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

class ProfileCategoriesRequested extends ProfileSettingsEvent {
  const ProfileCategoriesRequested();
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

class UpdateExperience extends ProfileSettingsEvent {
  final String experience;

  const UpdateExperience(this.experience);

  @override
  List<Object?> get props => [experience];
}

class UpdateLinkedin extends ProfileSettingsEvent {
  final String linkedin;

  const UpdateLinkedin(this.linkedin);

  @override
  List<Object?> get props => [linkedin];
}

class UpdateHh extends ProfileSettingsEvent {
  final String hh;

  const UpdateHh(this.hh);

  @override
  List<Object?> get props => [hh];
}

class UpdateAge extends ProfileSettingsEvent {
  final String age;

  const UpdateAge(this.age);

  @override
  List<Object?> get props => [age];
}

class UpdateEducation extends ProfileSettingsEvent {
  final String education;

  const UpdateEducation(this.education);

  @override
  List<Object?> get props => [education];
}

class UpdatePhoto extends ProfileSettingsEvent {
  final String filePath;

  const UpdatePhoto(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class RemovePhoto extends ProfileSettingsEvent {}

class UpdateCategory extends ProfileSettingsEvent {
  final List<String> categories;

  const UpdateCategory(this.categories);

  @override
  List<Object?> get props => [categories];
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
