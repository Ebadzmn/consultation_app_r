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
  final int selectedIndex;

  const ExpertProfileLoaded(this.expert, {this.selectedIndex = 0});

  @override
  List<Object> get props => [expert, selectedIndex];

  ExpertProfileLoaded copyWith({
    ExpertProfile? expert,
    int? selectedIndex,
  }) {
    return ExpertProfileLoaded(
      expert ?? this.expert,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class ExpertProfileError extends ExpertProfileState {
  final String message;

  const ExpertProfileError(this.message);

  @override
  List<Object> get props => [message];
}
