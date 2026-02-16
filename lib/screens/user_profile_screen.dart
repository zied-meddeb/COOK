import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.user;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppBorderRadius.xl),
                  ),
                ),
                child: Column(
                  children: [
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mon Profil',
                          style: AppTypography.h2.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: Icon(
                              Icons.settings_outlined,
                              color: colors.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Profile Card
                    Row(
                      children: [
                        user?.avatar != null
                            ? CachedNetworkImage(
                                imageUrl: user!.avatar!,
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                  radius: 40,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Text(
                                    user.name.substring(0, 1).toUpperCase(),
                                    style: AppTypography.h1.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Text(
                                    user.name.substring(0, 1).toUpperCase(),
                                    style: AppTypography.h1.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.primaryLight,
                                child: Text(
                                  user?.name.substring(0, 1).toUpperCase() ?? 'U',
                                  style: AppTypography.h1.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Utilisateur',
                                style: AppTypography.h3.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? 'email@example.com',
                                style: AppTypography.bodyMd.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                                ),
                                child: Text(
                                  user?.role == UserRole.cook ? '👨‍🍳 Chef' : '🍽️ Client',
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // User Stats Section
              _buildUserStatsSection(colors),

              const SizedBox(height: AppSpacing.lg),

              // Role Switch Section
              _buildRoleSwitchSection(colors, appProvider),

              const SizedBox(height: AppSpacing.lg),

              // Menu Sections
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Orders Section
                    Text(
                      'Mes commandes',
                      style: AppTypography.h4.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.receipt_long_outlined,
                          title: 'Commandes en cours',
                          subtitle: '2 commandes',
                          onTap: () => Navigator.of(context).pushNamed('/orders'),
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.history,
                          title: 'Historique',
                          subtitle: 'Voir toutes les commandes',
                          onTap: () => Navigator.of(context).pushNamed('/order-history'),
                          colors: colors,
                        ),
                      ],
                      colors: colors,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Favorites Section
                    Text(
                      'Mes favoris',
                      style: AppTypography.h4.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Plats favoris',
                          subtitle: '${appProvider.favoriteDishIds.length} plat${appProvider.favoriteDishIds.length > 1 ? 's' : ''}',
                          onTap: () => Navigator.of(context).pushNamed('/favorite-dishes'),
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.star_outline,
                          title: 'Chefs suivis',
                          subtitle: '${appProvider.followedCookIds.length} chef${appProvider.followedCookIds.length > 1 ? 's' : ''}',
                          onTap: () => Navigator.of(context).pushNamed('/followed-cooks'),
                          colors: colors,
                        ),
                      ],
                      colors: colors,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Account Section
                    Text(
                      'Mon compte',
                      style: AppTypography.h4.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Mes adresses',
                          subtitle: '${appProvider.savedAddresses.length} adresse${appProvider.savedAddresses.length > 1 ? 's' : ''} enregistrée${appProvider.savedAddresses.length > 1 ? 's' : ''}',
                          onTap: () => Navigator.of(context).pushNamed('/saved-addresses'),
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.payment_outlined,
                          title: 'Moyens de paiement',
                          subtitle: '•••• 4242',
                          onTap: () {},
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Activées',
                          onTap: () {},
                          colors: colors,
                        ),
                      ],
                      colors: colors,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Settings Section
                    Text(
                      'Paramètres',
                      style: AppTypography.h4.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Thème',
                          subtitle: themeProvider.themeMode == AppThemeMode.dark
                              ? 'Sombre'
                              : themeProvider.themeMode == AppThemeMode.light
                                  ? 'Clair'
                                  : 'Système',
                          onTap: () => _showThemeSelector(context, themeProvider, colors),
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.language_outlined,
                          title: 'Langue',
                          subtitle: 'Français',
                          onTap: () {},
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.help_outline,
                          title: 'Aide & Support',
                          onTap: () {},
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.info_outline,
                          title: 'À propos',
                          subtitle: 'Version 1.0.0',
                          onTap: () {},
                          colors: colors,
                        ),
                      ],
                      colors: colors,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Logout Button
                    AppButton(
                      label: 'Se déconnecter',
                      onPressed: () {
                        appProvider.setUser(null);
                        appProvider.clearCart();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      },
                      variant: AppButtonVariant.outline,
                      size: AppButtonSize.lg,
                      fullWidth: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required List<_MenuItem> items,
    required AppThemeColors colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              item,
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  color: colors.border,
                  indent: 56,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserStatsSection(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.secondary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes statistiques',
              style: AppTypography.h4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '🛒',
                    '24',
                    'Commandes',
                    colors,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: colors.border,
                ),
                Expanded(
                  child: _buildStatItem(
                    '⭐',
                    '4.8',
                    'Note moyenne',
                    colors,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: colors.border,
                ),
                Expanded(
                  child: _buildStatItem(
                    '❤️',
                    '12',
                    'Favoris',
                    colors,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String emoji,
    String value,
    String label,
    AppThemeColors colors,
  ) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodyXs.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoleSwitchSection(AppThemeColors colors, AppProvider appProvider) {
    final user = appProvider.user;
    final isClient = user?.role == UserRole.client;

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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Text('🔄', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Changer de mode',
                        style: AppTypography.bodyLg.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        isClient
                            ? 'Devenez chef et vendez vos plats'
                            : 'Passez en mode client',
                        style: AppTypography.bodySm.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Role Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (user != null && user.role != UserRole.client) {
                          appProvider.setUser(user.copyWith(role: UserRole.client));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/client',
                            (route) => false,
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isClient ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '🍽️',
                              style: TextStyle(fontSize: isClient ? 18 : 16),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Client',
                              style: AppTypography.bodyMd.copyWith(
                                color: isClient ? Colors.white : colors.textSecondary,
                                fontWeight: isClient ? FontWeight.w700 : FontWeight.w500,
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
                        if (user != null && user.role != UserRole.cook) {
                          appProvider.setUser(user.copyWith(role: UserRole.cook));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/cook',
                            (route) => false,
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: !isClient ? AppColors.secondary : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '👨‍🍳',
                              style: TextStyle(fontSize: !isClient ? 18 : 16),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Chef',
                              style: AppTypography.bodyMd.copyWith(
                                color: !isClient ? Colors.white : colors.textSecondary,
                                fontWeight: !isClient ? FontWeight.w700 : FontWeight.w500,
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
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(
    BuildContext context,
    ThemeProvider themeProvider,
    AppThemeColors colors,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Choisir le thème',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildThemeOption(
              '☀️',
              'Clair',
              AppThemeMode.light,
              themeProvider,
              colors,
            ),
            _buildThemeOption(
              '🌙',
              'Sombre',
              AppThemeMode.dark,
              themeProvider,
              colors,
            ),
            _buildThemeOption(
              '📱',
              'Système',
              AppThemeMode.system,
              themeProvider,
              colors,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    String icon,
    String label,
    AppThemeMode mode,
    ThemeProvider themeProvider,
    AppThemeColors colors,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    return GestureDetector(
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg.copyWith(
                  color: colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final AppThemeColors colors;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(icon, color: colors.textPrimary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.bodySm.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

