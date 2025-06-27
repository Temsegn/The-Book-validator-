class Song {
  final String id;
  final String title;
  final String singer;
  final String lyrics;
  final String audioUrl;
  final DateTime createdAt;
  final bool isVerified;
  final String category;
  final List<String> tags;
  final String language;
  final int duration;
  final String submittedBy;
  final String status;
  final double averageRating;
  final List<SongReview> reviews;
  final String? rejectionReason;
  final int viewCount;
  final int playCount;

  Song({
    required this.id,
    required this.title,
    required this.singer,
    required this.lyrics,
    this.audioUrl = '',
    required this.createdAt,
    this.isVerified = false,
    this.category = 'Hymn',
    this.tags = const [],
    this.language = 'English',
    this.duration = 0,
    this.submittedBy = '',
    this.status = 'pending',
    this.averageRating = 0.0,
    this.reviews = const [],
    this.rejectionReason,
    this.viewCount = 0,
    this.playCount = 0,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      singer: json['singer'] ?? '',
      lyrics: json['lyrics'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
      category: json['category'] ?? 'Hymn',
      tags: List<String>.from(json['tags'] ?? []),
      language: json['language'] ?? 'English',
      duration: json['duration'] ?? 0,
      submittedBy: json['submittedBy'] ?? '',
      status: json['status'] ?? 'pending',
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      reviews: (json['reviews'] as List?)
          ?.map((review) => SongReview.fromJson(review))
          .toList() ?? [],
      rejectionReason: json['rejectionReason'],
      viewCount: json['viewCount'] ?? 0,
      playCount: json['playCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'singer': singer,
      'lyrics': lyrics,
      'audioUrl': audioUrl,
      'isVerified': isVerified,
      'category': category,
      'tags': tags,
      'language': language,
      'duration': duration,
      'submittedBy': submittedBy,
      'status': status,
    };
  }

  Song copyWith({
    String? title,
    String? singer,
    String? lyrics,
    String? audioUrl,
    bool? isVerified,
    String? category,
    List<String>? tags,
    String? language,
    int? duration,
    String? status,
    double? averageRating,
    List<SongReview>? reviews,
    String? rejectionReason,
    int? viewCount,
    int? playCount,
  }) {
    return Song(
      id: id,
      title: title ?? this.title,
      singer: singer ?? this.singer,
      lyrics: lyrics ?? this.lyrics,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt,
      isVerified: isVerified ?? this.isVerified,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      language: language ?? this.language,
      duration: duration ?? this.duration,
      submittedBy: submittedBy,
      status: status ?? this.status,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      viewCount: viewCount ?? this.viewCount,
      playCount: playCount ?? this.playCount,
    );
  }
}

class SongReview {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final int rating;
  final DateTime createdAt;

  SongReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory SongReview.fromJson(Map<String, dynamic> json) {
    return SongReview(
      id: json['_id'] ?? json['id'] ?? '',
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
