import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class FollowedCooksScreen extends StatelessWidget {
  const FollowedCooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);

    final followedCooks = mockCooks
        .where((cook) => appProvider.followedCookIds.contains(cook.id))
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
          'Chefs suivis',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: followedCooks.isEmpty
          ? _buildEmptyState(colors)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: followedCooks.length,
              itemBuilder: (context, index) {
                final cook = followedCooks[index];
                return _buildCookCard(context, cook, colors, appProvider);
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
                Icons.people_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Aucun chef suivi',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Découvrez les chefs de votre quartier\net suivez vos favoris !',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookCard(
    BuildContext context,
    Cook cook,
    AppThemeColors colors,
    AppProvider appProvider,
  ) {
    final cookDishesCount = mockDishes.where((d) => d.cookId == cook.id).length;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/cook-profile',
        arguments: cook.id,
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
        child: Column(
          children: [
            // Banner
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppBorderRadius.lg),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: cook.banner,
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                // Unfollow button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      appProvider.toggleFollowCook(cook.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vous ne suivez plus ${cook.name}'),
                          backgroundColor: Colors.grey[800],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          action: SnackBarAction(
                            label: 'ANNULER',
                            textColor: AppColors.primary,
                            onPressed: () {
                              appProvider.toggleFollowCook(cook.id);
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Suivi',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: colors.card, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      child: CachedNetworkImage(
                        imageUrl: cook.avatar,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cook.name,
                                style: AppTypography.bodyLg.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (cook.verified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cook.title,
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Rating
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    cook.rating.toString(),
                                    style: AppTypography.bodyXs.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            // Dishes count
                            Text(
                              '$cookDishesCount plats',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            // Distance
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: colors.textSecondary,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${cook.distance} km',
                                  style: AppTypography.bodySm.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

