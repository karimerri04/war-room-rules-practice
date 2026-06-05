import 'package:flutter/foundation.dart';

import '../../data/incident_api_service.dart';
import '../../domain/add_incident_note_request.dart';
import '../../domain/incident.dart';
import '../../domain/resolve_incident_request.dart';

class IncidentDetailsNotifier extends ChangeNotifier {
  final IncidentApiService _incidentApiService;
  final String incidentId;

  IncidentDetailsNotifier({
    required IncidentApiService incidentApiService,
    required this.incidentId,
  }) : _incidentApiService = incidentApiService;

  bool _loading = false;
  bool _saving = false;
  String? _errorMessage;
  String? _successMessage;
  Incident? _incident;

  bool get loading => _loading;
  bool get saving => _saving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Incident? get incident => _incident;

  Future<void> loadIncident() async {
    _loading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _incident = await _incidentApiService.findById(incidentId);
    } catch (_) {
      _errorMessage = 'Unable to load incident details.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> startInvestigation() async {
    await _runMutation(
      successMessage: 'Investigation started.',
      action: () => _incidentApiService.startInvestigation(incidentId),
    );
  }

  Future<void> addNote({
    required String author,
    required String message,
  }) async {
    await _runMutation(
      successMessage: 'Investigation note added.',
      action: () => _incidentApiService.addNote(
        incidentId,
        AddIncidentNoteRequest(
          author: author,
          message: message,
        ),
      ),
    );
  }

  Future<void> resolve({
    required String resolutionSummary,
  }) async {
    await _runMutation(
      successMessage: 'Incident resolved.',
      action: () => _incidentApiService.resolve(
        incidentId,
        ResolveIncidentRequest(
          resolutionSummary: resolutionSummary,
        ),
      ),
    );
  }

  Future<void> _runMutation({
    required String successMessage,
    required Future<Incident> Function() action,
  }) async {
    _saving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _incident = await action();
      _successMessage = successMessage;
    } catch (_) {
      _errorMessage = 'Unable to update incident.';
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}