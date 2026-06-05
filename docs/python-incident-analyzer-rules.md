# Python Incident Analyzer Rules

This document explains how Python rules are applied inside the `python-incident-analyzer` tool.

The goal is not to display Python rules as a quiz. The goal is to apply Python rules in a real automation and reporting tool connected to the War Room backend.

## Project location

```text
tools/python-incident-analyzer
```

## Role in the global project

The Python module is not a backend and not a frontend.

It is a CLI tool used for:

* reading incident data from the Java backend;
* analyzing the incident queue;
* generating JSON, CSV and Markdown reports.

```text
React / Angular / Flutter frontends
               |
               v
       Java Spring Boot backend
               ^
               |
Python Incident Analyzer
```

The Java backend remains the source of truth.

## Python rules applied

## 1. Environment first

Before writing Python code, verify the interpreter:

```bash
python --version
```

The project requires:

```text
Python 3.11+
```

Rule applied:

```text
Always verify the Python version before starting a project.
```

## 2. Virtual environment

The project uses a local virtual environment:

```bash
python -m venv .venv
```

This keeps dependencies isolated from other projects.

Rule applied:

```text
A Python project must isolate its dependencies.
```

## 3. pyproject.toml as project configuration

The project is configured through:

```text
pyproject.toml
```

It defines:

* project metadata;
* runtime dependencies;
* development dependencies;
* CLI entry point;
* pytest configuration;
* ruff configuration.

Rule applied:

```text
Keep project configuration explicit and reproducible.
```

## 4. CLI with argparse

The command-line interface uses:

```text
argparse
```

Main commands:

```bash
incident-analyzer --version
incident-analyzer analyze --output reports
```

Rule applied:

```text
argparse transforms a script into a real command.
```

## 5. Explicit package structure

The project uses a `src` layout:

```text
src/incident_analyzer/
```

This avoids import confusion and keeps the package structure explicit.

Rule applied:

```text
A module organizes related code in separate files.
```

## 6. Domain model with dataclasses

The project models incident data with dataclasses:

```text
Incident
InvestigationNote
IncidentStats
IncidentAnalysis
```

Rule applied:

```text
A class describes a real domain concept.
```

Dataclasses reduce boilerplate while keeping data structures clear and typed.

## 7. Enums for controlled values

The project uses enums for backend values:

```text
IncidentStatus
IncidentSeverity
```

Instead of scattering raw strings, the code uses named values:

```text
OPEN
INVESTIGATING
RESOLVED

LOW
MEDIUM
HIGH
CRITICAL
```

Rule applied:

```text
Use explicit domain concepts instead of vague strings.
```

## 8. Safe JSON parsing

Backend JSON is parsed through factory methods:

```text
Incident.from_json()
InvestigationNote.from_json()
IncidentStats.from_json()
```

The UI or reporting layers do not parse raw JSON directly.

Rule applied:

```text
Transform a JSON response into dict/list Python, then into domain objects.
```

## 9. HTTP access isolated in one client

HTTP calls are centralized in:

```text
IncidentApiClient
```

This class owns:

* URLs;
* GET requests;
* timeout configuration;
* HTTP status validation;
* JSON parsing;
* API exceptions.

Rule applied:

```text
Check the HTTP response before processing the content.
```

## 10. Explicit API exceptions

Backend and network failures are converted into:

```text
IncidentApiError
```

Rule applied:

```text
Raise explicit exceptions for invalid or impossible situations.
```

This prevents the rest of the application from depending on low-level `requests` exceptions.

## 11. Analysis separate from API and files

The analysis logic lives in:

```text
IncidentAnalysisService
```

It receives incidents and returns an analysis result.

It does not:

* call the backend;
* read files;
* write files;
* parse CLI arguments.

Rule applied:

```text
Functions and classes should have clear responsibilities.
```

## 12. Counter for aggregations

The analysis service uses `Counter` to compute status and severity counts.

Rule applied:

```text
Use the standard library before writing manual loops.
```

## 13. pathlib for file paths

Report writers use:

```text
pathlib.Path
```

Rule applied:

```text
Do not build file paths manually.
```

This keeps paths reliable across Windows, Linux and macOS.

## 14. Context-aware file writing

Reports are written with safe file operations:

```python
with output_path.open("w", encoding="utf-8") as file:
    ...
```

Rule applied:

```text
Open files with with.
```

## 15. JSON report writer

The JSON writer produces:

```text
reports/incident-summary.json
```

It is intended for machine-readable output.

Rule applied:

```text
json.dump saves a Python structure as JSON.
```

## 16. CSV report writer

The CSV writer produces:

```text
reports/incident-summary.csv
```

It is intended for spreadsheet-friendly output.

Rule applied:

```text
csv.writer writes rows without manually managing commas.
```

## 17. Markdown report writer

The Markdown writer produces:

```text
reports/incident-summary.md
```

It is intended for human-readable summaries.

Rule applied:

```text
Automate report generation instead of writing repetitive documents manually.
```

## 18. Tests with pytest

The project uses:

```text
pytest
```

Tests cover:

* CLI parsing;
* enum parsing;
* dataclass JSON parsing;
* API client behavior;
* analysis logic;
* report generation.

Rule applied:

```text
Tests protect future changes and clarify expected behavior.
```

## 19. Fixtures and temporary paths

Report writer tests use `tmp_path`.

This avoids writing test files into the real project reports folder.

Rule applied:

```text
Tests should isolate temporary resources.
```

## 20. Mocking HTTP calls

API client tests mock `requests.get`.

This allows tests to verify behavior without requiring the backend to run.

Rule applied:

```text
Mock external systems when testing internal behavior.
```

## 21. Linting with Ruff

The project uses:

```bash
ruff check .
```

Ruff helps enforce:

* import order;
* line length;
* Python modernization;
* common bug prevention.

Rule applied:

```text
Regular style reduces mental load.
```

## 22. Readability over cleverness

The project avoids unnecessary Python tricks.

The design prefers:

* explicit classes;
* clear names;
* simple functions;
* small modules;
* direct control flow.

Rule applied:

```text
Python privileges readability before cleverness.
```

## Current command flow

```text
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

```text
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

```text
reports/incident-summary.json
reports/incident-summary.csv
reports/incident-summary.md
```

## What this module teaches

This module teaches Python through a real, useful workflow:

```text
read API data
→ parse JSON
→ model the domain
→ analyze the data
→ generate reports
→ test everything
```

It gives a practical foundation for later Python work such as:

* automation scripts;
* data analysis;
* backend utilities;
* scheduled jobs;
* CI tools;
* report generation;
* API clients.
