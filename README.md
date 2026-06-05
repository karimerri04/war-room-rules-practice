# War Room Rules Practice

Training project designed to practice Java, Spring Boot, React, Angular, Flutter and Python through a technical incident resolution dashboard and supporting automation tools.

The goal is not to display isolated rules as quiz content. The goal is to apply programming, architecture, automation and testing rules directly in real code.

## Project overview

The application simulates a technical incident resolution workflow.

It contains:

- a Java Spring Boot backend acting as the source of truth
- a React frontend implementing the incident dashboard with React idioms
- an Angular frontend implementing the same domain with Angular idioms
- a Flutter frontend implementing the same domain with Flutter and Dart idioms
- a Python CLI tool for analyzing backend incidents and generating reports
- Postman collections for manual API testing
- documentation explaining architecture, API and learning objectives

## Repository structure

```txt
war-room-rules-practice/
├── backend/
│   └── java-incident-service/
├── frontend/
│   ├── react-rules-practice/
│   ├── angular-rules-practice/
│   └── flutter-rules-practice/
├── tools/
│   └── python-incident-analyzer/
├── postman/
├── docs/
│   ├── api.md
│   ├── architecture.md
│   ├── backend-java-rules.md
│   ├── frontend-react-rules.md
│   ├── frontend-angular-rules.md
│   ├── frontend-flutter-rules.md
│   └── python-incident-analyzer-rules.md
├── README.md
└── docker-compose.yml
```

## Backend

Location:

```txt
backend/java-incident-service
```

Stack:

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

The backend exposes REST endpoints for:

- listing incidents
- loading incident details
- reading incident statistics
- starting an investigation
- adding investigation notes
- resolving an incident

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

- component composition
- hooks
- custom hooks
- lifted state
- `useMemo`
- `useCallback`
- React Router
- reusable UI components
- Error Boundary
- Vitest
- React Testing Library

## Angular frontend

Location:

```txt
frontend/angular-rules-practice
```

The Angular frontend practices:

- standalone components
- Angular Router
- services
- HttpClient
- RxJS
- signals
- reactive forms
- inputs and outputs
- feature-based architecture
- Angular component tests

## Flutter frontend

Location:

```txt
frontend/flutter-rules-practice
```

The Flutter frontend practices:

- Dart models and enums
- Material 3 widgets
- feature-based architecture
- `go_router`
- Provider
- ChangeNotifier
- HTTP API access
- loading, error, empty and success states
- pure Dart filtering logic
- unit tests
- widget tests

## Python Incident Analyzer

Location:

```txt
tools/python-incident-analyzer
```

The Python tool practices:

- virtual environments
- Python packaging with `pyproject.toml`
- argparse CLI
- requests
- dataclasses
- StrEnum
- pathlib
- JSON report generation
- CSV report generation
- Markdown report generation
- pytest
- ruff

The tool consumes the Java backend and generates incident analysis reports.

It is not a backend service. It is an automation and reporting tool.

Run analysis:

```bash
cd tools/python-incident-analyzer
source .venv/Scripts/activate
incident-analyzer analyze --output reports
```

Generated reports:

```txt
reports/incident-summary.json
reports/incident-summary.csv
reports/incident-summary.md
```

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

## Running the Flutter frontend

From:

```bash
cd frontend/flutter-rules-practice
```

Install dependencies:

```bash
flutter pub get
```

Start development server on Chrome:

```bash
flutter run -d chrome
```

Run tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

## Running the Python Incident Analyzer

From:

```bash
cd tools/python-incident-analyzer
```

Create and activate a virtual environment:

```bash
python -m venv .venv
source .venv/Scripts/activate
```

Install the project with development dependencies:

```bash
python -m pip install --upgrade pip
python -m pip install -e ".[dev]"
```

Run analysis:

```bash
incident-analyzer analyze --output reports
```

Run tests and lint:

```bash
pytest
ruff check .
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
6. `docs/frontend-flutter-rules.md`
7. `docs/python-incident-analyzer-rules.md`

## Learning objective

This project demonstrates how the same incident-resolution domain can be implemented across different layers, frontend frameworks and supporting automation tools.

The backend focuses on Java, Spring Boot, REST, domain modeling and tests.

The React frontend focuses on hooks, component composition and user-driven behavior.

The Angular frontend focuses on standalone components, services, signals, RxJS and reactive forms.

The Flutter frontend focuses on widgets, Dart models, Provider, ChangeNotifier, go_router, testable filtering logic and widget tests.

The Python Incident Analyzer focuses on automation, API consumption, data parsing, analysis, report generation, pytest and linting with ruff.
