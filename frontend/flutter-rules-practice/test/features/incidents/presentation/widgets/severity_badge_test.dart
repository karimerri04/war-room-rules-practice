import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_severity.dart';
import 'package:flutter_rules_practice/features/incidents/presentation/widgets/severity_badge.dart';

void main() {
  group('SeverityBadge', () {
    testWidgets('should display Low label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeverityBadge(severity: IncidentSeverity.low),
          ),
        ),
      );

      expect(find.text('Low'), findsOneWidget);
    });

    testWidgets('should display Medium label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeverityBadge(severity: IncidentSeverity.medium),
          ),
        ),
      );

      expect(find.text('Medium'), findsOneWidget);
    });

    testWidgets('should display High label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeverityBadge(severity: IncidentSeverity.high),
          ),
        ),
      );

      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('should display Critical label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeverityBadge(severity: IncidentSeverity.critical),
          ),
        ),
      );

      expect(find.text('Critical'), findsOneWidget);
    });
  });
}