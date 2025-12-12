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
  });
}
