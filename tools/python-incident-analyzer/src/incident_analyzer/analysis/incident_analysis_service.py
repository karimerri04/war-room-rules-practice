"""Incident analysis service."""

from __future__ import annotations

from collections import Counter

from incident_analyzer.analysis.incident_analysis import IncidentAnalysis
from incident_analyzer.domain.incident import Incident
from incident_analyzer.domain.incident_severity import IncidentSeverity
from incident_analyzer.domain.incident_status import IncidentStatus


class IncidentAnalysisService:
    """Analyze incidents and produce operational insights.
    This service is pure domain logic. It does not call the backend, read files,
    write files or parse CLI arguments.
    """

    def analyze(self, incidents: list[Incident]) -> IncidentAnalysis:
        """Analyze the incident queue and return computed counters and risks."""
        status_counts = Counter(incident.status for incident in incidents)
        severity_counts = Counter(incident.severity for incident in incidents)

        open_critical_incident_ids = [
            incident.incident_id
            for incident in incidents
            if incident.status == IncidentStatus.OPEN
            and incident.severity == IncidentSeverity.CRITICAL
        ]

        incidents_without_root_cause = [
            incident.incident_id
            for incident in incidents
            if not incident.root_cause.strip()
        ]

        incidents_without_resolution = [
            incident.incident_id
            for incident in incidents
            if incident.status != IncidentStatus.RESOLVED
            and not incident.resolution.strip()
        ]

        incidents_with_notes = [
            incident.incident_id for incident in incidents if incident.notes
        ]

        recommendations = self._build_recommendations(
            open_critical_incident_ids=open_critical_incident_ids,
            incidents_without_root_cause=incidents_without_root_cause,
            incidents_without_resolution=incidents_without_resolution,
        )

        return IncidentAnalysis(
            total_incidents=len(incidents),
            open_incidents=status_counts[IncidentStatus.OPEN],
            investigating_incidents=status_counts[IncidentStatus.INVESTIGATING],
            resolved_incidents=status_counts[IncidentStatus.RESOLVED],
            critical_incidents=severity_counts[IncidentSeverity.CRITICAL],
            high_incidents=severity_counts[IncidentSeverity.HIGH],
            medium_incidents=severity_counts[IncidentSeverity.MEDIUM],
            low_incidents=severity_counts[IncidentSeverity.LOW],
            open_critical_incident_ids=open_critical_incident_ids,
            incidents_without_root_cause=incidents_without_root_cause,
            incidents_without_resolution=incidents_without_resolution,
            incidents_with_notes=incidents_with_notes,
            recommendations=recommendations,
        )

    def _build_recommendations(
        self,
        *,
        open_critical_incident_ids: list[str],
        incidents_without_root_cause: list[str],
        incidents_without_resolution: list[str],
    ) -> list[str]:
        """Build human-readable recommendations from detected risks."""
        recommendations: list[str] = []

        if open_critical_incident_ids:
            recommendations.append(
                "Prioritize open critical incidents before lower-severity work."
            )

        if incidents_without_root_cause:
            recommendations.append(
                "Document root cause for incidents that are still missing one."
            )

        if incidents_without_resolution:
            recommendations.append(
                "Add resolution details before closing or reviewing incidents."
            )

        if not recommendations:
            recommendations.append("Incident queue looks healthy.")

        return recommendations
