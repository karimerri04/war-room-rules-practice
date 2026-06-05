import 'package:flutter/material.dart';

import '../../domain/incident_severity.dart';

/// Visual badge for an incident severity.
class SeverityBadge extends StatelessWidget {
  final IncidentSeverity severity;

  const SeverityBadge({
    super.key,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      IncidentSeverity.low => Colors.green,
      IncidentSeverity.medium => Colors.blue,
      IncidentSeverity.high => Colors.deepOrange,
      IncidentSeverity.critical => Colors.red,
    };

    return Chip(
      label: Text(severity.label),
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color),
      backgroundColor: color.withValues(alpha: 0.08),
    );
  }
}