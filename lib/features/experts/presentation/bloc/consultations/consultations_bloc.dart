import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../models/consultation_appointment.dart';
import 'consultations_event.dart';
import 'consultations_state.dart';

class ConsultationsBloc extends Bloc<ConsultationsEvent, ConsultationsState> {
  ConsultationsBloc({ConsultationsTab initialTab = ConsultationsTab.calendar})
    : super(
        ConsultationsState(
          tab: initialTab,
          focusedMonth: DateTime(DateTime.now().year, DateTime.now().month),
          selectedDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          appointments: _generateAppointmentsForMonth(
            DateTime(DateTime.now().year, DateTime.now().month),
          ),
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
    emit(state.copyWith(range: event.range));
  }

  void _onPreviousMonth(
    ConsultationsPreviousMonthPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final prev = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month - 1,
    );
    emit(
      state.copyWith(
        focusedMonth: prev,
        appointments: _generateAppointmentsForMonth(prev),
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
    emit(
      state.copyWith(
        focusedMonth: next,
        appointments: _generateAppointmentsForMonth(next),
      ),
    );
  }

  void _onDateSelected(
    ConsultationsDateSelected event,
    Emitter<ConsultationsState> emit,
  ) {
    final d = DateTime(event.date.year, event.date.month, event.date.day);
    emit(state.copyWith(selectedDate: d));
  }

  void _onPreviousWeek(
    ConsultationsPreviousWeekPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final newSelected = state.selectedDate.subtract(const Duration(days: 7));
    _emitWithUpdatedMonth(newSelected, emit);
  }

  void _onNextWeek(
    ConsultationsNextWeekPressed event,
    Emitter<ConsultationsState> emit,
  ) {
    final newSelected = state.selectedDate.add(const Duration(days: 7));
    _emitWithUpdatedMonth(newSelected, emit);
  }

  void _emitWithUpdatedMonth(
    DateTime newSelected,
    Emitter<ConsultationsState> emit,
  ) {
    final normalizedSelected = DateTime(
      newSelected.year,
      newSelected.month,
      newSelected.day,
    );
    final newMonth = DateTime(
      normalizedSelected.year,
      normalizedSelected.month,
    );
    final currentMonth = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month,
    );

    if (newMonth == currentMonth) {
      emit(state.copyWith(selectedDate: normalizedSelected));
      return;
    }

    emit(
      state.copyWith(
        selectedDate: normalizedSelected,
        focusedMonth: newMonth,
        appointments: _generateAppointmentsForMonth(newMonth),
      ),
    );
  }

  static List<ConsultationAppointment> _generateAppointmentsForMonth(
    DateTime month,
  ) {
    final base = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    final isExpertUser = di.currentUser.value?.userType == 'Expert';
    final people = isExpertUser
        ? [
            ('Client A', 'https://i.pravatar.cc/150?img=7'),
            ('Client B', 'https://i.pravatar.cc/150?img=8'),
            ('Client C', 'https://i.pravatar.cc/150?img=9'),
            ('Client D', 'https://i.pravatar.cc/150?img=10'),
          ]
        : [
            ('Александр Александров', 'https://i.pravatar.cc/150?img=12'),
            ('Мария Кожевникова', 'https://i.pravatar.cc/150?img=32'),
            ('Анна Петрова', 'https://i.pravatar.cc/150?img=44'),
            ('Иван Смирнов', 'https://i.pravatar.cc/150?img=18'),
          ];

    final appointments = <ConsultationAppointment>[];
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(base.year, base.month, day);
      if (day % 5 == 0) {
        final e = people[0];
        appointments.add(
          ConsultationAppointment(
            id: 'a-$day-1',
            expertName: e.$1,
            expertAvatarUrl: e.$2,
            dateTime: DateTime(date.year, date.month, date.day, 12, 0),
            status: ConsultationStatus.needToPay,
            hasUnreadMessages: day % 10 == 0,
          ),
        );
      }
      if (day % 7 == 0) {
        final e = people[1];
        appointments.add(
          ConsultationAppointment(
            id: 'a-$day-2',
            expertName: e.$1,
            expertAvatarUrl: e.$2,
            dateTime: DateTime(date.year, date.month, date.day, 15, 0),
            status: ConsultationStatus.paid,
            hasUnreadMessages: day % 14 == 0,
          ),
        );
      }
      if (day % 9 == 0) {
        final e = people[2];
        appointments.add(
          ConsultationAppointment(
            id: 'a-$day-3',
            expertName: e.$1,
            expertAvatarUrl: e.$2,
            dateTime: DateTime(date.year, date.month, date.day, 10, 0),
            status: ConsultationStatus.completed,
          ),
        );
      }
      if (day == 15) {
        final e = people[0];
        appointments.add(
          ConsultationAppointment(
            id: 'a-$day-fixed',
            expertName: e.$1,
            expertAvatarUrl: e.$2,
            dateTime: DateTime(date.year, date.month, date.day, 12, 0),
            status: ConsultationStatus.needToPay,
            hasUnreadMessages: true,
          ),
        );
      }
      if (day == 15) {
        final e = people[1];
        appointments.add(
          ConsultationAppointment(
            id: 'a-$day-fixed-2',
            expertName: e.$1,
            expertAvatarUrl: e.$2,
            dateTime: DateTime(date.year, date.month, date.day, 15, 0),
            status: ConsultationStatus.paid,
            hasUnreadMessages: true,
          ),
        );
      }
    }

    appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return appointments;
  }
}
