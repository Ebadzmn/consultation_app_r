import 'package:flutter_bloc/flutter_bloc.dart';
import 'consultations_event.dart';
import 'consultations_state.dart';
import '../../../domain/usecases/get_client_appointments_use_case.dart';
import '../../../domain/usecases/get_expert_appointments_use_case.dart';

class ConsultationsBloc extends Bloc<ConsultationsEvent, ConsultationsState> {
  final GetClientAppointmentsUseCase getClientAppointments;
  final GetExpertAppointmentsUseCase getExpertAppointments;
  final bool isExpert;
  final Map<DateTime, List<String>> _expertWorkingSlotsByDate = {};

  ConsultationsBloc({
    required this.getClientAppointments,
    required this.getExpertAppointments,
    required this.isExpert,
    ConsultationsTab initialTab = ConsultationsTab.calendar,
  }) : super(
          ConsultationsState(
            tab: initialTab,
            focusedMonth: DateTime(DateTime.now().year, DateTime.now().month),
            selectedDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            appointments: const [],
          ),
        ) {
    on<ConsultationsTabChanged>(_onTabChanged);
    on<ConsultationsRangeChanged>(_onRangeChanged);
    on<ConsultationsPreviousMonthPressed>(_onPreviousMonth);
    on<ConsultationsNextMonthPressed>(_onNextMonth);
    on<ConsultationsDateSelected>(_onDateSelected);
    on<ConsultationsPreviousWeekPressed>(_onPreviousWeek);
    on<ConsultationsNextWeekPressed>(_onNextWeek);
    on<WorkingHoursUpdated>(_onWorkingHoursUpdated);
    on<ConsultationsAppointmentsRequested>(_onAppointmentsRequested);
  }

  void _onWorkingHoursUpdated(
    WorkingHoursUpdated event,
    Emitter<ConsultationsState> emit,
  ) {
    emit(
      state.copyWith(
        offHours: event.offHours,
        workingHours: event.workingHours,
      ),
    );
  }

  void _onTabChanged(
    ConsultationsTabChanged event,
    Emitter<ConsultationsState> emit,
  ) {
    emit(state.copyWith(tab: event.tab));
  }

  void _onRangeChanged(
    ConsultationsRangeChanged event,
    Emitter<ConsultationsState> emit,
  ) {
    if (event.range == ConsultationsRange.week) {
      final today = DateTime.now();
      final normalizedToday = DateTime(
        today.year,
        today.month,
        today.day,
      );
      final thisWeekStart = normalizedToday.subtract(
        Duration(days: normalizedToday.weekday - 1),
      );
      final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
      final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
      final weekStartDateTime = DateTime(
        lastWeekStart.year,
        lastWeekStart.month,
        lastWeekStart.day,
        0,
        0,
        0,
      );
      final weekEndDateTime = DateTime(
        lastWeekEnd.year,
        lastWeekEnd.month,
        lastWeekEnd.day,
        23,
        59,
        59,
      );

      emit(
        state.copyWith(
          range: event.range,
          selectedDate: lastWeekStart,
          focusedMonth: DateTime(
            lastWeekStart.year,
            lastWeekStart.month,
          ),
        ),
      );

      add(
        ConsultationsAppointmentsRequested(
          start: weekStartDateTime,
          end: weekEndDateTime,
        ),
      );
    } else if (event.range == ConsultationsRange.month) {
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month);
      final today = DateTime(now.year, now.month, now.day);

      emit(
        state.copyWith(
          range: event.range,
          focusedMonth: thisMonth,
          selectedDate: today,
        ),
      );

      add(
        ConsultationsAppointmentsRequested(
          start: _monthStartFor(thisMonth),
          end: _monthEndFor(thisMonth),
        ),
      );
    } else if (event.range == ConsultationsRange.day) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dayStart = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      emit(
        state.copyWith(
          range: event.range,
          focusedMonth: DateTime(today.year, today.month),
          selectedDate: today,
        ),
      );

      add(
        ConsultationsAppointmentsRequested(
          start: dayStart,
          end: dayEnd,
        ),
      );
    } else {
      emit(state.copyWith(range: event.range));
    }
  }

  void _onPreviousMonth(
    ConsultationsPreviousMonthPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final prev = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month - 1,
    );
    emit(state.copyWith(focusedMonth: prev));
    add(
      ConsultationsAppointmentsRequested(
        start: _monthStartFor(prev),
        end: _monthEndFor(prev),
      ),
    );
  }

  void _onNextMonth(
    ConsultationsNextMonthPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final next = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month + 1,
    );
    emit(state.copyWith(focusedMonth: next));
    add(
      ConsultationsAppointmentsRequested(
        start: _monthStartFor(next),
        end: _monthEndFor(next),
      ),
    );
  }

  void _onDateSelected(
    ConsultationsDateSelected event,
    Emitter<ConsultationsState> emit,
  ) {
    final d = DateTime(event.date.year, event.date.month, event.date.day);
    List<String>? workingHours;
    if (isExpert) {
      final key = DateTime(d.year, d.month, d.day);
      workingHours = _expertWorkingSlotsByDate[key] ?? const [];
    }
    emit(
      state.copyWith(
        selectedDate: d,
        workingHours: workingHours,
      ),
    );
  }

  void _onPreviousWeek(
    ConsultationsPreviousWeekPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final newSelected = state.selectedDate.subtract(const Duration(days: 7));
    _emitWithUpdatedWeek(newSelected, emit);
  }

  void _onNextWeek(
    ConsultationsNextWeekPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final newSelected = state.selectedDate.add(const Duration(days: 7));
    _emitWithUpdatedWeek(newSelected, emit);
  }

  void _emitWithUpdatedWeek(
    DateTime newSelected,
    Emitter<ConsultationsState> emit,
  ) {
    final normalizedSelected = DateTime(
      newSelected.year,
      newSelected.month,
      newSelected.day,
    );
    final weekStart = normalizedSelected.subtract(
      Duration(days: normalizedSelected.weekday - 1),
    );
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekStartDateTime = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
      0,
      0,
      0,
    );
    final weekEndDateTime = DateTime(
      weekEnd.year,
      weekEnd.month,
      weekEnd.day,
      23,
      59,
      59,
    );

    emit(
      state.copyWith(
        selectedDate: normalizedSelected,
        focusedMonth: DateTime(
          normalizedSelected.year,
          normalizedSelected.month,
        ),
      ),
    );

    add(
      ConsultationsAppointmentsRequested(
        start: weekStartDateTime,
        end: weekEndDateTime,
      ),
    );
  }

  Future<void> _onAppointmentsRequested(
    ConsultationsAppointmentsRequested event,
    Emitter<ConsultationsState> emit,
  ) async {
    if (isExpert) {
      final result = await getExpertAppointments(
        ClientAppointmentsParams(start: event.start, end: event.end),
      );

      result.fold(
        (_) {},
        (overview) {
          _expertWorkingSlotsByDate.clear();
          for (final slot in overview.workingSlots) {
            final key = DateTime(
              slot.start.year,
              slot.start.month,
              slot.start.day,
            );
            final value =
                '${slot.start.hour.toString().padLeft(2, '0')}:'
                '${slot.start.minute.toString().padLeft(2, '0')} - '
                '${slot.end.hour.toString().padLeft(2, '0')}:'
                '${slot.end.minute.toString().padLeft(2, '0')}';
            final existing = _expertWorkingSlotsByDate[key];
            if (existing == null) {
              _expertWorkingSlotsByDate[key] = [value];
            } else {
              existing.add(value);
            }
          }

          final selected = DateTime(
            state.selectedDate.year,
            state.selectedDate.month,
            state.selectedDate.day,
          );
          final workingHoursStrings =
              _expertWorkingSlotsByDate[selected] ?? const [];

          emit(
            state.copyWith(
              appointments: overview.appointments,
              offHours: const [],
              workingHours: workingHoursStrings,
            ),
          );
        },
      );
    } else {
      final result = await getClientAppointments(
        ClientAppointmentsParams(start: event.start, end: event.end),
      );

      result.fold(
        (_) {},
        (appointments) {
          emit(
            state.copyWith(
              appointments: appointments,
            ),
          );
        },
      );
    }
  }

  static DateTime _monthStartFor(DateTime month) {
    return DateTime(month.year, month.month, 1, 0, 0, 0);
  }

  static DateTime _monthEndFor(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
  }
}
