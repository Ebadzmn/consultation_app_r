import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpBloc({required this.signUpUseCase}) : super(const SignUpState()) {
    on<SignUpUserTypeChanged>(_onUserTypeChanged);
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpSurnameChanged>(_onSurnameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPhoneChanged>(_onPhoneChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpRepeatPasswordChanged>(_onRepeatPasswordChanged);
    on<SignUpAboutMyselfChanged>(_onAboutMyselfChanged);
    on<SignUpExperienceChanged>(_onExperienceChanged);
    on<SignUpCostChanged>(_onCostChanged);
    on<SignUpCategoryToggled>(_onCategoryToggled);
    on<SignUpTermsChanged>(_onTermsChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onUserTypeChanged(
      SignUpUserTypeChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        userType: event.userType,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onNameChanged(SignUpNameChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        name: event.name,
        nameTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onSurnameChanged(SignUpSurnameChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        surname: event.surname,
        surnameTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        emailTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onPhoneChanged(SignUpPhoneChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        phone: event.phone,
        phoneTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        passwordTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onRepeatPasswordChanged(
      SignUpRepeatPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        repeatPassword: event.repeatPassword,
        repeatPasswordTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onAboutMyselfChanged(
      SignUpAboutMyselfChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        aboutMyself: event.aboutMyself,
        aboutMyselfTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onExperienceChanged(
      SignUpExperienceChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        experience: event.experience,
        experienceTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onCostChanged(SignUpCostChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        cost: event.cost,
        costTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onCategoryToggled(
      SignUpCategoryToggled event, Emitter<SignUpState> emit) {
    final next = List<String>.from(state.categoriesOfExpertise);

    if (event.selected) {
      if (!next.contains(event.category)) {
        next.add(event.category);
      }
    } else {
      next.remove(event.category);
    }

    emit(
      state.copyWith(
        categoriesOfExpertise: next,
        categoriesTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onTermsChanged(SignUpTermsChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        agreedToTerms: event.agreed,
        termsTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(
      state.copyWith(
        submitAttempted: true,
        nameTouched: true,
        surnameTouched: true,
        emailTouched: true,
        phoneTouched: true,
        passwordTouched: true,
        repeatPasswordTouched: true,
        aboutMyselfTouched: state.isExpert ? true : state.aboutMyselfTouched,
        experienceTouched: state.isExpert ? true : state.experienceTouched,
        costTouched: state.isExpert ? true : state.costTouched,
        categoriesTouched: state.isExpert ? true : state.categoriesTouched,
        termsTouched: true,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );

    if (!state.isValid) {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: 'Invalid form',
        ),
      );
      return;
    }

    emit(state.copyWith(status: SignUpStatus.loading));

    final isExpert = state.userType == 'Expert';

    final result = await signUpUseCase(SignUpParams(
      name: state.name,
      surname: state.surname,
      email: state.email,
      phoneNumber: state.phone,
      password: state.password,
      userType: state.userType,
      aboutMyself: isExpert ? state.aboutMyself : null,
      experience: isExpert ? state.experience : null,
      cost: isExpert ? state.cost : null,
      categoriesOfExpertise: isExpert ? state.categoriesOfExpertise : const [],
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          status: SignUpStatus.failure, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: SignUpStatus.success)),
    );
  }
}
