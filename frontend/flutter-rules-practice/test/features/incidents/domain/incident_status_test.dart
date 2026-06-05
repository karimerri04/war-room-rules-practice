import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_status.dart';

void main() {
  group('IncidentStatus', () {
    test('should parse OPEN from JSON', () {
      expect(IncidentStatus.fromJson('OPEN'), IncidentStatus.open);
    });

    test('should parse INVESTIGATING from JSON', () {
      expect(
        IncidentStatus.fromJson('INVESTIGATING'),
        IncidentStatus.investigating,
      );
    });

    test('should parse RESOLVED from JSON', () {
      expect(IncidentStatus.fromJson('RESOLVED'), IncidentStatus.resolved);
    });

    test('should serialize status to backend format', () {
      expect(IncidentStatus.open.toJson(), 'OPEN');
      expect(IncidentStatus.investigating.toJson(), 'INVESTIGATING');
      expect(IncidentStatus.resolved.toJson(), 'RESOLVED');
    });

    test('should expose user-facing labels', () {
      expect(IncidentStatus.open.label, 'Open');
      expect(IncidentStatus.investigating.label, 'Investigating');
      expect(IncidentStatus.resolved.label, 'Resolved');
    });

    test('should throw when status is unknown', () {
      expect(
            () => IncidentStatus.fromJson('UNKNOWN'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}