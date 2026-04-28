import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static const String _fontFamily = 'Roboto';

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: _fontFamily,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          primaryContainer: AppColors.primarySurface,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.accent,
          onSecondary: AppColors.textOnAccent,
          secondaryContainer: AppColors.accentSurface,
          onSecondaryContainer: AppColors.accentDark,
          error: AppColors.error,
          onError: Colors.white,
          errorContainer: AppColors.errorSurface,
          onErrorContainer: AppColors.error,
          surface: AppColors.surface,
          onSurface: AppColors.textDark,
          surfaceContainerHighest: AppColors.surfaceVariant,
          onSurfaceVariant: AppColors.textMedium,
          outline: AppColors.border,
          outlineVariant: AppColors.divider,
          shadow: AppColors.shadow,
          scrim: AppColors.shadow,
          inverseSurface: AppColors.textDark,
          onInverseSurface: AppColors.surface,
          inversePrimary: AppColors.primaryLight,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          scrolledUnderElevation: 2,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            disabledBackgroundColor: AppColors.textDisabled,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textMuted),
          hintStyle: const TextStyle(color: AppColors.textDisabled),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primarySurface,
          labelStyle: const TextStyle(fontSize: 12, color: AppColors.textDark),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w700,
            color: AppColors.textDark, height: 1.2,
          ),
          displayMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w700,
            color: AppColors.textDark, height: 1.2,
          ),
          headlineLarge: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w700,
            color: AppColors.textDark, height: 1.2,
          ),
          headlineMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600,
            color: AppColors.textDark, height: 1.2,
          ),
          headlineSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600,
            color: AppColors.textDark, height: 1.2,
          ),
          titleLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          titleMedium: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
          titleSmall: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
          ),
          bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400,
            color: AppColors.textDark, height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400,
            color: AppColors.textDark, height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400,
            color: AppColors.textMuted, height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
          ),
          labelSmall: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      );
}
