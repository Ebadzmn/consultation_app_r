import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    return await repository.signIn(
      username: params.username,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String username;
  final String password;

  const SignInParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
