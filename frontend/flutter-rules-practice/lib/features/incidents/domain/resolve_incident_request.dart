class ResolveIncidentRequest {
  final String resolutionSummary;

  const ResolveIncidentRequest({
    required this.resolutionSummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'resolutionSummary': resolutionSummary,
    };
  }
}