"""Tests for incident statistics parsing."""

from incident_analyzer.domain.incident_stats import IncidentStats


def test_should_parse_incident_stats_from_json() -> None:
    stats = IncidentStats.from_json(
        {
            "total": 3,
            "open": 2,
            "investigating": 1,
            "resolved": 0,
            "critical": 0,
            "high": 1,
            "medium": 2,
            "low": 0,
        }
    )

    assert stats.total == 3
    assert stats.open == 2
    assert stats.investigating == 1
    assert stats.resolved == 0
    assert stats.critical == 0
    assert stats.high == 1
    assert stats.medium == 2
    assert stats.low == 0


def test_should_default_missing_stats_to_zero() -> None:
    stats = IncidentStats.from_json({})

    assert stats.total == 0
    assert stats.open == 0
    assert stats.investigating == 0
    assert stats.resolved == 0
    assert stats.critical == 0
    assert stats.high == 0
    assert stats.medium == 0
    assert stats.low == 0
