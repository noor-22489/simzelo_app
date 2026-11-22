import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// ThemeExtension containing SimZelo channel identity and RF quality tier tokens
@immutable
class SimZeloColors extends ThemeExtension<SimZeloColors> {
  final Color simA;
  final Color simB;
  final Color strong;
  final Color fair;
  final Color weak;
  final Color dead;

  const SimZeloColors({
    required this.simA,
    required this.simB,
    required this.strong,
    required this.fair,
    required this.weak,
    required this.dead,
  });

  static const light = SimZeloColors(
    simA: AppColors.simALight,
    simB: AppColors.simBLight,
    strong: AppColors.strongLight,
    fair: AppColors.fairLight,
    weak: AppColors.weakLight,
    dead: AppColors.deadLight,
  );

  static const dark = SimZeloColors(
    simA: AppColors.simADark,
    simB: AppColors.simBDark,
    strong: AppColors.strongDark,
    fair: AppColors.fairDark,
    weak: AppColors.weakDark,
    dead: AppColors.deadDark,
  );

  @override
  SimZeloColors copyWith({
    Color? simA,
    Color? simB,
    Color? strong,
    Color? fair,
    Color? weak,
    Color? dead,
  }) {
    return SimZeloColors(
      simA: simA ?? this.simA,
      simB: simB ?? this.simB,
      strong: strong ?? this.strong,
      fair: fair ?? this.fair,
      weak: weak ?? this.weak,
      dead: dead ?? this.dead,
    );
  }

  @override
  SimZeloColors lerp(ThemeExtension<SimZeloColors>? other, double t) {
    if (other is! SimZeloColors) return this;
    return SimZeloColors(
      simA: Color.lerp(simA, other.simA, t)!,
      simB: Color.lerp(simB, other.simB, t)!,
      strong: Color.lerp(strong, other.strong, t)!,
      fair: Color.lerp(fair, other.fair, t)!,
      weak: Color.lerp(weak, other.weak, t)!,
      dead: Color.lerp(dead, other.dead, t)!,
    );
  }
}

/// Helper context extension for direct access to SimZelo custom color tokens
extension SimZeloThemeContext on BuildContext {
  SimZeloColors get simZeloColors =>
      Theme.of(this).extension<SimZeloColors>() ?? SimZeloColors.light;
}

/// AppTheme builds the official Light and Dark themes strictly following COLOR_SCHEME.md
class AppTheme {
  AppTheme._();

  /// Light Theme specification
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightText,
      error: AppColors.lightError,
      onError: Colors.white,
      outline: AppColors.lightOutline,
      onSurfaceVariant: AppColors.lightTextSecondary,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.lightBackground,
      cardColor: AppColors.lightCard,
      extension: SimZeloColors.light,
      systemOverlay: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  /// Dark Theme specification
  /// Important: onPrimary and onSecondary are #0B1120 (dark text on light-blue/teal buttons)
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary, // #0B1120 dark text on light blue primary
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary, // #0B1120 dark text on bright teal
      surface: AppColors.darkCard,
      onSurface: AppColors.darkText,
      error: AppColors.darkError,
      onError: AppColors.darkBackground,
      outline: AppColors.darkOutline,
      onSurfaceVariant: AppColors.darkTextSecondary,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      extension: SimZeloColors.dark,
      systemOverlay: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required SimZeloColors extension,
    required SystemUiOverlayStyle systemOverlay,
  }) {
    final textTheme = TextTheme(
      displayLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 14,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: colorScheme.onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: cardColor,
      extensions: [extension],
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: systemOverlay,
      ),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: colorScheme.outline, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.secondary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }

  // Backward compatibility getters
  static ThemeData get lightTheme => light();
  static ThemeData get darkTheme => dark();
}
