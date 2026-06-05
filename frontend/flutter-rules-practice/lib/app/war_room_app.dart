import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/incidents/data/incident_api_service.dart';
import '../features/incidents/presentation/state/incident_dashboard_notifier.dart';
import 'router.dart';

/// Root widget of the Flutter incident dashboard.
///
/// This widget wires the application-level dependencies:
/// - [IncidentApiService] for HTTP access to the Java backend.
/// - [IncidentDashboardNotifier] for dashboard state orchestration.
/// - [MaterialApp.router] for declarative navigation.
///
/// The backend remains the source of truth. Flutter only displays state and
/// sends user intent through the API service.
class WarRoomApp extends StatelessWidget {
  const WarRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentApiService = IncidentApiService();

    return MultiProvider(
      providers: [
        Provider<IncidentApiService>.value(value: incidentApiService),
        ChangeNotifierProvider<IncidentDashboardNotifier>(
          create: (_) => IncidentDashboardNotifier(incidentApiService)
            ..loadDashboard(),
        ),
      ],
      child: MaterialApp.router(
        title: 'War Room Rules Practice',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}