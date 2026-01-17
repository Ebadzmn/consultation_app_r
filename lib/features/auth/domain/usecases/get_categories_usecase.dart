import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/auth_repository.dart';

class GetCategoriesUseCase
    implements UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final AuthRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
    GetCategoriesParams params,
  ) async {
    return repository.getCategories(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetCategoriesParams extends Equatable {
  final int page;
  final int pageSize;

  const GetCategoriesParams({this.page = 1, this.pageSize = 10});

  @override
  List<Object?> get props => [page, pageSize];
}

