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
      child: const _MyProfileScaffold(key: ValueKey('my_profile_scaffold')),
    );
  }
}

class _MyProfileScaffold extends StatelessWidget {
  const _MyProfileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33354E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Main',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ExpertProfileBloc, ExpertProfileState>(
        builder: (context, state) {
          if (state is ExpertProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpertProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ExpertProfileLoaded) {
            return MyProfileView(expert: state.expert);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
