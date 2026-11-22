import 'package:flutter/material.dart';

/// ThemeController manages the runtime ThemeMode (system, light, dark)
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  /// Toggles between explicit Light and Dark mode
  static void toggleTheme(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;
    if (currentBrightness == Brightness.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }

  static void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }
}

/// Subtle theme switcher button (Sun / Moon) for live previews
class ThemeSwitcherButton extends StatelessWidget {
  const ThemeSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: colorScheme.primary,
        size: 22,
      ),
      onPressed: () => ThemeController.toggleTheme(context),
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
