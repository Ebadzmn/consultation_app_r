import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_experts_usecase.dart';
import 'experts_event.dart';
import 'experts_state.dart';

class ExpertsBloc extends Bloc<ExpertsEvent, ExpertsState> {
  final GetExpertsUseCase getExperts;

  ExpertsBloc({required this.getExperts}) : super(const ExpertsState()) {
    on<LoadExperts>(_onLoadExperts);
    on<FilterExperts>(_onFilterExperts);
    on<LoadMoreExperts>(_onLoadMoreExperts);
  }

  Future<void> _onLoadExperts(
      LoadExperts event, Emitter<ExpertsState> emit) async {
    emit(
      state.copyWith(
        status: ExpertsStatus.loading,
        errorMessage: null,
        experts: const [],
        page: 1,
        pageSize: 10,
        hasMore: true,
        isLoadingMore: false,
        categoryIds: const [],
        minRating: null,
        sortBy: null,
      ),
    );

    final result = await getExperts(const GetExpertsParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExpertsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (experts) => emit(
        state.copyWith(
          status: ExpertsStatus.success,
          experts: experts,
          page: 1,
          pageSize: 10,
          hasMore: experts.length == 10,
          isLoadingMore: false,
          categoryIds: const [],
          minRating: null,
          sortBy: null,
        ),
      ),
    );
  }

  Future<void> _onFilterExperts(
      FilterExperts event, Emitter<ExpertsState> emit) async {
    emit(
      state.copyWith(
        status: ExpertsStatus.loading,
        errorMessage: null,
        experts: const [],
        page: event.page,
        pageSize: event.pageSize,
        hasMore: true,
        isLoadingMore: false,
        categoryIds: event.categoryIds,
        minRating: event.minRating,
        sortBy: event.sortBy,
      ),
    );

    final result = await getExperts(
      GetExpertsParams(
        page: event.page,
        pageSize: event.pageSize,
        minRating: event.minRating,
        categoryIds: event.categoryIds,
        sortBy: event.sortBy,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExpertsStatus.failure,
          errorMessage: failure.message,
          isLoadingMore: false,
        ),
      ),
      (experts) => emit(
        state.copyWith(
          status: ExpertsStatus.success,
          experts: experts,
          hasMore: experts.length == state.pageSize,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreExperts(
    LoadMoreExperts event,
    Emitter<ExpertsState> emit,
  ) async {
    if (state.status != ExpertsStatus.success ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;

    final result = await getExperts(
      GetExpertsParams(
        page: nextPage,
        pageSize: state.pageSize,
        minRating: state.minRating,
        categoryIds:
            state.categoryIds.isEmpty ? null : List<int>.from(state.categoryIds),
        sortBy: state.sortBy,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExpertsStatus.failure,
          errorMessage: failure.message,
          isLoadingMore: false,
        ),
      ),
      (experts) {
        if (experts.isEmpty) {
          emit(
            state.copyWith(
              hasMore: false,
              isLoadingMore: false,
            ),
          );
        } else {
          final updatedExperts = List.of(state.experts)..addAll(experts);
          emit(
            state.copyWith(
              status: ExpertsStatus.success,
              experts: updatedExperts,
              page: nextPage,
              hasMore: experts.length == state.pageSize,
              isLoadingMore: false,
            ),
          );
        }
      },
    );
  }
}
