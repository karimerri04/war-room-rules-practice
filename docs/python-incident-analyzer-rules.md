# Python Incident Analyzer Rules

This document explains how Python rules are applied inside the `python-incident-analyzer` tool.

The goal is not to display Python rules as a quiz. The goal is to apply Python rules in a real automation and reporting tool connected to the War Room backend.

## Project location

```txt
tools/python-incident-analyzer
```

## Role in the global project

The Python module is not a backend and not a frontend.

It is a CLI tool used for:

- reading incident data from the Java backend
- analyzing the incident queue
- generating JSON, CSV and Markdown reports

The Java backend remains the source of truth.

## Python rules applied

### 1. Environment first

The project starts by checking the Python version:

```bash
python --version
```

The project requires Python 3.11+.

### 2. Virtual environment

Dependencies are isolated with:

```bash
python -m venv .venv
```

This avoids conflicts between projects.

### 3. pyproject.toml

Project metadata, dependencies, CLI entry points, pytest settings and ruff settings are centralized in:

```txt
pyproject.toml
```

### 4. CLI with argparse

The command-line interface uses `argparse`.

Main commands:

```bash
incident-analyzer --version
incident-analyzer analyze --output reports
```

### 5. Explicit src package layout

The package is stored under:

```txt
src/incident_analyzer/
```

This keeps imports predictable and avoids confusing local files with installable package files.

### 6. Domain model with dataclasses

The project models backend data with dataclasses:

- `Incident`
- `InvestigationNote`
- `IncidentStats`
- `IncidentAnalysis`

### 7. Enums for controlled values

The project uses `StrEnum` for backend enum values:

- `IncidentStatus`
- `IncidentSeverity`

This avoids scattering raw strings such as `OPEN`, `HIGH` or `RESOLVED`.

### 8. Safe JSON parsing

Backend JSON is parsed through factory methods:

- `Incident.from_json()`
- `InvestigationNote.from_json()`
- `IncidentStats.from_json()`

Required fields fail fast. Optional fields use safe defaults.

### 9. HTTP access isolated in one client

HTTP calls are centralized in:

```txt
IncidentApiClient
```

The CLI, analysis service and report writers do not call `requests` directly.

### 10. HTTP status checked before JSON parsing

The client checks the response status code before using the response body.

Invalid backend responses are converted into `IncidentApiError`.

### 11. Analysis is separate from API and files

The analysis logic lives in:

```txt
IncidentAnalysisService
```

It receives incidents and returns an `IncidentAnalysis`.

It does not call HTTP, parse CLI arguments or write files.

### 12. Standard library first

The project uses standard library tools where appropriate:

- `argparse`
- `dataclasses`
- `enum.StrEnum`
- `collections.Counter`
- `pathlib`
- `csv`
- `json`

### 13. pathlib for paths

Report writers use `Path` instead of manually building paths as strings.

This improves portability across Windows, Linux and macOS.

### 14. Context-aware file writing

Files are written with safe file operations:

```python
with output_path.open("w", encoding="utf-8") as file:
    ...
```

### 15. Report writers by format

Each writer has one responsibility:

- `JsonReportWriter`
- `CsvReportWriter`
- `MarkdownReportWriter`

### 16. Tests with pytest

Tests cover:

- CLI parsing
- domain parsing
- API client behavior
- API error handling
- analysis logic
- report writer output

### 17. Temporary test paths

Report writer tests use `tmp_path` to avoid writing into real project folders.

### 18. Mocking HTTP calls

API client tests mock `requests.get` so tests do not require the Java backend to run.

### 19. Linting with Ruff

Ruff enforces style, import order and Python modernization:

```bash
ruff check .
```

### 20. Readability over cleverness

The project uses simple classes, explicit names and direct control flow.

The goal is to learn Python through readable automation code.

## Current command flow

```txt
CLI
 |
 v
IncidentApiClient
 |
 v
Incident.from_json()
 |
 v
IncidentAnalysisService
 |
 v
JsonReportWriter / CsvReportWriter / MarkdownReportWriter
 |
 v
reports/
```

## Validation commands

From:

```txt
tools/python-incident-analyzer
```

Run:

```bash
pytest
ruff check .
```

Run the analyzer:

```bash
incident-analyzer analyze --output reports
```

Expected output files:

```txt
reports/incident-summary.json
reports/incident-summary.csv
reports/incident-summary.md
```

## Learning objective

This module teaches Python through a real workflow:

```txt
read API data
→ parse JSON
→ model the domain
→ analyze the data
→ generate reports
→ test everything
```
