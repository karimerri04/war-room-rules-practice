import 'package:flutter/foundation.dart';

import '../../data/incident_api_service.dart';
import '../../domain/incident.dart';
import '../../domain/incident_stats.dart';

class IncidentDashboardNotifier extends ChangeNotifier {
  final IncidentApiService _incidentApiService;

  IncidentDashboardNotifier(this._incidentApiService);

  bool _loading = false;
  String? _errorMessage;
  List<Incident> _incidents = [];
  IncidentStats? _stats;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<Incident> get incidents => List.unmodifiable(_incidents);
  IncidentStats? get stats => _stats;

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
    } catch (error) {
      _errorMessage = 'Unable to load incidents dashboard.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}