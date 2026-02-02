import 'package:consultant_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import 'package:consultant_app/injection_container.dart' as di;

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LoginBloc>(),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        titleSpacing: 0,
        centerTitle: false,
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            debugPrint('SignInView: Login Failure: ${state.errorMessage}');
          }
          if (state.status == LoginStatus.success) {
            debugPrint(
              'SignInView: Login Success. isExpert: ${state.isExpert}',
            );
            // As per latest requirement, route to Experts page instead of Consultations
            context.go(AppRoutes.experts);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.signInTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C), // Dark blue-ish color from design
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.email,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _EmailInput(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // Handle phone sign in
                    },
                    child: Text(
                      l10n.signInWithPhoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.withAlpha(
                          128,
                        ), // Light blue link style
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.password,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _PasswordInput(),
                const SizedBox(height: 30),
                _LoginButton(),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    // Navigate to Sign Up
                    context.push('/sign-up');
                  },
                  child: Text(
                    l10n.signUp,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ),
                const Spacer(),
                _ErrorMessageBox(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.emailTouched != current.emailTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.emailTouched || state.submitAttempted) &&
            !state.isEmailValid;
        final borderColor = showError
            ? Colors.red.shade300
            : Colors.grey.shade300;

        return TextField(
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginEmailChanged(value)),
          decoration: InputDecoration(
            hintText: '',
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.passwordTouched != current.passwordTouched ||
          previous.submitAttempted != current.submitAttempted,
      builder: (context, state) {
        final showError =
            (state.passwordTouched || state.submitAttempted) &&
            !state.isPasswordValid;
        final borderColor = showError
            ? Colors.red.shade300
            : Colors.grey.shade300;

        return TextField(
          obscureText: true,
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(value)),
          decoration: InputDecoration(
            hintText: '',
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.status == LoginStatus.loading
                ? null
                : () {
                    context.read<LoginBloc>().add(LoginSubmitted());
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6CC570), // Green color
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: state.status == LoginStatus.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    l10n.signIn,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _ErrorMessageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.errorMessage == null || state.errorMessage!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE5E5), // Light pink bg
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFF6B6B)), // Red border
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 14,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<LoginBloc>().add(LoginErrorDismissed());
                },
                child: const Icon(
                  Icons.close,
                  color: Color(0xFFD32F2F),
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
