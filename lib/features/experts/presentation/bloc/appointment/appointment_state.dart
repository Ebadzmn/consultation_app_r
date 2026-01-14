import 'package:equatable/equatable.dart';

enum AppointmentStatus {
  initial,
  loadingAvailability,
  submitting,
  success,
  failure,
}

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
  final List<DateTime> notWorkingDates;
  final DateTime? availabilityStart;
  final DateTime? availabilityEnd;

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
    this.notWorkingDates = const [],
    this.availabilityStart,
    this.availabilityEnd,
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
    List<DateTime>? notWorkingDates,
    DateTime? availabilityStart,
    DateTime? availabilityEnd,
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
      notWorkingDates: notWorkingDates ?? this.notWorkingDates,
      availabilityStart: availabilityStart ?? this.availabilityStart,
      availabilityEnd: availabilityEnd ?? this.availabilityEnd,
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
    unavailableTimes,
    showSlotWarning,
    notWorkingDates,
    availabilityStart,
    availabilityEnd,
  ];
}
