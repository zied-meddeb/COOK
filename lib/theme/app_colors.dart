import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFFFA6C38);
  static const Color primaryHover = Color(0xFFE85A24);
  static const Color primaryLight = Color(0xFFFDE4D5);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

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
