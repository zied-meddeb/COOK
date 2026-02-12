import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  String _name = '';
  String _description = '';
  String _category = '';
  String _price = '';
  String _prepTime = '';
  String _portions = '';
  String _ingredients = '';
  final List<String> _selectedAllergens = [];

  final List<String> _allergenOptions = [
    'Gluten',
    'Dairy',
    'Eggs',
    'Peanuts',
    'Tree Nuts',
    'Fish',
    'Shellfish',
    'Soy',
  ];

  final List<String> _categoryOptions = [
    'Italian',
    'Asian',
    'African',
    'Mediterranean',
    'Fusion',
    'Other',
  ];

  void _toggleAllergen(String allergen) {
    setState(() {
      if (_selectedAllergens.contains(allergen)) {
        _selectedAllergens.remove(allergen);
      } else {
        _selectedAllergens.add(allergen);
      }
    });
  }

  void _handlePublish() {
    if (_name.isEmpty || _price.isEmpty || _category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dish published successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const SizedBox(
                      width: 40,
                      child: Text(
                        '←',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Add New Dish',
                      style: AppTypography.h2.copyWith(
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Upload
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          border: Border.all(
                            color: colors.border,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('📸', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Upload Photo',
                              style: AppTypography.bodyLg.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Click to select image',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Basic Info
                    TextInputField(
                      label: 'Dish Name *',
                      placeholder: 'e.g., Beef Lasagna',
                      value: _name,
                      onChanged: (value) => setState(() => _name = value),
                    ),
                    TextInputField(
                      label: 'Description *',
                      placeholder: 'Describe your dish...',
                      value: _description,
                      onChanged: (value) => setState(() => _description = value),
                      multiline: true,
                      numberOfLines: 3,
                    ),

                    // Category
                    Text(
                      'Category *',
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _categoryOptions.map((cat) {
                        final isSelected = _category == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _category = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : colors.card,
                              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              border: Border.all(color: colors.border),
                            ),
                            child: Text(
                              cat,
                              style: AppTypography.bodySm.copyWith(
                                color: isSelected ? Colors.white : colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Pricing & Logistics
                    Row(
                      children: [
                        Expanded(
                          child: TextInputField(
                            label: 'Price (\$) *',
                            placeholder: '12.50',
                            value: _price,
                            onChanged: (value) => setState(() => _price = value),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: TextInputField(
                            label: 'Prep Time (min)',
                            placeholder: '30',
                            value: _prepTime,
                            onChanged: (value) => setState(() => _prepTime = value),
                          ),
                        ),
                      ],
                    ),
                    TextInputField(
                      label: 'Portions Available',
                      placeholder: '5',
                      value: _portions,
                      onChanged: (value) => setState(() => _portions = value),
                    ),

                    // Ingredients
                    TextInputField(
                      label: 'Ingredients',
                      placeholder: 'Separate with commas (e.g., Beef, Tomato, Cheese)',
                      value: _ingredients,
                      onChanged: (value) => setState(() => _ingredients = value),
                      multiline: true,
                      numberOfLines: 2,
                    ),

                    // Allergens
                    Text(
                      'Allergens',
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _allergenOptions.map((allergen) {
                        final isSelected = _selectedAllergens.contains(allergen);
                        return GestureDetector(
                          onTap: () => _toggleAllergen(allergen),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : colors.card,
                              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : colors.border,
                              ),
                            ),
                            child: Text(
                              allergen,
                              style: AppTypography.bodySm.copyWith(
                                color: isSelected ? Colors.white : colors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Publish Button
                    AppButton(
                      label: '🚀 Publish Dish',
                      onPressed: _handlePublish,
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.lg,
                      fullWidth: true,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
