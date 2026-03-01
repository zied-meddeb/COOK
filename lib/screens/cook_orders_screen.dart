import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CookOrdersScreen extends StatefulWidget {
  const CookOrdersScreen({super.key});

  @override
  State<CookOrdersScreen> createState() => _CookOrdersScreenState();
}

class _CookOrdersScreenState extends State<CookOrdersScreen> {
  int _selectedTab = 0;

  static const _tabLabels = ['Nouvelles', 'En cours', 'Prêtes', 'Livrées'];

  static const List<IconData> _emptyIcons = [
    Icons.inbox_rounded,
    Icons.hourglass_empty_rounded,
    Icons.check_circle_outline_rounded,
    Icons.local_shipping_outlined,
  ];

  static const _emptyMessages = [
    'Aucune nouvelle commande',
    'Aucune commande en préparation',
    'Aucune commande prête',
    'Aucune commande livrée',
  ];

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
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Commandes',
                    style: AppTypography.h3.copyWith(color: colors.textPrimary)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.full),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.receipt_long_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('${appProvider.cookOrders.length} total',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Scrollable pill tabs ──────────────────────────────────────
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _tabLabels.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final count = tabOrders[i].length;
                  final isSelected = _selectedTab == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : colors.card,
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.full),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : colors.border),
                      ),
                      child: Row(children: [
                        Text(_tabLabels[i],
                          style: AppTypography.bodySm.copyWith(
                            color: isSelected
                                ? Colors.white
                                : colors.textSecondary,
                            fontWeight: FontWeight.w600)),
                        if (count > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.full),
                            ),
                            child: Text('$count',
                              style: AppTypography.bodyXs.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                                fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Orders list ───────────────────────────────────────────────
            Expanded(
              child: currentOrders.isEmpty
                  ? _buildEmptyState(colors)
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async => appProvider.refreshCookOrders(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
                        itemCount: currentOrders.length,
                        itemBuilder: (context, index) => _buildOrderCard(
                          currentOrders[index], colors, appProvider),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: colors.border.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(_emptyIcons[_selectedTab],
                size: 34, color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(_emptyMessages[_selectedTab],
            style: AppTypography.bodyLg.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      Order order, AppThemeColors colors, AppProvider appProvider) {
    final isNew = order.status == 'new';
    final statusColor = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: isNew
              ? AppColors.primary.withValues(alpha: 0.4)
              : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Icon(_statusIcon(order.status),
                        size: 18, color: statusColor),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('#${order.id}',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const SizedBox(width: AppSpacing.sm),
                  _statusBadge(order.status, colors),
                ]),
                Text('${order.total.toStringAsFixed(2)} DT',
                  style: AppTypography.h4.copyWith(
                    color: colors.textPrimary, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Divider(height: 1, color: colors.border),

          // Customer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  order.clientName.isNotEmpty
                      ? order.clientName[0].toUpperCase()
                      : '?',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.clientName.isNotEmpty
                          ? order.clientName
                          : 'Client',
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600)),
                    if (order.createdAt != null)
                      Row(children: [
                        Icon(Icons.schedule_rounded,
                            size: 12, color: colors.textSecondary),
                        const SizedBox(width: 3),
                        Text(_formatTimeAgo(order.createdAt!),
                          style: AppTypography.bodySm
                              .copyWith(color: colors.textSecondary)),
                      ]),
                  ],
                ),
              ),
            ]),
          ),
          Divider(height: 1, color: colors.border),

          // Dish lines
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: order.dishes.map((dish) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: colors.border.withValues(alpha: 0.6),
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: Center(
                          child: Text('${dish.quantity}',
                            style: AppTypography.bodyXs.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(dish.name,
                        style: AppTypography.bodyMd
                            .copyWith(color: colors.textPrimary)),
                    ]),
                    Text(
                      '${(dish.price * dish.quantity).toStringAsFixed(2)} DT',
                      style: AppTypography.bodyMd
                          .copyWith(color: colors.textSecondary)),
                  ],
                ),
              )).toList(),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            child: _buildActionButtons(order, colors, appProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      Order order, AppThemeColors colors, AppProvider appProvider) {
    switch (order.status) {
      case 'new':
        return Row(children: [
          Expanded(child: _outlineBtn(
            label: 'Refuser',
            icon: Icons.close_rounded,
            color: AppColors.error,
            onTap: () => _showDeclineDialog(order, appProvider),
          )),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _filledBtn(
            label: 'Accepter',
            icon: Icons.check_rounded,
            color: AppColors.primary,
            onTap: () {
              appProvider.updateCookOrderStatus(order.id, 'preparing');
              _showSnackBar('Commande #${order.id} acceptée');
            },
          )),
        ]);
      case 'preparing':
        return _filledBtn(
          label: 'Marquer comme prête',
          icon: Icons.done_all_rounded,
          color: AppColors.warning,
          fullWidth: true,
          onTap: () {
            appProvider.updateCookOrderStatus(order.id, 'ready');
            _showSnackBar('Commande #${order.id} prête');
          },
        );
      case 'ready':
        return _filledBtn(
          label: 'Marquer récupérée',
          icon: Icons.local_shipping_rounded,
          color: AppColors.info,
          fullWidth: true,
          onTap: () {
            appProvider.updateCookOrderStatus(order.id, 'out_for_delivery');
            _showSnackBar('Commande #${order.id} en livraison');
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _filledBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Text(label,
              style: AppTypography.bodySm.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _outlineBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(label,
              style: AppTypography.bodySm.copyWith(
                color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status, AppThemeColors colors) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Text(_statusLabel(status),
        style: AppTypography.bodyXs.copyWith(
          color: color, fontWeight: FontWeight.w700)),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'new': return AppColors.primary;
      case 'preparing': return AppColors.warning;
      case 'ready': return AppColors.success;
      case 'out_for_delivery': return AppColors.info;
      default: return AppColors.secondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'new': return Icons.notifications_active_rounded;
      case 'preparing': return Icons.hourglass_top_rounded;
      case 'ready': return Icons.check_circle_rounded;
      case 'out_for_delivery': return Icons.local_shipping_rounded;
      default: return Icons.done_all_rounded;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'new': return 'Nouvelle';
      case 'preparing': return 'En préparation';
      case 'ready': return 'Prête';
      case 'out_for_delivery': return 'En livraison';
      case 'delivered': return 'Livrée';
      default: return status;
    }
  }

  String _formatTimeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inDays}j';
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md)),
    ));
  }

  void _showDeclineDialog(Order order, AppProvider appProvider) {
    final colors =
        Provider.of<ThemeProvider>(context, listen: false).colors(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
        icon: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle),
          child: const Icon(Icons.block_rounded,
              color: AppColors.error, size: 26),
        ),
        title: Text('Refuser la commande ?',
          style: AppTypography.h4.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center),
        content: Text(
          'Voulez-vous refuser la commande #${order.id} de ${order.clientName} ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textSecondary,
              side: BorderSide(color: colors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.full)),
            ),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              appProvider.updateCookOrderStatus(order.id, 'declined');
              Navigator.pop(context);
              _showSnackBar('Commande #${order.id} refusée');
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.full)),
            ),
            child: const Text('Refuser'),
          ),
        ],
      ),
    );
  }
}
