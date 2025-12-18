import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/consultation_appointment.dart';
import '../widgets/consultations_calendar.dart';

class AppointmentRescheduleSheet extends StatefulWidget {
  final ConsultationAppointment appointment;

  const AppointmentRescheduleSheet({super.key, required this.appointment});

  @override
  State<AppointmentRescheduleSheet> createState() =>
      _AppointmentRescheduleSheetState();
}

class _AppointmentRescheduleSheetState
    extends State<AppointmentRescheduleSheet> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.appointment.dateTime;
    _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    // Initial selected time could be null or match current appointment
    _selectedTime = DateFormat('HH:mm').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Close
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Change appointment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFF90A4AE)),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expert Info
                    const Text(
                      'Expert',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF90A4AE),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            widget.appointment.expertAvatarUrl,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFFFC107),
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '4.5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF33354E),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Reviews: 24', // Mock data
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF90A4AE),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.appointment.expertName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF33354E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildTag('Finance', const Color(0xFFFFF3E0)),
                                _buildTag('Banking', const Color(0xFFE8F5E9)),
                                _buildTag('IT', const Color(0xFFE3F2FD)),
                                _buildTag('+6', const Color(0xFFF5F5F5)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Comment Section
                    const Text(
                      'Comment',
                      style: TextStyle(fontSize: 14, color: Color(0xFF90A4AE)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sorry, I corrected the calendar. Choose a new date and time convenient for you.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Calendar
                    const Text(
                      'Select date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    // Reusing the ConsultationsCalendar widget logic partially or fully?
                    // ConsultationsCalendar has its own headers. The design shows "December 2025" and arrows.
                    // The existing ConsultationsCalendar matches this structure.
                    ConsultationsCalendar(
                      focusedMonth: _focusedMonth,
                      selectedDate: _selectedDate,
                      appointments:
                          [], // Pass empty so we don't confuse with other appointments
                      onPreviousMonth: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month - 1,
                          );
                        });
                      },
                      onNextMonth: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month + 1,
                          );
                        });
                      },
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Time Selection
                    const Text(
                      'Choose convenient time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Europe/Moscow +03:00',
                      style: TextStyle(color: Color(0xFF90A4AE), fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _TimeChip(
                            label: '09:00',
                            isSelected: _selectedTime == '09:00',
                            onTap: () =>
                                setState(() => _selectedTime = '09:00'),
                          ),
                          _TimeChip(
                            label: '11:00',
                            isSelected: _selectedTime == '11:00',
                            onTap: () =>
                                setState(() => _selectedTime = '11:00'),
                          ),
                          _TimeChip(
                            label: '12:00',
                            isSelected: _selectedTime == '12:00',
                            onTap: () =>
                                setState(() => _selectedTime = '12:00'),
                          ),
                          _TimeChip(
                            label: '15:00',
                            isSelected: _selectedTime == '15:00',
                            onTap: () =>
                                setState(() => _selectedTime = '15:00'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Simulate confirmation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF757575), // Grey button
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE53935)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Cancel appointment',
                      style: TextStyle(
                        color: Color(0xFFE53935), // Red text
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF33354E),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF66BB6A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
