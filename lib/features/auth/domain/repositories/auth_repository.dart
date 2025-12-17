import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
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
  });
}
