import 'package:consultant_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:consultant_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/my_profile_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/expert_public_profile_page.dart';
import 'package:consultant_app/features/experts/presentation/pages/experts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String expertPublicProfile = '/expert-public-profile';
  static const String myProfile = '/my-profile';
  static const String experts = '/experts';



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

final GoRouter AppRouter = GoRouter(
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
      path: AppRoutes.signIn,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const SignInPage(),
      ),
    ),
  ],
);
