import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/incidents/data/incident_api_service.dart';
import '../features/incidents/presentation/pages/incident_dashboard_page.dart';
import '../features/incidents/presentation/pages/incident_details_page.dart';
import '../features/incidents/presentation/state/incident_details_notifier.dart';

/// Centralized application router.
///
/// Routes are declared here instead of being scattered across widgets.
/// This keeps navigation explicit and prepares the app for deep-link-friendly
/// routes such as `/incidents/:id`.
final GoRouter appRouter = GoRouter(
  initialLocation: '/incidents',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, _) => '/incidents',
    ),
    GoRoute(
      path: '/incidents',
      builder: (context, state) => const IncidentDashboardPage(),
    ),
    GoRoute(
      path: '/incidents/:id',
      builder: (context, state) {
        final incidentId = state.pathParameters['id'];

        if (incidentId == null || incidentId.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('Incident id is missing.'),
            ),
          );
        }

        // The details page owns its own notifier because it has its own
        // loading, mutation and notification state.
        return ChangeNotifierProvider(
          create: (context) => IncidentDetailsNotifier(
            incidentApiService: context.read<IncidentApiService>(),
            incidentId: incidentId,
          )..loadIncident(),
          child: const IncidentDetailsPage(),
        );
      },
    ),
  ],
);