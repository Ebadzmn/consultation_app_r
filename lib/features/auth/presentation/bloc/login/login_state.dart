part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final bool isExpert;
  final String email;
  final String password;
  final LoginStatus status;
  final String? errorMessage;
  final bool emailTouched;
  final bool passwordTouched;
  final bool submitAttempted;

  const LoginState({
    this.isExpert =
        false, // Default to Client as per typical UX, or could be true if "Expert" is left side
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.emailTouched = false,
    this.passwordTouched = false,
    this.submitAttempted = false,
  });

  bool get isEmailValid {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return false;
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    return emailRegex.hasMatch(trimmedEmail);
  }

  bool get isPasswordValid => password.trim().isNotEmpty;

  LoginState copyWith({
    bool? isExpert,
    String? email,
    String? password,
    LoginStatus? status,
    String? errorMessage,
    bool? emailTouched,
    bool? passwordTouched,
    bool? submitAttempted,
  }) {
    return LoginState(
      isExpert: isExpert ?? this.isExpert,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      emailTouched: emailTouched ?? this.emailTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      submitAttempted: submitAttempted ?? this.submitAttempted,
    );
  }

  @override
  List<Object?> get props => [
        isExpert,
        email,
        password,
        status,
        errorMessage,
        emailTouched,
        passwordTouched,
        submitAttempted,
      ];
}
