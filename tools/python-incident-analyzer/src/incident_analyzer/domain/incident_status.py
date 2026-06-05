"""Incident lifecycle status."""

from __future__ import annotations

from enum import StrEnum


class IncidentStatus(StrEnum):
    """Incident lifecycle status mapped from the Java backend."""

    OPEN = "OPEN"
    INVESTIGATING = "INVESTIGATING"
    RESOLVED = "RESOLVED"

    @classmethod
    def from_json(cls, value: str) -> IncidentStatus:
        """Parse a backend status value into an enum."""
        try:
            return cls(value)
        except ValueError as exc:
            raise ValueError(f"Unknown incident status: {value}") from exc