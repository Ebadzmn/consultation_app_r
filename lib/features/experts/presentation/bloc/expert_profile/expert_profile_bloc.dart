import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../domain/entities/expert_profile.dart';
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final isExpertUser = di.currentUser.value?.userType == 'Expert';
      final expert = isExpertUser
          ? const ExpertProfile(
              id: 'e-1',
              name: 'Anastasiya Ivanova',
              rating: 4.5,
              imageUrl: 'https://i.pravatar.cc/300?img=5',
              areas: [
                'Finance',
                'Banking',
                'IT',
                'Finance',
                'Banking',
                'IT',
                'Finance',
                'Banking',
              ],
              articlesCount: 10,
              pollsCount: 30,
              reviewsCount: 24,
              answersCount: 14,
              education:
                  'Faculty of Economics, Lomonosov Moscow State University',
              experience: '3 years',
              description:
                  'It is difficult to say why actively developing third world countries represent nothing more than the quintessence of the victory of marketing over reason and must be declared violating universal human norms of ethics and morality!',
              cost: '1000₽/hour',
              researchCount: 0,
              articleListCount: 10,
              questionsCount: 0,
              projectsCount: 5,
            )
          : const ExpertProfile(
              id: 'c-1',
              name: 'Normal Client',
              rating: 5.0,
              imageUrl: 'https://i.pravatar.cc/300?img=15',
              areas: ['Business', 'Education'],
              articlesCount: 0,
              pollsCount: 0,
              reviewsCount: 3,
              answersCount: 0,
              education: 'University of Dhaka',
              experience: 'Student',
              description:
                  'Client profile with basic information. Book consultations with experts across various fields.',
              cost: '—',
              researchCount: 0,
              articleListCount: 0,
              questionsCount: 0,
              projectsCount: 0,
            );

      emit(ExpertProfileLoaded(expert));
    } catch (e) {
      emit(ExpertProfileError('Failed to load profile: $e'));
    }
  }
}
