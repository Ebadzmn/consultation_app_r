import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';
import '../../../../core/network/token_storage.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, UserEntity>> signUp({
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
    try {
      final userModel = await remoteDataSource.signUp(
        name: name,
        surname: surname,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        userType: userType,
        aboutMyself: aboutMyself,
        experience: experience,
        cost: cost,
        categoriesOfExpertise: categoriesOfExpertise,
      );
      return Right(userModel);
    } catch (e) {
      return const Left(ServerFailure('Sign up failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final responseBody = await remoteDataSource.signIn(
        username: username,
        password: password,
      );

      // Extract token from response. Assuming common format like data.token or data.access
      // Based on typical JWT setups. If format is different, user will provide feedback.
      final String? token =
          responseBody['access'] ??
          responseBody['data']?['token'] ??
          responseBody['data']?['access'] ??
          responseBody['token'];

      if (token != null) {
        await tokenStorage.saveToken(token);
      }

      // Construct a minimal user model from the response if available,
      // or at least return a success state.
      final userData = responseBody['data'] ?? {};
      final user = UserModel(
        id: (userData['user_id'] ?? userData['id'] ?? '0').toString(),
        name: userData['first_name'] ?? username, // Fallback to username
        email: userData['email'] ?? username,
        userType: (userData['user_type'] ?? 'Client').toString(),
      );

      await tokenStorage.saveUser(user);

      return Right(user);
    } catch (e) {
      return const Left(
        ServerFailure('Login failed. Please check your credentials.'),
      );
    }
  }

  @override
  Future<String?> getToken() async {
    return tokenStorage.getToken();
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenStorage.clearAuth();
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> tryAutoLogin() async {
    try {
      final token = tokenStorage.getToken();
      final user = tokenStorage.getUser();

      if (token != null && user != null) {
        return Right(user);
      }
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Auto login failed'));
    }
  }

  @override
  Future<void> persistUser(UserEntity user) async {
    if (user is UserModel) {
      await tokenStorage.saveUser(user);
    }
  }
}
