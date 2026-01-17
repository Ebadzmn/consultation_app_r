import 'package:equatable/equatable.dart';
import '../../../domain/entities/category_entity.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final String userType;
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String password;
  final String repeatPassword;
  final String aboutMyself;
  final String experience;
  final String cost;
  final List<String> categoriesOfExpertise;
  final List<CategoryEntity> availableCategories;
  final bool agreedToTerms;
  final String? errorMessage;
  final bool submitAttempted;
  final bool nameTouched;
  final bool surnameTouched;
  final bool emailTouched;
  final bool phoneTouched;
  final bool passwordTouched;
  final bool repeatPasswordTouched;
  final bool aboutMyselfTouched;
  final bool experienceTouched;
  final bool costTouched;
  final bool categoriesTouched;
  final bool termsTouched;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.userType = 'Expert',
    this.name = '',
    this.surname = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.repeatPassword = '',
    this.aboutMyself = '',
    this.experience = '',
    this.cost = '',
    this.categoriesOfExpertise = const [],
    this.availableCategories = const [],
    this.agreedToTerms = false,
    this.errorMessage,
    this.submitAttempted = false,
    this.nameTouched = false,
    this.surnameTouched = false,
    this.emailTouched = false,
    this.phoneTouched = false,
    this.passwordTouched = false,
    this.repeatPasswordTouched = false,
    this.aboutMyselfTouched = false,
    this.experienceTouched = false,
    this.costTouched = false,
    this.categoriesTouched = false,
    this.termsTouched = false,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? userType,
    String? name,
    String? surname,
    String? email,
    String? phone,
    String? password,
    String? repeatPassword,
    String? aboutMyself,
    String? experience,
    String? cost,
    List<String>? categoriesOfExpertise,
    List<CategoryEntity>? availableCategories,
    bool? agreedToTerms,
    String? errorMessage,
    bool? submitAttempted,
    bool? nameTouched,
    bool? surnameTouched,
    bool? emailTouched,
    bool? phoneTouched,
    bool? passwordTouched,
    bool? repeatPasswordTouched,
    bool? aboutMyselfTouched,
    bool? experienceTouched,
    bool? costTouched,
    bool? categoriesTouched,
    bool? termsTouched,
  }) {
    return SignUpState(
      status: status ?? this.status,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      aboutMyself: aboutMyself ?? this.aboutMyself,
      experience: experience ?? this.experience,
      cost: cost ?? this.cost,
      categoriesOfExpertise:
          categoriesOfExpertise ?? this.categoriesOfExpertise,
      availableCategories: availableCategories ?? this.availableCategories,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      errorMessage: errorMessage,
      submitAttempted: submitAttempted ?? this.submitAttempted,
      nameTouched: nameTouched ?? this.nameTouched,
      surnameTouched: surnameTouched ?? this.surnameTouched,
      emailTouched: emailTouched ?? this.emailTouched,
      phoneTouched: phoneTouched ?? this.phoneTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      repeatPasswordTouched:
          repeatPasswordTouched ?? this.repeatPasswordTouched,
      aboutMyselfTouched: aboutMyselfTouched ?? this.aboutMyselfTouched,
      experienceTouched: experienceTouched ?? this.experienceTouched,
      costTouched: costTouched ?? this.costTouched,
      categoriesTouched: categoriesTouched ?? this.categoriesTouched,
      termsTouched: termsTouched ?? this.termsTouched,
    );
  }

  bool get isExpert => userType == 'Expert';

  bool get isNameValid => name.trim().isNotEmpty;
  bool get isSurnameValid => surname.trim().isNotEmpty;

  bool get isEmailValid {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return false;
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    return emailRegex.hasMatch(trimmedEmail);
  }

  bool get isPhoneValid => phone.trim().isNotEmpty;
  bool get isPasswordValid => password.trim().length >= 6;
  bool get isRepeatPasswordValid =>
      repeatPassword.isNotEmpty && password == repeatPassword;
  bool get isTermsValid => agreedToTerms;

  bool get isAboutMyselfValid => !isExpert || aboutMyself.trim().isNotEmpty;
  bool get isExperienceValid => !isExpert || experience.trim().isNotEmpty;

  bool get isCostValid {
    if (!isExpert) {
      return true;
    }
    final parsedCost = double.tryParse(cost.trim());
    return parsedCost != null && parsedCost > 0;
  }

  bool get isCategoriesValid => !isExpert || categoriesOfExpertise.isNotEmpty;

  bool get isValid {
    final baseValid = isNameValid &&
        isSurnameValid &&
        isEmailValid &&
        isPhoneValid &&
        isPasswordValid &&
        isRepeatPasswordValid &&
        isTermsValid;

    if (!baseValid) {
      return false;
    }

    if (!isExpert) {
      return true;
    }

    return isAboutMyselfValid &&
        isExperienceValid &&
        isCostValid &&
        isCategoriesValid;
  }

  @override
  List<Object?> get props => [
        status,
        userType,
        name,
        surname,
        email,
        phone,
        password,
        repeatPassword,
        aboutMyself,
        experience,
        cost,
        categoriesOfExpertise,
        availableCategories,
        agreedToTerms,
        errorMessage,
        submitAttempted,
        nameTouched,
        surnameTouched,
        emailTouched,
        phoneTouched,
        passwordTouched,
        repeatPasswordTouched,
        aboutMyselfTouched,
        experienceTouched,
        costTouched,
        categoriesTouched,
        termsTouched,
      ];
}
