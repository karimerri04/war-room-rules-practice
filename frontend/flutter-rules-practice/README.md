# Flutter Rules Practice - War Room Incident Dashboard

This frontend is part of the `war-room-rules-practice` project.

The goal is not to display isolated Flutter rules as a quiz, but to apply Flutter, Dart and frontend architecture rules in a realistic incident resolution dashboard.

## Stack

* Flutter
* Dart
* Material 3
* go_router
* Provider
* ChangeNotifier
* HTTP package
* Flutter test

## Project role

This application is a Flutter frontend consuming the same Java Spring Boot backend used by the React and Angular frontends.

The backend remains the source of truth.

```text
Flutter frontend
        |
        | HTTP REST
        v
Java Spring Boot backend
```

Backend base URL:

```text
http://localhost:8081/api/java-incidents
```

Swagger:

```text
http://localhost:8081/swagger-ui/index.html
```

## Implemented features

* Incident dashboard
* Incident stats cards
* Clickable stats filters
* Status filtering
* Severity filtering
* Incident cards
* Status badges
* Severity badges
* Incident details page
* Start investigation action
* Add investigation note action
* Resolve incident action
* Loading state
* Error state
* Empty state
* Success and error messages after mutations
* Unit tests
* Widget tests

## Routes

```text
/               -> redirects to /incidents
/incidents      -> incident dashboard
/incidents/:id  -> incident details page
```

## Architecture

The project uses a feature-based structure.

```text
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

## Architecture rules applied

### 1. Flutter is the UI layer, not the backend

The Flutter app is a frontend client.

It does not own the incident lifecycle. It consumes the Java backend through HTTP.

### 2. Backend as source of truth

Incident data, status changes, notes and resolution actions are performed by the backend.

Flutter only sends user intent:

* start investigation
* add note
* resolve incident

### 3. Feature-based organization

Incident-related files are grouped under:

```text
features/incidents/
```

This keeps the domain, data access, UI state and widgets close to the business feature.

### 4. No network calls inside build()

Widgets do not call HTTP directly.

Network access is isolated in:

```text
IncidentApiService
```

State orchestration is handled by:

```text
IncidentDashboardNotifier
IncidentDetailsNotifier
```

### 5. Small reusable widgets

The UI is split into focused widgets:

* `IncidentCard`
* `IncidentStatsCards`
* `IncidentFilters`
* `StatusBadge`
* `SeverityBadge`

### 6. StatelessWidget by default

Most UI components are stateless.

`StatefulWidget` is used only where local controller lifecycle is required, such as the details page forms.

### 7. Provider and ChangeNotifier for simple app state

The app uses `Provider` with `ChangeNotifier`.

This is intentionally simple and sufficient for this project.

### 8. Declarative routing with go_router

Routes are centralized in:

```text
app/router.dart
```

This keeps navigation paths explicit and avoids scattering route strings across the app.

### 9. Loading, error, empty and success states

Screens explicitly represent:

* loading state
* error state
* empty state
* loaded content
* mutation success message
* mutation error message

### 10. Logic outside widgets is easier to test

Filtering logic is extracted to a pure function:

```text
filterIncidents()
```

This makes it simple to test without rendering the UI.

## Backend endpoints used

```text
GET    /api/java-incidents
GET    /api/java-incidents/{id}
GET    /api/java-incidents/stats
PATCH  /api/java-incidents/{id}/start-investigation
POST   /api/java-incidents/{id}/notes
PATCH  /api/java-incidents/{id}/resolve
```

## Run locally

Start the backend first:

```bash
cd backend/java-incident-service
mvn spring-boot:run
```

Then start Flutter:

```bash
cd frontend/flutter-rules-practice
flutter pub get
flutter run -d chrome
```

## Local backend URL

For Flutter Web or desktop on the same machine:

```dart
static const String baseUrl = 'http://localhost:8081/api/java-incidents';
```

For Android emulator:

```dart
static const String baseUrl = 'http://10.0.2.2:8081/api/java-incidents';
```

## Validation commands

```bash
flutter analyze
flutter test
flutter run -d chrome
```

## Tests

Run all tests:

```bash
flutter test
```

Current test coverage includes:

* enum parsing
* enum serialization
* incident JSON parsing
* investigation note JSON parsing
* incident stats JSON parsing
* incident filtering
* status badge widget
* severity badge widget
* incident card widget
* incident card navigation

## Development workflow

This project follows the same branch-by-branch workflow as the React and Angular frontends.

Suggested branches:

```text
feature/flutter-rules-practice-init
feature/flutter-dashboard-filters
feature/flutter-incident-details-page
feature/flutter-tests
feature/flutter-readme
feature/flutter-code-documentation
feature/global-documentation-flutter
```

## Design intention

This frontend is intentionally not over-engineered.

The goal is to demonstrate practical Flutter rules in a realistic project:

* clean structure
* readable widgets
* explicit state
* isolated API access
* testable logic
* navigation through real routes
* backend-driven lifecycle

## Notes

The Flutter frontend consumes the same backend contract as the other frontends.

If the backend response changes, update the Dart domain models first:

```text
features/incidents/domain/
```

Do not patch JSON parsing directly inside UI widgets.
