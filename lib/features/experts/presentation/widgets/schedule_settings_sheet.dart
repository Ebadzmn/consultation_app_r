import 'package:flutter/material.dart';

class ScheduleSettingsSheet extends StatefulWidget {
  const ScheduleSettingsSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleSettingsSheet> createState() => _ScheduleSettingsSheetState();
}

class _ScheduleSettingsSheetState extends State<ScheduleSettingsSheet> {
  String _selectedTimezone = 'Europe/Moscow +03:00';
  
  // Initialize with default values
  final List<DaySchedule> _schedule = [
    DaySchedule(day: 'Monday', startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Tuesday', startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Wednesday', startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Thursday', startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Friday', startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Saturday', startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Sunday', startTime: '09:00', endTime: '18:00', isEnabled: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.85, // Occupy most of screen
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Schedule Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33354E),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Timezone Section
          const Text(
            'Timezone',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTimezone,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['Europe/Moscow +03:00', 'UTC +00:00', 'Asia/Dhaka +06:00']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTimezone = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Days List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _schedule.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = _schedule[index];
              return Row(
                children: [
                  // Checkbox
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: item.isEnabled,
                      activeColor: const Color(0xFF33354E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        setState(() {
                          item.isEnabled = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Day Name
                  Expanded(
                    child: Text(
                      item.day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF33354E),
                      ),
                    ),
                  ),
                  
                  // Start Time
                  _buildTimeBox(context, item.startTime, (newTime) {
                    setState(() => item.startTime = newTime);
                  }),
                  const SizedBox(width: 8),
                  
                  // End Time
                  _buildTimeBox(context, item.endTime, (newTime) {
                    setState(() => item.endTime = newTime);
                  }),
                ],
              );
            },
          ),
          
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement save logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Close Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFF33354E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ),
  );
}

  Widget _buildTimeBox(BuildContext context, String time, Function(String) onChanged) {
    return GestureDetector(
      onTap: () async {
        // Simple time picker implementation
        final parts = time.split(':');
        final initialTime = TimeOfDay(
          hour: int.parse(parts[0]), 
          minute: int.parse(parts[1])
        );
        
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (picked != null) {
          final h = picked.hour.toString().padLeft(2, '0');
          final m = picked.minute.toString().padLeft(2, '0');
          onChanged('$h:$m');
        }
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF33354E),
          ),
        ),
      ),
    );
  }
}

class DaySchedule {
  final String day;
  String startTime;
  String endTime;
  bool isEnabled;

  DaySchedule({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.isEnabled,
  });
}
