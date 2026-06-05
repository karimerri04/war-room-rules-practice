"""Command-line interface for the Python Incident Analyzer.

This module is intentionally thin. It parses command-line arguments and
orchestrates the analysis workflow, but it does not own HTTP access, domain
parsing, analysis rules or file writing.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from incident_analyzer.analysis.incident_analysis_service import IncidentAnalysisService
from incident_analyzer.client.incident_api_client import IncidentApiClient
from incident_analyzer.client.incident_api_error import IncidentApiError
from incident_analyzer.config import APP_NAME, APP_VERSION, DEFAULT_BASE_URL
from incident_analyzer.reporting.csv_report_writer import CsvReportWriter
from incident_analyzer.reporting.json_report_writer import JsonReportWriter
from incident_analyzer.reporting.markdown_report_writer import MarkdownReportWriter


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

    subparsers = parser.add_subparsers(dest="command")

    analyze_parser = subparsers.add_parser(
        "analyze",
        help="Fetch incidents, analyze them and generate reports.",
    )
    analyze_parser.add_argument(
        "--base-url",
        default=DEFAULT_BASE_URL,
        help="Java backend incident API base URL.",
    )
    analyze_parser.add_argument(
        "--output",
        default="reports",
        help="Output directory for generated reports.",
    )

    return parser


def main() -> None:
    """Run the command-line application."""
    parser = build_parser()
    args = parser.parse_args()

    if args.version:
        print(f"{APP_NAME} {APP_VERSION}")
        return

    if args.command == "analyze":
        run_analyze_command(
            base_url=args.base_url,
            output_dir=Path(args.output),
        )
        return

    parser.print_help()


def run_analyze_command(base_url: str, output_dir: Path) -> None:
    """Run the complete incident analysis workflow.

    Flow:
    1. read incidents from the Java backend;
    2. compute operational analysis;
    3. write JSON, CSV and Markdown reports.

    The Java backend remains the source of truth. This command only reads data.
    """
    client = IncidentApiClient(base_url=base_url)
    analysis_service = IncidentAnalysisService()

    try:
        incidents = client.find_all()
    except IncidentApiError as exc:
        print(f"Unable to analyze incidents: {exc}")
        raise SystemExit(1) from exc

    analysis = analysis_service.analyze(incidents)

    json_path = JsonReportWriter().write(analysis, output_dir)
    csv_path = CsvReportWriter().write(analysis, output_dir)
    markdown_path = MarkdownReportWriter().write(analysis, output_dir)

    print("Incident analysis completed.")
    print(f"- JSON: {json_path}")
    print(f"- CSV: {csv_path}")
    print(f"- Markdown: {markdown_path}")


if __name__ == "__main__":
    main()
