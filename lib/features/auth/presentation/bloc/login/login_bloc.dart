import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:consultant_app/injection_container.dart' as di;
import 'package:consultant_app/features/auth/data/models/user_model.dart';
import 'package:consultant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:consultant_app/features/auth/domain/usecases/sign_in_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase signInUseCase;

  LoginBloc({required this.signInUseCase}) : super(const LoginState()) {
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
    debugPrint(
      'LoginBloc: UserType changed to ${event.isExpert ? "Expert" : "Client"}',
    );
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

    final result = await signInUseCase(
      SignInParams(username: email.trim(), password: password.trim()),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        // Prioritize the UI selection for navigation and dashboard mode
        final isExpertResult = state.isExpert;

        debugPrint(
          'LoginBloc: Success. UI selected isExpert: ${state.isExpert}, Server said: ${user.userType}. Using Final: $isExpertResult',
        );

        // Update global user with the UI-selected role for consistency in navigation/dashboard
        if (user is UserModel) {
          final updatedUser = user.copyWith(
            userType: isExpertResult ? 'Expert' : 'Client',
          );
          di.currentUser.value = updatedUser;
          // Persist the spoofed user so it survives app restart
          di.sl<AuthRepository>().persistUser(updatedUser);
        } else {
          di.currentUser.value = user;
          di.sl<AuthRepository>().persistUser(user);
        }

        emit(
          state.copyWith(status: LoginStatus.success, isExpert: isExpertResult),
        );
      },
    );
  }
}
