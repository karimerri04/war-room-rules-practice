import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/incidents/data/incident_api_service.dart';
import '../features/incidents/presentation/pages/incident_dashboard_page.dart';
import '../features/incidents/presentation/pages/incident_details_page.dart';
import '../features/incidents/presentation/state/incident_details_notifier.dart';

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