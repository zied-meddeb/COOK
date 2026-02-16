import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class FavoriteDishesScreen extends StatelessWidget {
  const FavoriteDishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);

    final favoriteDishes = mockDishes
        .where((dish) => appProvider.favoriteDishIds.contains(dish.id))
        .toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Plats favoris',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: favoriteDishes.isEmpty
          ? _buildEmptyState(colors)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: favoriteDishes.length,
              itemBuilder: (context, index) {
                final dish = favoriteDishes[index];
                return _buildDishCard(context, dish, colors, appProvider);
              },
            ),
    );
  }

  Widget _buildEmptyState(AppThemeColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Aucun plat favori',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Explorez les plats et ajoutez vos favoris\nen appuyant sur le ❤️',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishCard(
    BuildContext context,
    Dish dish,
    AppThemeColors colors,
    AppProvider appProvider,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/dish-details',
        arguments: dish.id,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppBorderRadius.lg),
              ),
              child: CachedNetworkImage(
                imageUrl: dish.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: AppTypography.bodyLg.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Par ${dish.cookName}',
                      style: AppTypography.bodySm.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${dish.price.toStringAsFixed(2)}€',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dish.rating.toString(),
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Remove favorite button
            IconButton(
              onPressed: () {
                appProvider.toggleFavoriteDish(dish.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${dish.name} retiré des favoris'),
                    backgroundColor: Colors.grey[800],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: 'ANNULER',
                      textColor: AppColors.primary,
                      onPressed: () {
                        appProvider.toggleFavoriteDish(dish.id);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

