import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/incident_dashboard_notifier.dart';
import '../widgets/incident_card.dart';
import '../widgets/incident_filters.dart';
import '../widgets/incident_stats_cards.dart';

/// Dashboard screen for incident monitoring and filtering.
///
/// This page does not fetch data directly. It reads state from
/// [IncidentDashboardNotifier] and delegates user actions to it.
class IncidentDashboardPage extends StatelessWidget {
  const IncidentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<IncidentDashboardNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('War Room'),
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

/// Renders the dashboard body according to the current async state:
/// loading, error, empty or loaded content.
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
      return _DashboardErrorState(
        message: notifier.errorMessage!,
        onRetry: notifier.loadDashboard,
      );
    }

    if (notifier.incidents.isEmpty) {
      return const _DashboardEmptyState(
        title: 'No incidents found',
        message: 'The backend did not return any incident yet.',
      );
    }

    final filteredIncidents = notifier.filteredIncidents;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DashboardHero(
          totalIncidents: notifier.incidents.length,
          visibleIncidents: filteredIncidents.length,
        ),
        const SizedBox(height: 24),
        if (notifier.stats != null) ...[
          _SectionTitle(
            title: 'Overview',
            subtitle: 'Click a stat card to filter the incident queue.',
          ),
          const SizedBox(height: 12),
          IncidentStatsCards(
            stats: notifier.stats!,
            onTotalSelected: notifier.clearFilters,
            onStatusSelected: notifier.filterByStatus,
            onSeveritySelected: notifier.filterBySeverity,
          ),
          const SizedBox(height: 24),
        ],
        _SectionTitle(
          title: 'Filters',
          subtitle: 'Current view applied to the incident queue.',
        ),
        const SizedBox(height: 12),
        IncidentFilters(
          filter: notifier.filter,
          visibleCount: filteredIncidents.length,
          onClearFilters: notifier.clearFilters,
        ),
        const SizedBox(height: 24),
        _SectionTitle(
          title: 'Incident queue',
          subtitle: 'Open an incident to investigate, add notes or resolve it.',
        ),
        const SizedBox(height: 16),
        if (filteredIncidents.isEmpty)
          _FilteredEmptyState(
            onClearFilters: notifier.clearFilters,
          )
        else
          ...filteredIncidents.map(
                (incident) => IncidentCard(incident: incident),
          ),
      ],
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final int totalIncidents;
  final int visibleIncidents;

  const _DashboardHero({
    required this.totalIncidents,
    required this.visibleIncidents,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 16,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Incident resolution dashboard',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Practice Flutter rules through a real operational workflow: observe, filter, investigate and resolve incidents.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _HeroMetric(
                  label: 'Total',
                  value: totalIncidents.toString(),
                ),
                _HeroMetric(
                  label: 'Visible',
                  value: visibleIncidents.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Text(
                  'Unable to load dashboard',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _DashboardEmptyState({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inbox_outlined,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  final VoidCallback onClearFilters;

  const _FilteredEmptyState({
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.filter_alt_off,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'No incidents match this filter',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clear filters to display the full incident queue again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }
}