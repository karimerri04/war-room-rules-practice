"""Command-line interface for the Python Incident Analyzer."""

from __future__ import annotations

import argparse

from incident_analyzer.config import APP_NAME, APP_VERSION


def build_parser() -> argparse.ArgumentParser:
    """Build and return the command-line parser."""
    parser = argparse.ArgumentParser(
        prog="incident-analyzer",
        description="Analyze War Room incidents from the Java backend.",
    )

    parser.add_argument(
        "--version",
        action="store_true",
        help="Show the application version and exit.",
    )

    return parser


def main() -> None:
    """Run the command-line application."""
    parser = build_parser()
    args = parser.parse_args()

    if args.version:
        print(f"{APP_NAME} {APP_VERSION}")
        return

    parser.print_help()


if __name__ == "__main__":
    main()
