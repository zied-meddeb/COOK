import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../api/mock_api.dart';

class CookReviewsScreen extends StatefulWidget {
  const CookReviewsScreen({super.key});

  @override
  State<CookReviewsScreen> createState() => _CookReviewsScreenState();
}

class _CookReviewsScreenState extends State<CookReviewsScreen> {
  List<Review> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final cookId =
        Provider.of<AppProvider>(context, listen: false).currentCook?.id ?? '';
    final reviews = await mockApi.fetchCookReviews(cookId);
    setState(() { _reviews = reviews; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final cook = Provider.of<AppProvider>(context).currentCook;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: colors.border),
                    ),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 20, color: colors.textPrimary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text('Avis clients',
                  style: AppTypography.h3.copyWith(color: colors.textPrimary)),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Rating summary card ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: colors.border),
                ),
                child: Row(children: [
                  // Score block
                  Column(children: [
                    Text('${cook?.rating ?? 0}',
                      style: AppTypography.h1.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w800)),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: List.generate(5, (i) {
                        final r = (cook?.rating ?? 0).round();
                        return Icon(
                          i < r ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 16, color: AppColors.warning);
                      }),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${cook?.reviewCount ?? 0} avis',
                      style: AppTypography.bodySm
                          .copyWith(color: colors.textSecondary)),
                  ]),
                  const SizedBox(width: AppSpacing.xl),
                  // Bar chart
                  Expanded(
                    child: Column(children: [
                      _buildRatingBar(5, 0.70, colors),
                      _buildRatingBar(4, 0.20, colors),
                      _buildRatingBar(3, 0.05, colors),
                      _buildRatingBar(2, 0.03, colors),
                      _buildRatingBar(1, 0.02, colors),
                    ]),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Reviews list ──────────────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : _reviews.isEmpty
                      ? _buildEmpty(colors)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          itemCount: _reviews.length,
                          itemBuilder: (_, i) =>
                              _buildReviewCard(_reviews[i], colors),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(AppThemeColors colors) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: colors.border.withValues(alpha: 0.4),
            shape: BoxShape.circle),
          child: Icon(Icons.rate_review_rounded,
              size: 34, color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Aucun avis pour le moment',
          style: AppTypography.bodyLg.copyWith(color: colors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Text('Les avis de vos clients apparaîtront ici',
          style: AppTypography.bodySm.copyWith(color: colors.textSecondary)),
      ]),
    );
  }

  Widget _buildRatingBar(int stars, double pct, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Text('$stars',
          style: AppTypography.bodySm.copyWith(
            color: colors.textSecondary, fontWeight: FontWeight.w600)),
        const SizedBox(width: 3),
        const Icon(Icons.star_rounded, size: 11, color: AppColors.warning),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: colors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.warning),
              minHeight: 7,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 30,
          child: Text('${(pct * 100).round()}%',
            style: AppTypography.bodyXs.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.right),
        ),
      ]),
    );
  }

  Widget _buildReviewCard(Review review, AppThemeColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CachedNetworkImage(
            imageUrl: review.authorAvatar,
            imageBuilder: (_, img) =>
                CircleAvatar(radius: 20, backgroundImage: img),
            placeholder: (_, __) => _avatarFallback(review.authorName),
            errorWidget: (_, __, ___) => _avatarFallback(review.authorName),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.authorName,
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textPrimary, fontWeight: FontWeight.w600)),
                Row(children: [
                  Icon(Icons.schedule_rounded,
                      size: 11, color: colors.textSecondary),
                  const SizedBox(width: 3),
                  Text(review.timestamp,
                    style: AppTypography.bodySm
                        .copyWith(color: colors.textSecondary)),
                ]),
              ]),
          ),
          // Star badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppBorderRadius.full),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
              const SizedBox(width: 3),
              Text('${review.rating}',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.warning, fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Text(review.text,
          style: AppTypography.bodyMd.copyWith(color: colors.textPrimary)),
        if (review.image != null) ...[
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            child: CachedNetworkImage(
              imageUrl: review.image!,
              height: 150, width: double.infinity, fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(height: 150, color: colors.border),
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _avatarFallback(String name) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppTypography.bodySm.copyWith(
          color: AppColors.primary, fontWeight: FontWeight.w700)),
    );
  }
}
