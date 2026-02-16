import '../models/models.dart';

// ==================== MOCK DISHES ====================
final List<Dish> mockDishes = [
  // Traditionnel
  const Dish(
    id: '1',
    name: 'Couscous Royal Maison',
    description: 'Un authentique couscous royal avec merguez, agneau, poulet et légumes frais. Recette traditionnelle transmise de génération en génération.',
    price: 14.50,
    rating: 4.9,
    reviewCount: 156,
    distance: 0.8,
    image: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800',
    cookId: '1',
    cookName: 'Fatima B.',
    cookAvatar: 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=200',
    portions: 4,
    available: true,
    ingredients: ['Semoule', 'Agneau', 'Poulet', 'Merguez', 'Pois chiches', 'Légumes', 'Épices'],
    allergens: ['gluten'],
    categoryId: 'traditional',
    prepTime: '45 min',
    deliveryAvailable: true,
    pickupAvailable: true,
  ),
  const Dish(
    id: '2',
    name: 'Lasagnes de Nonna',
    description: 'Lasagnes crémeuses avec sauce bolognaise maison, béchamel onctueuse et parmesan. La vraie recette italienne.',
    price: 12.50,
    rating: 4.8,
    reviewCount: 124,
    distance: 1.2,
    image: 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=800',
    cookId: '2',
    cookName: 'Maria G.',
    cookAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    portions: 2,
    available: true,
    ingredients: ['Pâtes', 'Bœuf', 'Tomate', 'Béchamel', 'Parmesan', 'Herbes'],
    allergens: ['gluten', 'dairy', 'eggs'],
    categoryId: 'european',
    prepTime: '35 min',
  ),
  // Asiatique
  const Dish(
    id: '3',
    name: 'Pad Thai aux Crevettes',
    description: 'Nouilles de riz sautées avec crevettes fraîches, cacahuètes, germes de soja et sauce tamarin maison.',
    price: 11.00,
    rating: 4.7,
    reviewCount: 89,
    distance: 0.5,
    image: 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=800',
    cookId: '3',
    cookName: 'Lin W.',
    cookAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    portions: 6,
    available: true,
    ingredients: ['Nouilles de riz', 'Crevettes', 'Œufs', 'Cacahuètes', 'Tamarin', 'Citron vert'],
    allergens: ['shellfish', 'peanuts', 'eggs'],
    categoryId: 'asian',
    prepTime: '25 min',
  ),
  const Dish(
    id: '4',
    name: 'Dumplings Vapeur',
    description: 'Raviolis chinois faits main, farcis au porc et gingembre, cuits à la vapeur. Servis avec sauce soja.',
    price: 9.50,
    rating: 5.0,
    reviewCount: 67,
    distance: 0.3,
    image: 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=800',
    cookId: '3',
    cookName: 'Lin W.',
    cookAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    portions: 12,
    available: true,
    ingredients: ['Farine', 'Porc', 'Gingembre', 'Ciboulette', 'Sauce soja'],
    allergens: ['gluten', 'soy'],
    categoryId: 'asian',
    prepTime: '20 min',
  ),
  // Vegan
  const Dish(
    id: '5',
    name: 'Buddha Bowl Quinoa',
    description: 'Bowl complet avec quinoa, avocat, pois chiches rôtis, légumes grillés et sauce tahini citronnée.',
    price: 10.50,
    rating: 4.6,
    reviewCount: 45,
    distance: 1.5,
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    cookId: '4',
    cookName: 'Sophie M.',
    cookAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    portions: 3,
    available: true,
    ingredients: ['Quinoa', 'Avocat', 'Pois chiches', 'Légumes', 'Tahini', 'Citron'],
    allergens: ['sesame'],
    categoryId: 'vegan',
    prepTime: '20 min',
  ),
  const Dish(
    id: '6',
    name: 'Curry de Lentilles',
    description: 'Dahl onctueux aux lentilles corail, lait de coco et épices indiennes. Accompagné de riz basmati.',
    price: 9.00,
    rating: 4.7,
    reviewCount: 52,
    distance: 1.0,
    image: 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800',
    cookId: '4',
    cookName: 'Sophie M.',
    cookAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    portions: 5,
    available: false,
    ingredients: ['Lentilles', 'Lait de coco', 'Curcuma', 'Cumin', 'Riz'],
    allergens: [],
    categoryId: 'vegan',
    prepTime: '30 min',
  ),
  // Oriental
  const Dish(
    id: '7',
    name: 'Tajine d\'Agneau',
    description: 'Tajine mijoté à la marocaine avec agneau fondant, pruneaux, amandes et miel. Un voyage culinaire.',
    price: 16.00,
    rating: 4.9,
    reviewCount: 98,
    distance: 2.0,
    image: 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?w=800',
    cookId: '1',
    cookName: 'Fatima B.',
    cookAvatar: 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=200',
    portions: 2,
    available: true,
    ingredients: ['Agneau', 'Pruneaux', 'Amandes', 'Miel', 'Safran', 'Cannelle'],
    allergens: ['nuts'],
    categoryId: 'oriental',
    prepTime: '60 min',
  ),
  const Dish(
    id: '8',
    name: 'Falafels Maison',
    description: 'Boulettes de pois chiches croustillantes avec sauce tahini, salade fraîche et pain pita.',
    price: 8.50,
    rating: 4.5,
    reviewCount: 76,
    distance: 0.7,
    image: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800',
    cookId: '5',
    cookName: 'Ahmed K.',
    cookAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    portions: 8,
    available: true,
    ingredients: ['Pois chiches', 'Persil', 'Coriandre', 'Tahini', 'Pita'],
    allergens: ['gluten', 'sesame'],
    categoryId: 'oriental',
    prepTime: '15 min',
  ),
  // Sucré
  const Dish(
    id: '9',
    name: 'Tiramisu Traditionnel',
    description: 'Le vrai tiramisu italien avec mascarpone crémeux, café espresso et cacao amer.',
    price: 6.50,
    rating: 4.8,
    reviewCount: 134,
    distance: 1.2,
    image: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800',
    cookId: '2',
    cookName: 'Maria G.',
    cookAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    portions: 6,
    available: true,
    ingredients: ['Mascarpone', 'Café', 'Biscuits', 'Cacao', 'Œufs'],
    allergens: ['dairy', 'eggs', 'gluten'],
    categoryId: 'sweet',
    prepTime: '15 min',
  ),
  const Dish(
    id: '10',
    name: 'Crêpes Suzette',
    description: 'Crêpes fines flambées au Grand Marnier avec beurre d\'orange et zeste. Un classique français.',
    price: 8.00,
    rating: 4.6,
    reviewCount: 45,
    distance: 0.9,
    image: 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=800',
    cookId: '6',
    cookName: 'Pierre L.',
    cookAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    portions: 4,
    available: true,
    ingredients: ['Farine', 'Beurre', 'Orange', 'Grand Marnier', 'Sucre'],
    allergens: ['gluten', 'dairy', 'eggs'],
    categoryId: 'sweet',
    prepTime: '20 min',
  ),
  // Healthy
  const Dish(
    id: '11',
    name: 'Saumon Grillé & Quinoa',
    description: 'Pavé de saumon grillé avec quinoa aux légumes, sauce yaourt aux herbes.',
    price: 15.00,
    rating: 4.7,
    reviewCount: 62,
    distance: 1.8,
    image: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
    cookId: '4',
    cookName: 'Sophie M.',
    cookAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    portions: 2,
    available: true,
    ingredients: ['Saumon', 'Quinoa', 'Légumes', 'Yaourt grec', 'Herbes'],
    allergens: ['fish', 'dairy'],
    categoryId: 'healthy',
    prepTime: '25 min',
  ),
  const Dish(
    id: '12',
    name: 'Poke Bowl Thon',
    description: 'Bowl hawaïen avec thon frais, riz vinaigré, avocat, mangue et sauce ponzu.',
    price: 13.50,
    rating: 4.8,
    reviewCount: 89,
    distance: 0.6,
    image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    cookId: '3',
    cookName: 'Lin W.',
    cookAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    portions: 4,
    available: true,
    ingredients: ['Thon', 'Riz', 'Avocat', 'Mangue', 'Edamame', 'Sauce ponzu'],
    allergens: ['fish', 'soy'],
    categoryId: 'healthy',
    prepTime: '15 min',
  ),
];

// ==================== MOCK COOKS ====================
final List<Cook> mockCooks = [
  const Cook(
    id: '1',
    name: 'Fatima Benali',
    title: 'Chef Maison • Cuisine Maghrébine',
    rating: 4.9,
    reviewCount: 254,
    yearsExperience: 20,
    mealsServed: 1250,
    certified: true,
    bio: 'Passionnée de cuisine depuis mon enfance au Maroc. Je partage les recettes traditionnelles de ma grand-mère avec amour et authenticité.',
    avatar: 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
    banner: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
    distance: 0.8,
    deliveryRadius: 5,
    prepTime: '45 min',
    verified: true,
    topSeller: true,
    location: 'Paris 11ème',
    address: '15 Rue Oberkampf, 75011 Paris',
    specialties: ['Couscous', 'Tajines', 'Pastilla', 'Briouates'],
    isAvailable: true,
    minimumOrder: 15.0,
  ),
  const Cook(
    id: '2',
    name: 'Maria Giuliani',
    title: 'Nonna Chef • Cuisine Italienne',
    rating: 4.8,
    reviewCount: 186,
    yearsExperience: 35,
    mealsServed: 890,
    certified: true,
    bio: 'Née à Naples, je cuisine italien depuis toujours. Mes lasagnes et tiramisus sont des recettes familiales que je suis fière de partager.',
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
    banner: 'https://images.unsplash.com/photo-1498579150354-977475b7ea0b?w=800',
    distance: 1.2,
    deliveryRadius: 4,
    prepTime: '35 min',
    verified: true,
    topSeller: true,
    location: 'Paris 9ème',
    address: '8 Rue des Martyrs, 75009 Paris',
    specialties: ['Lasagnes', 'Tiramisu', 'Risotto', 'Gnocchi'],
    isAvailable: true,
    minimumOrder: 12.0,
  ),
  const Cook(
    id: '3',
    name: 'Lin Wei',
    title: 'Chef Créatif • Cuisine Asiatique',
    rating: 4.9,
    reviewCount: 156,
    yearsExperience: 12,
    mealsServed: 620,
    certified: true,
    bio: 'De Shanghai à Paris, je fusionne les saveurs asiatiques traditionnelles avec une touche moderne. Mes dumplings sont faits main chaque jour.',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    banner: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
    distance: 0.5,
    deliveryRadius: 3,
    prepTime: '25 min',
    verified: true,
    topSeller: false,
    location: 'Paris 13ème',
    address: '45 Avenue de Choisy, 75013 Paris',
    specialties: ['Dumplings', 'Pad Thai', 'Poke Bowl', 'Ramen'],
    isAvailable: true,
    minimumOrder: 10.0,
  ),
  const Cook(
    id: '4',
    name: 'Sophie Martin',
    title: 'Coach Nutrition • Healthy Food',
    rating: 4.7,
    reviewCount: 97,
    yearsExperience: 8,
    mealsServed: 450,
    certified: true,
    bio: 'Diététicienne et passionnée de cuisine saine. Je prouve que manger healthy peut être délicieux et gourmand!',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    banner: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    distance: 1.5,
    deliveryRadius: 6,
    prepTime: '20 min',
    verified: true,
    topSeller: false,
    location: 'Paris 16ème',
    address: '22 Avenue Mozart, 75016 Paris',
    specialties: ['Buddha Bowls', 'Smoothies', 'Salades', 'Plats Vegan'],
    isAvailable: true,
    minimumOrder: 8.0,
  ),
  const Cook(
    id: '5',
    name: 'Ahmed Khalil',
    title: 'Chef Traditionnel • Cuisine Libanaise',
    rating: 4.8,
    reviewCount: 134,
    yearsExperience: 15,
    mealsServed: 720,
    certified: false,
    bio: 'Les saveurs du Liban dans votre assiette! Mezze, falafels, shawarma... tout est fait maison avec des ingrédients frais.',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    banner: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800',
    distance: 0.7,
    deliveryRadius: 4,
    prepTime: '30 min',
    verified: true,
    topSeller: true,
    location: 'Paris 10ème',
    address: '56 Rue du Faubourg Saint-Denis, 75010 Paris',
    specialties: ['Falafels', 'Houmous', 'Shawarma', 'Taboulé'],
    isAvailable: true,
    minimumOrder: 10.0,
  ),
  const Cook(
    id: '6',
    name: 'Pierre Lefebvre',
    title: 'Pâtissier Amateur • Desserts Français',
    rating: 4.6,
    reviewCount: 78,
    yearsExperience: 10,
    mealsServed: 340,
    certified: false,
    bio: 'Ex-ingénieur reconverti par passion. Je crée des desserts français classiques avec une précision... d\'ingénieur!',
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    banner: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800',
    distance: 0.9,
    deliveryRadius: 3,
    prepTime: '20 min',
    verified: false,
    topSeller: false,
    location: 'Paris 5ème',
    address: '12 Rue Mouffetard, 75005 Paris',
    specialties: ['Crêpes', 'Tarte Tatin', 'Éclairs', 'Paris-Brest'],
    isAvailable: false,
    minimumOrder: 6.0,
  ),
];

// ==================== MOCK ORDERS ====================
final List<Order> mockOrders = [
  const Order(
    id: '1',
    status: 'out_for_delivery',
    estimatedArrival: '12:45',
    eta: 15,
    dishes: [
      OrderItem(id: '1', name: 'Couscous Royal Maison', quantity: 1, price: 14.50),
      OrderItem(id: '9', name: 'Tiramisu Traditionnel', quantity: 2, price: 6.50),
    ],
    total: 30.50,
    driverId: '1',
    driverName: 'Michael B.',
    driverRating: 4.9,
    driverAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    cookId: '1',
    cookName: 'Fatima Benali',
    timeline: [
      TimelineStep(step: 'delivered', label: 'Livré', timestamp: null),
      TimelineStep(step: 'out_for_delivery', label: 'En livraison', timestamp: '12:30', active: true),
      TimelineStep(step: 'ready', label: 'Prêt', timestamp: '12:15'),
      TimelineStep(step: 'preparing', label: 'En préparation', timestamp: '11:55'),
      TimelineStep(step: 'received', label: 'Commande reçue', timestamp: '11:50'),
    ],
  ),
  const Order(
    id: '2',
    status: 'preparing',
    estimatedArrival: '13:30',
    eta: 45,
    dishes: [
      OrderItem(id: '3', name: 'Pad Thai aux Crevettes', quantity: 2, price: 11.00),
    ],
    total: 25.00,
    driverId: '',
    driverName: '',
    driverRating: 0,
    driverAvatar: '',
    cookId: '3',
    cookName: 'Lin Wei',
    timeline: [
      TimelineStep(step: 'delivered', label: 'Livré', timestamp: null),
      TimelineStep(step: 'out_for_delivery', label: 'En livraison', timestamp: null),
      TimelineStep(step: 'ready', label: 'Prêt', timestamp: null),
      TimelineStep(step: 'preparing', label: 'En préparation', timestamp: '12:45', active: true),
      TimelineStep(step: 'received', label: 'Commande reçue', timestamp: '12:40'),
    ],
  ),
  const Order(
    id: '3',
    status: 'delivered',
    estimatedArrival: '10:00',
    eta: 0,
    dishes: [
      OrderItem(id: '5', name: 'Buddha Bowl Quinoa', quantity: 1, price: 10.50),
      OrderItem(id: '11', name: 'Saumon Grillé & Quinoa', quantity: 1, price: 15.00),
    ],
    total: 28.50,
    driverId: '2',
    driverName: 'Sarah D.',
    driverRating: 4.8,
    driverAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    cookId: '4',
    cookName: 'Sophie Martin',
    timeline: [
      TimelineStep(step: 'delivered', label: 'Livré', timestamp: '10:00', active: true),
      TimelineStep(step: 'out_for_delivery', label: 'En livraison', timestamp: '09:45'),
      TimelineStep(step: 'ready', label: 'Prêt', timestamp: '09:30'),
      TimelineStep(step: 'preparing', label: 'En préparation', timestamp: '09:10'),
      TimelineStep(step: 'received', label: 'Commande reçue', timestamp: '09:00'),
    ],
  ),
];

// ==================== MOCK REVIEWS ====================
final List<Review> mockReviews = [
  const Review(
    id: '1',
    authorName: 'Jean-Pierre M.',
    authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    rating: 5,
    text: 'Absolument délicieux! Le couscous était comme celui de ma grand-mère. Portions généreuses et livraison rapide. Je recommande vivement!',
    timestamp: 'Il y a 2 jours',
    image: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400',
  ),
  const Review(
    id: '2',
    authorName: 'Marie L.',
    authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    rating: 5,
    text: "Les lasagnes de Maria sont incroyables. On sent vraiment l'amour dans la préparation. Ma nouvelle adresse préférée!",
    timestamp: 'Il y a 3 jours',
  ),
  const Review(
    id: '3',
    authorName: 'Thomas B.',
    authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    rating: 4,
    text: "Très bon pad thai, bien épicé comme je l'aime. Juste un peu long pour la livraison mais ça vaut le coup d'attendre.",
    timestamp: 'Il y a 5 jours',
    image: 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=400',
  ),
  const Review(
    id: '4',
    authorName: 'Sophie D.',
    authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    rating: 5,
    text: 'Le Buddha Bowl était frais et savoureux. Parfait pour un déjeuner healthy! La sauce tahini est à tomber.',
    timestamp: 'Il y a 1 semaine',
  ),
  const Review(
    id: '5',
    authorName: 'Ahmed R.',
    authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    rating: 5,
    text: "Meilleur tajine que j'ai mangé hors du Maroc. Fatima est une vraie artiste de la cuisine!",
    timestamp: 'Il y a 1 semaine',
    image: 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?w=400',
  ),
];

// ==================== MOCK API CLASS ====================
class MockApi {
  // Dishes
  Future<List<Dish>> fetchDishes({String? categoryId, String? cookId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var dishes = mockDishes;
    if (categoryId != null) {
      dishes = dishes.where((d) => d.categoryId == categoryId).toList();
    }
    if (cookId != null) {
      dishes = dishes.where((d) => d.cookId == cookId).toList();
    }
    return dishes;
  }

  Future<Dish?> fetchDish(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockDishes.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Dish>> searchDishes(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowercaseQuery = query.toLowerCase();
    return mockDishes.where((dish) {
      return dish.name.toLowerCase().contains(lowercaseQuery) ||
          dish.description.toLowerCase().contains(lowercaseQuery) ||
          dish.ingredients.any((i) => i.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<List<Dish>> fetchPopularDishes() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<Dish>.from(mockDishes)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(6).toList();
  }

  Future<List<Dish>> fetchRecentDishes() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockDishes.where((d) => d.available).take(4).toList();
  }

  // Cooks
  Future<List<Cook>> fetchCooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockCooks;
  }

  Future<Cook?> fetchCook(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockCooks.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Cook>> fetchPopularCooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockCooks.where((c) => c.topSeller).toList();
  }

  Future<List<Cook>> fetchNearbyCooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<Cook>.from(mockCooks)
      ..sort((a, b) => a.distance.compareTo(b.distance));
    return sorted.take(4).toList();
  }

  // Orders
  Future<List<Order>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockOrders;
  }

  Future<Order?> fetchOrder(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockOrders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Order>> fetchActiveOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockOrders.where((o) => o.status != 'delivered').toList();
  }

  Future<List<Order>> fetchOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockOrders.where((o) => o.status == 'delivered').toList();
  }

  // Reviews
  Future<List<Review>> fetchReviews(String? dishId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockReviews;
  }

  Future<List<Review>> fetchCookReviews(String cookId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockReviews.take(3).toList();
  }

  // Categories
  Future<List<FoodCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return FoodCategory.categories;
  }
}

final mockApi = MockApi();
