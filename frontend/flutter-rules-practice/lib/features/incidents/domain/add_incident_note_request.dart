class AddIncidentNoteRequest {
  final String author;
  final String message;

  const AddIncidentNoteRequest({
    required this.author,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'message': message,
    };
  }
}