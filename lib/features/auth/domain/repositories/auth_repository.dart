import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../entities/category_entity.dart';

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

  Future<Either<Failure, UserEntity>> signIn({
    required String username,
    required String password,
  });

  Future<String?> getToken();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity?>> tryAutoLogin();

  Future<void> persistUser(UserEntity user);

  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    int page,
    int pageSize,
  });

  Future<Either<Failure, UserEntity>> getProfile();
}
