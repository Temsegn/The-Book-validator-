class User {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final String? profileImage;
  final String? bio;
  final String? location;
  final UserPreferences preferences;
  final List<String> favoriteBooks;
  final List<String> favoriteSongs;
  final int contributionsCount;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;
  final bool emailVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.isAdmin = false,
    this.profileImage,
    this.bio,
    this.location,
    required this.preferences,
    this.favoriteBooks = const [],
    this.favoriteSongs = const [],
    this.contributionsCount = 0,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
    this.emailVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      profileImage: json['profileImage'],
      bio: json['bio'],
      location: json['location'],
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      favoriteBooks: List<String>.from(json['favoriteBooks'] ?? []),
      favoriteSongs: List<String>.from(json['favoriteSongs'] ?? []),
      contributionsCount: json['contributionsCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isActive: json['isActive'] ?? true,
      emailVerified: json['emailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'profileImage': profileImage,
      'bio': bio,
      'location': location,
      'preferences': preferences.toJson(),
      'favoriteBooks': favoriteBooks,
      'favoriteSongs': favoriteSongs,
      'contributionsCount': contributionsCount,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
      'emailVerified': emailVerified,
    };
  }

  User copyWith({
    String? name,
    String? email,
    bool? isAdmin,
    String? profileImage,
    String? bio,
    String? location,
    UserPreferences? preferences,
    List<String>? favoriteBooks,
    List<String>? favoriteSongs,
    int? contributionsCount,
    DateTime? lastLogin,
    bool? isActive,
    bool? emailVerified,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
      favoriteSongs: favoriteSongs ?? this.favoriteSongs,
      contributionsCount: contributionsCount ?? this.contributionsCount,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}

class UserPreferences {
  final String theme;
  final NotificationSettings notifications;
  final String language;

  UserPreferences({
    this.theme = 'system',
    required this.notifications,
    this.language = 'en',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      theme: json['theme'] ?? 'system',
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      language: json['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notifications': notifications.toJson(),
      'language': language,
    };
  }
}

class NotificationSettings {
  final bool email;
  final bool push;

  NotificationSettings({
    this.email = true,
    this.push = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      email: json['email'] ?? true,
      push: json['push'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'push': push,
    };
  }
}
