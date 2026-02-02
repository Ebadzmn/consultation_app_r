import 'package:equatable/equatable.dart';

enum ProfileSettingsStatus { initial, loading, success, error }

class ProfileSettingsState extends Equatable {
  final ProfileSettingsStatus status;
  final String firstName;
  final String lastName;
  final String about;
  final String imageUrl; // For display
  final List<String> categories;
  final String cost;
  final bool isByAgreement;
  final String experience;
  final String linkedin;
  final String hh;
  final String age;
  final String education;
  final String oldPassword;
  final String newPassword;
  final String repeatPassword;
  final String? errorMessage;

  const ProfileSettingsState({
    this.status = ProfileSettingsStatus.initial,
    this.firstName = '',
    this.lastName = '',
    this.about = '',
    this.imageUrl = '',
    this.categories = const [],
    this.cost = '',
    this.isByAgreement = false,
    this.experience = '',
    this.linkedin = '',
    this.hh = '',
    this.age = '',
    this.education = '',
    this.oldPassword = '',
    this.newPassword = '',
    this.repeatPassword = '',
    this.errorMessage,
  });

  ProfileSettingsState copyWith({
    ProfileSettingsStatus? status,
    String? firstName,
    String? lastName,
    String? about,
    String? imageUrl,
    List<String>? categories,
    String? cost,
    bool? isByAgreement,
    String? experience,
    String? linkedin,
    String? hh,
    String? age,
    String? education,
    String? oldPassword,
    String? newPassword,
    String? repeatPassword,
    String? errorMessage,
  }) {
    return ProfileSettingsState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      about: about ?? this.about,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      cost: cost ?? this.cost,
      isByAgreement: isByAgreement ?? this.isByAgreement,
      experience: experience ?? this.experience,
      linkedin: linkedin ?? this.linkedin,
      hh: hh ?? this.hh,
      age: age ?? this.age,
      education: education ?? this.education,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    firstName,
    lastName,
    about,
    imageUrl,
    categories,
    cost,
    isByAgreement,
    experience,
    linkedin,
    hh,
    age,
    education,
    oldPassword,
    newPassword,
    repeatPassword,
    errorMessage,
  ];
}
