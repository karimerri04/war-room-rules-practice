# Backend Java Rules Practiced

## Goal

The backend is designed to practice Java and Spring Boot rules through a real incident-resolution service.

The focus is not only on making endpoints work, but on building code that is structured, testable and explainable.

## Stack

- Java 21
- Spring Boot
- Spring Web MVC
- Spring Validation
- Spring Actuator
- Springdoc OpenAPI / Swagger
- Lombok
- JUnit 5
- MockMvc
- In-memory repository

## Rules practiced

### Domain-first modeling

The backend models the business domain explicitly.

Core concepts:

- `Incident`
- `IncidentId`
- `InvestigationNote`
- `IncidentStatus`
- `IncidentSeverity`

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

- `FindAllIncidentsUseCase`
- `FindIncidentByIdUseCase`
- `GetIncidentStatsUseCase`
- `StartIncidentInvestigationUseCase`
- `AddIncidentNoteUseCase`
- `ResolveIncidentUseCase`

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

- `IncidentResponse`
- `IncidentStatsResponse`
- `InvestigationNoteResponse`
- `AddIncidentNoteRequest`
- `ResolveIncidentRequest`

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

- `IncidentTest`
- `IncidentIdTest`
- `InvestigationNoteTest`
- `InMemoryIncidentRepositoryTest`

These tests verify behavior below the HTTP layer.

## Interview talking points

This backend shows:

- clean separation between API, application and domain logic
- domain-driven thinking without unnecessary complexity
- testable use-case design
- replaceable persistence
- structured error handling
- REST API documentation with Swagger
- meaningful tests beyond superficial controller checks
