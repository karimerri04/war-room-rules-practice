import 'package:flutter/foundation.dart';

import '../../data/incident_api_service.dart';
import '../../domain/filter_incidents.dart';
import '../../domain/incident.dart';
import '../../domain/incident_filter.dart';
import '../../domain/incident_severity.dart';
import '../../domain/incident_stats.dart';
import '../../domain/incident_status.dart';

class IncidentDashboardNotifier extends ChangeNotifier {
  final IncidentApiService _incidentApiService;

  IncidentDashboardNotifier(this._incidentApiService);

  bool _loading = false;
  String? _errorMessage;
  List<Incident> _incidents = [];
  IncidentStats? _stats;
  IncidentFilter _filter = const IncidentFilter.empty();

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<Incident> get incidents => List.unmodifiable(_incidents);
  IncidentStats? get stats => _stats;
  IncidentFilter get filter => _filter;

  List<Incident> get filteredIncidents {
    return filterIncidents(
      incidents: _incidents,
      filter: _filter,
    );
  }

  Future<void> loadDashboard() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _incidentApiService.findAll(),
        _incidentApiService.getStats(),
      ]);

      _incidents = results[0] as List<Incident>;
      _stats = results[1] as IncidentStats;
    } catch (_) {
      _errorMessage = 'Unable to load incidents dashboard.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _filter = const IncidentFilter.empty();
    notifyListeners();
  }

  void filterByStatus(IncidentStatus status) {
    _filter = IncidentFilter(status: status);
    notifyListeners();
  }

  void filterBySeverity(IncidentSeverity severity) {
    _filter = IncidentFilter(severity: severity);
    notifyListeners();
  }
}