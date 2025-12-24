import 'package:equatable/equatable.dart';
import '../../models/consultation_appointment.dart';

enum ConsultationsTab { calendar, list }

enum ConsultationsRange { month, week, day }

class ConsultationsState extends Equatable {
  final ConsultationsTab tab;
  final ConsultationsRange range;
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<ConsultationAppointment> appointments;
  final List<String> offHours;
  final List<String> workingHours;

  const ConsultationsState({
    this.tab = ConsultationsTab.calendar,
    this.range = ConsultationsRange.month,
    required this.focusedMonth,
    required this.selectedDate,
    this.appointments = const [],
    this.offHours = const ['09:00 - 11:00'],
    this.workingHours = const ['18:00 - 22:00'],
  });

  ConsultationsState copyWith({
    ConsultationsTab? tab,
    ConsultationsRange? range,
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<ConsultationAppointment>? appointments,
    List<String>? offHours,
    List<String>? workingHours,
  }) {
    return ConsultationsState(
      tab: tab ?? this.tab,
      range: range ?? this.range,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      offHours: offHours ?? this.offHours,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  @override
  List<Object?> get props => [
        tab,
        range,
        focusedMonth,
        selectedDate,
        appointments,
        offHours,
        workingHours,
      ];
}

