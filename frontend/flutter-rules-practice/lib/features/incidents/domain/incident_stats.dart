class IncidentStats {
  final int total;
  final int open;
  final int investigating;
  final int resolved;
  final int low;
  final int medium;
  final int high;
  final int critical;

  const IncidentStats({
    required this.total,
    required this.open,
    required this.investigating,
    required this.resolved,
    required this.low,
    required this.medium,
    required this.high,
    required this.critical,
  });

  factory IncidentStats.fromJson(Map<String, dynamic> json) {
    return IncidentStats(
      total: json['total'] as int,
      open: json['open'] as int,
      investigating: json['investigating'] as int,
      resolved: json['resolved'] as int,
      low: json['low'] as int,
      medium: json['medium'] as int,
      high: json['high'] as int,
      critical: json['critical'] as int,
    );
  }
}