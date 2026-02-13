import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class TextInputField extends StatelessWidget {
  final String? label;
  final String placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool multiline;
  final int numberOfLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const TextInputField({
    super.key,
    this.label,
    required this.placeholder,
    this.value,
    this.onChanged,
    this.controller,
    this.multiline = false,
    this.numberOfLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.label.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller ?? (value != null
              ? (TextEditingController(text: value)
                ..selection = TextSelection.collapsed(offset: value!.length))
              : null),
          onChanged: onChanged,
          maxLines: multiline ? numberOfLines : 1,
          minLines: multiline ? numberOfLines : 1,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.bodyMd.copyWith(
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTypography.bodyMd.copyWith(
              color: colors.textSecondary,
            ),
            filled: true,
            fillColor: colors.card,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: colors.textSecondary, size: 20)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
