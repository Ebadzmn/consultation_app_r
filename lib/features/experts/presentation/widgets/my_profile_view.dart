import 'package:consultant_app/features/experts/domain/entities/expert_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../domain/entities/project.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_routes.dart';
import '../pages/profile_settings_page.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';

class MyProfileView extends StatelessWidget {
  final ExpertProfile expert;

  const MyProfileView({super.key, required this.expert});

  bool _hasData(ExpertProfile expert, int index, bool isExpert) {
    if (isExpert) {
      // Expert Tabs: Researches, Articles, Questions, Reviews, Projects, Appointments, Notifications, Your rating
      switch (index) {
        case 0: // Researches
          return expert.researchCount > 0;
        case 1: // Articles
          return expert.articleListCount > 0;
        case 2: // Questions
          return expert.questionsCount > 0;
        case 3: // Reviews
          return expert.reviewsCount > 0;
        case 4: // Projects
          return expert.projectsCount > 0;
        case 5: // Appointments
          return false; // Assuming no data for now, or check specific list
        case 6: // Notifications
          return false;
        case 7: // Your rating
          return false; // Just a rating view, maybe always show content?
        default:
          return false;
      }
    } else {
      // Client Tabs: Notifications, Appointments, Reviews, Questions
      switch (index) {
        case 0: // Notifications
          return false;
        case 1: // Appointments
          return false;
        case 2: // Reviews
          return expert.reviewsCount > 0;
        case 3: // Questions
          return expert.questionsCount > 0;
        default:
          return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpert = di.currentUser.value?.userType == 'Expert';

    final tabs = isExpert
        ? [
            Tab(text: 'Researches ${expert.researchCount}'),
            Tab(text: 'Articles ${expert.articleListCount}'),
            Tab(text: 'Questions ${expert.questionsCount}'),
            Tab(text: 'Reviews ${expert.reviewsCount}'),
            Tab(text: 'Projects ${expert.projectsCount}'),
            const Tab(text: 'Appointments'),
            const Tab(text: 'Notifications 0'),
            Tab(text: 'Your rating ${expert.rating}'),
          ]
        : [
            const Tab(text: 'Notifications'),
            const Tab(text: 'Appointments'),
            const Tab(text: 'Reviews'),
            Tab(text: 'Questions ${expert.questionsCount}'),
          ];

    return BlocBuilder<ExpertProfileBloc, ExpertProfileState>(
      builder: (context, state) {
        final selectedIndex =
            state is ExpertProfileLoaded ? state.selectedIndex : 0;
        // Ensure index is valid for current tabs
        final safeIndex = selectedIndex >= tabs.length ? 0 : selectedIndex;
        final currentTabHasData = _hasData(expert, safeIndex, isExpert);

        return DefaultTabController(
          length: tabs.length,
          initialIndex: safeIndex,
          child: Builder(
            builder: (innerContext) {
              return CustomScrollView(
                key: ValueKey(
                    'my_profile_scroll_${isExpert}_${safeIndex}_${currentTabHasData}'),
                physics: currentTabHasData
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: _ExpertHeaderDelegate(
                      expert: expert,
                      isExpert: isExpert,
                      canCollapse: currentTabHasData,
                    ),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Education', expert.education),
                              const SizedBox(height: 16),
                              _buildInfoRow('Experience', expert.experience),
                              const SizedBox(height: 16),
                              Text(
                                expert.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Color(0xFF33354E),
                                ),
                              ),
                              if (isExpert) ...[
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                    'Consultation Cost', expert.cost),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _StickyTabBarDelegate(
                      TabBar(
                        onTap: (index) {
                          context
                              .read<ExpertProfileBloc>()
                              .add(ExpertProfileTabChanged(index));
                        },
                        isScrollable: true,
                        labelColor: const Color(0xFF33354E),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF33354E),
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        tabs: tabs,
                      ),
                    ),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        if (!currentTabHasData) {
                          return const SizedBox(height: 80);
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (isExpert && selectedIndex == 4)
                              ? expert.projects.length
                              : 15,
                          itemBuilder: (context, index) {
                            if (isExpert && selectedIndex == 4) {
                              return _buildProjectCard(
                                  context, expert.projects[index]);
                            }

                            String titlePrefix = 'Item';
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${expert.questionsCount > index ? "Question" : "Item"} #$index',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF33354E),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'What % of the total budget goes to operating expenses in IT in the banking sector? (Item $index)',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF33354E),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Publication description: ${expert.description.substring(0, 50)}...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '104',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '30 minutes ago',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 32),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Add extra padding at bottom to avoid content being hidden behind the button
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.projectDetails),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33354E),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (project.participantAvatars.isNotEmpty)
                  SizedBox(
                    width: 96,
                    height: 32,
                    child: Stack(
                      children: [
                        for (int i = 0;
                            i <
                                (project.participantAvatars.length > 3
                                    ? 3
                                    : project.participantAvatars.length);
                            i++)
                          Positioned(
                            left: i * 20.0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  NetworkImage(project.participantAvatars[i]),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        if (project.additionalParticipantsCount > 0)
                          Positioned(
                            left: 60.0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF33354E),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '+${project.additionalParticipantsCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                const Spacer(),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  '${project.commentsCount}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(project.date),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF33354E),
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _ExpertHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ExpertProfile expert;
  final bool isExpert;
  final bool canCollapse;

  _ExpertHeaderDelegate({
    required this.expert,
    required this.isExpert,
    this.canCollapse = true,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double progress = shrinkOffset / maxExtent;
    // progress 0 = expanded, 1 = collapsed

    // Check if collapsed enough to switch view
    final bool isCollapsed = progress > 0.5; // Threshold to switch layout

    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Expanded Content (Fades out)
          IgnorePointer(
            ignoring: isCollapsed,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isCollapsed ? 0.0 : 1.0,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(expert.imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expert.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    if (isExpert) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Rating: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF33354E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            expert.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF33354E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Expert in:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF33354E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: expert.areas.map((area) {
                            // Cycle through some colors for chips to match design vibe
                            final colors = [
                              const Color(0xFFFFF4E5), // Light orange
                              const Color(0xFFE8F5E9), // Light green
                              const Color(0xFFE3F2FD), // Light blue
                            ];
                            final color = colors[
                                expert.areas.indexOf(area) % colors.length];
                            
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                area,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${expert.articleListCount} articles • ${expert.pollsCount} polls • ${expert.reviewsCount} reviews • ${expert.answersCount} answers',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      Text(
                        'Client',
                        style: TextStyle(
                          color: Color(0xFF33354E),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileSettingsPage(expert: expert),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF33354E),
                            side: const BorderSide(color: Color(0xFF33354E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Profile Settings'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFEBEE),
                            foregroundColor: Colors.red[400],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Collapsed Content (Fades in)
          IgnorePointer(
            ignoring: !isCollapsed,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isCollapsed ? 1.0 : 0.0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(expert.imageUrl),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              expert.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF33354E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isExpert ? 'Expert' : 'Client',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF33354E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => isExpert ? 420 : 260; 

  @override
  double get minExtent => canCollapse ? 80 : (isExpert ? 420 : 260);

  @override
  bool shouldRebuild(covariant _ExpertHeaderDelegate oldDelegate) {
    return oldDelegate.canCollapse != canCollapse ||
        oldDelegate.expert != expert ||
        oldDelegate.isExpert != isExpert;
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _StickyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
