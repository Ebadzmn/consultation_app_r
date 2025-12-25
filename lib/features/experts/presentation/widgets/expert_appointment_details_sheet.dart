import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/consultation_appointment.dart';
import '../../../../../injection_container.dart' as di;

class ExpertAppointmentDetailsSheet extends StatelessWidget {
  final ConsultationAppointment appointment;

  const ExpertAppointmentDetailsSheet({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final isExpert = di.currentUser.value?.userType == 'Expert';
    
    // Status Logic
    final isConfirmed = appointment.status == ConsultationStatus.paid;
    
    // Status Text & Color
    String statusText;
    Color statusColor;
    Color statusBg;

    if (isExpert) {
      statusText = isConfirmed ? 'Confirmed' : 'Requires confirmation';
      statusColor = isConfirmed ? const Color(0xFF66BB6A) : const Color(0xFFEF5350);
      statusBg = isConfirmed ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    } else {
      statusText = isConfirmed ? 'Confirmed' : 'Waiting for confirmation';
      statusColor = isConfirmed ? const Color(0xFF66BB6A) : const Color(0xFFFFA726); // Orange for waiting
      statusBg = isConfirmed ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header with Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appointment details',
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
          const SizedBox(height: 24),

          // User Info (Expert sees Client, Client sees Expert)
          Text(
            isExpert ? 'Client' : 'Expert',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(appointment.expertAvatarUrl),
              ),
              const SizedBox(width: 12),
              Text(
                appointment.expertName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF33354E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), // Light Yellow
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Finances',
              style: TextStyle(
                color: Color(0xFFFFA000), // Amber/Orange
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Date and Time
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      DateFormat('d MMMM', Localizations.localeOf(context).toString()).format(appointment.dateTime),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF33354E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const Text(
                      'Europe/Moscow +03:00', // Mocked timezone
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF90A4AE),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Comment
          const Text(
            'Comment to meeting',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'I have a big question for you',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF33354E),
            ),
          ),
          const SizedBox(height: 20),

          // Status
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          if (isExpert)
            _buildExpertActions(context, isConfirmed)
          else
            _buildClientActions(context, isConfirmed),
            
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

  Widget _buildExpertActions(BuildContext context, bool isConfirmed) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              isConfirmed ? 'Join' : 'Approve',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEF5350)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              isConfirmed ? 'Cancel appointment' : 'Decline',
              style: const TextStyle(
                color: Color(0xFFEF5350),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientActions(BuildContext context, bool isConfirmed) {
    return Column(
      children: [
        if (!isConfirmed) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33354E), // Dark blue for Pay
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Pay now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (isConfirmed) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Join',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEF5350)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancel appointment',
              style: TextStyle(
                color: Color(0xFFEF5350),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
