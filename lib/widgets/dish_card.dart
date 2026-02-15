import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class DishCard extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final String distance;
  final bool available;
  final VoidCallback onPress;

  const DishCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.distance,
    this.available = true,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizes based on available width
        final cardWidth = constraints.maxWidth;
        final isCompact = cardWidth < 160;
        final badgePadding = isCompact
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 3)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        final contentPadding = isCompact ? AppSpacing.sm : AppSpacing.md;

        return GestureDetector(
          onTap: onPress,
          child: Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image container - takes flexible space
                Flexible(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error),
                        ),
                      ),
                      // Badge
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: Container(
                          padding: badgePadding,
                          decoration: BoxDecoration(
                            color: available
                                ? AppColors.success.withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: Text(
                            available ? 'Available' : 'Pre-order',
                            style: (isCompact ? AppTypography.bodyXs : AppTypography.bodySm).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content - takes minimal space needed
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(contentPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: (isCompact ? AppTypography.bodySm : AppTypography.bodyMd).copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: isCompact ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: isCompact ? AppSpacing.xs : AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: (isCompact ? AppTypography.bodySm : AppTypography.bodyMd).copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '★',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontSize: isCompact ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: AppTypography.bodySm.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (!isCompact) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '$distance mi away',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
