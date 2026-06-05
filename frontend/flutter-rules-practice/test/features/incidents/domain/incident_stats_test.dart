import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_stats.dart';

void main() {
  group('IncidentStats', () {
    test('should parse stats from JSON', () {
      final stats = IncidentStats.fromJson({
        'total': 3,
        'open': 2,
        'investigating': 1,
        'resolved': 0,
        'low': 0,
        'medium': 1,
        'high': 1,
        'critical': 1,
      });

      expect(stats.total, 3);
      expect(stats.open, 2);
      expect(stats.investigating, 1);
      expect(stats.resolved, 0);
      expect(stats.low, 0);
      expect(stats.medium, 1);
      expect(stats.high, 1);
      expect(stats.critical, 1);
    });
  });
}