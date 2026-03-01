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
            // ── Header ───────────────────────────────────────────────────
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
                  Expanded(
                    child: Text('Mon Menu',
                      style: AppTypography.h3.copyWith(color: colors.textPrimary)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/add-dish'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppBorderRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8, offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('Ajouter',
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Stats bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    _buildMenuStat(Icons.restaurant_menu_rounded,
                        '${dishes.length}', 'Total', colors.textSecondary, colors),
                    _buildDivider(colors),
                    _buildMenuStat(Icons.check_circle_rounded,
                        '$availableCount', 'Disponibles', AppColors.success, colors),
                    _buildDivider(colors),
                    _buildMenuStat(Icons.cancel_rounded,
                        '$unavailableCount', 'Inactifs', AppColors.error, colors),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Dishes list ───────────────────────────────────────────────
            Expanded(
              child: dishes.isEmpty
                  ? _buildEmptyState(colors)
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async => appProvider.refreshCookDishes(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        itemCount: dishes.length,
                        itemBuilder: (context, index) =>
                            _buildDishCard(dishes[index], colors, appProvider),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(AppThemeColors colors) => Container(
        width: 1, height: 32,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        color: colors.border,
      );

  Widget _buildMenuStat(IconData icon, String value, String label,
      Color iconColor, AppThemeColors colors) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                style: AppTypography.bodyLg.copyWith(
                  color: colors.textPrimary, fontWeight: FontWeight.w800)),
              Text(label,
                style: AppTypography.bodyXs.copyWith(color: colors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.restaurant_menu_rounded,
                size: 34, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Votre menu est vide',
            style: AppTypography.h4.copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppSpacing.sm),
          Text('Ajoutez votre premier plat pour commencer',
            style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Ajouter un plat',
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
                  width: 96, height: 96, fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 96, height: 96, color: colors.border,
                    child: Icon(Icons.restaurant_rounded,
                        size: 28, color: colors.textSecondary)),
                  errorWidget: (_, __, ___) => Container(
                    width: 96, height: 96, color: colors.border,
                    child: Icon(Icons.restaurant_rounded,
                        size: 28, color: colors.textSecondary)),
                ),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dish.name,
                        style: AppTypography.bodyLg.copyWith(
                          color: colors.textPrimary, fontWeight: FontWeight.w700),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AppSpacing.xs),
                      Row(children: [
                        Text('${dish.price.toStringAsFixed(2)} DT',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const SizedBox(width: AppSpacing.md),
                        Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
                        const SizedBox(width: 2),
                        Text('${dish.rating}',
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textSecondary)),
                        const SizedBox(width: AppSpacing.md),
                        Icon(Icons.schedule_rounded, size: 13,
                            color: colors.textSecondary),
                        const SizedBox(width: 2),
                        Text(dish.prepTime,
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textSecondary)),
                      ]),
                      const SizedBox(height: AppSpacing.sm),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: 2),
                          decoration: BoxDecoration(
                            color: dish.available
                                ? AppColors.success.withValues(alpha: 0.12)
                                : AppColors.error.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.full),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dish.available
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dish.available ? 'Disponible' : 'Inactif',
                              style: AppTypography.bodyXs.copyWith(
                                color: dish.available
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w600)),
                          ]),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.layers_rounded,
                            size: 12, color: colors.textSecondary),
                        const SizedBox(width: 3),
                        Text('${dish.portions} portions',
                          style: AppTypography.bodyXs
                              .copyWith(color: colors.textSecondary)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Action bar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
                GestureDetector(
                  onTap: () => appProvider.toggleCookDishAvailability(dish.id),
                  child: Row(children: [
                    Icon(
                      dish.available
                          ? Icons.toggle_on_rounded
                          : Icons.toggle_off_rounded,
                      size: 30,
                      color: dish.available
                          ? AppColors.success
                          : colors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      dish.available ? 'Actif' : 'Inactif',
                      style: AppTypography.bodySm.copyWith(
                        color: dish.available
                            ? AppColors.success
                            : colors.textSecondary,
                        fontWeight: FontWeight.w600)),
                  ]),
                ),
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/edit-dish', arguments: dish),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.edit_rounded,
                          size: 17, color: AppColors.info),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => _showDeleteDialog(dish, appProvider),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.delete_rounded,
                          size: 17, color: AppColors.error),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Dish dish, AppProvider appProvider) {
    final colors =
        Provider.of<ThemeProvider>(context, listen: false).colors(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
        icon: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.delete_rounded, color: AppColors.error, size: 26),
        ),
        title: Text('Supprimer le plat ?',
          style: AppTypography.h4.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center),
        content: Text(
          'Voulez-vous vraiment supprimer "${dish.name}" de votre menu ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textSecondary,
              side: BorderSide(color: colors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.full)),
            ),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              appProvider.deleteCookDish(dish.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${dish.name} supprimé'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md)),
              ));
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.full)),
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

