class Song {
  final String id;
  final String title;
  final String singer;
  final String lyrics;
  final String audioUrl;
  final DateTime createdAt;
  final bool isVerified;

  Song({
    required this.id,
    required this.title,
    required this.singer,
    required this.lyrics,
    this.audioUrl = '',
    required this.createdAt,
    this.isVerified = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      singer: json['singer'] ?? '',
      lyrics: json['lyrics'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'singer': singer,
      'lyrics': lyrics,
      'audioUrl': audioUrl,
      'isVerified': isVerified,
    };
  }
}
