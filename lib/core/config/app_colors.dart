import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand — Primary Teal
  static const Color primary = Color(0xFF1A8C7A);
  static const Color primaryDark = Color(0xFF147060);
  static const Color primaryLight = Color(0xFF2AB99E);
  static const Color primarySurface = Color(0xFFE6F5F2);

  // Brand — Gold Accent
  static const Color accent = Color(0xFFD4A843);
  static const Color accentDark = Color(0xFFB08A30);
  static const Color accentLight = Color(0xFFE8C56A);
  static const Color accentSurface = Color(0xFFFDF6E3);

  // Background
  static const Color background = Color(0xFFF5F0E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF9F6F0);

  // Text
  static const Color textDark = Color(0xFF1A3A35);
  static const Color textMedium = Color(0xFF3D6B63);
  static const Color textMuted = Color(0xFF6B8C88);
  static const Color textDisabled = Color(0xFFB0C4C1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFF1A1A1A);

  // Status colors
  static const Color success = Color(0xFF2E9B6A);
  static const Color successSurface = Color(0xFFE4F7EE);
  static const Color warning = Color(0xFFD4A843);
  static const Color warningSurface = Color(0xFFFDF6E3);
  static const Color error = Color(0xFFD94F4F);
  static const Color errorSurface = Color(0xFFFDEAEA);
  static const Color info = Color(0xFF3A7BD5);
  static const Color infoSurface = Color(0xFFE8F0FD);

  // Order status colors
  static const Color statusPending = Color(0xFFD4A843);
  static const Color statusConfirmed = Color(0xFF3A7BD5);
  static const Color statusOnTheWay = Color(0xFF8A63D2);
  static const Color statusInProgress = Color(0xFF1A8C7A);
  static const Color statusCompleted = Color(0xFF2E9B6A);
  static const Color statusCancelled = Color(0xFFD94F4F);

  // Divider / border
  static const Color divider = Color(0xFFE8E2D8);
  static const Color border = Color(0xFFD4CEBF);

  // Shadow
  static const Color shadow = Color(0x1A1A3A35);
}
