import 'package:equatable/equatable.dart';

abstract class ExpertProfileEvent extends Equatable {
  const ExpertProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadExpertProfile extends ExpertProfileEvent {
  final String? expertId;

  const LoadExpertProfile({this.expertId});

  @override
  List<Object> get props => [expertId ?? ''];
}

class ExpertProfileTabChanged extends ExpertProfileEvent {
  final int index;

  const ExpertProfileTabChanged(this.index);

  @override
  List<Object> get props => [index];
}
