import 'package:equatable/equatable.dart';
import '../../../domain/entities/expert_profile.dart';

abstract class ExpertProfileState extends Equatable {
  const ExpertProfileState();

  @override
  List<Object> get props => [];
}

class ExpertProfileInitial extends ExpertProfileState {}

class ExpertProfileLoading extends ExpertProfileState {}

class ExpertProfileLoaded extends ExpertProfileState {
  final ExpertProfile expert;

  const ExpertProfileLoaded(this.expert);

  @override
  List<Object> get props => [expert];
}

class ExpertProfileError extends ExpertProfileState {
  final String message;

  const ExpertProfileError(this.message);

  @override
  List<Object> get props => [message];
}
