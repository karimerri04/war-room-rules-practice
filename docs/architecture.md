# Architecture

## Goal

`war-room-rules-practice` is a training project built around a technical incident resolution dashboard.

The purpose is to practice architecture and framework rules through realistic code.

The project deliberately avoids quiz-style rule display. Instead, each rule is applied inside a working application or a supporting automation tool.

## High-level architecture

```txt
React frontend   ┐
Angular frontend ├── HTTP REST ── Java Spring Boot backend
Flutter frontend ┘                        ▲
                                          │
                                          │ HTTP REST
                                          │
                            Python Incident Analyzer
                            CLI reporting tool
```

The Java backend is the source of truth.

The React, Angular and Flutter applications are three independent frontend implementations of the same incident-resolution domain.

The Python module is not a backend service and not a frontend application. It is a CLI tool that consumes the Java backend API, analyzes incidents and generates reports.

## Repository layout

```txt
war-room-rules-practice/
├── backend/
│   └── java-incident-service/
├── frontend/
│   ├── react-rules-practice/
│   ├── angular-rules-practice/
│   └── flutter-rules-practice/
├── tools/
│   └── python-incident-analyzer/
├── postman/
├── docs/
│   ├── api.md
│   ├── architecture.md
│   ├── backend-java-rules.md
│   ├── frontend-react-rules.md
│   ├── frontend-angular-rules.md
│   ├── frontend-flutter-rules.md
│   └── python-incident-analyzer-rules.md
├── README.md
└── docker-compose.yml
```

## Backend architecture

The backend follows a layered and domain-oriented structure.

Main responsibilities:

* expose REST endpoints
* validate requests
* execute use cases
* maintain incident state in memory
* map domain objects to DTOs
* handle errors consistently
* provide Swagger/OpenAPI documentation
* provide tests for domain, repository and controller behavior

Conceptual layers:

```txt
api/
application/
domain/
infrastructure/
```

## Backend domain model

The core domain contains:

* `Incident`
* `IncidentId`
* `InvestigationNote`
* `IncidentStatus`
* `IncidentSeverity`
* `IncidentRepository`

Statuses:

```txt
OPEN
INVESTIGATING
RESOLVED
```

Severities:

```txt
LOW
MEDIUM
HIGH
CRITICAL
```

## Backend use cases

The application layer contains use cases such as:

* find all incidents
* find incident by id
* get incident statistics
* start investigation
* add investigation note
* resolve incident

This keeps business operations separated from the REST controller.

## React frontend architecture

The React frontend is organized by feature.

```txt
src/
├── app/
├── features/
│   └── incidents/
│       ├── api/
│       ├── components/
│       ├── hooks/
│       ├── pages/
│       └── types/
├── shared/
└── test/
```

React responsibilities:

* display incident dashboard
* filter incidents
* show clickable statistics
* navigate to incident details
* start investigation
* add notes
* resolve incidents
* show loading and error states
* protect the app with an Error Boundary
* validate behavior with Vitest and React Testing Library

## Angular frontend architecture

The Angular frontend is also organized by feature.

```txt
src/app/
├── core/
│   └── config/
└── features/
    └── incidents/
        ├── data-access/
        ├── models/
        ├── pages/
        ├── ui/
        └── utils/
```

Angular responsibilities:

* display incident dashboard
* filter incidents with signals
* emit filter events from presentational components
* load data through injectable services
* use RxJS for async streams
* use reactive forms for notes and resolution
* test reusable UI components

## Flutter frontend architecture

The Flutter frontend is organized by application area and feature.

```txt
lib/
├── main.dart
├── app/
│   ├── router.dart
│   └── war_room_app.dart
├── core/
│   └── config/
│       └── api_config.dart
└── features/
    └── incidents/
        ├── data/
        │   └── incident_api_service.dart
        ├── domain/
        │   ├── add_incident_note_request.dart
        │   ├── filter_incidents.dart
        │   ├── format_incident_date.dart
        │   ├── incident.dart
        │   ├── incident_filter.dart
        │   ├── incident_severity.dart
        │   ├── incident_stats.dart
        │   ├── incident_status.dart
        │   ├── investigation_note.dart
        │   └── resolve_incident_request.dart
        └── presentation/
            ├── pages/
            ├── state/
            └── widgets/
```

Flutter responsibilities:

* display incident dashboard
* filter incidents through a pure Dart function
* show clickable statistics
* navigate with `go_router`
* load data through an isolated API service
* manage screen state with `Provider` and `ChangeNotifier`
* represent loading, error, empty and success states
* start investigation
* add notes
* resolve incidents
* validate domain logic with unit tests
* validate visible UI behavior with widget tests

## Python Incident Analyzer architecture

The Python module is located under:

```txt
tools/python-incident-analyzer
```

It is intentionally placed under `tools/` because it is not a backend service and not a frontend application.

Its responsibility is to:

* call the Java backend
* parse incident JSON
* analyze the incident queue
* generate JSON, CSV and Markdown reports

The Java backend remains the source of truth.

The Python tool does not modify incidents. It reads and analyzes them.

```txt
tools/python-incident-analyzer/
├── pyproject.toml
├── README.md
├── reports/
├── src/
│   └── incident_analyzer/
│       ├── __init__.py
│       ├── cli.py
│       ├── config.py
│       ├── client/
│       │   ├── incident_api_client.py
│       │   └── incident_api_error.py
│       ├── domain/
│       │   ├── incident.py
│       │   ├── incident_severity.py
│       │   ├── incident_stats.py
│       │   ├── incident_status.py
│       │   └── investigation_note.py
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

Python internal flow:

```txt
CLI
 |
 v
IncidentApiClient
 |
 v
Domain models
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

Responsibility split:

| Layer        | Responsibility                                                    |
| ------------ | ----------------------------------------------------------------- |
| `cli.py`     | Parse command-line arguments and orchestrate the analysis command |
| `client/`    | Communicate with the Java backend                                 |
| `domain/`    | Represent incidents, statuses, severities, notes and stats        |
| `analysis/`  | Compute operational insights                                      |
| `reporting/` | Write JSON, CSV and Markdown reports                              |
| `tests/`     | Protect domain, client, analysis and reporting behavior           |

Python responsibilities:

* provide a CLI entry point
* read incidents from the Java backend
* transform JSON into Python dataclasses
* analyze status, severity and risk signals
* generate machine-readable JSON
* generate spreadsheet-friendly CSV
* generate human-readable Markdown
* validate behavior with pytest
* enforce style and modernization with ruff

## Design principles

### One backend source of truth

The backend owns incident state.

React, Angular, Flutter and Python consume the same backend API.

The frontend applications display and mutate incident state through the backend.

The Python tool reads incident state and generates reports.

### Frontends are clients, not microservices

The frontend applications are not backend services.

Do not create structures such as:

```txt
backend/react-incident-service
backend/angular-incident-service
backend/flutter-incident-service
```

The correct structure is:

```txt
frontend/react-rules-practice
frontend/angular-rules-practice
frontend/flutter-rules-practice
```

### Tools are not services

The `tools/` folder contains automation, analysis and reporting utilities.

A tool can consume application APIs, but it does not own business truth.

For this project:

```txt
backend/   -> source of truth and business API
frontend/  -> user interfaces
tools/     -> automation, analysis and reporting
docs/      -> global documentation
postman/   -> manual API testing
```

The Python Incident Analyzer belongs under `tools/` because it is a CLI reporting utility, not a backend service.

### Framework-specific frontends

React, Angular and Flutter solve the same business problem using their own idioms.

React uses:

* hooks
* custom hooks
* lifted state
* memoization
* component composition

Angular uses:

* standalone components
* services
* signals
* RxJS
* reactive forms
* inputs and outputs

Flutter uses:

* widgets
* Material 3
* `go_router`
* `Provider`
* `ChangeNotifier`
* feature-based folders
* pure Dart filtering logic
* widget tests

### Tool-specific Python module

Python solves a different problem: automation and reporting.

Python uses:

* virtual environment
* `pyproject.toml`
* `argparse`
* `requests`
* dataclasses
* `StrEnum`
* `pathlib`
* JSON writing
* CSV writing
* Markdown generation
* pytest
* ruff

### Feature-based organization

Incident-related code is grouped under the incident feature in each frontend.

Python groups related responsibilities by technical role:

```txt
client/
domain/
analysis/
reporting/
```

This improves readability, maintainability and interview defensibility.

### Testable units

Backend tests cover:

* domain behavior
* value objects
* repository behavior
* controller behavior with MockMvc

Frontend tests cover:

* rendering
* inputs
* outputs
* links
* filter behavior
* user-visible outcomes
* navigation behavior

Python tests cover:

* CLI parser behavior
* enum parsing
* dataclass JSON parsing
* API client behavior
* API error handling
* analysis logic
* report writer output

## Why this architecture is useful

This project is useful for interview preparation because it shows:

* REST API design
* Spring Boot application structure
* frontend architecture in React, Angular and Flutter
* clean separation of concerns
* practical testing strategy
* Python automation and reporting
* API consumption from an external tool
* ability to explain technical decisions across multiple technologies

It also shows the difference between:

```txt
backend service
frontend client
automation tool
documentation
manual API testing
```
