import 'package:flutter/material.dart';
import '../../domain/entities/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Views and Likes
            Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: Color(0xFFB0BACB),
                ),
                const SizedBox(width: 4),
                Text(
                  '${project.viewsCount}',
                  style: const TextStyle(
                    color: Color(0xFFB0BACB),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.thumb_up_outlined,
                  size: 16,
                  color: Color(0xFFB0BACB),
                ),
                const SizedBox(width: 4),
                Text(
                  '${project.likesCount}',
                  style: const TextStyle(
                    color: Color(0xFFB0BACB),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF33354E),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Categories
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                if (project.categories.isNotEmpty)
                  _buildCategoryChip(project.categories.first),
                if (project.categories.length > 1)
                  _buildCountChip('+${project.categories.length - 1}'),
              ],
            ),
            const SizedBox(height: 8),
            // Participants
            _buildParticipantStack(
              project.participantAvatars,
              project.additionalParticipantsCount,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1E88E5),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCountChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF757575),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildParticipantStack(List<String> avatars, int additionalCount) {
    return SizedBox(
      height: 28,
      child: Stack(
        children: [
          for (int i = 0; i < avatars.length && i < 3; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(avatars[i]),
                ),
              ),
            ),
          if (additionalCount > 0)
            Positioned(
              left: (avatars.length > 3 ? 3 : avatars.length) * 14.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF33354E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$additionalCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
