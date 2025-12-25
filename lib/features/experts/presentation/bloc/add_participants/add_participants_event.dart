import 'package:equatable/equatable.dart';

abstract class AddParticipantsEvent extends Equatable {
  const AddParticipantsEvent();

  @override
  List<Object?> get props => [];
}

class LoadParticipants extends AddParticipantsEvent {}

class SearchQueryChanged extends AddParticipantsEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleParticipantSelection extends AddParticipantsEvent {
  final String participantId;
  const ToggleParticipantSelection(this.participantId);

  @override
  List<Object?> get props => [participantId];
}
