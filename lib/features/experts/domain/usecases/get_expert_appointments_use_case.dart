import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expert_consultations_overview.dart';
import '../repositories/experts_repository.dart';
import 'get_client_appointments_use_case.dart';

class GetExpertAppointmentsUseCase
    implements
        UseCase<ExpertConsultationsOverview, ClientAppointmentsParams> {
  final ExpertsRepository repository;

  GetExpertAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, ExpertConsultationsOverview>> call(
    ClientAppointmentsParams params,
  ) async {
    return repository.getExpertAppointments(
      start: params.start,
      end: params.end,
    );
  }
}
