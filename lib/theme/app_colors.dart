import 'package:flutter/material.dart';

class AppColors {
  // Primary - Orange chaud HomeChef
  static const Color primary = Color(0xFFFF7A00);
  static const Color primaryHover = Color(0xFFE86E00);
  static const Color primaryLight = Color(0xFFFFF3E6);
  static const Color primaryDark = Color(0xFFCC6200);

  // Secondary - Vert doux
  static const Color secondary = Color(0xFF2ECC71);
  static const Color secondaryLight = Color(0xFFE8F8F0);
  static const Color secondaryDark = Color(0xFF27AE60);

  // Status
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Light Mode
  static const Color lightBackground = Color(0xFFF8F6F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF181311);
  static const Color lightTextSecondary = Color(0xFF8C6B5F);
  static const Color lightBorder = Color(0xFFE6DEDB);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Dark Mode
  static const Color darkBackground = Color(0xFF23150F);
  static const Color darkSurface = Color(0xFF2F1F1A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB8A39F);
  static const Color darkBorder = Color(0xFF4A352F);
  static const Color darkCard = Color(0xFF33221B);
}

class AppThemeColors {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color card;

  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.card,
  });

  static const light = AppThemeColors(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    border: AppColors.lightBorder,
    card: AppColors.lightCard,
  );

  static const dark = AppThemeColors(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    border: AppColors.darkBorder,
    card: AppColors.darkCard,
  );
}
