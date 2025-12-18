import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../bloc/consultations/consultations_bloc.dart';
import '../bloc/consultations/consultations_event.dart';
import '../bloc/consultations/consultations_state.dart';
import '../models/consultation_appointment.dart';
import '../widgets/consultations_calendar.dart';
import '../widgets/weekly_scheduler_components.dart';
import '../widgets/appointment_cancellation_sheet.dart';

class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConsultationsBloc(),
      child: const _ConsultationsContent(),
    );
  }
}

class _ConsultationsContent extends StatefulWidget {
  const _ConsultationsContent();

  @override
  State<_ConsultationsContent> createState() => _ConsultationsContentState();
}

class _ConsultationsContentState extends State<_ConsultationsContent> {
  ConsultationAppointment? _selectedWeeklyAppointment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E3E),
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.consultations,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ConsultationsBloc, ConsultationsState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      children: [
                        _TabSwitcher(
                          selected: state.tab,
                          onChanged: (tab) => context
                              .read<ConsultationsBloc>()
                              .add(ConsultationsTabChanged(tab)),
                        ),
                        const SizedBox(height: 12),
                        _RangeSwitcher(
                          selected: state.range,
                          onChanged: (range) => context
                              .read<ConsultationsBloc>()
                              .add(ConsultationsRangeChanged(range)),
                        ),
                        const SizedBox(height: 16),
                        const _StatusLegend(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (state.tab == ConsultationsTab.calendar &&
                    state.range == ConsultationsRange.week) ...[
                  SliverToBoxAdapter(
                    child: WeeklyCalendarView(
                      appointments: state.appointments,
                      selectedDate: state.selectedDate,
                      onPreviousWeek: () => context
                          .read<ConsultationsBloc>()
                          .add(ConsultationsPreviousWeekPressed()),
                      onNextWeek: () => context.read<ConsultationsBloc>().add(
                        ConsultationsNextWeekPressed(),
                      ),
                      onAppointmentTap: (appointment) {
                        context.read<ConsultationsBloc>().add(
                          ConsultationsDateSelected(appointment.dateTime),
                        );
                        setState(() {
                          _selectedWeeklyAppointment = appointment;
                        });
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: _AppointmentsSection(
                        title: DateFormat('MMMM d').format(state.selectedDate),
                        appointments: _selectedWeeklyAppointment != null
                            ? [_selectedWeeklyAppointment!]
                            : _filterAppointmentsForRange(
                                appointments: state.appointments,
                                selectedDate: state.selectedDate,
                                range: ConsultationsRange.day,
                              ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ] else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (state.tab == ConsultationsTab.calendar) ...[
                          if (state.range == ConsultationsRange.month)
                            ConsultationsCalendar(
                              focusedMonth: state.focusedMonth,
                              selectedDate: state.selectedDate,
                              appointments: state.appointments,
                              onPreviousMonth: () => context
                                  .read<ConsultationsBloc>()
                                  .add(ConsultationsPreviousMonthPressed()),
                              onNextMonth: () => context
                                  .read<ConsultationsBloc>()
                                  .add(ConsultationsNextMonthPressed()),
                              onDateSelected: (d) => context
                                  .read<ConsultationsBloc>()
                                  .add(ConsultationsDateSelected(d)),
                            )
                          else if (state.range == ConsultationsRange.day)
                            _DayHeader(date: state.selectedDate),
                          const SizedBox(height: 16),
                          _AppointmentsSection(
                            title: DateFormat(
                              'MMMM d',
                            ).format(state.selectedDate),
                            appointments: _filterAppointmentsForRange(
                              appointments: state.appointments,
                              selectedDate: state.selectedDate,
                              range: state.range,
                            ),
                          ),
                        ] else ...[
                          _AppointmentsSection(
                            title: 'Appointments',
                            appointments: state.appointments,
                            showDate: true,
                          ),
                        ],
                        const SizedBox(height: 20),
                      ]),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 3),
    );
  }

  static List<ConsultationAppointment> _filterAppointmentsForRange({
    required List<ConsultationAppointment> appointments,
    required DateTime selectedDate,
    required ConsultationsRange range,
  }) {
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    if (range == ConsultationsRange.month) {
      return appointments
          .where(
            (a) =>
                a.dateTime.year == selected.year &&
                a.dateTime.month == selected.month &&
                a.dateTime.day == selected.day,
          )
          .toList();
    }
    if (range == ConsultationsRange.day) {
      return appointments
          .where(
            (a) =>
                a.dateTime.year == selected.year &&
                a.dateTime.month == selected.month &&
                a.dateTime.day == selected.day,
          )
          .toList();
    }

    final start = selected.subtract(Duration(days: selected.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return appointments
        .where((a) => !a.dateTime.isBefore(start) && a.dateTime.isBefore(end))
        .toList();
  }
}

class _TabSwitcher extends StatelessWidget {
  final ConsultationsTab selected;
  final ValueChanged<ConsultationsTab> onChanged;

  const _TabSwitcher({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillButton(
            label: 'Calendar',
            isSelected: selected == ConsultationsTab.calendar,
            selectedColor: const Color(0xFF5C5D87), // Dark Purple/Blue
            onTap: () => onChanged(ConsultationsTab.calendar),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PillButton(
            label: 'List',
            isSelected: selected == ConsultationsTab.list,
            selectedColor: const Color(0xFF5C5D87),
            onTap: () => onChanged(ConsultationsTab.list),
          ),
        ),
      ],
    );
  }
}

class _RangeSwitcher extends StatelessWidget {
  final ConsultationsRange selected;
  final ValueChanged<ConsultationsRange> onChanged;

  const _RangeSwitcher({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillButton(
            label: 'Month',
            isSelected: selected == ConsultationsRange.month,
            selectedColor: const Color(0xFF66BB6A), // Green
            onTap: () => onChanged(ConsultationsRange.month),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PillButton(
            label: 'Week',
            isSelected: selected == ConsultationsRange.week,
            selectedColor: const Color(0xFF66BB6A),
            onTap: () => onChanged(ConsultationsRange.week),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PillButton(
            label: 'Day',
            isSelected: selected == ConsultationsRange.day,
            selectedColor: const Color(0xFF66BB6A),
            onTap: () => onChanged(ConsultationsRange.day),
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFEEEEEE), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF33354E),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  const _StatusLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LegendItem(label: 'Paid', color: Color(0xFF66BB6A)),
        SizedBox(width: 16),
        _LegendItem(
          label: 'Need to paid', // Matches image text exactly
          color: Color(0xFFEF5350),
        ),
        SizedBox(width: 16),
        _LegendItem(
          label: 'Complited', // Matches image text exactly
          color: Color(0xFF90A4AE),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF33354E),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime date;

  const _DayHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        DateFormat('d MMMM yyyy', locale).format(date),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF33354E),
        ),
      ),
    );
  }
}

class _AppointmentsSection extends StatelessWidget {
  final String title;
  final List<ConsultationAppointment> appointments;
  final bool showDate;

  const _AppointmentsSection({
    required this.title,
    required this.appointments,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final sorted = [...appointments]
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF33354E),
          ),
        ),
        const SizedBox(height: 10),
        if (sorted.isEmpty)
          const _EmptyAppointments()
        else
          ...sorted.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AppointmentTile(
                appointment: a,
                subtitle: showDate
                    ? DateFormat('d MMM, HH:mm', locale).format(a.dateTime)
                    : DateFormat('HH:mm', locale).format(a.dateTime),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'No appointments',
        style: TextStyle(color: Color(0xFF90A4AE), fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final ConsultationAppointment appointment;
  final String subtitle;

  const _AppointmentTile({required this.appointment, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final status = _statusMeta(appointment.status);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              AppointmentCancellationSheet(appointment: appointment),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000), // Softer shadow
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Time and Status
            Row(
              children: [
                Text(
                  subtitle, // Time string passed from parent
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: status.$3, // Background color
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // More rounded capsule
                  ),
                  child: Text(
                    status.$1,
                    style: TextStyle(
                      color: status.$2, // Text color
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bottom Row: Profile and Chat
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(appointment.expertAvatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    appointment.expertName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF33354E),
                    ),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xFFB0BEC5), // Light grey icon
                      size: 24,
                    ),
                    if (appointment.hasUnreadMessages)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935), // Red dot
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static (String label, Color textColor, Color bgColor) _statusMeta(
    ConsultationStatus status,
  ) {
    switch (status) {
      case ConsultationStatus.paid:
        return ('paid', const Color(0xFF66BB6A), const Color(0xFFE8F5E9));
      case ConsultationStatus.needToPay:
        return ('not paid', const Color(0xFFEF5350), const Color(0xFFFFEBEE));
      case ConsultationStatus.completed:
        return ('completed', const Color(0xFF90A4AE), const Color(0xFFF5F5F5));
    }
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;

  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2E2E3E),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        if (index == 0) {
          context.go(AppRoutes.experts);
        } else if (index == 3) {
          context.go(AppRoutes.consultations);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.star_border),
          activeIcon: const Icon(Icons.star),
          label: l10n.experts,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bolt),
          label: l10n.materials,
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E3E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble_outline),
          label: l10n.consultations,
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.help_outline),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          label: l10n.questions,
        ),
      ],
    );
  }
}
