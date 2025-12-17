import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginUserTypeChanged>(_onUserTypeChanged);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginErrorDismissed>(_onErrorDismissed);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onUserTypeChanged(
    LoginUserTypeChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        isExpert: event.isExpert,
        status: LoginStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        emailTouched: true,
        status: LoginStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        passwordTouched: true,
        status: LoginStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onErrorDismissed(LoginErrorDismissed event, Emitter<LoginState> emit) {
    emit(state.copyWith(errorMessage: '', status: LoginStatus.initial));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        submitAttempted: true,
        emailTouched: true,
        passwordTouched: true,
        status: LoginStatus.initial,
        errorMessage: null,
      ),
    );

    final email = state.email;
    final password = state.password;

    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Please fill in the required fields',
        ),
      );
      return;
    }

    if (!state.isEmailValid) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Please enter a valid email address',
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Mock success
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Authentication failed',
        ),
      );
    }
  }
}
