import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/usecases/get_categories_usecase.dart';
import '../../../domain/usecases/create_project_use_case.dart';
import 'new_project_event.dart';
import 'new_project_state.dart';

class NewProjectBloc extends Bloc<NewProjectEvent, NewProjectState> {
  final GetCategoriesUseCase? getCategoriesUseCase;
  final CreateProjectUseCase? createProjectUseCase;

  NewProjectBloc({
    this.getCategoriesUseCase,
    this.createProjectUseCase,
  }) : super(const NewProjectState()) {
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
    on<NewProjectCategoriesRequested>(_onCategoriesRequested);
    on<PublishProject>(_onPublishProject);

    add(const NewProjectCategoriesRequested());
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

  Future<void> _onCategoriesRequested(
    NewProjectCategoriesRequested event,
    Emitter<NewProjectState> emit,
  ) async {
    if (getCategoriesUseCase == null) {
      return;
    }

    final result = await getCategoriesUseCase!(
      const GetCategoriesParams(page: 1, pageSize: 50),
    );

    result.fold(
      (_) {},
      (categories) {
        emit(
          state.copyWith(categories: categories),
        );
      },
    );
  }

  void _onAddParticipant(AddParticipant event, Emitter<NewProjectState> emit) {
    final updatedParticipants = List<ProjectParticipant>.from(
      state.participants,
    )..add(
        ProjectParticipant(
          id: event.name,
          name: event.name,
          avatarUrl: event.avatarUrl,
        ),
      );
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
    if (createProjectUseCase == null) {
      return;
    }

    emit(state.copyWith(isPublishing: true));

    final name = state.title.trim();
    final year = int.tryParse(state.year) ?? DateTime.now().year;
    final goals = state.description.trim();
    final company = state.company.trim();

    int? categoryId;
    for (final c in state.categories) {
      if (c.name == state.category) {
        categoryId = c.id;
        break;
      }
    }

    final categoryIds = <int>[];
    if (categoryId != null) {
      categoryIds.add(categoryId);
    }

    final memberIds = state.participants
        .map((p) => int.tryParse(p.id))
        .whereType<int>()
        .toList();

    final keyResults = state.results.trim().isEmpty
        ? <String>[]
        : <String>[state.results.trim()];

    final customerId = 1;

    final result = await createProjectUseCase!(
      CreateProjectParams(
        name: name,
        year: year,
        categoryIds: categoryIds,
        memberIds: memberIds,
        keyResults: keyResults,
        goals: goals,
        customerId: customerId,
        company: company,
      ),
    );

    result.fold(
      (_) {
        emit(state.copyWith(isPublishing: false));
      },
      (_) {
        emit(state.copyWith(isPublishing: false, publishSuccess: true));
      },
    );
  }
}
