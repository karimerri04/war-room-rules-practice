import 'package:flutter/material.dart';

import '../../domain/incident_status.dart';

/// Visual badge for an incident status.
class StatusBadge extends StatelessWidget {
  final IncidentStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      IncidentStatus.open => Colors.orange,
      IncidentStatus.investigating => Colors.blue,
      IncidentStatus.resolved => Colors.green,
    };

    return Chip(
      label: Text(status.label),
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color),
      backgroundColor: color.withValues(alpha: 0.08),
    );
  }
}