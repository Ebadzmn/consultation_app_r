import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../domain/repositories/experts_repository.dart';
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

    try {
      final repository = di.sl<ExpertsRepository>();
      final result = await repository.getExperts();

      result.fold(
        (_) {
          emit(
            state.copyWith(
              status: AddParticipantsStatus.failure,
            ),
          );
        },
        (experts) {
          final participants = experts
              .map(
                (e) => ProjectParticipant(
                  id: e.id,
                  name: e.name,
                  avatarUrl: e.avatarUrl,
                ),
              )
              .toList();

          emit(
            state.copyWith(
              status: AddParticipantsStatus.success,
              participants: participants
                  .map(
                    (p) => SelectableParticipant(participant: p),
                  )
                  .toList(),
            ),
          );
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AddParticipantsStatus.failure,
        ),
      );
    }
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
