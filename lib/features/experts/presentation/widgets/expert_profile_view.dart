import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expert_profile.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';

class ExpertProfileView extends StatelessWidget {
  final ExpertProfile expert;

  const ExpertProfileView({super.key, required this.expert});

  bool _hasData(ExpertProfile expert, int index) {
    switch (index) {
      case 0: // Research
        return expert.researchCount > 0;
      case 1: // Articles
        return expert.articleListCount > 0;
      case 2: // Projects
        return expert.projectsCount > 0;
      case 3: // Questions
        return expert.questionsCount > 0;
      case 4: // Notifications
        return false;
      case 5: // Appointments
        return false;
      case 6: // Reviews
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
          length: 7,
          initialIndex: selectedIndex,
          child: Builder(
            builder: (innerContext) {
              return CustomScrollView(
                key: ValueKey(
                  'expert_profile_scroll_${selectedIndex}_${currentTabHasData}',
                ),
                physics: currentTabHasData
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: _ExpertHeaderDelegate(
                      expert: expert,
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
                        onTap: (index) {
                          context.read<ExpertProfileBloc>().add(
                            ExpertProfileTabChanged(index),
                          );
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
                        tabs: [
                          Tab(text: 'Research ${expert.researchCount}'),
                          Tab(text: 'Articles ${expert.articleListCount}'),
                          Tab(text: 'Projects ${expert.projectsCount}'),
                          Tab(text: 'Questions ${expert.questionsCount}'),
                          const Tab(text: 'Notifications'),
                          const Tab(text: 'Appointments'),
                          const Tab(text: 'Reviews'),
                        ],
                      ),
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
                          itemCount: 5, // Mock count
                          itemBuilder: (context, index) {
                            if (selectedIndex == 2) {
                              return _buildProjectCard(index);
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

  Widget _buildProjectCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modern development methodology has dotted all the i\'s',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33354E),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'In general, of course, the new model of organizational activity creates prerequisites for the prioritization of reason over emotions.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 96, // Increased width to fit 3 avatars + count overlap
                height: 32,
                child: Stack(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Positioned(
                        left: i * 20.0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?u=${10 + i + index}',
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
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
                        child: const Text(
                          '+3',
                          style: TextStyle(
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
                '104',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(
                '30 minutes ago',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
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
                      Text(
                        'Rating: ${expert.rating}',
                        style: const TextStyle(
                          color: Color(0xFF33354E),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 18,
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
                      children: [
                        ...expert.areas.take(3).map((area) => _buildTag(area)),
                        _buildTag('+6', isMore: true),
                      ],
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
                              children: [
                                ...expert.areas
                                    .take(3)
                                    .map(
                                      (area) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6.0,
                                        ),
                                        child: _buildTag(area),
                                      ),
                                    ),
                                _buildTag('+6', isMore: true),
                              ],
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

  Widget _buildTag(String text, {bool isMore = false}) {
    Color bgColor = const Color(0xFFF0F4C3); // Light yellow/green
    Color textColor = const Color(0xFF827717); // Darker text

    if (text == 'Finance' || text == 'Banking') {
      bgColor = const Color(0xFFFFF9C4); // Yellowish
      textColor = const Color(0xFFFBC02D);
    } else if (text == 'IT') {
      bgColor = const Color(0xFFE3F2FD); // Light Blue
      textColor = const Color(0xFF1E88E5);
    } else if (text == 'Banks' || text == 'Banking') {
      bgColor = const Color(0xFFDCEDC8); // Light Green
      textColor = const Color(0xFF689F38);
    } else if (isMore) {
      bgColor = Colors.grey[200]!;
      textColor = Colors.grey[700]!;
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
  double get maxExtent => 320;

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
