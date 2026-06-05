"""Tests for the command-line parser."""

from pathlib import Path
from unittest.mock import Mock, patch

import pytest

from incident_analyzer.cli import build_parser, run_analyze_command
from incident_analyzer.client.incident_api_error import IncidentApiError
from incident_analyzer.domain.incident import Incident
from incident_analyzer.domain.incident_severity import IncidentSeverity
from incident_analyzer.domain.incident_status import IncidentStatus


def test_parser_accepts_version_flag() -> None:
    parser = build_parser()

    args = parser.parse_args(["--version"])

    assert args.version is True


def test_parser_accepts_analyze_command_with_defaults() -> None:
    parser = build_parser()

    args = parser.parse_args(["analyze"])

    assert args.command == "analyze"
    assert args.base_url == "http://localhost:8081/api/java-incidents"
    assert args.output == "reports"


def test_parser_accepts_analyze_command_with_custom_options() -> None:
    parser = build_parser()

    args = parser.parse_args(
        [
            "analyze",
            "--base-url",
            "http://backend/api/java-incidents",
            "--output",
            "custom-reports",
        ]
    )

    assert args.command == "analyze"
    assert args.base_url == "http://backend/api/java-incidents"
    assert args.output == "custom-reports"


def test_run_analyze_command_writes_reports(tmp_path: Path) -> None:
    incident = Incident(
        incident_id="JAVA-INC-001",
        title="Test incident",
        description="Test description",
        severity=IncidentSeverity.HIGH,
        status=IncidentStatus.OPEN,
        symptoms=["HTTP 500 returned instead of 404"],
        root_cause="",
        resolution="",
        created_at="2026-06-05T15:38:59Z",
        resolved_at=None,
        notes=[],
    )

    with patch("incident_analyzer.cli.IncidentApiClient") as client_class:
        client = Mock()
        client.find_all.return_value = [incident]
        client_class.return_value = client

        run_analyze_command(
            base_url="http://backend/api/java-incidents",
            output_dir=tmp_path,
        )

    assert (tmp_path / "incident-summary.json").exists()
    assert (tmp_path / "incident-summary.csv").exists()
    assert (tmp_path / "incident-summary.md").exists()

    client_class.assert_called_once_with(base_url="http://backend/api/java-incidents")
    client.find_all.assert_called_once()


def test_run_analyze_command_exits_when_api_fails(tmp_path: Path) -> None:
    with patch("incident_analyzer.cli.IncidentApiClient") as client_class:
        client = Mock()
        client.find_all.side_effect = IncidentApiError("Backend unavailable")
        client_class.return_value = client

        with pytest.raises(SystemExit) as error:
            run_analyze_command(
                base_url="http://backend/api/java-incidents",
                output_dir=tmp_path,
            )

    assert error.value.code == 1
