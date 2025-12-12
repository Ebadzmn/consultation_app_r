import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state.status == ProfileSettingsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings saved successfully')),
          );
        } else if (state.status == ProfileSettingsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33354E),
              ),
            ),
            const SizedBox(height: 24),

            // First Name
            _buildLabel('First name'),
            _buildTextField(
              controller: _firstNameController,
              onChanged: (value) => context
                  .read<ProfileSettingsBloc>()
                  .add(UpdateFirstName(value)),
            ),
            const SizedBox(height: 16),

            // Last Name
            _buildLabel('Last name'),
            _buildTextField(
              controller: _lastNameController,
              onChanged: (value) =>
                  context.read<ProfileSettingsBloc>().add(UpdateLastName(value)),
            ),
            const SizedBox(height: 16),

            // About
            _buildLabel('About'),
            _buildTextField(
              controller: _aboutController,
              maxLines: 6,
              onChanged: (value) =>
                  context.read<ProfileSettingsBloc>().add(UpdateAbout(value)),
            ),
            const SizedBox(height: 24),

            // Photo
            _buildLabel('Photo'),
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
                          ? const Icon(Icons.person,
                              size: 40, color: Colors.grey)
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
                      child: const Text(
                        'Upload photo',
                        style: TextStyle(color: Color(0xFF33354E)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ProfileSettingsBloc>().add(RemovePhoto());
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Remove photo',
                        style: TextStyle(color: Color(0xFFEF5350)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Expert's categories
            _buildLabel('Expert\'s categories'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  buildWhen: (previous, current) =>
                      previous.category != current.category,
                  builder: (context, state) {
                    return DropdownButton<String>(
                      isExpanded: true,
                      value: state.category.isNotEmpty ? state.category : null,
                      hint: const Text('Select category'),
                      items: ['Finance', 'IT', 'Legal', 'Health']
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<ProfileSettingsBloc>()
                              .add(UpdateCategory(value));
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cost
            _buildLabel('Стоимость консультации:'),
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
                        hintText: 'Cost per hour in ₽',
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
                            context
                                .read<ProfileSettingsBloc>()
                                .add(ToggleAgreement(value ?? false));
                          },
                        ),
                        const Text('By agreement'),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Password Change Section
            const Text(
              'Смена пароля',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33354E),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel('Старый пароль'),
            _buildTextField(
              controller: _oldPasswordController,
              obscureText: true,
              onChanged: (value) => context
                  .read<ProfileSettingsBloc>()
                  .add(UpdateOldPassword(value)),
            ),
            const SizedBox(height: 16),

            _buildLabel('Новый пароль'),
            _buildTextField(
              controller: _newPasswordController,
              obscureText: true,
              onChanged: (value) => context
                  .read<ProfileSettingsBloc>()
                  .add(UpdateNewPassword(value)),
            ),
            const SizedBox(height: 16),

            _buildLabel('Повторите новый пароль'),
            _buildTextField(
              controller: _repeatPasswordController,
              obscureText: true,
              onChanged: (value) => context
                  .read<ProfileSettingsBloc>()
                  .add(UpdateRepeatPassword(value)),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProfileSettingsBloc>().add(SaveProfileSettings());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(
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
                  // Show confirmation dialog then delete
                },
                child: const Text(
                  'Delete profile',
                  style: TextStyle(
                    color: Color(0xFFEF5350),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
