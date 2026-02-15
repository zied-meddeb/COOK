import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class DishCard extends StatefulWidget {
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
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isCompact = cardWidth < 160;
        final badgePadding = isCompact
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 3)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        final contentPadding = isCompact ? AppSpacing.sm : AppSpacing.md;

        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onPress,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color: _isPressed ? AppColors.primary.withValues(alpha: 0.3) : colors.border,
                  width: _isPressed ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: _isPressed ? 15 : 8,
                    offset: Offset(0, _isPressed ? 8 : 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image container
                  Expanded(
                    flex: 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image
                        CachedNetworkImage(
                          imageUrl: widget.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: colors.border,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: colors.border,
                            child: Icon(
                              Icons.restaurant,
                              color: colors.textSecondary,
                              size: 32,
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Availability Badge
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: Container(
                            padding: badgePadding,
                            decoration: BoxDecoration(
                              color: widget.available
                                  ? AppColors.success
                                  : Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.available ? Icons.check_circle : Icons.schedule,
                                  color: Colors.white,
                                  size: isCompact ? 10 : 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.available ? 'Dispo' : 'Sur commande',
                                  style: (isCompact ? AppTypography.bodyXs : AppTypography.bodySm).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Rating badge (bottom right)
                        Positioned(
                          bottom: AppSpacing.sm,
                          right: AppSpacing.sm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '⭐',
                                  style: TextStyle(fontSize: 10),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.rating.toString(),
                                  style: AppTypography.bodyXs.copyWith(
                                    color: Colors.black87,
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
                  // Content
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: (isCompact ? AppTypography.bodySm : AppTypography.bodyMd).copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              maxLines: isCompact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.price.toStringAsFixed(2)}€',
                                    style: (isCompact ? AppTypography.bodyMd : AppTypography.bodyLg).copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (!isCompact)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 10,
                                          color: colors.textSecondary,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${widget.distance} km',
                                          style: AppTypography.bodyXs.copyWith(
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              // Quick add button
                              Container(
                                width: isCompact ? 28 : 32,
                                height: isCompact ? 28 : 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: isCompact ? 16 : 18,
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
            ),
          ),
        );
      },
    );
  }
}
