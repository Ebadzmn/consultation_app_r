import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expert_entity.dart';
import '../../domain/repositories/experts_repository.dart';
import '../models/expert_model.dart';

class ExpertsRepositoryImpl implements ExpertsRepository {
  @override
  Future<Either<Failure, List<ExpertEntity>>> getExperts() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final mockExperts = [
        const ExpertModel(
          id: '1',
          name: 'Alexander Alexandrov',
          avatarUrl: 'https://i.pravatar.cc/150?img=11', // Placeholder
          rating: 4.5,
          reviewsCount: 24,
          articlesCount: 10,
          pollsCount: 30,
          tags: ['Finance', 'Banking', 'IT', '+6'],
          description: 'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
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
          description: 'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
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
          description: 'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
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
          description: 'In our pursuit of improving user experience we miss that interactive prototypes are exposed...',
          price: 1000,
        ),
      ];

      return Right(mockExperts);
    } catch (e) {
      return const Left(ServerFailure('Failed to load experts'));
    }
  }
}
