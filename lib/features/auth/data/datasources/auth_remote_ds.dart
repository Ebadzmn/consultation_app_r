import '../models/user_model.dart';

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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
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
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate success
    return UserModel(
      id: '123',
      name: name,
      email: email,
      userType: userType,
    );
  }
}
