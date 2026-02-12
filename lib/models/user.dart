enum UserRole { client, cook }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
    );
  }
}
