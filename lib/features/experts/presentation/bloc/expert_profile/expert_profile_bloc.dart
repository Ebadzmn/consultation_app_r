import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../domain/repositories/experts_repository.dart';
import 'expert_profile_event.dart';
import 'expert_profile_state.dart';

class ExpertProfileBloc extends Bloc<ExpertProfileEvent, ExpertProfileState> {
  ExpertProfileBloc() : super(ExpertProfileInitial()) {
    on<LoadExpertProfile>(_onLoadExpertProfile);
    on<ExpertProfileTabChanged>(_onTabChanged);
  }

  void _onTabChanged(
    ExpertProfileTabChanged event,
    Emitter<ExpertProfileState> emit,
  ) {
    if (state is ExpertProfileLoaded) {
      emit((state as ExpertProfileLoaded).copyWith(selectedIndex: event.index));
    }
  }

  Future<void> _onLoadExpertProfile(
    LoadExpertProfile event,
    Emitter<ExpertProfileState> emit,
  ) async {
    emit(ExpertProfileLoading());
    try {
      if (event.expertId != null) {
        final repository = di.sl<ExpertsRepository>();
        final result = await repository.getExpertProfile(event.expertId!);

        await result.fold<Future<void>>(
          (failure) async {
            emit(ExpertProfileError(failure.message));
          },
          (profile) async {
            emit(ExpertProfileLoaded(profile));
          },
        );
        return;
      }

      final repository = di.sl<ExpertsRepository>();
      final result = await repository.getCurrentUserProfile();

      await result.fold<Future<void>>(
        (failure) async {
          emit(ExpertProfileError(failure.message));
        },
        (profile) async {
          emit(ExpertProfileLoaded(profile));
        },
      );
    } catch (e) {
      emit(ExpertProfileError('Failed to load profile: $e'));
    }
  }
}
