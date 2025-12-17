import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

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
}
