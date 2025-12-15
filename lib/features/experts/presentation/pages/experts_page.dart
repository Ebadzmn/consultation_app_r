import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../../../../injection_container.dart';
import '../bloc/experts_bloc.dart';
import '../bloc/experts_event.dart';
import '../bloc/experts_state.dart';
import '../widgets/expert_card.dart';
import '../widgets/experts_filter_sheet.dart';

class ExpertsPage extends StatelessWidget {
  const ExpertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpertsBloc>()..add(LoadExperts()),
      child: const ExpertsView(),
    );
  }
}

class ExpertsView extends StatefulWidget {
  const ExpertsView({super.key});

  @override
  State<ExpertsView> createState() => _ExpertsViewState();
}

class _ExpertsViewState extends State<ExpertsView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _showFilterSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: const ExpertsFilterSheet(),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            _isSearching ? Colors.white : const Color(0xFF2E2E3E),
        elevation: 0,
        titleSpacing: 0,
        title: _isSearching
            ? SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(
                    color: Color(0xFF33354E),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB0BEC5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFFB0BEC5),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _toggleSearch();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Color(0xFFB0BEC5),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              )
            : const Text(
                'Experts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: _isSearching
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _toggleSearch,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.myProfile),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=1',
                      ), // User profile
                    ),
                  ),
                ),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterSheet(context),
        backgroundColor: Colors.white,
        child: const Icon(Icons.filter_list, color: Color(0xFF2E2E3E)),
      ),
      body: BlocBuilder<ExpertsBloc, ExpertsState>(
        builder: (context, state) {
          if (state.status == ExpertsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ExpertsStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Error loading experts'));
          } else if (state.status == ExpertsStatus.success) {
            return ListView.builder(
              itemCount: state.experts.length,
              itemBuilder: (context, index) {
                final expert = state.experts[index];
                return GestureDetector(
                  onTap: () => context.push(AppRoutes.expertPublicProfile),
                  child: ExpertCard(expert: expert),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E2E3E), // Active color
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Experts selected
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.star_border), // Using star for experts as icon isn't clear in image
            activeIcon: Icon(Icons.star),
            label: 'Experts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bolt), // Materials icon guess
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E3E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Consultations',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.help_outline),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            label: 'Questions',
          ),
        ],
      ),
    );
  }
}
