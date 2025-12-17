import 'package:equatable/equatable.dart';
import 'consultations_state.dart';

abstract class ConsultationsEvent extends Equatable {
  const ConsultationsEvent();

  @override
  List<Object?> get props => [];
}

class ConsultationsTabChanged extends ConsultationsEvent {
  final ConsultationsTab tab;

  const ConsultationsTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ConsultationsRangeChanged extends ConsultationsEvent {
  final ConsultationsRange range;

  const ConsultationsRangeChanged(this.range);

  @override
  List<Object?> get props => [range];
}

class ConsultationsPreviousMonthPressed extends ConsultationsEvent {}

class ConsultationsNextMonthPressed extends ConsultationsEvent {}

class ConsultationsDateSelected extends ConsultationsEvent {
  final DateTime date;

  const ConsultationsDateSelected(this.date);

  @override
  List<Object?> get props => [date];
}

