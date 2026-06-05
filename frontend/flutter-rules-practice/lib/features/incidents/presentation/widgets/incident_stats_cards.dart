import 'package:flutter/material.dart';

import '../../domain/incident_stats.dart';

class IncidentStatsCards extends StatelessWidget {
  final IncidentStats stats;

  const IncidentStatsCards({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatsItem(label: 'Total', value: stats.total),
      _StatsItem(label: 'Open', value: stats.open),
      _StatsItem(label: 'Investigating', value: stats.investigating),
      _StatsItem(label: 'Resolved', value: stats.resolved),
      _StatsItem(label: 'Critical', value: stats.critical),
      _StatsItem(label: 'High', value: stats.high),
      _StatsItem(label: 'Medium', value: stats.medium),
      _StatsItem(label: 'Low', value: stats.low),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
          width: 150,
          child: Card(
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
                    style:
                    Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}

class _StatsItem {
  final String label;
  final int value;

  const _StatsItem({
    required this.label,
    required this.value,
  });
}