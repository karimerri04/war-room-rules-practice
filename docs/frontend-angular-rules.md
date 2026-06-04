# Frontend Angular Rules Practiced

## Goal

The Angular frontend practices Angular and TypeScript rules inside the same incident-resolution domain as the React frontend.

The goal is to show how the same workflow can be implemented using Angular idioms.

## Stack

- Angular
- TypeScript
- Angular Router
- HttpClient
- RxJS
- Signals
- Reactive Forms
- CSS by feature
- Vitest / Angular test runner

## Feature structure

```txt
src/app/
├── app.component.ts
├── app.component.html
├── app.component.css
├── app.config.ts
├── app.routes.ts
├── core/
│   └── config/
│       └── api.config.ts
└── features/
    └── incidents/
        ├── data-access/
        ├── models/
        ├── pages/
        ├── ui/
        └── utils/
```

## Rules practiced

### Standalone components

The application uses standalone components.

Examples:

- `IncidentDashboardPageComponent`
- `IncidentDetailsPageComponent`
- `IncidentCardComponent`
- `IncidentStatsComponent`
- `IncidentFiltersComponent`
- `IncidentListComponent`
- `StatusBadgeComponent`
- `SeverityBadgeComponent`

Each component declares its own imports.

### Feature-based architecture

Incident code is isolated under:

```txt
features/incidents/
```

The feature contains:

- data access
- models
- pages
- UI components
- utilities

This keeps the project modular.

### Service-based API access

HTTP calls are centralized in:

```txt
features/incidents/data-access/incident.service.ts
```

Components do not call endpoints directly.

### HttpClient configuration

`HttpClient` is configured in:

```txt
app.config.ts
```

using:

```ts
provideHttpClient()
```

### Signals for UI state

Signals are used for local UI state.

Examples:

- selected status
- selected severity
- selected incident
- loading
- action loading
- error
- notification

### RxJS for async loading

RxJS is used to combine and transform async data.

The dashboard uses `combineLatest`.

The details page uses:

- route `paramMap`
- `switchMap`
- `tap`
- `catchError`

### Input and output communication

Reusable UI components use Angular inputs and outputs.

Examples:

```ts
readonly stats = input.required<IncidentStats>()
readonly statClick = output<StatFilter>()
```

This keeps child components presentational and parent-driven.

### Derived state through utilities

Filtering logic is extracted to:

```txt
features/incidents/utils/incident-filters.util.ts
```

The function is pure and reusable.

### Reactive forms

The details page uses reactive forms for:

- adding investigation notes
- resolving incidents

Validation is explicit with validators and `markAllAsTouched()`.

### Routing

Angular Router defines:

- dashboard route
- details route
- redirect from root

in:

```txt
app.routes.ts
```

### Accessibility

The UI uses:

- semantic sections
- labels for filters
- clickable statistics as buttons
- `aria-label`
- `aria-live`
- `role="list"`
- `role="listitem"`

### Testing

The Angular frontend includes component tests for:

- `AppComponent`
- `StatusBadgeComponent`
- `SeverityBadgeComponent`
- `IncidentStatsComponent`
- `IncidentFiltersComponent`
- `IncidentCardComponent`

Tests validate:

- rendering
- labels
- CSS classes
- input values
- output events
- router links

## Interview talking points

This Angular frontend shows:

- standalone Angular architecture
- service-based data access
- signal-based UI state
- RxJS async composition
- reactive forms
- reusable presentational components
- component testing
- clear separation between smart pages and UI components
