import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// LoginScreen: User authentication screen (Frame 7)
/// Features top uniform Teal outline user badge, SimZelo wordmark, live theme switcher,
/// email/phone validation, password toggle, 'Forgot Password?' link, 'Continue with Google',
/// and dynamic theme compliance with COLOR_SCHEME.md.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network authentication
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      final colorScheme = Theme.of(context).colorScheme;

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
                  'Welcome back to SimZelo!',
                  style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }

  Future<void> _onGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    // Simulate Google OAuth
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() {
      _isGoogleLoading = false;
    });

    final colorScheme = Theme.of(context).colorScheme;

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
                'Signed in with Google successfully!',
                style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  void _onForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  void _onSignUp() {
    Navigator.pushNamed(context, '/signup-step1');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: Navigator.canPop(context),
        actions: [
          // Theme Switcher Button for testing Light/Dark themes
          const ThemeSwitcherButton(),
          const SizedBox(width: 4),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Top uniform Teal outline user-login icon in a soft circular badge
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
                        Icons.person_pin_rounded,
                        size: 40,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 'Welcome Back' heading and subtitle
                Center(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Log in to find the best network for you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Mobile Number or Email field
                CustomTextField(
                  label: 'Mobile Number or Email',
                  hintText: 'Enter mobile number or email',
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your mobile number or email';
                    }
                    final input = value.trim();
                    final isEmail = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(input);
                    final isPhone = RegExp(r'^\+?[0-9]{10,13}$').hasMatch(
                      input.replaceAll(RegExp(r'\s+|-'), ''),
                    );

                    if (!isEmail && !isPhone) {
                      return 'Enter a valid email address or mobile number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Password with show/hide eye toggle
                CustomTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // Right-aligned 'Forgot Password?' text button directly underneath Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _onForgotPassword,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      minimumSize: const Size(44, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Full-width 'Login' primary button
                PrimaryButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: _onLogin,
                ),

                const SizedBox(height: 22),

                // Horizontal divider with 'OR'
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorScheme.outline,
                        thickness: 1.2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: colorScheme.outline,
                        thickness: 1.2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Secondary outlined button 'Continue with Google'
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isGoogleLoading ? null : _onGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      side: BorderSide(color: colorScheme.outline, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isGoogleLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _GoogleIconBadge(),
                              const SizedBox(width: 10),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // Bottom footer: 'Don't have an account? Sign Up' routing to /signup-step1
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _onSignUp,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                          child: Text(
                            'Sign Up',
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

/// A crisp, vector Google 'G' icon rendered with official brand colors
class _GoogleIconBadge extends StatelessWidget {
  const _GoogleIconBadge();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double strokeWidth = w * 0.22;

    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      w - strokeWidth,
      h - strokeWidth,
    );

    final Paint bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw 4 color arcs
    // Red (top)
    canvas.drawArc(rect, 3.14159 * 1.25, 3.14159 * 0.5, false, redPaint);
    // Yellow (left)
    canvas.drawArc(rect, 3.14159 * 0.75, 3.14159 * 0.5, false, yellowPaint);
    // Green (bottom)
    canvas.drawArc(rect, 3.14159 * 0.25, 3.14159 * 0.5, false, greenPaint);
    // Blue (right)
    canvas.drawArc(rect, -3.14159 * 0.25, 3.14159 * 0.5, false, bluePaint);

    // Draw Blue horizontal crossbar
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final Rect barRect = Rect.fromLTWH(
      w * 0.45,
      h * 0.40,
      w * 0.55 - strokeWidth / 2,
      strokeWidth,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
