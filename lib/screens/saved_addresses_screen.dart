import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final addresses = appProvider.savedAddresses;

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
                      child: Icon(Icons.arrow_back, color: colors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Mes adresses',
                      style: AppTypography.h2.copyWith(color: colors.textPrimary),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAddAddressSheet(context, colors, appProvider),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Address list
            Expanded(
              child: addresses.isEmpty
                  ? _buildEmptyState(colors, appProvider)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return _buildAddressCard(addresses[index], colors, appProvider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppThemeColors colors, AppProvider appProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off_outlined,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Aucune adresse enregistrée',
              style: AppTypography.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ajoutez une adresse pour faciliter vos prochaines commandes',
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            GestureDetector(
              onTap: () => _showAddAddressSheet(context, colors, appProvider),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Ajouter une adresse',
                      style: AppTypography.bodyLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(SavedAddress address, AppThemeColors colors, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : colors.border,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Map preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppBorderRadius.xl - 1),
            ),
            child: SizedBox(
              height: 120,
              child: IgnorePointer(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(address.latitude, address.longitude),
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.cuisinvoisin.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(address.latitude, address.longitude),
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Address info
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getLabelColor(address.label).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getLabelIcon(address.label),
                            size: 14,
                            color: _getLabelColor(address.label),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            address.label,
                            style: AppTypography.bodySm.copyWith(
                              color: _getLabelColor(address.label),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: Text(
                          'Par défaut',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: colors.textSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      color: colors.card,
                      onSelected: (value) {
                        switch (value) {
                          case 'default':
                            appProvider.setDefaultAddress(address.id);
                            break;
                          case 'edit':
                            _showEditAddressSheet(context, colors, appProvider, address);
                            break;
                          case 'delete':
                            _showDeleteConfirmation(context, colors, appProvider, address);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (!address.isDefault)
                          PopupMenuItem(
                            value: 'default',
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                                const SizedBox(width: AppSpacing.sm),
                                Text('Définir par défaut', style: AppTypography.bodyMd.copyWith(color: colors.textPrimary)),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Text('Modifier', style: AppTypography.bodyMd.copyWith(color: colors.textPrimary)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Text('Supprimer', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  address.address,
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (address.additionalInfo != null && address.additionalInfo!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    address.additionalInfo!,
                    style: AppTypography.bodySm.copyWith(color: colors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLabelColor(String label) {
    switch (label.toLowerCase()) {
      case 'maison':
        return AppColors.primary;
      case 'bureau':
        return AppColors.secondary;
      case 'autre':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'maison':
        return Icons.home;
      case 'bureau':
        return Icons.business;
      case 'autre':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  void _showDeleteConfirmation(BuildContext context, AppThemeColors colors, AppProvider appProvider, SavedAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        title: Text(
          'Supprimer l\'adresse ?',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${address.label}" ?',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              appProvider.deleteSavedAddress(address.id);
              Navigator.of(context).pop();
            },
            child: Text('Supprimer', style: AppTypography.bodyMd.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context, AppThemeColors colors, AppProvider appProvider) {
    _showAddressFormSheet(context, colors, appProvider, null);
  }

  void _showEditAddressSheet(BuildContext context, AppThemeColors colors, AppProvider appProvider, SavedAddress address) {
    _showAddressFormSheet(context, colors, appProvider, address);
  }

  void _showAddressFormSheet(BuildContext context, AppThemeColors colors, AppProvider appProvider, SavedAddress? existingAddress) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        existingAddress: existingAddress,
        onSave: (address) {
          if (existingAddress != null) {
            appProvider.updateSavedAddress(address);
          } else {
            appProvider.addSavedAddress(address);
          }
        },
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final SavedAddress? existingAddress;
  final Function(SavedAddress) onSave;

  const _AddressFormSheet({
    this.existingAddress,
    required this.onSave,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  late TextEditingController _additionalInfoController;
  late TextEditingController _searchController;

  late LatLng _selectedLocation;
  late MapController _mapController;
  String _selectedLabel = 'Maison';
  bool _isDefault = false;
  bool _isSearching = false;
  bool _showSearchResults = false;
  List<_SearchResult> _searchResults = [];

  final List<String> _labelOptions = ['Maison', 'Bureau', 'Autre'];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.existingAddress?.label ?? 'Maison');
    _addressController = TextEditingController(text: widget.existingAddress?.address ?? '');
    _additionalInfoController = TextEditingController(text: widget.existingAddress?.additionalInfo ?? '');
    _searchController = TextEditingController();
    _selectedLocation = widget.existingAddress != null
        ? LatLng(widget.existingAddress!.latitude, widget.existingAddress!.longitude)
        : const LatLng(36.8065, 10.1815);
    _mapController = MapController();
    _selectedLabel = widget.existingAddress?.label ?? 'Maison';
    _isDefault = widget.existingAddress?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _additionalInfoController.dispose();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final isEditing = widget.existingAddress != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.xl)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, color: colors.textPrimary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    isEditing ? 'Modifier l\'adresse' : 'Nouvelle adresse',
                    style: AppTypography.h3.copyWith(color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label selection
                  Text('Type d\'adresse', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: _labelOptions.map((label) => Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedLabel = label),
                        child: Container(
                          margin: EdgeInsets.only(right: label != _labelOptions.last ? AppSpacing.sm : 0),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: _selectedLabel == label ? AppColors.primary : colors.card,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            border: Border.all(
                              color: _selectedLabel == label ? AppColors.primary : colors.border,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                label == 'Maison' ? Icons.home : label == 'Bureau' ? Icons.business : Icons.place,
                                color: _selectedLabel == label ? Colors.white : colors.textSecondary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: AppTypography.bodySm.copyWith(
                                  color: _selectedLabel == label ? Colors.white : colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Search bar
                  Text('Rechercher une adresse', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSearchBar(colors),
                  const SizedBox(height: AppSpacing.lg),

                  // Map
                  Text('Position sur la carte', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    height: 200,
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
                              setState(() => _selectedLocation = point);
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
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                    ),
                                    child: const Icon(Icons.location_on, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: colors.card.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                            ),
                            child: Text(
                              'Touchez pour déplacer',
                              style: AppTypography.bodySm.copyWith(color: colors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Address display
                  Text('Adresse', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _addressController.text.isEmpty ? 'Sélectionnez une position' : _addressController.text,
                            style: AppTypography.bodyMd.copyWith(
                              color: _addressController.text.isEmpty ? colors.textSecondary : colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Additional info
                  Text('Informations supplémentaires', style: AppTypography.bodyMd.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: colors.border),
                    ),
                    child: TextField(
                      controller: _additionalInfoController,
                      style: AppTypography.bodyMd.copyWith(color: colors.textPrimary),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Étage, appartement, code d\'entrée...',
                        hintStyle: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Default switch
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppColors.success, size: 24),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Adresse par défaut', style: AppTypography.bodyMd.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                              Text('Utiliser cette adresse automatiquement', style: AppTypography.bodySm.copyWith(color: colors.textSecondary)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isDefault,
                          onChanged: (value) => setState(() => _isDefault = value),
                          activeColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
          // Save button
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.card,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: SafeArea(
              child: GestureDetector(
                onTap: _saveAddress,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: _addressController.text.isEmpty ? colors.border : AppColors.primary,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  ),
                  child: Text(
                    isEditing ? 'Enregistrer les modifications' : 'Ajouter cette adresse',
                    style: AppTypography.bodyLg.copyWith(
                      color: _addressController.text.isEmpty ? colors.textSecondary : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppThemeColors colors) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: _showSearchResults ? AppColors.primary : colors.border),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: AppTypography.bodyMd.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Ex: Ariana, Tunis...',
              hintStyle: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
              prefixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
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
        if (_showSearchResults && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.xs),
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(color: colors.border),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  dense: true,
                  leading: Icon(result.type == 'city' ? Icons.location_city : Icons.place, color: AppColors.primary, size: 20),
                  title: Text(result.name, style: AppTypography.bodyMd.copyWith(color: colors.textPrimary)),
                  subtitle: Text(result.description, style: AppTypography.bodySm.copyWith(color: colors.textSecondary)),
                  onTap: () => _selectSearchResult(result),
                );
              },
            ),
          ),
      ],
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
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _searchController.text == query) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    final q = query.toLowerCase();
    final allLocations = [
      _SearchResult(name: 'Ariana', description: 'Gouvernorat de l\'Ariana, Tunisie', type: 'city', latitude: 36.8663, longitude: 10.1647),
      _SearchResult(name: 'Tunis', description: 'Capitale de la Tunisie', type: 'city', latitude: 36.8065, longitude: 10.1815),
      _SearchResult(name: 'La Marsa', description: 'Tunis, Tunisie', type: 'city', latitude: 36.8764, longitude: 10.3253),
      _SearchResult(name: 'Les Berges du Lac', description: 'Tunis, Tunisie', type: 'area', latitude: 36.8326, longitude: 10.2336),
      _SearchResult(name: 'Sousse', description: 'Gouvernorat de Sousse, Tunisie', type: 'city', latitude: 35.8288, longitude: 10.6405),
      _SearchResult(name: 'Sfax', description: 'Gouvernorat de Sfax, Tunisie', type: 'city', latitude: 34.7406, longitude: 10.7603),
      _SearchResult(name: 'Carthage', description: 'Tunis, Tunisie', type: 'area', latitude: 36.8528, longitude: 10.3233),
      _SearchResult(name: 'Sidi Bou Said', description: 'Tunis, Tunisie', type: 'area', latitude: 36.8687, longitude: 10.3417),
    ];
    final results = allLocations.where((loc) => loc.name.toLowerCase().contains(q) || loc.description.toLowerCase().contains(q)).take(5).toList();
    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  void _selectSearchResult(_SearchResult result) {
    final location = LatLng(result.latitude, result.longitude);
    setState(() {
      _selectedLocation = location;
      _searchController.text = result.name;
      _showSearchResults = false;
      _searchResults = [];
    });
    _mapController.move(location, 15.0);
    _updateAddressFromLocation(location);
  }

  void _updateAddressFromLocation(LatLng location) {
    final address = _getAddressFromCoordinates(location.latitude, location.longitude);
    setState(() {
      _addressController.text = address;
    });
  }

  String _getAddressFromCoordinates(double lat, double lng) {
    final regions = [
      {'name': 'Ariana', 'city': 'Ariana', 'minLat': 36.82, 'maxLat': 36.92, 'minLng': 10.10, 'maxLng': 10.22},
      {'name': 'Tunis Centre', 'city': 'Tunis', 'minLat': 36.78, 'maxLat': 36.82, 'minLng': 10.15, 'maxLng': 10.20},
      {'name': 'La Marsa', 'city': 'Tunis', 'minLat': 36.85, 'maxLat': 36.90, 'minLng': 10.30, 'maxLng': 10.35},
      {'name': 'Les Berges du Lac', 'city': 'Tunis', 'minLat': 36.82, 'maxLat': 36.86, 'minLng': 10.22, 'maxLng': 10.28},
      {'name': 'Sousse', 'city': 'Sousse', 'minLat': 35.80, 'maxLat': 35.86, 'minLng': 10.60, 'maxLng': 10.68},
      {'name': 'Sfax', 'city': 'Sfax', 'minLat': 34.72, 'maxLat': 34.78, 'minLng': 10.74, 'maxLng': 10.80},
    ];
    for (final region in regions) {
      if (lat >= (region['minLat'] as double) && lat <= (region['maxLat'] as double) &&
          lng >= (region['minLng'] as double) && lng <= (region['maxLng'] as double)) {
        final streetNumber = ((lat * 1000).toInt() % 150) + 1;
        final streets = ['Rue de la République', 'Avenue Habib Bourguiba', 'Avenue de la Liberté', 'Rue Ibn Khaldoun'];
        final street = streets[((lng * 100).toInt() % streets.length)];
        return '$streetNumber $street, ${region['name']}, ${region['city']}, Tunisie';
      }
    }
    if (lat >= 30.0 && lat <= 38.0 && lng >= 7.0 && lng <= 12.0) {
      final streetNumber = ((lat * 1000).toInt() % 150) + 1;
      return '$streetNumber Rue Principale, Tunisie';
    }
    return 'Position: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }

  void _saveAddress() {
    if (_addressController.text.isEmpty) return;

    HapticFeedback.mediumImpact();

    final address = SavedAddress(
      id: widget.existingAddress?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: _selectedLabel,
      address: _addressController.text,
      additionalInfo: _additionalInfoController.text.isEmpty ? null : _additionalInfoController.text,
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
      isDefault: _isDefault,
      createdAt: widget.existingAddress?.createdAt ?? DateTime.now(),
    );

    widget.onSave(address);
    Navigator.of(context).pop();
  }
}

class _SearchResult {
  final String name;
  final String description;
  final String type;
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

