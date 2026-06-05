import 'package:flutter/material.dart';

import '../../domain/incident_filter.dart';

class IncidentFilters extends StatelessWidget {
  final IncidentFilter filter;
  final int visibleCount;
  final VoidCallback onClearFilters;

  const IncidentFilters({
    super.key,
    required this.filter,
    required this.visibleCount,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final activeFilterLabel = _activeFilterLabel();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Visible incidents: $visibleCount',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (activeFilterLabel != null)
              Chip(
                label: Text(activeFilterLabel),
                onDeleted: onClearFilters,
              )
            else
              const Chip(
                label: Text('No active filter'),
              ),
            TextButton.icon(
              onPressed: filter.isEmpty ? null : onClearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  String? _activeFilterLabel() {
    if (filter.status != null) {
      return 'Status: ${filter.status!.label}';
    }

    if (filter.severity != null) {
      return 'Severity: ${filter.severity!.label}';
    }

    return null;
  }
}