import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_project_event.dart';
import 'new_project_state.dart';

class NewProjectBloc extends Bloc<NewProjectEvent, NewProjectState> {
  NewProjectBloc()
    : super(
        const NewProjectState(
          participants: [
            ProjectParticipant(
              name: 'Alexander Alexandrov',
              avatarUrl: 'https://i.pravatar.cc/150?img=12',
              isMe: true,
            ),
            ProjectParticipant(
              name: 'Maria Kozhevnikova',
              avatarUrl: 'https://i.pravatar.cc/150?img=32',
            ),
          ],
          files: ['Presentation.pdf', 'Project_report.pdf'],
        ),
      ) {
    on<TitleChanged>(_onTitleChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<CoverImageChanged>(_onCoverImageChanged);
    on<TextContentChanged>(_onTextContentChanged);
    on<CategoryChanged>(_onCategoryChanged);
    on<CompanyChanged>(_onCompanyChanged);
    on<YearChanged>(_onYearChanged);
    on<ResultsChanged>(_onResultsChanged);
    on<AddFile>(_onAddFile);
    on<RemoveFile>(_onRemoveFile);
    on<AddParticipant>(_onAddParticipant);
    on<AddParticipants>(_onAddParticipants);
    on<RemoveParticipant>(_onRemoveParticipant);
    on<PublishProject>(_onPublishProject);
  }

  void _onCompanyChanged(CompanyChanged event, Emitter<NewProjectState> emit) {
    emit(state.copyWith(company: event.company));
  }

  void _onYearChanged(YearChanged event, Emitter<NewProjectState> emit) {
    emit(state.copyWith(year: event.year));
  }

  void _onResultsChanged(ResultsChanged event, Emitter<NewProjectState> emit) {
    emit(state.copyWith(results: event.results));
  }

  void _onAddFile(AddFile event, Emitter<NewProjectState> emit) {
    emit(state.copyWith(files: [...state.files, event.fileName]));
  }

  void _onRemoveFile(RemoveFile event, Emitter<NewProjectState> emit) {
    final updatedFiles = state.files.where((f) => f != event.fileName).toList();
    emit(state.copyWith(files: updatedFiles));
  }

  void _onTitleChanged(TitleChanged event, Emitter<NewProjectState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<NewProjectState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onCoverImageChanged(
    CoverImageChanged event,
    Emitter<NewProjectState> emit,
  ) {
    emit(state.copyWith(coverImagePath: event.imagePath));
  }

  void _onTextContentChanged(
    TextContentChanged event,
    Emitter<NewProjectState> emit,
  ) {
    emit(state.copyWith(textContent: event.text));
  }

  void _onCategoryChanged(
    CategoryChanged event,
    Emitter<NewProjectState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onAddParticipant(AddParticipant event, Emitter<NewProjectState> emit) {
    final updatedParticipants = List<ProjectParticipant>.from(
      state.participants,
    )..add(ProjectParticipant(name: event.name, avatarUrl: event.avatarUrl));
    emit(state.copyWith(participants: updatedParticipants));
  }

  void _onAddParticipants(
    AddParticipants event,
    Emitter<NewProjectState> emit,
  ) {
    // Avoid duplicates
    final currentNames = state.participants.map((p) => p.name).toSet();
    final newParticipants = event.participants
        .where((p) => !currentNames.contains(p.name))
        .toList();

    final updatedParticipants = [...state.participants, ...newParticipants];
    emit(state.copyWith(participants: updatedParticipants));
  }

  void _onRemoveParticipant(
    RemoveParticipant event,
    Emitter<NewProjectState> emit,
  ) {
    final updatedParticipants = state.participants
        .where((p) => p.name != event.name)
        .toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  void _onPublishProject(
    PublishProject event,
    Emitter<NewProjectState> emit,
  ) async {
    emit(state.copyWith(isPublishing: true));
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isPublishing: false, publishSuccess: true));
  }
}
