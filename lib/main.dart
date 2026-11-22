import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/onboarding/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/signup_step1_screen.dart';
import 'features/auth/signup_step2_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/check_email_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SimZeloApp());
}

class SimZeloApp extends StatelessWidget {
  const SimZeloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'SimZelo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: currentMode,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/signup-step1': (context) => const SignUpStep1Screen(),
            '/signup-step2': (context) => const SignUpStep2Screen(),
            '/login': (context) => const LoginScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/check-email': (context) => const CheckEmailScreen(),
          },
        );
      },
    );
  }
}
