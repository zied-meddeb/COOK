import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';
import '../providers/providers.dart';
import '../theme/theme.dart';

class ClientNavigator extends StatefulWidget {
  const ClientNavigator({super.key});

  @override
  State<ClientNavigator> createState() => _ClientNavigatorState();
}

class _ClientNavigatorState extends State<ClientNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);

    final screens = [
      const ClientHomeScreen(),
      const ExploreScreen(),
      const CartScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border(
            top: BorderSide(color: colors.border),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: '🏠',
                  label: 'Home',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                  colors: colors,
                ),
                _buildNavItem(
                  icon: '🔍',
                  label: 'Explore',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                  colors: colors,
                ),
                _buildNavItem(
                  icon: '🛒',
                  label: 'Cart',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                  colors: colors,
                  badge: appProvider.cart.items.isNotEmpty
                      ? appProvider.cart.items.length
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppThemeColors colors,
    int? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  icon,
                  style: TextStyle(
                    fontSize: 20,
                    color: isSelected ? AppColors.primary : colors.textSecondary,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CookNavigator extends StatefulWidget {
  const CookNavigator({super.key});

  @override
  State<CookNavigator> createState() => _CookNavigatorState();
}

class _CookNavigatorState extends State<CookNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    final screens = [
      const CookDashboardScreen(),
      const _CookOrdersPlaceholder(),
      const _CookProfilePlaceholder(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border(
            top: BorderSide(color: colors.border),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: '📊',
                  label: 'Dashboard',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                  colors: colors,
                ),
                _buildNavItem(
                  icon: '📦',
                  label: 'Orders',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                  colors: colors,
                ),
                _buildNavItem(
                  icon: '👤',
                  label: 'Profile',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppThemeColors colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? AppColors.primary : colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CookOrdersPlaceholder extends StatelessWidget {
  const _CookOrdersPlaceholder();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Text(
          'Orders Screen',
          style: AppTypography.h2.copyWith(color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _CookProfilePlaceholder extends StatelessWidget {
  const _CookProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Text(
          'Profile Screen',
          style: AppTypography.h2.copyWith(color: colors.textPrimary),
        ),
      ),
    );
  }
}
