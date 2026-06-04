# Frontend React Rules Practiced

## Goal

The React frontend practices React and TypeScript rules inside a realistic incident dashboard.

The objective is not to memorize rules, but to apply them in working UI code.

## Stack

- React
- TypeScript
- Vite
- React Router
- CSS by feature
- Vitest
- React Testing Library
- Testing Library User Event

## Feature structure

```txt
src/
├── app/
│   └── App.tsx
├── features/
│   └── incidents/
│       ├── api/
│       ├── components/
│       ├── hooks/
│       ├── pages/
│       └── types/
├── shared/
│   ├── components/
│   ├── config/
│   └── layout/
├── test/
│   └── setup.ts
├── index.css
└── main.tsx
```

## Rules practiced

### Component composition

The dashboard is built from focused components:

- `IncidentStats`
- `IncidentFilters`
- `IncidentList`
- `IncidentCard`
- `StatusBadge`
- `SeverityBadge`

Each component has a clear responsibility.

### State lifting

Filter state is owned by `IncidentDashboardPage`.

Child components receive values and callbacks through props.

This keeps state predictable and avoids duplicated state.

### Derived state with `useMemo`

Filtered incidents are derived from:

- all incidents
- selected status
- selected severity

The filtered list is computed with `useMemo`.

It is not stored as separate state.

### Stable callbacks with `useCallback`

Important callbacks are wrapped with `useCallback` where useful.

Examples:

- loading incidents
- starting investigation
- adding notes
- resolving incidents
- handling statistic card clicks

### API isolation

HTTP calls are isolated in:

```txt
features/incidents/api/incidentApi.ts
```

UI components do not directly depend on endpoint URLs.

### Custom hook

Incident loading logic is centralized in:

```txt
features/incidents/hooks/useIncidents.ts
```

The dashboard consumes a simple contract:

```ts
const { incidents, stats, loading, error, reload } = useIncidents()
```

### Reusable badges

Status and severity badges are isolated into reusable components:

```txt
StatusBadge.tsx
SeverityBadge.tsx
```

This avoids duplicated badge rendering and CSS.

### Error Boundary

The React app is wrapped in an `ErrorBoundary`.

This prevents unexpected rendering errors from causing a blank screen.

### Routing

React Router is used for:

- default redirect
- incident dashboard
- incident details page

Routes:

```txt
/
/incidents
/incidents/:id
```

### Accessibility

The UI uses:

- semantic sections
- labels for filters
- buttons for clickable statistics
- `aria-label`
- `aria-live` for action notifications

### Testing

The React frontend includes tests for:

- `IncidentStats`
- `IncidentFilters`
- `IncidentCard`
- `IncidentDashboardPage`

Tests focus on user-visible behavior.

Examples:

- clicking `Open` filters the dashboard
- clicking `Critical` filters by severity
- clicking `Total` resets filters
- cards render links to details pages

## Interview talking points

This React frontend shows:

- feature-based organization
- controlled filters
- reusable components
- lifted state
- derived state
- router usage
- Error Boundary usage
- practical frontend tests
