import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/injection_container.dart' as di;
import 'package:consultant_app/features/auth/domain/entities/category_entity.dart';
import '../bloc/new_project/new_project_bloc.dart';
import '../bloc/new_project/new_project_event.dart';
import '../bloc/new_project/new_project_state.dart';
import '../widgets/add_participants_sheet.dart';

class NewProjectPage extends StatelessWidget {
  const NewProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewProjectBloc(
        getCategoriesUseCase: di.sl(),
        createProjectUseCase: di.sl(),
      ),
      child: const _NewProjectContent(),
    );
  }
}

class _NewProjectContent extends StatelessWidget {
  const _NewProjectContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33354E),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Create project',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFEEEEEE), size: 24),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: BlocConsumer<NewProjectBloc, NewProjectState>(
        listener: (context, state) {
          if (state.publishSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Project published successfully!')),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Project Title', isRequired: true),
                _buildTextField(
                  initialValue: state.title,
                  hintText: 'Super Project 2025',
                  onChanged: (value) =>
                      context.read<NewProjectBloc>().add(TitleChanged(value)),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Project Category', isRequired: true),
                _buildDropdownField(
                  value: state.category.isEmpty ? null : state.category,
                  hintText: 'Select category',
                  categories: state.categories,
                  onChanged: (value) => context.read<NewProjectBloc>().add(
                    CategoryChanged(value ?? ''),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Company'),
                _buildTextField(
                  initialValue: state.company,
                  hintText: 'OOO "AI"',
                  onChanged: (value) =>
                      context.read<NewProjectBloc>().add(CompanyChanged(value)),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Project Year', isRequired: true),
                _buildTextField(
                  initialValue: state.year,
                  hintText: '2025',
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      context.read<NewProjectBloc>().add(YearChanged(value)),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Project Description ( Goals)'),
                _buildTextField(
                  initialValue: state.description,
                  hintText: 'Enter description',
                  maxLines: 4,
                  onChanged: (value) => context.read<NewProjectBloc>().add(
                    DescriptionChanged(value),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Key Project Results', isRequired: true),
                _buildTextField(
                  initialValue: state.results,
                  hintText: 'Enter results',
                  maxLines: 4,
                  onChanged: (value) =>
                      context.read<NewProjectBloc>().add(ResultsChanged(value)),
                ),
                const SizedBox(height: 24),
                _buildFileList(context, state.files),
                const SizedBox(height: 12),
                _buildAddLink(
                  icon: Icons.add,
                  label: 'Add project files',
                  onTap: () {
                    // In a real app, this would open a file picker
                    context.read<NewProjectBloc>().add(
                      const AddFile('New_document.pdf'),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: Color(0xFFEEEEEE), height: 1),
                ),
                _buildFieldLabel('Project Participants', isRequired: true),
                _buildParticipantList(context, state.participants),
                const SizedBox(height: 12),
                _buildAddLink(
                  icon: Icons.add,
                  label: 'Add participant',
                  onTap: () async {
                    final result =
                        await showModalBottomSheet<List<ProjectParticipant>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const AddParticipantsSheet(),
                        );

                    if (result != null && context.mounted) {
                      context.read<NewProjectBloc>().add(
                        AddParticipants(result),
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
                _buildPublishButton(context, state.isPublishing),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Color(0xFF33354E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? initialValue,
    required String hintText,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0BACB), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF33354E)),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    String? value,
    required String hintText,
    required List<CategoryEntity> categories,
    required ValueChanged<String?> onChanged,
  }) {
    final items = categories.map((c) => c.name).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hintText,
            style: const TextStyle(color: Color(0xFFB0BACB), fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF33354E)),
          items: items
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              )
              .toList(),
          onChanged: categories.isEmpty ? null : onChanged,
        ),
      ),
    );
  }

  Widget _buildFileList(BuildContext context, List<String> files) {
    return Column(
      children: files
          .map(
            (fileName) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Color(0xFFB0BACB),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fileName,
                      style: const TextStyle(
                        color: Color(0xFF33354E),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFFB0BACB),
                      size: 18,
                    ),
                    onPressed: () => context.read<NewProjectBloc>().add(
                      RemoveFile(fileName),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildParticipantList(
    BuildContext context,
    List<ProjectParticipant> participants,
  ) {
    return Column(
      children: participants
          .map(
            (participant) => Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(participant.avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${participant.name}${participant.isMe ? ' (You)' : ''}',
                      style: const TextStyle(
                        color: Color(0xFF33354E),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (!participant.isMe)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFB0BACB),
                        size: 18,
                      ),
                      onPressed: () => context.read<NewProjectBloc>().add(
                        RemoveParticipant(participant.name),
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAddLink({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF66BB6A), size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF66BB6A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton(BuildContext context, bool isPublishing) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF76C776),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isPublishing
            ? null
            : () => context.read<NewProjectBloc>().add(PublishProject()),
        child: isPublishing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Publish',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
