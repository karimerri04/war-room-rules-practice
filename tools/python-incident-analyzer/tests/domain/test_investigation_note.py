"""Tests for investigation note parsing."""

from incident_analyzer.domain.investigation_note import InvestigationNote


def test_should_parse_investigation_note_from_json() -> None:
    note = InvestigationNote.from_json(
        {
            "author": "Karim",
            "message": "Started investigation.",
            "createdAt": "2026-06-05T16:00:00Z",
        }
    )

    assert note.author == "Karim"
    assert note.message == "Started investigation."
    assert note.created_at == "2026-06-05T16:00:00Z"


def test_should_default_missing_note_fields_to_empty_strings() -> None:
    note = InvestigationNote.from_json({})

    assert note.author == ""
    assert note.message == ""
    assert note.created_at == ""
