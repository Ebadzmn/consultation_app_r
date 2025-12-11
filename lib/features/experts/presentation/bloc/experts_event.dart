import 'package:equatable/equatable.dart';

abstract class ExpertsEvent extends Equatable {
  const ExpertsEvent();

  @override
  List<Object> get props => [];
}

class LoadExperts extends ExpertsEvent {}

class FilterExperts extends ExpertsEvent {
  final String category;
  final String rating;
  final String sortBy;

  const FilterExperts({
    required this.category,
    required this.rating,
    required this.sortBy,
  });

  @override
  List<Object> get props => [category, rating, sortBy];
}
