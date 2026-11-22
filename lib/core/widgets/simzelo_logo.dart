import 'package:flutter/material.dart';

/// SimZeloLogo: Reusable brand widget displaying the 'SZ' SIM-card monogram
/// and 'SimZelo' wordmark.
/// Automatically adapts asset and typography cleanly between Light (#F6F8FB)
/// and Dark (#0B1120) backgrounds, with strictly enforced no-overflow constraints at 360dp.
class SimZeloLogo extends StatelessWidget {
  final double monogramHeight;
  final bool showWordmark;
  final double wordmarkFontSize;
  final double spacing;
  final Color? wordmarkColor;
  final bool isHorizontal;

  const SimZeloLogo({
    super.key,
    this.monogramHeight = 140.0,
    this.showWordmark = true,
    this.wordmarkFontSize = 28.0,
    this.spacing = 16.0,
    this.wordmarkColor,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // Use dark-optimized transparent asset for dark theme
    final monogramAsset = isDark
        ? 'assets/simzelo_logo_dark_transparent.png'
        : 'assets/simzelo_logo_transparent.png';

    final fallbackAsset = isDark
        ? 'assets/SimZelo_logo_dark.jpg.jpeg'
        : 'assets/SimZelo_logo_light.jpg.jpeg';

    final monogram = Image.asset(
      monogramAsset,
      height: monogramHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackAsset,
          height: monogramHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/simzelo_logo_transparent.png',
            height: monogramHeight,
            fit: BoxFit.contain,
          ),
        );
      },
    );

    final effectiveWordmarkColor = wordmarkColor ??
        (isDark ? colorScheme.onSurface : colorScheme.primary);

    final wordmark = Text(
      'SimZelo',
      style: TextStyle(
        color: effectiveWordmarkColor,
        fontSize: wordmarkFontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );

    if (!showWordmark) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: monogram,
      );
    }

    Widget content;
    if (isHorizontal) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          monogram,
          SizedBox(width: spacing),
          wordmark,
        ],
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          monogram,
          SizedBox(height: spacing),
          wordmark,
        ],
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: content,
      ),
    );
  }
}
