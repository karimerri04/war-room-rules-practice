import 'incident.dart';
import 'incident_filter.dart';

List<Incident> filterIncidents({
  required List<Incident> incidents,
  required IncidentFilter filter,
}) {
  if (filter.isEmpty) {
    return incidents;
  }

  return incidents.where((incident) {
    final matchesStatus =
        filter.status == null || incident.status == filter.status;

    final matchesSeverity =
        filter.severity == null || incident.severity == filter.severity;

    return matchesStatus && matchesSeverity;
  }).toList();
}