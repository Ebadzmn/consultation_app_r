import 'package:consultant_app/features/experts/domain/entities/available_work_dates_entity.dart';

class AvailableWorkDatesModel extends AvailableWorkDatesEntity {
  const AvailableWorkDatesModel({
    required super.start,
    required super.end,
    required super.notWorkingDates,
  });

  factory AvailableWorkDatesModel.fromJson(Map<String, dynamic> json) {
    return AvailableWorkDatesModel(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      notWorkingDates: (json['not_working_dates'] as List)
          .map((e) => DateTime.parse(e))
          .toList(),
    );
  }
}
