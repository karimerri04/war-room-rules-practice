"""Investigation note domain model."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class InvestigationNote:
    """Note added during an incident investigation."""

    author: str
    message: str
    created_at: str

    @classmethod
    def from_json(cls, data: dict[str, Any]) -> InvestigationNote:
        """Create an investigation note from backend JSON."""
        return cls(
            author=str(data.get("author", "")),
            message=str(data.get("message", "")),
            created_at=str(data.get("createdAt", "")),
        )
