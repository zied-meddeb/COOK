import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  List<Dish> _popularDishes = [];
  List<Dish> _recentDishes = [];
  List<Cook> _popularCooks = [];
  List<Cook> _nearbyCooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final popularDishes = await mockApi.fetchPopularDishes();
    final recentDishes = await mockApi.fetchRecentDishes();
    final popularCooks = await mockApi.fetchPopularCooks();
    final nearbyCooks = await mockApi.fetchNearbyCooks();

    setState(() {
      _popularDishes = popularDishes;
      _recentDishes = recentDishes;
      _popularCooks = popularCooks;
      _nearbyCooks = nearbyCooks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.user;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(colors, user),

                // Search Bar
                _buildSearchBar(colors),
                const SizedBox(height: AppSpacing.lg),

                // Active Order Banner (if any)
                _buildActiveOrderBanner(colors),

                // Categories
                _buildCategoriesSection(colors),
                const SizedBox(height: AppSpacing.xl),

                // Popular Dishes
                _buildSectionHeader('Plats populaires', 'Voir tout', colors, () {
                  Navigator.of(context).pushNamed('/explore');
                }),
                const SizedBox(height: AppSpacing.md),
                _buildPopularDishes(colors),
                const SizedBox(height: AppSpacing.xl),

                // Popular Chefs
                _buildSectionHeader('Chefs du moment', 'Voir tout', colors, () {}),
                const SizedBox(height: AppSpacing.md),
                _buildPopularCooks(colors),
                const SizedBox(height: AppSpacing.xl),

                // Nearby Cooks
                _buildSectionHeader('Près de chez vous', 'Voir tout', colors, () {}),
                const SizedBox(height: AppSpacing.md),
                _buildNearbyCooks(colors),
                const SizedBox(height: AppSpacing.xl),

                // Recent Dishes
                _buildSectionHeader('Ajoutés récemment', 'Voir tout', colors, () {}),
                const SizedBox(height: AppSpacing.md),
                _buildRecentDishes(colors),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemeColors colors, User? user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📍', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Paris, France',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: colors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Bonjour, ${user?.name ?? 'Gourmet'} ! 👋',
                style: AppTypography.h2.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: colors.textPrimary,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/search'),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: colors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Rechercher couscous, pizza, sushi...',
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrderBanner(AppThemeColors colors) {
    // Check for active orders
    return FutureBuilder<List<Order>>(
      future: mockApi.fetchActiveOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final order = snapshot.data!.first;
        return Container(
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg,
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/order-tracking'),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: const Center(
                    child: Text('🚴', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commande en cours',
                        style: AppTypography.bodyMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Arrivée estimée: ${order.estimatedArrival}',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  ),
                  child: Text(
                    'Suivre',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catégories',
                style: AppTypography.h3.copyWith(color: colors.textPrimary),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/categories'),
                child: Text(
                  'Voir tout',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: FoodCategory.categories.length,
            itemBuilder: (context, index) {
              final category = FoodCategory.categories[index];
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  '/category',
                  arguments: category.id,
                ),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            category.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        category.name,
                        style: AppTypography.bodyXs.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    AppThemeColors colors,
    VoidCallback onAction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.h3.copyWith(color: colors.textPrimary),
          ),
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDishes(AppThemeColors colors) {
    if (_isLoading) {
      return _buildLoadingShimmer(colors);
    }

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: _popularDishes.length,
        itemBuilder: (context, index) {
          final dish = _popularDishes[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            child: DishCard(
              id: dish.id,
              name: dish.name,
              image: dish.image,
              price: dish.price,
              rating: dish.rating,
              distance: dish.distance.toString(),
              available: dish.available,
              onPress: () => Navigator.of(context).pushNamed(
                '/dish-details',
                arguments: dish.id,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularCooks(AppThemeColors colors) {
    if (_isLoading) {
      return _buildLoadingShimmer(colors, height: 140);
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: _popularCooks.length,
        itemBuilder: (context, index) {
          final cook = _popularCooks[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              '/cook-profile',
              arguments: cook.id,
            ),
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: CachedNetworkImageProvider(cook.avatar),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cook.name,
                                style: AppTypography.bodyLg.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (cook.verified)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text('✓', style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cook.title,
                          style: AppTypography.bodyXs.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${cook.rating}',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              ' (${cook.reviewCount})',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            if (cook.topSeller)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '🔥 Top',
                                  style: AppTypography.bodyXs.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyCooks(AppThemeColors colors) {
    if (_isLoading) {
      return _buildLoadingShimmer(colors, height: 80);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: _nearbyCooks.take(3).map((cook) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              '/cook-profile',
              arguments: cook.id,
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(cook.avatar),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cook.name,
                          style: AppTypography.bodyMd.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 2),
                            Text(
                              '${cook.rating}',
                              style: AppTypography.bodyXs.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              '📍 ${cook.distance} km',
                              style: AppTypography.bodyXs.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: cook.isAvailable
                          ? AppColors.success.withValues(alpha: 0.1)
                          : colors.border,
                      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                    ),
                    child: Text(
                      cook.isAvailable ? 'Disponible' : 'Indisponible',
                      style: AppTypography.bodyXs.copyWith(
                        color: cook.isAvailable
                            ? AppColors.success
                            : colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentDishes(AppThemeColors colors) {
    if (_isLoading) {
      return _buildLoadingShimmer(colors);
    }

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: _recentDishes.length,
        itemBuilder: (context, index) {
          final dish = _recentDishes[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            child: DishCard(
              id: dish.id,
              name: dish.name,
              image: dish.image,
              price: dish.price,
              rating: dish.rating,
              distance: dish.distance.toString(),
              available: dish.available,
              onPress: () => Navigator.of(context).pushNamed(
                '/dish-details',
                arguments: dish.id,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer(AppThemeColors colors, {double height = 260}) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        },
      ),
    );
  }
}
