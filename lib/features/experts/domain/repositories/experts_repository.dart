import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expert_entity.dart';
import '../entities/available_work_dates_entity.dart';
import '../entities/expert_profile.dart';
import '../entities/expert_consultations_overview.dart';
import '../../presentation/models/consultation_appointment.dart';

abstract class ExpertsRepository {
  Future<Either<Failure, List<ExpertEntity>>> getExperts();
  Future<Either<Failure, ExpertProfile>> getExpertProfile(String expertId);
  Future<Either<Failure, ExpertProfile>> getCurrentUserProfile();
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
  Future<Either<Failure, List<ConsultationAppointment>>> getClientAppointments({
    required DateTime start,
    required DateTime end,
  });
  Future<Either<Failure, ExpertConsultationsOverview>> getExpertAppointments({
    required DateTime start,
    required DateTime end,
  });
}
