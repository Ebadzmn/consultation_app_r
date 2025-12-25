import 'package:equatable/equatable.dart';
import '../new_project/new_project_state.dart';

class SelectableParticipant extends Equatable {
  final ProjectParticipant participant;
  final bool isSelected;

  const SelectableParticipant({
    required this.participant,
    this.isSelected = false,
  });

  SelectableParticipant copyWith({
    ProjectParticipant? participant,
    bool? isSelected,
  }) {
    return SelectableParticipant(
      participant: participant ?? this.participant,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [participant, isSelected];
}

enum AddParticipantsStatus { initial, loading, success, failure }

class AddParticipantsState extends Equatable {
  final AddParticipantsStatus status;
  final List<SelectableParticipant> participants;
  final String searchQuery;

  const AddParticipantsState({
    this.status = AddParticipantsStatus.initial,
    this.participants = const [],
    this.searchQuery = '',
  });

  List<SelectableParticipant> get filteredParticipants {
    if (searchQuery.isEmpty) return participants;
    return participants.where((p) {
      return p.participant.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
    }).toList();
  }

  int get selectedCount => participants.where((p) => p.isSelected).length;
  List<ProjectParticipant> get selectedParticipants => participants
      .where((p) => p.isSelected)
      .map((p) => p.participant)
      .toList();

  AddParticipantsState copyWith({
    AddParticipantsStatus? status,
    List<SelectableParticipant>? participants,
    String? searchQuery,
  }) {
    return AddParticipantsState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, participants, searchQuery];
}
