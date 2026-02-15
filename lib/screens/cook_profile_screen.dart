import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class CookProfileScreen extends StatelessWidget {
  final String cookId;

  const CookProfileScreen({super.key, required this.cookId});

  Cook get cook {
    return mockCooks.firstWhere(
      (c) => c.id == cookId,
      orElse: () => mockCooks.first,
    );
  }

  List<Dish> get cookDishes {
    return mockDishes.where((d) => d.cookId == cookId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: cook.banner,
                    width: double.infinity,
                    height: 200,
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
                      child: const Icon(Icons.restaurant, size: 48, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 12 + MediaQuery.of(context).padding.top,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '←',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Card
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Transform.translate(
                      offset: const Offset(0, -AppSpacing.xxxl),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: cook.avatar,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -AppSpacing.lg),
                      child: Column(
                        children: [
                          Text(
                            cook.name,
                            style: AppTypography.h2.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            cook.title,
                            style: AppTypography.bodyMd.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Rating Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppBorderRadius.full),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '★',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  cook.rating.toString(),
                                  style: AppTypography.bodyLg.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Stats Row
                          Container(
                            padding: const EdgeInsets.only(top: AppSpacing.lg),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  '${cook.yearsExperience}+',
                                  'YEARS',
                                  colors,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: colors.border,
                                ),
                                _buildStatItem(
                                  '${cook.mealsServed}+',
                                  'MEALS',
                                  colors,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: colors.border,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      '✓',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'CERTIFIED',
                                      style: AppTypography.bodySm.copyWith(
                                        color: colors.textSecondary,
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
                  ],
                ),
              ),
            ),

            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: AppTypography.h3.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    cook.bio,
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Signature Dishes
            if (cookDishes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Signature Dishes',
                      style: AppTypography.h3.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'View Menu →',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 1,
                  ),
                  itemCount: cookDishes.length,
                  itemBuilder: (context, index) {
                    final dish = cookDishes[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        '/dish-details',
                        arguments: dish.id,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          color: colors.card,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: dish.image,
                              width: double.infinity,
                              height: double.infinity,
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
                                child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dish.name,
                                      style: AppTypography.bodySm.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$${dish.price}',
                                      style: AppTypography.bodySm.copyWith(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Follow',
                      onPressed: () {},
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.lg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Order Now',
                      onPressed: () => Navigator.of(context).pushNamed('/explore'),
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.lg,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, AppThemeColors colors) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: colors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
