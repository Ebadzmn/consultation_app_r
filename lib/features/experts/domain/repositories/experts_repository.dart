import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expert_entity.dart';

abstract class ExpertsRepository {
  Future<Either<Failure, List<ExpertEntity>>> getExperts();
}
