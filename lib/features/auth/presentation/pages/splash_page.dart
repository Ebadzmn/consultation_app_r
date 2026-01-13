import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/injection_container.dart' as di;
import 'package:consultant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:consultant_app/core/config/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Small delay to show splash screen if it loads too fast
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    try {
      final result = await di.sl<AuthRepository>().tryAutoLogin();

      if (!mounted) return;

      result.fold(
        (failure) {
          di.currentUser.value = null;
          context.go(AppRoutes.signIn);
        },
        (user) {
          di.currentUser.value = user;
          if (user != null) {
            if (user.userType.toLowerCase().contains('expert')) {
              context.go(AppRoutes.experts);
            } else {
              context.go(AppRoutes.experts);
            }
          } else {
            context.go(AppRoutes.signIn);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        di.currentUser.value = null;
        context.go(AppRoutes.signIn);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF33354E), // Match app theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for logo
            Icon(Icons.rocket_launch, size: 80, color: Color(0xFF66BB6A)),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Color(0xFF66BB6A)),
          ],
        ),
      ),
    );
  }
}
