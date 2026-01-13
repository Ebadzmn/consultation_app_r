import 'package:flutter/material.dart';
import '../../domain/entities/project.dart';

class ProjectDetailsSheet extends StatelessWidget {
  final Project project;

  const ProjectDetailsSheet({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Детали проекта',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            project.categories.isNotEmpty
                                ? project.categories.first
                                : 'ИИ / ML',
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _buildStatIcon(Icons.calendar_today_outlined, '2025'),
                        const SizedBox(width: 16),
                        _buildStatIcon(
                          Icons.visibility_outlined,
                          '${project.viewsCount}',
                        ),
                        const SizedBox(width: 16),
                        _buildStatIcon(
                          Icons.thumb_up_outlined,
                          '${project.likesCount}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Participants
                    const Text(
                      'Participants',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAFB2C5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildParticipantsList(),
                    const SizedBox(height: 8),
                    const Text(
                      'Показать всех',
                      style: TextStyle(
                        color: Color(0xFF66BB6A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Company
                    const Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAFB2C5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ООО “ИИ Новокузнецк”',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      'Описание',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAFB2C5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF33354E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Materials
                    const Text(
                      'Материалы проекта',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAFB2C5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMaterialItem('Презентация.pdf'),
                    const SizedBox(height: 8),
                    _buildMaterialItem('Отчет_по_проекту.pdf'),
                    const SizedBox(height: 24),

                    // Like Section Footer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Понравился проект?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF33354E),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.thumb_up,
                            color: Color(0xFFB0B3C7),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${project.likesCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB0B3C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFAFB2C5)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAFB2C5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildParticipantsList() {
    final names = [
      'Александр Александров',
      'Анастасия Иванова',
      'Константин Константинов',
    ];
    return names
        .map(
          (name) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildMaterialItem(String fileName) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Color(0xFFAFB2C5), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF33354E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
