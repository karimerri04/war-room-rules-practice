import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_status.dart';
import 'package:flutter_rules_practice/features/incidents/presentation/widgets/status_badge.dart';

void main() {
  group('StatusBadge', () {
    testWidgets('should display Open label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: IncidentStatus.open),
          ),
        ),
      );

      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('should display Investigating label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: IncidentStatus.investigating),
          ),
        ),
      );

      expect(find.text('Investigating'), findsOneWidget);
    });

    testWidgets('should display Resolved label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: IncidentStatus.resolved),
          ),
        ),
      );

      expect(find.text('Resolved'), findsOneWidget);
    });
  });
}