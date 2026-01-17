import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../bloc/expert_profile/expert_profile_bloc.dart';
import '../bloc/expert_profile/expert_profile_event.dart';
import '../bloc/expert_profile/expert_profile_state.dart';
import '../widgets/expert_profile_view.dart';

class ExpertPublicProfilePage extends StatelessWidget {
  final String? expertId;

  const ExpertPublicProfilePage({super.key, this.expertId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpertProfileBloc()
        ..add(LoadExpertProfile(expertId: expertId)),
      child: const _ExpertPublicProfileScaffold(
        key: ValueKey('expert_public_profile_scaffold'),
      ),
    );
  }
}

class _ExpertPublicProfileScaffold extends StatelessWidget {
  const _ExpertPublicProfileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        title: Text(
          l10n.main,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
        actions: const [],
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
            onPressed: () {
              context.push(AppRoutes.consultations);
            },
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
