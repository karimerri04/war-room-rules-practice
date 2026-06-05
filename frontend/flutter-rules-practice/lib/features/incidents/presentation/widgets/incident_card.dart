import 'package:flutter/material.dart';

import '../../domain/incident.dart';
import 'severity_badge.dart';
import 'status_badge.dart';

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
          // Details route will be added in the next step.
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
              const SizedBox(height: 12),
              Text(
                'Service: ${incident.serviceName}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}