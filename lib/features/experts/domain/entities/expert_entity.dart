import 'package:equatable/equatable.dart';

class ExpertEntity extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final int reviewsCount;
  final int articlesCount;
  final int pollsCount;
  final List<String> tags;
  final List<int> categoryIds;
  final String description;
  final int price;

  const ExpertEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.reviewsCount,
    required this.articlesCount,
    required this.pollsCount,
    required this.tags,
    this.categoryIds = const [],
    required this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        rating,
        reviewsCount,
        articlesCount,
        pollsCount,
        tags,
        categoryIds,
        description,
        price,
      ];
}
