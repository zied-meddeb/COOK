import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class CookDashboardScreen extends StatefulWidget {
  const CookDashboardScreen({super.key});

  @override
  State<CookDashboardScreen> createState() => _CookDashboardScreenState();
}

class _CookDashboardScreenState extends State<CookDashboardScreen> {
  bool _availability = true;

  final List<Map<String, dynamic>> _pendingOrders = [
    {
      'id': '1',
      'dishName': 'Beef Lasagna',
      'quantity': 2,
      'status': 'new',
      'customerName': 'Sarah M.',
      'time': '2 mins ago',
    },
    {
      'id': '2',
      'dishName': 'Vegan Curry',
      'quantity': 1,
      'status': 'new',
      'customerName': 'John D.',
      'time': '5 mins ago',
    },
    {
      'id': '3',
      'dishName': 'Dumplings',
      'quantity': 3,
      'status': 'preparing',
      'customerName': 'Emma W.',
      'time': '10 mins ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: AppTypography.h2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _availability = !_availability),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: _availability ? AppColors.success : colors.border,
                          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        ),
                        child: Text(
                          _availability ? '🟢 Available' : '🔴 Unavailable',
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 1.2,
                  children: [
                    _buildStatCard(
                      '💰',
                      "Today's Revenue",
                      '\$127.50',
                      AppColors.primary,
                      colors,
                    ),
                    _buildStatCard(
                      '📦',
                      'Orders Today',
                      '12',
                      colors.textPrimary,
                      colors,
                    ),
                    _buildStatCard(
                      '👀',
                      'Profile Views',
                      '34',
                      colors.textPrimary,
                      colors,
                    ),
                    _buildStatCard(
                      '⭐',
                      'Rating',
                      '4.9',
                      AppColors.warning,
                      colors,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: AppTypography.h3.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.9,
                      children: [
                        _buildActionButton(
                          '🍽️',
                          'My Menu',
                          colors.card,
                          colors.textPrimary,
                          colors,
                          () {},
                        ),
                        _buildActionButton(
                          '➕',
                          'Add Dish',
                          AppColors.primary,
                          Colors.white,
                          colors,
                          () => Navigator.of(context).pushNamed('/add-dish'),
                        ),
                        _buildActionButton(
                          '💬',
                          'Messages',
                          colors.card,
                          colors.textPrimary,
                          colors,
                          () {},
                        ),
                        _buildActionButton(
                          '⭐',
                          'Reviews',
                          colors.card,
                          colors.textPrimary,
                          colors,
                          () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Pending Orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pending Orders',
                      style: AppTypography.h3.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_pendingOrders.length}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Orders List
              ..._pendingOrders.map((order) => Container(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['dishName'],
                            style: AppTypography.bodyLg.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order['customerName']} • x${order['quantity']}',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          Text(
                            order['time'],
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (order['status'] == 'new') ...[
                      AppButton(
                        label: 'Accept',
                        onPressed: () {},
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.sm,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppButton(
                        label: 'Decline',
                        onPressed: () {},
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.sm,
                      ),
                    ] else if (order['status'] == 'preparing')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Text(
                          'Preparing',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String emoji,
    String label,
    String value,
    Color valueColor,
    AppThemeColors colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String emoji,
    String label,
    Color bgColor,
    Color textColor,
    AppThemeColors colors,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: bgColor == colors.card
              ? Border.all(color: colors.border)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
