import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Dish> _searchResults = [];
  List<Cook> _cookResults = [];
  bool _isLoading = false;
  String _selectedFilter = 'all';

  final List<String> _recentSearches = [
    'Couscous',
    'Tiramisu',
    'Vegan',
    'Asiatique',
  ];

  final List<String> _popularSearches = [
    '🍜 Pad Thai',
    '🥙 Falafels',
    '🍝 Lasagnes',
    '🥗 Buddha Bowl',
    '🍰 Tiramisu',
    '🍲 Tajine',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.length >= 2) {
      _performSearch(_searchController.text);
    } else {
      setState(() {
        _searchResults = [];
        _cookResults = [];
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);

    final dishes = await mockApi.searchDishes(query);
    final cooks = await mockApi.fetchCooks();
    final filteredCooks = cooks.where((c) =>
      c.name.toLowerCase().contains(query.toLowerCase()) ||
      c.specialties.any((s) => s.toLowerCase().contains(query.toLowerCase()))
    ).toList();

    setState(() {
      _searchResults = dishes;
      _cookResults = filteredCooks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final hasResults = _searchResults.isNotEmpty || _cookResults.isNotEmpty;
    final hasQuery = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.card,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: colors.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: colors.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher un plat, chef...',
                                    hintStyle: AppTypography.bodyMd.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: AppTypography.bodyMd.copyWith(
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ),
                              if (hasQuery)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchResults = [];
                                      _cookResults = [];
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: colors.textSecondary,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Filter Chips
                  if (hasResults) ...[
                    const SizedBox(height: AppSpacing.md),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'Tout', colors),
                          _buildFilterChip('dishes', 'Plats', colors),
                          _buildFilterChip('chefs', 'Chefs', colors),
                          _buildFilterChip('available', 'Disponible', colors),
                          _buildFilterChip('delivery', 'Livraison', colors),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState(colors)
                  : hasQuery && hasResults
                      ? _buildSearchResults(colors)
                      : hasQuery && !hasResults
                          ? _buildNoResults(colors)
                          : _buildDefaultContent(colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String id, String label, AppThemeColors colors) {
    final isSelected = _selectedFilter == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = id),
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.sm),
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
        child: Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: isSelected ? Colors.white : colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(AppThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Recherche en cours...',
            style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(AppThemeColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recherches récentes',
                  style: AppTypography.h3.copyWith(color: colors.textPrimary),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Effacer',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _recentSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          search,
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Popular Searches
          Text(
            'Recherches populaires',
            style: AppTypography.h3.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _popularSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  final cleanSearch = search.replaceAll(RegExp(r'[^\w\s]'), '').trim();
                  _searchController.text = cleanSearch;
                  _performSearch(cleanSearch);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  ),
                  child: Text(
                    search,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Categories
          Text(
            'Parcourir par catégorie',
            style: AppTypography.h3.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            children: FoodCategory.categories.map((category) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  '/category',
                  arguments: category.id,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
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
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      category.name,
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AppThemeColors colors) {
    final filteredDishes = _selectedFilter == 'chefs'
        ? <Dish>[]
        : _selectedFilter == 'available'
            ? _searchResults.where((d) => d.available).toList()
            : _selectedFilter == 'delivery'
                ? _searchResults.where((d) => d.deliveryAvailable).toList()
                : _searchResults;

    final filteredCooks = _selectedFilter == 'dishes'
        ? <Cook>[]
        : _cookResults;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chefs Section
          if (filteredCooks.isNotEmpty) ...[
            Text(
              'Chefs (${filteredCooks.length})',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCooks.length,
                itemBuilder: (context, index) {
                  final cook = filteredCooks[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      '/cook-profile',
                      arguments: cook.id,
                    ),
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: CachedNetworkImageProvider(cook.avatar),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cook.name,
                                  style: AppTypography.bodyMd.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Text('⭐', style: TextStyle(fontSize: 12)),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${cook.rating} (${cook.reviewCount})',
                                      style: AppTypography.bodyMd.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cook.location,
                                  style: AppTypography.bodyMd.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Dishes Section
          if (filteredDishes.isNotEmpty) ...[
            Text(
              'Plats (${filteredDishes.length})',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredDishes.length,
              itemBuilder: (context, index) {
                final dish = filteredDishes[index];
                return _buildDishResultCard(dish, colors);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDishResultCard(Dish dish, AppThemeColors colors) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/dish-details',
        arguments: dish.id,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: CachedNetworkImage(
                imageUrl: dish.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: AppTypography.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'par ${dish.cookName}',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 2),
                      Text(
                        '${dish.rating}',
                        style: AppTypography.bodySm.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Text('📍', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 2),
                      Text(
                        '${dish.distance} km',
                        style: AppTypography.bodySm.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: dish.available
                              ? AppColors.success.withValues(alpha: 0.1)
                              : colors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          dish.available ? 'Dispo' : 'Indispo',
                          style: AppTypography.bodyMd.copyWith(
                            color: dish.available
                                ? AppColors.success
                                : colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${dish.price.toStringAsFixed(2)}€',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dish.prepTime,
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(AppThemeColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
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
              child: const Center(
                child: Text('🔍', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Aucun résultat',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Essayez avec d\'autres mots-clés',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Parcourir les catégories',
              onPressed: () => Navigator.of(context).pushNamed('/categories'),
              variant: AppButtonVariant.primary,
              size: AppButtonSize.md,
            ),
          ],
        ),
      ),
    );
  }
}

