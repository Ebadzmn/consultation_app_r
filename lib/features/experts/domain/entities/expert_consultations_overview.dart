import 'package:equatable/equatable.dart';
import '../../presentation/models/consultation_appointment.dart';

class ExpertWorkingSlot extends Equatable {
  final DateTime start;
  final DateTime end;
  final String title;

  const ExpertWorkingSlot({
    required this.start,
    required this.end,
    required this.title,
  });

  @override
  List<Object?> get props => [start, end, title];
}

class ExpertConsultationsOverview extends Equatable {
  final List<ConsultationAppointment> appointments;
  final List<ExpertWorkingSlot> workingSlots;

  const ExpertConsultationsOverview({
    required this.appointments,
    required this.workingSlots,
  });

  @override
  List<Object?> get props => [appointments, workingSlots];
}

