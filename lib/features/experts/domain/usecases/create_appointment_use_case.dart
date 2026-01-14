import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/experts_repository.dart';

class CreateAppointmentUseCase {
  final ExpertsRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<Either<Failure, void>> call(CreateAppointmentParams params) async {
    return repository.createAppointment(
      expertId: params.expertId,
      appointmentDate: params.appointmentDate,
      appointmentTime: params.appointmentTime,
      categoryId: params.categoryId,
      notes: params.notes,
    );
  }
}

class CreateAppointmentParams extends Equatable {
  final String expertId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final int categoryId;
  final String notes;

  const CreateAppointmentParams({
    required this.expertId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.categoryId,
    required this.notes,
  });

  @override
  List<Object?> get props => [
        expertId,
        appointmentDate,
        appointmentTime,
        categoryId,
        notes,
      ];
}

