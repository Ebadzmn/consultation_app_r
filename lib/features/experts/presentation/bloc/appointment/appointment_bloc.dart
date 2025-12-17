import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  static const List<String> _baseTimeSlots = ['09:00', '11:00', '12:00', '15:00'];

  AppointmentBloc({DateTime? initialDate})
      : super(
          _initialState(initialDate ?? DateTime.now()),
        ) {
    on<AppointmentDateChanged>(_onDateChanged);
    on<AppointmentTimeChanged>(_onTimeChanged);
    on<AppointmentCategoryChanged>(_onCategoryChanged);
    on<AppointmentCommentChanged>(_onCommentChanged);
    on<AppointmentSubmitted>(_onSubmitted);
    on<AppointmentSlotWarningDismissed>(_onSlotWarningDismissed);
  }

  static AppointmentState _initialState(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return AppointmentState(
      selectedDate: normalized,
      timeSlots: _baseTimeSlots,
      unavailableTimes: _unavailableTimesForDate(normalized),
    );
  }

  static Set<String> _unavailableTimesForDate(DateTime date) {
    final day = date.day;
    if (day % 2 == 0) {
      return {'11:00', '15:00'};
    }
    if (day % 3 == 0) {
      return {'09:00', '12:00'};
    }
    return {'12:00'};
  }

  void _onDateChanged(
    AppointmentDateChanged event,
    Emitter<AppointmentState> emit,
  ) {
    final normalized = DateTime(event.date.year, event.date.month, event.date.day);
    final unavailableTimes = _unavailableTimesForDate(normalized);
    final selectedTime = state.selectedTime;
    final clearedSelectedTime =
        selectedTime != null && unavailableTimes.contains(selectedTime)
            ? null
            : selectedTime;

    emit(
      state.copyWith(
        selectedDate: normalized,
        selectedTime: clearedSelectedTime,
        unavailableTimes: unavailableTimes,
        showSlotWarning: false,
        status: AppointmentStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onTimeChanged(
    AppointmentTimeChanged event,
    Emitter<AppointmentState> emit,
  ) {
    if (state.unavailableTimes.contains(event.time)) {
      emit(
        state.copyWith(
          showSlotWarning: true,
          status: AppointmentStatus.initial,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedTime: event.time,
        showSlotWarning: false,
        status: AppointmentStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onCategoryChanged(
    AppointmentCategoryChanged event,
    Emitter<AppointmentState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategory: event.category,
        showSlotWarning: false,
        status: AppointmentStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onCommentChanged(
    AppointmentCommentChanged event,
    Emitter<AppointmentState> emit,
  ) {
    emit(
      state.copyWith(
        comment: event.comment,
        showSlotWarning: false,
        status: AppointmentStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    AppointmentSubmitted event,
    Emitter<AppointmentState> emit,
  ) async {
    if (state.selectedTime == null) {
      emit(state.copyWith(showSlotWarning: true));
      return;
    }
    emit(state.copyWith(status: AppointmentStatus.submitting, errorMessage: null));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(status: AppointmentStatus.success));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(
      state.copyWith(
        status: AppointmentStatus.initial,
      ),
    );
  }

  void _onSlotWarningDismissed(
    AppointmentSlotWarningDismissed event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(showSlotWarning: false));
  }
}
