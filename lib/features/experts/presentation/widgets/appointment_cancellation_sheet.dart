import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/consultation_appointment.dart';
import 'appointment_cancellation_success_sheet.dart';
import 'appointment_reschedule_sheet.dart';

class AppointmentCancellationSheet extends StatelessWidget {
  final ConsultationAppointment appointment;

  const AppointmentCancellationSheet({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
          // Close Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Color(0xFF90A4AE)),
            ),
          ),

          // Warning Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'Confirm cancellation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33354E), // Dark text color
            ),
          ),
          const SizedBox(height: 16),

          // Expert Label
          const Text(
            'Expert',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Expert Profile
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(appointment.expertAvatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating and stats
                    Row(
                      children: const [
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
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
                          'Reviews: 24',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF90A4AE),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Articles: 10',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF90A4AE),
                          ),
                        ),
                        // 'Polls: 30' might be too long to fit, let's include it if space allows or wrap
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.expertName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tags
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
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Date and Time
          const Text(
            'Date',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('d MMMM', 'en_US').format(appointment.dateTime),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33354E),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Time',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('HH:mm').format(appointment.dateTime),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF33354E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Europe/Moscow +03:00',
            style: TextStyle(fontSize: 13, color: Color(0xFF90A4AE)),
          ),
          const SizedBox(height: 32),

          // Buttons
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      const AppointmentCancellationSuccessSheet(),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE53935)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Confirm cancellation',
                style: TextStyle(
                  color: Color(0xFFE53935), // Red text
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.85,
                    child: AppointmentRescheduleSheet(appointment: appointment),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF90A4AE)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Choose another date and time',
                style: TextStyle(
                  color: Color(0xFF33354E), // Dark text
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
