import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../presentation/models/consultation_appointment.dart';
import '../repositories/experts_repository.dart';

class GetClientAppointmentsUseCase
    implements UseCase<List<ConsultationAppointment>, ClientAppointmentsParams> {
  final ExpertsRepository repository;

  GetClientAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ConsultationAppointment>>> call(
    ClientAppointmentsParams params,
  ) async {
    return repository.getClientAppointments(
      start: params.start,
      end: params.end,
    );
  }
}

class ClientAppointmentsParams extends Equatable {
  final DateTime start;
  final DateTime end;

  const ClientAppointmentsParams({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}

