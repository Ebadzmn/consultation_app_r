import 'package:equatable/equatable.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final String userType;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String repeatPassword;
  final bool agreedToTerms;
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.userType = 'Client',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.repeatPassword = '',
    this.agreedToTerms = false,
    this.errorMessage,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? userType,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? repeatPassword,
    bool? agreedToTerms,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      errorMessage: errorMessage,
    );
  }

  bool get isValid {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        repeatPassword.isNotEmpty &&
        password == repeatPassword &&
        agreedToTerms;
  }

  @override
  List<Object?> get props => [
        status,
        userType,
        name,
        email,
        phone,
        password,
        repeatPassword,
        agreedToTerms,
        errorMessage,
      ];
}
