import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/format_incident_date.dart';
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
    final noteCount = incident.notes.length;

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
              _IncidentCardHeader(incident: incident),
              const SizedBox(height: 12),
              Text(
                incident.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
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
                  'Key symptoms',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                ...incident.symptoms.take(2).map(
                      (symptom) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $symptom'),
                  ),
                ),
                if (incident.symptoms.length > 2)
                  Text(
                    '+${incident.symptoms.length - 2} more symptom(s)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _MetaChip(
                    icon: Icons.schedule,
                    label: formatIncidentDate(incident.createdAt),
                  ),
                  _MetaChip(
                    icon: Icons.notes,
                    label: '$noteCount note(s)',
                  ),
                  const _MetaChip(
                    icon: Icons.arrow_forward,
                    label: 'Open details',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncidentCardHeader extends StatelessWidget {
  final Incident incident;

  const _IncidentCardHeader({
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          incident.id,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        StatusBadge(status: incident.status),
        SeverityBadge(severity: incident.severity),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
      ),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}