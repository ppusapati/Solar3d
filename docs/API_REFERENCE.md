# Solar3D CAD Backbone — API Reference

This document covers the full API surface of the three CAD backbone services.
All RPC services use the [Connect protocol](https://connectrpc.com/docs/protocol)
and are callable over HTTP/1.1 or HTTP/2 as JSON (Content-Type: `application/json`)
or as Protobuf (Content-Type: `application/proto`).

The REST API exposed by `api-gateway-service` provides a JSON façade for the
most common client workflows.

---

## Table of Contents

1. [Service Endpoints](#service-endpoints)
2. [DrawingRevisionService (RPC)](#drawingrevisionservice)
3. [CadCoreService (RPC)](#cadcoreservice)
4. [API Gateway (REST)](#api-gateway-rest)
5. [Common Types](#common-types)
6. [Error Codes](#error-codes)

---

## Service Endpoints

| Service | Default Port | Protocol |
|---------|-------------|----------|
| `drawing-revision-service` | 8091 | ConnectRPC (HTTP/1.1 + HTTP/2) |
| `cad-core-service` | 8092 | ConnectRPC (HTTP/1.1 + HTTP/2) |
| `api-gateway-service` | 8090 | REST/JSON |

ConnectRPC URL pattern: `POST /{package}.{Service}/{Method}`

---

## DrawingRevisionService

Package: `drawing.v1`  
Base path: `/drawing.v1.DrawingRevisionService/`

Manages drawing metadata and immutable revision snapshots.  
Source of truth for all drawing entity state.

---

### CreateDrawing

`POST /drawing.v1.DrawingRevisionService/CreateDrawing`

Creates a new drawing and its empty initial revision.

**Request**

```json
{
  "project_id": "uuid",           // required — owning project
  "name":       "Floor Plan L1",  // required — human-readable name
  "description": "string",        // optional
  "metadata_json": "{}",          // optional — arbitrary JSON string
  "author":     "user@example.com", // required
  "contract": { ... }             // optional — ContractMetadata
}
```

**Response**

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

**Errors**

| Code | Condition |
|------|-----------|
| `invalid_argument` | `project_id` not a valid UUID, `name` empty, `author` empty, `metadata_json` not valid JSON |
| `internal` | DB write failure |

---

### GetDrawing

`POST /drawing.v1.DrawingRevisionService/GetDrawing`

Returns drawing metadata without materialising the entity snapshot.

**Request**

```json
{ "drawing_id": "uuid" }
```

**Response**

```json
{ "drawing": { Drawing } }
```

**Errors**

| Code | Condition |
|------|-----------|
| `invalid_argument` | `drawing_id` not a valid UUID |
| `not_found` | No drawing with the given ID |

---

### ListDrawings

`POST /drawing.v1.DrawingRevisionService/ListDrawings`

Returns drawings for a project in descending `updated_at` order.

**Request**

```json
{
  "project_id":        "uuid",
  "page_size":         20,    // default 20, max 200
  "page_token":        "",    // opaque cursor from previous response
  "include_archived":  false
}
```

**Response**

```json
{
  "drawings":        [ Drawing, ... ],
  "next_page_token": "string",   // empty string = no more pages
  "total_count":     42
}
```

---

### UpdateDrawing

`POST /drawing.v1.DrawingRevisionService/UpdateDrawing`

Updates mutable drawing fields. Only the fields supplied in the request are updated.

**Request**

```json
{
  "drawing_id":    "uuid",
  "name":          "string",         // optional
  "description":   "string",         // optional
  "metadata_json": "{}",             // optional
  "status":        "DRAWING_STATUS_ARCHIVED"  // optional — archive a drawing
}
```

**Response**

```json
{ "drawing": { Drawing } }
```

**Errors**

| Code | Condition |
|------|-----------|
| `not_found` | Drawing ID does not exist |
| `invalid_argument` | Malformed UUID |

---

### GetDrawingState

`POST /drawing.v1.DrawingRevisionService/GetDrawingState`

Returns a materialised entity snapshot for a specific revision (or current head if `revision_id` is omitted).

**Request**

```json
{
  "drawing_id":  "uuid",
  "revision_id": "uuid"  // optional — defaults to current head
}
```

**Response**

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }   // includes full entities array
}
```

---

### ListDrawingRevisions

`POST /drawing.v1.DrawingRevisionService/ListDrawingRevisions`

Returns revision pointers (no entity payload) in descending `committed_at` order.

**Request**

```json
{
  "drawing_id":  "uuid",
  "page_size":   20,
  "page_token":  ""
}
```

**Response**

```json
{
  "revisions":       [ RevisionPointer, ... ],
  "next_page_token": "",
  "total_count":     7
}
```

---

### GetDrawingRevision

`POST /drawing.v1.DrawingRevisionService/GetDrawingRevision`

Returns a specific immutable revision snapshot.

**Request**

```json
{
  "drawing_id":  "uuid",
  "revision_id": "uuid"   // required
}
```

**Response**

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

---

### StoreDrawingRevision

`POST /drawing.v1.DrawingRevisionService/StoreDrawingRevision`

Persists a new immutable entity snapshot and advances the drawing head.

**Request**

```json
{
  "drawing_id":  "uuid",
  "author":      "user@example.com",
  "summary":     "Added roof outline",
  "command_id":  "uuid",               // idempotency key — use a stable UUID per logical command
  "entities":    [ DrawingEntity, ... ],
  "contract":    { ContractMetadata }  // optional
}
```

**Response**

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

**Errors**

| Code | Condition |
|------|-----------|
| `invalid_argument` | Missing `drawing_id`, `author`, or `entities` |
| `not_found` | Drawing does not exist |
| `already_exists` | `command_id` already recorded for this drawing (idempotency guard) |

> **Idempotency**: Supplying the same `command_id` twice returns `already_exists`.
> Callers should use a stable UUID (e.g. derived from the user action event ID)
> and handle `already_exists` as a success.

---

## CadCoreService

Package: `drawing.v1`  
Base path: `/drawing.v1.CadCoreService/`

Validates and applies drawing commands on top of the revision store.
Stateless — delegates all writes to `drawing-revision-service`.

---

### ValidateDrawingCommand

`POST /drawing.v1.CadCoreService/ValidateDrawingCommand`

Validates a command against a drawing revision without persisting anything.

**Request**

```json
{
  "command": {
    "command_id":  "uuid",
    "drawing_id":  "uuid",
    "actor":       "user@example.com",
    "mutations": [
      {
        "action":    "REVISION_ACTION_CREATE",
        "entity_id": "uuid",
        "before":    null,
        "after":     { DrawingEntity }
      }
    ],
    "issued_at": "2026-03-31T12:00:00Z"
  },
  "base_revision_id": "uuid"   // revision to validate against
}
```

**Response**

```json
{
  "valid":               true,
  "violations":          [],
  "resulting_entities":  [ DrawingEntity, ... ]
}
```

`resulting_entities` is the projected entity list after applying the command —
useful for pre-flight preview on the client.

---

### CommitDrawingCommand

`POST /drawing.v1.CadCoreService/CommitDrawingCommand`

Validates and persists a command as a new drawing revision.

**Request**

```json
{
  "command": { DrawingCommand },
  "base_revision_id": "uuid",
  "summary": "User-visible description of the change"
}
```

**Response**

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

**Errors**

| Code | Condition |
|------|-----------|
| `invalid_argument` | Validation violations exist (see `ValidateDrawingCommand`) |
| `failed_precondition` | `base_revision_id` is no longer the head (stale — client must re-fetch) |
| `not_found` | Drawing does not exist |

---

### RevertDrawingRevision

`POST /drawing.v1.CadCoreService/RevertDrawingRevision`

Promotes a previous revision snapshot as the new drawing head (non-destructive undo).

**Request**

```json
{
  "drawing_id":         "uuid",
  "target_revision_id": "uuid",
  "author":             "user@example.com",
  "summary":            "Reverted to revision before roof changes"
}
```

**Response**

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }   // new head revision containing the old snapshot
}
```

---

## API Gateway (REST)

Base URL: `http://api-gateway-service:8090`

The gateway composes responses from `project-service`, `drawing-revision-service`, and `cad-core-service` into ergonomic REST endpoints for frontend and mobile clients.

All responses are JSON. All request bodies are JSON.

---

### GET /healthz

Returns service health and downstream connectivity status.

**Response** `200 OK`

```json
{
  "status": "ok",
  "downstream": {
    "project-service":          { "status": "ok" },
    "drawing-revision-service": { "status": "ok" },
    "cad-core-service":         { "status": "ok" }
  }
}
```

If any downstream is unhealthy, the `status` field for that service will be `"error"`.
The gateway itself returns `200` — the caller must inspect `downstream` entries.

---

### GET /api/v1/workspace/projects/{projectID}

Returns project metadata and all active drawings for the project.

**Path parameters**

| Name | Type | Description |
|------|------|-------------|
| `projectID` | UUID | Project identifier |

**Response** `200 OK`

```json
{
  "project":     { Project },
  "drawings":    [ Drawing, ... ],
  "total_count": 3
}
```

---

### GET /api/v1/workspace/drawings/{drawingID}

Returns the full drawing workspace: project context, drawing metadata, current revision state, and recent revision history.

**Response** `200 OK`

```json
{
  "project":   { Project },
  "drawing":   { Drawing },
  "revision":  { DrawingRevision },
  "revisions": [ RevisionPointer, ... ]
}
```

---

### POST /api/v1/workspace/projects/{projectID}/drawings

Creates a new drawing under the project.

**Request body**

```json
{
  "name":        "Site Plan",
  "description": "string",
  "author":      "user@example.com"
}
```

**Response** `201 Created`

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

---

### PATCH /api/v1/workspace/drawings/{drawingID}

Updates mutable drawing fields.

**Request body** (all fields optional)

```json
{
  "name":        "Renamed Plan",
  "description": "string",
  "status":      "DRAWING_STATUS_ARCHIVED"
}
```

**Response** `200 OK`

```json
{ "drawing": { Drawing } }
```

---

### POST /api/v1/workspace/drawings/{drawingID}/commands

Commits a drawing command (validate + persist).

**Request body**

```json
{
  "command_id":       "uuid",
  "base_revision_id": "uuid",
  "summary":          "string",
  "mutations": [
    {
      "action":    "REVISION_ACTION_CREATE",
      "entity_id": "uuid",
      "after":     { DrawingEntity }
    }
  ]
}
```

**Response** `200 OK`

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

**Error** `409 Conflict` — stale `base_revision_id` (client must re-fetch head).

---

### POST /api/v1/workspace/drawings/{drawingID}/revert

Reverts to a previous revision.

**Request body**

```json
{
  "target_revision_id": "uuid",
  "author":             "user@example.com",
  "summary":            "Undo last change"
}
```

**Response** `200 OK`

```json
{
  "drawing":  { Drawing },
  "revision": { DrawingRevision }
}
```

---

## Common Types

### Drawing

```json
{
  "drawing_id":          "uuid",
  "project_id":          "uuid",
  "name":                "string",
  "description":         "string",
  "metadata_json":       "{}",
  "status":              "DRAWING_STATUS_ACTIVE",
  "current_revision_id": "uuid",
  "revision_count":      3,
  "entity_count":        47,
  "created_at":          "2026-01-15T10:00:00Z",
  "updated_at":          "2026-03-31T09:30:00Z",
  "contract":            { ContractMetadata }
}
```

`status` values: `DRAWING_STATUS_ACTIVE`, `DRAWING_STATUS_ARCHIVED`

---

### DrawingRevision

```json
{
  "pointer":    { RevisionPointer },
  "drawing_id": "uuid",
  "command_id": "uuid",
  "entities":   [ DrawingEntity, ... ]
}
```

---

### RevisionPointer

```json
{
  "revision_id":        "uuid",
  "parent_revision_id": "uuid",
  "author":             "user@example.com",
  "summary":            "Added roof outline",
  "committed_at":       "2026-03-31T09:30:00Z",
  "contract":           { ContractMetadata }
}
```

---

### DrawingEntity

```json
{
  "header": {
    "entity_id":   "uuid",
    "drawing_id":  "uuid",
    "entity_type": "DRAWING_ENTITY_TYPE_POLYLINE",
    "layer":       { "layer_id": "L1", "layer_name": "Walls" },
    "style":       { "style_id": "S1", "style_name": "Default" },
    "created_at":  "2026-03-31T09:30:00Z",
    "updated_at":  "2026-03-31T09:30:00Z"
  },
  "polyline": {
    "vertices": [ { "x": 0.0, "y": 0.0 }, { "x": 10.0, "y": 0.0 } ],
    "closed":   false
  }
}
```

`entity_type` values: `POLYLINE`, `POLYGON`, `TEXT`, `DIMENSION`, `BLOCK_REFERENCE`

The `geometry` field is a oneof — only one of `polyline`, `polygon`, `text`, `dimension`, `block_reference` will be present.

---

### DrawingMutation

```json
{
  "action":    "REVISION_ACTION_CREATE",
  "entity_id": "uuid",
  "before":    null,
  "after":     { DrawingEntity }
}
```

`action` values: `REVISION_ACTION_CREATE`, `REVISION_ACTION_UPDATE`, `REVISION_ACTION_DELETE`

---

## Error Codes

All ConnectRPC errors follow the [Connect error model](https://connectrpc.com/docs/protocol/#error-codes).

| Connect code | HTTP status | Condition |
|---|---|---|
| `invalid_argument` | 400 | Missing required field, malformed UUID, empty string for required field |
| `not_found` | 404 | Resource ID does not exist |
| `already_exists` | 409 | Duplicate `command_id` (idempotency conflict) |
| `failed_precondition` | 409 | Stale `base_revision_id` — re-fetch the drawing and retry |
| `internal` | 500 | Unexpected server or database error |

REST gateway errors:

| HTTP status | Condition |
|---|---|
| 400 | Malformed request body or invalid UUID in path |
| 404 | Drawing or project not found |
| 409 | Command conflict (stale revision or duplicate command) |
| 502 | Downstream service unreachable |
| 500 | Internal gateway error |
