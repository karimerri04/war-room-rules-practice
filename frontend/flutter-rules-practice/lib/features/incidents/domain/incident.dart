import 'incident_severity.dart';
import 'incident_status.dart';
import 'investigation_note.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final IncidentStatus status;
  final IncidentSeverity severity;
  final String serviceName;
  final String createdAt;
  final String? resolvedAt;
  final List<InvestigationNote> notes;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.severity,
    required this.serviceName,
    required this.createdAt,
    required this.resolvedAt,
    required this.notes,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    final rawNotes = json['notes'] as List<dynamic>? ?? [];

    return Incident(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: IncidentStatus.fromJson(json['status'] as String),
      severity: IncidentSeverity.fromJson(json['severity'] as String),
      serviceName: json['serviceName'] as String,
      createdAt: json['createdAt'] as String,
      resolvedAt: json['resolvedAt'] as String?,
      notes: rawNotes
          .map((note) => InvestigationNote.fromJson(note as Map<String, dynamic>))
          .toList(),
    );
  }
}