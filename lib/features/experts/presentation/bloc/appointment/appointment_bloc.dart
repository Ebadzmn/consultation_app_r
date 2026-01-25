import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

import '../../../domain/usecases/get_available_work_dates_use_case.dart';
import '../../../domain/usecases/get_available_time_slots_use_case.dart';
import '../../../domain/usecases/create_appointment_use_case.dart';
import '../../../../auth/domain/usecases/get_categories_usecase.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final String expertId;
  final GetAvailableWorkDatesUseCase? getAvailableWorkDatesUseCase;
  final GetAvailableTimeSlotsUseCase? getAvailableTimeSlotsUseCase;
  final CreateAppointmentUseCase? createAppointmentUseCase;
  final GetCategoriesUseCase? getCategoriesUseCase;

  AppointmentBloc({
    required this.expertId,
    DateTime? initialDate,
    this.getAvailableWorkDatesUseCase,
    this.getAvailableTimeSlotsUseCase,
    this.createAppointmentUseCase,
    this.getCategoriesUseCase,
  }) : super(_initialState(initialDate ?? DateTime.now())) {
    on<AppointmentDateChanged>(_onDateChanged);
    on<AppointmentTimeChanged>(_onTimeChanged);
    on<AppointmentCategoryChanged>(_onCategoryChanged);
    on<AppointmentCommentChanged>(_onCommentChanged);
    on<AppointmentSubmitted>(_onSubmitted);
    on<AppointmentSlotWarningDismissed>(_onSlotWarningDismissed);
    on<LoadAvailableWorkDates>(_onLoadAvailableWorkDates);
    on<AppointmentCategoriesRequested>(_onCategoriesRequested);
  }

  static AppointmentState _initialState(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return AppointmentState(
      selectedDate: normalized,
      timeSlots: const [],
      unavailableTimes: const {},
    );
  }

  Future<void> _onDateChanged(
    AppointmentDateChanged event,
    Emitter<AppointmentState> emit,
  ) async {
    final normalized = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
    );

    emit(
      state.copyWith(
        selectedDate: normalized,
        selectedTime: null,
        unavailableTimes: const {},
        timeSlots: const [],
        showSlotWarning: false,
        status: AppointmentStatus.loadingAvailability,
        errorMessage: null,
      ),
    );

    if (getAvailableTimeSlotsUseCase == null) {
      emit(
        state.copyWith(
          status: AppointmentStatus.initial,
        ),
      );
      return;
    }

    final result = await getAvailableTimeSlotsUseCase!(
      GetAvailableTimeSlotsParams(
        expertId: expertId,
        selectedDate: normalized,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AppointmentStatus.failure,
            errorMessage: 'Failed to load available times',
          ),
        );
      },
      (slots) {
        emit(
          state.copyWith(
            status: AppointmentStatus.initial,
            timeSlots: slots,
            unavailableTimes: const {},
          ),
        );
      },
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
    if (createAppointmentUseCase == null) {
      emit(
        state.copyWith(
          status: AppointmentStatus.failure,
          errorMessage: 'Appointment creation is not configured',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: AppointmentStatus.submitting, errorMessage: null),
    );

    final categoryId = _mapCategoryToId(state.selectedCategory);

    final result = await createAppointmentUseCase!(
      CreateAppointmentParams(
        expertId: expertId,
        appointmentDate: state.selectedDate,
        appointmentTime: state.selectedTime!,
        categoryId: categoryId,
        notes: state.comment,
      ),
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(
          state.copyWith(
            status: AppointmentStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) async {
        if (emit.isDone) return;
        emit(state.copyWith(status: AppointmentStatus.success));
        await Future.delayed(const Duration(milliseconds: 300));
        if (emit.isDone) return;
        emit(state.copyWith(status: AppointmentStatus.initial));
      },
    );
  }

  void _onSlotWarningDismissed(
    AppointmentSlotWarningDismissed event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(showSlotWarning: false));
  }

  Future<void> _onLoadAvailableWorkDates(
    LoadAvailableWorkDates event,
    Emitter<AppointmentState> emit,
  ) async {
    if (getAvailableWorkDatesUseCase == null) return;

    emit(state.copyWith(status: AppointmentStatus.loadingAvailability));

    final result = await getAvailableWorkDatesUseCase!(event.expertId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AppointmentStatus.failure,
            errorMessage: 'Failed to load availability',
          ),
        );
      },
      (availability) {
        emit(
          state.copyWith(
            status: AppointmentStatus.initial,
            notWorkingDates: availability.notWorkingDates,
            availabilityStart: availability.start,
            availabilityEnd: availability.end,
          ),
        );
      },
    );
  }

  Future<void> _onCategoriesRequested(
    AppointmentCategoriesRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    if (getCategoriesUseCase == null) return;

    final result = await getCategoriesUseCase!(
      const GetCategoriesParams(page: 1, pageSize: 50),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            errorMessage: failure.message,
          ),
        );
      },
      (categories) {
        emit(
          state.copyWith(
            categories: categories,
          ),
        );
      },
    );
  }

  int _mapCategoryToId(String? category) {
    if (category == null) {
      if (state.categories.isNotEmpty) {
        return state.categories.first.id;
      }
      return 1;
    }

    for (final c in state.categories) {
      if (c.name == category) {
        return c.id;
      }
    }

    return 1;
  }
}
