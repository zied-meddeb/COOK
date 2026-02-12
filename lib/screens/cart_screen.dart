import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cart = appProvider.cart;

    if (cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your cart is empty',
                  style: AppTypography.h2.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Continue Shopping',
                  onPressed: () => Navigator.of(context).pushNamed('/explore'),
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.lg,
                ),
              ],
            ),
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
                            child: const SizedBox(
                              width: 40,
                              child: Text(
                                '←',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Your Order',
                              style: AppTypography.h2.copyWith(
                                color: colors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),

                    // Delivery Mode Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: SegmentedControl(
                        options: const ['Delivery', 'Pickup'],
                        selectedIndex: _deliveryMode,
                        onValueChange: (index) {
                          setState(() => _deliveryMode = index);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Items Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        'Items (${cart.items.length})',
                        style: AppTypography.h3.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Cart Items
                    ...cart.items.map((item) => Container(
                      margin: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(
                        children: [
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
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Quantity Control
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => appProvider.updateCartItem(
                                    item.id,
                                    item.quantity - 1,
                                  ),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '−',
                                        style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: AppTypography.bodyMd.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => appProvider.updateCartItem(
                                    item.id,
                                    item.quantity + 1,
                                  ),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),

                          // Remove Button
                          GestureDetector(
                            onTap: () => appProvider.removeFromCart(item.id),
                            child: Text(
                              '✕',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: AppSpacing.xl),

                    // Cost Breakdown
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        children: [
                          _buildCostRow(
                            'Subtotal',
                            '\$${cart.subtotal.toStringAsFixed(2)}',
                            colors,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildCostRow(
                            'Service Fee',
                            '\$${cart.serviceFee.toStringAsFixed(2)}',
                            colors,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildCostRow(
                            'Delivery Fee',
                            _deliveryMode == 1 ? 'N/A' : 'Free',
                            colors,
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
                                '\$${cart.total.toStringAsFixed(2)}',
                                style: AppTypography.h3.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),

            // Checkout Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.card,
                border: Border(
                  top: BorderSide(color: colors.border),
                ),
              ),
              child: AppButton(
                label: 'Proceed to Payment - \$${cart.total.toStringAsFixed(2)}',
                onPressed: () => Navigator.of(context).pushNamed('/order-tracking'),
                variant: AppButtonVariant.primary,
                size: AppButtonSize.lg,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, AppThemeColors colors) {
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
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
