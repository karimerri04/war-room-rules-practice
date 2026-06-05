# Frontend Flutter Rules Practiced

## Goal

The Flutter frontend practices Flutter and Dart rules inside the same incident-resolution domain as the React and Angular frontends.

The goal is not to display Flutter rules as quiz content. The goal is to apply Flutter rules directly in a working incident dashboard.

## Stack

- Flutter
- Dart
- Material 3
- go_router
- Provider
- ChangeNotifier
- HTTP package
- Flutter test

## Project role

The Flutter application is a frontend client.

It consumes the Java Spring Boot backend through HTTP REST.

The backend remains the source of truth for:

- incident state
- status transitions
- investigation notes
- resolution actions

Flutter sends user intent and displays the backend response.

## Feature structure

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
            │   ├── incident_dashboard_page.dart
            │   └── incident_details_page.dart
            ├── state/
            │   ├── incident_dashboard_notifier.dart
            │   └── incident_details_notifier.dart
            └── widgets/
                ├── incident_card.dart
                ├── incident_filters.dart
                ├── incident_stats_cards.dart
                ├── severity_badge.dart
                └── status_badge.dart
```

## Rules practiced

### Flutter is a frontend layer

Flutter is not a backend service.

The correct placement is:

```txt
frontend/flutter-rules-practice
```

The incorrect placement would be:

```txt
backend/flutter-incident-service
```

### Backend as source of truth

The Flutter app does not own incident lifecycle rules.

It calls backend endpoints such as:

```txt
PATCH /api/java-incidents/{id}/start-investigation
POST  /api/java-incidents/{id}/notes
PATCH /api/java-incidents/{id}/resolve
```

The backend returns the updated incident, and Flutter renders that response.

### Everything visible is composed from widgets

The UI is built from focused widgets:

- `IncidentCard`
- `IncidentStatsCards`
- `IncidentFilters`
- `StatusBadge`
- `SeverityBadge`

This keeps the widget tree readable and easier to test.

### StatelessWidget by default

Most UI components are stateless because they only receive data and callbacks.

Examples:

- `IncidentCard`
- `IncidentStatsCards`
- `IncidentFilters`
- `StatusBadge`
- `SeverityBadge`

`StatefulWidget` is used only where local controller lifecycle is required, such as text fields in the incident details page.

### No network calls inside build()

Widgets do not call HTTP directly.

HTTP access is isolated in:

```txt
IncidentApiService
```

Screen state is handled by:

```txt
IncidentDashboardNotifier
IncidentDetailsNotifier
```

This keeps `build()` focused on UI composition.

### Data layer isolation

`IncidentApiService` centralizes:

- endpoint URLs
- HTTP methods
- request serialization
- response parsing
- non-2xx error handling

Widgets receive domain models instead of raw JSON.

### Provider and ChangeNotifier for simple state

The project uses `Provider` and `ChangeNotifier` because the state requirements are simple:

- load dashboard
- store active filter
- expose filtered incidents
- load one incident
- run backend mutations
- expose loading, saving, success and error states

A heavier pattern such as Bloc would be unnecessary for this scope.

### Declarative routing with go_router

Routes are centralized in:

```txt
app/router.dart
```

Implemented routes:

```txt
/               -> redirects to /incidents
/incidents      -> incident dashboard
/incidents/:id  -> incident details page
```

This avoids scattering route definitions across widgets.

### Pure filtering logic

Dashboard filtering is extracted into a pure Dart function:

```txt
filterIncidents()
```

Benefits:

- no widget dependency
- no API dependency
- easy unit testing
- predictable behavior

### Explicit async states

Screens represent the important UI states explicitly:

- loading
- error
- empty
- loaded content
- mutation success
- mutation error

This makes the UI more resilient and easier to explain.

### Widget testing

The Flutter frontend includes widget tests for visible behavior.

Examples:

- status badge label
- severity badge label
- incident card content
- incident card navigation

### Unit testing

The Flutter frontend includes unit tests for logic and parsing.

Examples:

- enum parsing
- enum serialization
- incident JSON parsing
- investigation note JSON parsing
- incident stats JSON parsing
- incident filtering

## Backend endpoints used

```txt
GET    /api/java-incidents
GET    /api/java-incidents/{id}
GET    /api/java-incidents/stats
PATCH  /api/java-incidents/{id}/start-investigation
POST   /api/java-incidents/{id}/notes
PATCH  /api/java-incidents/{id}/resolve
```

## Validation commands

```bash
flutter analyze
flutter test
flutter run -d chrome
```

## Interview explanation

A concise explanation of this Flutter frontend:

```txt
I implemented Flutter as a third frontend for the same incident-resolution backend.
The backend remains the source of truth. Flutter consumes the REST API through an isolated data service.
The app uses a feature-based structure, Provider and ChangeNotifier for simple state, go_router for navigation,
and pure Dart functions for testable business-side UI logic such as filtering.
The UI is composed from small reusable widgets and covered with unit and widget tests.
```
