import 'package:equatable/equatable.dart';
import '../../domain/entities/expert_entity.dart';

enum ExpertsStatus { initial, loading, success, failure }

class ExpertsState extends Equatable {
  final ExpertsStatus status;
  final List<ExpertEntity> experts;
  final String? errorMessage;
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;
  final List<int> categoryIds;
  final double? minRating;
  final String? sortBy;
  final String? search;

  const ExpertsState({
    this.status = ExpertsStatus.initial,
    this.experts = const [],
    this.errorMessage,
    this.page = 1,
    this.pageSize = 10,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.categoryIds = const [],
    this.minRating,
    this.sortBy,
    this.search,
  });

  ExpertsState copyWith({
    ExpertsStatus? status,
    List<ExpertEntity>? experts,
    String? errorMessage,
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
    List<int>? categoryIds,
    double? minRating,
    String? sortBy,
    String? search,
  }) {
    return ExpertsState(
      status: status ?? this.status,
      experts: experts ?? this.experts,
      errorMessage: errorMessage,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      categoryIds: categoryIds ?? this.categoryIds,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [
        status,
        experts,
        errorMessage,
        page,
        pageSize,
        hasMore,
        isLoadingMore,
        categoryIds,
        minRating,
        sortBy,
        search,
      ];
}
