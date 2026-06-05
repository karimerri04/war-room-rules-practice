import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/incident_dashboard_notifier.dart';
import '../widgets/incident_card.dart';
import '../widgets/incident_stats_cards.dart';

class IncidentDashboardPage extends StatelessWidget {
  const IncidentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<IncidentDashboardNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('War Room Incident Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh dashboard',
            onPressed: notifier.loading ? null : notifier.loadDashboard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: _DashboardBody(notifier: notifier),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final IncidentDashboardNotifier notifier;

  const _DashboardBody({
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    if (notifier.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notifier.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(notifier.errorMessage!),
        ),
      );
    }

    if (notifier.incidents.isEmpty) {
      return const Center(
        child: Text('No incidents found.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Incident resolution dashboard',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Practice Flutter rules through a real incident management UI.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        if (notifier.stats != null) ...[
          IncidentStatsCards(stats: notifier.stats!),
          const SizedBox(height: 24),
        ],
        Text(
          'Incidents',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...notifier.incidents.map(
              (incident) => IncidentCard(incident: incident),
        ),
      ],
    );
  }
}