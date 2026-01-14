import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final List<DateTime> notWorkingDates;

  const AppointmentCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.notWorkingDates = const [],
  });

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFFB0BEC5)),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_focusedMonth),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33354E),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF66BB6A)),
                onPressed: _nextMonth,
              ),
            ],
          ),
        ),

        // Week Days Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF90A4AE),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Days Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildDaysGrid(),
        ),
      ],
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final weekdayOfFirstDay = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun

    // Previous month filler days
    final prevMonthDays = weekdayOfFirstDay - 1;

    final totalCells = (daysInMonth + prevMonthDays <= 35) ? 35 : 42;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < prevMonthDays) {
          // Previous month days
          final prevMonth = DateTime(
            _focusedMonth.year,
            _focusedMonth.month,
            0,
          );
          final day = prevMonth.day - (prevMonthDays - index - 1);
          return _buildOutOfMonthDay('$day');
        } else {
          final day = index - prevMonthDays + 1;
          if (day > daysInMonth) {
            // Next month days
            final nextMonthDay = day - daysInMonth;
            return _buildOutOfMonthDay('$nextMonthDay');
          }

          final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
          final isSelected =
              date.year == widget.selectedDate.year &&
              date.month == widget.selectedDate.month &&
              date.day == widget.selectedDate.day;

          final isNotWorking = widget.notWorkingDates.any(
            (d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day,
          );

          return GestureDetector(
            onTap: isNotWorking ? null : () => widget.onDateSelected(date),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF66BB6A)
                    : (isNotWorking ? Colors.grey[100] : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: isSelected
                      ? const Color(0xFF66BB6A)
                      : (isNotWorking
                            ? Colors.transparent
                            : const Color(0xFFE0E0E0)),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isNotWorking
                            ? Colors.grey[400]
                            : const Color(0xFF33354E)),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildOutOfMonthDay(String label) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFB0BEC5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
