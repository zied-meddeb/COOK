import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _deliveryMode = 0; // 0 = Delivery, 1 = Pickup
  bool _isProcessing = false;

  Future<void> _placeOrder() async {
    HapticFeedback.heavyImpact();
    setState(() => _isProcessing = true);

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isProcessing = false);
      Navigator.of(context).pushNamed('/order-tracking');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cart = appProvider.cart;

    if (cart.items.isEmpty) {
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(color: colors.border),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Mon panier',
                        style: AppTypography.h2.copyWith(
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              // Empty state
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🛒', style: TextStyle(fontSize: 50)),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Votre panier est vide',
                          style: AppTypography.h2.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Découvrez nos délicieux plats préparés par des chefs passionnés',
                          style: AppTypography.bodyMd.copyWith(
                            color: colors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: 'Explorer les plats',
                          onPressed: () => Navigator.of(context).pushNamed('/explore'),
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.lg,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.card,
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                border: Border.all(color: colors.border),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Mon panier',
                              style: AppTypography.h2.copyWith(
                                color: colors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _showClearCartDialog(context, appProvider, colors);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.card,
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                border: Border.all(color: colors.border),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delivery Mode Selector - Enhanced
                    _buildDeliveryModeSelector(colors),
                    const SizedBox(height: AppSpacing.xl),

                    // Items Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        children: [
                          Text(
                            'Articles',
                            style: AppTypography.h3.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Cart Items - Enhanced
                    ...cart.items.map((item) => _buildCartItem(item, appProvider, colors)),
                    const SizedBox(height: AppSpacing.xl),

                    // Promo Code Section
                    _buildPromoCodeSection(colors),
                    const SizedBox(height: AppSpacing.xl),

                    // Cost Breakdown - Enhanced
                    _buildCostBreakdown(cart, colors),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),

            // Checkout Button - Enhanced
            _buildCheckoutButton(cart, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryModeSelector(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _deliveryMode = 0);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: _deliveryMode == 0 ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    boxShadow: _deliveryMode == 0
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: _deliveryMode == 0 ? Colors.white : colors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Livraison',
                        style: AppTypography.bodyLg.copyWith(
                          color: _deliveryMode == 0 ? Colors.white : colors.textSecondary,
                          fontWeight: _deliveryMode == 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _deliveryMode = 1);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: _deliveryMode == 1 ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    boxShadow: _deliveryMode == 1
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storefront,
                        color: _deliveryMode == 1 ? Colors.white : colors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'À emporter',
                        style: AppTypography.bodyLg.copyWith(
                          color: _deliveryMode == 1 ? Colors.white : colors.textSecondary,
                          fontWeight: _deliveryMode == 1 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(dynamic item, AppProvider appProvider, AppThemeColors colors) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        appProvider.removeFromCart(item.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
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
            // Image placeholder
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: const Center(
                child: Text('🍽️', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.dishName,
                    style: AppTypography.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(2)}€ x ${item.quantity}',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(item.price * item.quantity).toStringAsFixed(2)}€',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Control
            Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      appProvider.updateCartItem(item.id, item.quantity - 1);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: colors.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      '${item.quantity}',
                      style: AppTypography.bodyLg.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      appProvider.updateCartItem(item.id, item.quantity + 1);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
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

  Widget _buildPromoCodeSection(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: const Icon(Icons.local_offer, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Code promo',
                style: AppTypography.bodyMd.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                'Ajouter',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown(dynamic cart, AppThemeColors colors) {
    final deliveryFee = _deliveryMode == 0 ? 2.99 : 0.0;
    final total = cart.subtotal + cart.serviceFee + deliveryFee;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé de la commande',
              style: AppTypography.h4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildCostRow('Sous-total', '${cart.subtotal.toStringAsFixed(2)}€', colors),
            const SizedBox(height: AppSpacing.md),
            _buildCostRow('Frais de service', '${cart.serviceFee.toStringAsFixed(2)}€', colors),
            const SizedBox(height: AppSpacing.md),
            _buildCostRow(
              'Frais de livraison',
              _deliveryMode == 0 ? '${deliveryFee.toStringAsFixed(2)}€' : 'Gratuit',
              colors,
              isHighlighted: _deliveryMode == 1,
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(color: colors.border),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTypography.h3.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)}€',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, AppThemeColors colors, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(
            color: isHighlighted ? AppColors.success : colors.textPrimary,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(dynamic cart, AppThemeColors colors) {
    final deliveryFee = _deliveryMode == 0 ? 2.99 : 0.0;
    final total = cart.subtotal + cart.serviceFee + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(
          top: BorderSide(color: colors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: _isProcessing ? null : _placeOrder,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: _isProcessing ? AppColors.success : AppColors.primary,
              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: (_isProcessing ? AppColors.success : AppColors.primary)
                      .withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _isProcessing
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
                          'Traitement...',
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
                        const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Passer la commande',
                          style: AppTypography.bodyLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
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
                            '${total.toStringAsFixed(2)}€',
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
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, AppProvider appProvider, AppThemeColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        title: Text(
          'Vider le panier ?',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer tous les articles de votre panier ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              appProvider.clearCart();
              Navigator.of(context).pop();
            },
            child: Text(
              'Vider',
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
