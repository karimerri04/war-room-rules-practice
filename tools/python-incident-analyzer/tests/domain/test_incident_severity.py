"""Tests for incident severity parsing."""

import pytest

from incident_analyzer.domain.incident_severity import IncidentSeverity


def test_should_parse_low_severity() -> None:
    assert IncidentSeverity.from_json("LOW") == IncidentSeverity.LOW


def test_should_parse_medium_severity() -> None:
    assert IncidentSeverity.from_json("MEDIUM") == IncidentSeverity.MEDIUM


def test_should_parse_high_severity() -> None:
    assert IncidentSeverity.from_json("HIGH") == IncidentSeverity.HIGH


def test_should_parse_critical_severity() -> None:
    assert IncidentSeverity.from_json("CRITICAL") == IncidentSeverity.CRITICAL


def test_should_raise_when_severity_is_unknown() -> None:
    with pytest.raises(ValueError, match="Unknown incident severity"):
        IncidentSeverity.from_json("BLOCKER")
