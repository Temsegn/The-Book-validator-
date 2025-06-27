class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final int unitsAvailable;
  final List<Review> reviews;
  final String imageUrl;
  final DateTime createdAt;
  final bool isVerified;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.unitsAvailable,
    required this.reviews,
    this.imageUrl = '',
    required this.createdAt,
    this.isVerified = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      unitsAvailable: json['unitsAvailable'] ?? 0,
      reviews: (json['reviews'] as List?)
          ?.map((review) => Review.fromJson(review))
          .toList() ?? [],
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'unitsAvailable': unitsAvailable,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
    };
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
    };
  }
}
