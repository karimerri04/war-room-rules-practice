"""Tests for the incident API client."""

from __future__ import annotations

from unittest.mock import Mock, patch

import pytest
import requests

from incident_analyzer.client.incident_api_client import IncidentApiClient
from incident_analyzer.client.incident_api_error import IncidentApiError
from incident_analyzer.domain.incident_severity import IncidentSeverity
from incident_analyzer.domain.incident_status import IncidentStatus


def test_should_find_all_incidents() -> None:
    response = _json_response(
        [
            {
                "id": "JAVA-INC-001",
                "title": "NullPointerException when finding an unknown incident",
               "description": (
    "The API fails when an unknown incident id is requested."
),
                "severity": "HIGH",
                "status": "OPEN",
                "symptoms": ["HTTP 500 returned instead of 404"],
                "rootCause": "",
                "resolution": "",
                "createdAt": "2026-06-05T15:38:59Z",
                "resolvedAt": None,
                "notes": [],
            }
        ]
    )

    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.return_value = response

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")
        incidents = client.find_all()

    assert len(incidents) == 1
    assert incidents[0].incident_id == "JAVA-INC-001"
    assert incidents[0].severity == IncidentSeverity.HIGH
    assert incidents[0].status == IncidentStatus.OPEN

    get.assert_called_once_with(
        "http://backend/api/java-incidents",
        timeout=5.0,
    )


def test_should_find_incident_by_id() -> None:
    response = _json_response(
        {
            "id": "JAVA-INC-002",
            "title": "Mutable incident state",
            "description": "Incident state is modified directly.",
            "severity": "MEDIUM",
            "status": "INVESTIGATING",
            "symptoms": [],
            "rootCause": "",
            "resolution": "",
            "createdAt": "2026-06-05T15:38:59Z",
            "resolvedAt": None,
            "notes": [],
        }
    )

    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.return_value = response

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")
        incident = client.find_by_id("JAVA-INC-002")

    assert incident.incident_id == "JAVA-INC-002"
    assert incident.status == IncidentStatus.INVESTIGATING

    get.assert_called_once_with(
        "http://backend/api/java-incidents/JAVA-INC-002",
        timeout=5.0,
    )


def test_should_get_stats() -> None:
    response = _json_response(
        {
            "total": 3,
            "open": 3,
            "investigating": 0,
            "resolved": 0,
            "critical": 0,
            "high": 1,
            "medium": 2,
            "low": 0,
        }
    )

    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.return_value = response

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")
        stats = client.get_stats()

    assert stats.total == 3
    assert stats.open == 3
    assert stats.high == 1
    assert stats.medium == 2

    get.assert_called_once_with(
        "http://backend/api/java-incidents/stats",
        timeout=5.0,
    )


def test_should_raise_when_backend_returns_error_status() -> None:
    response = _json_response(
        {"message": "Internal server error"},
        status_code=500,
    )

    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.return_value = response

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")

        with pytest.raises(IncidentApiError, match="HTTP 500") as error:
            client.find_all()

    assert error.value.status_code == 500


def test_should_raise_when_backend_is_unreachable() -> None:
    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.side_effect = requests.ConnectionError("connection refused")

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")

        with pytest.raises(IncidentApiError, match="Unable to reach incident backend"):
            client.find_all()


def test_should_raise_when_incident_list_is_not_array() -> None:
    response = _json_response({"unexpected": "object"})

    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.return_value = response

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")

        with pytest.raises(IncidentApiError, match="Expected a JSON array"):
            client.find_all()


def test_should_raise_when_json_is_invalid() -> None:
    response = Mock()
    response.status_code = 200
    response.json.side_effect = ValueError("invalid json")

    with patch("incident_analyzer.client.incident_api_client.requests.get") as get:
        get.return_value = response

        client = IncidentApiClient(base_url="http://backend/api/java-incidents")

        with pytest.raises(IncidentApiError, match="invalid JSON"):
            client.find_all()


def _json_response(payload: object, status_code: int = 200) -> Mock:
    response = Mock()
    response.status_code = status_code
    response.json.return_value = payload
    return response