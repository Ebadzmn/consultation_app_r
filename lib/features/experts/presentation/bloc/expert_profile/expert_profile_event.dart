import 'package:equatable/equatable.dart';

abstract class ExpertProfileEvent extends Equatable {
  const ExpertProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadExpertProfile extends ExpertProfileEvent {}
