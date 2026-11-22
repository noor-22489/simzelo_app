import 'package:flutter/material.dart';

/// AppColors defines the precise hex color palette for SimZelo
/// strictly adhering to COLOR_SCHEME.md specification.
class AppColors {
  AppColors._();

  // ---------- Light Theme Tokens ----------
  static const Color lightBackground = Color(0xFFF6F8FB);
  static const Color lightCard       = Color(0xFFFFFFFF);
  static const Color lightPrimary    = Color(0xFF0F4C81); // Deep Navy
  static const Color lightOnPrimary  = Color(0xFFFFFFFF);
  static const Color lightSecondary  = Color(0xFF0D9488); // Teal
  static const Color lightOnSecondary= Color(0xFFFFFFFF);
  static const Color lightText       = Color(0xFF0F172A); // Near-black slate
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightOutline    = Color(0xFFE2E8F0);
  static const Color lightError      = Color(0xFFB91C1C);

  // ---------- Dark Theme Tokens ----------
  static const Color darkBackground  = Color(0xFF0B1120); // Midnight Slate
  static const Color darkCard        = Color(0xFF131C31);
  static const Color darkPrimary     = Color(0xFF60A5FA); // Light Blue
  static const Color darkOnPrimary   = Color(0xFF0B1120); // Dark text on light blue buttons
  static const Color darkSecondary   = Color(0xFF2DD4BF); // Bright Teal
  static const Color darkOnSecondary = Color(0xFF0B1120);
  static const Color darkText        = Color(0xFFF1F5F9); // Off-white
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkOutline     = Color(0xFF1E293B);
  static const Color darkError       = Color(0xFFF87171);

  // ---------- Channel Identity Tokens (SIM A / SIM B) ----------
  static const Color simALight       = Color(0xFF2563EB); // Royal Cobalt
  static const Color simADark        = Color(0xFF60A5FA);
  static const Color simBLight       = Color(0xFF0D9488); // Deep Teal
  static const Color simBDark        = Color(0xFF2DD4BF);

  // ---------- RF Signal Quality Tiers ----------
  static const Color strongLight     = Color(0xFF15803D); // Green
  static const Color strongDark      = Color(0xFF4ADE80);
  static const Color fairLight       = Color(0xFF0369A1); // Blue
  static const Color fairDark        = Color(0xFF38BDF8);
  static const Color weakLight       = Color(0xFFB45309); // Amber
  static const Color weakDark        = Color(0xFFFBBF24);
  static const Color deadLight       = Color(0xFFB91C1C); // Red
  static const Color deadDark        = Color(0xFFF87171);

  // Backward compatibility aliases
  static const Color primary = lightPrimary;
  static const Color secondary = lightSecondary;
  static const Color background = lightBackground;
  static const Color surface = lightCard;
  static const Color textPrimary = lightText;
  static const Color textSecondary = lightTextSecondary;
  static const Color error = lightError;
  static const Color border = lightOutline;
  static const Color borderFocused = lightSecondary;
  static const Color dotInactive = lightOutline;
  static const Color dotActive = lightSecondary;
}
