import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/core/localization/app_locale.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../../domain/entities/expert_profile.dart';
import '../bloc/profile_settings/profile_settings_bloc.dart';
import '../bloc/profile_settings/profile_settings_event.dart';
import '../bloc/profile_settings/profile_settings_state.dart';

class ProfileSettingsView extends StatefulWidget {
  final ExpertProfile expert;

  const ProfileSettingsView({super.key, required this.expert});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _aboutController;
  late TextEditingController _costController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _repeatPasswordController;
  final List<String> _allCategories = const ['Finance', 'IT', 'Legal', 'Health'];

  @override
  void initState() {
    super.initState();
    final nameParts = widget.expert.name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _aboutController = TextEditingController(text: widget.expert.description);
    _costController = TextEditingController(text: widget.expert.cost);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _aboutController.dispose();
    _costController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state.status == ProfileSettingsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.settingsSavedSuccessfully)),
          );
        } else if (state.status == ProfileSettingsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? l10n.errorOccurred)),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileSettings,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33354E),
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel(l10n.language),
            const SizedBox(height: 8),
            ValueListenableBuilder<Locale?>(
              valueListenable: appLocale,
              builder: (context, locale, _) {
                final currentLocale = locale ?? Localizations.localeOf(context);
                final selected = currentLocale.languageCode == 'ru'
                    ? const Locale('ru')
                    : const Locale('en');
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      isExpanded: true,
                      value: selected,
                      items: [
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(l10n.english),
                        ),
                        DropdownMenuItem(
                          value: const Locale('ru'),
                          child: Text(l10n.russian),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setAppLocale(value);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // First Name
            _buildLabel(l10n.firstName),
            _buildTextField(
              controller: _firstNameController,
              onChanged: (value) => context.read<ProfileSettingsBloc>().add(
                UpdateFirstName(value),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name
            _buildLabel(l10n.lastName),
            _buildTextField(
              controller: _lastNameController,
              onChanged: (value) => context.read<ProfileSettingsBloc>().add(
                UpdateLastName(value),
              ),
            ),
            const SizedBox(height: 16),

            // About
            _buildLabel(l10n.about),
            _buildTextField(
              controller: _aboutController,
              maxLines: 6,
              onChanged: (value) =>
                  context.read<ProfileSettingsBloc>().add(UpdateAbout(value)),
            ),
            const SizedBox(height: 24),

            // Photo
            _buildLabel(l10n.photo),
            const SizedBox(height: 8),
            Row(
              children: [
                BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  buildWhen: (previous, current) =>
                      previous.imageUrl != current.imageUrl,
                  builder: (context, state) {
                    return CircleAvatar(
                      radius: 40,
                      backgroundImage: state.imageUrl.isNotEmpty
                          ? NetworkImage(state.imageUrl)
                          : null,
                      backgroundColor: Colors.grey[200],
                      child: state.imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Implement upload photo
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC5CAE9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        l10n.uploadPhoto,
                        style: const TextStyle(color: Color(0xFF33354E)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ProfileSettingsBloc>().add(RemovePhoto());
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.removePhoto,
                        style: const TextStyle(color: Color(0xFFEF5350)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Expert's categories
            _buildLabel(l10n.expertsCategories),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                buildWhen: (previous, current) =>
                    previous.categories != current.categories,
                builder: (context, state) {
                  final selected = state.categories;
                  final hasSelection = selected.isNotEmpty;
                  final text = hasSelection
                      ? selected.join(', ')
                      : l10n.selectCategory;
                  final textStyle = TextStyle(
                    color: hasSelection
                        ? const Color(0xFF33354E)
                        : const Color(0xFFB0BEC5),
                    fontSize: 14,
                  );
                  return Builder(
                    builder: (innerContext) {
                      return InkWell(
                        onTap: () {
                          _openCategorySelector(innerContext, selected, l10n);
                        },
                        child: SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  text,
                                  style: textStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFFB0BEC5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Cost
            _buildLabel(l10n.consultationCost),
            const SizedBox(height: 8),
            BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      enabled: !state.isByAgreement,
                      controller: _costController,
                      decoration: InputDecoration(
                        hintText: l10n.costPerHourHint,
                        filled: state.isByAgreement,
                        fillColor: state.isByAgreement
                            ? Colors.grey[200]
                            : Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      onChanged: (value) => context
                          .read<ProfileSettingsBloc>()
                          .add(UpdateCost(value)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: state.isByAgreement,
                          activeColor: const Color(0xFF33354E),
                          onChanged: (value) {
                            context.read<ProfileSettingsBloc>().add(
                              ToggleAgreement(value ?? false),
                            );
                          },
                        ),
                        Text(l10n.byAgreement),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Password Change Section
            Text(
              l10n.passwordChange,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33354E),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel(l10n.oldPassword),
            _buildTextField(
              controller: _oldPasswordController,
              obscureText: true,
              onChanged: (value) => context.read<ProfileSettingsBloc>().add(
                UpdateOldPassword(value),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel(l10n.newPassword),
            _buildTextField(
              controller: _newPasswordController,
              obscureText: true,
              onChanged: (value) => context.read<ProfileSettingsBloc>().add(
                UpdateNewPassword(value),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel(l10n.repeatNewPassword),
            _buildTextField(
              controller: _repeatPasswordController,
              obscureText: true,
              onChanged: (value) => context.read<ProfileSettingsBloc>().add(
                UpdateRepeatPassword(value),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProfileSettingsBloc>().add(
                    SaveProfileSettings(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  l10n.saveChanges,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delete Profile
            Center(
              child: TextButton(
                onPressed: () {
                  _showDeleteProfileDialog(context);
                },
                child: Text(
                  l10n.deleteProfile,
                  style: const TextStyle(color: Color(0xFFEF5350), fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<List<String>?> _showCategorySelector(
    BuildContext context,
    List<String> current,
    AppLocalizations l10n,
  ) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final selected = current.toSet();
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.expertsCategories,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF33354E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._allCategories.map(
                    (c) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: selected.contains(c),
                      title: Text(
                        c,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF33354E),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selected.add(c);
                          } else {
                            selected.remove(c);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop<List<String>?>(null);
                        },
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(
                            color: Color(0xFF33354E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop<List<String>>(
                            selected.toList(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF33354E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          elevation: 0,
                        ),
                        child: Text(l10n.saveChanges),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _openCategorySelector(
    BuildContext context,
    List<String> current,
    AppLocalizations l10n,
  ) async {
    final bloc = context.read<ProfileSettingsBloc>();
    _showCategorySelector(context, current, l10n).then((updated) {
      if (updated == null) {
        return;
      }
      if (!mounted) {
        return;
      }
      bloc.add(UpdateCategory(updated));
    });
  }

  void _showDeleteProfileDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.deleteProfileTitle,
                      style: const TextStyle(
                        color: Color(0xFF33354E), // Dark color
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(bottomSheetContext).pop(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.toConfirmProvidePassword,
                  style: const TextStyle(
                    color: Color(0xFF33354E),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: l10n.yourPassword,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ProfileSettingsBloc>().add(
                            DeleteProfile(passwordController.text),
                          );
                          Navigator.of(bottomSheetContext).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF5350), // Red color
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.removeProfile,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(bottomSheetContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF33354E),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF33354E),
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required Function(String) onChanged,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
