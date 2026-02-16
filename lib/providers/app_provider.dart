import 'package:flutter/material.dart';
import '../models/models.dart';

class AppProvider extends ChangeNotifier {
  User? _user;
  Cart _cart = Cart.empty();
  bool _isLoading = false;
  List<SavedAddress> _savedAddresses = [];
  final List<String> _favoriteDishIds = [];
  final List<String> _followedCookIds = [];

  User? get user => _user;
  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  List<SavedAddress> get savedAddresses => _savedAddresses;
  List<String> get favoriteDishIds => _favoriteDishIds;
  List<String> get followedCookIds => _followedCookIds;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _updateCartTotals(List<CartItem> items) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
    const serviceFee = 2.0;
    const deliveryFee = 0.0;
    final total = subtotal + serviceFee + deliveryFee;

    _cart = Cart(
      items: items,
      subtotal: subtotal,
      serviceFee: serviceFee,
      deliveryFee: deliveryFee,
      total: total,
    );
    notifyListeners();
  }

  void addToCart(CartItem newItem) {
    final existingIndex = _cart.items.indexWhere((item) => item.dishId == newItem.dishId);

    List<CartItem> updatedItems;
    if (existingIndex != -1) {
      updatedItems = List.from(_cart.items);
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + newItem.quantity,
      );
    } else {
      updatedItems = [..._cart.items, newItem];
    }

    _updateCartTotals(updatedItems);
  }

  void removeFromCart(String itemId) {
    final updatedItems = _cart.items.where((item) => item.id != itemId).toList();
    _updateCartTotals(updatedItems);
  }

  void updateCartItem(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
    } else {
      final updatedItems = _cart.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList();
      _updateCartTotals(updatedItems);
    }
  }

  void clearCart() {
    _cart = Cart.empty();
    notifyListeners();
  }

  // Address management methods
  void addSavedAddress(SavedAddress address) {
    // If this is set as default, remove default from others
    if (address.isDefault) {
      _savedAddresses = _savedAddresses.map((addr) =>
        addr.copyWith(isDefault: false)
      ).toList();
    }
    // If this is the first address, make it default
    final isFirst = _savedAddresses.isEmpty;
    _savedAddresses.add(isFirst ? address.copyWith(isDefault: true) : address);
    notifyListeners();
  }

  void updateSavedAddress(SavedAddress updatedAddress) {
    final index = _savedAddresses.indexWhere((addr) => addr.id == updatedAddress.id);
    if (index != -1) {
      // If setting as default, remove default from others
      if (updatedAddress.isDefault) {
        _savedAddresses = _savedAddresses.map((addr) =>
          addr.copyWith(isDefault: false)
        ).toList();
      }
      _savedAddresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  void deleteSavedAddress(String addressId) {
    final wasDefault = _savedAddresses.any((addr) => addr.id == addressId && addr.isDefault);
    _savedAddresses.removeWhere((addr) => addr.id == addressId);

    // If we deleted the default address, make the first one default
    if (wasDefault && _savedAddresses.isNotEmpty) {
      _savedAddresses[0] = _savedAddresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  void setDefaultAddress(String addressId) {
    _savedAddresses = _savedAddresses.map((addr) =>
      addr.copyWith(isDefault: addr.id == addressId)
    ).toList();
    notifyListeners();
  }

  // Favorites management methods
  bool isDishFavorite(String dishId) {
    return _favoriteDishIds.contains(dishId);
  }

  void toggleFavoriteDish(String dishId) {
    if (_favoriteDishIds.contains(dishId)) {
      _favoriteDishIds.remove(dishId);
    } else {
      _favoriteDishIds.add(dishId);
    }
    notifyListeners();
  }

  void addFavoriteDish(String dishId) {
    if (!_favoriteDishIds.contains(dishId)) {
      _favoriteDishIds.add(dishId);
      notifyListeners();
    }
  }

  void removeFavoriteDish(String dishId) {
    if (_favoriteDishIds.remove(dishId)) {
      notifyListeners();
    }
  }

  // Followed cooks management methods
  bool isFollowingCook(String cookId) {
    return _followedCookIds.contains(cookId);
  }

  void toggleFollowCook(String cookId) {
    if (_followedCookIds.contains(cookId)) {
      _followedCookIds.remove(cookId);
    } else {
      _followedCookIds.add(cookId);
    }
    notifyListeners();
  }

  void followCook(String cookId) {
    if (!_followedCookIds.contains(cookId)) {
      _followedCookIds.add(cookId);
      notifyListeners();
    }
  }

  void unfollowCook(String cookId) {
    if (_followedCookIds.remove(cookId)) {
      notifyListeners();
    }
  }
}
