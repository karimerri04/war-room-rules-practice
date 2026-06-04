# FILE: README.md

# War Room Rules Practice

Training project designed to practice Java, Spring Boot, React and Angular through a technical incident resolution dashboard.

The goal is not to display isolated rules as quiz content. The goal is to apply programming, architecture and testing rules directly in real code.

## Project overview

The application simulates a technical incident resolution workflow.

It contains:

* a Java Spring Boot backend acting as the source of truth
* a React frontend implementing the incident dashboard with React idioms
* an Angular frontend implementing the same domain with Angular idioms
* Postman collections for manual API testing
* documentation explaining architecture, API and learning objectives

## Repository structure

```txt
war-room-rules-practice/
├── backend/
│   └── java-incident-service/
├── frontend/
│   ├── react-rules-practice/
│   └── angular-rules-practice/
├── postman/
├── docs/
│   ├── api.md
│   ├── architecture.md
│   ├── backend-java-rules.md
│   ├── frontend-react-rules.md
│   └── frontend-angular-rules.md
├── README.md
└── docker-compose.yml
```

## Backend

Location:

```txt
backend/java-incident-service
```

Stack:

* Java 21
* Spring Boot
* Spring Web MVC
* Spring Validation
* Spring Actuator
* Springdoc OpenAPI / Swagger
* Lombok
* JUnit 5
* MockMvc
* In-memory repository

The backend exposes REST endpoints for:

* listing incidents
* loading incident details
* reading incident statistics
* starting an investigation
* adding investigation notes
* resolving an incident

Swagger is available at:

```txt
http://localhost:8081/swagger-ui/index.html
```

## React frontend

Location:

```txt
frontend/react-rules-practice
```

The React frontend practices:

* component composition
* hooks
* custom hooks
* lifted state
* `useMemo`
* `useCallback`
* React Router
* reusable UI components
* Error Boundary
* Vitest
* React Testing Library

## Angular frontend

Location:

```txt
frontend/angular-rules-practice
```

The Angular frontend practices:

* standalone components
* Angular Router
* services
* HttpClient
* RxJS
* signals
* reactive forms
* inputs and outputs
* feature-based architecture
* Angular component tests

## Postman

Location:

```txt
postman/
```

The Postman folder contains:

```txt
War-Room-Rules-Practice.postman_collection.json
War-Room-Local.postman_environment.json
```

These files can be imported into Postman to test the backend API manually.

## Running the backend

From:

```bash
cd backend/java-incident-service
```

Run:

```bash
./mvnw spring-boot:run
```

On Windows:

```bash
mvnw spring-boot:run
```

Backend base URL:

```txt
http://localhost:8081/api/java-incidents
```

## Running the React frontend

From:

```bash
cd frontend/react-rules-practice
```

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

## Running the Angular frontend

From:

```bash
cd frontend/angular-rules-practice
```

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

## Documentation

Global documentation is available under:

```txt
docs/
```

Recommended reading order:

1. `docs/architecture.md`
2. `docs/api.md`
3. `docs/backend-java-rules.md`
4. `docs/frontend-react-rules.md`
5. `docs/frontend-angular-rules.md`

## Learning objective

This project demonstrates how the same incident-resolution domain can be implemented across different layers and frontend frameworks.

The backend focuses on Java, Spring Boot, REST, domain modeling and tests.

The React frontend focuses on hooks, component composition and user-driven behavior.

The Angular frontend focuses on standalone components, services, signals, RxJS and reactive forms.

# FILE: docs/architecture.md

# Architecture

## Goal

`war-room-rules-practice` is a training project built around a technical incident resolution dashboard.

The purpose is to practice architecture and framework rules through realistic code.

The project deliberately avoids quiz-style rule display. Instead, each rule is applied inside a working application.

## High-level architecture

```txt
React frontend   ┐
                 ├── HTTP REST ── Java Spring Boot backend
Angular frontend ┘
```

The Java backend is the source of truth.

The React and Angular applications are two independent frontend implementations of the same domain.

They are not backend services.

## Repository layout

```txt
war-room-rules-practice/
├── backend/
│   └── java-incident-service/
├── frontend/
│   ├── react-rules-practice/
│   └── angular-rules-practice/
├── postman/
├── docs/
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

## Design principles

### One backend source of truth

The backend owns incident state.

React and Angular consume the same backend API.

### Framework-specific frontends

React and Angular solve the same business problem using their own idioms.

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

### Feature-based organization

Incident-related code is grouped under the incident feature in both frontends.

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

## Why this architecture is useful

This project is useful for interview preparation because it shows:

* REST API design
* Spring Boot application structure
* frontend architecture in React and Angular
* clean separation of concerns
* practical testing strategy
* ability to explain technical decisions

# FILE: docs/api.md

# API Documentation

## Base URL

```txt
http://localhost:8081/api/java-incidents
```

## Swagger

Swagger UI is available at:

```txt
http://localhost:8081/swagger-ui/index.html
```

## Endpoints

### Health check

```http
GET /api/java-incidents/health
```

Returns a basic health response for the incident service.

### List incidents

```http
GET /api/java-incidents
```

Returns all incidents.

Response body:

```json
[
  {
    "id": "INC-001",
    "title": "Kafka consumer lag is increasing",
    "description": "The payment consumer group is not processing messages fast enough.",
    "severity": "HIGH",
    "status": "OPEN",
    "symptoms": [],
    "rootCause": "",
    "resolution": "",
    "createdAt": "2026-06-04T10:00:00Z",
    "resolvedAt": null,
    "notes": []
  }
]
```

### Find incident by id

```http
GET /api/java-incidents/{id}
```

Example:

```http
GET /api/java-incidents/INC-001
```

Returns one incident.

If the incident does not exist, the API returns a structured error response.

### Get incident statistics

```http
GET /api/java-incidents/stats
```

Returns aggregated dashboard statistics.

Response body:

```json
{
  "total": 8,
  "open": 2,
  "investigating": 1,
  "resolved": 3,
  "critical": 1,
  "high": 2,
  "medium": 3,
  "low": 2
}
```

### Start investigation

```http
PATCH /api/java-incidents/{id}/start-investigation
```

Example:

```http
PATCH /api/java-incidents/INC-001/start-investigation
```

Moves an incident from `OPEN` to `INVESTIGATING`.

If the incident is already resolved or cannot transition, the backend handles the rule according to the domain behavior.

### Add investigation note

```http
POST /api/java-incidents/{id}/notes
```

Request body:

```json
{
  "author": "Karim",
  "message": "Initial investigation started."
}
```

Returns the updated incident with the new note.

### Resolve incident

```http
PATCH /api/java-incidents/{id}/resolve
```

Request body:

```json
{
  "rootCause": "Consumer group was under-provisioned.",
  "resolution": "Increased consumer instances and tuned batch settings."
}
```

Returns the resolved incident.

## Error handling

The backend exposes structured error responses.

General shape:

```json
{
  "timestamp": "2026-06-04T10:00:00Z",
  "status": 404,
  "error": "Not Found",
  "message": "Incident not found",
  "path": "/api/java-incidents/INC-999"
}
```

## Postman

Postman files are available under:

```txt
postman/
```

Files:

```txt
War-Room-Rules-Practice.postman_collection.json
War-Room-Local.postman_environment.json
```

Recommended usage:

1. Import the collection.
2. Import the local environment.
3. Start the backend.
4. Run requests from top to bottom.

# FILE: docs/backend-java-rules.md

# Backend Java Rules Practiced

## Goal

The backend is designed to practice Java and Spring Boot rules through a real incident-resolution service.

The focus is not only on making endpoints work, but on building code that is structured, testable and explainable.

## Stack

* Java 21
* Spring Boot
* Spring Web MVC
* Spring Validation
* Spring Actuator
* Springdoc OpenAPI / Swagger
* Lombok
* JUnit 5
* MockMvc
* In-memory repository

## Rules practiced

### Domain-first modeling

The backend models the business domain explicitly.

Core concepts:

* `Incident`
* `IncidentId`
* `InvestigationNote`
* `IncidentStatus`
* `IncidentSeverity`

The domain is not represented as loose maps or generic DTOs.

### Value object for identity

`IncidentId` represents incident identity as a dedicated concept.

This improves type safety and keeps validation close to the value.

### Enum-based state

Incident status and severity are represented with enums.

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

This prevents invalid string values and makes state transitions easier to reason about.

### Use case separation

Application behavior is implemented through use cases.

Examples:

* `FindAllIncidentsUseCase`
* `FindIncidentByIdUseCase`
* `GetIncidentStatsUseCase`
* `StartIncidentInvestigationUseCase`
* `AddIncidentNoteUseCase`
* `ResolveIncidentUseCase`

This avoids putting business logic directly in controllers.

### Repository port

The domain/application layer depends on an `IncidentRepository` port.

The current implementation is in memory:

```txt
InMemoryIncidentRepository
```

This keeps persistence replaceable.

A database implementation could be added later without changing controller or use-case logic.

### DTO boundary

The API exposes response and request DTOs.

Examples:

* `IncidentResponse`
* `IncidentStatsResponse`
* `InvestigationNoteResponse`
* `AddIncidentNoteRequest`
* `ResolveIncidentRequest`

DTOs prevent direct exposure of internal domain objects.

### Mapper responsibility

`IncidentMapper` converts domain objects into API DTOs.

This keeps controller code focused on HTTP concerns.

### Centralized error handling

`GlobalExceptionHandler` handles API errors consistently.

`IncidentNotFoundException` is mapped into a structured response.

This avoids duplicating try/catch blocks in every controller method.

### Validation

Request objects are validated using Spring validation annotations.

This protects the application from invalid input at the boundary.

### MockMvc controller tests

`IncidentControllerMockMvcTest` validates the REST API behavior through Spring MVC.

This gives confidence that routes, status codes and JSON responses work as expected.

### Domain and repository tests

The backend also contains tests for:

* `IncidentTest`
* `IncidentIdTest`
* `InvestigationNoteTest`
* `InMemoryIncidentRepositoryTest`

These tests verify behavior below the HTTP layer.

## Interview talking points

This backend shows:

* clean separation between API, application and domain logic
* domain-driven thinking without unnecessary complexity
* testable use-case design
* replaceable persistence
* structured error handling
* REST API documentation with Swagger
* meaningful tests beyond superficial controller checks

# FILE: docs/frontend-react-rules.md

# Frontend React Rules Practiced

## Goal

The React frontend practices React and TypeScript rules inside a realistic incident dashboard.

The objective is not to memorize rules, but to apply them in working UI code.

## Stack

* React
* TypeScript
* Vite
* React Router
* CSS by feature
* Vitest
* React Testing Library
* Testing Library User Event

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

* `IncidentStats`
* `IncidentFilters`
* `IncidentList`
* `IncidentCard`
* `StatusBadge`
* `SeverityBadge`

Each component has a clear responsibility.

### State lifting

Filter state is owned by `IncidentDashboardPage`.

Child components receive values and callbacks through props.

This keeps state predictable and avoids duplicated state.

### Derived state with `useMemo`

Filtered incidents are derived from:

* all incidents
* selected status
* selected severity

The filtered list is computed with `useMemo`.

It is not stored as separate state.

### Stable callbacks with `useCallback`

Important callbacks are wrapped with `useCallback` where useful.

Examples:

* loading incidents
* starting investigation
* adding notes
* resolving incidents
* handling statistic card clicks

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

* default redirect
* incident dashboard
* incident details page

Routes:

```txt
/
 /incidents
 /incidents/:id
```

### Accessibility

The UI uses:

* semantic sections
* labels for filters
* buttons for clickable statistics
* `aria-label`
* `aria-live` for action notifications

### Testing

The React frontend includes tests for:

* `IncidentStats`
* `IncidentFilters`
* `IncidentCard`
* `IncidentDashboardPage`

Tests focus on user-visible behavior.

Examples:

* clicking `Open` filters the dashboard
* clicking `Critical` filters by severity
* clicking `Total` resets filters
* cards render links to details pages

## Interview talking points

This React frontend shows:

* feature-based organization
* controlled filters
* reusable components
* lifted state
* derived state
* router usage
* Error Boundary usage
* practical frontend tests

# FILE: docs/frontend-angular-rules.md

# Frontend Angular Rules Practiced

## Goal

The Angular frontend practices Angular and TypeScript rules inside the same incident-resolution domain as the React frontend.

The goal is to show how the same workflow can be implemented using Angular idioms.

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

Incident code is isolated under:

```txt
features/incidents/
```

The feature contains:

* data access
* models
* pages
* UI components
* utilities

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

* selected status
* selected severity
* selected incident
* loading
* action loading
* error
* notification

### RxJS for async loading

RxJS is used to combine and transform async data.

The dashboard uses `combineLatest`.

The details page uses:

* route `paramMap`
* `switchMap`
* `tap`
* `catchError`

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

* adding investigation notes
* resolving incidents

Validation is explicit with validators and `markAllAsTouched()`.

### Routing

Angular Router defines:

* dashboard route
* details route
* redirect from root

in:

```txt
app.routes.ts
```

### Accessibility

The UI uses:

* semantic sections
* labels for filters
* clickable statistics as buttons
* `aria-label`
* `aria-live`
* `role="list"`
* `role="listitem"`

### Testing

The Angular frontend includes component tests for:

* `AppComponent`
* `StatusBadgeComponent`
* `SeverityBadgeComponent`
* `IncidentStatsComponent`
* `IncidentFiltersComponent`
* `IncidentCardComponent`

Tests validate:

* rendering
* labels
* CSS classes
* input values
* output events
* router links

## Interview talking points

This Angular frontend shows:

* standalone Angular architecture
* service-based data access
* signal-based UI state
* RxJS async composition
* reactive forms
* reusable presentational components
* component testing
* clear separation between smart pages and UI components
