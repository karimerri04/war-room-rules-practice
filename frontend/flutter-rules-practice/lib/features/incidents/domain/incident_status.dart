/// Incident lifecycle status.
///
/// Values are mapped from the backend enum format:
/// `OPEN`, `INVESTIGATING`, `RESOLVED`.
enum IncidentStatus {
  open,
  investigating,
  resolved;

  /// Parses the backend enum value into a Dart enum.
  static IncidentStatus fromJson(String value) {
    return switch (value) {
      'OPEN' => IncidentStatus.open,
      'INVESTIGATING' => IncidentStatus.investigating,
      'RESOLVED' => IncidentStatus.resolved,
      _ => throw ArgumentError('Unknown incident status: $value'),
    };
  }

  String toJson() {
    return switch (this) {
      IncidentStatus.open => 'OPEN',
      IncidentStatus.investigating => 'INVESTIGATING',
      IncidentStatus.resolved => 'RESOLVED',
    };
  }

  String get label {
    return switch (this) {
      IncidentStatus.open => 'Open',
      IncidentStatus.investigating => 'Investigating',
      IncidentStatus.resolved => 'Resolved',
    };
  }
}