import 'package:equatable/equatable.dart';
import '../../../../auth/domain/entities/category_entity.dart';

enum AppointmentStatus {
  initial,
  loadingAvailability,
  loadingTimeSlots,
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
  final List<CategoryEntity> categories;

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
    this.categories = const [],
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
    List<CategoryEntity>? categories,
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
      categories: categories ?? this.categories,
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
    categories,
  ];
}
