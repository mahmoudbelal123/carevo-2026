import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand - Primary Teal
  static const Color primary = Color(0xFF146C63);
  static const Color primaryDark = Color(0xFF0F524B);
  static const Color primaryLight = Color(0xFF1C8F83);
  static const Color primarySurface = Color(0xFFE7F4F2);

  // Brand - Gold Accent
  static const Color accent = Color(0xFFCC9A2E);
  static const Color accentDark = Color(0xFFA67D21);
  static const Color accentLight = Color(0xFFE2B95D);
  static const Color accentSurface = Color(0xFFFBF4E4);

  // Background
  static const Color background = Color(0xFFF4F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF3F2);

  // Text
  static const Color textDark = Color(0xFF102827);
  static const Color textMedium = Color(0xFF385C59);
  static const Color textMuted = Color(0xFF6A8380);
  static const Color textDisabled = Color(0xFFABBCBA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFF1A1A1A);

  // Status colors
  static const Color success = Color(0xFF2B9362);
  static const Color successSurface = Color(0xFFE7F7EF);
  static const Color warning = Color(0xFFCC9A2E);
  static const Color warningSurface = Color(0xFFFBF4E4);
  static const Color error = Color(0xFFD64949);
  static const Color errorSurface = Color(0xFFFCECEC);
  static const Color info = Color(0xFF326FC9);
  static const Color infoSurface = Color(0xFFE8F0FD);

  // Order status colors
  static const Color statusPending = warning;
  static const Color statusConfirmed = info;
  static const Color statusOnTheWay = Color(0xFF7E5CD8);
  static const Color statusInProgress = primary;
  static const Color statusCompleted = success;
  static const Color statusCancelled = error;

  // Divider / border
  static const Color divider = Color(0xFFDCE7E6);
  static const Color border = Color(0xFFCBDBD8);

  // Shadow
  static const Color shadow = Color(0x17102827);
}
