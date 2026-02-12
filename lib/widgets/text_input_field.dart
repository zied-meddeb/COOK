import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class TextInputField extends StatelessWidget {
  final String? label;
  final String placeholder;
  final String value;
  final ValueChanged<String> onChanged;
  final bool multiline;
  final int numberOfLines;

  const TextInputField({
    super.key,
    this.label,
    required this.placeholder,
    required this.value,
    required this.onChanged,
    this.multiline = false,
    this.numberOfLines = 1,
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
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          maxLines: multiline ? numberOfLines : 1,
          minLines: multiline ? numberOfLines : 1,
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
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
