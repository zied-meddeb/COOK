import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Order> _activeOrders = [];
  List<Order> _pastOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    final active = await mockApi.fetchActiveOrders();
    final past = await mockApi.fetchOrderHistory();
    setState(() {
      _activeOrders = active;
      _pastOrders = past;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: colors.textPrimary),
        ),
        title: Text(
          'Mes Commandes',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: colors.textSecondary,
          labelStyle: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: AppTypography.bodyMd,
          tabs: [
            Tab(text: 'En cours (${_activeOrders.length})'),
            Tab(text: 'Historique (${_pastOrders.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(_activeOrders, colors, isActive: true),
                _buildOrdersList(_pastOrders, colors, isActive: false),
              ],
            ),
    );
  }

  Widget _buildOrdersList(
    List<Order> orders,
    AppThemeColors colors, {
    required bool isActive,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.card,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isActive ? '📦' : '📋',
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isActive ? 'Aucune commande en cours' : 'Aucun historique',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isActive
                  ? 'Explorez nos délicieux plats faits maison !'
                  : 'Vos commandes passées apparaîtront ici',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (isActive) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Découvrir les plats',
                onPressed: () => Navigator.of(context).pushNamed('/explore'),
                variant: AppButtonVariant.primary,
                size: AppButtonSize.md,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _OrderCard(
          order: orders[index],
          colors: colors,
          isActive: isActive,
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final AppThemeColors colors;
  final bool isActive;

  const _OrderCard({
    required this.order,
    required this.colors,
    required this.isActive,
  });

  String get _statusText {
    switch (order.status) {
      case 'received':
        return 'Reçue';
      case 'preparing':
        return 'En préparation';
      case 'ready':
        return 'Prête';
      case 'out_for_delivery':
        return 'En livraison';
      case 'delivered':
        return 'Livrée';
      default:
        return order.status;
    }
  }

  Color get _statusColor {
    switch (order.status) {
      case 'delivered':
        return AppColors.success;
      case 'out_for_delivery':
        return AppColors.primary;
      case 'preparing':
      case 'ready':
        return AppColors.warning;
      default:
        return colors.textSecondary;
    }
  }

  String get _statusIcon {
    switch (order.status) {
      case 'received':
        return '📥';
      case 'preparing':
        return '👨‍🍳';
      case 'ready':
        return '✅';
      case 'out_for_delivery':
        return '🚴';
      case 'delivered':
        return '🎉';
      default:
        return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/order-tracking'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(_statusIcon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      ),
                      child: Text(
                        _statusText,
                        style: AppTypography.bodySm.copyWith(
                          color: _statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '#${order.id}',
                  style: AppTypography.bodySm.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Cook Info
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Center(
                    child: Text('👨‍🍳', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.cookName,
                        style: AppTypography.bodyMd.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${order.dishes.length} article(s)',
                        style: AppTypography.bodySm.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive && order.eta > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${order.eta} min',
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Arrivée ~${order.estimatedArrival}',
                        style: AppTypography.bodyXs.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Dishes
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Column(
                children: order.dishes.map((dish) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${dish.quantity}x ${dish.name}',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${(dish.price * dish.quantity).toStringAsFixed(2)}€',
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${order.total.toStringAsFixed(2)}€',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            // Active Order Actions
            if (isActive) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Suivre',
                      onPressed: () => Navigator.of(context).pushNamed('/order-tracking'),
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.sm,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Contacter',
                      onPressed: () {},
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.sm,
                    ),
                  ),
                ],
              ),
            ],

            // Past Order Actions
            if (!isActive) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Commander à nouveau',
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.sm,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Laisser un avis',
                      onPressed: () {},
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.sm,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

