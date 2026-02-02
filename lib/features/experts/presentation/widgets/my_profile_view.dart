import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:consultant_app/features/experts/domain/entities/expert_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import 'package:go_router/go_router.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';
import 'project_card.dart';
import 'project_categories_sheet.dart';
import 'project_details_sheet.dart';
import '../utils/category_color_helper.dart';

import '../pages/profile_settings_page.dart';

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
        case 2: // Project
          return expert.projectsCount > 0;
        case 3: // Questions
          return expert.questionsCount > 0;
        case 4: // Reviews
          return expert.reviewsCount > 0;
        case 5: // Appointments
          return false;
        case 6: // Notifications
          return false;
        case 7: // Your rating
          return false;
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
            Tab(text: 'Исследования ${expert.researchCount}'),
            Tab(text: 'Статьи ${expert.articlesCount}'),
            Tab(text: 'Project ${expert.projectsCount}'),
            Tab(text: 'Questions ${expert.questionsCount}'),
            Tab(text: 'Отзывы ${expert.reviewsCount}'),
            const Tab(text: 'Appointments'),
            const Tab(text: 'Notifications 0'),
            Tab(text: 'Your rating ${expert.rating}'),
          ]
        : [
            const Tab(text: 'Notifications'),
            const Tab(text: 'Appointments'),
            Tab(text: 'Reviews ${expert.reviewsCount}'),
            Tab(text: 'Questions ${expert.questionsCount}'),
          ];

    return BlocBuilder<ExpertProfileBloc, ExpertProfileState>(
      builder: (context, state) {
        final selectedIndex = state is ExpertProfileLoaded
            ? state.selectedIndex
            : 0;
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
                  'my_profile_scroll_${isExpert}_${safeIndex}_$currentTabHasData',
                ),
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
                                _buildInfoRow('Consultation Cost', expert.cost),
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
                        tabAlignment: TabAlignment.start,
                        padding: EdgeInsets.zero,
                        onTap: (index) {
                          context.read<ExpertProfileBloc>().add(
                            ExpertProfileTabChanged(index),
                          );
                        },
                        isScrollable: true,
                        labelColor: const Color(0xFF33354E),
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        indicatorWeight: 4,
                        dividerColor: Colors.transparent,
                        tabs: tabs,
                      ),
                    ),
                    pinned: true,
                  ),
                  if (isExpert && safeIndex == 2)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => ProjectCategoriesSheet(
                                  selectedCategories: const [],
                                  onApply: (categories) {
                                    // Handle logic if needed
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sort,
                                    color: Color(0xFF66BB6A),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'All categories',
                                    style: TextStyle(
                                      color: Color(0xFF66BB6A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          itemCount: (isExpert && safeIndex == 2) ? 0 : 15,
                          itemBuilder: (context, index) {
                            if (isExpert && safeIndex == 2) {
                              return const SizedBox.shrink();
                            }

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
                  if (isExpert && safeIndex == 2 && currentTabHasData)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.1,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final project = expert.projects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    ProjectDetailsSheet(project: project),
                              );
                            },
                          );
                        }, childCount: expert.projects.length),
                      ),
                    ),
                  // Add extra padding at bottom to avoid content being hidden behind the button
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
          ),
        );
      },
    );
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
                          children: expert.areas.asMap().entries.map((entry) {
                            final colors = CategoryColorHelper.getColors(
                              entry.key,
                            );

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colors.$1,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  color: colors.$2,
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
                          onPressed: () async {
                            final result = await di
                                .sl<AuthRepository>()
                                .logout();
                            result.fold(
                              (failure) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(failure.message)),
                                  ),
                              (_) {
                                di.currentUser.value = null;
                                context.go(AppRoutes.signIn);
                              },
                            );
                          },
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
