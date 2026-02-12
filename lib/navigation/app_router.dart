import 'package:flutter/material.dart';
import '../screens/screens.dart';
import 'navigators.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
        
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
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
        
      case '/add-dish':
        return MaterialPageRoute(
          builder: (_) => const AddDishScreen(),
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
