import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expert_entity.dart';
import '../repositories/experts_repository.dart';

class GetExpertsUseCase {
  final ExpertsRepository repository;

  GetExpertsUseCase(this.repository);

  Future<Either<Failure, List<ExpertEntity>>> call() async {
    return await repository.getExperts();
  }
}
