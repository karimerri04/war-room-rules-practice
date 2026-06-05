import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/incident.dart';
import 'severity_badge.dart';
import 'status_badge.dart';

/// Compact incident summary used in the dashboard list.
///
/// The card is intentionally stateless. It receives an [Incident] and navigates
/// to the details route when selected.
class IncidentCard extends StatelessWidget {
  final Incident incident;

  const IncidentCard({
    super.key,
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.go('/incidents/${incident.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusBadge(status: incident.status),
                  SeverityBadge(severity: incident.severity),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                incident.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                incident.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (incident.symptoms.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Symptoms',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                ...incident.symptoms.map(
                      (symptom) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $symptom'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}