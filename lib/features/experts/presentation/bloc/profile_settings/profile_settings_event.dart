import 'package:equatable/equatable.dart';
import '../../../domain/entities/expert_profile.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileSettings extends ProfileSettingsEvent {
  final ExpertProfile expert;

  const LoadProfileSettings(this.expert);

  @override
  List<Object?> get props => [expert];
}

class UpdateFirstName extends ProfileSettingsEvent {
  final String firstName;

  const UpdateFirstName(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class UpdateLastName extends ProfileSettingsEvent {
  final String lastName;

  const UpdateLastName(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class UpdateAbout extends ProfileSettingsEvent {
  final String about;

  const UpdateAbout(this.about);

  @override
  List<Object?> get props => [about];
}

class UpdatePhoto extends ProfileSettingsEvent {
  // In a real app, this might be a File or image path.
  // For now, we'll just simulate the action.
  const UpdatePhoto();
}

class RemovePhoto extends ProfileSettingsEvent {}

class UpdateCategory extends ProfileSettingsEvent {
  final String category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCost extends ProfileSettingsEvent {
  final String cost;

  const UpdateCost(this.cost);

  @override
  List<Object?> get props => [cost];
}

class ToggleAgreement extends ProfileSettingsEvent {
  final bool value;

  const ToggleAgreement(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateOldPassword extends ProfileSettingsEvent {
  final String password;

  const UpdateOldPassword(this.password);

  @override
  List<Object?> get props => [password];
}

class UpdateNewPassword extends ProfileSettingsEvent {
  final String password;

  const UpdateNewPassword(this.password);

  @override
  List<Object?> get props => [password];
}

class UpdateRepeatPassword extends ProfileSettingsEvent {
  final String password;

  const UpdateRepeatPassword(this.password);

  @override
  List<Object?> get props => [password];
}

class SaveProfileSettings extends ProfileSettingsEvent {}

class DeleteProfile extends ProfileSettingsEvent {
  final String password;

  const DeleteProfile(this.password);

  @override
  List<Object?> get props => [password];
}
