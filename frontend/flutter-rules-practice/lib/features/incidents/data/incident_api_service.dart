import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../domain/add_incident_note_request.dart';
import '../domain/incident.dart';
import '../domain/incident_stats.dart';
import '../domain/resolve_incident_request.dart';

class IncidentApiService {
  Future<List<Incident>> findAll() async {
    final response = await http.get(Uri.parse(ApiConfig.baseUrl));

    _ensureSuccess(response);

    final jsonBody = jsonDecode(response.body) as List<dynamic>;

    return jsonBody
        .map((item) => Incident.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Incident> findById(String id) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/$id'));

    _ensureSuccess(response);

    return Incident.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<IncidentStats> getStats() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/stats'));

    _ensureSuccess(response);

    return IncidentStats.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Incident> startInvestigation(String id) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/$id/start-investigation'),
    );

    _ensureSuccess(response);

    return Incident.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Incident> addNote(
      String id,
      AddIncidentNoteRequest request,
      ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/$id/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    _ensureSuccess(response);

    return Incident.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Incident> resolve(
      String id,
      ResolveIncidentRequest request,
      ) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/$id/resolve'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    _ensureSuccess(response);

    return Incident.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw IncidentApiException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}

class IncidentApiException implements Exception {
  final int statusCode;
  final String body;

  const IncidentApiException({
    required this.statusCode,
    required this.body,
  });

  @override
  String toString() {
    return 'IncidentApiException(statusCode: $statusCode, body: $body)';
  }
}