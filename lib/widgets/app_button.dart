import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'package:provider/provider.dart';

enum AppButtonVariant { primary, secondary, outline }
enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final bool disabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.fullWidth = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    final sizeStyles = {
      AppButtonSize.sm: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      AppButtonSize.md: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      AppButtonSize.lg: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    };

    final minHeights = {
      AppButtonSize.sm: 32.0,
      AppButtonSize.md: 44.0,
      AppButtonSize.lg: 56.0,
    };

    final textStyles = {
      AppButtonSize.sm: AppTypography.bodySm,
      AppButtonSize.md: AppTypography.bodyMd,
      AppButtonSize.lg: AppTypography.bodyLg,
    };

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = disabled ? Colors.grey : AppColors.primary;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = colors.card;
        textColor = colors.textPrimary;
        borderColor = colors.border;
        break;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = AppColors.primary;
        break;
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Container(
            padding: sizeStyles[size],
            constraints: BoxConstraints(minHeight: minHeights[size]!),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(
                color: borderColor,
                width: variant == AppButtonVariant.outline || variant == AppButtonVariant.secondary ? 1 : 0,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: textStyles[size]?.copyWith(
                  color: textColor,
                  fontWeight: variant == AppButtonVariant.primary || variant == AppButtonVariant.outline
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
