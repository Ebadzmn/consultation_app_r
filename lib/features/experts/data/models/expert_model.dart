import 'package:consultant_app/core/network/api_client.dart';
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

  factory ExpertModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';

    final firstName = (json['first_name'] ?? '').toString().trim();
    final lastName = (json['last_name'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();

    final rawAbout = (json['about'] ?? '').toString();
    final description = rawAbout
        .replaceAll(
          RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false),
          '',
        )
        .trim();

    final rating = (json['rating'] as num?)?.toDouble() ?? 0.0;
    final reviewsCount = (json['reviews_cnt'] as num?)?.toInt() ?? 0;
    final articlesCount = (json['article_cnt'] as num?)?.toInt() ?? 0;
    final pollsCount = (json['surveys_cnt'] as num?)?.toInt() ?? 0;
    final price = (json['hour_cost'] as num?)?.toInt() ?? 0;

    final categories = json['categories'];
    List<String> tags = [];
    if (categories is List) {
      tags = categories
          .map((e) => e is int ? e : int.tryParse(e.toString()))
          .whereType<int>()
          .map((id) => _categoryNamesById[id] ?? 'Категория $id')
          .toList();
    }

    final avatarUrlRaw = (json['avatar_url'] as String?)?.trim();
    final s = avatarUrlRaw ?? '';
    String avatarUrl;
    if (s.isEmpty) {
      avatarUrl = 'https://i.pravatar.cc/150?u=$id';
    } else if (s.startsWith('http://') || s.startsWith('https://')) {
      avatarUrl = s;
    } else {
      final uri = Uri.parse(ApiClient.baseUrl);
      final origin = '${uri.scheme}://${uri.host}';
      avatarUrl = '$origin$s';
    }

    return ExpertModel(
      id: id,
      name: fullName.isNotEmpty ? fullName : 'Expert $id',
      avatarUrl: avatarUrl,
      rating: rating,
      reviewsCount: reviewsCount,
      articlesCount: articlesCount,
      pollsCount: pollsCount,
      tags: tags,
      description: description,
      price: price,
    );
  }

  static const Map<int, String> _categoryNamesById = {
    1: 'ИТ',
    2: 'Финансы',
    3: 'Банки',
    4: 'Бизнес-коучинг',
    5: 'Юридические консультации',
    6: 'PR и маркетинг',
  };
}
