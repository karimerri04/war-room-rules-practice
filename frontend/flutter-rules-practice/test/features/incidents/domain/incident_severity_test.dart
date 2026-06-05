import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_severity.dart';

void main() {
  group('IncidentSeverity', () {
    test('should parse LOW from JSON', () {
      expect(IncidentSeverity.fromJson('LOW'), IncidentSeverity.low);
    });

    test('should parse MEDIUM from JSON', () {
      expect(IncidentSeverity.fromJson('MEDIUM'), IncidentSeverity.medium);
    });

    test('should parse HIGH from JSON', () {
      expect(IncidentSeverity.fromJson('HIGH'), IncidentSeverity.high);
    });

    test('should parse CRITICAL from JSON', () {
      expect(IncidentSeverity.fromJson('CRITICAL'), IncidentSeverity.critical);
    });

    test('should serialize severity to backend format', () {
      expect(IncidentSeverity.low.toJson(), 'LOW');
      expect(IncidentSeverity.medium.toJson(), 'MEDIUM');
      expect(IncidentSeverity.high.toJson(), 'HIGH');
      expect(IncidentSeverity.critical.toJson(), 'CRITICAL');
    });

    test('should expose user-facing labels', () {
      expect(IncidentSeverity.low.label, 'Low');
      expect(IncidentSeverity.medium.label, 'Medium');
      expect(IncidentSeverity.high.label, 'High');
      expect(IncidentSeverity.critical.label, 'Critical');
    });

    test('should throw when severity is unknown', () {
      expect(
            () => IncidentSeverity.fromJson('BLOCKER'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}