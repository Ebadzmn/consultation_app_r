import 'package:flutter/material.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/repositories/experts_repository.dart';

class ScheduleSettingsSheet extends StatefulWidget {
  const ScheduleSettingsSheet({super.key});

  @override
  State<ScheduleSettingsSheet> createState() => _ScheduleSettingsSheetState();
}

class _ScheduleSettingsSheetState extends State<ScheduleSettingsSheet> {
  String _selectedTimezone = '';
  bool _isSaving = false;
  
  // Initialize with default values
  final List<DaySchedule> _schedule = [
    DaySchedule(day: 'Monday', dayOfWeek: 1, startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Tuesday', dayOfWeek: 2, startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Wednesday', dayOfWeek: 3, startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Thursday', dayOfWeek: 4, startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Friday', dayOfWeek: 5, startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Saturday', dayOfWeek: 6, startTime: '09:00', endTime: '18:00', isEnabled: true),
    DaySchedule(day: 'Sunday', dayOfWeek: 7, startTime: '09:00', endTime: '18:00', isEnabled: true),
  ];

  final List<String> _timezoneOptions = [];

  @override
  void initState() {
    super.initState();
    _loadTimezone();
    _loadSchedule();
  }

  Future<void> _loadTimezone() async {
    final repository = di.sl<ExpertsRepository>();
    final result = await repository.getScheduleTimezone();

    if (!mounted) {
      return;
    }

    result.fold(
      (_) {
        setState(() {
          _timezoneOptions
            ..clear()
            ..add('Europe/Moscow');
          _selectedTimezone = 'Europe/Moscow';
        });
      },
      (tz) {
        final value = (tz ?? '').trim();
        if (value.isEmpty) {
          setState(() {
            _timezoneOptions
              ..clear()
              ..add('Europe/Moscow');
            _selectedTimezone = 'Europe/Moscow';
          });
          return;
        }

        setState(() {
          _timezoneOptions
            ..clear()
            ..add(value);
          _selectedTimezone = value;
        });
      },
    );
  }

  Future<void> _loadSchedule() async {
    final repository = di.sl<ExpertsRepository>();
    final result = await repository.getSchedule();

    if (!mounted) {
      return;
    }

    result.fold(
      (_) {},
      (items) {
        if (items.isEmpty) {
          return;
        }

        final byDay = <int, DaySchedule>{};

        for (final item in items) {
          final rawDay = item['day_of_week'];
          int? dayOfWeek;
          if (rawDay is num) {
            dayOfWeek = rawDay.toInt();
          } else if (rawDay is String) {
            dayOfWeek = int.tryParse(rawDay);
          }
          dayOfWeek ??= 1;

          final isWorkDay = item['is_work_day'] == true;
          final start = (item['start_time'] ?? '09:00').toString();
          final end = (item['end_time'] ?? '18:00').toString();
          final idValue = item['id'];
          int? id;
          if (idValue is num) {
            id = idValue.toInt();
          } else if (idValue is String) {
            id = int.tryParse(idValue);
          }

          final dayName = _dayNameFor(dayOfWeek);

          byDay[dayOfWeek] = DaySchedule(
            day: dayName,
            dayOfWeek: dayOfWeek,
            startTime: start,
            endTime: end,
            isEnabled: isWorkDay,
            id: id,
          );
        }

        final ordered = <DaySchedule>[];
        for (var day = 1; day <= 7; day++) {
          final existing = byDay[day];
          if (existing != null) {
            ordered.add(existing);
          } else {
            ordered.add(
              DaySchedule(
                day: _dayNameFor(day),
                dayOfWeek: day,
                startTime: '09:00',
                endTime: '18:00',
                isEnabled: true,
              ),
            );
          }
        }

        setState(() {
          _schedule
            ..clear()
            ..addAll(ordered);
        });
      },
    );
  }

  String _dayNameFor(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

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
            child: _timezoneOptions.isEmpty
                ? const Text('Loading...')
                : DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTimezone,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _timezoneOptions.map((String value) {
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
              onPressed: _isSaving
                  ? null
                  : () async {
                      setState(() {
                        _isSaving = true;
                      });

                      final payload = <Map<String, dynamic>>[];
                      for (var i = 0; i < _schedule.length; i++) {
                        final item = _schedule[i];
                        final map = <String, dynamic>{
                          'day_of_week': item.dayOfWeek,
                          'is_work_day': item.isEnabled,
                          'start_time': item.startTime,
                          'end_time': item.endTime,
                        };
                        payload.add(map);
                      }

                      final repository = di.sl<ExpertsRepository>();
                      final result = await repository.updateSchedule(
                        schedule: payload,
                      );

                      if (!mounted) {
                        return;
                      }

                      result.fold(
                        (_) {
                          setState(() {
                            _isSaving = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to save schedule'),
                            ),
                          );
                        },
                        (_) {
                          Navigator.pop(context);
                        },
                      );
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
  final int dayOfWeek;
  final int? id;
  String startTime;
  String endTime;
  bool isEnabled;

  DaySchedule({
    required this.day,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isEnabled,
    this.id,
  });
}
