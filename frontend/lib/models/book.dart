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
  final String category;
  final List<String> tags;
  final String language;
  final int pageCount;
  final String isbn;
  final double averageRating;
  final String submittedBy;
  final String status;
  final String? rejectionReason;
  final int viewCount;
  final int downloadCount;

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
    this.category = 'General',
    this.tags = const [],
    this.language = 'English',
    this.pageCount = 0,
    this.isbn = '',
    this.averageRating = 0.0,
    this.submittedBy = '',
    this.status = 'pending',
    this.rejectionReason,
    this.viewCount = 0,
    this.downloadCount = 0,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] ?? json['id'] ?? '',
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
      category: json['category'] ?? 'General',
      tags: List<String>.from(json['tags'] ?? []),
      language: json['language'] ?? 'English',
      pageCount: json['pageCount'] ?? 0,
      isbn: json['isbn'] ?? '',
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      submittedBy: json['submittedBy'] ?? '',
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejectionReason'],
      viewCount: json['viewCount'] ?? 0,
      downloadCount: json['downloadCount'] ?? 0,
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
      'category': category,
      'tags': tags,
      'language': language,
      'pageCount': pageCount,
      'isbn': isbn,
      'submittedBy': submittedBy,
      'status': status,
    };
  }

  Book copyWith({
    String? title,
    String? author,
    String? description,
    int? unitsAvailable,
    List<Review>? reviews,
    String? imageUrl,
    bool? isVerified,
    String? category,
    List<String>? tags,
    String? language,
    int? pageCount,
    String? isbn,
    double? averageRating,
    String? status,
    String? rejectionReason,
    int? viewCount,
    int? downloadCount,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      unitsAvailable: unitsAvailable ?? this.unitsAvailable,
      reviews: reviews ?? this.reviews,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      isVerified: isVerified ?? this.isVerified,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      language: language ?? this.language,
      pageCount: pageCount ?? this.pageCount,
      isbn: isbn ?? this.isbn,
      averageRating: averageRating ?? this.averageRating,
      submittedBy: submittedBy,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      viewCount: viewCount ?? this.viewCount,
      downloadCount: downloadCount ?? this.downloadCount,
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final int rating;
  final DateTime createdAt;
  final List<String> likes;
  final bool isVerified;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.likes = const [],
    this.isVerified = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: List<String>.from(json['likes'] ?? []),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'likes': likes,
      'isVerified': isVerified,
    };
  }
}
