import 'package:flutter/material.dart';

class AppointmentCancellationSuccessSheet extends StatelessWidget {
  const AppointmentCancellationSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9), // Light green background
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle_rounded,
                color: Color(
                  0xFF66BB6A,
                ), // Green icon matched from previous files
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'Appointment successfully canceled',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33354E),
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          const Text(
            'The paid amount will be returned to your payment account within 7 days',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF90A4AE),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the sheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A), // Green button
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Go to personal account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
