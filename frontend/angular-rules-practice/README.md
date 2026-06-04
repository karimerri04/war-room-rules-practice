# Angular Rules Practice - War Room Incident Dashboard

This frontend is part of the `war-room-rules-practice` project.

The goal is not to display isolated Angular rules as a quiz, but to apply Angular, TypeScript and frontend architecture rules in a realistic incident resolution dashboard.

## Stack

* Angular
* TypeScript
* Angular Router
* HttpClient
* RxJS
* Signals
* Reactive Forms
* CSS by feature
* Vitest / Angular test runner

## Features

The application provides a dashboard for technical incident resolution.

Current capabilities:

* Display incident statistics
* Filter incidents by status
* Filter incidents by severity
* Click statistic cards to update dashboard filters
* Display incident cards
* Navigate to an incident details page
* Start investigation
* Add investigation notes
* Resolve an incident
* Display status and severity badges
* Handle loading and error states
* Use reactive forms for incident notes and resolution

## Routes

| Route            | Description               |
| ---------------- | ------------------------- |
| `/`              | Redirects to `/incidents` |
| `/incidents`     | Incident dashboard        |
| `/incidents/:id` | Incident details page     |

## Project structure

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
        │   └── incident.service.ts
        ├── models/
        │   ├── incident.model.ts
        │   └── incident-filter.model.ts
        ├── pages/
        │   ├── incident-dashboard-page/
        │   └── incident-details-page/
        ├── ui/
        │   ├── incident-card/
        │   ├── incident-filters/
        │   ├── incident-list/
        │   ├── incident-stats/
        │   ├── severity-badge/
        │   └── status-badge/
        └── utils/
            └── incident-filters.util.ts
```

## Angular rules practiced

### Standalone components

The application uses standalone components instead of NgModules.

Examples:

* `IncidentDashboardPageComponent`
* `IncidentDetailsPageComponent`
* `IncidentCardComponent`
* `IncidentStatsComponent`
* `IncidentFiltersComponent`
* `IncidentListComponent`
* `StatusBadgeComponent`
* `SeverityBadgeComponent`

Each component declares its own imports.

### Feature-based architecture

The incident domain is isolated under:

```txt
features/incidents/
```

The feature contains:

* data access
* models
* pages
* UI components
* utilities

This keeps the application modular and easier to extend.

### Service-based API access

HTTP calls are isolated in:

```txt
features/incidents/data-access/incident.service.ts
```

UI components do not call backend endpoints directly.

The service exposes methods such as:

```ts
findAll()
findById(id)
getStats()
startInvestigation(id)
addNote(id, request)
resolve(id, request)
```

### HttpClient with provider configuration

`HttpClient` is configured once in:

```txt
app.config.ts
```

using:

```ts
provideHttpClient()
```

This makes `HttpClient` injectable in Angular services.

### Signals for local UI state

The dashboard and details page use signals for local UI state such as:

* selected status
* selected severity
* selected incident
* loading state
* action loading state
* notifications
* errors

Examples:

```ts
readonly selectedStatus = signal<StatusFilter>('ALL')
readonly selectedSeverity = signal<SeverityFilter>('ALL')
```

### RxJS for async data loading

The dashboard combines backend data streams with RxJS:

```ts
combineLatest({
  incidents: this.incidents$,
  stats: this.stats$,
})
```

The details page uses route parameters and API loading with:

```ts
paramMap
switchMap
tap
catchError
```

### Input and output communication

Reusable UI components communicate with their parent through Angular inputs and outputs.

Examples:

```ts
readonly stats = input.required<IncidentStats>()
readonly statClick = output<StatFilter>()
```

This keeps components reusable and parent-driven.

### Derived state through utilities

Filtering logic is extracted to:

```txt
features/incidents/utils/incident-filters.util.ts
```

The dashboard derives the visible incident list from:

* all incidents
* selected status
* selected severity

This avoids duplicating filtered state.

### Reactive forms

The details page uses reactive forms for:

* adding investigation notes
* resolving incidents

The forms use `FormBuilder`, validators and `markAllAsTouched()` to keep validation explicit.

### Routing

Angular Router defines:

* dashboard route
* details route
* default redirect

in:

```txt
app.routes.ts
```

### Accessibility

The UI uses:

* semantic page sections
* labels for filters
* buttons for clickable statistics
* `aria-label` for statistics and filters
* `aria-live` for action notifications
* `role="list"` and `role="listitem"` where Angular control-flow blocks would otherwise conflict with HTML list validation

## Tests

The Angular frontend includes component tests for:

* `AppComponent`
* `StatusBadgeComponent`
* `SeverityBadgeComponent`
* `IncidentStatsComponent`
* `IncidentFiltersComponent`
* `IncidentCardComponent`

The tests validate:

* component creation
* rendered labels
* CSS class selection
* input rendering
* output events
* router links

## Commands

Install dependencies:

```bash
npm install
```

Start development server:

```bash
npm start
```

Run tests:

```bash
npm run test:run
```

Run build:

```bash
npm run build
```

## Backend dependency

The Angular frontend expects the Java incident service to be running.

Default API base URL is configured in:

```txt
src/app/core/config/api.config.ts
```

Backend Swagger is available at:

```txt
http://localhost:8081/swagger-ui/index.html
```

## Notes

This Angular frontend intentionally implements the same incident-resolution domain as the React frontend, but using Angular idioms.

The objective is to compare how the same business workflow can be implemented with:

* React hooks and component composition
* Angular standalone components, services, signals, RxJS and reactive forms

## Next improvements

Possible next steps:

* Add tests for `IncidentDetailsPageComponent`
* Add API mocking for Angular tests
* Add route-level loading and error handling
* Add optimistic UI updates
* Add global project documentation under `/docs`
