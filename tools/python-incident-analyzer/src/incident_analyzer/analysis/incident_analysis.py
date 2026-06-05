"""Incident analysis result model."""

from __future__ import annotations

from dataclasses import dataclass, field


@dataclass(frozen=True)
class IncidentAnalysis:
    """Computed summary of the incident queue."""

    total_incidents: int
    open_incidents: int
    investigating_incidents: int
    resolved_incidents: int
    critical_incidents: int
    high_incidents: int
    medium_incidents: int
    low_incidents: int
    open_critical_incident_ids: list[str] = field(default_factory=list)
    incidents_without_root_cause: list[str] = field(default_factory=list)
    incidents_without_resolution: list[str] = field(default_factory=list)
    incidents_with_notes: list[str] = field(default_factory=list)
    recommendations: list[str] = field(default_factory=list)

    @property
    def has_risk(self) -> bool:
        """Return True when the queue contains unresolved risk."""
        return bool(
            self.open_critical_incident_ids
            or self.incidents_without_root_cause
            or self.incidents_without_resolution
        )
