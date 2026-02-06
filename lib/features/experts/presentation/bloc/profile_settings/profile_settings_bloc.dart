import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:consultant_app/core/network/api_client.dart';
import 'package:consultant_app/core/network/dio_client.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../../auth/domain/usecases/get_categories_usecase.dart';
import 'profile_settings_event.dart';
import 'profile_settings_state.dart';

class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  ProfileSettingsBloc({required this.getCategoriesUseCase})
      : super(const ProfileSettingsState()) {
    on<LoadProfileSettings>(_onLoadProfileSettings);
    on<ProfileCategoriesRequested>(_onProfileCategoriesRequested);
    on<UpdateFirstName>(_onUpdateFirstName);
    on<UpdateLastName>(_onUpdateLastName);
    on<UpdateAbout>(_onUpdateAbout);
    on<UpdatePhoto>(_onUpdatePhoto);
    on<RemovePhoto>(_onRemovePhoto);
    on<UpdateCategory>(_onUpdateCategory);
    on<UpdateCost>(_onUpdateCost);
    on<ToggleAgreement>(_onToggleAgreement);
    on<UpdateExperience>(_onUpdateExperience);
    on<UpdateLinkedin>(_onUpdateLinkedin);
    on<UpdateHh>(_onUpdateHh);
    on<UpdateAge>(_onUpdateAge);
    on<UpdateEducation>(_onUpdateEducation);
    on<UpdateOldPassword>(_onUpdateOldPassword);
    on<UpdateNewPassword>(_onUpdateNewPassword);
    on<UpdateRepeatPassword>(_onUpdateRepeatPassword);
    on<SaveProfileSettings>(_onSaveProfileSettings);
    on<DeleteProfile>(_onDeleteProfile);
  }

  void _onLoadProfileSettings(
    LoadProfileSettings event,
    Emitter<ProfileSettingsState> emit,
  ) {
    // Split name into first and last name
    final nameParts = event.expert.name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    emit(
      state.copyWith(
        status: ProfileSettingsStatus.initial,
        firstName: firstName,
        lastName: lastName,
        about: event.expert.description,
        imageUrl: event.expert.imageUrl,
        categories: event.expert.areas,
        cost: event.expert.cost,
        // Logic to determine if cost is by agreement could be parsed from string
        // For now, let's assume if it contains digits it's not by agreement
        isByAgreement: !RegExp(r'\d').hasMatch(event.expert.cost),
        experience: event.expert.experience,
        linkedin: event.expert.linkedinUrl ?? '',
        hh: event.expert.hhUrl ?? '',
        age: event.expert.age?.toString() ?? '',
        education: event.expert.education,
      ),
    );
  }

  Future<void> _onProfileCategoriesRequested(
    ProfileCategoriesRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final result = await getCategoriesUseCase(
      const GetCategoriesParams(page: 1, pageSize: 50),
    );

    result.fold(
      (_) => emit(state.copyWith(availableCategories: const [])),
      (categories) =>
          emit(state.copyWith(availableCategories: categories)),
    );
  }

  void _onUpdateFirstName(
    UpdateFirstName event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(firstName: event.firstName));
  }

  void _onUpdateLastName(
    UpdateLastName event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(lastName: event.lastName));
  }

  void _onUpdateAbout(UpdateAbout event, Emitter<ProfileSettingsState> emit) {
    emit(state.copyWith(about: event.about));
  }

  Future<void> _onUpdatePhoto(
    UpdatePhoto event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(state.copyWith(status: ProfileSettingsStatus.loading));
    try {
      final dioClient = di.sl<DioClient>();

      final file = await dio.MultipartFile.fromFile(
        event.filePath,
      );

      final formData = dio.FormData.fromMap({
        'avatar': file,
      });

      final response = await dioClient.patch(
        ApiClient.profile,
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      String? newImageUrl;
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final raw = (data['avatar_url'] ?? data['avatar'] ?? '').toString();
        final s = raw.trim();
        if (s.isNotEmpty) {
          if (s.startsWith('http://') || s.startsWith('https://')) {
            newImageUrl = s;
          } else {
            final uri = Uri.parse(ApiClient.baseUrl);
            final origin = '${uri.scheme}://${uri.host}';
            newImageUrl = '$origin$s';
          }
        }
      }

      emit(
        state.copyWith(
          status: ProfileSettingsStatus.success,
          imageUrl: newImageUrl ?? state.imageUrl,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileSettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onRemovePhoto(RemovePhoto event, Emitter<ProfileSettingsState> emit) {
    emit(state.copyWith(imageUrl: ''));
  }

  void _onUpdateCategory(
    UpdateCategory event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(categories: event.categories));
  }

  void _onUpdateCost(UpdateCost event, Emitter<ProfileSettingsState> emit) {
    emit(state.copyWith(cost: event.cost));
  }

  void _onToggleAgreement(
    ToggleAgreement event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(isByAgreement: event.value));
  }

  void _onUpdateExperience(
    UpdateExperience event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(experience: event.experience));
  }

  void _onUpdateLinkedin(
    UpdateLinkedin event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(linkedin: event.linkedin));
  }

  void _onUpdateHh(UpdateHh event, Emitter<ProfileSettingsState> emit) {
    emit(state.copyWith(hh: event.hh));
  }

  void _onUpdateAge(UpdateAge event, Emitter<ProfileSettingsState> emit) {
    emit(state.copyWith(age: event.age));
  }

  void _onUpdateEducation(
    UpdateEducation event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(education: event.education));
  }

  void _onUpdateOldPassword(
    UpdateOldPassword event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(oldPassword: event.password));
  }

  void _onUpdateNewPassword(
    UpdateNewPassword event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(newPassword: event.password));
  }

  void _onUpdateRepeatPassword(
    UpdateRepeatPassword event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(repeatPassword: event.password));
  }

  Future<void> _onSaveProfileSettings(
    SaveProfileSettings event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(state.copyWith(status: ProfileSettingsStatus.loading));
    try {
      final firstName = state.firstName.trim();
      final lastName = state.lastName.trim();
      final about = state.about.trim();

      int? parseInt(String value) {
        final trimmed = value.trim();
        if (trimmed.isEmpty) {
          return null;
        }
        final digits = RegExp(r'\d+').allMatches(trimmed).map((m) {
          return m.group(0) ?? '';
        }).join();
        if (digits.isEmpty) {
          return null;
        }
        return int.tryParse(digits);
      }

      final age = parseInt(state.age);

      int? hourCost;
      if (!state.isByAgreement) {
        hourCost = parseInt(state.cost);
      }

      final experience = parseInt(state.experience);

      final consultingExperience = experience;

      final hhLink = state.hh.trim().isNotEmpty ? state.hh.trim() : null;
      final linkedinLink =
          state.linkedin.trim().isNotEmpty ? state.linkedin.trim() : null;

      final categoryIds = <int>[];
      final selectedNames = state.categories;
      for (final category in state.availableCategories) {
        if (selectedNames.contains(category.name)) {
          categoryIds.add(category.id);
        }
      }

      final educationList = <Map<String, dynamic>>[];
      final rawEducation = state.education.trim();
      if (rawEducation.isNotEmpty) {
        final parts = rawEducation
            .split('•')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        String? institution;
        String? faculty;
        String? specialization;
        int? yearEnd;
        if (parts.isNotEmpty) {
          institution = parts[0];
        }
        if (parts.length > 1) {
          faculty = parts[1];
        }
        if (parts.length > 2) {
          specialization = parts[2];
        }
        if (parts.length > 3) {
          final yearDigits =
              RegExp(r'\d+').firstMatch(parts[3])?.group(0) ?? '';
          if (yearDigits.isNotEmpty) {
            yearEnd = int.tryParse(yearDigits);
          }
        }
        final education = <String, dynamic>{};
        if (institution != null && institution.isNotEmpty) {
          education['institution'] = institution;
        }
        if (faculty != null && faculty.isNotEmpty) {
          education['faculty'] = faculty;
        }
        if (specialization != null && specialization.isNotEmpty) {
          education['specialization'] = specialization;
        }
        if (yearEnd != null) {
          education['year_end'] = yearEnd;
        }
        if (education.isNotEmpty) {
          educationList.add(education);
        }
      }

      final body = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'about': about,
        'age': age,
        'hour_cost': hourCost,
        'experience': experience,
        'consulting_experience': consultingExperience,
        'hh_link': hhLink,
        'linkedin_link': linkedinLink,
        'categories': categoryIds,
        'education': educationList,
        'avatar': null,
      };

      body.removeWhere((key, value) => value == null);

      final dioClient = di.sl<DioClient>();
      await dioClient.patch(ApiClient.profile, data: body);

      emit(state.copyWith(status: ProfileSettingsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileSettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteProfile(
    DeleteProfile event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    // In a real app, you would verify the password and then delete the profile.
    emit(state.copyWith(status: ProfileSettingsStatus.loading));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Check if password is correct (Mock)
      if (event.password == "password") {
        // Mock password check
        emit(state.copyWith(status: ProfileSettingsStatus.success));
        // In real implementation, you might want to navigate away or show a success message
      } else {
        // emit(state.copyWith(status: ProfileSettingsStatus.error, errorMessage: "Incorrect password"));
        emit(
          state.copyWith(status: ProfileSettingsStatus.success),
        ); // Just letting it succeed for now as requested
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileSettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
