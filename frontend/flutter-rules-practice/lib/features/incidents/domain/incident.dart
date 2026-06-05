import 'incident_severity.dart';
import 'incident_status.dart';
import 'investigation_note.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final IncidentStatus status;
  final IncidentSeverity severity;
  final List<String> symptoms;
  final String rootCause;
  final String resolution;
  final String createdAt;
  final String? resolvedAt;
  final List<InvestigationNote> notes;

  /// Incident domain model used by the Flutter frontend.
  ///
  /// This model mirrors the JSON contract returned by the Java backend.
  /// Keep this file aligned with the backend response before changing widgets.
  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.severity,
    required this.symptoms,
    required this.rootCause,
    required this.resolution,
    required this.createdAt,
    required this.resolvedAt,
    required this.notes,
  });

  /// Creates an [Incident] from the backend JSON response.
  ///
  /// Optional backend arrays and text fields are normalized to safe defaults
  /// so widgets do not need to handle missing keys repeatedly.
  factory Incident.fromJson(Map<String, dynamic> json) {
    final rawSymptoms = json['symptoms'] as List<dynamic>? ?? [];
    final rawNotes = json['notes'] as List<dynamic>? ?? [];

    return Incident(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: IncidentStatus.fromJson(json['status'] as String),
      severity: IncidentSeverity.fromJson(json['severity'] as String),
      symptoms: rawSymptoms.map((symptom) => symptom as String).toList(),
      rootCause: json['rootCause'] as String? ?? '',
      resolution: json['resolution'] as String? ?? '',
      createdAt: json['createdAt'] as String,
      resolvedAt: json['resolvedAt'] as String?,
      notes: rawNotes
          .map(
            (note) => InvestigationNote.fromJson(
          note as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}