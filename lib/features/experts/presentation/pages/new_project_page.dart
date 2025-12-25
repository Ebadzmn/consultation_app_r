import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/new_project/new_project_bloc.dart';
import '../bloc/new_project/new_project_event.dart';
import '../bloc/new_project/new_project_state.dart';
import '../widgets/add_participants_sheet.dart';

class NewProjectPage extends StatelessWidget {
  const NewProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewProjectBloc(),
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
        leading: const SizedBox.shrink(),
        title: const Text(
          'Editor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  hintText: 'Project Title',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD0D0D8),
                  ),
                  onChanged: (value) =>
                      context.read<NewProjectBloc>().add(TitleChanged(value)),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  hintText: 'Short Description',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFD0D0D8),
                  ),
                  onChanged: (value) => context.read<NewProjectBloc>().add(
                    DescriptionChanged(value),
                  ),
                ),
                const SizedBox(height: 24),
                _buildCoverImagePlaceholder(),
                const SizedBox(height: 32),
                const Text(
                  'Text',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFD0D0D8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                _buildAddButton(),
                const SizedBox(height: 32),
                const Divider(color: Color(0xFFEEEEEE), height: 1),
                const SizedBox(height: 24),
                _buildSettingsHeader(),
                const SizedBox(height: 24),
                _buildCategoryField(),
                const SizedBox(height: 32),
                _buildParticipantsSection(context, state.participants),
                const SizedBox(height: 32),
                _buildPublishButton(context, state.isPublishing),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextStyle style,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      style: style.copyWith(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: style,
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCoverImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_outlined, color: Color(0xFFB0BACB), size: 32),
          SizedBox(height: 8),
          Text(
            'Add a cover image',
            style: TextStyle(
              color: Color(0xFFB0BACB),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC0C5D6), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Add',
            style: TextStyle(
              color: Color(0xFF33354E),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF33354E)),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Row(
      children: [
        const Text(
          'SETTINGS',
          style: TextStyle(
            color: Color(0xFFA0A5B9),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        const Icon(Icons.delete_outline, color: Color(0xFFA0A5B9), size: 18),
        const SizedBox(width: 4),
        const Text(
          'Clear All',
          style: TextStyle(
            color: Color(0xFFA0A5B9),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category:',
          style: TextStyle(
            color: Color(0xFF33354E),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Text(
                'Select category',
                style: TextStyle(
                  color: Color(0xFFB0BACB),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_down, color: Color(0xFF33354E)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(
    BuildContext context,
    List<ProjectParticipant> participants,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Participants',
          style: TextStyle(
            color: Color(0xFF33354E),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...participants.map((p) => _buildParticipantTile(p)),
        const SizedBox(height: 12),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final result = await showModalBottomSheet<List<ProjectParticipant>>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddParticipantsSheet(),
            );

            if (result != null && context.mounted) {
              context.read<NewProjectBloc>().add(AddParticipants(result));
            }
          },
          child: Row(
            children: const [
              Icon(Icons.add, color: Color(0xFF66BB6A), size: 24),
              SizedBox(width: 8),
              Text(
                'Add participant',
                style: TextStyle(
                  color: Color(0xFF66BB6A),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantTile(ProjectParticipant participant) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(participant.avatarUrl),
          ),
          const SizedBox(width: 12),
          Text(
            '${participant.name}${participant.isMe ? ' (You)' : ''}',
            style: const TextStyle(
              color: Color(0xFF33354E),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (!participant.isMe)
            const Icon(Icons.close, color: Color(0xFFB0BACB), size: 20),
        ],
      ),
    );
  }

  Widget _buildPublishButton(BuildContext context, bool isPublishing) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4EBD1),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isPublishing
            ? null
            : () => context.read<NewProjectBloc>().add(PublishProject()),
        child: isPublishing
            ? const CircularProgressIndicator(color: Colors.green)
            : const Text(
                'Publish',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
