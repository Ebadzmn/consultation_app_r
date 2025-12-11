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

    final result = await getExperts();

    result.fold(
      (failure) => emit(state.copyWith(
          status: ExpertsStatus.failure, errorMessage: failure.message)),
      (experts) => emit(
          state.copyWith(status: ExpertsStatus.success, experts: experts)),
    );
  }

  Future<void> _onFilterExperts(
      FilterExperts event, Emitter<ExpertsState> emit) async {
    // In a real app, this would trigger a new UseCase call with parameters
    // For now, we'll simulate filtering on the already loaded list or reload
    // Since we only have mock data, we will just reload to simulate activity
    add(LoadExperts());
  }
}
