import 'package:flutter_bloc/flutter_bloc.dart';
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

      final expert = ExpertProfile(
        id: '1',
        name: 'Anastasiya Ivanova',
        rating: 4.9,
        imageUrl:
            'https://i.pravatar.cc/300?img=5', // Female avatar
        areas: const [
          'Finance',
          'Banking',
          'IT',
          'Legal',
          'Audit',
          'Strategy',
        ],
        articlesCount: 10,
        pollsCount: 30,
        reviewsCount: 24,
        answersCount: 14,
        education: 'Higher School of Economics (National Research University)',
        experience: '7 years',
        description:
            'Professional financial consultant with over 7 years of experience in banking sector analysis and IT integration. I specialize in optimizing business processes and implementing strategic financial planning for large enterprises. Dedicated to providing comprehensive market research and strategic planning to optimize business performance.',
        cost: '\$50/hour',
        researchCount: 30,
        articleListCount: 10,
        questionsCount: 12,
      );

      emit(ExpertProfileLoaded(expert));
    } catch (e) {
      emit(ExpertProfileError('Failed to load profile: $e'));
    }
  }
}
