import 'package:go_router/go_router.dart';

import '../features/incidents/presentation/pages/incident_dashboard_page.dart';

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
  ],
);