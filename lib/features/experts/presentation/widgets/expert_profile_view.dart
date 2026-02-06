import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expert_profile.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../auth/domain/repositories/auth_repository.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';
import 'project_card.dart';
import 'project_categories_sheet.dart';
import 'project_details_sheet.dart';
import '../utils/category_color_helper.dart';

class ExpertProfileView extends StatelessWidget {
  final ExpertProfile expert;

  const ExpertProfileView({super.key, required this.expert});

  bool _hasData(ExpertProfile expert, int index) {
    switch (index) {
      case 0: // Researches
        return expert.researchCount > 0;
      case 1: // Articles
        return expert.articleListCount > 0;
      case 2: // Project
        return expert.projectsCount > 0;
      case 3: // Reviews
        return expert.reviewsCount > 0;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertProfileBloc, ExpertProfileState>(
      builder: (context, state) {
        final selectedIndex = state is ExpertProfileLoaded
            ? state.selectedIndex
            : 0;
        final currentTabHasData = _hasData(expert, selectedIndex);

        return DefaultTabController(
          length: 4,
          initialIndex: selectedIndex,
          child: Builder(
            builder: (innerContext) {
              Widget buildTabBody() {
                if (!currentTabHasData) {
                  return const SizedBox(height: 80);
                }

                if (selectedIndex == 2) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Color(0xFF33354E),
                        indent: 0,
                        endIndent: 300,
                      ),
                      GestureDetector(
                        onTap: () {
                          final bloc = context.read<ExpertProfileBloc>();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ProjectCategoriesSheet(
                              selectedCategories: const [],
                              onApply: (categories) async {
                                if (categories.isEmpty) {
                                  bloc.add(
                                    LoadExpertProfile(expertId: expert.id),
                                  );
                                  return;
                                }

                                final selectedName = categories.first;
                                final allCategoriesResult = await di
                                    .sl<AuthRepository>()
                                    .getCategories(page: 1, pageSize: 50);

                                int? selectedId;
                                allCategoriesResult.fold((_) {}, (
                                  allCategories,
                                ) {
                                  for (final c in allCategories) {
                                    if (c.name == selectedName) {
                                      selectedId = c.id;
                                      break;
                                    }
                                  }
                                });

                                if (selectedId == null) {
                                  return;
                                }

                                bloc.add(FilterExpertProjects(selectedId!));
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: expert.projects.length,
                          itemBuilder: (context, index) {
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
                          },
                        ),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5, // Mock count
                  itemBuilder: (context, index) {
                    String titlePrefix = 'Item';
                    switch (selectedIndex) {
                      case 0:
                        titlePrefix = 'Research';
                        break;
                      case 1:
                        titlePrefix = 'Article';
                        break;
                      case 2:
                        titlePrefix = 'Question';
                        break;
                      case 3:
                        titlePrefix = 'Review';
                        break;
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
                            '$titlePrefix #${index + 1}',
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
                            'Publication description: ${expert.description.length > 50 ? expert.description.substring(0, 50) : expert.description}...',
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
              }

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: _ExpertHeaderDelegate(
                      expert: expert,
                      canCollapse: true,
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
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'Cost of consultation',
                                expert.cost,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
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
                        indicatorColor: const Color(0xFF33354E),
                        indicatorWeight: 4,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(text: 'Исследования ${expert.researchCount}'),
                          Tab(text: 'Статьи ${expert.articleListCount}'),
                          Tab(text: 'Project ${expert.projectsCount}'),
                          const Tab(text: 'Отзывы'),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey<int>(selectedIndex),
                        child: buildTabBody(),
                      ),
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
  final bool canCollapse;

  _ExpertHeaderDelegate({required this.expert, this.canCollapse = true});

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
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isCollapsed ? 0.0 : 1.0,
            child: SingleChildScrollView(
              // Prevent overflow during shrink
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(expert.imageUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    expert.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33354E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Rating: ',
                        style: TextStyle(
                          color: Color(0xFF33354E),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        expert.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Color(0xFF33354E),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Expert's areas
                  const Text(
                    "Expert's areas",
                    style: TextStyle(
                      color: Color(0xFF33354E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tags
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: () {
                        final entries = expert.areas.asMap().entries.toList();

                        if (entries.length <= 2) {
                          return entries
                              .map(
                                (entry) => _buildTag(
                                  entry.value,
                                  index: entry.key,
                                ),
                              )
                              .toList();
                        }

                        final visibleEntries = entries.take(2).toList();
                        final moreCount = entries.length - 2;

                        return [
                          ...visibleEntries.map(
                            (entry) => _buildTag(
                              entry.value,
                              index: entry.key,
                            ),
                          ),
                          _buildTag(
                            '$moreCount+',
                            isMore: true,
                          ),
                        ];
                      }(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row 1
                  Text(
                    '${expert.articlesCount} articles  •  ${expert.pollsCount} polls  •  ${expert.reviewsCount} reviews  •  ${expert.answersCount} answers',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Collapsed Content (Fades in)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isCollapsed ? 1.0 : 0.0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(expert.imageUrl),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Stats/Rating Row
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${expert.rating}',
                                style: const TextStyle(
                                  color: Color(0xFF33354E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    'Reviews: ${expert.reviewsCount}  Articles: ${expert.articlesCount}  Polls: ${expert.pollsCount}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
                                    ),
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Name
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
                          const SizedBox(height: 6),
                          // Tags Row
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: () {
                                final entries =
                                    expert.areas.asMap().entries.toList();

                                if (entries.length <= 2) {
                                  return entries
                                      .map(
                                        (entry) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 6.0,
                                          ),
                                          child: _buildTag(
                                            entry.value,
                                            index: entry.key,
                                          ),
                                        ),
                                      )
                                      .toList();
                                }

                                final visibleEntries =
                                    entries.take(2).toList();
                                final moreCount = entries.length - 2;

                                return [
                                  ...visibleEntries.map(
                                    (entry) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: _buildTag(
                                        entry.value,
                                        index: entry.key,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(right: 6.0),
                                    child: _buildTag(
                                      '$moreCount+',
                                      isMore: true,
                                    ),
                                  ),
                                ];
                              }(),
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
        ],
      ),
    );
  }

  Widget _buildTag(String text, {bool isMore = false, int index = 0}) {
    Color bgColor;
    Color textColor;

    if (isMore) {
      bgColor = Colors.grey[200]!;
      textColor = Colors.grey[700]!;
    } else {
      final colors = CategoryColorHelper.getColors(index);
      bgColor = colors.$1;
      textColor = colors.$2;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 360;

  @override
  double get minExtent => canCollapse ? 110 : 320;

  @override
  bool shouldRebuild(covariant _ExpertHeaderDelegate oldDelegate) {
    return oldDelegate.canCollapse != canCollapse ||
        oldDelegate.expert != expert;
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
