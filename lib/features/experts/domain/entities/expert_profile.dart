import 'project.dart';

class ExpertProfile {
  final String id;
  final String name;
  final double rating;
  final String imageUrl;
  final List<String> areas;
  final int articlesCount;
  final int pollsCount;
  final int reviewsCount;
  final int answersCount;
  final String education;
  final String experience;
  final String description;
  final String cost;
  final int researchCount;
  final int
  articleListCount; // "Articles 10" in stats vs list count? Design shows "Researches 30", "Articles 10", "Questions 12" tab like headers
  final int questionsCount;
  final int projectsCount;
  final List<Project> projects;

  const ExpertProfile({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.areas,
    required this.articlesCount,
    required this.pollsCount,
    required this.reviewsCount,
    required this.answersCount,
    required this.education,
    required this.experience,
    required this.description,
    required this.cost,
    required this.researchCount,
    required this.articleListCount,
    required this.questionsCount,
    required this.projectsCount,
    this.projects = const [],
  });

  ExpertProfile copyWith({
    String? id,
    String? name,
    double? rating,
    String? imageUrl,
    List<String>? areas,
    int? articlesCount,
    int? pollsCount,
    int? reviewsCount,
    int? answersCount,
    String? education,
    String? experience,
    String? description,
    String? cost,
    int? researchCount,
    int? articleListCount,
    int? questionsCount,
    int? projectsCount,
    List<Project>? projects,
  }) {
    return ExpertProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      areas: areas ?? this.areas,
      articlesCount: articlesCount ?? this.articlesCount,
      pollsCount: pollsCount ?? this.pollsCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      answersCount: answersCount ?? this.answersCount,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      researchCount: researchCount ?? this.researchCount,
      articleListCount: articleListCount ?? this.articleListCount,
      questionsCount: questionsCount ?? this.questionsCount,
      projectsCount: projectsCount ?? this.projectsCount,
      projects: projects ?? this.projects,
    );
  }
}
