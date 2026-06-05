"""Tests for incident analysis service."""

from incident_analyzer.analysis.incident_analysis_service import IncidentAnalysisService
from incident_analyzer.domain.incident import Incident
from incident_analyzer.domain.incident_severity import IncidentSeverity
from incident_analyzer.domain.incident_status import IncidentStatus
from incident_analyzer.domain.investigation_note import InvestigationNote


def test_should_analyze_incident_queue() -> None:
    service = IncidentAnalysisService()

    analysis = service.analyze(
        [
            _incident(
                incident_id="JAVA-INC-001",
                status=IncidentStatus.OPEN,
                severity=IncidentSeverity.CRITICAL,
                root_cause="",
                resolution="",
            ),
            _incident(
                incident_id="JAVA-INC-002",
                status=IncidentStatus.INVESTIGATING,
                severity=IncidentSeverity.HIGH,
                root_cause="Mutable state",
                resolution="",
                notes=[
                    InvestigationNote(
                        author="Karim",
                        message="Started investigation.",
                        created_at="2026-06-05T16:00:00Z",
                    )
                ],
            ),
            _incident(
                incident_id="JAVA-INC-003",
                status=IncidentStatus.RESOLVED,
                severity=IncidentSeverity.MEDIUM,
                root_cause="Controller contained business logic",
                resolution="Moved logic to use case.",
            ),
        ]
    )

    assert analysis.total_incidents == 3
    assert analysis.open_incidents == 1
    assert analysis.investigating_incidents == 1
    assert analysis.resolved_incidents == 1

    assert analysis.critical_incidents == 1
    assert analysis.high_incidents == 1
    assert analysis.medium_incidents == 1
    assert analysis.low_incidents == 0

    assert analysis.open_critical_incident_ids == ["JAVA-INC-001"]
    assert analysis.incidents_without_root_cause == ["JAVA-INC-001"]
    assert analysis.incidents_without_resolution == ["JAVA-INC-001", "JAVA-INC-002"]
    assert analysis.incidents_with_notes == ["JAVA-INC-002"]

    assert analysis.has_risk is True
    assert "Prioritize open critical incidents" in analysis.recommendations[0]


def test_should_return_healthy_recommendation_when_no_risk_exists() -> None:
    service = IncidentAnalysisService()

    analysis = service.analyze(
        [
            _incident(
                incident_id="JAVA-INC-001",
                status=IncidentStatus.RESOLVED,
                severity=IncidentSeverity.LOW,
                root_cause="Known cause",
                resolution="Resolved by applying fix.",
            )
        ]
    )

    assert analysis.has_risk is False
    assert analysis.recommendations == ["Incident queue looks healthy."]


def test_should_handle_empty_incident_queue() -> None:
    service = IncidentAnalysisService()

    analysis = service.analyze([])

    assert analysis.total_incidents == 0
    assert analysis.open_incidents == 0
    assert analysis.investigating_incidents == 0
    assert analysis.resolved_incidents == 0
    assert analysis.critical_incidents == 0
    assert analysis.high_incidents == 0
    assert analysis.medium_incidents == 0
    assert analysis.low_incidents == 0
    assert analysis.has_risk is False
    assert analysis.recommendations == ["Incident queue looks healthy."]


def _incident(
    *,
    incident_id: str,
    status: IncidentStatus,
    severity: IncidentSeverity,
    root_cause: str,
    resolution: str,
    notes: list[InvestigationNote] | None = None,
) -> Incident:
    return Incident(
        incident_id=incident_id,
        title=f"Incident {incident_id}",
        description=f"Description for {incident_id}",
        severity=severity,
        status=status,
        symptoms=[],
        root_cause=root_cause,
        resolution=resolution,
        created_at="2026-06-05T15:38:59Z",
        resolved_at=None,
        notes=notes or [],
    )
