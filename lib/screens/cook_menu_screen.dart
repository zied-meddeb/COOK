import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CookMenuScreen extends StatefulWidget {
  const CookMenuScreen({super.key});

  @override
  State<CookMenuScreen> createState() => _CookMenuScreenState();
}

class _CookMenuScreenState extends State<CookMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).refreshCookDishes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final dishes = appProvider.cookDishes;

    final availableCount = dishes.where((d) => d.available).length;
    final unavailableCount = dishes.where((d) => !d.available).length;

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
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: colors.border),
                      ),
                      child: const Center(
                        child: Text('←', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Mon Menu',
                      style: AppTypography.h2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/add-dish'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('➕', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Ajouter',
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Bar
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMenuStat('📋', '${dishes.length}', 'Total', colors),
                    Container(
                      width: 1,
                      height: 30,
                      color: colors.border,
                    ),
                    _buildMenuStat('🟢', '$availableCount', 'Disponibles', colors),
                    Container(
                      width: 1,
                      height: 30,
                      color: colors.border,
                    ),
                    _buildMenuStat('🔴', '$unavailableCount', 'Indisponibles', colors),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Dishes List
            Expanded(
              child: dishes.isEmpty
                  ? _buildEmptyState(colors)
                  : RefreshIndicator(
                      onRefresh: () async {
                        await appProvider.refreshCookDishes();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        itemCount: dishes.length,
                        itemBuilder: (context, index) {
                          return _buildDishCard(dishes[index], colors, appProvider);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuStat(String emoji, String value, String label, AppThemeColors colors) {
    return Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.h4.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Votre menu est vide',
            style: AppTypography.h3.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ajoutez votre premier plat pour commencer',
            style: AppTypography.bodyMd.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: '➕ Ajouter un plat',
            onPressed: () => Navigator.of(context).pushNamed('/add-dish'),
            variant: AppButtonVariant.primary,
            size: AppButtonSize.lg,
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(Dish dish, AppThemeColors colors, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          // Dish Image + Info
          Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.lg),
                  bottomLeft: Radius.circular(AppBorderRadius.lg),
                ),
                child: CachedNetworkImage(
                  imageUrl: dish.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 100,
                    color: colors.border,
                    child: const Center(
                      child: Text('🍽️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: colors.border,
                    child: const Center(
                      child: Text('🍽️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dish.name,
                              style: AppTypography.bodyLg.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Text(
                            '${dish.price.toStringAsFixed(2)} €',
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            '⭐ ${dish.rating}',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            '🕒 ${dish.prepTime}',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: dish.available
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                            ),
                            child: Text(
                              dish.available ? '✅ Disponible' : '❌ Indisponible',
                              style: AppTypography.bodyXs.copyWith(
                                color: dish.available ? AppColors.success : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${dish.portions} portions',
                            style: AppTypography.bodyXs.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Action Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppBorderRadius.lg),
                bottomRight: Radius.circular(AppBorderRadius.lg),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Availability Toggle
                GestureDetector(
                  onTap: () => appProvider.toggleCookDishAvailability(dish.id),
                  child: Row(
                    children: [
                      Icon(
                        dish.available ? Icons.toggle_on : Icons.toggle_off,
                        color: dish.available ? AppColors.success : colors.textSecondary,
                        size: 28,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        dish.available ? 'Actif' : 'Inactif',
                        style: AppTypography.bodySm.copyWith(
                          color: dish.available ? AppColors.success : colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Edit
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/edit-dish', arguments: dish),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(color: colors.border),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: colors.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Delete
                    GestureDetector(
                      onTap: () => _showDeleteDialog(dish, appProvider),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 18,
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
    );
  }

  void _showDeleteDialog(Dish dish, AppProvider appProvider) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colors = themeProvider.colors(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: Text(
          'Supprimer le plat ?',
          style: AppTypography.h4.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${dish.name}" de votre menu ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              appProvider.deleteCookDish(dish.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${dish.name} supprimé'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                ),
              );
            },
            child: Text(
              'Supprimer',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

