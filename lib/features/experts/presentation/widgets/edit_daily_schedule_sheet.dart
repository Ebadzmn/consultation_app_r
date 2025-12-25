import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDailyScheduleSheet extends StatefulWidget {
  final DateTime date;

  const EditDailyScheduleSheet({super.key, required this.date});

  @override
  State<EditDailyScheduleSheet> createState() => _EditDailyScheduleSheetState();
}

class _EditDailyScheduleSheetState extends State<EditDailyScheduleSheet> {
  final List<_ScheduleInterval> _intervals = [
    _ScheduleInterval(type: 'Not working', startTime: '09:00', endTime: '18:00'),
    _ScheduleInterval(type: 'Working', startTime: '09:00', endTime: '18:00'),
  ];

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy').format(widget.date);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Change work schedule\nfor $dateStr',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.grey[400]),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(_intervals.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildIntervalRow(index),
            );
          }),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _intervals.add(_ScheduleInterval(
                  type: 'Working',
                  startTime: '09:00',
                  endTime: '18:00',
                ));
              });
            },
            child: Row(
              children: const [
                Icon(Icons.add, color: Color(0xFF66BB6A), size: 20),
                SizedBox(width: 8),
                Text(
                  'Add interval',
                  style: TextStyle(
                    color: Color(0xFF66BB6A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEEEEEE)),
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
        ],
      ),
    );
  }

  Widget _buildIntervalRow(int index) {
    final interval = _intervals[index];
    return Row(
      children: [
        // Type Dropdown
        Expanded(
          flex: 4,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: interval.type,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                items: ['Working', 'Not working'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _intervals[index] = interval.copyWith(type: newValue);
                    });
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Start Time
        Expanded(
          flex: 2,
          child: _buildTimeField(interval.startTime, (val) {
            setState(() {
              _intervals[index] = interval.copyWith(startTime: val);
            });
          }),
        ),
        const SizedBox(width: 8),
        // End Time
        Expanded(
          flex: 2,
          child: _buildTimeField(interval.endTime, (val) {
            setState(() {
              _intervals[index] = interval.copyWith(endTime: val);
            });
          }),
        ),
        const SizedBox(width: 8),
        // Delete Button
        Container(
          width: 44,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                _intervals.removeAt(index);
              });
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFFB0BEC5),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String time, Function(String) onChanged) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: const TextStyle(fontSize: 14, color: Color(0xFF33354E)),
      ),
    );
  }
}

class _ScheduleInterval {
  final String type;
  final String startTime;
  final String endTime;

  _ScheduleInterval({
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  _ScheduleInterval copyWith({
    String? type,
    String? startTime,
    String? endTime,
  }) {
    return _ScheduleInterval(
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
