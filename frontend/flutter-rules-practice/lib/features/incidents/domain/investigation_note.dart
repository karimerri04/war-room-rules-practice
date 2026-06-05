class InvestigationNote {
  final String author;
  final String message;
  final String createdAt;

  const InvestigationNote({
    required this.author,
    required this.message,
    required this.createdAt,
  });

  factory InvestigationNote.fromJson(Map<String, dynamic> json) {
    return InvestigationNote(
      author: json['author'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}