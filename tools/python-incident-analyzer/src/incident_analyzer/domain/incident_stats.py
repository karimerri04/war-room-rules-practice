"""Incident statistics domain model."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class IncidentStats:
    """Aggregated incident counters returned by the Java backend."""

    total: int
    open: int
    investigating: int
    resolved: int
    critical: int
    high: int
    medium: int
    low: int

    @classmethod
    def from_json(cls, data: dict[str, Any]) -> IncidentStats:
        """Create incident statistics from backend JSON."""
        return cls(
            total=int(data.get("total", 0)),
            open=int(data.get("open", 0)),
            investigating=int(data.get("investigating", 0)),
            resolved=int(data.get("resolved", 0)),
            critical=int(data.get("critical", 0)),
            high=int(data.get("high", 0)),
            medium=int(data.get("medium", 0)),
            low=int(data.get("low", 0)),
        )