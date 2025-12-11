import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
    String? phoneNumber,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
    String? phoneNumber,
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
