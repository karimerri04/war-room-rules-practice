import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/filter_incidents.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_filter.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_severity.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_status.dart';

void main() {
  group('filterIncidents', () {
    final incidents = [
      _incident(
        id: 'JAVA-INC-001',
        status: IncidentStatus.open,
        severity: IncidentSeverity.high,
      ),
      _incident(
        id: 'JAVA-INC-002',
        status: IncidentStatus.investigating,
        severity: IncidentSeverity.medium,
      ),
      _incident(
        id: 'JAVA-INC-003',
        status: IncidentStatus.resolved,
        severity: IncidentSeverity.low,
      ),
    ];

    test('should return all incidents when filter is empty', () {
      final result = filterIncidents(
        incidents: incidents,
        filter: const IncidentFilter.empty(),
      );

      expect(result, hasLength(3));
    });

    test('should filter incidents by status', () {
      final result = filterIncidents(
        incidents: incidents,
        filter: const IncidentFilter(status: IncidentStatus.open),
      );

      expect(result, hasLength(1));
      expect(result.first.id, 'JAVA-INC-001');
    });

    test('should filter incidents by severity', () {
      final result = filterIncidents(
        incidents: incidents,
        filter: const IncidentFilter(severity: IncidentSeverity.medium),
      );

      expect(result, hasLength(1));
      expect(result.first.id, 'JAVA-INC-002');
    });

    test('should return empty list when no incident matches filter', () {
      final result = filterIncidents(
        incidents: incidents,
        filter: const IncidentFilter(
          status: IncidentStatus.open,
          severity: IncidentSeverity.critical,
        ),
      );

      expect(result, isEmpty);
    });
  });
}

Incident _incident({
  required String id,
  required IncidentStatus status,
  required IncidentSeverity severity,
}) {
  return Incident(
    id: id,
    title: 'Incident $id',
    description: 'Description for $id',
    status: status,
    severity: severity,
    symptoms: const [],
    rootCause: '',
    resolution: '',
    createdAt: '2026-06-05T15:38:59Z',
    resolvedAt: null,
    notes: const [],
  );
}