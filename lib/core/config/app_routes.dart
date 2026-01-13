import 'package:consultant_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:consultant_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/my_profile_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/expert_public_profile_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/experts_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/appointment_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/consultations_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/pay_now_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/payment_method_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/pay_success_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/new_project_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/project_details_page.dart';
import 'package:consultant_app/features/experts/presentation/models/pay_now_args.dart';
import 'package:consultant_app/features/experts/domain/entities/expert_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String expertPublicProfile = '/expert-public-profile';
  static const String appointment = '/appointment';
  static const String payNow = '/pay-now';
  static const String paymentMethod = '/payment-method';
  static const String paySuccess = '/pay-success';
  static const String myProfile = '/my-profile';
  static const String experts = '/experts';
  static const String consultations = '/consultations';
  static const String newProject = '/new-project';
  static const String projectDetails = '/project-details';

  static Page<dynamic> fadeTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.signIn,
  routes: [
    GoRoute(
      path: AppRoutes.signUp,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const SignUpPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.expertPublicProfile,
      pageBuilder: (context, state) {
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: const ExpertPublicProfilePage(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.appointment,
      pageBuilder: (context, state) {
        final expert = state.extra as ExpertEntity;
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: AppointmentPage(expert: expert),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.payNow,
      pageBuilder: (context, state) {
        final args = state.extra as PayNowArgs;
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: PayNowPage(args: args),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.paySuccess,
      pageBuilder: (context, state) {
        final args = state.extra as PayNowArgs;
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: PaySuccessPage(args: args),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.paymentMethod,
      pageBuilder: (context, state) {
        final args = state.extra as PayNowArgs;
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: PaymentMethodPage(args: args),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.myProfile,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const MyProfilePage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.experts,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ExpertsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.consultations,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ConsultationsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const SignInPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.newProject,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NewProjectPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.projectDetails,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ProjectDetailsPage(),
      ),
    ),
  ],
);
