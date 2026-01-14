import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/available_work_dates_entity.dart';
import '../repositories/experts_repository.dart';

class GetAvailableWorkDatesUseCase
    implements UseCase<AvailableWorkDatesEntity, String> {
  final ExpertsRepository repository;

  GetAvailableWorkDatesUseCase(this.repository);

  @override
  Future<Either<Failure, AvailableWorkDatesEntity>> call(
    String expertId,
  ) async {
    return await repository.getAvailableWorkDates(expertId);
  }
}
