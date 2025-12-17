import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/consultation_appointment.dart';

class WeeklyCalendarView extends StatelessWidget {
  final List<ConsultationAppointment> appointments;
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final ValueChanged<ConsultationAppointment> onAppointmentTap;

  const WeeklyCalendarView({
    super.key,
    required this.appointments,
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onAppointmentTap,
  });

  @override
  Widget build(BuildContext context) {
    // 10 hours visible approx.
    // 1 hour row height = 50.0 (40 + padding/borders ~ 50)
    // 10 * 50 = 500.0 height
    const double rowHeight = 50.0;
    const double visibleHours = 7;
    const double totalHeight = rowHeight * visibleHours;

    // Calculate start of week (Monday)
    // If selectedDate is Monday, it keeps it.
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header (Date Navigation + Days)
          _WeeklyHeader(
            weekStart: weekStart,
            weekEnd: weekEnd,
            onPreviousWeek: onPreviousWeek,
            onNextWeek: onNextWeek,
          ),

          // Scrollable Calendar Area with Fade
          SizedBox(
            height: totalHeight,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [
                    0.0,
                    0.08, // 8% fade at top
                    0.92, // 8% fade at bottom
                    1.0,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ), // Padding to allow scrolling past edges
                itemCount: 24,
                itemBuilder: (context, index) {
                  return WeeklyTimeRow(
                    hour: index,
                    height: rowHeight,
                    appointments: appointments,
                    weekStart: weekStart,
                    onAppointmentTap: onAppointmentTap,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyHeader extends StatelessWidget {
  final DateTime weekStart;
  final DateTime weekEnd;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const _WeeklyHeader({
    required this.weekStart,
    required this.weekEnd,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM');
    final rangeText =
        '${dateFormat.format(weekStart)} - ${dateFormat.format(weekEnd)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          // Date Range Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFFEEEEEE),
                  size: 30,
                ),
                onPressed: onPreviousWeek,
              ),
              Text(
                rangeText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF66BB6A),
                  size: 30,
                ),
                onPressed: onNextWeek,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 50), // Match time column width
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    _buildDayHeader('Пн'),
                    _buildDayHeader('Вт'),
                    _buildDayHeader('Ср'),
                    _buildDayHeader('Чт'),
                    _buildDayHeader('Пт'),
                    _buildDayHeader('Сб'),
                    _buildDayHeader('Вс'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: const TextStyle(
            color: Color(0xFF9094BB),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class WeeklyTimeRow extends StatelessWidget {
  final int hour;
  final double height;
  final List<ConsultationAppointment> appointments;
  final DateTime weekStart;
  final ValueChanged<ConsultationAppointment> onAppointmentTap;

  const WeeklyTimeRow({
    super.key,
    required this.hour,
    required this.height,
    required this.appointments,
    required this.weekStart,
    required this.onAppointmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            // Time Column
            SizedBox(
              width: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Grid Columns (7 days)
            Expanded(
              child: Row(
                children: List.generate(7, (dayIndex) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: _buildAppointmentBlock(dayIndex, hour),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentBlock(int dayIndex, int hour) {
    // Calculate date for this column
    final currentDate = weekStart.add(Duration(days: dayIndex));

    // Find appointment matching date and hour
    ConsultationAppointment? appointment;
    try {
      appointment = appointments.firstWhere(
        (appt) =>
            appt.dateTime.year == currentDate.year &&
            appt.dateTime.month == currentDate.month &&
            appt.dateTime.day == currentDate.day &&
            appt.dateTime.hour == hour,
      );
    } catch (_) {
      // No appointment found
    }

    final hasAppointment = appointment != null;
    final color = hasAppointment
        ? _statusColor(appointment.status)
        : Colors.transparent;
    final borderColor = hasAppointment ? color : const Color(0xFFE0E0E0);

    if (!hasAppointment) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
      );
    }

    final nonNullAppointment = appointment;

    return GestureDetector(
      onTap: () => onAppointmentTap(nonNullAppointment),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
      ),
    );
  }

  Color _statusColor(ConsultationStatus status) {
    switch (status) {
      case ConsultationStatus.paid:
        return const Color(0xFF66BB6A);
      case ConsultationStatus.needToPay:
        return const Color(0xFFEF5350);
      case ConsultationStatus.completed:
        return const Color(0xFF90A4AE);
    }
  }
}

// Deprecated or unused but kept for compatibility if referenced elsewhere
class WeeklyDailyList extends StatelessWidget {
  const WeeklyDailyList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
