import 'package:flutter_bloc/flutter_bloc.dart';
import '../new_project/new_project_state.dart';
import 'add_participants_event.dart';
import 'add_participants_state.dart';

class AddParticipantsBloc
    extends Bloc<AddParticipantsEvent, AddParticipantsState> {
  AddParticipantsBloc() : super(const AddParticipantsState()) {
    on<LoadParticipants>(_onLoadParticipants);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ToggleParticipantSelection>(_onToggleParticipantSelection);
  }

  Future<void> _onLoadParticipants(
    LoadParticipants event,
    Emitter<AddParticipantsState> emit,
  ) async {
    emit(state.copyWith(status: AddParticipantsStatus.loading));

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data based on the image provided
    final mockParticipants = [
      const ProjectParticipant(
        name: 'Maria Kozhevnikova',
        avatarUrl: 'https://i.pravatar.cc/150?u=1',
      ),
      const ProjectParticipant(
        name: 'Maria Petrova',
        avatarUrl: 'https://i.pravatar.cc/150?u=2',
      ),
      const ProjectParticipant(
        name: 'Maria Zaytseva',
        avatarUrl: 'https://i.pravatar.cc/150?u=3',
      ),
      const ProjectParticipant(
        name: 'Maria Ivanova',
        avatarUrl: 'https://i.pravatar.cc/150?u=4',
      ),
      const ProjectParticipant(
        name: 'Maria Smirnova',
        avatarUrl: 'https://i.pravatar.cc/150?u=5',
      ),
      const ProjectParticipant(
        name: 'Maria Sokolova',
        avatarUrl: 'https://i.pravatar.cc/150?u=6',
      ),
      const ProjectParticipant(
        name: 'Maria Popova',
        avatarUrl: 'https://i.pravatar.cc/150?u=7',
      ),
    ];

    emit(
      state.copyWith(
        status: AddParticipantsStatus.success,
        participants: mockParticipants
            .map((p) => SelectableParticipant(participant: p))
            .toList(),
      ),
    );
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<AddParticipantsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onToggleParticipantSelection(
    ToggleParticipantSelection event,
    Emitter<AddParticipantsState> emit,
  ) {
    final updatedParticipants = state.participants.map((p) {
      if (p.participant.name == event.participantId) {
        // Using name as ID for now
        return p.copyWith(isSelected: !p.isSelected);
      }
      return p;
    }).toList();

    emit(state.copyWith(participants: updatedParticipants));
  }
}
