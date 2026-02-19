import 'package:flutter/material.dart';
import '../screens/screens.dart';
import '../models/models.dart';
import 'navigators.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const ClientNavigator(),
          settings: settings,
        );
        
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case '/client':
        return MaterialPageRoute(
          builder: (_) => const ClientNavigator(),
          settings: settings,
        );
        
      case '/cook':
        return MaterialPageRoute(
          builder: (_) => const CookNavigator(),
          settings: settings,
        );
        
      case '/explore':
        return MaterialPageRoute(
          builder: (_) => const ExploreScreen(),
          settings: settings,
        );

      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );

      case '/categories':
        return MaterialPageRoute(
          builder: (_) => const CategoriesScreen(),
          settings: settings,
        );

      case '/category':
        final categoryId = settings.arguments as String? ?? 'traditional';
        return MaterialPageRoute(
          builder: (_) => CategoryDetailScreen(categoryId: categoryId),
          settings: settings,
        );

      case '/dish-details':
        final dishId = settings.arguments as String? ?? '1';
        return MaterialPageRoute(
          builder: (_) => DishDetailsScreen(dishId: dishId),
          settings: settings,
        );
        
      case '/cook-profile':
        final cookId = settings.arguments as String? ?? '1';
        return MaterialPageRoute(
          builder: (_) => CookProfileScreen(cookId: cookId),
          settings: settings,
        );
        
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );
        
      case '/order-tracking':
        return MaterialPageRoute(
          builder: (_) => const OrderTrackingScreen(),
          settings: settings,
        );

      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
          settings: settings,
        );

      case '/order-history':
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
          settings: settings,
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const UserProfileScreen(),
          settings: settings,
        );

      case '/add-dish':
        return MaterialPageRoute(
          builder: (_) => const AddDishScreen(),
          settings: settings,
        );

      case '/saved-addresses':
        return MaterialPageRoute(
          builder: (_) => const SavedAddressesScreen(),
          settings: settings,
        );

      case '/favorite-dishes':
        return MaterialPageRoute(
          builder: (_) => const FavoriteDishesScreen(),
          settings: settings,
        );

      case '/followed-cooks':
        return MaterialPageRoute(
          builder: (_) => const FollowedCooksScreen(),
          settings: settings,
        );

      case '/cook-menu':
        return MaterialPageRoute(
          builder: (_) => const CookMenuScreen(),
          settings: settings,
        );

      case '/cook-reviews':
        return MaterialPageRoute(
          builder: (_) => const CookReviewsScreen(),
          settings: settings,
        );

      case '/edit-dish':
        final dish = settings.arguments as Dish;
        return MaterialPageRoute(
          builder: (_) => EditDishScreen(dish: dish),
          settings: settings,
        );

      case '/cook-orders':
        return MaterialPageRoute(
          builder: (_) => const CookOrdersScreen(),
          settings: settings,
        );

      case '/cook-profile-edit':
        return MaterialPageRoute(
          builder: (_) => const CookProfileEditScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
