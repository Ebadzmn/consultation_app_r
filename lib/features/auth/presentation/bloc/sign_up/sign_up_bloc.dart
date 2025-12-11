import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpBloc({required this.signUpUseCase}) : super(const SignUpState()) {
    on<SignUpUserTypeChanged>(_onUserTypeChanged);
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPhoneChanged>(_onPhoneChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpRepeatPasswordChanged>(_onRepeatPasswordChanged);
    on<SignUpTermsChanged>(_onTermsChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onUserTypeChanged(
      SignUpUserTypeChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(userType: event.userType));
  }

  void _onNameChanged(SignUpNameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPhoneChanged(SignUpPhoneChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onRepeatPasswordChanged(
      SignUpRepeatPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(repeatPassword: event.repeatPassword));
  }

  void _onTermsChanged(SignUpTermsChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(agreedToTerms: event.agreed));
  }

  Future<void> _onSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: SignUpStatus.failure, errorMessage: "Invalid form"));
      return;
    }

    emit(state.copyWith(status: SignUpStatus.loading));

    final result = await signUpUseCase(SignUpParams(
      name: state.name,
      email: state.email,
      password: state.password,
      userType: state.userType,
      phoneNumber: state.phone.isNotEmpty ? state.phone : null,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          status: SignUpStatus.failure, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: SignUpStatus.success)),
    );
  }
}
