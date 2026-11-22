import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';

/// CheckEmailScreen: Password reset email confirmation screen (Frame 9)
/// Features Teal envelope badge, dynamic email interpolation, subtle confirmation card,
/// 'Back to Login' CTA, and anti-spam 30-second resend countdown timer.
/// Fully theme-adaptive with COLOR_SCHEME.md tokens.
class CheckEmailScreen extends StatefulWidget {
  final String? email;

  const CheckEmailScreen({
    super.key,
    this.email,
  });

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  Timer? _countdownTimer;
  int _resendCountdown = 0;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 30;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCountdown > 1) {
          _resendCountdown--;
        } else {
          _resendCountdown = 0;
          timer.cancel();
        }
      });
    });
  }

  void _onResendEmail(String targetEmail, ColorScheme colorScheme) {
    if (_resendCountdown > 0) return;

    _startResendTimer();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.primary,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: colorScheme.onPrimary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Password reset link resent to $targetEmail',
                style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2400),
      ),
    );
  }

  void _onBackToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final routeEmail = ModalRoute.of(context)?.settings.arguments as String?;
    final resolvedEmail = widget.email ?? routeEmail ?? 'your registered email';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                'SimZelo',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Teal outline envelope-check icon in a soft circular container
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.35),
                    width: 1.8,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    size: 42,
                    color: colorScheme.secondary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Heading: 'Check Your Email !'
              Text(
                'Check Your Email !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle dynamically showing the passed email address
              Text.rich(
                TextSpan(
                  text: "We've sent a password reset link to ",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.45,
                  ),
                  children: [
                    TextSpan(
                      text: resolvedEmail,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Subtle Teal-tinted confirmation card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.30),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Email Sent',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please check your inbox and follow the instructions to reset your password.',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Primary button 'Back to Login' (clears stack back to /login)
              PrimaryButton(
                text: 'Back to Login',
                onPressed: _onBackToLogin,
              ),

              const SizedBox(height: 24),

              // Footer 'Didn't receive the email? Resend Link' with 30s countdown timer
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Didn't receive the email? ",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  _resendCountdown > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                          child: Text(
                            'Resend in ${_resendCountdown}s',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => _onResendEmail(resolvedEmail, colorScheme),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                            child: Text(
                              'Resend Link',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
