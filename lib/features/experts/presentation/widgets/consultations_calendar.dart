import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/consultation_appointment.dart';

class ConsultationsCalendar extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<ConsultationAppointment> appointments;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? maxMonth;

  const ConsultationsCalendar({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.appointments,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDateSelected,
    this.maxMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy').format(focusedMonth);
    final canGoNext = maxMonth == null ||
        DateTime(focusedMonth.year, focusedMonth.month, 1).isBefore(
          DateTime(maxMonth!.year, maxMonth!.month, 1),
        );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFFEEEEEE),
                  size: 30,
                ),
                onPressed: onPreviousMonth,
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color:
                      canGoNext ? const Color(0xFF66BB6A) : const Color(0xFFEEEEEE),
                  size: 30,
                ),
                onPressed: canGoNext ? onNextMonth : null,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _WeekdayLabel('Mon'),
              _WeekdayLabel('Tue'),
              _WeekdayLabel('Wed'),
              _WeekdayLabel('Thu'),
              _WeekdayLabel('Fri'),
              _WeekdayLabel('Sat'),
              _WeekdayLabel('Sun'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: _DaysGrid(
            focusedMonth: focusedMonth,
            selectedDate: selectedDate,
            appointments: appointments,
            onDateSelected: onDateSelected,
          ),
        ),
      ],
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;

  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF9094BB),
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
    );
  }
}

class _DaysGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<ConsultationAppointment> appointments;
  final ValueChanged<DateTime> onDateSelected;

  const _DaysGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.appointments,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final prevMonthDays = firstDayOfMonth.weekday - 1;

    final totalCells = (daysInMonth + prevMonthDays <= 35) ? 35 : 42;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < prevMonthDays) {
          final prevMonth = DateTime(focusedMonth.year, focusedMonth.month, 0);
          final day = prevMonth.day - (prevMonthDays - index - 1);
          return _OutOfMonthCell(label: '$day');
        }

        final day = index - prevMonthDays + 1;
        if (day > daysInMonth) {
          final nextMonthDay = day - daysInMonth;
          return _OutOfMonthCell(label: '$nextMonthDay');
        }

        final date = DateTime(focusedMonth.year, focusedMonth.month, day);
        final isSelected =
            date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

        // Check if it's today
        final now = DateTime.now();
        final isToday =
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

        final dayAppointments = appointments
            .where(
              (a) =>
                  a.dateTime.year == date.year &&
                  a.dateTime.month == date.month &&
                  a.dateTime.day == date.day,
            )
            .toList();

        final count = dayAppointments.length;

        // Priority: NeedToPay (Red) > Paid (Green) > Completed (Grey)
        // Adjust logic if you want to show totals regardless of status mix
        Color? badgeColor;
        if (dayAppointments.any(
          (a) => a.status == ConsultationStatus.needToPay,
        )) {
          badgeColor = const Color(0xFFEF5350);
        } else if (dayAppointments.any(
          (a) => a.status == ConsultationStatus.paid,
        )) {
          badgeColor = const Color(0xFF66BB6A);
        } else if (dayAppointments.isNotEmpty) {
          // Fallback or completed
          badgeColor = const Color(0xFFBDBDBD); // Grey
        }

        // Override badge count color based on specific logic if "count" should reflect all or specific category?
        // Assuming count implies total appointments for the day.

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF66BB6A) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? null
                      : isToday
                      ? Border.all(color: const Color(0xFF66BB6A), width: 1.5)
                      : Border.all(color: const Color(0xFFEEEEEE), width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              if (count > 0 && badgeColor != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 14,
                    ),
                    padding: const EdgeInsets.fromLTRB(6, 2, 2, 6),
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      widthFactor: 0.9,
                      heightFactor: 1,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _OutOfMonthCell extends StatelessWidget {
  final String label;

  const _OutOfMonthCell({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Keep background clean
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFAFAFA), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[500], // Very faint text
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }
}
