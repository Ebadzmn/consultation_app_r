import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expert_entity.dart';
import '../entities/available_work_dates_entity.dart';

abstract class ExpertsRepository {
  Future<Either<Failure, List<ExpertEntity>>> getExperts();
  Future<Either<Failure, AvailableWorkDatesEntity>> getAvailableWorkDates(
    String expertId,
  );
  Future<Either<Failure, List<String>>> getAvailableTimeSlots({
    required String expertId,
    required DateTime selectedDate,
  });
  Future<Either<Failure, void>> createAppointment({
    required String expertId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int categoryId,
    required String notes,
  });
}
