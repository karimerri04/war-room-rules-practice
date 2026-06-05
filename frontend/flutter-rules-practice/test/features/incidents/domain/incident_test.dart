import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_severity.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_status.dart';

void main() {
  group('Incident', () {
    test('should parse incident from backend JSON', () {
      final incident = Incident.fromJson({
        'id': 'JAVA-INC-001',
        'title': 'NullPointerException when finding an unknown incident',
        'description': 'The API fails when an unknown incident id is requested.',
        'severity': 'HIGH',
        'status': 'OPEN',
        'symptoms': [
          'HTTP 500 returned instead of 404',
          'Stack trace shows null access',
        ],
        'rootCause': '',
        'resolution': '',
        'createdAt': '2026-06-05T15:38:59Z',
        'resolvedAt': null,
        'notes': [],
      });

      expect(incident.id, 'JAVA-INC-001');
      expect(incident.title, contains('NullPointerException'));
      expect(incident.status, IncidentStatus.open);
      expect(incident.severity, IncidentSeverity.high);
      expect(incident.symptoms, hasLength(2));
      expect(incident.rootCause, '');
      expect(incident.resolution, '');
      expect(incident.createdAt, '2026-06-05T15:38:59Z');
      expect(incident.resolvedAt, isNull);
      expect(incident.notes, isEmpty);
    });

    test('should parse incident with notes', () {
      final incident = Incident.fromJson({
        'id': 'JAVA-INC-002',
        'title': 'Mutable incident state',
        'description': 'Incident state is modified directly.',
        'severity': 'MEDIUM',
        'status': 'INVESTIGATING',
        'symptoms': [],
        'rootCause': 'Missing use case orchestration',
        'resolution': '',
        'createdAt': '2026-06-05T15:38:59Z',
        'resolvedAt': null,
        'notes': [
          {
            'author': 'Karim',
            'message': 'Started investigation.',
            'createdAt': '2026-06-05T16:00:00Z',
          }
        ],
      });

      expect(incident.status, IncidentStatus.investigating);
      expect(incident.severity, IncidentSeverity.medium);
      expect(incident.notes, hasLength(1));
      expect(incident.notes.first.author, 'Karim');
      expect(incident.notes.first.message, 'Started investigation.');
    });

    test('should default optional lists and nullable text fields safely', () {
      final incident = Incident.fromJson({
        'id': 'JAVA-INC-003',
        'title': 'Controller contains business logic',
        'description': 'Controller validates domain behavior directly.',
        'severity': 'MEDIUM',
        'status': 'OPEN',
        'createdAt': '2026-06-05T15:38:59Z',
        'resolvedAt': null,
      });

      expect(incident.symptoms, isEmpty);
      expect(incident.notes, isEmpty);
      expect(incident.rootCause, '');
      expect(incident.resolution, '');
    });
  });
}