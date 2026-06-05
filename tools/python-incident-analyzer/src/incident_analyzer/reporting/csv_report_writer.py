"""CSV report writer."""

from __future__ import annotations

import csv
from pathlib import Path

from incident_analyzer.analysis.incident_analysis import IncidentAnalysis


class CsvReportWriter:
    """Write incident analysis counters as a CSV report."""

    def write(self, analysis: IncidentAnalysis, output_dir: Path) -> Path:
        """Write the CSV report and return the created file path."""
        output_dir.mkdir(parents=True, exist_ok=True)
        output_path = output_dir / "incident-summary.csv"

        rows = [
            ("total_incidents", analysis.total_incidents),
            ("open_incidents", analysis.open_incidents),
            ("investigating_incidents", analysis.investigating_incidents),
            ("resolved_incidents", analysis.resolved_incidents),
            ("critical_incidents", analysis.critical_incidents),
            ("high_incidents", analysis.high_incidents),
            ("medium_incidents", analysis.medium_incidents),
            ("low_incidents", analysis.low_incidents),
            ("open_critical_incidents", len(analysis.open_critical_incident_ids)),
            ("without_root_cause", len(analysis.incidents_without_root_cause)),
            ("without_resolution", len(analysis.incidents_without_resolution)),
            ("with_notes", len(analysis.incidents_with_notes)),
        ]

        with output_path.open("w", encoding="utf-8", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(["metric", "value"])
            writer.writerows(rows)

        return output_path
