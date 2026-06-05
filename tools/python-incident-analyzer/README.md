# Python Incident Analyzer

This tool is part of the `war-room-rules-practice` project.

It is not a backend service. It is a Python CLI tool that consumes the Java Spring Boot incident API, analyzes the incident queue and generates reports.

## Project role

```text
Python Incident Analyzer
        |
        | HTTP REST
        v
Java Spring Boot backend
```

The Java backend remains the source of truth.

The Python tool only reads incident data, analyzes it and writes report files.

## Stack

* Python 3.11+
* requests
* argparse
* pathlib
* dataclasses
* StrEnum
* JSON
* CSV
* pytest
* ruff

## Features

* Installable Python CLI
* Version command
* Analyze command
* HTTP client for the Java incident backend
* Incident domain model
* Incident statistics model
* Incident analysis service
* JSON report writer
* CSV report writer
* Markdown report writer
* Unit tests
* Linting with Ruff

## Repository location

```text
tools/python-incident-analyzer
```

## Architecture

```text
tools/python-incident-analyzer/
├── pyproject.toml
├── README.md
├── reports/
├── src/
│   └── incident_analyzer/
│       ├── __init__.py
│       ├── cli.py
│       ├── config.py
│       ├── domain/
│       │   ├── incident.py
│       │   ├── incident_severity.py
│       │   ├── incident_stats.py
│       │   ├── incident_status.py
│       │   └── investigation_note.py
│       ├── client/
│       │   ├── incident_api_client.py
│       │   └── incident_api_error.py
│       ├── analysis/
│       │   ├── incident_analysis.py
│       │   └── incident_analysis_service.py
│       └── reporting/
│           ├── csv_report_writer.py
│           ├── json_report_writer.py
│           └── markdown_report_writer.py
└── tests/
    ├── client/
    ├── domain/
    ├── analysis/
    └── reporting/
```

## Main command

```bash
incident-analyzer analyze --output reports
```

This command:

1. calls the Java backend;
2. loads the incident list;
3. parses JSON into Python domain objects;
4. analyzes the queue;
5. writes JSON, CSV and Markdown reports.

Generated files:

```text
reports/
├── incident-summary.json
├── incident-summary.csv
└── incident-summary.md
```

## Backend API used

Default base URL:

```text
http://localhost:8081/api/java-incidents
```

Endpoints consumed:

```text
GET /api/java-incidents
```

The Python tool currently reads the full incident list and computes its own analysis from that list.

## Setup

From the project root:

```bash
cd tools/python-incident-analyzer
```

Create a virtual environment:

```bash
python -m venv .venv
```

Activate it.

Git Bash on Windows:

```bash
source .venv/Scripts/activate
```

PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

Linux/macOS:

```bash
source .venv/bin/activate
```

Install the project in editable mode with development dependencies:

```bash
python -m pip install --upgrade pip
python -m pip install -e ".[dev]"
```

## Commands

Show version:

```bash
incident-analyzer --version
```

Run analysis:

```bash
incident-analyzer analyze --output reports
```

Run analysis with a custom backend URL:

```bash
incident-analyzer analyze \
  --base-url http://localhost:8081/api/java-incidents \
  --output reports
```

## Validation

Run tests:

```bash
pytest
```

Run lint:

```bash
ruff check .
```

Apply safe lint fixes:

```bash
ruff check . --fix
```

Optional formatting:

```bash
ruff format .
```

## Design rules applied

### 1. Python project dependencies are isolated

The project uses a virtual environment:

```bash
python -m venv .venv
```

This prevents dependency conflicts with other Python projects.

### 2. The CLI is separated from business logic

The CLI lives in:

```text
src/incident_analyzer/cli.py
```

It parses user commands and delegates work to dedicated classes.

### 3. HTTP access is isolated

Backend calls are centralized in:

```text
IncidentApiClient
```

The rest of the code does not call `requests` directly.

### 4. HTTP status is checked before JSON parsing

The client verifies the response status before using the response body.

This avoids processing invalid backend responses as if they were valid data.

### 5. JSON is parsed into domain objects

Backend JSON is transformed into Python models:

```text
Incident
InvestigationNote
IncidentStats
```

This keeps analysis and reporting code clean and predictable.

### 6. Domain concepts use explicit types

The project uses:

```text
IncidentStatus
IncidentSeverity
```

These enums prevent scattering raw strings like `OPEN`, `HIGH` or `RESOLVED` across the codebase.

### 7. Analysis is pure and testable

The analysis service receives a list of incidents and returns an `IncidentAnalysis`.

It does not know about HTTP, files or CLI arguments.

### 8. Reporting is separated by output format

Each writer has one responsibility:

```text
JsonReportWriter
CsvReportWriter
MarkdownReportWriter
```

This makes each format easy to test and change independently.

### 9. Files are written with pathlib

The project uses `Path` instead of hand-built string paths.

This keeps file handling more reliable across Windows, Linux and macOS.

### 10. Tests protect each layer

Tests cover:

* CLI parser
* domain parsing
* API client behavior
* incident analysis
* report writers

## Learning objective

This module is designed to learn Python through a real project.

It practices:

* virtual environments
* Python packaging
* modules and packages
* dataclasses
* enums
* type hints
* HTTP APIs
* JSON parsing
* CSV writing
* Markdown generation
* exceptions
* tests
* linting
* command-line tooling

## Future improvements

Possible next steps:

* add logging instead of print output;
* add `--format json|csv|md|all`;
* add `--fail-on-risk` for CI usage;
* add report timestamp;
* add analysis by incident severity and status combinations;
* add a scheduled job example;
* add GitHub Actions validation.
