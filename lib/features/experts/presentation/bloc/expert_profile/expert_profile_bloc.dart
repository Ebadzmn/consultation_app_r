import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../domain/repositories/experts_repository.dart';
import 'expert_profile_event.dart';
import 'expert_profile_state.dart';

class ExpertProfileBloc extends Bloc<ExpertProfileEvent, ExpertProfileState> {
  ExpertProfileBloc() : super(ExpertProfileInitial()) {
    on<LoadExpertProfile>(_onLoadExpertProfile);
    on<ExpertProfileTabChanged>(_onTabChanged);
    on<FilterExpertProjects>(_onFilterExpertProjects);
  }

  void _onTabChanged(
    ExpertProfileTabChanged event,
    Emitter<ExpertProfileState> emit,
  ) {
    if (state is ExpertProfileLoaded) {
      emit((state as ExpertProfileLoaded).copyWith(selectedIndex: event.index));
    }
  }

  Future<void> _onFilterExpertProjects(
    FilterExpertProjects event,
    Emitter<ExpertProfileState> emit,
  ) async {
    final current = state;
    if (current is! ExpertProfileLoaded) {
      return;
    }

    try {
      final repository = di.sl<ExpertsRepository>();
      final projectsResult = await repository.getExpertProjects(
        current.expert.id,
        categoryId: event.categoryId,
      );

      projectsResult.fold(
        (_) {},
        (projects) {
          final updatedExpert = current.expert.copyWith(
            projects: projects,
            projectsCount: projects.length,
          );
          emit(
            ExpertProfileLoaded(
              updatedExpert,
              selectedIndex: current.selectedIndex,
            ),
          );
        },
      );
    } catch (_) {}
  }

  Future<void> _onLoadExpertProfile(
    LoadExpertProfile event,
    Emitter<ExpertProfileState> emit,
  ) async {
    emit(ExpertProfileLoading());
    try {
      final repository = di.sl<ExpertsRepository>();
      if (event.expertId != null) {
        final result = await repository.getExpertProfile(event.expertId!);

        await result.fold<Future<void>>(
          (failure) async {
            emit(ExpertProfileError(failure.message));
          },
          (profile) async {
            if (profile.projectsCount > 0) {
              final projectsResult = await repository.getExpertProjects(
                profile.id,
              );
              final expertWithProjects = projectsResult.fold(
                (_) => profile,
                (projects) => profile.copyWith(
                  projects: projects,
                  projectsCount: projects.length,
                ),
              );
              emit(ExpertProfileLoaded(expertWithProjects));
            } else {
              emit(ExpertProfileLoaded(profile));
            }
          },
        );
        return;
      }

      final result = await repository.getCurrentUserProfile();

      await result.fold<Future<void>>(
        (failure) async {
          emit(ExpertProfileError(failure.message));
        },
        (profile) async {
          if (profile.projectsCount > 0) {
            final projectsResult = await repository.getExpertProjects(
              profile.id,
            );
            final expertWithProjects = projectsResult.fold(
              (_) => profile,
              (projects) => profile.copyWith(
                projects: projects,
                projectsCount: projects.length,
              ),
            );
            emit(ExpertProfileLoaded(expertWithProjects));
          } else {
            emit(ExpertProfileLoaded(profile));
          }
        },
      );
    } catch (e) {
      emit(ExpertProfileError('Failed to load profile: $e'));
    }
  }
}
