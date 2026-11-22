import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simzelo_app/main.dart';
import 'package:simzelo_app/features/auth/signup_step1_screen.dart';
import 'package:simzelo_app/features/auth/signup_step2_screen.dart';
import 'package:simzelo_app/features/auth/login_screen.dart';
import 'package:simzelo_app/features/auth/forgot_password_screen.dart';
import 'package:simzelo_app/features/auth/check_email_screen.dart';

void main() {
  testWidgets('SimZelo app smoke test loads Splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SimZeloApp());

    // Verify tagline appears
    expect(find.text('Find your best network, at the best price.'), findsOneWidget);

    // Verify wordmark appears
    expect(find.text('SimZelo'), findsOneWidget);
  });

  testWidgets('Onboarding 3-step carousel navigation and controls test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400 * 2, 850 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SimZeloApp());

    // Advance splash screen timer (2.5 seconds)
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Slide 1 checks
    expect(find.text('Find the Best Network Near You'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next →'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    // Tap Next to advance to Slide 2
    await tester.tap(find.text('Next →'));
    await tester.pumpAndSettle();

    // Slide 2 checks
    expect(find.text('Find Network Based on Your Location'), findsOneWidget);
    expect(find.text('Enable Location Access'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Tap 'Enable Location Access' to trigger dialog
    final locationBtn = find.text('Enable Location Access');
    await tester.tap(locationBtn);
    await tester.pumpAndSettle();
    expect(find.text('Allow Location Access?'), findsOneWidget);

    // Grant permission
    await tester.tap(find.text('While Using App'));
    await tester.pumpAndSettle();
    expect(find.text('Location Access Enabled'), findsOneWidget);

    // Advance to Slide 3
    await tester.tap(find.text('Next →'));
    await tester.pumpAndSettle();

    // Slide 3 checks
    expect(find.text('Compare Mobile Packages'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    // Skip must be hidden on Slide 3
    expect(find.text('Skip'), findsNothing);

    // Tap 'Get Started' to verify navigation to /signup-step1
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpStep1Screen), findsOneWidget);
  });

  testWidgets('Registration 2-Step Flow (Step 1 and Step 2) form validation test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400 * 2, 850 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SimZeloApp());

    // Advance splash to onboarding
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Skip directly to /signup-step1
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpStep1Screen), findsOneWidget);
    expect(find.text('Step 1 of 2'), findsOneWidget);
    expect(find.text('+92'), findsOneWidget);

    // Attempt continue with empty fields -> should trigger validation
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your mobile number'), findsOneWidget);

    // Fill valid Full Name
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your full name'), 'John Doe');

    // Fill invalid mobile number
    await tester.enterText(find.widgetWithText(TextFormField, '3XX XXXXXXX'), '12345');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter valid 10-digit number (e.g. 3001234567)'), findsOneWidget);

    // Fill valid Pakistani mobile number
    await tester.enterText(find.widgetWithText(TextFormField, '3XX XXXXXXX'), '3001234567');

    // Select Network from dropdown
    final networkDropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(networkDropdown);
    await tester.tap(networkDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jazz').last);
    await tester.pumpAndSettle();

    // Tap Continue -> navigate to Step 2
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify Step 2 loaded
    expect(find.byType(SignUpStep2Screen), findsOneWidget);
    expect(find.text('Step 2 of 2'), findsOneWidget);
    expect(find.text('Secure Your Account'), findsOneWidget);
    expect(find.text('Hi John Doe, create your login details to protect your account.'), findsOneWidget);

    // Attempt creation without filling fields or agreeing to terms
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(find.text('Please create a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
    expect(find.text('Please agree to the Terms & Conditions and Privacy Policy.'), findsOneWidget);

    // Fill valid email and mismatched passwords
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your email address'), 'john@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Create a password'), 'secretPass123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Re-enter your password'), 'differentPass');

    // Agree to terms
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);

    // Fix password match
    await tester.enterText(find.widgetWithText(TextFormField, 'Re-enter your password'), 'secretPass123');
    await tester.pumpAndSettle();

    // Tap Create Account
    await tester.tap(find.text('Create Account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Verify success dialog appears
    expect(find.text('Account Created!'), findsOneWidget);
  });

  testWidgets('LoginScreen form validation, Google sign in, and routes test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400 * 2, 850 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SimZeloApp());

    // Advance splash
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Tap Log in from onboarding
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    // Verify Login Screen widgets
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Log in to find the best network for you.'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    // Empty login attempt
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your mobile number or email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Invalid email / phone format
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter mobile number or email'), 'invaliduser');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address or mobile number'), findsOneWidget);

    // Valid email and password
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter mobile number or email'), 'user@simzelo.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), 'myPassword123');
    await tester.pumpAndSettle();

    // Perform Login
    await tester.tap(find.text('Login'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back to SimZelo!'), findsOneWidget);

    // Test Google Sign In button
    final googleBtn = find.text('Continue with Google');
    await tester.ensureVisible(googleBtn);
    await tester.tap(googleBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    expect(find.text('Signed in with Google successfully!'), findsOneWidget);
  });

  testWidgets('Password Recovery Flow: ForgotPasswordScreen to CheckEmailScreen test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400 * 2, 850 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SimZeloApp());

    // Advance splash
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Go to login
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    // Go to Forgot Password
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    // Verify ForgotPasswordScreen loaded
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Validate empty email submission
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your registered email address'), findsOneWidget);

    // Enter valid recovery email
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter your registered email'),
      'resetuser@simzelo.com',
    );
    await tester.pumpAndSettle();

    // Submit reset link
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    // Verify CheckEmailScreen loaded with dynamic email interpolation
    expect(find.byType(CheckEmailScreen), findsOneWidget);
    expect(find.text('Check Your Email !'), findsOneWidget);
    expect(find.textContaining('resetuser@simzelo.com'), findsOneWidget);
    expect(find.text('Email Sent'), findsOneWidget);

    // Test 30-second resend countdown timer
    expect(find.text('Resend Link'), findsOneWidget);
    await tester.tap(find.text('Resend Link'));
    await tester.pump();
    expect(find.text('Resend in 30s'), findsOneWidget);

    // Advance 5 seconds
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Resend in 25s'), findsOneWidget);

    // Tap Back to Login (clears stack back to /login)
    await tester.tap(find.text('Back to Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
