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
      surname: params.surname,
      email: params.email,
      password: params.password,
      userType: params.userType,
      phoneNumber: params.phoneNumber,
      aboutMyself: params.aboutMyself,
      experience: params.experience,
      cost: params.cost,
      categoriesOfExpertise: params.categoriesOfExpertise,
    );
  }
}

class SignUpParams {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String userType;
  final String phoneNumber;
  final String? aboutMyself;
  final String? experience;
  final String? cost;
  final List<String> categoriesOfExpertise;

  SignUpParams({
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.userType,
    this.aboutMyself,
    this.experience,
    this.cost,
    this.categoriesOfExpertise = const [],
  });
}
