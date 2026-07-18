import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens for TradeVision AI.
/// Dark background with emerald-green accents, inspired by TradingView's
/// premium dark theme.
class AppColors {
  AppColors._();

  // Base surfaces
  static const Color background = Color(0xFF0B0E11);
  static const Color surface = Color(0xFF12161B);
  static const Color surfaceElevated = Color(0xFF1A1F26);
  static const Color surfaceCard = Color(0xFF161B22);
  static const Color border = Color(0xFF232A33);

  // Emerald accent system
  static const Color primary = Color(0xFF11C98A);
  static const Color primaryDark = Color(0xFF0E9E6D);
  static const Color primaryLight = Color(0xFF4FE3B3);
  static const Color primaryFaint = Color(0x2611C98A);

  // Signal colors
  static const Color buy = Color(0xFF11C98A);
  static const Color sell = Color(0xFFF6465D);
  static const Color wait = Color(0xFFF0B90B);

  // Text
  static const Color textPrimary = Color(0xFFEAF0EF);
  static const Color textSecondary = Color(0xFF8B98A5);
  static const Color textTertiary = Color(0xFF5B6672);

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF11C98A), Color(0xFF0A9E75)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF1DE9A1), Color(0xFF0B8F63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.sell,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
