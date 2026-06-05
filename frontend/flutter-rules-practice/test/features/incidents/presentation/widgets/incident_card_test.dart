import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_severity.dart';
import 'package:flutter_rules_practice/features/incidents/domain/incident_status.dart';
import 'package:flutter_rules_practice/features/incidents/presentation/widgets/incident_card.dart';

void main() {
  group('IncidentCard', () {
    testWidgets('should display polished incident summary', (tester) async {
      final router = _routerWithCard(_incident());

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(find.text('JAVA-INC-001'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      expect(
        find.text('NullPointerException when finding an unknown incident'),
        findsOneWidget,
      );
      expect(
        find.text('The API fails when an unknown incident id is requested.'),
        findsOneWidget,
      );
      expect(find.text('Key symptoms'), findsOneWidget);
      expect(find.text('• HTTP 500 returned instead of 404'), findsOneWidget);
      expect(find.text('• Stack trace shows null access'), findsOneWidget);
      expect(find.text('0 note(s)'), findsOneWidget);
      expect(find.text('Open details'), findsOneWidget);
    });

    testWidgets('should navigate to incident details when tapped', (
        tester,
        ) async {
      final router = _routerWithCard(_incident());

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      await tester.tap(find.byType(IncidentCard));
      await tester.pumpAndSettle();

      expect(find.text('Details page for JAVA-INC-001'), findsOneWidget);
    });
  });
}

GoRouter _routerWithCard(Incident incident) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: IncidentCard(incident: incident),
        ),
      ),
      GoRoute(
        path: '/incidents/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];

          return Scaffold(
            body: Text('Details page for $id'),
          );
        },
      ),
    ],
  );
}

Incident _incident() {
  return const Incident(
    id: 'JAVA-INC-001',
    title: 'NullPointerException when finding an unknown incident',
    description: 'The API fails when an unknown incident id is requested.',
    status: IncidentStatus.open,
    severity: IncidentSeverity.high,
    symptoms: [
      'HTTP 500 returned instead of 404',
      'Stack trace shows null access',
    ],
    rootCause: '',
    resolution: '',
    createdAt: '2026-06-05T15:38:59Z',
    resolvedAt: null,
    notes: [],
  );
}