import 'package:flutter/material.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// ForgotPasswordScreen: Password recovery request screen (Frame 8)
/// Features top-left back arrow, SimZelo wordmark, Teal outline padlock badge,
/// email validation, 'Send Reset Link' primary button, and 'Back to Login' button.
/// Fully theme-adaptive with COLOR_SCHEME.md tokens.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      final email = _emailController.text.trim();
      Navigator.pushNamed(
        context,
        '/check-email',
        arguments: email,
      );
    }
  }

  void _onBackToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.maybePop(context),
        ),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Center Teal outline padlock icon in a soft circular container
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
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
                        Icons.lock_reset_rounded,
                        size: 40,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Heading & Subtitle
                Center(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Don't worry! Enter your registered email address and we'll send you a password reset link.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Email Address Field
                CustomTextField(
                  label: 'Email Address',
                  hintText: 'Enter your registered email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your registered email address';
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Primary Button 'Send Reset Link'
                PrimaryButton(
                  text: 'Send Reset Link',
                  isLoading: _isLoading,
                  onPressed: _onSendResetLink,
                ),

                const SizedBox(height: 20),

                // 'Back to Login' button
                Center(
                  child: TextButton.icon(
                    onPressed: _onBackToLogin,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    label: Text(
                      'Back to Login',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
