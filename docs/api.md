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
