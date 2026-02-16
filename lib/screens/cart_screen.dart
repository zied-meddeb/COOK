import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _deliveryMode = 0; // 0 = Delivery, 1 = Pickup
  bool _isProcessing = false;
  int _paymentMethod = 0; // 0 = Card, 1 = Cash
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  String _selectedAddress = '';
  bool _isAddressValid = false;

  // Map related variables
  final MapController _mapController = MapController();
  LatLng _selectedLocation = const LatLng(36.8065, 10.1815); // Tunis par défaut
  bool _isMapExpanded = false;
  bool _isLoadingLocation = false;

  // Search related variables
  final TextEditingController _searchController = TextEditingController();
  List<_SearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;

  @override
  void dispose() {
    _addressController.dispose();
    _additionalInfoController.dispose();
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    // Validate address for delivery mode
    if (_deliveryMode == 0 && !_isAddressValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer une adresse de livraison valide'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() => _isProcessing = true);

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isProcessing = false);
      Navigator.of(context).pushNamed('/order-tracking');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cart = appProvider.cart;

    if (cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(color: colors.border),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Mon panier',
                        style: AppTypography.h2.copyWith(
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              // Empty state
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🛒', style: TextStyle(fontSize: 50)),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Votre panier est vide',
                          style: AppTypography.h2.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Découvrez nos délicieux plats préparés par des chefs passionnés',
                          style: AppTypography.bodyMd.copyWith(
                            color: colors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: 'Explorer les plats',
                          onPressed: () => Navigator.of(context).pushNamed('/explore'),
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.lg,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.card,
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                border: Border.all(color: colors.border),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Mon panier',
                              style: AppTypography.h2.copyWith(
                                color: colors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _showClearCartDialog(context, appProvider, colors);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.card,
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                border: Border.all(color: colors.border),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delivery Mode Selector - Enhanced
                    _buildDeliveryModeSelector(colors),
                    const SizedBox(height: AppSpacing.xl),

                    // Location Section (only for delivery)
                    if (_deliveryMode == 0) ...[
                      _buildLocationSection(colors),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Payment Method Section
                    _buildPaymentMethodSection(colors),
                    const SizedBox(height: AppSpacing.xl),

                    // Items Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        children: [
                          Text(
                            'Articles',
                            style: AppTypography.h3.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Cart Items - Enhanced
                    ...cart.items.map((item) => _buildCartItem(item, appProvider, colors)),
                    const SizedBox(height: AppSpacing.xl),

                    // Promo Code Section
                    _buildPromoCodeSection(colors),
                    const SizedBox(height: AppSpacing.xl),

                    // Cost Breakdown - Enhanced
                    _buildCostBreakdown(cart, colors),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),

            // Checkout Button - Enhanced
            _buildCheckoutButton(cart, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryModeSelector(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _deliveryMode = 0);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: _deliveryMode == 0 ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    boxShadow: _deliveryMode == 0
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: _deliveryMode == 0 ? Colors.white : colors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Livraison',
                        style: AppTypography.bodyLg.copyWith(
                          color: _deliveryMode == 0 ? Colors.white : colors.textSecondary,
                          fontWeight: _deliveryMode == 0 ? FontWeight.w700 : FontWeight.w500,
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
                  HapticFeedback.selectionClick();
                  setState(() => _deliveryMode = 1);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: _deliveryMode == 1 ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    boxShadow: _deliveryMode == 1
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storefront,
                        color: _deliveryMode == 1 ? Colors.white : colors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'À emporter',
                        style: AppTypography.bodyLg.copyWith(
                          color: _deliveryMode == 1 ? Colors.white : colors.textSecondary,
                          fontWeight: _deliveryMode == 1 ? FontWeight.w700 : FontWeight.w500,
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
    );
  }

  Widget _buildLocationSection(AppThemeColors colors) {
    final appProvider = Provider.of<AppProvider>(context);
    final savedAddresses = appProvider.savedAddresses;

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
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Adresse de livraison',
                    style: AppTypography.h4.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                // Expand/Collapse map button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _isMapExpanded = !_isMapExpanded);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: colors.border),
                    ),
                    child: Icon(
                      _isMapExpanded ? Icons.expand_less : Icons.map,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Saved addresses selector
            if (savedAddresses.isNotEmpty) ...[
              _buildSavedAddressesSelector(colors, savedAddresses, appProvider),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: Divider(color: colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'ou nouvelle adresse',
                      style: AppTypography.bodySm.copyWith(color: colors.textSecondary),
                    ),
                  ),
                  Expanded(child: Divider(color: colors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Search bar for address
            _buildAddressSearchBar(colors),
            const SizedBox(height: AppSpacing.md),

            // Interactive Map
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isMapExpanded ? 300 : 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(color: colors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _selectedLocation,
                      initialZoom: 15.0,
                      onTap: (tapPosition, point) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedLocation = point;
                          _isAddressValid = true;
                        });
                        _updateAddressFromLocation(point);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.cuisinvoisin.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation,
                            width: 50,
                            height: 50,
                            child: const _LocationMarker(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Map overlay controls
                  Positioned(
                    right: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Column(
                      children: [
                        _buildMapButton(
                          icon: Icons.add,
                          onTap: () {
                            final currentZoom = _mapController.camera.zoom;
                            _mapController.move(_selectedLocation, currentZoom + 1);
                          },
                          colors: colors,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _buildMapButton(
                          icon: Icons.remove,
                          onTap: () {
                            final currentZoom = _mapController.camera.zoom;
                            _mapController.move(_selectedLocation, currentZoom - 1);
                          },
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                  // Loading indicator
                  if (_isLoadingLocation)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  // Tap to select hint
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: colors.card.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.touch_app, color: AppColors.primary, size: 16),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Touchez la carte pour placer le marqueur',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Location buttons row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _getCurrentLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isLoadingLocation
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Icon(Icons.my_location, color: AppColors.primary, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Ma position',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showFullScreenMap(colors),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fullscreen, color: AppColors.secondary, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Plein écran',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Coordinates display
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.gps_fixed, color: colors.textSecondary, size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                      style: AppTypography.bodySm.copyWith(
                        color: colors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Additional info
            Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(color: colors.border),
              ),
              child: TextField(
                controller: _additionalInfoController,
                style: AppTypography.bodyMd.copyWith(color: colors.textPrimary),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Instructions supplémentaires (étage, code, etc.)',
                  hintStyle: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Icon(Icons.edit_note, color: colors.textSecondary),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
            ),

            // Address validation indicator
            if (_selectedAddress.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    _isAddressValid ? Icons.check_circle : Icons.info_outline,
                    color: _isAddressValid ? AppColors.success : AppColors.warning,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _isAddressValid
                          ? 'Adresse validée'
                          : 'Veuillez entrer une adresse complète',
                      style: AppTypography.bodySm.copyWith(
                        color: _isAddressValid ? AppColors.success : AppColors.warning,
                      ),
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

  Widget _buildSavedAddressesSelector(AppThemeColors colors, List<SavedAddress> savedAddresses, AppProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.bookmark_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Adresses enregistrées',
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.border),
          ...savedAddresses.map((address) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedAddress = address.address;
                _searchController.text = address.address;
                _selectedLocation = LatLng(address.latitude, address.longitude);
                _isAddressValid = true;
              });
              _mapController.move(_selectedLocation, 15.0);
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _selectedAddress == address.address
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: colors.border,
                    width: address != savedAddresses.last ? 1 : 0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedAddress == address.address
                          ? AppColors.primary
                          : colors.background,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Icon(
                      address.label.toLowerCase() == 'maison'
                          ? Icons.home
                          : address.label.toLowerCase() == 'bureau'
                              ? Icons.business
                              : Icons.place,
                      color: _selectedAddress == address.address
                          ? Colors.white
                          : colors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              address.label,
                              style: AppTypography.bodyMd.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (address.isDefault) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                                ),
                                child: Text(
                                  'Par défaut',
                                  style: AppTypography.bodyXs.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address.address,
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (_selectedAddress == address.address)
                    Icon(Icons.check_circle, color: AppColors.primary, size: 24),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAddressSearchBar(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search input
        Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(
              color: _showSearchResults && _searchResults.isNotEmpty
                  ? AppColors.primary
                  : colors.border,
            ),
            boxShadow: _showSearchResults && _searchResults.isNotEmpty
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onTap: () {
              if (_searchController.text.isNotEmpty) {
                setState(() => _showSearchResults = true);
              }
            },
            style: AppTypography.bodyMd.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Rechercher une adresse (ex: Ariana, Tunis...)',
              hintStyle: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
              prefixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Icon(Icons.search, color: colors.textSecondary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults = [];
                          _showSearchResults = false;
                        });
                      },
                      child: Icon(Icons.clear, color: colors.textSecondary),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),

        // Search results dropdown
        if (_showSearchResults && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.xs),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: colors.border,
                ),
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return _buildSearchResultItem(result, colors);
                },
              ),
            ),
          ),

        // Selected address display
        if (_selectedAddress.isNotEmpty && !_showSearchResults) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _selectedAddress,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.text = _selectedAddress;
                      _showSearchResults = false;
                    });
                  },
                  child: Icon(Icons.edit, color: AppColors.success, size: 18),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResultItem(_SearchResult result, AppThemeColors colors) {
    return InkWell(
      onTap: () => _selectSearchResult(result),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: result.type == 'city'
                    ? AppColors.primaryLight
                    : AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Icon(
                result.type == 'city' ? Icons.location_city : Icons.place,
                color: result.type == 'city' ? AppColors.primary : AppColors.secondary,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    result.description,
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colors.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _searchController.text == query) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    // Simulated search results - In real app, use geocoding API
    final results = _getMockSearchResults(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  List<_SearchResult> _getMockSearchResults(String query) {
    final q = query.toLowerCase();

    // Mock database of locations (Tunisia focused as example)
    final allLocations = [
      _SearchResult(
        name: 'Ariana',
        description: 'Gouvernorat de l\'Ariana, Tunisie',
        type: 'city',
        latitude: 36.8663,
        longitude: 10.1647,
      ),
      _SearchResult(
        name: 'Ariana Ville',
        description: 'Centre ville, Ariana, Tunisie',
        type: 'area',
        latitude: 36.8625,
        longitude: 10.1935,
      ),
      _SearchResult(
        name: 'Ariana Soghra',
        description: 'Ariana, Tunisie',
        type: 'area',
        latitude: 36.8578,
        longitude: 10.1864,
      ),
      _SearchResult(
        name: 'Cité Ennasr',
        description: 'Ariana, Tunisie',
        type: 'area',
        latitude: 36.8456,
        longitude: 10.1823,
      ),
      _SearchResult(
        name: 'Tunis',
        description: 'Capitale de la Tunisie',
        type: 'city',
        latitude: 36.8065,
        longitude: 10.1815,
      ),
      _SearchResult(
        name: 'Tunis Centre',
        description: 'Centre ville, Tunis, Tunisie',
        type: 'area',
        latitude: 36.8008,
        longitude: 10.1800,
      ),
      _SearchResult(
        name: 'La Marsa',
        description: 'Gouvernorat de Tunis, Tunisie',
        type: 'city',
        latitude: 36.8764,
        longitude: 10.3253,
      ),
      _SearchResult(
        name: 'Lac 1',
        description: 'Les Berges du Lac, Tunis',
        type: 'area',
        latitude: 36.8326,
        longitude: 10.2336,
      ),
      _SearchResult(
        name: 'Lac 2',
        description: 'Les Berges du Lac, Tunis',
        type: 'area',
        latitude: 36.8426,
        longitude: 10.2536,
      ),
      _SearchResult(
        name: 'Sousse',
        description: 'Gouvernorat de Sousse, Tunisie',
        type: 'city',
        latitude: 35.8288,
        longitude: 10.6405,
      ),
      _SearchResult(
        name: 'Sfax',
        description: 'Gouvernorat de Sfax, Tunisie',
        type: 'city',
        latitude: 34.7406,
        longitude: 10.7603,
      ),
      _SearchResult(
        name: 'Monastir',
        description: 'Gouvernorat de Monastir, Tunisie',
        type: 'city',
        latitude: 35.7643,
        longitude: 10.8113,
      ),
      _SearchResult(
        name: 'Hammamet',
        description: 'Gouvernorat de Nabeul, Tunisie',
        type: 'city',
        latitude: 36.4000,
        longitude: 10.6167,
      ),
      _SearchResult(
        name: 'Nabeul',
        description: 'Gouvernorat de Nabeul, Tunisie',
        type: 'city',
        latitude: 36.4561,
        longitude: 10.7376,
      ),
      _SearchResult(
        name: 'Bizerte',
        description: 'Gouvernorat de Bizerte, Tunisie',
        type: 'city',
        latitude: 37.2744,
        longitude: 9.8739,
      ),
      _SearchResult(
        name: 'Carthage',
        description: 'Tunis, Tunisie',
        type: 'area',
        latitude: 36.8528,
        longitude: 10.3233,
      ),
      _SearchResult(
        name: 'Sidi Bou Said',
        description: 'Tunis, Tunisie',
        type: 'area',
        latitude: 36.8687,
        longitude: 10.3417,
      ),
      _SearchResult(
        name: 'Menzah',
        description: 'Tunis, Tunisie',
        type: 'area',
        latitude: 36.8245,
        longitude: 10.1458,
      ),
      _SearchResult(
        name: 'Menzah 6',
        description: 'El Menzah, Tunis',
        type: 'area',
        latitude: 36.8312,
        longitude: 10.1523,
      ),
      _SearchResult(
        name: 'Bardo',
        description: 'Le Bardo, Tunis',
        type: 'area',
        latitude: 36.8092,
        longitude: 10.1346,
      ),
    ];

    // Filter results based on query
    return allLocations
        .where((loc) =>
            loc.name.toLowerCase().contains(q) ||
            loc.description.toLowerCase().contains(q))
        .take(6)
        .toList();
  }

  void _selectSearchResult(_SearchResult result) {
    HapticFeedback.selectionClick();

    final location = LatLng(result.latitude, result.longitude);

    setState(() {
      _selectedLocation = location;
      _selectedAddress = '${result.name}, ${result.description}';
      _addressController.text = _selectedAddress;
      _searchController.text = result.name;
      _isAddressValid = true;
      _showSearchResults = false;
      _searchResults = [];
    });

    // Move map to selected location
    _mapController.move(location, 15.0);
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onTap,
    required AppThemeColors colors,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, color: colors.textPrimary, size: 20),
      ),
    );
  }

  void _getCurrentLocation() async {
    HapticFeedback.selectionClick();
    setState(() => _isLoadingLocation = true);

    // Simulate getting current location (in real app, use geolocator)
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Simulated current location (Tunis Centre)
      final location = const LatLng(36.8008, 10.1800);
      final address = _getAddressFromCoordinates(location.latitude, location.longitude);
      setState(() {
        _selectedLocation = location;
        _addressController.text = address;
        _selectedAddress = address;
        _isAddressValid = true;
        _isLoadingLocation = false;
      });
      _mapController.move(_selectedLocation, 17.0);
    }
  }

  void _updateAddressFromLocation(LatLng location) async {
    setState(() => _isLoadingLocation = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      // Get address based on coordinates using reverse geocoding simulation
      final address = _getAddressFromCoordinates(location.latitude, location.longitude);
      setState(() {
        _addressController.text = address;
        _selectedAddress = address;
        _isAddressValid = true;
        _isLoadingLocation = false;
      });
    }
  }

  String _getAddressFromCoordinates(double lat, double lng) {
    // Define regions with their coordinate bounds and names
    final regions = [
      {'name': 'Ariana', 'city': 'Ariana', 'minLat': 36.82, 'maxLat': 36.92, 'minLng': 10.10, 'maxLng': 10.22},
      {'name': 'Tunis Centre', 'city': 'Tunis', 'minLat': 36.78, 'maxLat': 36.82, 'minLng': 10.15, 'maxLng': 10.20},
      {'name': 'La Marsa', 'city': 'Tunis', 'minLat': 36.85, 'maxLat': 36.90, 'minLng': 10.30, 'maxLng': 10.35},
      {'name': 'Carthage', 'city': 'Tunis', 'minLat': 36.84, 'maxLat': 36.87, 'minLng': 10.30, 'maxLng': 10.34},
      {'name': 'Sidi Bou Said', 'city': 'Tunis', 'minLat': 36.86, 'maxLat': 36.88, 'minLng': 10.33, 'maxLng': 10.36},
      {'name': 'Le Bardo', 'city': 'Tunis', 'minLat': 36.80, 'maxLat': 36.82, 'minLng': 10.12, 'maxLng': 10.15},
      {'name': 'Les Berges du Lac', 'city': 'Tunis', 'minLat': 36.82, 'maxLat': 36.86, 'minLng': 10.22, 'maxLng': 10.28},
      {'name': 'El Menzah', 'city': 'Tunis', 'minLat': 36.82, 'maxLat': 36.85, 'minLng': 10.13, 'maxLng': 10.17},
      {'name': 'Cité Ennasr', 'city': 'Ariana', 'minLat': 36.84, 'maxLat': 36.86, 'minLng': 10.17, 'maxLng': 10.20},
      {'name': 'Sousse', 'city': 'Sousse', 'minLat': 35.80, 'maxLat': 35.86, 'minLng': 10.60, 'maxLng': 10.68},
      {'name': 'Sfax', 'city': 'Sfax', 'minLat': 34.72, 'maxLat': 34.78, 'minLng': 10.74, 'maxLng': 10.80},
      {'name': 'Monastir', 'city': 'Monastir', 'minLat': 35.74, 'maxLat': 35.80, 'minLng': 10.78, 'maxLng': 10.85},
      {'name': 'Hammamet', 'city': 'Nabeul', 'minLat': 36.38, 'maxLat': 36.44, 'minLng': 10.58, 'maxLng': 10.65},
      {'name': 'Nabeul', 'city': 'Nabeul', 'minLat': 36.44, 'maxLat': 36.48, 'minLng': 10.72, 'maxLng': 10.76},
      {'name': 'Bizerte', 'city': 'Bizerte', 'minLat': 37.26, 'maxLat': 37.30, 'minLng': 9.85, 'maxLng': 9.90},
      {'name': 'La Manouba', 'city': 'Manouba', 'minLat': 36.80, 'maxLat': 36.82, 'minLng': 10.06, 'maxLng': 10.12},
      {'name': 'Ben Arous', 'city': 'Ben Arous', 'minLat': 36.74, 'maxLat': 36.78, 'minLng': 10.20, 'maxLng': 10.26},
    ];

    // Find matching region
    for (final region in regions) {
      final minLat = region['minLat'] as double;
      final maxLat = region['maxLat'] as double;
      final minLng = region['minLng'] as double;
      final maxLng = region['maxLng'] as double;

      if (lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng) {
        final streetNumber = ((lat * 1000).toInt() % 150) + 1;
        final streets = ['Rue de la République', 'Avenue Habib Bourguiba', 'Rue de Marseille', 'Avenue de la Liberté', 'Rue Ibn Khaldoun', 'Avenue Mohamed V'];
        final street = streets[((lng * 100).toInt() % streets.length)];
        return '$streetNumber $street, ${region['name']}, ${region['city']}, Tunisie';
      }
    }

    // Default: Check if in Tunisia general area
    if (lat >= 30.0 && lat <= 38.0 && lng >= 7.0 && lng <= 12.0) {
      final streetNumber = ((lat * 1000).toInt() % 150) + 1;

      // Determine closest major city
      String city = 'Tunis';
      if (lat < 34.0) city = 'Sfax';
      else if (lat < 35.5) city = 'Sousse';
      else if (lat > 37.0) city = 'Bizerte';
      else if (lng > 10.5) city = 'Nabeul';

      return '$streetNumber Rue Principale, $city, Tunisie';
    }

    // Outside Tunisia
    return '${((lat * 100).toInt() % 200)} Rue Principale, Position: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }

  void _showFullScreenMap(AppThemeColors colors) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _FullScreenMapPicker(
          initialLocation: _selectedLocation,
          onLocationSelected: (location, address) {
            setState(() {
              _selectedLocation = location;
              _addressController.text = address;
              _selectedAddress = address;
              _isAddressValid = true;
            });
            _mapController.move(location, 17.0);
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(AppThemeColors colors) {
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
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Icon(Icons.payment, color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Mode de paiement',
                  style: AppTypography.h4.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Payment options
            _buildPaymentOption(
              colors: colors,
              icon: Icons.credit_card,
              title: 'Carte bancaire',
              subtitle: 'Visa, Mastercard, CB',
              index: 0,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPaymentOption(
              colors: colors,
              icon: Icons.money,
              title: 'Espèces',
              subtitle: 'Paiement à la livraison',
              index: 1,
              iconColor: AppColors.success,
            ),
            // Card details section (if card payment selected)
            if (_paymentMethod == 0) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: const Icon(Icons.credit_card, color: Colors.blue, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '**** **** **** 4242',
                            style: AppTypography.bodyMd.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Expire 12/28',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _showAddCardBottomSheet(colors);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        ),
                        child: Text(
                          'Modifier',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Cash payment note
            if (_paymentMethod == 1) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Préparez le montant exact si possible. Le livreur peut ne pas avoir de monnaie.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required AppThemeColors colors,
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
    required Color iconColor,
  }) {
    final isSelected = _paymentMethod == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _paymentMethod = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : colors.background,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(icon, color: iconColor, size: 24),
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
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : colors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardBottomSheet(AppThemeColors colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppBorderRadius.xl)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
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
                'Ajouter une carte',
                style: AppTypography.h3.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Card number
              _buildCardInputField(
                colors: colors,
                label: 'Numéro de carte',
                hint: '1234 5678 9012 3456',
                icon: Icons.credit_card,
              ),
              const SizedBox(height: AppSpacing.md),
              // Expiry and CVV row
              Row(
                children: [
                  Expanded(
                    child: _buildCardInputField(
                      colors: colors,
                      label: 'Date d\'expiration',
                      hint: 'MM/AA',
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildCardInputField(
                      colors: colors,
                      label: 'CVV',
                      hint: '123',
                      icon: Icons.lock_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Cardholder name
              _buildCardInputField(
                colors: colors,
                label: 'Nom du titulaire',
                hint: 'JEAN DUPONT',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Enregistrer la carte',
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Carte enregistrée avec succès'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                      ),
                    );
                  },
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.lg,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInputField({
    required AppThemeColors colors,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: colors.border),
          ),
          child: TextField(
            style: AppTypography.bodyMd.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
              prefixIcon: Icon(icon, color: colors.textSecondary, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(dynamic item, AppProvider appProvider, AppThemeColors colors) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        appProvider.removeFromCart(item.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
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
            // Image placeholder
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: const Center(
                child: Text('🍽️', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.dishName,
                    style: AppTypography.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(2)}€ x ${item.quantity}',
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(item.price * item.quantity).toStringAsFixed(2)}€',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Control
            Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      appProvider.updateCartItem(item.id, item.quantity - 1);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: colors.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      '${item.quantity}',
                      style: AppTypography.bodyLg.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      appProvider.updateCartItem(item.id, item.quantity + 1);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
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

  Widget _buildPromoCodeSection(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: const Icon(Icons.local_offer, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Code promo',
                style: AppTypography.bodyMd.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                'Ajouter',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown(dynamic cart, AppThemeColors colors) {
    final deliveryFee = _deliveryMode == 0 ? 2.99 : 0.0;
    final total = cart.subtotal + cart.serviceFee + deliveryFee;

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
            Text(
              'Résumé de la commande',
              style: AppTypography.h4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildCostRow('Sous-total', '${cart.subtotal.toStringAsFixed(2)}€', colors),
            const SizedBox(height: AppSpacing.md),
            _buildCostRow('Frais de service', '${cart.serviceFee.toStringAsFixed(2)}€', colors),
            const SizedBox(height: AppSpacing.md),
            _buildCostRow(
              'Frais de livraison',
              _deliveryMode == 0 ? '${deliveryFee.toStringAsFixed(2)}€' : 'Gratuit',
              colors,
              isHighlighted: _deliveryMode == 1,
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(color: colors.border),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTypography.h3.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)}€',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, AppThemeColors colors, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(
            color: isHighlighted ? AppColors.success : colors.textPrimary,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(dynamic cart, AppThemeColors colors) {
    final deliveryFee = _deliveryMode == 0 ? 2.99 : 0.0;
    final total = cart.subtotal + cart.serviceFee + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(
          top: BorderSide(color: colors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: _isProcessing ? null : _placeOrder,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: _isProcessing ? AppColors.success : AppColors.primary,
              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: (_isProcessing ? AppColors.success : AppColors.primary)
                      .withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Traitement...',
                          style: AppTypography.bodyLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Passer la commande',
                          style: AppTypography.bodyLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          ),
                          child: Text(
                            '${total.toStringAsFixed(2)}€',
                            style: AppTypography.bodyMd.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, AppProvider appProvider, AppThemeColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        title: Text(
          'Vider le panier ?',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer tous les articles de votre panier ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              appProvider.clearCart();
              Navigator.of(context).pop();
            },
            child: Text(
              'Vider',
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

// Custom location marker widget
class _LocationMarker extends StatelessWidget {
  const _LocationMarker();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.primary,
                  size: 14,
                ),
              ),
            ),
            Container(
              width: 2,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              width: 6,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Full screen map picker
class _FullScreenMapPicker extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng location, String address) onLocationSelected;

  const _FullScreenMapPicker({
    required this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<_FullScreenMapPicker> createState() => _FullScreenMapPickerState();
}

class _FullScreenMapPickerState extends State<_FullScreenMapPicker> {
  late LatLng _currentLocation;
  late MapController _mapController;
  String _currentAddress = '';
  bool _isLoading = false;

  // Search variables
  final TextEditingController _searchController = TextEditingController();
  List<_SearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _mapController = MapController();
    _updateAddressFromLocation(_currentLocation);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateAddressFromLocation(LatLng location) async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      final address = _getAddressFromCoordinates(location.latitude, location.longitude);
      setState(() {
        _currentAddress = address;
        _isLoading = false;
      });
    }
  }

  String _getAddressFromCoordinates(double lat, double lng) {
    // Define regions with their coordinate bounds and names
    final regions = [
      {'name': 'Ariana', 'city': 'Ariana', 'minLat': 36.82, 'maxLat': 36.92, 'minLng': 10.10, 'maxLng': 10.22},
      {'name': 'Tunis Centre', 'city': 'Tunis', 'minLat': 36.78, 'maxLat': 36.82, 'minLng': 10.15, 'maxLng': 10.20},
      {'name': 'La Marsa', 'city': 'Tunis', 'minLat': 36.85, 'maxLat': 36.90, 'minLng': 10.30, 'maxLng': 10.35},
      {'name': 'Carthage', 'city': 'Tunis', 'minLat': 36.84, 'maxLat': 36.87, 'minLng': 10.30, 'maxLng': 10.34},
      {'name': 'Sidi Bou Said', 'city': 'Tunis', 'minLat': 36.86, 'maxLat': 36.88, 'minLng': 10.33, 'maxLng': 10.36},
      {'name': 'Le Bardo', 'city': 'Tunis', 'minLat': 36.80, 'maxLat': 36.82, 'minLng': 10.12, 'maxLng': 10.15},
      {'name': 'Les Berges du Lac', 'city': 'Tunis', 'minLat': 36.82, 'maxLat': 36.86, 'minLng': 10.22, 'maxLng': 10.28},
      {'name': 'El Menzah', 'city': 'Tunis', 'minLat': 36.82, 'maxLat': 36.85, 'minLng': 10.13, 'maxLng': 10.17},
      {'name': 'Cité Ennasr', 'city': 'Ariana', 'minLat': 36.84, 'maxLat': 36.86, 'minLng': 10.17, 'maxLng': 10.20},
      {'name': 'Sousse', 'city': 'Sousse', 'minLat': 35.80, 'maxLat': 35.86, 'minLng': 10.60, 'maxLng': 10.68},
      {'name': 'Sfax', 'city': 'Sfax', 'minLat': 34.72, 'maxLat': 34.78, 'minLng': 10.74, 'maxLng': 10.80},
      {'name': 'Monastir', 'city': 'Monastir', 'minLat': 35.74, 'maxLat': 35.80, 'minLng': 10.78, 'maxLng': 10.85},
      {'name': 'Hammamet', 'city': 'Nabeul', 'minLat': 36.38, 'maxLat': 36.44, 'minLng': 10.58, 'maxLng': 10.65},
      {'name': 'Nabeul', 'city': 'Nabeul', 'minLat': 36.44, 'maxLat': 36.48, 'minLng': 10.72, 'maxLng': 10.76},
      {'name': 'Bizerte', 'city': 'Bizerte', 'minLat': 37.26, 'maxLat': 37.30, 'minLng': 9.85, 'maxLng': 9.90},
      {'name': 'La Manouba', 'city': 'Manouba', 'minLat': 36.80, 'maxLat': 36.82, 'minLng': 10.06, 'maxLng': 10.12},
      {'name': 'Ben Arous', 'city': 'Ben Arous', 'minLat': 36.74, 'maxLat': 36.78, 'minLng': 10.20, 'maxLng': 10.26},
    ];

    // Find matching region
    for (final region in regions) {
      final minLat = region['minLat'] as double;
      final maxLat = region['maxLat'] as double;
      final minLng = region['minLng'] as double;
      final maxLng = region['maxLng'] as double;

      if (lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng) {
        final streetNumber = ((lat * 1000).toInt() % 150) + 1;
        final streets = ['Rue de la République', 'Avenue Habib Bourguiba', 'Rue de Marseille', 'Avenue de la Liberté', 'Rue Ibn Khaldoun', 'Avenue Mohamed V'];
        final street = streets[((lng * 100).toInt() % streets.length)];
        return '$streetNumber $street, ${region['name']}, ${region['city']}, Tunisie';
      }
    }

    // Default: Check if in Tunisia general area
    if (lat >= 30.0 && lat <= 38.0 && lng >= 7.0 && lng <= 12.0) {
      final streetNumber = ((lat * 1000).toInt() % 150) + 1;

      // Determine closest major city
      String city = 'Tunis';
      if (lat < 34.0) city = 'Sfax';
      else if (lat < 35.5) city = 'Sousse';
      else if (lat > 37.0) city = 'Bizerte';
      else if (lng > 10.5) city = 'Nabeul';

      return '$streetNumber Rue Principale, $city, Tunisie';
    }

    // Outside Tunisia
    return '${((lat * 100).toInt() % 200)} Rue Principale, Position: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 16.0,
              onTap: (tapPosition, point) {
                HapticFeedback.selectionClick();
                setState(() => _currentLocation = point);
                _updateAddressFromLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cuisinvoisin.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 50,
                    height: 50,
                    child: const _LocationMarker(),
                  ),
                ],
              ),
            ],
          ),

          // Top bar with search
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(Icons.close, color: colors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            onTap: () {
                              if (_searchController.text.isNotEmpty) {
                                setState(() => _showSearchResults = true);
                              }
                            },
                            style: AppTypography.bodyMd.copyWith(color: colors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Rechercher une adresse...',
                              hintStyle: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
                              prefixIcon: _isSearching
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  : Icon(Icons.search, color: colors.textSecondary),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchResults = [];
                                          _showSearchResults = false;
                                        });
                                      },
                                      child: Icon(Icons.clear, color: colors.textSecondary),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(AppSpacing.md),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Search results
                  if (_showSearchResults && _searchResults.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: AppSpacing.sm, left: 56),
                      constraints: const BoxConstraints(maxHeight: 250),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _searchResults.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: colors.border,
                          ),
                          itemBuilder: (context, index) {
                            final result = _searchResults[index];
                            return _buildSearchResultItem(result, colors);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            right: AppSpacing.lg,
            bottom: 220,
            child: Column(
              children: [
                _buildZoomButton(
                  icon: Icons.add,
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_currentLocation, currentZoom + 1);
                  },
                  colors: colors,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildZoomButton(
                  icon: Icons.remove,
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_currentLocation, currentZoom - 1);
                  },
                  colors: colors,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildZoomButton(
                  icon: Icons.my_location,
                  onTap: () {
                    // Simulate getting current location (Tunis)
                    setState(() {
                      _currentLocation = const LatLng(36.8008, 10.1800);
                    });
                    _mapController.move(_currentLocation, 17.0);
                    _updateAddressFromLocation(_currentLocation);
                  },
                  colors: colors,
                  isHighlighted: true,
                ),
              ],
            ),
          ),

          // Bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppBorderRadius.xl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adresse sélectionnée',
                                style: AppTypography.bodySm.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              _isLoading
                                  ? Row(
                                      children: [
                                        const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          'Chargement...',
                                          style: AppTypography.bodyMd.copyWith(
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      _currentAddress.isEmpty
                                          ? 'Touchez la carte pour sélectionner'
                                          : _currentAddress,
                                      style: AppTypography.bodyMd.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Coordinates
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.gps_fixed,
                            color: colors.textSecondary,
                            size: 14,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${_currentLocation.latitude.toStringAsFixed(6)}, ${_currentLocation.longitude.toStringAsFixed(6)}',
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          widget.onLocationSelected(_currentLocation, _currentAddress);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check, color: Colors.white),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Confirmer cette adresse',
                                style: AppTypography.bodyLg.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
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
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _searchController.text == query) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    final results = _getMockSearchResults(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  List<_SearchResult> _getMockSearchResults(String query) {
    final q = query.toLowerCase();

    final allLocations = [
      _SearchResult(name: 'Ariana', description: 'Gouvernorat de l\'Ariana, Tunisie', type: 'city', latitude: 36.8663, longitude: 10.1647),
      _SearchResult(name: 'Ariana Ville', description: 'Centre ville, Ariana, Tunisie', type: 'area', latitude: 36.8625, longitude: 10.1935),
      _SearchResult(name: 'Ariana Soghra', description: 'Ariana, Tunisie', type: 'area', latitude: 36.8578, longitude: 10.1864),
      _SearchResult(name: 'Cité Ennasr', description: 'Ariana, Tunisie', type: 'area', latitude: 36.8456, longitude: 10.1823),
      _SearchResult(name: 'Tunis', description: 'Capitale de la Tunisie', type: 'city', latitude: 36.8065, longitude: 10.1815),
      _SearchResult(name: 'Tunis Centre', description: 'Centre ville, Tunis, Tunisie', type: 'area', latitude: 36.8008, longitude: 10.1800),
      _SearchResult(name: 'La Marsa', description: 'Gouvernorat de Tunis, Tunisie', type: 'city', latitude: 36.8764, longitude: 10.3253),
      _SearchResult(name: 'Lac 1', description: 'Les Berges du Lac, Tunis', type: 'area', latitude: 36.8326, longitude: 10.2336),
      _SearchResult(name: 'Lac 2', description: 'Les Berges du Lac, Tunis', type: 'area', latitude: 36.8426, longitude: 10.2536),
      _SearchResult(name: 'Sousse', description: 'Gouvernorat de Sousse, Tunisie', type: 'city', latitude: 35.8288, longitude: 10.6405),
      _SearchResult(name: 'Sfax', description: 'Gouvernorat de Sfax, Tunisie', type: 'city', latitude: 34.7406, longitude: 10.7603),
      _SearchResult(name: 'Monastir', description: 'Gouvernorat de Monastir, Tunisie', type: 'city', latitude: 35.7643, longitude: 10.8113),
      _SearchResult(name: 'Hammamet', description: 'Gouvernorat de Nabeul, Tunisie', type: 'city', latitude: 36.4000, longitude: 10.6167),
      _SearchResult(name: 'Nabeul', description: 'Gouvernorat de Nabeul, Tunisie', type: 'city', latitude: 36.4561, longitude: 10.7376),
      _SearchResult(name: 'Bizerte', description: 'Gouvernorat de Bizerte, Tunisie', type: 'city', latitude: 37.2744, longitude: 9.8739),
      _SearchResult(name: 'Carthage', description: 'Tunis, Tunisie', type: 'area', latitude: 36.8528, longitude: 10.3233),
      _SearchResult(name: 'Sidi Bou Said', description: 'Tunis, Tunisie', type: 'area', latitude: 36.8687, longitude: 10.3417),
      _SearchResult(name: 'Menzah', description: 'Tunis, Tunisie', type: 'area', latitude: 36.8245, longitude: 10.1458),
      _SearchResult(name: 'Menzah 6', description: 'El Menzah, Tunis', type: 'area', latitude: 36.8312, longitude: 10.1523),
      _SearchResult(name: 'Bardo', description: 'Le Bardo, Tunis', type: 'area', latitude: 36.8092, longitude: 10.1346),
      _SearchResult(name: 'Manouba', description: 'Gouvernorat de la Manouba, Tunisie', type: 'city', latitude: 36.8081, longitude: 10.0863),
      _SearchResult(name: 'Ben Arous', description: 'Gouvernorat de Ben Arous, Tunisie', type: 'city', latitude: 36.7533, longitude: 10.2283),
    ];

    return allLocations
        .where((loc) =>
            loc.name.toLowerCase().contains(q) ||
            loc.description.toLowerCase().contains(q))
        .take(6)
        .toList();
  }

  void _selectSearchResult(_SearchResult result) {
    HapticFeedback.selectionClick();

    final location = LatLng(result.latitude, result.longitude);

    setState(() {
      _currentLocation = location;
      _currentAddress = '${result.name}, ${result.description}';
      _searchController.text = result.name;
      _showSearchResults = false;
      _searchResults = [];
    });

    _mapController.move(location, 15.0);
  }

  Widget _buildSearchResultItem(_SearchResult result, AppThemeColors colors) {
    return InkWell(
      onTap: () => _selectSearchResult(result),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: result.type == 'city'
                    ? AppColors.primaryLight
                    : AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Icon(
                result.type == 'city' ? Icons.location_city : Icons.place,
                color: result.type == 'city' ? AppColors.primary : AppColors.secondary,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    result.description,
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colors.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
    required AppThemeColors colors,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primary : colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isHighlighted ? Colors.white : colors.textPrimary,
        ),
      ),
    );
  }
}

// Search result model for address search
class _SearchResult {
  final String name;
  final String description;
  final String type; // 'city' or 'area'
  final double latitude;
  final double longitude;

  _SearchResult({
    required this.name,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
  });
}

