import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../../domain/entities/expert_profile.dart';
import '../bloc/profile_settings/profile_settings_bloc.dart';
import '../bloc/profile_settings/profile_settings_event.dart';
import '../widgets/profile_settings_view.dart';

class ProfileSettingsPage extends StatelessWidget {
  final ExpertProfile expert;

  const ProfileSettingsPage({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) =>
          ProfileSettingsBloc()..add(LoadProfileSettings(expert)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF33354E),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.toProfilePage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          titleSpacing: 0,
        ),
        body: ProfileSettingsView(expert: expert),
      ),
    );
  }
}
