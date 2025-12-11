import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    return await repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
      userType: params.userType,
      phoneNumber: params.phoneNumber,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String userType;
  final String? phoneNumber;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    this.phoneNumber,
  });
}
