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
          color: AppColors.primary,
          onRefresh: () async {
            await appProvider.refreshCookOrders();
            await appProvider.refreshCookDishes();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────
                _buildHeader(cook, appProvider, colors),
                const SizedBox(height: AppSpacing.lg),

                // ── Revenue banner ───────────────────────────────────────
                _buildRevenueBanner(appProvider, colors),
                const SizedBox(height: AppSpacing.lg),

                // ── Stats row ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(child: _buildStatCard(
                        icon: Icons.receipt_long_rounded,
                        label: 'Commandes',
                        value: '${appProvider.cookOrderCount}',
                        iconColor: AppColors.info,
                        colors: colors,
                      )),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _buildStatCard(
                        icon: Icons.restaurant_menu_rounded,
                        label: 'Plats',
                        value: '${appProvider.cookDishes.length}',
                        iconColor: AppColors.secondary,
                        colors: colors,
                      )),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _buildStatCard(
                        icon: Icons.star_rounded,
                        label: 'Note',
                        value: '${cook?.rating ?? 0}',
                        iconColor: AppColors.warning,
                        colors: colors,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Quick Actions ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('Actions rapides',
                    style: AppTypography.h4.copyWith(color: colors.textPrimary)),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(children: [
                    Expanded(child: _buildActionTile(
                      icon: Icons.menu_book_rounded,
                      label: 'Mon Menu',
                      description: 'Gérer vos plats',
                      colors: colors,
                      onTap: () => Navigator.of(context).pushNamed('/cook-menu'),
                    )),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: _buildActionTile(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Ajouter',
                      description: 'Nouveau plat',
                      highlighted: true,
                      colors: colors,
                      onTap: () => Navigator.of(context).pushNamed('/add-dish'),
                    )),
                  ]),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(children: [
                    Expanded(child: _buildActionTile(
                      icon: Icons.rate_review_rounded,
                      label: 'Avis clients',
                      description: 'Voir les retours',
                      colors: colors,
                      onTap: () => Navigator.of(context).pushNamed('/cook-reviews'),
                    )),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: _buildActionTile(
                      icon: Icons.bar_chart_rounded,
                      label: 'Statistiques',
                      description: 'Vos performances',
                      colors: colors,
                      onTap: () {},
                    )),
                  ]),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Pending Orders ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Commandes en attente',
                        style: AppTypography.h4.copyWith(color: colors.textPrimary)),
                      if (pendingOrders.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppBorderRadius.full),
                          ),
                          child: Text(
                            '${pendingOrders.length} nouvelle${pendingOrders.length > 1 ? 's' : ''}',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                if (pendingOrders.isEmpty)
                  _buildEmptyOrders(colors)
                else
                  ...pendingOrders.map((o) => _buildOrderCard(o, colors, appProvider)),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(Cook? cook, AppProvider appProvider, AppThemeColors colors) {
    final isAvailable = cook?.isAvailable ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${cook?.name.split(' ').first ?? 'Chef'}',
                  style: AppTypography.h4.copyWith(color: colors.textPrimary),
                ),
                Text(
                  cook?.title ?? 'Chef Maison',
                  style: AppTypography.bodySm.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          // Availability pill
          GestureDetector(
            onTap: () => appProvider.toggleCookAvailability(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isAvailable
                    ? AppColors.success.withValues(alpha: 0.12)
                    : colors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
                border: Border.all(
                    color: isAvailable ? AppColors.success : colors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAvailable ? AppColors.success : colors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isAvailable ? 'Disponible' : 'Indisponible',
                    style: AppTypography.bodySm.copyWith(
                      color: isAvailable ? AppColors.success : colors.textSecondary,
                      fontWeight: FontWeight.w600,
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

  // ── Revenue banner ───────────────────────────────────────────────────────
  Widget _buildRevenueBanner(AppProvider appProvider, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryHover],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16, offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenus du jour',
                    style: AppTypography.bodySm.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    )),
                  const SizedBox(height: 4),
                  Text(
                    '${appProvider.cookRevenue.toStringAsFixed(2)} DT',
                    style: AppTypography.h2.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${appProvider.cookOrderCount} commande${appProvider.cookOrderCount != 1 ? 's' : ''} traitée${appProvider.cookOrderCount != 1 ? 's' : ''}',
                    style: AppTypography.bodySm.copyWith(
                      color: Colors.white.withValues(alpha: 0.75)),
                  ),
                ],
              ),
            ),
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stat card ────────────────────────────────────────────────────────────
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required AppThemeColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value,
            style: AppTypography.h3.copyWith(
              color: colors.textPrimary, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
            style: AppTypography.bodyXs.copyWith(
              color: colors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ── Action tile ──────────────────────────────────────────────────────────
  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required String description,
    required AppThemeColors colors,
    required VoidCallback onTap,
    bool highlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.primary : colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
              color: highlighted ? AppColors.primary : colors.border),
          boxShadow: highlighted
              ? [BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: highlighted
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(icon,
                color: highlighted ? Colors.white : AppColors.primary,
                size: 19),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: AppTypography.bodySm.copyWith(
                      color: highlighted ? Colors.white : colors.textPrimary,
                      fontWeight: FontWeight.w700)),
                  Text(description,
                    style: AppTypography.bodyXs.copyWith(
                      color: highlighted
                          ? Colors.white.withValues(alpha: 0.75)
                          : colors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
              size: 16,
              color: highlighted
                  ? Colors.white.withValues(alpha: 0.7)
                  : colors.textSecondary),
          ],
        ),
      ),
    );
  }

  // ── Empty orders ─────────────────────────────────────────────────────────
  Widget _buildEmptyOrders(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Column(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: colors.border.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inbox_rounded,
                color: colors.textSecondary, size: 26),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Aucune commande en attente',
            style: AppTypography.bodyMd.copyWith(
              color: colors.textPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text('Les nouvelles commandes apparaîtront ici',
            style: AppTypography.bodySm.copyWith(color: colors.textSecondary)),
        ]),
      ),
    );
  }

  // ── Order card ───────────────────────────────────────────────────────────
  Widget _buildOrderCard(
      Order order, AppThemeColors colors, AppProvider appProvider) {
    final isNew = order.status == 'new';
    final isPreparing = order.status == 'preparing';
    final statusColor = isNew ? AppColors.primary : AppColors.warning;

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: isNew
              ? AppColors.primary.withValues(alpha: 0.35)
              : colors.border,
        ),
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Icon(
                    isNew
                        ? Icons.notifications_active_rounded
                        : Icons.hourglass_top_rounded,
                    color: statusColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.person_outline_rounded,
                            size: 12, color: colors.textSecondary),
                        const SizedBox(width: 3),
                        Text(order.clientName,
                          style: AppTypography.bodySm
                              .copyWith(color: colors.textSecondary)),
                        Text(
                          '  ·  ${order.dishes.map((d) => '${d.quantity}x').join(', ')}',
                          style: AppTypography.bodySm
                              .copyWith(color: colors.textSecondary)),
                      ]),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.full),
                  ),
                  child: Text(
                    isNew ? 'Nouveau' : 'En cours',
                    style: AppTypography.bodyXs.copyWith(
                      color: statusColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.border),
          // Bottom row – time + actions
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                if (order.createdAt != null) ...[
                  Icon(Icons.schedule_rounded,
                      size: 12, color: colors.textSecondary),
                  const SizedBox(width: 3),
                  Text(_formatTimeAgo(order.createdAt!),
                    style: AppTypography.bodySm
                        .copyWith(color: colors.textSecondary)),
                ],
                const Spacer(),
                if (isNew) ...[
                  _outlineBtn(
                    label: 'Refuser',
                    color: AppColors.error,
                    onTap: () => appProvider.updateCookOrderStatus(
                        order.id, 'declined'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _filledBtn(
                    label: 'Accepter',
                    color: AppColors.primary,
                    onTap: () {
                      appProvider.updateCookOrderStatus(
                          order.id, 'preparing');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Commande acceptée'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.md)),
                      ));
                    },
                  ),
                ] else if (isPreparing)
                  _filledBtn(
                    label: 'Marquer prête',
                    color: AppColors.warning,
                    onTap: () {
                      appProvider.updateCookOrderStatus(order.id, 'ready');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Commande marquée comme prête'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.md)),
                      ));
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filledBtn({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Text(label,
          style: AppTypography.bodySm.copyWith(
            color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _outlineBtn({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Text(label,
          style: AppTypography.bodySm.copyWith(
            color: color, fontWeight: FontWeight.w600)),
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
}
