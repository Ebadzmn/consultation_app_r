import 'package:equatable/equatable.dart';
import '../../domain/entities/expert_entity.dart';

class PayNowArgs extends Equatable {
  final String? appointmentId;
  final ExpertEntity expert;
  final int price;
  final DateTime date;
  final String time;
  final String? category;
  final String comment;
  final Duration payWithin;

  const PayNowArgs({
    this.appointmentId,
    required this.expert,
    required this.price,
    required this.date,
    required this.time,
    required this.category,
    required this.comment,
    required this.payWithin,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        expert,
        price,
        date,
        time,
        category,
        comment,
        payWithin,
      ];
}
