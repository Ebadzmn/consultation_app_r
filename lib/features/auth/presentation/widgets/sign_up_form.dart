import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import '../bloc/sign_up/sign_up_bloc.dart';
import '../bloc/sign_up/sign_up_event.dart';
import '../bloc/sign_up/sign_up_state.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? l10n.signUpFailure),
              ),
            );
        } else if (state.status == SignUpStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.signUpSuccess)));
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              l10n.signUpTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E3E), // Dark color
              ),
            ),
            const SizedBox(height: 30),
            const _UserTypeToggle(),
            const SizedBox(height: 30),
            _NameInput(),
            const SizedBox(height: 16),
            _SurnameInput(),
            const SizedBox(height: 16),
            _PhoneInput(),
            const SizedBox(height: 16),
            _EmailInput(),
            const SizedBox(height: 16),
            _PasswordInput(),
            const SizedBox(height: 16),
            _RepeatPasswordInput(),
            BlocBuilder<SignUpBloc, SignUpState>(
              buildWhen: (previous, current) =>
                  previous.userType != current.userType,
              builder: (context, state) {
                final isExpert = state.userType == 'Expert';
                if (!isExpert) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _AboutMyselfInput(),
                    const SizedBox(height: 16),
                    _ExperienceInput(),
                    const SizedBox(height: 16),
                    _CostInput(),
                    const SizedBox(height: 16),
                    _CategoriesOfExpertiseInput(),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _TermsCheckbox(),
            const SizedBox(height: 30),
            _SignUpButton(),
            const SizedBox(height: 30),
            _LoginLink(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _UserTypeToggle extends StatelessWidget {
  const _UserTypeToggle();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.userType != current.userType,
      builder: (context, state) {
        final isExpert = state.userType == 'Expert';
        return Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: l10n.expert,
                isSelected: isExpert,
                onTap: () => context
                    .read<SignUpBloc>()
                    .add(const SignUpUserTypeChanged('Expert')),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ToggleButton(
                label: l10n.client,
                isSelected: !isExpert,
                onTap: () => context
                    .read<SignUpBloc>()
                    .add(const SignUpUserTypeChanged('Client')),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF555B7D) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF555B7D) : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2E3E5C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.name != current.name ||
          previous.nameTouched != current.nameTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.nameTouched || state.submitAttempted) && !state.isNameValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.yourName,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(SignUpNameChanged(value)),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SurnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.surname != current.surname ||
          previous.surnameTouched != current.surnameTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError = (state.surnameTouched || state.submitAttempted) &&
            !state.isSurnameValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.surname,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(SignUpSurnameChanged(value)),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.emailTouched != current.emailTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError = (state.emailTouched || state.submitAttempted) &&
            !state.isEmailValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.email,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(SignUpEmailChanged(value)),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.phone != current.phone ||
          previous.phoneTouched != current.phoneTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError = (state.phoneTouched || state.submitAttempted) &&
            !state.isPhoneValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.telephoneNumber,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(SignUpPhoneChanged(value)),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AboutMyselfInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.aboutMyself != current.aboutMyself ||
          previous.aboutMyselfTouched != current.aboutMyselfTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError = (state.aboutMyselfTouched || state.submitAttempted) &&
            !state.isAboutMyselfValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutMyself,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => context
                  .read<SignUpBloc>()
                  .add(SignUpAboutMyselfChanged(value)),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExperienceInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.experience != current.experience ||
          previous.experienceTouched != current.experienceTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.experienceTouched || state.submitAttempted) &&
                !state.isExperienceValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.experience,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => context
                  .read<SignUpBloc>()
                  .add(SignUpExperienceChanged(value)),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CostInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.cost != current.cost ||
          previous.costTouched != current.costTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.costTouched || state.submitAttempted) && !state.isCostValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cost,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(SignUpCostChanged(value)),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoriesOfExpertiseInput extends StatelessWidget {
  static const _categories = <String>[
    'Finance',
    'IT',
    'Legal',
    'Health',
    'Banking',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.categoriesOfExpertise != current.categoriesOfExpertise ||
          previous.categoriesTouched != current.categoriesTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError = (state.categoriesTouched || state.submitAttempted) &&
            !state.isCategoriesValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categoriesOfExpertise,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in _categories)
                    FilterChip(
                      label: Text(category),
                      selected: state.categoriesOfExpertise.contains(category),
                      onSelected: (selected) {
                        context.read<SignUpBloc>().add(
                              SignUpCategoryToggled(
                                category: category,
                                selected: selected,
                              ),
                            );
                      },
                      selectedColor: const Color(0xFF5B5E7D),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: state.categoriesOfExpertise.contains(category)
                            ? Colors.white
                            : const Color(0xFF2E2E3E),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: Colors.white,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.passwordTouched != current.passwordTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError = (state.passwordTouched || state.submitAttempted) &&
            !state.isPasswordValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.password,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(SignUpPasswordChanged(value)),
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RepeatPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.repeatPassword != current.repeatPassword ||
          previous.repeatPasswordTouched != current.repeatPasswordTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.repeatPasswordTouched || state.submitAttempted) &&
                !state.isRepeatPasswordValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.grey.shade300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.repeatPassword,
              style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpRepeatPasswordChanged(value),
              ),
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.agreedToTerms != current.agreedToTerms ||
          previous.termsTouched != current.termsTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.termsTouched || state.submitAttempted) && !state.isTermsValid;
        final borderColor =
            showError ? Colors.red.shade300 : Colors.transparent;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: state.agreedToTerms,
                  activeColor: const Color(0xFF5B5E7D),
                  onChanged: (value) {
                    context.read<SignUpBloc>().add(
                          SignUpTermsChanged(value ?? false),
                        );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: l10n.agreePrefix,
                    style:
                        const TextStyle(color: Color(0xFF2E2E3E), fontSize: 14),
                    children: [
                      TextSpan(
                        text: l10n.agreePolicy,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: state.status == SignUpStatus.loading
                ? null
                : () {
                    context.read<SignUpBloc>().add(const SignUpSubmitted());
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A), // Green color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: state.status == SignUpStatus.loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    l10n.signUp,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: RichText(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: l10n.alreadyHaveAccount,
          style: const TextStyle(color: Color(0xFF2E2E3E), fontSize: 14),
          children: [
            TextSpan(
              text: l10n.signInLink,
              style: const TextStyle(
                color: Color(0xFF2E2E3E),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go(AppRoutes.signIn);
                },
            ),
          ],
        ),
      ),
    );
  }
}
