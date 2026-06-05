"""JSON report writer."""

from __future__ import annotations

import json
from pathlib import Path

from incident_analyzer.analysis.incident_analysis import IncidentAnalysis


class JsonReportWriter:
    """Write incident analysis as a machine-readable JSON report."""

    def write(self, analysis: IncidentAnalysis, output_dir: Path) -> Path:
        """Write the JSON report and return the created file path."""
        output_dir.mkdir(parents=True, exist_ok=True)
        output_path = output_dir / "incident-summary.json"

        with output_path.open("w", encoding="utf-8") as file:
            json.dump(
                {
                    "totalIncidents": analysis.total_incidents,
                    "openIncidents": analysis.open_incidents,
                    "investigatingIncidents": analysis.investigating_incidents,
                    "resolvedIncidents": analysis.resolved_incidents,
                    "criticalIncidents": analysis.critical_incidents,
                    "highIncidents": analysis.high_incidents,
                    "mediumIncidents": analysis.medium_incidents,
                    "lowIncidents": analysis.low_incidents,
                    "openCriticalIncidentIds": analysis.open_critical_incident_ids,
                    "incidentsWithoutRootCause": analysis.incidents_without_root_cause,
                    "incidentsWithoutResolution": analysis.incidents_without_resolution,
                    "incidentsWithNotes": analysis.incidents_with_notes,
                    "recommendations": analysis.recommendations,
                    "hasRisk": analysis.has_risk,
                },
                file,
                indent=2,
            )

        return output_path
