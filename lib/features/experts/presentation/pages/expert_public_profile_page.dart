import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';
import '../widgets/expert_profile_view.dart';

class ExpertPublicProfilePage extends StatelessWidget {
  const ExpertPublicProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpertProfileBloc()..add(LoadExpertProfile()),
      child: const _ExpertPublicProfileScaffold(
        key: ValueKey('expert_public_profile_scaffold'),
      ),
    );
  }
}

class _ExpertPublicProfileScaffold extends StatefulWidget {
  const _ExpertPublicProfileScaffold({super.key});

  @override
  State<_ExpertPublicProfileScaffold> createState() =>
      _ExpertPublicProfileScaffoldState();
}

class _ExpertPublicProfileScaffoldState
    extends State<_ExpertPublicProfileScaffold> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _isSearching ? Colors.white : const Color(0xFF33354E),
        elevation: 0,
        leading: _isSearching
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
            : Text(
                l10n.main,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
        centerTitle: false,
        actions: _isSearching
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 24),
                  onPressed: _toggleSearch,
                ),
              ],
      ),
      body: BlocBuilder<ExpertProfileBloc, ExpertProfileState>(
        builder: (context, state) {
          if (state is ExpertProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpertProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ExpertProfileLoaded) {
            return ExpertProfileView(expert: state.expert);
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A), // Green button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.consultation,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
