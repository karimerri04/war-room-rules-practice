"""Incident severity level."""

from __future__ import annotations

from enum import StrEnum


class IncidentSeverity(StrEnum):
    """Incident severity mapped from the Java backend."""

    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"

    @classmethod
    def from_json(cls, value: str) -> IncidentSeverity:
        """Parse a backend severity value into an enum."""
        try:
            return cls(value)
        except ValueError as exc:
            raise ValueError(f"Unknown incident severity: {value}") from exc
