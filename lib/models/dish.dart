class Dish {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final double distance;
  final String image;
  final String cookId;
  final String cookName;
  final int portions;
  final bool available;
  final List<String> ingredients;
  final List<String> allergens;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.image,
    required this.cookId,
    required this.cookName,
    required this.portions,
    required this.available,
    required this.ingredients,
    required this.allergens,
  });

  Dish copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    int? reviewCount,
    double? distance,
    String? image,
    String? cookId,
    String? cookName,
    int? portions,
    bool? available,
    List<String>? ingredients,
    List<String>? allergens,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distance: distance ?? this.distance,
      image: image ?? this.image,
      cookId: cookId ?? this.cookId,
      cookName: cookName ?? this.cookName,
      portions: portions ?? this.portions,
      available: available ?? this.available,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
    );
  }
}
