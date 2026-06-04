# React Rules Practice - War Room Incident Dashboard

This frontend is part of the `war-room-rules-practice` project.

The goal is not to display isolated React rules as a quiz, but to apply React, TypeScript and frontend architecture rules in a realistic incident resolution dashboard.

## Stack

* React
* TypeScript
* Vite
* React Router
* CSS by feature
* Vitest
* React Testing Library
* Testing Library User Event

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
* Protect the application with an Error Boundary

## Routes

| Route            | Description               |
| ---------------- | ------------------------- |
| `/`              | Redirects to `/incidents` |
| `/incidents`     | Incident dashboard        |
| `/incidents/:id` | Incident details page     |

## Project structure

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

## React rules practiced

### Component composition

The dashboard is built from focused components:

* `IncidentStats`
* `IncidentFilters`
* `IncidentList`
* `IncidentCard`
* `StatusBadge`
* `SeverityBadge`

Each component has a clear responsibility.

### State lifting

Filter state is owned by `IncidentDashboardPage`.

The child components receive state and callbacks through props:

* `selectedStatus`
* `selectedSeverity`
* `onStatusChange`
* `onSeverityChange`
* `onStatClick`

This keeps the dashboard behavior predictable.

### Derived state with `useMemo`

Filtered incidents are derived from:

* all incidents
* selected status
* selected severity

The filtered list is computed with `useMemo` instead of being stored as duplicated state.

### Stable callbacks with `useCallback`

Actions such as loading incidents, starting investigation, adding notes, resolving incidents and handling statistic card clicks are wrapped with `useCallback` where useful.

### API isolation

HTTP calls are isolated in:

```txt
features/incidents/api/incidentApi.ts
```

The UI does not directly manage endpoint URLs.

### Custom hook

Incident loading logic is centralized in:

```txt
features/incidents/hooks/useIncidents.ts
```

The dashboard consumes a simple API:

```ts
const { incidents, stats, loading, error, reload } = useIncidents()
```

### Reusable badges

Status and severity rendering is isolated in:

```txt
components/badges/StatusBadge.tsx
components/badges/SeverityBadge.tsx
```

This avoids duplicated CSS and repeated conditional rendering.

### Error boundary

The application is wrapped in an `ErrorBoundary` to prevent a full white screen in case of unexpected rendering errors.

### Accessibility

The UI uses:

* semantic sections
* labels for filters
* buttons for clickable statistics
* `aria-label` for statistics and filters
* `aria-live` for action notifications

## Tests

The frontend uses Vitest and React Testing Library.

Current tested components:

* `IncidentStats`
* `IncidentFilters`
* `IncidentCard`
* `IncidentDashboardPage`

The tests validate user-visible behavior rather than implementation details.

## Commands

Install dependencies:

```bash
npm install
```

Start development server:

```bash
npm run dev
```

Run tests:

```bash
npm run test:run
```

Run build:

```bash
npm run build
```

Preview production build:

```bash
npm run preview
```

## Backend dependency

The frontend expects the Java incident service to be running.

Default API base URL is configured in:

```txt
src/shared/config/apiConfig.ts
```

Backend Swagger is available at:

```txt
http://localhost:8081/swagger-ui/index.html
```

## Next improvements

Possible next steps:

* Add tests for `IncidentDetailsPage`
* Add MSW for API mocking
* Add route-level error handling
* Add optimistic UI updates
* Add Angular practice frontend in `frontend/angular-rules-practice`
