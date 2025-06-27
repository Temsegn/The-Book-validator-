class User {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.isAdmin = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}
