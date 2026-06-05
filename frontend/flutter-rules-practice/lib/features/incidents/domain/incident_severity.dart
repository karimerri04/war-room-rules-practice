enum IncidentSeverity {
  low,
  medium,
  high,
  critical;

  static IncidentSeverity fromJson(String value) {
    return switch (value) {
      'LOW' => IncidentSeverity.low,
      'MEDIUM' => IncidentSeverity.medium,
      'HIGH' => IncidentSeverity.high,
      'CRITICAL' => IncidentSeverity.critical,
      _ => throw ArgumentError('Unknown incident severity: $value'),
    };
  }

  String toJson() {
    return switch (this) {
      IncidentSeverity.low => 'LOW',
      IncidentSeverity.medium => 'MEDIUM',
      IncidentSeverity.high => 'HIGH',
      IncidentSeverity.critical => 'CRITICAL',
    };
  }

  String get label {
    return switch (this) {
      IncidentSeverity.low => 'Low',
      IncidentSeverity.medium => 'Medium',
      IncidentSeverity.high => 'High',
      IncidentSeverity.critical => 'Critical',
    };
  }
}