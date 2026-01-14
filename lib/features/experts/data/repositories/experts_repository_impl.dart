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
          name: 'Alexander Alexandrov',
          avatarUrl: 'https://i.pravatar.cc/150?img=11',
          rating: 4.5,
          reviewsCount: 24,
          articlesCount: 10,
          pollsCount: 30,
          tags: ['Finance', 'Banking', 'IT', '+6'],
          description:
              'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
          price: 1000,
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
}
