import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CookDashboardScreen extends StatefulWidget {
  const CookDashboardScreen({super.key});

  @override
  State<CookDashboardScreen> createState() => _CookDashboardScreenState();
}

class _CookDashboardScreenState extends State<CookDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cook = appProvider.currentCook;
    final pendingOrders = [
      ...appProvider.cookNewOrders,
      ...appProvider.cookPreparingOrders,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await appProvider.refreshCookOrders();
            await appProvider.refreshCookDishes();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: AppTypography.h2.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Bonjour, ${cook?.name.split(' ').first ?? 'Chef'} 👋',
                            style: AppTypography.bodyMd.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => appProvider.toggleCookAvailability(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: (cook?.isAvailable ?? false) ? AppColors.success : colors.border,
                            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          ),
                          child: Text(
                            (cook?.isAvailable ?? false) ? '🟢 Disponible' : '🔴 Indisponible',
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
                        'Revenus du jour',
                        '${appProvider.cookRevenue.toStringAsFixed(2)} €',
                        AppColors.primary,
                        colors,
                      ),
                      _buildStatCard(
                        '📦',
                        'Commandes',
                        '${appProvider.cookOrderCount}',
                        colors.textPrimary,
                        colors,
                      ),
                      _buildStatCard(
                        '🍽️',
                        'Plats au menu',
                        '${appProvider.cookDishes.length}',
                        colors.textPrimary,
                        colors,
                      ),
                      _buildStatCard(
                        '⭐',
                        'Note',
                        '${cook?.rating ?? 0}',
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
                        'Actions rapides',
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
                            'Mon Menu',
                            colors.card,
                            colors.textPrimary,
                            colors,
                            () => Navigator.of(context).pushNamed('/cook-menu'),
                          ),
                          _buildActionButton(
                            '➕',
                            'Ajouter',
                            AppColors.primary,
                            Colors.white,
                            colors,
                            () => Navigator.of(context).pushNamed('/add-dish'),
                          ),
                          _buildActionButton(
                            '⭐',
                            'Avis',
                            colors.card,
                            colors.textPrimary,
                            colors,
                            () => Navigator.of(context).pushNamed('/cook-reviews'),
                          ),
                          _buildActionButton(
                            '📊',
                            'Stats',
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
                        'Commandes en attente',
                        style: AppTypography.h3.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '${pendingOrders.length}',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (pendingOrders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        children: [
                          const Text('📭', style: TextStyle(fontSize: 36)),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Aucune commande en attente',
                            style: AppTypography.bodyMd.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...pendingOrders.map((order) => _buildOrderCard(order, colors, appProvider)),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, AppThemeColors colors, AppProvider appProvider) {
    return Container(
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
                Row(
                  children: [
                    Text(
                      order.dishes.map((d) => d.name).join(', '),
                      style: AppTypography.bodyLg.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.clientName} • ${order.dishes.map((d) => 'x${d.quantity}').join(', ')}',
                  style: AppTypography.bodySm.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                if (order.createdAt != null)
                  Text(
                    _formatTimeAgo(order.createdAt!),
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (order.status == 'new') ...[
            AppButton(
              label: 'Accepter',
              onPressed: () {
                appProvider.updateCookOrderStatus(order.id, 'preparing');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Commande #${order.id} acceptée'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              variant: AppButtonVariant.primary,
              size: AppButtonSize.sm,
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              label: 'Refuser',
              onPressed: () {
                appProvider.updateCookOrderStatus(order.id, 'declined');
              },
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
            ),
          ] else if (order.status == 'preparing')
            GestureDetector(
              onTap: () {
                appProvider.updateCookOrderStatus(order.id, 'ready');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Commande #${order.id} prête !'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Text(
                  'En cours →',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inDays}j';
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
