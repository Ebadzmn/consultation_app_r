import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/add_participants/add_participants_bloc.dart';
import '../bloc/add_participants/add_participants_event.dart';
import '../bloc/add_participants/add_participants_state.dart';

class AddParticipantsSheet extends StatelessWidget {
  const AddParticipantsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddParticipantsBloc()..add(LoadParticipants()),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<AddParticipantsBloc, AddParticipantsState>(
                builder: (context, state) {
                  if (state.status == AddParticipantsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildSearchField(context),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.filteredParticipants.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final item = state.filteredParticipants[index];
                            return _buildParticipantTile(context, item);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add participants to the project',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF33354E),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFB0BACB)),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        onChanged: (value) {
          context.read<AddParticipantsBloc>().add(SearchQueryChanged(value));
        },
        decoration: const InputDecoration(
          hintText: 'Enter email or name',
          hintStyle: TextStyle(color: Color(0xFFB0BACB)),
          prefixIcon:
              null, // No search icon on left based on 1st screen, but let's check.
          // Actually the design shows "Marta | X" or "Enter email (search icon right)"
          // Image 1: "Enter email" + Search Icon on right.
          suffixIcon: Icon(Icons.search, color: Color(0xFFB0BACB)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildParticipantTile(
    BuildContext context,
    SelectableParticipant item,
  ) {
    return InkWell(
      onTap: () {
        context.read<AddParticipantsBloc>().add(
          ToggleParticipantSelection(item.participant.name),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: item.isSelected,
                onChanged: (value) {
                  context.read<AddParticipantsBloc>().add(
                    ToggleParticipantSelection(item.participant.name),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: Color(0xFFB0BACB)),
                activeColor: const Color(
                  0xFF33354E,
                ), // Dark color from screenshot
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(item.participant.avatarUrl),
            ),
            const SizedBox(width: 12),
            Text(
              item.participant.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF33354E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return BlocBuilder<AddParticipantsBloc, AddParticipantsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66BB6A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final selected = state.selectedParticipants;
                      context.pop(selected);
                    },
                    child: const Text(
                      'Send invitation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF66BB6A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.reply, color: Colors.white, size: 24),
                  onPressed: () {
                    // Handle share action
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
