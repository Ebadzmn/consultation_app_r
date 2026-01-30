import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/experts_repository.dart';

class CreateProjectParams {
  final String name;
  final int year;
  final List<int> categoryIds;
  final List<int> memberIds;
  final List<String> keyResults;
  final String goals;
  final int? customerId;
  final String company;

  const CreateProjectParams({
    required this.name,
    required this.year,
    required this.categoryIds,
    required this.memberIds,
    required this.keyResults,
    required this.goals,
    required this.customerId,
    required this.company,
  });
}

class CreateProjectUseCase {
  final ExpertsRepository repository;

  CreateProjectUseCase(this.repository);

  Future<Either<Failure, void>> call(CreateProjectParams params) {
    return repository.createProject(
      name: params.name,
      year: params.year,
      categoryIds: params.categoryIds,
      memberIds: params.memberIds,
      keyResults: params.keyResults,
      goals: params.goals,
      customerId: params.customerId,
      company: params.company,
    );
  }
}

