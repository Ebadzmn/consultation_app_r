import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../../../../injection_container.dart';
import '../../domain/repositories/experts_repository.dart';
import '../bloc/experts_bloc.dart';
import '../bloc/experts_event.dart';
import '../bloc/experts_state.dart';
import '../widgets/expert_card.dart';
import '../widgets/experts_filter_sheet.dart';
import 'package:consultant_app/features/experts/presentation/widgets/custom_bottom_nav_bar.dart';

class ExpertsPageState {
  final bool isSearching;
  final String? avatarUrl;

  const ExpertsPageState({
    this.isSearching = false,
    this.avatarUrl,
  });

  ExpertsPageState copyWith({
    bool? isSearching,
    String? avatarUrl,
  }) {
    return ExpertsPageState(
      isSearching: isSearching ?? this.isSearching,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ExpertsPageCubit extends Cubit<ExpertsPageState> {
  final ExpertsRepository repository;

  ExpertsPageCubit({required this.repository})
      : super(const ExpertsPageState()) {
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final result = await repository.getCurrentUserProfile();
    result.fold(
      (_) {},
      (profile) {
        emit(state.copyWith(avatarUrl: profile.imageUrl));
      },
    );
  }

  void toggleSearch() {
    emit(state.copyWith(isSearching: !state.isSearching));
  }
}

class ExpertsPage extends StatelessWidget {
  const ExpertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpertsBloc>(
          create: (_) => sl<ExpertsBloc>()..add(LoadExperts()),
        ),
        BlocProvider<ExpertsPageCubit>(
          create: (_) => ExpertsPageCubit(repository: sl<ExpertsRepository>()),
        ),
      ],
      child: const ExpertsView(),
    );
  }
}

class ExpertsView extends StatelessWidget {
  const ExpertsView({super.key});

  void _toggleSearch(BuildContext context) {
    context.read<ExpertsPageCubit>().toggleSearch();
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
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pageState = context.watch<ExpertsPageCubit>().state;
    final isSearching = pageState.isSearching;
    final avatarUrl = pageState.avatarUrl;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: isSearching ? Colors.white : const Color(0xFF2E2E3E),
        elevation: 0,
        titleSpacing: 0,
        title: isSearching
            ? SizedBox(
                height: 40,
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(
                    color: Color(0xFF33354E),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.search,
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
                            _toggleSearch(context);
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
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.experts,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        actions: isSearching
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _toggleSearch(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.myProfile),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      backgroundColor: Colors.white,
                      child: avatarUrl == null || avatarUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 18,
                              color: Color(0xFF2E2E3E),
                            )
                          : null,
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
            return Center(
              child: Text(state.errorMessage ?? 'Error loading experts'),
            );
          } else if (state.status == ExpertsStatus.success) {
            return ListView.builder(
              itemCount: state.experts.length,
              itemBuilder: (context, index) {
                final expert = state.experts[index];
                return GestureDetector(
                  onTap: () => context.push(
                    AppRoutes.expertPublicProfile,
                    extra: expert.id,
                  ),
                  child: ExpertCard(expert: expert),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
