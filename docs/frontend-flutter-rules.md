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

It consumes the Java Spring Boot backend through HTTP and does not own incident state.

The backend remains the source of truth.

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
        ├── domain/
        └── presentation/
```

## Rules applied

### Flutter is the UI layer

The Flutter app is not a backend service.

It displays data, captures user intent and delegates mutations to the backend API.

### Widgets stay small and focused

The dashboard is composed of focused widgets:

- `IncidentCard`
- `IncidentStatsCards`
- `IncidentFilters`
- `StatusBadge`
- `SeverityBadge`

### StatelessWidget by default

Most widgets are stateless.

`StatefulWidget` is used only when local lifecycle is required, such as text controllers in the details page.

### No HTTP calls inside build()

Network access is isolated in:

```txt
IncidentApiService
```

Widgets render state and delegate user actions.

### State management is explicit

The app uses:

- `Provider`
- `ChangeNotifier`
- screen-level notifiers

Dashboard state lives in `IncidentDashboardNotifier`.

Details page state lives in `IncidentDetailsNotifier`.

### Routing is centralized

Navigation is declared in:

```txt
app/router.dart
```

The application supports:

```txt
/incidents
/incidents/:id
```

### Domain parsing is isolated

Dart models convert backend JSON into typed objects:

- `Incident`
- `InvestigationNote`
- `IncidentStats`
- `IncidentStatus`
- `IncidentSeverity`

### Filtering is pure and testable

Incident filtering is extracted into a pure Dart function:

```txt
filterIncidents()
```

This makes the filtering rules testable without rendering widgets.

### UI states are explicit

The screens represent:

- loading
- error
- empty
- success
- mutation feedback

### Tests protect behavior

Flutter tests cover:

- enum parsing
- model parsing
- filtering logic
- badges
- incident cards
- navigation behavior

## Learning objective

The Flutter frontend demonstrates how to build a small but realistic client application with clean UI composition, separated state, typed models, route-based navigation and tests.
