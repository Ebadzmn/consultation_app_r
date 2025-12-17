import 'package:equatable/equatable.dart';

enum AppointmentStatus { initial, submitting, success, failure }

class AppointmentState extends Equatable {
  final DateTime selectedDate;
  final String? selectedTime;
  final String? selectedCategory;
  final String comment;
  final AppointmentStatus status;
  final String? errorMessage;
  final List<String> timeSlots;
  final Set<String> unavailableTimes;
  final bool showSlotWarning;

  const AppointmentState({
    required this.selectedDate,
    this.selectedTime,
    this.selectedCategory,
    this.comment = '',
    this.status = AppointmentStatus.initial,
    this.errorMessage,
    this.timeSlots = const [],
    this.unavailableTimes = const {},
    this.showSlotWarning = false,
  });

  AppointmentState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    String? selectedCategory,
    String? comment,
    AppointmentStatus? status,
    String? errorMessage,
    List<String>? timeSlots,
    Set<String>? unavailableTimes,
    bool? showSlotWarning,
  }) {
    return AppointmentState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      errorMessage: errorMessage,
      timeSlots: timeSlots ?? this.timeSlots,
      unavailableTimes: unavailableTimes ?? this.unavailableTimes,
      showSlotWarning: showSlotWarning ?? this.showSlotWarning,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        selectedTime,
        selectedCategory,
        comment,
        status,
        errorMessage,
        timeSlots,
        unavailableTimes,
        showSlotWarning,
      ];
}
