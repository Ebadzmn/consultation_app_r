import 'package:equatable/equatable.dart';

enum ProfileSettingsStatus { initial, loading, success, error }

class ProfileSettingsState extends Equatable {
  final ProfileSettingsStatus status;
  final String firstName;
  final String lastName;
  final String about;
  final String imageUrl; // For display
  final String category;
  final String cost;
  final bool isByAgreement;
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
    this.category = '',
    this.cost = '',
    this.isByAgreement = false,
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
    String? category,
    String? cost,
    bool? isByAgreement,
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
      category: category ?? this.category,
      cost: cost ?? this.cost,
      isByAgreement: isByAgreement ?? this.isByAgreement,
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
        category,
        cost,
        isByAgreement,
        oldPassword,
        newPassword,
        repeatPassword,
        errorMessage,
      ];
}
