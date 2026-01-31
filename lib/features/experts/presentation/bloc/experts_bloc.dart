import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_experts_usecase.dart';
import 'experts_event.dart';
import 'experts_state.dart';

class ExpertsBloc extends Bloc<ExpertsEvent, ExpertsState> {
  final GetExpertsUseCase getExperts;

  ExpertsBloc({required this.getExperts}) : super(const ExpertsState()) {
    on<LoadExperts>(_onLoadExperts);
    on<FilterExperts>(_onFilterExperts);
  }

  Future<void> _onLoadExperts(
      LoadExperts event, Emitter<ExpertsState> emit) async {
    emit(state.copyWith(status: ExpertsStatus.loading));

    final result = await getExperts(const GetExpertsParams());

    result.fold(
      (failure) => emit(state.copyWith(
          status: ExpertsStatus.failure, errorMessage: failure.message)),
      (experts) => emit(
          state.copyWith(status: ExpertsStatus.success, experts: experts)),
    );
  }

  Future<void> _onFilterExperts(
      FilterExperts event, Emitter<ExpertsState> emit) async {
    emit(state.copyWith(status: ExpertsStatus.loading));

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
        ),
      ),
      (experts) => emit(
        state.copyWith(
          status: ExpertsStatus.success,
          experts: experts,
        ),
      ),
    );
  }
}
