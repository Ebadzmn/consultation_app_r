import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../bloc/sign_up/sign_up_bloc.dart';
import '../bloc/sign_up/sign_up_event.dart';
import '../bloc/sign_up/sign_up_state.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        } else if (state.status == SignUpStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Sign Up Success')));
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              "SIGN UP",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E3E), // Dark color
              ),
            ),
            const SizedBox(height: 30),
            _UserTypeSelector(),
            const SizedBox(height: 30),
            _NameInput(),
            const SizedBox(height: 16),
            _EmailInput(),
            const SizedBox(height: 16),
            _PhoneInput(),
            const SizedBox(height: 16),
            _PasswordInput(),
            const SizedBox(height: 16),
            _RepeatPasswordInput(),
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

class _UserTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.userType != current.userType,
      builder: (context, state) {
        final isExpert = state.userType == 'Expert';
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<SignUpBloc>().add(
                    const SignUpUserTypeChanged('Expert'),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isExpert ? const Color(0xFF5B5E7D) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: isExpert
                        ? null
                        : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    "Expert",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isExpert ? Colors.white : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<SignUpBloc>().add(
                    const SignUpUserTypeChanged('Client'),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !isExpert
                        ? const Color(
                            0xFF5B5E7D,
                          ) // Assuming same active color? Design shows white for Client but "Expert" is active. Wait.
                        // Design shows: Expert (Active) -> Dark Blue. Client (Inactive) -> White.
                        // If Client is active, it should be Dark Blue? Or maybe different?
                        // Usually active state has the color. Let's assume active gets the dark blue.
                        // But wait, in the design "Expert" is selected.
                        // If I click Client, Client should become Dark Blue?
                        // Or maybe Client is secondary?
                        // I'll stick to: Active = Dark Blue, Inactive = White.
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: !isExpert
                        ? null
                        : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    "Client",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: !isExpert ? Colors.white : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your name",
              style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
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
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email",
              style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
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
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                text: "Phone number ",
                style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
                children: [
                  TextSpan(
                    text:
                        "(not requered)", // Keeping typo as per design or fixing it? User said "design ta same to same hobe".
                    // But usually typos should be fixed. "requered" -> "required".
                    // I will fix it to "required" but keep style.
                    // Wait, user said "same to same". I should check if I should preserve the typo.
                    // Usually I should correct it. "not required".
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
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
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Password",
              style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
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
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.repeatPassword != current.repeatPassword,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Repeat password",
              style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 16),
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
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.agreedToTerms != current.agreedToTerms,
      builder: (context, state) {
        return Row(
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
                text: const TextSpan(
                  text: "I have read and agree to ",
                  style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 14),
                  children: [
                    TextSpan(
                      text: "the personal data processing policy",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: state.isValid
                ? () {
                    context.read<SignUpBloc>().add(const SignUpSubmitted());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A), // Green color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: const Color(0xFF66BB6A).withOpacity(0.5),
            ),
            child: state.status == SignUpStatus.loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Sign Up",
                    style: TextStyle(
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
    return Center(
      child: RichText(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: "I already have account. ",
          style: TextStyle(color: Color(0xFF2E2E3E), fontSize: 14),
          children: [
            TextSpan(
              text: "Sign in",
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
