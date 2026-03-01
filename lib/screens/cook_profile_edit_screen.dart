import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class CookProfileEditScreen extends StatefulWidget {
  const CookProfileEditScreen({super.key});

  @override
  State<CookProfileEditScreen> createState() => _CookProfileEditScreenState();
}

class _CookProfileEditScreenState extends State<CookProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _deliveryRadiusController;
  late TextEditingController _specialtiesController;
  bool _isAvailable = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final cook = Provider.of<AppProvider>(context, listen: false).currentCook;
    _nameController = TextEditingController(text: cook?.name ?? '');
    _titleController = TextEditingController(text: cook?.title ?? '');
    _bioController = TextEditingController(text: cook?.bio ?? '');
    _phoneController = TextEditingController(text: cook?.phone ?? '');
    _addressController = TextEditingController(text: cook?.address ?? '');
    _deliveryRadiusController = TextEditingController(
        text: cook?.deliveryRadius.toString() ?? '');
    _specialtiesController =
        TextEditingController(text: cook?.specialties.join(', ') ?? '');
    _isAvailable = cook?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _deliveryRadiusController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final cook = appProvider.currentCook;
    if (cook == null) return;

    final updatedCook = cook.copyWith(
      name: _nameController.text,
      title: _titleController.text,
      bio: _bioController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      deliveryRadius: int.tryParse(_deliveryRadiusController.text) ??
          cook.deliveryRadius,
      specialties: _specialtiesController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      isAvailable: _isAvailable,
    );

    appProvider.updateCookProfile(updatedCook);
    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Profil mis à jour avec succès'),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cook = appProvider.currentCook;
    final user = appProvider.user;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mon Profil',
                      style: AppTypography.h3
                          .copyWith(color: colors.textPrimary)),
                    GestureDetector(
                      onTap: () {
                        if (_isEditing) {
                          _handleSave();
                        } else {
                          setState(() => _isEditing = true);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: _isEditing
                              ? AppColors.success
                              : AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.full),
                          boxShadow: [
                            BoxShadow(
                              color: (_isEditing
                                      ? AppColors.success
                                      : AppColors.primary)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8, offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(
                            _isEditing
                                ? Icons.check_rounded
                                : Icons.edit_rounded,
                            size: 15, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            _isEditing ? 'Enregistrer' : 'Modifier',
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Profile card ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(children: [
                    Stack(children: [
                      cook?.avatar != null
                          ? CachedNetworkImage(
                              imageUrl: cook!.avatar,
                              imageBuilder: (_, img) => CircleAvatar(
                                  radius: 36, backgroundImage: img),
                              placeholder: (_, __) =>
                                  _avatarPlaceholder(cook.name, 36),
                              errorWidget: (_, __, ___) =>
                                  _avatarPlaceholder(cook.name, 36),
                            )
                          : _avatarPlaceholder(
                              user?.name ?? '', 36),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: colors.card, width: 2)),
                          child: const Icon(Icons.camera_alt_rounded,
                              size: 11, color: Colors.white),
                        ),
                      ),
                    ]),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cook?.name ?? user?.name ?? 'Chef',
                            style: AppTypography.h4
                                .copyWith(color: colors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(cook?.title ?? 'Chef Maison',
                            style: AppTypography.bodyMd
                                .copyWith(color: colors.textSecondary)),
                          const SizedBox(height: AppSpacing.sm),
                          Row(children: [
                            if (cook?.verified == true) ...[
                              _badge(Icons.verified_rounded,
                                  'Vérifié', AppColors.success),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            if (cook?.certified == true)
                              _badge(Icons.workspace_premium_rounded,
                                  'Certifié', AppColors.warning),
                          ]),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Stats row ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(children: [
                  Expanded(child: _buildStatCard(
                    Icons.star_rounded, '${cook?.rating ?? 0}',
                    'Note', AppColors.warning, colors)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _buildStatCard(
                    Icons.rate_review_rounded, '${cook?.reviewCount ?? 0}',
                    'Avis', AppColors.info, colors)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _buildStatCard(
                    Icons.restaurant_rounded, '${cook?.mealsServed ?? 0}',
                    'Repas', AppColors.secondary, colors)),
                ]),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Availability ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: (_isAvailable
                                    ? AppColors.success
                                    : colors.textSecondary)
                                .withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.wifi_tethering_rounded,
                            size: 18,
                            color: _isAvailable
                                ? AppColors.success
                                : colors.textSecondary),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Disponibilité',
                              style: AppTypography.bodyMd.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600)),
                            Text(
                              _isAvailable
                                  ? 'Visible par les clients'
                                  : 'Masqué des clients',
                              style: AppTypography.bodySm
                                  .copyWith(color: colors.textSecondary)),
                          ],
                        ),
                      ]),
                      Switch(
                        value: _isAvailable,
                        onChanged: (v) => setState(() => _isAvailable = v),
                        activeColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Info section ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: const Icon(Icons.person_rounded,
                              size: 15, color: AppColors.primary),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text('Informations',
                          style: AppTypography.h4
                              .copyWith(color: colors.textPrimary)),
                      ]),
                      const SizedBox(height: AppSpacing.lg),
                      if (_isEditing) ...[
                        TextInputField(
                          label: 'Nom',
                          placeholder: 'Votre nom',
                          controller: _nameController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Titre',
                          placeholder: 'Ex: Chef Maison • Cuisine Tunisienne',
                          controller: _titleController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Bio',
                          placeholder: 'Décrivez-vous...',
                          controller: _bioController,
                          multiline: true,
                          numberOfLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Téléphone',
                          placeholder: '+216 XX XXX XXX',
                          controller: _phoneController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Adresse',
                          placeholder: 'Votre adresse',
                          controller: _addressController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Rayon de livraison (km)',
                          placeholder: '5',
                          controller: _deliveryRadiusController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextInputField(
                          label: 'Spécialités (séparées par des virgules)',
                          placeholder: 'Ex: Couscous, Tajines, Pastilla',
                          controller: _specialtiesController,
                        ),
                      ] else ...[
                        if (cook?.bio?.isNotEmpty == true) ...[
                          _buildInfoRow(Icons.notes_rounded, 'Bio',
                              cook!.bio, colors),
                          const Divider(height: AppSpacing.xl),
                        ],
                        if (cook?.phone?.isNotEmpty == true) ...[
                          _buildInfoRow(Icons.phone_rounded, 'Téléphone',
                              cook!.phone, colors),
                          const Divider(height: AppSpacing.xl),
                        ],
                        if (cook?.address?.isNotEmpty == true) ...[
                          _buildInfoRow(Icons.location_on_rounded, 'Adresse',
                              cook!.address, colors),
                          const Divider(height: AppSpacing.xl),
                        ],
                        _buildInfoRow(
                          Icons.local_shipping_rounded,
                          'Rayon de livraison',
                          '${cook?.deliveryRadius ?? 0} km',
                          colors),
                        if (cook?.specialties?.isNotEmpty == true) ...[
                          const Divider(height: AppSpacing.xl),
                          Row(children: [
                            const Icon(Icons.local_fire_department_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Spécialités',
                              style: AppTypography.bodyMd.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: cook!.specialties.map((s) =>
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.full),
                                ),
                                child: Text(s,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ).toList(),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Settings ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(children: [
                  // Theme toggle
                  GestureDetector(
                    onTap: () {
                      final tp = Provider.of<ThemeProvider>(context,
                          listen: false);
                      tp.setThemeMode(tp.isDarkMode(context)
                          ? AppThemeMode.light
                          : AppThemeMode.dark);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: Icon(
                            themeProvider.isDarkMode(context)
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            size: 18, color: AppColors.info),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            themeProvider.isDarkMode(context)
                                ? 'Mode clair'
                                : 'Mode sombre',
                            style: AppTypography.bodyLg.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600)),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: colors.textSecondary),
                      ]),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Logout
                  GestureDetector(
                    onTap: () {
                      final ap = Provider.of<AppProvider>(context,
                          listen: false);
                      ap.setUser(null);
                      ap.setCook(null);
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.06),
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded,
                              size: 18, color: AppColors.error),
                          const SizedBox(width: AppSpacing.md),
                          Text('Se déconnecter',
                            style: AppTypography.bodyLg.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _avatarPlaceholder(String name, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppTypography.h2.copyWith(color: AppColors.primary)),
    );
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(label,
          style: AppTypography.bodyXs.copyWith(
            color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label,
      Color iconColor, AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(value,
          style: AppTypography.h4.copyWith(
            color: colors.textPrimary, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label,
          style: AppTypography.bodyXs
              .copyWith(color: colors.textSecondary)),
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      AppThemeColors colors) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: colors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Icon(icon, size: 15, color: colors.textSecondary),
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
            style: AppTypography.bodySm
                .copyWith(color: colors.textSecondary)),
          Text(value,
            style: AppTypography.bodyMd
                .copyWith(color: colors.textPrimary)),
        ]),
      ),
    ]);
  }
}

