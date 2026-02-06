import 'package:equatable/equatable.dart';

abstract class ExpertsEvent extends Equatable {
  const ExpertsEvent();

  @override
  List<Object> get props => [];
}

class LoadExperts extends ExpertsEvent {}

class LoadMoreExperts extends ExpertsEvent {}

class FilterExperts extends ExpertsEvent {
  final List<int> categoryIds;
  final double minRating;
  final String sortBy;
  final String? search;
  final int page;
  final int pageSize;

  const FilterExperts({
    required this.categoryIds,
    required this.minRating,
    required this.sortBy,
    this.search,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object> get props => [
        categoryIds,
        minRating,
        sortBy,
        search ?? '',
        page,
        pageSize,
      ];
}
