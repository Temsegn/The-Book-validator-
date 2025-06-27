class Report {
  final String id;
  final String type; // 'book' or 'song'
  final String title;
  final String description;
  final String screenshotUrl;
  final String reporterId;
  final String reporterName;
  final DateTime createdAt;
  final String status; // 'pending', 'reviewed', 'resolved'

  Report({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.screenshotUrl,
    required this.reporterId,
    required this.reporterName,
    required this.createdAt,
    this.status = 'pending',
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      screenshotUrl: json['screenshotUrl'] ?? '',
      reporterId: json['reporterId'] ?? '',
      reporterName: json['reporterName'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'screenshotUrl': screenshotUrl,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'status': status,
    };
  }
}
