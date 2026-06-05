"""Tests for incident status parsing."""

import pytest

from incident_analyzer.domain.incident_status import IncidentStatus


def test_should_parse_open_status() -> None:
    assert IncidentStatus.from_json("OPEN") == IncidentStatus.OPEN


def test_should_parse_investigating_status() -> None:
    assert IncidentStatus.from_json("INVESTIGATING") == IncidentStatus.INVESTIGATING


def test_should_parse_resolved_status() -> None:
    assert IncidentStatus.from_json("RESOLVED") == IncidentStatus.RESOLVED


def test_should_raise_when_status_is_unknown() -> None:
    with pytest.raises(ValueError, match="Unknown incident status"):
        IncidentStatus.from_json("UNKNOWN")
