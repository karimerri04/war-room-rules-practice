"""Tests for report writers."""

from __future__ import annotations

import csv
import json

from incident_analyzer.analysis.incident_analysis import IncidentAnalysis
from incident_analyzer.reporting.csv_report_writer import CsvReportWriter
from incident_analyzer.reporting.json_report_writer import JsonReportWriter
from incident_analyzer.reporting.markdown_report_writer import MarkdownReportWriter


def test_should_write_json_report(tmp_path) -> None:
    analysis = _analysis()

    output_path = JsonReportWriter().write(analysis, tmp_path)

    assert output_path.name == "incident-summary.json"
    assert output_path.exists()

    content = json.loads(output_path.read_text(encoding="utf-8"))

    assert content["totalIncidents"] == 3
    assert content["openCriticalIncidentIds"] == ["JAVA-INC-001"]
    assert content["hasRisk"] is True


def test_should_write_csv_report(tmp_path) -> None:
    analysis = _analysis()

    output_path = CsvReportWriter().write(analysis, tmp_path)

    assert output_path.name == "incident-summary.csv"
    assert output_path.exists()

    with output_path.open(encoding="utf-8", newline="") as file:
        rows = list(csv.reader(file))

    assert rows[0] == ["metric", "value"]
    assert ["total_incidents", "3"] in rows
    assert ["open_critical_incidents", "1"] in rows


def test_should_write_markdown_report(tmp_path) -> None:
    analysis = _analysis()

    output_path = MarkdownReportWriter().write(analysis, tmp_path)

    assert output_path.name == "incident-summary.md"
    assert output_path.exists()

    content = output_path.read_text(encoding="utf-8")

    assert "# Incident Summary" in content
    assert "- Total incidents: 3" in content
    assert "- Open critical incidents: JAVA-INC-001" in content
    assert "- Prioritize open critical incidents before lower-severity work." in content


def _analysis() -> IncidentAnalysis:
    return IncidentAnalysis(
        total_incidents=3,
        open_incidents=1,
        investigating_incidents=1,
        resolved_incidents=1,
        critical_incidents=1,
        high_incidents=1,
        medium_incidents=1,
        low_incidents=0,
        open_critical_incident_ids=["JAVA-INC-001"],
        incidents_without_root_cause=["JAVA-INC-001"],
        incidents_without_resolution=["JAVA-INC-001", "JAVA-INC-002"],
        incidents_with_notes=["JAVA-INC-002"],
        recommendations=[
            "Prioritize open critical incidents before lower-severity work."
        ],
    )
