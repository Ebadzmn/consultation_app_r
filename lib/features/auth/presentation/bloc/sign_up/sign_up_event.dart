import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpUserTypeChanged extends SignUpEvent {
  final String userType;
  const SignUpUserTypeChanged(this.userType);

  @override
  List<Object?> get props => [userType];
}

class SignUpNameChanged extends SignUpEvent {
  final String name;
  const SignUpNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class SignUpSurnameChanged extends SignUpEvent {
  final String surname;
  const SignUpSurnameChanged(this.surname);

  @override
  List<Object?> get props => [surname];
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;
  const SignUpEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignUpPhoneChanged extends SignUpEvent {
  final String phone;
  const SignUpPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;
  const SignUpPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignUpRepeatPasswordChanged extends SignUpEvent {
  final String repeatPassword;
  const SignUpRepeatPasswordChanged(this.repeatPassword);

  @override
  List<Object?> get props => [repeatPassword];
}

class SignUpAboutMyselfChanged extends SignUpEvent {
  final String aboutMyself;
  const SignUpAboutMyselfChanged(this.aboutMyself);

  @override
  List<Object?> get props => [aboutMyself];
}

class SignUpExperienceChanged extends SignUpEvent {
  final String experience;
  const SignUpExperienceChanged(this.experience);

  @override
  List<Object?> get props => [experience];
}

class SignUpCostChanged extends SignUpEvent {
  final String cost;
  const SignUpCostChanged(this.cost);

  @override
  List<Object?> get props => [cost];
}

class SignUpCategoryToggled extends SignUpEvent {
  final String category;
  final bool selected;

  const SignUpCategoryToggled({required this.category, required this.selected});

  @override
  List<Object?> get props => [category, selected];
}

class SignUpTermsChanged extends SignUpEvent {
  final bool agreed;
  const SignUpTermsChanged(this.agreed);

  @override
  List<Object?> get props => [agreed];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}

class SignUpCategoriesRequested extends SignUpEvent {
  const SignUpCategoriesRequested();
}
