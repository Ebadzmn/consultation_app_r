import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:consultant_app/injection_container.dart' as di;

import 'package:consultant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:consultant_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:consultant_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:consultant_app/core/usecases/usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase signInUseCase;
  final GetProfileUseCase getProfileUseCase;

  LoginBloc({required this.signInUseCase, required this.getProfileUseCase})
    : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginErrorDismissed>(_onErrorDismissed);
    on<LoginSubmitted>(_onSubmitted);
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

    // 1. Sign In
    final signInResult = await signInUseCase(
      SignInParams(username: email.trim(), password: password.trim()),
    );

    await signInResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) async {
        // 2. Fetch Profile to Determine Role
        final profileResult = await getProfileUseCase(NoParams());

        profileResult.fold(
          (failure) {
            emit(
              state.copyWith(
                status: LoginStatus.failure,
                errorMessage:
                    'Login successful but failed to fetch profile: ${failure.message}',
              ),
            );
          },
          (userProfile) {
            String userType = userProfile.userType;
            // Normalize userType if needed
            // If the API returns 0/1 as int, userType in UserModel might be "0" or "1" string
            // Logic: 1 = Expert, 0 = Client

            bool isExpert = false;
            if (userType == "1" || userType.toLowerCase() == "expert") {
              isExpert = true;
            }

            debugPrint(
              'LoginBloc: Profile Fetched. UserType: $userType, isExpert: $isExpert',
            );

            // Update global user
            di.currentUser.value = userProfile;
            di.sl<AuthRepository>().persistUser(userProfile);

            emit(
              state.copyWith(status: LoginStatus.success, isExpert: isExpert),
            );
          },
        );
      },
    );
  }
}
