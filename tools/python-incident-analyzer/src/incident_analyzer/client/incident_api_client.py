"""HTTP client for the Java incident backend.

This module isolates all network access from the rest of the Python tool.
The CLI, analysis service and report writers should never call `requests`
directly.
"""

from __future__ import annotations

from typing import Any

import requests

from incident_analyzer.client.incident_api_error import IncidentApiError
from incident_analyzer.config import DEFAULT_BASE_URL
from incident_analyzer.domain.incident import Incident
from incident_analyzer.domain.incident_stats import IncidentStats


class IncidentApiClient:
    """Client responsible for reading incidents from the Java backend.

    Responsibilities:
    - build backend URLs;
    - execute HTTP GET requests;
    - validate HTTP status codes;
    - decode JSON responses;
    - convert JSON into Python domain objects.
    """

    def __init__(self, base_url: str = DEFAULT_BASE_URL, timeout_seconds: float = 5.0):
        self.base_url = base_url.rstrip("/")
        self.timeout_seconds = timeout_seconds

    def find_all(self) -> list[Incident]:
        """Return all incidents from the backend."""
        data = self._get_json(self.base_url)

        if not isinstance(data, list):
            raise IncidentApiError("Expected a JSON array for incident list.")

        return [Incident.from_json(item) for item in data if isinstance(item, dict)]

    def find_by_id(self, incident_id: str) -> Incident:
        """Return one incident by id."""
        data = self._get_json(f"{self.base_url}/{incident_id}")

        if not isinstance(data, dict):
            raise IncidentApiError("Expected a JSON object for incident details.")

        return Incident.from_json(data)

    def get_stats(self) -> IncidentStats:
        """Return aggregated incident statistics."""
        data = self._get_json(f"{self.base_url}/stats")

        if not isinstance(data, dict):
            raise IncidentApiError("Expected a JSON object for incident statistics.")

        return IncidentStats.from_json(data)

    def _get_json(self, url: str) -> Any:
        """Execute a GET request and return decoded JSON."""
        try:
            response = requests.get(url, timeout=self.timeout_seconds)
        except requests.RequestException as exc:
            raise IncidentApiError(f"Unable to reach incident backend: {exc}") from exc

        if response.status_code < 200 or response.status_code >= 300:
            raise IncidentApiError(
                f"Incident backend returned HTTP {response.status_code}.",
                status_code=response.status_code,
            )

        try:
            return response.json()
        except ValueError as exc:
            raise IncidentApiError("Incident backend returned invalid JSON.") from exc
