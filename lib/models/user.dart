enum UserRole { client, cook }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;
  final List<String> favoriteDishIds;
  final List<String> followedCookIds;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.favoriteDishIds = const [],
    this.followedCookIds = const [],
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? avatar,
    List<String>? favoriteDishIds,
    List<String>? followedCookIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      favoriteDishIds: favoriteDishIds ?? this.favoriteDishIds,
      followedCookIds: followedCookIds ?? this.followedCookIds,
    );
  }

  bool isDishFavorite(String dishId) => favoriteDishIds.contains(dishId);
  bool isFollowingCook(String cookId) => followedCookIds.contains(cookId);
}
