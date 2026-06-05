import 'incident.dart';
import 'incident_filter.dart';

/// Applies dashboard filters to the incident list.
///
/// This is a pure function on purpose:
/// - no widget dependency
/// - no API dependency
/// - easy to unit test
///
/// The UI only asks for filtered data; it does not own the filtering rules.
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