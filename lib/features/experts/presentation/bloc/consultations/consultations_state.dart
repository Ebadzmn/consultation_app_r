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

  const ConsultationsState({
    this.tab = ConsultationsTab.calendar,
    this.range = ConsultationsRange.month,
    required this.focusedMonth,
    required this.selectedDate,
    this.appointments = const [],
  });

  ConsultationsState copyWith({
    ConsultationsTab? tab,
    ConsultationsRange? range,
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<ConsultationAppointment>? appointments,
  }) {
    return ConsultationsState(
      tab: tab ?? this.tab,
      range: range ?? this.range,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
    );
  }

  @override
  List<Object?> get props => [tab, range, focusedMonth, selectedDate, appointments];
}

