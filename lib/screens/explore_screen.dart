import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  int _viewMode = 0; // 0 = Plats, 1 = Chefs
  String _selectedCategory = 'all';
  String _sortBy = 'popular';
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _sortOptions = [
    {'id': 'popular', 'label': 'Populaire', 'icon': '🔥'},
    {'id': 'rating', 'label': 'Mieux notés', 'icon': '⭐'},
    {'id': 'price_low', 'label': 'Prix croissant', 'icon': '💰'},
    {'id': 'price_high', 'label': 'Prix décroissant', 'icon': '💎'},
    {'id': 'distance', 'label': 'Distance', 'icon': '📍'},
  ];

  List<Dish> get _filteredDishes {
    var dishes = mockDishes.toList();

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      dishes = dishes.where((d) =>
        d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        d.cookName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by category
    if (_selectedCategory != 'all') {
      dishes = dishes.where((d) => d.categoryId == _selectedCategory).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'rating':
        dishes.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        dishes.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        dishes.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'distance':
        dishes.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      default:
        // popular - par défaut
        dishes.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }

    return dishes;
  }

  List<Cook> get _filteredCooks {
    var cooks = mockCooks.toList();

    if (_searchQuery.isNotEmpty) {
      cooks = cooks.where((c) =>
        c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        c.title.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    switch (_sortBy) {
      case 'rating':
        cooks.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        cooks.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      default:
        cooks.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }

    return cooks;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche
            _buildHeader(colors),

            // Toggle Plats/Chefs
            _buildViewToggle(colors),

            // Filtres (si visible)
            if (_showFilters) _buildFiltersSection(colors),

            // Catégories (uniquement pour les plats)
            if (_viewMode == 0) _buildCategoriesChips(colors),

            // Résultats
            Expanded(
              child: _viewMode == 0
                ? _buildDishesGrid(colors)
                : _buildCooksGrid(colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Explorer',
                  style: AppTypography.h2.copyWith(color: colors.textPrimary),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _showFilters = !_showFilters);
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: _showFilters ? AppColors.primary : colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    border: Border.all(
                      color: _showFilters ? AppColors.primary : colors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: _showFilters ? Colors.white : colors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Search bar
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: colors.textSecondary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: _viewMode == 0 ? 'Rechercher un plat...' : 'Rechercher un chef...',
                      hintStyle: AppTypography.bodyMd.copyWith(
                        color: colors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close, color: colors.textSecondary, size: 20),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _viewMode = 0);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _viewMode == 0 ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 18,
                          color: _viewMode == 0 ? Colors.white : colors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Plats',
                          style: AppTypography.bodyMd.copyWith(
                            color: _viewMode == 0 ? Colors.white : colors.textSecondary,
                            fontWeight: _viewMode == 0 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _viewMode = 1);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _viewMode == 1 ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 18,
                          color: _viewMode == 1 ? Colors.white : colors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Chefs',
                          style: AppTypography.bodyMd.copyWith(
                            color: _viewMode == 1 ? Colors.white : colors.textSecondary,
                            fontWeight: _viewMode == 1 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(AppThemeColors colors) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trier par',
            style: AppTypography.bodyMd.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _sortOptions.map((option) {
              final isSelected = _sortBy == option['id'];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _sortBy = option['id'] as String);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : colors.background,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : colors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option['icon'] as String,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        option['label'] as String,
                        style: AppTypography.bodySm.copyWith(
                          color: isSelected ? Colors.white : colors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesChips(AppThemeColors colors) {
    final categories = [
      {'id': 'all', 'name': 'Tous', 'icon': '🍽️'},
      ...FoodCategory.categories.map((c) => {'id': c.id, 'name': c.name, 'icon': c.icon}),
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedCategory = category['id'] as String);
            },
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : colors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(
                  color: isSelected ? AppColors.primary : colors.border,
                ),
              ),
              child: Row(
                children: [
                  Text(category['icon'] as String, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    category['name'] as String,
                    style: AppTypography.bodySm.copyWith(
                      color: isSelected ? Colors.white : colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildDishesGrid(AppThemeColors colors) {
    final dishes = _filteredDishes;

    if (dishes.isEmpty) {
      return _buildEmptyState(colors, 'Aucun plat trouvé', '🍽️');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth < 400 ? 2 : (screenWidth / 200).floor().clamp(2, 4);

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.7,
          ),
          itemCount: dishes.length,
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return DishCard(
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
            );
          },
        );
      },
    );
  }

  Widget _buildCooksGrid(AppThemeColors colors) {
    final cooks = _filteredCooks;

    if (cooks.isEmpty) {
      return _buildEmptyState(colors, 'Aucun chef trouvé', '👨‍🍳');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: cooks.length,
      itemBuilder: (context, index) {
        final cook = cooks[index];
        return _buildChefCard(cook, colors);
      },
    );
  }

  Widget _buildChefCard(Cook cook, AppThemeColors colors) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/cook-profile',
        arguments: cook.id,
      ),
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
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: cook.avatar,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 35,
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      cook.name.substring(0, 1),
                      style: AppTypography.h2.copyWith(color: AppColors.primary),
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      cook.name.substring(0, 1),
                      style: AppTypography.h2.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
                if (cook.verified)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.card, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cook.name,
                    style: AppTypography.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    cook.title,
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
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
                      const SizedBox(width: AppSpacing.md),
                      const Text('📍', style: TextStyle(fontSize: 12)),
                      Text(
                        ' ${cook.distance} km',
                        style: AppTypography.bodySm.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status badge
            Column(
              children: [
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
                    cook.isAvailable ? 'Dispo' : 'Indispo',
                    style: AppTypography.bodyXs.copyWith(
                      color: cook.isAvailable
                          ? AppColors.success
                          : colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppThemeColors colors, String message, String emoji) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            style: AppTypography.h3.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Essayez de modifier vos filtres',
            style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
