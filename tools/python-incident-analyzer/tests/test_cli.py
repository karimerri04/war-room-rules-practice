"""Tests for the command-line parser."""

from incident_analyzer.cli import build_parser


def test_parser_accepts_version_flag() -> None:
    parser = build_parser()

    args = parser.parse_args(["--version"])

    assert args.version is True
