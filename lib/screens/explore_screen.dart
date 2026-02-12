import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../api/mock_api.dart';
import '../widgets/widgets.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'Explore',
          style: AppTypography.h2.copyWith(color: colors.textPrimary),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 0.65,
        ),
        itemCount: mockDishes.length,
        itemBuilder: (context, index) {
          final dish = mockDishes[index];
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
      ),
    );
  }
}
