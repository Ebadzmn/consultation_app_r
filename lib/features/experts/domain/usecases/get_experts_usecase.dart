import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/expert_entity.dart';
import '../repositories/experts_repository.dart';

class GetExpertsParams extends Equatable {
  final int page;
  final int pageSize;
  final double? minRating;
  final List<int>? categoryIds;
  final String? sortBy;
  final String? search;

  const GetExpertsParams({
    this.page = 1,
    this.pageSize = 10,
    this.minRating,
    this.categoryIds,
    this.sortBy,
    this.search,
  });

  @override
  List<Object?> get props => [
        page,
        pageSize,
        minRating,
        categoryIds,
        sortBy,
        search,
      ];
}

class GetExpertsUseCase {
  final ExpertsRepository repository;

  GetExpertsUseCase(this.repository);

  Future<Either<Failure, List<ExpertEntity>>> call(
    GetExpertsParams params,
  ) async {
    return repository.getExperts(
      page: params.page,
      pageSize: params.pageSize,
      minRating: params.minRating,
      categoryIds: params.categoryIds,
      sortBy: params.sortBy,
      search: params.search,
    );
  }
}
