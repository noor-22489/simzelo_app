import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/primary_button.dart';
import 'widgets/onboarding_illustrations.dart';

/// OnboardingModel defines slide content
class _OnboardingSlide {
  final String title;
  final String subtitle;
  final Widget illustration;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });
}

/// OnboardingScreen: 3-step carousel with interactive permissions,
/// animated Teal indicators, theme-toggle, back/next/get-started controls, and login link.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLocationGranted = false;

  late final List<_OnboardingSlide> _slides;

  @override
  void initState() {
    super.initState();
    _slides = const [
      _OnboardingSlide(
        title: 'Find the Best Network Near You',
        subtitle:
            'Discover mobile networks with better coverage and signal strength in your area.',
        illustration: Slide1NetworkWavesIllustration(),
      ),
      _OnboardingSlide(
        title: 'Find Network Based on Your Location',
        subtitle:
            'Allow location access to discover mobile network coverage and signal availability around your current area.',
        illustration: Slide2LocationMapIllustration(),
      ),
      _OnboardingSlide(
        title: 'Compare Mobile Packages',
        subtitle:
            'Compare prices, internet data, calling minutes and package validity across different networks.',
        illustration: Slide3ComparisonIllustration(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _onGetStarted();
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, '/signup-step1');
  }

  void _onGetStarted() {
    Navigator.pushNamed(context, '/signup-step1');
  }

  void _onLogin() {
    Navigator.pushNamed(context, '/login');
  }

  Future<void> _requestLocationPermission() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final granted = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.surface,
          title: Row(
            children: [
              Icon(Icons.location_on_rounded, color: colorScheme.secondary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Allow Location Access?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'SimZelo uses your device location to identify surrounding cell towers and determine the strongest mobile network in your exact neighborhood.',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: TextButton.styleFrom(
                minimumSize: const Size(80, 44),
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
              child: const Text('Don\'t Allow'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                minimumSize: const Size(120, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'While Using App',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (granted == true && mounted) {
      setState(() {
        _isLocationGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with ThemeSwitcher on left and 44x44px Skip on right
            _buildTopBar(colorScheme),

            // PageView Carousel with 3 slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        slide.illustration,
                        const SizedBox(height: 20),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        // Interactive 'Enable Location Access' button exclusively on Slide 2
                        if (index == 1) ...[
                          const SizedBox(height: 16),
                          _buildLocationButton(colorScheme),
                        ],
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Controls Area
            _buildBottomControls(colorScheme),
          ],
        ),
      ),
    );
  }

  /// Top Bar with subtle theme switcher (left) and 44x44px Skip button (right, Slides 1 & 2)
  Widget _buildTopBar(ColorScheme colorScheme) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Theme Switcher Button (cleanly spaced from Skip)
          const ThemeSwitcherButton(),

          // Skip Button with minimum 44x44 tap target
          _currentPage < 2
              ? ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  child: TextButton(
                    onPressed: _onSkip,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(44, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: 44, height: 44),
        ],
      ),
    );
  }

  /// Interactive Location Permission Action on Slide 2
  Widget _buildLocationButton(ColorScheme colorScheme) {
    final activeColor = colorScheme.secondary;
    final primaryColor = colorScheme.primary;

    return OutlinedButton.icon(
      onPressed: _requestLocationPermission,
      icon: Icon(
        _isLocationGranted ? Icons.check_circle_rounded : Icons.my_location_rounded,
        color: _isLocationGranted ? activeColor : primaryColor,
        size: 18,
      ),
      label: Text(
        _isLocationGranted ? 'Location Access Enabled' : 'Enable Location Access',
        style: TextStyle(
          color: _isLocationGranted ? activeColor : primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(200, 44),
        side: BorderSide(
          color: _isLocationGranted ? activeColor : colorScheme.outline,
          width: 1.4,
        ),
        backgroundColor: _isLocationGranted
            ? activeColor.withValues(alpha: 0.12)
            : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Bottom Section: 3-dot indicator, CTA buttons (Back/Next/Get Started), & Login link
  Widget _buildBottomControls(ColorScheme colorScheme) {
    final isLastSlide = _currentPage == _slides.length - 1;
    final hasBack = _currentPage > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated 3-dot page indicator in Teal
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (index) {
              final isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: isActive ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: isActive ? colorScheme.secondary : colorScheme.outline,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Action Buttons: Back button (Slides 2-3) & Primary CTA (Next / Get Started)
          Row(
            children: [
              if (hasBack) ...[
                // Back Button with min 44x44 tap target
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  child: OutlinedButton(
                    onPressed: _onBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(88, 52),
                      side: BorderSide(color: colorScheme.outline, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: colorScheme.surface,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: PrimaryButton(
                  text: isLastSlide ? 'Get Started' : 'Next →',
                  onPressed: _onNext,
                  height: 52,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Footer Link: 'Already have an account? Log in'
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: _onLogin,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  child: Text(
                    'Log in',
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
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
