class Report {
  final String id;
  final String type;
  final String contentId;
  final String reason;
  final String description;
  final String reportedBy;
  final String status;
  final DateTime createdAt;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final String? resolution;

  Report({
    required this.id,
    required this.type,
    required this.contentId,
    required this.reason,
    required this.description,
    required this.reportedBy,
    this.status = 'pending',
    required this.createdAt,
    this.resolvedBy,
    this.resolvedAt,
    this.resolution,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? '',
      contentId: json['contentId'] ?? '',
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      reportedBy: json['reportedBy'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      resolvedBy: json['resolvedBy'],
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      resolution: json['resolution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'contentId': contentId,
      'reason': reason,
      'description': description,
      'reportedBy': reportedBy,
      'status': status,
      'resolvedBy': resolvedBy,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolution': resolution,
    };
  }
}
