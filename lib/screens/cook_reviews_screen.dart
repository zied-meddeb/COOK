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
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final cookId = appProvider.currentCook?.id ?? '';
    final reviews = await mockApi.fetchCookReviews(cookId);
    setState(() {
      _reviews = reviews;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);
    final appProvider = Provider.of<AppProvider>(context);
    final cook = appProvider.currentCook;

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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: colors.border),
                      ),
                      child: const Center(
                        child: Text('←', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Mes Avis',
                      style: AppTypography.h2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Rating Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '${cook?.rating ?? 0}',
                          style: AppTypography.h1.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: List.generate(5, (index) {
                            final rating = cook?.rating ?? 0;
                            return Text(
                              index < rating.round() ? '⭐' : '☆',
                              style: const TextStyle(fontSize: 14),
                            );
                          }),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${cook?.reviewCount ?? 0} avis',
                          style: AppTypography.bodySm.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: Column(
                        children: [
                          _buildRatingBar(5, 0.7, colors),
                          _buildRatingBar(4, 0.2, colors),
                          _buildRatingBar(3, 0.05, colors),
                          _buildRatingBar(2, 0.03, colors),
                          _buildRatingBar(1, 0.02, colors),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Reviews List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _reviews.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('💬', style: TextStyle(fontSize: 48)),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                'Aucun avis pour le moment',
                                style: AppTypography.bodyLg.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) {
                            return _buildReviewCard(_reviews[index], colors);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text(
              '$stars',
              style: AppTypography.bodySm.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: colors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: review.authorAvatar,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 18,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    review.authorName[0],
                    style: AppTypography.bodySm.copyWith(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    review.authorName[0],
                    style: AppTypography.bodySm.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      review.timestamp,
                      style: AppTypography.bodySm.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Text(
                    index < review.rating ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 12),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            review.text,
            style: AppTypography.bodyMd.copyWith(
              color: colors.textPrimary,
            ),
          ),
          if (review.image != null) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: CachedNetworkImage(
                imageUrl: review.image!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 150,
                  color: colors.border,
                ),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

