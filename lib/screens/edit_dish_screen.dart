import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class EditDishScreen extends StatefulWidget {
  final Dish dish;

  const EditDishScreen({super.key, required this.dish});

  @override
  State<EditDishScreen> createState() => _EditDishScreenState();
}

class _EditDishScreenState extends State<EditDishScreen> {
  late String _name;
  late String _description;
  late String _category;
  late String _price;
  late String _prepTime;
  late String _portions;
  late String _ingredients;
  late List<String> _selectedAllergens;
  late bool _deliveryAvailable;
  late bool _pickupAvailable;
  late bool _available;

  final List<String> _allergenOptions = [
    'Gluten', 'Dairy', 'Eggs', 'Peanuts',
    'Tree Nuts', 'Fish', 'Shellfish', 'Soy',
  ];

  final List<String> _categoryOptions = [
    'Italian', 'Asian', 'African', 'Mediterranean', 'Fusion', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.dish.name;
    _description = widget.dish.description;
    _category = _categoryOptions.contains(widget.dish.categoryId)
        ? widget.dish.categoryId
        : 'Other';
    _price = widget.dish.price.toStringAsFixed(2);
    _prepTime = widget.dish.prepTime.replaceAll(' min', '');
    _portions = widget.dish.portions.toString();
    _ingredients = widget.dish.ingredients.join(', ');
    _selectedAllergens = List.from(widget.dish.allergens);
    _deliveryAvailable = widget.dish.deliveryAvailable;
    _pickupAvailable = widget.dish.pickupAvailable;
    _available = widget.dish.available;
  }

  void _toggleAllergen(String allergen) {
    setState(() {
      final lower = allergen.toLowerCase();
      if (_selectedAllergens.contains(lower)) {
        _selectedAllergens.remove(lower);
      } else {
        _selectedAllergens.add(lower);
      }
    });
  }

  void _handleSave() {
    if (_name.isEmpty || _price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final updatedDish = widget.dish.copyWith(
      name: _name,
      description: _description,
      price: double.tryParse(_price) ?? widget.dish.price,
      prepTime: '$_prepTime min',
      portions: int.tryParse(_portions) ?? widget.dish.portions,
      ingredients: _ingredients.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      allergens: _selectedAllergens,
      deliveryAvailable: _deliveryAvailable,
      pickupAvailable: _pickupAvailable,
      available: _available,
    );

    appProvider.updateCookDish(updatedDish);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Plat mis à jour avec succès !'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Modifier le Plat',
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
                    // Basic Info
                    TextInputField(
                      label: 'Nom du plat *',
                      placeholder: 'Ex: Beef Lasagna',
                      value: _name,
                      onChanged: (v) => setState(() => _name = v),
                    ),
                    TextInputField(
                      label: 'Description *',
                      placeholder: 'Décrivez votre plat...',
                      value: _description,
                      onChanged: (v) => setState(() => _description = v),
                      multiline: true,
                      numberOfLines: 3,
                    ),

                    // Category
                    Text(
                      'Catégorie *',
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
                            label: 'Prix (€) *',
                            placeholder: '12.50',
                            value: _price,
                            onChanged: (v) => setState(() => _price = v),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: TextInputField(
                            label: 'Temps de prép. (min)',
                            placeholder: '30',
                            value: _prepTime,
                            onChanged: (v) => setState(() => _prepTime = v),
                          ),
                        ),
                      ],
                    ),
                    TextInputField(
                      label: 'Portions disponibles',
                      placeholder: '5',
                      value: _portions,
                      onChanged: (v) => setState(() => _portions = v),
                    ),

                    // Availability Toggle
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '✅ Disponible',
                                style: AppTypography.bodyMd.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Switch(
                                value: _available,
                                onChanged: (v) => setState(() => _available = v),
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🚗 Livraison disponible',
                                style: AppTypography.bodyMd.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Switch(
                                value: _deliveryAvailable,
                                onChanged: (v) => setState(() => _deliveryAvailable = v),
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🏠 Retrait disponible',
                                style: AppTypography.bodyMd.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Switch(
                                value: _pickupAvailable,
                                onChanged: (v) => setState(() => _pickupAvailable = v),
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Ingredients
                    TextInputField(
                      label: 'Ingrédients',
                      placeholder: 'Séparez par des virgules (ex: Bœuf, Tomate, Fromage)',
                      value: _ingredients,
                      onChanged: (v) => setState(() => _ingredients = v),
                      multiline: true,
                      numberOfLines: 2,
                    ),

                    // Allergens
                    Text(
                      'Allergènes',
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
                        final isSelected = _selectedAllergens.contains(allergen.toLowerCase());
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

                    // Save Button
                    AppButton(
                      label: '💾 Enregistrer les modifications',
                      onPressed: _handleSave,
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

