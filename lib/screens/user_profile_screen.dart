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
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primaryLight,
                          backgroundImage: user?.avatar != null
                              ? CachedNetworkImageProvider(user!.avatar!)
                              : null,
                          child: user?.avatar == null
                              ? Text(
                                  user?.name.substring(0, 1).toUpperCase() ?? 'U',
                                  style: AppTypography.h1.copyWith(
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
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
                            child: Icon(
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
                          subtitle: '12 plats',
                          onTap: () {},
                          colors: colors,
                        ),
                        _MenuItem(
                          icon: Icons.star_outline,
                          title: 'Chefs suivis',
                          subtitle: '5 chefs',
                          onTap: () {},
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
                          subtitle: '2 adresses enregistrées',
                          onTap: () {},
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
              Icon(Icons.check_circle, color: AppColors.primary, size: 24),
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

