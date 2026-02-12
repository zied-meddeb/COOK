class CartItem {
  final String id;
  final String dishId;
  final String dishName;
  final int quantity;
  final double price;
  final String cookId;

  const CartItem({
    required this.id,
    required this.dishId,
    required this.dishName,
    required this.quantity,
    required this.price,
    required this.cookId,
  });

  CartItem copyWith({
    String? id,
    String? dishId,
    String? dishName,
    int? quantity,
    double? price,
    String? cookId,
  }) {
    return CartItem(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      dishName: dishName ?? this.dishName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      cookId: cookId ?? this.cookId,
    );
  }
}

class Cart {
  final List<CartItem> items;
  final double subtotal;
  final double serviceFee;
  final double deliveryFee;
  final double total;

  const Cart({
    required this.items,
    required this.subtotal,
    required this.serviceFee,
    required this.deliveryFee,
    required this.total,
  });

  factory Cart.empty() {
    return const Cart(
      items: [],
      subtotal: 0,
      serviceFee: 2.0,
      deliveryFee: 0,
      total: 2.0,
    );
  }

  Cart copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? serviceFee,
    double? deliveryFee,
    double? total,
  }) {
    return Cart(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      serviceFee: serviceFee ?? this.serviceFee,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
    );
  }
}
