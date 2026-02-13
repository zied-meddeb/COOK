class FoodCategory {
  final String id;
  final String name;
  final String icon;
  final String image;
  final int dishCount;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.dishCount,
  });

  static const List<FoodCategory> categories = [
    FoodCategory(
      id: 'salty',
      name: 'Salé',
      icon: '🍖',
      image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
      dishCount: 45,
    ),
    FoodCategory(
      id: 'sweet',
      name: 'Sucré',
      icon: '🍰',
      image: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=400',
      dishCount: 32,
    ),
    FoodCategory(
      id: 'healthy',
      name: 'Healthy',
      icon: '🥗',
      image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
      dishCount: 28,
    ),
    FoodCategory(
      id: 'vegan',
      name: 'Vegan',
      icon: '🌱',
      image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      dishCount: 19,
    ),
    FoodCategory(
      id: 'traditional',
      name: 'Traditionnel',
      icon: '🍲',
      image: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
      dishCount: 56,
    ),
    FoodCategory(
      id: 'oriental',
      name: 'Oriental',
      icon: '🥙',
      image: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400',
      dishCount: 24,
    ),
    FoodCategory(
      id: 'european',
      name: 'Européen',
      icon: '🍝',
      image: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400',
      dishCount: 38,
    ),
    FoodCategory(
      id: 'asian',
      name: 'Asiatique',
      icon: '🍜',
      image: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
      dishCount: 41,
    ),
  ];
}

