import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33354E),
        elevation: 0,
        leadingWidth: 150,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Row(
            children: const [
              SizedBox(width: 16),
              Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              SizedBox(width: 4),
              Text(
                'На главную',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF90A4AE),
                ),
                const SizedBox(width: 8),
                const Text(
                  'сегодня в 16:30',
                  style: TextStyle(
                    color: Color(0xFF90A4AE),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Финансы',
                    style: TextStyle(
                      color: Color(0xFFFB8C00),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Современная методология разработки расставила все точки над i',
              style: TextStyle(
                color: Color(0xFF33354E),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Участники проекта',
              style: TextStyle(
                color: Color(0xFF90A4AE),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            _buildParticipantRow(
              'Александр Александров',
              'https://i.pravatar.cc/150?img=11',
            ),
            const SizedBox(height: 12),
            _buildParticipantRow(
              'Анастасия Иванова',
              'https://i.pravatar.cc/150?img=5',
            ),
            const SizedBox(height: 12),
            _buildParticipantRow(
              'Константин Константинов',
              'https://i.pravatar.cc/150?img=3',
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Показать всех',
                style: TextStyle(
                  color: Color(0xFF66BB6A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Сложно сказать, почему активно развивающиеся страны третьего мира представляют собой не что иное, как квинтэссенцию победы маркетинга над разумом и должны быть объявлены нарушающими общечеловеческие нормы этики и морали!',
              style: TextStyle(
                color: Color(0xFF33354E),
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1519681393784-d120267933ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Подпись под фото',
              style: TextStyle(
                color: Color(0xFF90A4AE),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'H2-заголовок',
              style: TextStyle(
                color: Color(0xFF33354E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Пример сплошного текста: Как уже неоднократно упомянуто, тщательные исследования конкурентов будут разоблачены. И нет сомнений, что предприниматели в сети интернет, вне зависимости от их уровня, должны быть функционально разнесены на независимые элементы. Высокий уровень вовлечения представителей целевой аудитории является четким доказательством простого факта: убеждённость некоторых оппонентов не оставляет шанса для прогресса профессионального сообщества.',
              style: TextStyle(
                color: Color(0xFF33354E),
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '104 КОММЕНТАРИЯ',
                  style: TextStyle(
                    color: Color(0xFF90A4AE),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                  ),
                ),
                Row(
                  children: const [
                    Text(
                      'Новые',
                      style: TextStyle(
                        color: Color(0xFF90A4AE),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Популярные',
                      style: TextStyle(
                        color: Color(0xFF33354E),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Написать комментарий',
                style: TextStyle(
                  color: Color(0xFF90A4AE),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Comments List
            _buildCommentItem(),
            const SizedBox(height: 24),
            _buildCommentItem(),
            const SizedBox(height: 24),
            _buildCommentItem(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF33354E),
                  side: const BorderSide(color: Color(0xFFCFD8DC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Раскрыть все комментарии',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'ЕЩЁ СТАТЬИ',
              style: TextStyle(
                color: Color(0xFF90A4AE),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            _buildArticleCard(),
            const SizedBox(height: 24),
            _buildArticleCard(),
            const SizedBox(height: 24),
            _buildArticleCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF33354E),
                  side: const BorderSide(color: Color(0xFFCFD8DC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Больше статей',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Современная методология разработки расставила все точки над i',
          style: TextStyle(
            color: Color(0xFF33354E),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'В целом, конечно, новая модель организационной деятельности создаёт предпосылки для приоритизации разума над эмоциями.',
          style: TextStyle(
            color: Color(0xFF33354E),
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://images.unsplash.com/photo-1519681393784-d120267933ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline,
                size: 16, color: Color(0xFF90A4AE)),
            const SizedBox(width: 4),
            const Text(
              '104',
              style: TextStyle(
                color: Color(0xFF90A4AE),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16, color: Color(0xFF90A4AE)),
            const SizedBox(width: 4),
            const Text(
              '30 минут назад',
              style: TextStyle(
                color: Color(0xFF90A4AE),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Георгий Георгиев',
                    style: TextStyle(
                      color: Color(0xFF33354E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '8 мин назад',
                    style: TextStyle(
                      color: Color(0xFF90A4AE),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF90A4AE), size: 20),
            const SizedBox(width: 4),
            const Text(
              '+10',
              style: TextStyle(
                color: Color(0xFF66BB6A),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_up,
                color: Color(0xFF90A4AE), size: 20),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Сложно сказать, почему активно развивающиеся страны третьего мира ограничены исключительно образом мышления. Принимая во внимание показатели успешности, высокотехнологичная концепция общественного уклада не даёт нам иного выбора, кроме определения глубокомысленных рассуждений.',
          style: TextStyle(
            color: Color(0xFF33354E),
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Ответить',
                style: TextStyle(
                  color: Color(0xFF9FA8DA),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {},
              child: const Text(
                '10 ответов',
                style: TextStyle(
                  color: Color(0xFF9FA8DA),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParticipantRow(String name, String avatarUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF33354E),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
