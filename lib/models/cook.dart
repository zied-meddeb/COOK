class Cook {
  final String id;
  final String name;
  final String title;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final int mealsServed;
  final bool certified;
  final String bio;
  final String avatar;
  final String banner;
  final double distance;
  final int deliveryRadius;
  final String prepTime;
  final bool verified;
  final bool topSeller;
  final String location;
  final String address;
  final List<String> specialties;
  final bool isAvailable;
  final bool acceptsDelivery;
  final bool acceptsPickup;
  final double minimumOrder;
  final String phone;

  const Cook({
    required this.id,
    required this.name,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.yearsExperience,
    required this.mealsServed,
    required this.certified,
    required this.bio,
    required this.avatar,
    required this.banner,
    required this.distance,
    required this.deliveryRadius,
    required this.prepTime,
    required this.verified,
    required this.topSeller,
    this.location = '',
    this.address = '',
    this.specialties = const [],
    this.isAvailable = true,
    this.acceptsDelivery = true,
    this.acceptsPickup = true,
    this.minimumOrder = 0,
    this.phone = '',
  });

  Cook copyWith({
    String? id,
    String? name,
    String? title,
    double? rating,
    int? reviewCount,
    int? yearsExperience,
    int? mealsServed,
    bool? certified,
    String? bio,
    String? avatar,
    String? banner,
    double? distance,
    int? deliveryRadius,
    String? prepTime,
    bool? verified,
    bool? topSeller,
    String? location,
    String? address,
    List<String>? specialties,
    bool? isAvailable,
    bool? acceptsDelivery,
    bool? acceptsPickup,
    double? minimumOrder,
    String? phone,
  }) {
    return Cook(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      mealsServed: mealsServed ?? this.mealsServed,
      certified: certified ?? this.certified,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
      distance: distance ?? this.distance,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      prepTime: prepTime ?? this.prepTime,
      verified: verified ?? this.verified,
      topSeller: topSeller ?? this.topSeller,
      location: location ?? this.location,
      address: address ?? this.address,
      specialties: specialties ?? this.specialties,
      isAvailable: isAvailable ?? this.isAvailable,
      acceptsDelivery: acceptsDelivery ?? this.acceptsDelivery,
      acceptsPickup: acceptsPickup ?? this.acceptsPickup,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      phone: phone ?? this.phone,
    );
  }
}
