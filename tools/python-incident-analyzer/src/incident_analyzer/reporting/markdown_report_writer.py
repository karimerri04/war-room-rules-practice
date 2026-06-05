"""Markdown report writer."""

from __future__ import annotations

from pathlib import Path

from incident_analyzer.analysis.incident_analysis import IncidentAnalysis


class MarkdownReportWriter:
    """Write incident analysis as a human-readable Markdown report."""

    def write(self, analysis: IncidentAnalysis, output_dir: Path) -> Path:
        """Write the Markdown report and return the created file path."""
        output_dir.mkdir(parents=True, exist_ok=True)
        output_path = output_dir / "incident-summary.md"

        content = "\n".join(
            [
                "# Incident Summary",
                "",
                "## Overview",
                "",
                f"- Total incidents: {analysis.total_incidents}",
                f"- Open incidents: {analysis.open_incidents}",
                f"- Investigating incidents: {analysis.investigating_incidents}",
                f"- Resolved incidents: {analysis.resolved_incidents}",
                "",
                "## Severity",
                "",
                f"- Critical: {analysis.critical_incidents}",
                f"- High: {analysis.high_incidents}",
                f"- Medium: {analysis.medium_incidents}",
                f"- Low: {analysis.low_incidents}",
                "",
                "## Risk signals",
                "",
                _format_list(
                    "Open critical incidents",
                    analysis.open_critical_incident_ids,
                ),
                _format_list(
                    "Incidents without root cause",
                    analysis.incidents_without_root_cause,
                ),
                _format_list(
                    "Incidents without resolution",
                    analysis.incidents_without_resolution,
                ),
                _format_list(
                    "Incidents with notes",
                    analysis.incidents_with_notes,
                ),
                "",
                "## Recommendations",
                "",
                *_format_bullets(analysis.recommendations),
                "",
            ]
        )

        output_path.write_text(content, encoding="utf-8")

        return output_path


def _format_list(title: str, values: list[str]) -> str:
    if not values:
        return f"- {title}: none"

    return f"- {title}: {', '.join(values)}"


def _format_bullets(values: list[str]) -> list[str]:
    if not values:
        return ["- No recommendation."]

    return [f"- {value}" for value in values]
