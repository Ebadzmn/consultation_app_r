import '../../domain/entities/expert_entity.dart';

class ExpertModel extends ExpertEntity {
  const ExpertModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.rating,
    required super.reviewsCount,
    required super.articlesCount,
    required super.pollsCount,
    required super.tags,
    required super.description,
    required super.price,
  });

  // Mocking data so no need for fromJson/toJson for now, 
  // but good to have if we were using real API.
}
