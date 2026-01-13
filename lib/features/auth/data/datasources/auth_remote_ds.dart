import 'package:consultant_app/core/network/dio_client.dart';
import 'package:consultant_app/core/network/api_client.dart';
import '../models/user_model.dart';
import '../models/expert_register_request.dart';
import '../models/client_register_request.dart';
import '../models/login_request.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String surname,
    required String email,
    required String phoneNumber,
    required String password,
    required String userType,
    String? aboutMyself,
    String? experience,
    String? cost,
    List<String>? categoriesOfExpertise,
  });

  Future<Map<String, dynamic>> signIn({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> signUp({
    required String name,
    required String surname,
    required String email,
    required String phoneNumber,
    required String password,
    required String userType,
    String? aboutMyself,
    String? experience,
    String? cost,
    List<String>? categoriesOfExpertise,
  }) async {
    final bool isExpert = userType.toLowerCase() == 'expert';
    final int mappedUserType = isExpert ? 1 : 0;

    final Map<String, dynamic> requestBody;

    if (isExpert) {
      requestBody = ExpertRegisterRequest(
        firstName: name,
        lastName: surname,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        userType: mappedUserType,
        hourCost: int.tryParse(cost ?? '0') ?? 0,
        experience: int.tryParse(experience ?? '0') ?? 0,
        expertCategories:
            categoriesOfExpertise?.map((e) => int.tryParse(e) ?? 0).toList() ??
            [],
      ).toJson();
    } else {
      requestBody = ClientRegisterRequest(
        firstName: name,
        lastName: surname,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        userType: mappedUserType,
      ).toJson();
    }

    final response = await _dioClient.post(
      ApiClient.register,
      data: requestBody,
    );

    // The API response comes in a wrapped format:
    // { "status": "success", "message": "...", "data": { "user_id": 174, "user_type": 1 } }

    final responseData = response.data['data'];

    return UserModel(
      id: responseData['user_id'].toString(),
      name: name,
      email: email,
      userType: userType,
    );
  }

  @override
  Future<Map<String, dynamic>> signIn({
    required String username,
    required String password,
  }) async {
    final request = LoginRequest(username: username, password: password);

    final response = await _dioClient.post(
      ApiClient.login,
      data: request.toJson(),
    );

    // Assuming the response contains access token in data or top level
    // format might be { "status": "success", "data": { "access": "...", "refresh": "..." } }
    return response.data;
  }
}
