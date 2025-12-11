import 'package:equatable/equatable.dart';
import '../../domain/entities/expert_entity.dart';

enum ExpertsStatus { initial, loading, success, failure }

class ExpertsState extends Equatable {
  final ExpertsStatus status;
  final List<ExpertEntity> experts;
  final String? errorMessage;

  const ExpertsState({
    this.status = ExpertsStatus.initial,
    this.experts = const [],
    this.errorMessage,
  });

  ExpertsState copyWith({
    ExpertsStatus? status,
    List<ExpertEntity>? experts,
    String? errorMessage,
  }) {
    return ExpertsState(
      status: status ?? this.status,
      experts: experts ?? this.experts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, experts, errorMessage];
}
