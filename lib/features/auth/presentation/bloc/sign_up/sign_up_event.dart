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

class SignUpTermsChanged extends SignUpEvent {
  final bool agreed;
  const SignUpTermsChanged(this.agreed);

  @override
  List<Object?> get props => [agreed];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
