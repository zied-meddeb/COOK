import 'package:flutter/material.dart';
import '../models/models.dart';

class AppProvider extends ChangeNotifier {
  User? _user;
  Cart _cart = Cart.empty();
  bool _isLoading = false;

  User? get user => _user;
  Cart get cart => _cart;
  bool get isLoading => _isLoading;

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
}
