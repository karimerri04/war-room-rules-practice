import 'package:flutter/material.dart';

import '../../domain/incident_severity.dart';
import '../../domain/incident_stats.dart';
import '../../domain/incident_status.dart';

/// Clickable incident statistics cards.
///
/// Each card displays an aggregate value and emits a filter intent when tapped.
/// The filtering itself is handled by the dashboard notifier.
class IncidentStatsCards extends StatelessWidget {
  final IncidentStats stats;
  final VoidCallback onTotalSelected;
  final ValueChanged<IncidentStatus> onStatusSelected;
  final ValueChanged<IncidentSeverity> onSeveritySelected;

  const IncidentStatsCards({
    super.key,
    required this.stats,
    required this.onTotalSelected,
    required this.onStatusSelected,
    required this.onSeveritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatsItem(
        label: 'Total',
        value: stats.total,
        onTap: onTotalSelected,
      ),
      _StatsItem(
        label: 'Open',
        value: stats.open,
        onTap: () => onStatusSelected(IncidentStatus.open),
      ),
      _StatsItem(
        label: 'Investigating',
        value: stats.investigating,
        onTap: () => onStatusSelected(IncidentStatus.investigating),
      ),
      _StatsItem(
        label: 'Resolved',
        value: stats.resolved,
        onTap: () => onStatusSelected(IncidentStatus.resolved),
      ),
      _StatsItem(
        label: 'Critical',
        value: stats.critical,
        onTap: () => onSeveritySelected(IncidentSeverity.critical),
      ),
      _StatsItem(
        label: 'High',
        value: stats.high,
        onTap: () => onSeveritySelected(IncidentSeverity.high),
      ),
      _StatsItem(
        label: 'Medium',
        value: stats.medium,
        onTap: () => onSeveritySelected(IncidentSeverity.medium),
      ),
      _StatsItem(
        label: 'Low',
        value: stats.low,
        onTap: () => onSeveritySelected(IncidentSeverity.low),
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
          width: 150,
          child: _StatsCard(item: item),
        ),
      )
          .toList(),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final _StatsItem item;

  const _StatsCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                item.value.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsItem {
  final String label;
  final int value;
  final VoidCallback onTap;

  const _StatsItem({
    required this.label,
    required this.value,
    required this.onTap,
  });
}