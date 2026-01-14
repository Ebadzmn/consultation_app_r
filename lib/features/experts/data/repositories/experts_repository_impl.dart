import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expert_entity.dart';
import '../../domain/repositories/experts_repository.dart';
import '../models/expert_model.dart';
import '../data_sources/experts_remote_data_source.dart';
import '../../domain/entities/available_work_dates_entity.dart';

class ExpertsRepositoryImpl implements ExpertsRepository {
  final ExpertsRemoteDataSource remoteDataSource;

  ExpertsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<ExpertEntity>>> getExperts() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final mockExperts = [
        const ExpertModel(
          id: '1',
          name: 'Alexander Alexandrov',
          avatarUrl: 'https://i.pravatar.cc/150?img=11',
          rating: 4.5,
          reviewsCount: 24,
          articlesCount: 10,
          pollsCount: 30,
          tags: ['Finance', 'Banking', 'IT', '+6'],
          description:
              'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
          price: 10000,
        ),
        const ExpertModel(
          id: '2',
          name: 'Konstantin Sergeev',
          avatarUrl: 'https://i.pravatar.cc/150?img=13',
          rating: 4.5,
          reviewsCount: 24,
          articlesCount: 10,
          pollsCount: 30,
          tags: ['IT', 'Finance', 'Banking'],
          description:
              'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
          price: 50000,
        ),
        const ExpertModel(
          id: '3',
          name: 'Maria Petrova',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          rating: 4.5,
          reviewsCount: 24,
          articlesCount: 10,
          pollsCount: 30,
          tags: ['Finance', 'Banking'],
          description:
              'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
          price: 3000,
        ),
        const ExpertModel(
          id: '4',
          name: 'Ivan Smirnov',
          avatarUrl: 'https://i.pravatar.cc/150?img=18',
          rating: 4.5,
          reviewsCount: 24,
          articlesCount: 10,
          pollsCount: 30,
          tags: ['Finance', 'Banking', 'IT', '+6'],
          description:
              'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
          price: 1000,
        ),
        const ExpertModel(
          id: '5',
          name: 'Dmitry Ivanov',
          avatarUrl: 'https://i.pravatar.cc/150?img=21',
          rating: 4.2,
          reviewsCount: 18,
          articlesCount: 8,
          pollsCount: 20,
          tags: ['IT', 'Startups'],
          description:
              'Helps early-stage startups with product strategy and technical architecture.',
          price: 15000,
        ),
        const ExpertModel(
          id: '6',
          name: 'Olga Sidorova',
          avatarUrl: 'https://i.pravatar.cc/150?img=29',
          rating: 4.8,
          reviewsCount: 40,
          articlesCount: 15,
          pollsCount: 50,
          tags: ['Marketing', 'Branding'],
          description:
              'Brand and marketing strategist with focus on digital promotion.',
          price: 8000,
        ),
        const ExpertModel(
          id: '7',
          name: 'Sergey Kuznetsov',
          avatarUrl: 'https://i.pravatar.cc/150?img=35',
          rating: 4.3,
          reviewsCount: 19,
          articlesCount: 6,
          pollsCount: 17,
          tags: ['Banking', 'Risk'],
          description:
              'Expert in banking risk management and regulatory compliance.',
          price: 12000,
        ),
        const ExpertModel(
          id: '8',
          name: 'Ekaterina Volkova',
          avatarUrl: 'https://i.pravatar.cc/150?img=41',
          rating: 4.9,
          reviewsCount: 52,
          articlesCount: 22,
          pollsCount: 60,
          tags: ['HR', 'Coaching'],
          description:
              'Helps managers with career development and team communications.',
          price: 6000,
        ),
        const ExpertModel(
          id: '9',
          name: 'Andrey Pavlov',
          avatarUrl: 'https://i.pravatar.cc/150?img=48',
          rating: 4.4,
          reviewsCount: 27,
          articlesCount: 9,
          pollsCount: 25,
          tags: ['Project Management', 'Agile'],
          description:
              'Practical guidance on agile transformations and project delivery.',
          price: 9000,
        ),
        const ExpertModel(
          id: '10',
          name: 'Natalia Romanova',
          avatarUrl: 'https://i.pravatar.cc/150?img=52',
          rating: 4.6,
          reviewsCount: 33,
          articlesCount: 12,
          pollsCount: 28,
          tags: ['Finance', 'Investments'],
          description:
              'Consults on personal investments and long-term financial planning.',
          price: 20000,
        ),
      ];

      return Right(mockExperts);
    } catch (e) {
      return const Left(ServerFailure('Failed to load experts'));
    }
  }

  @override
  Future<Either<Failure, AvailableWorkDatesEntity>> getAvailableWorkDates(
    String expertId,
  ) async {
    try {
      final result = await remoteDataSource.getAvailableWorkDates(expertId);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Failed to load available dates'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableTimeSlots({
    required String expertId,
    required DateTime selectedDate,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableTimeSlots(
        expertId,
        selectedDate,
      );
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Failed to load available timeslots'));
    }
  }

  @override
  Future<Either<Failure, void>> createAppointment({
    required String expertId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int categoryId,
    required String notes,
  }) async {
    try {
      await remoteDataSource.createAppointment(
        expertId: expertId,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        categoryId: categoryId,
        notes: notes,
      );
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to create appointment'));
    }
  }
}
