import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:consultant_app/injection_container.dart' as di;
import 'package:consultant_app/features/auth/domain/entities/user_entity.dart';

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
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();

      UserEntity? user;
      if (trimmedEmail == 'ebadzmn1@gmail.com' && trimmedPassword == '112233') {
        user = const UserEntity(
          id: 'c-1',
          name: 'Normal Client',
          email: 'ebadzmn1@gmail.com',
          userType: 'Client',
        );
      } else if (trimmedEmail == 'ebadzmn2@gmail.com' &&
          trimmedPassword == '11223344') {
        user = const UserEntity(
          id: 'e-1',
          name: 'Expert Client',
          email: 'ebadzmn2@gmail.com',
          userType: 'Expert',
        );
      }

      if (user == null) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Invalid credentials',
          ),
        );
        return;
      }

      di.currentUser.value = user;
      emit(
        state.copyWith(
          status: LoginStatus.success,
          isExpert: user.userType == 'Expert',
        ),
      );
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
