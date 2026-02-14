import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../../../auth/domain/entities/category_entity.dart';
import '../../domain/entities/expert_entity.dart';

class ExpertCard extends StatelessWidget {
  final ExpertEntity expert;
  final Map<int, CategoryEntity> categoriesById;

  const ExpertCard({
    super.key,
    required this.expert,
    required this.categoriesById,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 10,
        left: 12,
        right: 12,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(expert.avatarUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFBC02D),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${expert.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF2E2E3E),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatText('Reviews: ${expert.reviewsCount}'),
                        const SizedBox(width: 8),
                        _buildStatText('Articles: ${expert.articlesCount}'),
                        const SizedBox(width: 8),
                        _buildStatText('Polls: ${expert.pollsCount}'),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expert.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E2E3E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: () {
                        final categoryIds = expert.categoryIds;
                        if (categoryIds.isNotEmpty &&
                            categoriesById.isNotEmpty) {
                          if (categoryIds.length <= 2) {
                            return categoryIds
                                .map((id) => _buildCategoryTag(id))
                                .toList();
                          }

                          final visible = categoryIds.take(2).toList();
                          final moreCount = categoryIds.length - 2;

                          return [
                            ...visible.map((id) => _buildCategoryTag(id)),
                            _buildTag('$moreCount+'),
                          ];
                        }

                        final tags = expert.tags;
                        if (tags.length <= 2) {
                          return tags.map((tag) => _buildTag(tag)).toList();
                        }

                        return [
                          ...tags.take(2).map((tag) => _buildTag(tag)),
                          _buildTag('${tags.length - 2}+'),
                        ];
                      }(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            expert.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575), // Grey color for description
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Consultation price',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatPrice(expert.price)}/hour',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E3E),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.appointment, extra: expert);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A), // Green button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Consultation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }

  Widget _buildStatText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
    );
  }

  Widget _buildTag(String text) {
    final List<Map<String, Color>> tagColors = [
      {
        'bg': const Color(0xFFFFF59D),
        'text': const Color(0xFFF59D00),
      }, // Yellow
      {'bg': const Color(0xFFC8E6C9), 'text': const Color(0xFF2E7D32)}, // Green
      {'bg': const Color(0xFFBBDEFB), 'text': const Color(0xFF1976D2)}, // Blue
      {
        'bg': const Color(0xFFE1BEE7),
        'text': const Color(0xFF7B1FA2),
      }, // Purple
      {
        'bg': const Color(0xFFFFCCBC),
        'text': const Color(0xFFD84315),
      }, // Deep Orange
      {'bg': const Color(0xFFB2DFDB), 'text': const Color(0xFF00695C)}, // Teal
      {'bg': const Color(0xFFFFCDD2), 'text': const Color(0xFFC62828)}, // Red
      {
        'bg': const Color(0xFFCFD8DC),
        'text': const Color(0xFF37474F),
      }, // Blue Grey
    ];

    final index = text.hashCode.abs() % tagColors.length;
    final color = tagColors[index];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color['bg'],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color['text'],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCategoryTag(int categoryId) {
    final category = categoriesById[categoryId];
    final label = (category?.name ?? '').trim();
    final text = label.isNotEmpty ? label : 'Category $categoryId';

    final parsed = _tryParseHexColor(category?.color);
    if (parsed == null) {
      return _buildTag(text);
    }

    final hsl = HSLColor.fromColor(parsed);
    final textColor = hsl
        .withLightness((hsl.lightness * 0.45).clamp(0.22, 0.42))
        .withSaturation((hsl.saturation * 1.05).clamp(0.25, 1.0))
        .toColor();

    final bg = parsed.withAlpha(150);
    final border = textColor.withAlpha(220);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color? _tryParseHexColor(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    var hex = raw;
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.startsWith('0x') || hex.startsWith('0X')) {
      hex = hex.substring(2);
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length != 8) {
      return null;
    }

    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) {
      return null;
    }
    return Color(parsed);
  }

  String _formatPrice(int price) {
    // Simple formatter, in real app use NumberFormat
    return '$price P';
  }
}
