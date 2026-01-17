import 'package:consultant_app/features/experts/domain/entities/project.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../domain/entities/expert_profile.dart';
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

      final isExpertUser = di.currentUser.value?.userType == 'Expert';
      final expert = isExpertUser
          ? ExpertProfile(
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
              projects: [
                Project(
                  id: 'p-1',
                  title: 'Modern development methodology has dotted all the i\'s',
                  description:
                      'In general, of course, the new model of organizational activity creates prerequisites for the prioritization of reason over emotions.',
                  participantAvatars: [
                    'https://i.pravatar.cc/150?u=11',
                    'https://i.pravatar.cc/150?u=12',
                    'https://i.pravatar.cc/150?u=13',
                  ],
                  additionalParticipantsCount: 3,
                  commentsCount: 104,
                  date: DateTime.now().subtract(const Duration(minutes: 30)),
                ),
                Project(
                  id: 'p-2',
                  title: 'Another interesting project about AI',
                  description:
                      'Artificial intelligence is reshaping how we approach complex problems in modern software engineering.',
                  participantAvatars: [
                    'https://i.pravatar.cc/150?u=14',
                    'https://i.pravatar.cc/150?u=15',
                  ],
                  additionalParticipantsCount: 0,
                  commentsCount: 42,
                  date: DateTime.now().subtract(const Duration(hours: 2)),
                ),
                Project(
                  id: 'p-3',
                  title: 'Digital Transformation in Banking Sector',
                  description:
                      'Implementing modern digital solutions to streamline banking operations and improve customer experience.',
                  participantAvatars: [
                    'https://i.pravatar.cc/150?u=16',
                    'https://i.pravatar.cc/150?u=17',
                    'https://i.pravatar.cc/150?u=18',
                    'https://i.pravatar.cc/150?u=19',
                  ],
                  additionalParticipantsCount: 5,
                  commentsCount: 89,
                  date: DateTime.now().subtract(const Duration(days: 1)),
                ),
                Project(
                  id: 'p-4',
                  title: 'Blockchain for Financial Transactions',
                  description:
                      'Exploring the potential of blockchain technology to secure and speed up international money transfers.',
                  participantAvatars: [
                    'https://i.pravatar.cc/150?u=20',
                    'https://i.pravatar.cc/150?u=21',
                  ],
                  additionalParticipantsCount: 1,
                  commentsCount: 56,
                  date: DateTime.now().subtract(const Duration(days: 3)),
                ),
                Project(
                  id: 'p-5',
                  title: 'AI-driven Credit Scoring Model',
                  description:
                      'Developing a machine learning model to assess credit risk more accurately using alternative data sources.',
                  participantAvatars: [
                    'https://i.pravatar.cc/150?u=22',
                    'https://i.pravatar.cc/150?u=23',
                    'https://i.pravatar.cc/150?u=24',
                  ],
                  additionalParticipantsCount: 2,
                  commentsCount: 34,
                  date: DateTime.now().subtract(const Duration(days: 5)),
                ),
              ],
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
