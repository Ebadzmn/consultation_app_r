import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class AppointmentDateChanged extends AppointmentEvent {
  final DateTime date;

  const AppointmentDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class AppointmentTimeChanged extends AppointmentEvent {
  final String time;

  const AppointmentTimeChanged(this.time);

  @override
  List<Object?> get props => [time];
}

class AppointmentCategoryChanged extends AppointmentEvent {
  final String category;

  const AppointmentCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class AppointmentCommentChanged extends AppointmentEvent {
  final String comment;

  const AppointmentCommentChanged(this.comment);

  @override
  List<Object?> get props => [comment];
}

class AppointmentSubmitted extends AppointmentEvent {}

class AppointmentSlotWarningDismissed extends AppointmentEvent {}

class LoadAvailableWorkDates extends AppointmentEvent {
  final String expertId;

  const LoadAvailableWorkDates(this.expertId);

  @override
  List<Object?> get props => [expertId];
}
