import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CookProfileEditScreen extends StatefulWidget {
  const CookProfileEditScreen({super.key});

  @override
  State<CookProfileEditScreen> createState() => _CookProfileEditScreenState();
}

class _CookProfileEditScreenState extends State<CookProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _prepTimeController;
  late TextEditingController _minimumOrderController;
  late TextEditingController _deliveryRadiusController;
  late TextEditingController _specialtiesController;
  bool _acceptsDelivery = true;
  bool _acceptsPickup = true;
  bool _isAvailable = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final cook = Provider.of<AppProvider>(context, listen: false).currentCook;
    _nameController = TextEditingController(text: cook?.name ?? '');
    _titleController = TextEditingController(text: cook?.title ?? '');
    _bioController = TextEditingController(text: cook?.bio ?? '');
    _phoneController = TextEditingController(text: cook?.phone ?? '');
    _addressController = TextEditingController(text: cook?.address ?? '');
    _prepTimeController = TextEditingController(text: cook?.prepTime ?? '');
    _minimumOrderController = TextEditingController(text: cook?.minimumOrder.toStringAsFixed(0) ?? '');
    _deliveryRadiusController = TextEditingController(text: cook?.deliveryRadius.toString() ?? '');
    _specialtiesController = TextEditingController(text: cook?.specialties.join(', ') ?? '');
    _acceptsDelivery = cook?.acceptsDelivery ?? true;
    _acceptsPickup = cook?.acceptsPickup ?? true;
    _isAvailable = cook?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _prepTimeController.dispose();
    _minimumOrderController.dispose();
    _deliveryRadiusController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final cook = appProvider.currentCook;
    if (cook == null) return;

    final updatedCook = cook.copyWith(
      name: _nameController.text,
      title: _titleController.text,
      bio: _bioController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      prepTime: _prepTimeController.text,
      minimumOrder: double.tryParse(_minimumOrderController.text) ?? cook.minimumOrder,
      deliveryRadius: int.tryParse(_deliveryRadiusController.text) ?? cook.deliveryRadius,
      specialties: _specialtiesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      acceptsDelivery: _acceptsDelivery,
      acceptsPickup: _acceptsPickup,
      isAvailable: _isAvailable,
    );

    appProvider.updateCookProfile(updatedCook);
    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profil mis à jour avec succès !'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cook = appProvider.currentCook;
    final user = appProvider.user;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mon Profil Chef',
                      style: AppTypography.h2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_isEditing) {
                          _handleSave();
                        } else {
                          setState(() => _isEditing = true);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: _isEditing ? AppColors.success : AppColors.primary,
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        ),
                        child: Text(
                          _isEditing ? '💾 Enregistrer' : '✏️ Modifier',
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      cook?.avatar != null
                          ? CachedNetworkImage(
                              imageUrl: cook!.avatar,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 36,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 36,
                                backgroundColor: AppColors.primaryLight,
                                child: Text(
                                  cook.name.isNotEmpty ? cook.name[0] : '?',
                                  style: AppTypography.h2.copyWith(color: AppColors.primary),
                                ),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                radius: 36,
                                backgroundColor: AppColors.primaryLight,
                                child: Text(
                                  cook.name.isNotEmpty ? cook.name[0] : '?',
                                  style: AppTypography.h2.copyWith(color: AppColors.primary),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                user?.name.isNotEmpty == true ? user!.name[0] : '?',
                                style: AppTypography.h2.copyWith(color: AppColors.primary),
                              ),
                            ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cook?.name ?? user?.name ?? 'Chef',
                              style: AppTypography.h3.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cook?.title ?? 'Chef Maison',
                              style: AppTypography.bodyMd.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                if (cook?.verified == true) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                    ),
                                    child: Text(
                                      '✅ Vérifié',
                                      style: AppTypography.bodyXs.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                ],
                                if (cook?.certified == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                    ),
                                    child: Text(
                                      '🏅 Certifié',
                                      style: AppTypography.bodyXs.copyWith(
                                        color: AppColors.warning,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.85,
                  children: [
                    _buildStatCard('⭐', '${cook?.rating ?? 0}', 'Note', colors),
                    _buildStatCard('💬', '${cook?.reviewCount ?? 0}', 'Avis', colors),
                    _buildStatCard('🍽️', '${cook?.mealsServed ?? 0}', 'Repas', colors),
                    _buildStatCard('📅', '${cook?.yearsExperience ?? 0} ans', 'Expérience', colors),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Availability Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disponibilité',
                        style: AppTypography.h4.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildToggleRow(
                        '🟢 Disponible',
                        'Les clients peuvent vous trouver',
                        _isAvailable,
                        (val) => setState(() => _isAvailable = val),
                        colors,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildToggleRow(
                        '🚗 Livraison',
                        'Accepter les commandes avec livraison',
                        _acceptsDelivery,
                        (val) => setState(() => _acceptsDelivery = val),
                        colors,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildToggleRow(
                        '🏠 Retrait',
                        'Accepter les retraits sur place',
                        _acceptsPickup,
                        (val) => setState(() => _acceptsPickup = val),
                        colors,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Editable Fields
              if (_isEditing) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations',
                          style: AppTypography.h4.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextInputField(
                          label: 'Nom',
                          placeholder: 'Votre nom',
                          controller: _nameController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Titre',
                          placeholder: 'Ex: Chef Maison • Cuisine Italienne',
                          controller: _titleController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Bio',
                          placeholder: 'Décrivez-vous...',
                          controller: _bioController,
                          multiline: true,
                          numberOfLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Téléphone',
                          placeholder: '+33 6 00 00 00 00',
                          controller: _phoneController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Adresse',
                          placeholder: 'Votre adresse',
                          controller: _addressController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: TextInputField(
                                label: 'Temps de préparation',
                                placeholder: '30 min',
                                controller: _prepTimeController,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextInputField(
                                label: 'Commande minimum (€)',
                                placeholder: '10',
                                controller: _minimumOrderController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Rayon de livraison (km)',
                          placeholder: '5',
                          controller: _deliveryRadiusController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Spécialités (séparées par des virgules)',
                          placeholder: 'Ex: Couscous, Tajines, Pastilla',
                          controller: _specialtiesController,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Read-only info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations',
                          style: AppTypography.h4.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (cook?.bio != null && cook!.bio.isNotEmpty) ...[
                          _buildInfoRow('📝', 'Bio', cook.bio, colors),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        if (cook?.phone != null && cook!.phone.isNotEmpty) ...[
                          _buildInfoRow('📞', 'Téléphone', cook.phone, colors),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        if (cook?.address != null && cook!.address.isNotEmpty) ...[
                          _buildInfoRow('📍', 'Adresse', cook.address, colors),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        _buildInfoRow('🕒', 'Temps de préparation', cook?.prepTime ?? '-', colors),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('💰', 'Commande minimum', '${cook?.minimumOrder.toStringAsFixed(0) ?? '0'} €', colors),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('🚗', 'Rayon de livraison', '${cook?.deliveryRadius ?? 0} km', colors),
                        if (cook?.specialties != null && cook!.specialties.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Spécialités',
                            style: AppTypography.bodyMd.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: cook.specialties.map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              ),
                              child: Text(
                                s,
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),

              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Switch to Client Mode
                    GestureDetector(
                      onTap: () {
                        final appProvider = Provider.of<AppProvider>(context, listen: false);
                        appProvider.setUser(appProvider.user?.copyWith(role: UserRole.client));
                        Navigator.of(context).pushReplacementNamed('/client');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            const Text('🔄', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passer en mode Client',
                                    style: AppTypography.bodyLg.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Commander des plats',
                                    style: AppTypography.bodySm.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: colors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Theme toggle
                    GestureDetector(
                      onTap: () {
                        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                        themeProvider.setThemeMode(
                          themeProvider.isDarkMode(context)
                              ? AppThemeMode.light
                              : AppThemeMode.dark,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            Text(
                              themeProvider.isDarkMode(context) ? '☀️' : '🌙',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                themeProvider.isDarkMode(context) ? 'Mode clair' : 'Mode sombre',
                                style: AppTypography.bodyLg.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: colors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Logout
                    AppButton(
                      label: '🚪 Se déconnecter',
                      onPressed: () {
                        final appProvider = Provider.of<AppProvider>(context, listen: false);
                        appProvider.setUser(null);
                        appProvider.setCook(null);
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      variant: AppButtonVariant.outline,
                      size: AppButtonSize.lg,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String value, String label, AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.bodyLg.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTypography.bodyXs.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    AppThemeColors colors,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMd.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: _isEditing || title.contains('Disponible') ? onChanged : null,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String emoji, String label, String value, AppThemeColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySm.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMd.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

