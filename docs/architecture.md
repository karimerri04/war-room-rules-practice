# Architecture

## Goal

`war-room-rules-practice` is a training project built around a technical incident resolution dashboard.

The purpose is to practice architecture and framework rules through realistic code.

The project deliberately avoids quiz-style rule display. Instead, each rule is applied inside a working application.

## High-level architecture

```txt
React frontend   ┐
Angular frontend ├── HTTP REST ── Java Spring Boot backend
Flutter frontend ┘
```

The Java backend is the source of truth.

The React, Angular and Flutter applications are three independent frontend implementations of the same domain.

They are not backend services.

## Repository layout

```txt
war-room-rules-practice/
├── backend/
│   └── java-incident-service/
├── frontend/
│   ├── react-rules-practice/
│   ├── angular-rules-practice/
│   └── flutter-rules-practice/
├── postman/
├── docs/
│   ├── api.md
│   ├── architecture.md
│   ├── backend-java-rules.md
│   ├── frontend-react-rules.md
│   ├── frontend-angular-rules.md
│   └── frontend-flutter-rules.md
├── README.md
└── docker-compose.yml
```

## Backend architecture

The backend follows a layered and domain-oriented structure.

Main responsibilities:

- expose REST endpoints
- validate requests
- execute use cases
- maintain incident state in memory
- map domain objects to DTOs
- handle errors consistently
- provide Swagger/OpenAPI documentation
- provide tests for domain, repository and controller behavior

Conceptual layers:

```txt
api/
application/
domain/
infrastructure/
```

## Backend domain model

The core domain contains:

- `Incident`
- `IncidentId`
- `InvestigationNote`
- `IncidentStatus`
- `IncidentSeverity`
- `IncidentRepository`

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

- find all incidents
- find incident by id
- get incident statistics
- start investigation
- add investigation note
- resolve incident

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

- display incident dashboard
- filter incidents
- show clickable statistics
- navigate to incident details
- start investigation
- add notes
- resolve incidents
- show loading and error states
- protect the app with an Error Boundary
- validate behavior with Vitest and React Testing Library

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

- display incident dashboard
- filter incidents with signals
- emit filter events from presentational components
- load data through injectable services
- use RxJS for async streams
- use reactive forms for notes and resolution
- test reusable UI components

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

- display incident dashboard
- filter incidents through a pure Dart function
- show clickable statistics
- navigate with `go_router`
- load data through an isolated API service
- manage screen state with `Provider` and `ChangeNotifier`
- represent loading, error, empty and success states
- start investigation
- add notes
- resolve incidents
- validate domain logic with unit tests
- validate visible UI behavior with widget tests

## Design principles

### One backend source of truth

The backend owns incident state.

React, Angular and Flutter consume the same backend API.

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

### Framework-specific frontends

React, Angular and Flutter solve the same business problem using their own idioms.

React uses:

- hooks
- custom hooks
- lifted state
- memoization
- component composition

Angular uses:

- standalone components
- services
- signals
- RxJS
- reactive forms
- inputs and outputs

Flutter uses:

- widgets
- Material 3
- `go_router`
- `Provider`
- `ChangeNotifier`
- feature-based folders
- pure Dart filtering logic
- widget tests

### Feature-based organization

Incident-related code is grouped under the incident feature in each frontend.

This improves readability, maintainability and interview defensibility.

### Testable units

Backend tests cover:

- domain behavior
- value objects
- repository behavior
- controller behavior with MockMvc

Frontend tests cover:

- rendering
- inputs
- outputs
- links
- filter behavior
- user-visible outcomes
- navigation behavior

## Why this architecture is useful

This project is useful for interview preparation because it shows:

- REST API design
- Spring Boot application structure
- frontend architecture in React, Angular and Flutter
- clean separation of concerns
- practical testing strategy
- ability to explain technical decisions
