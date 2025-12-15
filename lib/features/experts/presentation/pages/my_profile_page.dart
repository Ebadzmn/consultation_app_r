import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';
import '../widgets/my_profile_view.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpertProfileBloc()..add(LoadExpertProfile()),
      child: const _MyProfileScaffold(),
    );
  }
}

class _MyProfileScaffold extends StatefulWidget {
  const _MyProfileScaffold({super.key});

  @override
  State<_MyProfileScaffold> createState() => _MyProfileScaffoldState();
}

class _MyProfileScaffoldState extends State<_MyProfileScaffold> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            _isSearching ? Colors.white : const Color(0xFF33354E),
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
                'Main',
                style: TextStyle(
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
                  icon: const Icon(Icons.search,
                      color: Colors.white, size: 24),
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
            return MyProfileView(
              expert: state.expert,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
