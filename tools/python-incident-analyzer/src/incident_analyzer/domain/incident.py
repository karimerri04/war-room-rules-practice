"""Incident domain model."""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from incident_analyzer.domain.incident_severity import IncidentSeverity
from incident_analyzer.domain.incident_status import IncidentStatus
from incident_analyzer.domain.investigation_note import InvestigationNote


@dataclass(frozen=True)
class Incident:
    """Incident returned by the Java backend.

    This object mirrors the backend JSON contract. Optional backend fields are
    normalized to safe Python defaults so analysis and reporting code can use
    predictable values.
    """

    incident_id: str
    title: str
    description: str
    severity: IncidentSeverity
    status: IncidentStatus
    symptoms: list[str] = field(default_factory=list)
    root_cause: str = ""
    resolution: str = ""
    created_at: str = ""
    resolved_at: str | None = None
    notes: list[InvestigationNote] = field(default_factory=list)

    @classmethod
    def from_json(cls, data: dict[str, Any]) -> Incident:
        """Create an incident from backend JSON.

        Required fields are accessed directly to fail fast when the backend contract
        changes. Optional fields use safe defaults.
        """
        raw_symptoms = data.get("symptoms") or []
        raw_notes = data.get("notes") or []

        return cls(
            incident_id=str(data["id"]),
            title=str(data["title"]),
            description=str(data["description"]),
            severity=IncidentSeverity.from_json(str(data["severity"])),
            status=IncidentStatus.from_json(str(data["status"])),
            symptoms=[str(symptom) for symptom in raw_symptoms],
            root_cause=str(data.get("rootCause", "")),
            resolution=str(data.get("resolution", "")),
            created_at=str(data.get("createdAt", "")),
            resolved_at=data.get("resolvedAt"),
            notes=[
                InvestigationNote.from_json(note)
                for note in raw_notes
                if isinstance(note, dict)
            ],
        )

    @property
    def is_open(self) -> bool:
        """Return True when the incident is still open."""
        return self.status == IncidentStatus.OPEN

    @property
    def is_resolved(self) -> bool:
        """Return True when the incident is resolved."""
        return self.status == IncidentStatus.RESOLVED

    @property
    def is_critical(self) -> bool:
        """Return True when the incident severity is critical."""
        return self.severity == IncidentSeverity.CRITICAL
