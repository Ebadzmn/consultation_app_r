import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../../domain/entities/expert_entity.dart';

class ExpertCard extends StatelessWidget {
  final ExpertEntity expert;

  const ExpertCard({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
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
                        const Icon(Icons.star, color: Color(0xFFFBC02D), size: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      expert.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E2E3E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: expert.tags.map((tag) => _buildTag(tag)).toList(),
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
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF9E9E9E),
      ),
    );
  }

  Widget _buildTag(String text) {
    Color backgroundColor;
    Color textColor;
    switch (text.toLowerCase()) {
      case 'finance':
        backgroundColor = const Color(0xFFFFF59D);
        textColor = const Color(0xFFF59D00);
        break;
      case 'banking':
        backgroundColor = const Color(0xFFC8E6C9); // Light Green
        textColor = const Color(0xFF2E7D32);  
        break;
      case 'it':
        backgroundColor = const Color(0xFFBBDEFB); // Light Blue
        textColor = const Color(0xFF1976D2);        
        break;
      default:
        backgroundColor = const Color(0xFFF5F5F5); // Light Grey
        textColor = const Color(0xFF2E2E3E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
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

  String _formatPrice(int price) {
    // Simple formatter, in real app use NumberFormat
    return '$price P';
  }
}
