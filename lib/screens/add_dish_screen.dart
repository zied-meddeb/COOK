import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

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
  bool _deliveryAvailable = true;
  bool _pickupAvailable = true;
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _allergenOptions = [
    'Gluten', 'Lait', 'Oeufs', 'Arachides',
    'Fruits à coque', 'Poisson', 'Crustacés', 'Soja',
  ];

  final List<String> _categoryOptions = [
    'Traditionnel', 'Asiatique', 'Africain',
    'Méditerranéen', 'Fusion', 'Autre',
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (file != null) {
        setState(() => _selectedImages.add(File(file.path)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _pickMultiple() async {
    try {
      final List<XFile> files = await _imagePicker.pickMultiImage(
        maxWidth: 1200, maxHeight: 1200, imageQuality: 85,
      );
      if (files.isNotEmpty) {
        setState(() => _selectedImages.addAll(files.map((f) => File(f.path))));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _showPickerSheet() {
    final colors = Provider.of<ThemeProvider>(context, listen: false).colors(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(width: 40, height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('Ajouter une photo',
                style: AppTypography.h4.copyWith(color: colors.textPrimary)),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: const Icon(Icons.photo_camera_rounded, color: AppColors.primary, size: 20),
              ),
              title: Text('Prendre une photo',
                style: AppTypography.bodyLg.copyWith(color: colors.textPrimary)),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: const Icon(Icons.photo_library_rounded, color: AppColors.info, size: 20),
              ),
              title: Text('Choisir depuis la galerie',
                style: AppTypography.bodyLg.copyWith(color: colors.textPrimary)),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: const Icon(Icons.collections_rounded, color: AppColors.secondary, size: 20),
              ),
              title: Text('Sélectionner plusieurs photos',
                style: AppTypography.bodyLg.copyWith(color: colors.textPrimary)),
              onTap: () { Navigator.pop(context); _pickMultiple(); },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _handlePublish() {
    if (_name.isEmpty || _price.isEmpty || _category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final cook = appProvider.currentCook;

    final newDish = Dish(
      id: 'dish_${DateTime.now().millisecondsSinceEpoch}',
      name: _name,
      description: _description,
      price: double.tryParse(_price) ?? 0,
      rating: 0,
      reviewCount: 0,
      distance: 0,
      image: _selectedImages.isNotEmpty
          ? _selectedImages.first.path
          : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      cookId: cook?.id ?? '',
      cookName: cook?.name ?? '',
      cookAvatar: cook?.avatar ?? '',
      portions: int.tryParse(_portions) ?? 1,
      available: true,
      ingredients: _ingredients.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      allergens: _selectedAllergens,
      categoryId: _category.toLowerCase(),
      prepTime: _prepTime.isNotEmpty ? '$_prepTime min' : '30 min',
      deliveryAvailable: _deliveryAvailable,
      pickupAvailable: _pickupAvailable,
    );

    appProvider.addCookDish(newDish);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Plat publié avec succès !'),
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
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(Icons.arrow_back_rounded, size: 20, color: colors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Nouveau plat',
                    style: AppTypography.h3.copyWith(color: colors.textPrimary)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Photo section ─────────────────────────────────────
                    if (_selectedImages.isNotEmpty) ...[
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length + 1,
                          itemBuilder: (context, index) {
                            // "Add more" tile at the end
                            if (index == _selectedImages.length) {
                              return GestureDetector(
                                onTap: _showPickerSheet,
                                child: Container(
                                  width: 130,
                                  margin: const EdgeInsets.only(right: AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: colors.card,
                                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.4),
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add_photo_alternate_rounded,
                                          size: 32, color: AppColors.primary),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text('Ajouter',
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.primary, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              );
                            }
                            // Image tile
                            return Stack(
                              children: [
                                Container(
                                  width: 170,
                                  margin: const EdgeInsets.only(right: AppSpacing.md),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                                    border: Border.all(
                                      color: index == 0 ? AppColors.primary : colors.border,
                                      width: index == 0 ? 2 : 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.file(_selectedImages[index],
                                      fit: BoxFit.cover, height: 180),
                                ),
                                if (index == 0)
                                  Positioned(
                                    bottom: 8, left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                      ),
                                      child: Text('Principal',
                                        style: AppTypography.bodyXs.copyWith(
                                          color: Colors.white, fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                Positioned(
                                  top: 6, right: 14,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedImages.removeAt(index)),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ] else
                      GestureDetector(
                        onTap: _showPickerSheet,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                            border: Border.all(color: colors.border),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add_a_photo_rounded,
                                    size: 26, color: AppColors.primary),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text('Importer des photos',
                                style: AppTypography.bodyLg.copyWith(
                                  color: colors.textPrimary, fontWeight: FontWeight.w700)),
                              const SizedBox(height: AppSpacing.xs),
                              Text('Appareil photo ou galerie',
                                style: AppTypography.bodySm.copyWith(color: colors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Basic info ────────────────────────────────────────
                    TextInputField(
                      label: 'Nom du plat *',
                      placeholder: 'Ex: Couscous Royal',
                      value: _name,
                      onChanged: (v) => setState(() => _name = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextInputField(
                      label: 'Description *',
                      placeholder: 'Décrivez votre plat...',
                      value: _description,
                      onChanged: (v) => setState(() => _description = v),
                      multiline: true,
                      numberOfLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Category ──────────────────────────────────────────
                    Text('Catégorie *',
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary, fontWeight: FontWeight.w700)),
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
                                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : colors.card,
                              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              border: Border.all(
                                  color: isSelected ? AppColors.primary : colors.border),
                            ),
                            child: Text(cat,
                              style: AppTypography.bodySm.copyWith(
                                color: isSelected ? Colors.white : colors.textPrimary,
                                fontWeight: FontWeight.w600)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Pricing ───────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: TextInputField(
                            label: 'Prix (DT) *',
                            placeholder: '12.50',
                            value: _price,
                            onChanged: (v) => setState(() => _price = v),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextInputField(
                            label: 'Temps de préparation (min)',
                            placeholder: '30',
                            value: _prepTime,
                            onChanged: (v) => setState(() => _prepTime = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextInputField(
                      label: 'Portions disponibles',
                      placeholder: '5',
                      value: _portions,
                      onChanged: (v) => setState(() => _portions = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextInputField(
                      label: 'Ingrédients',
                      placeholder: 'Séparez par des virgules (ex: Bœuf, Tomate, Fromage)',
                      value: _ingredients,
                      onChanged: (v) => setState(() => _ingredients = v),
                      multiline: true,
                      numberOfLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Allergens ─────────────────────────────────────────
                    Text('Allergènes',
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary, fontWeight: FontWeight.w700)),
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
                                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : colors.card,
                              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              border: Border.all(
                                  color: isSelected ? AppColors.primary : colors.border),
                            ),
                            child: Text(allergen,
                              style: AppTypography.bodySm.copyWith(
                                color: isSelected ? Colors.white : colors.textPrimary)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Publish button ────────────────────────────────────
                    AppButton(
                      label: 'Publier le plat',
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
