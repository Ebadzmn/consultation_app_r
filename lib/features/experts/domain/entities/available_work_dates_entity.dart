import 'package:equatable/equatable.dart';

class AvailableWorkDatesEntity extends Equatable {
  final DateTime start;
  final DateTime end;
  final List<DateTime> notWorkingDates;

  const AvailableWorkDatesEntity({
    required this.start,
    required this.end,
    required this.notWorkingDates,
  });

  @override
  List<Object?> get props => [start, end, notWorkingDates];
}
