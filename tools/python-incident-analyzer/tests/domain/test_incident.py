"""Tests for incident parsing and derived properties."""

from incident_analyzer.domain.incident import Incident
from incident_analyzer.domain.incident_severity import IncidentSeverity
from incident_analyzer.domain.incident_status import IncidentStatus


def test_should_parse_incident_from_backend_json() -> None:
    incident = Incident.from_json(
        {
            "id": "JAVA-INC-001",
            "title": "NullPointerException when finding an unknown incident",
            "description": "The API fails when an unknown incident id is requested.",
            "severity": "HIGH",
            "status": "OPEN",
            "symptoms": [
                "HTTP 500 returned instead of 404",
                "Stack trace shows null access",
            ],
            "rootCause": "",
            "resolution": "",
            "createdAt": "2026-06-05T15:38:59Z",
            "resolvedAt": None,
            "notes": [],
        }
    )

    assert incident.incident_id == "JAVA-INC-001"
    assert "NullPointerException" in incident.title
    assert incident.severity == IncidentSeverity.HIGH
    assert incident.status == IncidentStatus.OPEN
    assert incident.symptoms == [
        "HTTP 500 returned instead of 404",
        "Stack trace shows null access",
    ]
    assert incident.root_cause == ""
    assert incident.resolution == ""
    assert incident.created_at == "2026-06-05T15:38:59Z"
    assert incident.resolved_at is None
    assert incident.notes == []
    assert incident.is_open is True
    assert incident.is_resolved is False
    assert incident.is_critical is False


def test_should_parse_incident_with_notes() -> None:
    incident = Incident.from_json(
        {
            "id": "JAVA-INC-002",
            "title": "Mutable incident state",
            "description": "Incident state is modified directly.",
            "severity": "MEDIUM",
            "status": "INVESTIGATING",
            "symptoms": [],
            "rootCause": "Missing use case orchestration",
            "resolution": "",
            "createdAt": "2026-06-05T15:38:59Z",
            "resolvedAt": None,
            "notes": [
                {
                    "author": "Karim",
                    "message": "Started investigation.",
                    "createdAt": "2026-06-05T16:00:00Z",
                }
            ],
        }
    )

    assert incident.status == IncidentStatus.INVESTIGATING
    assert incident.severity == IncidentSeverity.MEDIUM
    assert incident.notes[0].author == "Karim"
    assert incident.notes[0].message == "Started investigation."


def test_should_default_optional_fields_safely() -> None:
    incident = Incident.from_json(
        {
            "id": "JAVA-INC-003",
            "title": "Controller contains business logic",
            "description": "Controller validates domain behavior directly.",
            "severity": "CRITICAL",
            "status": "OPEN",
        }
    )

    assert incident.symptoms == []
    assert incident.notes == []
    assert incident.root_cause == ""
    assert incident.resolution == ""
    assert incident.created_at == ""
    assert incident.resolved_at is None
    assert incident.is_critical is True