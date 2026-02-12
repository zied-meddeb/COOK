import '../models/models.dart';

// Mock data
final List<Dish> mockDishes = [
  const Dish(
    id: '1',
    name: "Grandma's Beef Lasagna",
    description: 'Layers of homemade pasta, slow-cooked Bolognese sauce with premium beef, and creamy béchamel',
    price: 12.50,
    rating: 4.9,
    reviewCount: 124,
    distance: 0.8,
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1ZXMlPXDMpy0WmI7c6HVWjTl5b2nxZAaM4gDmkdPxv7hWWHC02ysS8j-Q2y0TStOFRWhGXLvlvFge_kdSIjmW1UnbB95JAQwcZWTXmz5dQrNTzHQRStQXDgT7BzMdjX-MBfUklQUQCbtpPECd4C3k1cwqjQqqZ0KPYpjmkBUj9jYNdm4LawqHgcmCnHHXHJK-5LRBzWjkC_1Tayun1HX1E90yHyE8rFdWGSPToZ1m5nx81HTFPyQ36oc3l2R8Tcq5c6Yf88gC8LY',
    cookId: '1',
    cookName: 'Maria G.',
    portions: 2,
    available: true,
    ingredients: ['Beef', 'Tomato', 'Cheese', 'Herbs', 'Wheat'],
    allergens: ['gluten', 'dairy', 'eggs'],
  ),
  const Dish(
    id: '2',
    name: 'Vegan Lentil Curry',
    description: 'Spicy vegan lentil curry with herbs',
    price: 9.50,
    rating: 4.7,
    reviewCount: 45,
    distance: 1.2,
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuw4Gfg48IPOOQwE6PDd4ZkmHeJPH3jP-W1gA3t4a-oyn9izYJPclMaaACaeUsJLPVDLDgErbzqco3tyCLKl4_6EMEHjTfdv_piE3MGVdDkjpIMdD2k08PRGCWRFVeoXWZL9AYRDRQbcxFxAWntzikQDtNsmDLVSibzQmXmzzME1TGwYnxbH_a9o-O_kAL8MaMRQKKSN2MTlBwD-yOsOfvft_ejVblnOjAMFbonPxpzRrCMwCQin2wtDH_SFFkP8iTGfhwBvmz4UE',
    cookId: '2',
    cookName: 'Chef Ahmed',
    portions: 1,
    available: false,
    ingredients: ['Lentils', 'Spices', 'Coconut Milk'],
    allergens: [],
  ),
  const Dish(
    id: '3',
    name: 'Homemade Chicken Dumplings',
    description: 'Handmade chinese dumplings on a plate',
    price: 8.00,
    rating: 5.0,
    reviewCount: 12,
    distance: 0.3,
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAWEkwTljH5n3kOf60cgpE_-Rp8Q8M6ejIdPN5mwXwhcygX4nuZ2qrNM_RMTt7_cmU0inltS4ebay4gTYJ226fvzpDPEFQpM5EAMGKMKiPg9rRTXJQ-zH9eQA_z7nfzAspD72zJ9RHQ7wQDV9GW7dKtzWcgX5jRxnDXkYO2OYfcUFnBoGbiM9Z0CoszdSzQCpLSjcvoywuV2VugAiTN1LqKnllxeUhD7DMz1eWXIrWbhmhtYsQ_XqQlXdt6uQ2VEY4VALDrhnEkPlI',
    cookId: '3',
    cookName: 'Grandma Lina',
    portions: 12,
    available: true,
    ingredients: ['Chicken', 'Wheat', 'Eggs', 'Vegetables'],
    allergens: ['gluten', 'eggs'],
  ),
];

final List<Cook> mockCooks = [
  const Cook(
    id: '1',
    name: 'Maria Romano',
    title: 'Home Chef • Italian Cuisine',
    rating: 4.9,
    reviewCount: 124,
    yearsExperience: 15,
    mealsServed: 250,
    certified: true,
    bio: 'Cooking has always been my love language. I specialize in traditional Sicilian recipes passed down from my Nonna.',
    avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBUgrJ4fNcseZVeWELrOfeIli81doi76V-Annr-AMhgylUpCN6_9sgUGX1hlfa_4OyWlh2S88kxrYz5prFlyzbHt3IayZ-4qefbs2uAD3_gPwlqBJjWTB0vg6Wb97XkhKoWigu_mHRFkRY6xI9MC-59AGt8lETw5x_71KkzEEGI_6SFX1wVHmwEhCGCRHOpOV5gpKfa6HItX0vZdYdPQ6479HFPqjNXcogIVbmEEZCjb1Tuvt0wsci0ZcrUkukQTSJFa4TrZxPUoAw',
    banner: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDp3rKU3NYeynZQI01sjc5YIzqI9uNxUmBZixBLLTIWmZSUWtRolKZ-zAr6YTGUrk6qYWh0I66cICdt5lhpUuIEf_34X8BuLLYLoLO7xnA7C0hUS-EH6QwkuiKsDPLaymiK63irkkwV_68v4CrQ-wN-GMQ79SnQ3rWkrI2x2S9aXVDMxbcwdN-jW8xwo7p13Ecv_0UnBk_FH8p3T30ESYrrhPRHzt1E_Dwgzyoww3pOVBSVm9hqNuzx3o8KJxn64dl-6K_kyUQdaQM',
    distance: 0.5,
    deliveryRadius: 3,
    prepTime: '45 min',
    verified: true,
    topSeller: true,
  ),
  const Cook(
    id: '2',
    name: 'Chef Ahmed',
    title: 'Professional Chef • Modern Fusion',
    rating: 4.5,
    reviewCount: 12,
    yearsExperience: 3,
    mealsServed: 45,
    certified: false,
    bio: 'New to the platform but passionate about creating innovative fusion dishes.',
    avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDHC3ghXWIGKo7HyvRjb3zb1IHSQqYeTMXpuh6QEdvu8RH5jfGsDIcyM4EOChJc8qNOpiKB_OfFxiwQf0rZ8hp9GmSanQZyRw9VzpEEFN1DLsfMuvzCmsERI3pTBLgLFsVBuz8rDr17JdTULdcSnh98BruFnYq-57iWaVn4oFUGXAGu4cIHFt14KraKLHG0ew5tCypNqSgC_d5OiW4uVQgSJRYdmrUIh7g2fg9t5eNLoNDHXHYmqFQGTmo5Od7swJfLTUDhbNf9HMY',
    banner: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIk3EqnRglsAMpxK3F-_1wBVEpy65PRY63XGt0OxuSql-IAEoRaOYfLEnTQbT7D22378GRg6VNxj8jUhIUC-_fIkAMrAf4tJNJHQ8NpEWx5kulCWH_WVYQC2x89UhV34bkLMudo-ivpNDJrfAWFn8Yis64UNC90whMkbBjSXIzWISVDs5qX7gZRoqqu54TbACvCRiBzwQY1xojERe5fAZew3nlg26pTV0zUQFK106755NWTqxFWnjxfB0HPGqg9VDnb4XWS9osL4Y',
    distance: 1.2,
    deliveryRadius: 5,
    prepTime: '30 min',
    verified: false,
    topSeller: false,
  ),
  const Cook(
    id: '3',
    name: 'Grandma Lina',
    title: 'Home Cook • Italian Classics',
    rating: 4.8,
    reviewCount: 84,
    yearsExperience: 20,
    mealsServed: 200,
    certified: true,
    bio: 'Traditional Italian recipes made with love and the finest ingredients.',
    avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC23lOscpU5xf8eAFozOIPjY_MjJZEfI7gPrRGEe9ZhO0PRqiS5i25PEBQc92Kg0XHxhJO1vlhEDt8jlpBi2E2wHoUIQEKxqJBIlSDfw0hlBO6ZaCQgVjfsvwS2nGqHEy-wf7-tJbRBGru6FpVHQYkc4d86-6iUbsfxoJ2r4KT0Rlo29OdjsJv2ezwo8SpPUhine5JwcT9yerwTC9MArijyyvfnbo5i2C6p4_YjAAMTjcLuq-ZxEQQRWi1C6NY2G2enPR_6DogENHw',
    banner: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDp3rKU3NYeynZQI01sjc5YIzqI9uNxUmBZixBLLTIWmZSUWtRolKZ-zAr6YTGUrk6qYWh0I66cICdt5lhpUuIEf_34X8BuLLYLoLO7xnA7C0hUS-EH6QwkuiKsDPLaymiK63irkkwV_68v4CrQ-wN-GMQ79SnQ3rWkrI2x2S9aXVDMxbcwdN-jW8xwo7p13Ecv_0UnBk_FH8p3T30ESYrrhPRHzt1E_Dwgzyoww3pOVBSVm9hqNuzx3o8KJxn64dl-6K_kyUQdaQM',
    distance: 0.8,
    deliveryRadius: 4,
    prepTime: '50 min',
    verified: true,
    topSeller: false,
  ),
];

final List<Order> mockOrders = [
  Order(
    id: '1',
    status: 'out_for_delivery',
    estimatedArrival: '12:45 PM',
    eta: 15,
    dishes: const [
      OrderItem(id: '1', name: "Grandma's Lasagna", quantity: 1, price: 12.50),
    ],
    total: 19.50,
    driverId: '1',
    driverName: 'Michael B.',
    driverRating: 4.9,
    driverAvatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBbwT7Xkzq0TiquHAbMHumld60BHA12LMY9DwHD1uqwtdJrHSXph2iozELKeNKPB8fNFKaCtCq13qP5xZOfo-TKTTliyyDUR0COkgwc6gliHINxNSgfwE-WHX25nEwisbsCqLhcyqM4hMC9AkvlpvislmfF0sVbLhZidxbAgg6mzHpLWwR1zVLB9b2oDZxuBTGSGsYHSNl_Ls78znAKpwScpudI5u-2PrwkLgs9QmI9wLq7QD9i5UfhQWYOxP5p0HmTp_yfXAjc-yU',
    cookId: '1',
    cookName: 'Sarah Jenkins',
    timeline: const [
      TimelineStep(step: 'delivered', label: 'Delivered', timestamp: null),
      TimelineStep(step: 'out_for_delivery', label: 'Out for Delivery', timestamp: '12:30 PM', active: true),
      TimelineStep(step: 'ready', label: 'Ready', timestamp: '12:15 PM'),
      TimelineStep(step: 'preparing', label: 'Preparing', timestamp: '11:55 AM'),
      TimelineStep(step: 'received', label: 'Order Received', timestamp: '11:50 AM'),
    ],
  ),
];

final List<Review> mockReviews = [
  const Review(
    id: '1',
    authorName: 'John Doe',
    authorAvatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBPhxqQsWCNEsnjAoyd3HqAoqHZOKXnuTXiB3eNedz6lekGJgqbFbuevbQMwWeeSH5gLEZCsjg1v6JfOAO8jJ-g067_Ko9m8awlrOX9wiiM5I21EOeAzIza3xQLSTsjP2CNX6HlUm0j30L3reLfQh9PXhZPxBDCEPBrUYTzMauz1-W_9VjW4VakxWidexg7oZGW11ob1a4mNdBFHETVcGA_ohizIS8vebfOa0G6VO7qZgmPpAYuJ-9opNLc20EMZQC4KKLg6CwkgrE',
    rating: 5,
    text: "Absolutely delicious! Reminded me of my grandmother's cooking. The portion was generous too.",
    timestamp: '2 days ago',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA82fg_5Dgox7QWhDwqGBsZDh6qN6FCR1C6O_cctmCF_U6iHrRPhenLzPjbaFwfmzWwknykDQ2M_n3TMiI4bTHNM32anWhs8HRmDsyISYcY8djuEWTABLJ5Y-2zEMEl_MH01u2nD7CUNCk3FMUJXmuTKsBrF-d5UFB5RmJ0FAfDS8IMO1HyGfGZuml-DY5l1LcKTFMhvd0AHcpK7x_Und8fB7mE4TDUxRzXMkYj0eOsrO1aFcgdT5TWBdHyzNKD3YURZqUYOjT1GTA',
  ),
];

// Mock API class
class MockApi {
  Future<List<Dish>> fetchDishes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockDishes;
  }

  Future<Dish?> fetchDish(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockDishes.firstWhere((d) => d.id == id, orElse: () => mockDishes.first);
  }

  Future<List<Cook>> fetchCooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockCooks;
  }

  Future<Cook?> fetchCook(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockCooks.firstWhere((c) => c.id == id, orElse: () => mockCooks.first);
  }

  Future<List<Order>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockOrders;
  }

  Future<Order?> fetchOrder(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockOrders.firstWhere((o) => o.id == id, orElse: () => mockOrders.first);
  }

  Future<List<Review>> fetchReviews(String dishId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockReviews;
  }
}

final mockApi = MockApi();
