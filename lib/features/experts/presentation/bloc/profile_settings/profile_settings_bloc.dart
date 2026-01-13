import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_settings_event.dart';
import 'profile_settings_state.dart';

class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc() : super(const ProfileSettingsState()) {
    on<LoadProfileSettings>(_onLoadProfileSettings);
    on<UpdateFirstName>(_onUpdateFirstName);
    on<UpdateLastName>(_onUpdateLastName);
    on<UpdateAbout>(_onUpdateAbout);
    on<UpdatePhoto>(_onUpdatePhoto);
    on<RemovePhoto>(_onRemovePhoto);
    on<UpdateCategory>(_onUpdateCategory);
    on<UpdateCost>(_onUpdateCost);
    on<ToggleAgreement>(_onToggleAgreement);
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
        categories: const [],
        cost: event.expert.cost,
        // Logic to determine if cost is by agreement could be parsed from string
        // For now, let's assume if it contains digits it's not by agreement
        isByAgreement: !RegExp(r'\d').hasMatch(event.expert.cost),
      ),
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

  void _onUpdatePhoto(UpdatePhoto event, Emitter<ProfileSettingsState> emit) {
    // Logic to pick image would go here or be passed in
    // For now, just a placeholder
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
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
