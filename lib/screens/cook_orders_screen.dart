import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CookOrdersScreen extends StatefulWidget {
  const CookOrdersScreen({super.key});

  @override
  State<CookOrdersScreen> createState() => _CookOrdersScreenState();
}

class _CookOrdersScreenState extends State<CookOrdersScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);

    final tabOrders = [
      appProvider.cookNewOrders,
      appProvider.cookPreparingOrders,
      appProvider.cookReadyOrders,
      appProvider.cookDeliveredOrders,
    ];

    final currentOrders = tabOrders[_selectedTab];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
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
                    'Commandes',
                    style: AppTypography.h2.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: Text(
                      '${appProvider.cookOrders.length} total',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SegmentedControl(
                options: [
                  'Nouvelles (${appProvider.cookNewOrders.length})',
                  'En cours (${appProvider.cookPreparingOrders.length})',
                  'Prêtes (${appProvider.cookReadyOrders.length})',
                  'Livrées (${appProvider.cookDeliveredOrders.length})',
                ],
                selectedIndex: _selectedTab,
                onValueChange: (index) => setState(() => _selectedTab = index),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Orders List
            Expanded(
              child: currentOrders.isEmpty
                  ? _buildEmptyState(colors)
                  : RefreshIndicator(
                      onRefresh: () async {
                        await appProvider.refreshCookOrders();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        itemCount: currentOrders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderCard(
                            currentOrders[index],
                            colors,
                            appProvider,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppThemeColors colors) {
    final emptyMessages = [
      'Aucune nouvelle commande',
      'Aucune commande en préparation',
      'Aucune commande prête',
      'Aucune commande livrée',
    ];
    final emptyIcons = ['📭', '🍳', '✅', '📦'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emptyIcons[_selectedTab],
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            emptyMessages[_selectedTab],
            style: AppTypography.bodyLg.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, AppThemeColors colors, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '#${order.id}',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildStatusBadge(order.status, colors),
                ],
              ),
              Text(
                '${order.total.toStringAsFixed(2)} €',
                style: AppTypography.h4.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Customer info
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  order.clientName.isNotEmpty ? order.clientName[0] : '?',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.clientName.isNotEmpty ? order.clientName : 'Client',
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
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
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Divider
          Divider(color: colors.border, height: 1),
          const SizedBox(height: AppSpacing.md),

          // Dishes
          ...order.dishes.map((dish) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${dish.quantity}x ${dish.name}',
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${(dish.price * dish.quantity).toStringAsFixed(2)} €',
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          )),

          // Action buttons
          const SizedBox(height: AppSpacing.md),
          _buildActionButtons(order, colors, appProvider),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Order order, AppThemeColors colors, AppProvider appProvider) {
    switch (order.status) {
      case 'new':
        return Row(
          children: [
            Expanded(
              child: AppButton(
                label: '✅ Accepter',
                onPressed: () {
                  appProvider.updateCookOrderStatus(order.id, 'preparing');
                  _showSnackBar('Commande #${order.id} acceptée');
                },
                variant: AppButtonVariant.primary,
                size: AppButtonSize.md,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton(
                label: '❌ Refuser',
                onPressed: () {
                  _showDeclineDialog(order, appProvider);
                },
                variant: AppButtonVariant.outline,
                size: AppButtonSize.md,
              ),
            ),
          ],
        );
      case 'preparing':
        return AppButton(
          label: '🍽️ Marquer comme prêt',
          onPressed: () {
            appProvider.updateCookOrderStatus(order.id, 'ready');
            _showSnackBar('Commande #${order.id} prête pour la livraison');
          },
          variant: AppButtonVariant.primary,
          size: AppButtonSize.md,
          fullWidth: true,
        );
      case 'ready':
        return AppButton(
          label: '🚗 Marquer comme récupéré',
          onPressed: () {
            appProvider.updateCookOrderStatus(order.id, 'out_for_delivery');
            _showSnackBar('Commande #${order.id} en livraison');
          },
          variant: AppButtonVariant.primary,
          size: AppButtonSize.md,
          fullWidth: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStatusBadge(String status, AppThemeColors colors) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'new':
        bgColor = AppColors.info.withValues(alpha: 0.15);
        textColor = AppColors.info;
        label = 'Nouvelle';
        break;
      case 'preparing':
        bgColor = AppColors.warning.withValues(alpha: 0.15);
        textColor = AppColors.warning;
        label = 'En préparation';
        break;
      case 'ready':
        bgColor = AppColors.success.withValues(alpha: 0.15);
        textColor = AppColors.success;
        label = 'Prête';
        break;
      case 'out_for_delivery':
        bgColor = AppColors.primary.withValues(alpha: 0.15);
        textColor = AppColors.primary;
        label = 'En livraison';
        break;
      case 'delivered':
        bgColor = colors.border;
        textColor = colors.textSecondary;
        label = 'Livrée';
        break;
      default:
        bgColor = colors.border;
        textColor = colors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Text(
        label,
        style: AppTypography.bodySm.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    );
  }

  void _showDeclineDialog(Order order, AppProvider appProvider) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colors = themeProvider.colors(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: Text(
          'Refuser la commande ?',
          style: AppTypography.h4.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir refuser la commande #${order.id} de ${order.clientName} ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              appProvider.updateCookOrderStatus(order.id, 'declined');
              Navigator.pop(context);
              _showSnackBar('Commande #${order.id} refusée');
            },
            child: Text(
              'Refuser',
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

