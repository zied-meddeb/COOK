import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class DishDetailsScreen extends StatefulWidget {
  final String dishId;

  const DishDetailsScreen({super.key, required this.dishId});

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> with SingleTickerProviderStateMixin {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isAddingToCart = false;
  late AnimationController _favoriteController;
  late Animation<double> _favoriteAnimation;

  // Mapping des allergènes avec leurs icônes
  static const Map<String, Map<String, dynamic>> allergenInfo = {
    'gluten': {'icon': '🌾', 'label': 'Gluten', 'color': Color(0xFFE67E22)},
    'dairy': {'icon': '🥛', 'label': 'Lactose', 'color': Color(0xFF3498DB)},
    'nuts': {'icon': '🥜', 'label': 'Fruits à coque', 'color': Color(0xFF8B4513)},
    'eggs': {'icon': '🥚', 'label': 'Œufs', 'color': Color(0xFFF39C12)},
    'fish': {'icon': '🐟', 'label': 'Poisson', 'color': Color(0xFF1ABC9C)},
    'shellfish': {'icon': '🦐', 'label': 'Crustacés', 'color': Color(0xFFE74C3C)},
    'soy': {'icon': '🫘', 'label': 'Soja', 'color': Color(0xFF27AE60)},
    'sesame': {'icon': '🌱', 'label': 'Sésame', 'color': Color(0xFF9B59B6)},
    'peanuts': {'icon': '🥜', 'label': 'Arachides', 'color': Color(0xFFD35400)},
    'celery': {'icon': '🥬', 'label': 'Céleri', 'color': Color(0xFF2ECC71)},
    'mustard': {'icon': '🟡', 'label': 'Moutarde', 'color': Color(0xFFF1C40F)},
    'lupin': {'icon': '🌸', 'label': 'Lupin', 'color': Color(0xFF8E44AD)},
    'molluscs': {'icon': '🐚', 'label': 'Mollusques', 'color': Color(0xFF34495E)},
    'sulphites': {'icon': '🧪', 'label': 'Sulfites', 'color': Color(0xFF7F8C8D)},
  };

  Dish get dish {
    return mockDishes.firstWhere(
      (d) => d.id == widget.dishId,
      orElse: () => mockDishes.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    HapticFeedback.mediumImpact();
    setState(() => _isFavorite = !_isFavorite);
    if (_isFavorite) {
      _favoriteController.forward().then((_) => _favoriteController.reverse());
    }
  }

  Future<void> _handleAddToCart() async {
    HapticFeedback.heavyImpact();
    setState(() => _isAddingToCart = true);

    // Simulate a small delay for animation
    await Future.delayed(const Duration(milliseconds: 500));

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.addToCart(CartItem(
      id: '${dish.id}-${DateTime.now().millisecondsSinceEpoch}',
      dishId: dish.id,
      dishName: dish.name,
      quantity: _quantity,
      price: dish.price,
      cookId: dish.cookId,
    ));

    setState(() => _isAddingToCart = false);

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('${dish.name} ajouté au panier'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'VOIR',
            textColor: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image with actions
                _buildHeroImage(colors),

                // Content
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title, Price and Badges
                      _buildTitleSection(colors),
                      const SizedBox(height: AppSpacing.lg),

                      // Delivery & Pickup badges
                      _buildDeliveryBadges(colors),
                      const SizedBox(height: AppSpacing.lg),

                      // Description
                      Text(
                        dish.description,
                        style: AppTypography.bodyMd.copyWith(
                          color: colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Cook Card
                      _buildCookCard(colors),
                      const SizedBox(height: AppSpacing.xl),

                      // Allergens Section
                      if (dish.allergens.isNotEmpty) ...[
                        _buildAllergensSection(colors),
                        const SizedBox(height: AppSpacing.xl),
                      ],

                      // Ingredients
                      _buildIngredientsSection(colors),
                      const SizedBox(height: AppSpacing.xl),

                      // Quantity Selector
                      _buildQuantitySelector(colors),
                      const SizedBox(height: AppSpacing.xl),

                      // Add to Cart Button
                      _buildAddToCartButton(colors),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(AppThemeColors colors) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // Image
          CachedNetworkImage(
            imageUrl: dish.image,
            width: double.infinity,
            height: 320,
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
              child: const Icon(Icons.fastfood, size: 48, color: Colors.grey),
            ),
          ),

          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    colors.background.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 12 + MediaQuery.of(context).padding.top,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.card.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: colors.textPrimary,
                  size: 22,
                ),
              ),
            ),
          ),

          // Favorite and Share buttons
          Positioned(
            top: 12 + MediaQuery.of(context).padding.top,
            right: 16,
            child: Row(
              children: [
                // Share button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // TODO: Implement share
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.card.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.share_outlined,
                      color: colors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Favorite button with animation
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: ScaleTransition(
                    scale: _favoriteAnimation,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _isFavorite
                            ? AppColors.error.withValues(alpha: 0.1)
                            : colors.card.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? AppColors.error : colors.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Urgency badge
          if (dish.portions <= 5)
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⏱️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      'Plus que ${dish.portions} portions !',
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
    );
  }

  Widget _buildTitleSection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                dish.name,
                style: AppTypography.h1.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${dish.price.toStringAsFixed(2)}€',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'par portion',
                  style: AppTypography.bodyXs.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Rating, prep time and reviews
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${dish.rating}',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' (${dish.reviewCount})',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: colors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    dish.prepTime,
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  const Text('📍', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    '${dish.distance} km',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryBadges(AppThemeColors colors) {
    return Row(
      children: [
        if (dish.deliveryAvailable)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, size: 18, color: AppColors.success),
                const SizedBox(width: 6),
                Text(
                  'Livraison',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (dish.deliveryAvailable && dish.pickupAvailable)
          const SizedBox(width: AppSpacing.sm),
        if (dish.pickupAvailable)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront, size: 18, color: AppColors.info),
                const SizedBox(width: 6),
                Text(
                  'À emporter',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCookCard(AppThemeColors colors) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/cook-profile',
        arguments: dish.cookId,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              child: CachedNetworkImage(
                imageUrl: dish.cookAvatar.isNotEmpty ? dish.cookAvatar : dish.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.primaryLight,
                  child: Center(
                    child: Text(
                      dish.cookName.substring(0, 1),
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primaryLight,
                  child: Center(
                    child: Text(
                      dish.cookName.substring(0, 1),
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        dish.cookName,
                        style: AppTypography.bodyLg.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Chef vérifié',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
              ),
              child: Row(
                children: [
                  Text(
                    'Voir profil',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergensSection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Allergènes',
              style: AppTypography.h3.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: dish.allergens.map((allergen) {
                  final info = allergenInfo[allergen.toLowerCase()] ??
                      {'icon': '⚠️', 'label': allergen, 'color': AppColors.warning};
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: (info['color'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          info['icon'] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          info['label'] as String,
                          style: AppTypography.bodySm.copyWith(
                            color: info['color'] as Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Ce plat contient des allergènes. Vérifiez avec le chef si vous avez des doutes.',
                style: AppTypography.bodyXs.copyWith(
                  color: colors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingrédients',
          style: AppTypography.h3.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: dish.ingredients.map((ingredient) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              ingredient,
              style: AppTypography.bodySm.copyWith(
                color: colors.textPrimary,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantité',
          style: AppTypography.h3.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (_quantity > 1) {
                    HapticFeedback.selectionClick();
                    setState(() => _quantity--);
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _quantity > 1 ? colors.background : colors.border.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _quantity > 1 ? colors.textPrimary : colors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$_quantity',
                    style: AppTypography.h2.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    _quantity == 1 ? 'portion' : 'portions',
                    style: AppTypography.bodyXs.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _quantity++);
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(AppThemeColors colors) {
    final totalPrice = dish.price * _quantity;

    return GestureDetector(
      onTap: _isAddingToCart ? null : _handleAddToCart,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: _isAddingToCart ? AppColors.success : AppColors.primary,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          boxShadow: [
            BoxShadow(
              color: (_isAddingToCart ? AppColors.success : AppColors.primary).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _isAddingToCart
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Ajout en cours...',
                      style: AppTypography.bodyLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'Ajouter au panier',
                      style: AppTypography.bodyLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      ),
                      child: Text(
                        '${totalPrice.toStringAsFixed(2)}€',
                        style: AppTypography.bodyMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
