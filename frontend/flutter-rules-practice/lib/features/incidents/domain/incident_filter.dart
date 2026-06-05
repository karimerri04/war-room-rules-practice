import 'incident_severity.dart';
import 'incident_status.dart';

class IncidentFilter {
  final IncidentStatus? status;
  final IncidentSeverity? severity;

  const IncidentFilter({
    this.status,
    this.severity,
  });

  const IncidentFilter.empty()
      : status = null,
        severity = null;

  bool get isEmpty => status == null && severity == null;

  IncidentFilter copyWith({
    IncidentStatus? status,
    IncidentSeverity? severity,
    bool clearStatus = false,
    bool clearSeverity = false,
  }) {
    return IncidentFilter(
      status: clearStatus ? null : status ?? this.status,
      severity: clearSeverity ? null : severity ?? this.severity,
    );
  }
}