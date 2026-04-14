# Solar3D Services - Quick Reference Guide

A concise developer guide for integrating with upgraded solar3D services. All services follow the same patterns and share finalized proto contracts.

---

## Table of Contents

1. [Common Patterns](#common-patterns)
2. [Service Endpoints](#service-endpoints)
3. [Authentication & Headers](#authentication--headers)
4. [Trace ID & Request Correlation](#trace-id--request-correlation)
5. [Idempotent Operations](#idempotent-operations)
6. [Long-Running Jobs](#long-running-jobs)
7. [Error Handling](#error-handling)
8. [Service-Specific Examples](#service-specific-examples)

---

## Common Patterns

### Request Format
All services follow this HTTP API structure:

```
POST /api/v1/{resource}
GET /api/v1/{resource}/{id}
PUT /api/v1/{resource}/{id}
DELETE /api/v1/{resource}/{id}
```

### Response Format (Success)
```json
{
  "data": { /* resource */ },
  "metadata": {
    "trace_id": "abc-def-ghi",
    "request_id": "req-123",
    "timestamp": "2024-03-30T15:00:00Z"
  }
}
```

### Response Format (Error)
```json
{
  "error": {
    "code": "INVALID_INPUT",
    "message": "Project name required",
    "details": "Expected field 'name' in request body",
    "trace_id": "abc-def-ghi"
  }
}
```

---

## Service Endpoints

| Service | Port | Base URL | Primary Operations |
|---------|------|----------|-------------------|
| **Project** | 8001 | `http://localhost:8001` | Create, update, list projects |
| **Terrain** | 8002 | `http://localhost:8002` | Query elevation, contours |
| **Layout** | 8003 | `http://localhost:8003` | Generate tiles, panel arrays |
| **Simulation** | 8004 | `http://localhost:8004` | Run solar yield simulations |
| **Electrical** | 8005 | `http://localhost:8005` | Validate network, cable sizing |
| **Routing** | 8006 | `http://localhost:8006` | Find optimal cable paths |
| **Report** | 8007 | `http://localhost:8007` | Generate, version reports |
| **Orchestration** | 9000 | `http://localhost:9000` | Submit/monitor long-running jobs |

---

## Authentication & Headers

### Required Headers

```http
X-Trace-ID: [uuid or string]
  Purpose: Trace request across services
  Format: Any string; recommended UUID4 or "{service}-{timestamp}"
  Example: "abc-123-def"

X-Request-ID: [uuid]
  Purpose: Unique request identifier
  Format: UUID4
  Example: "f47ac10b-58cc-4372-a567-0e02b2c3d479"

X-Actor-ID: [string]
  Purpose: Identify user/actor for audit logging
  Format: User ID, email, or service principal name
  Example: "user-123" or "batch-processor"

Content-Type: application/json
  Purpose: Specify JSON payload (required for POST/PUT)
```

### Optional Headers

```http
Idempotency-Key: [string]
  Purpose: Enable safe retries for create/update operations
  Format: Any unique string per logical operation
  Example: "project-alpha-2024-q1"
  Note: Required for: CreateProject, CreateAsset, SubmitSimulation

Accept-Encoding: gzip, deflate
  Purpose: Request compression (optional for bandwidth savings)

User-Agent: [string]
  Purpose: Identify client (recommended for debugging)
  Example: "solar3d-portal/1.0"
```

---

## Trace ID & Request Correlation

### Goal
Correlate logs and spans across all microservices using a single trace ID.

### Using Trace IDs

**JavaScript/TypeScript:**
```typescript
import { v4 as uuidv4 } from 'uuid';

const traceId = uuidv4();

async function queryServices(projectId: string) {
  const headers = {
    'X-Trace-ID': traceId,
    'X-Actor-ID': 'user-123',
  };

  // All requests use the same trace ID
  const project = await fetch(`http://localhost:8001/api/v1/projects/${projectId}`, { headers });
  const terrain = await fetch(`http://localhost:8002/api/v1/terrain/grid`, { headers });
  const layout = await fetch(`http://localhost:8003/api/v1/layouts/generate`, { headers });
  
  // All requests are correlated in logs under this single trace ID
}
```

**Go:**
```go
package main

import (
	"context"
	"github.com/google/uuid"
	"net/http"
)

func queryServices(ctx context.Context, projectID string) {
	traceID := uuid.New().String()
	
	// Create HTTP client with trace ID middleware
	client := &http.Client{
		Transport: &TraceIDTransport{
			TraceID: traceID,
			RoundTripper: http.DefaultTransport,
		},
	}
	
	// All requests automatically include X-Trace-ID header
	req, _ := http.NewRequestWithContext(ctx, "GET", "http://localhost:8001/api/v1/projects/"+projectID, nil)
	resp, _ := client.Do(req)
	
	// Response echoes back trace ID for verification
	responseTraceID := resp.Header.Get("X-Trace-ID")
	// responseTraceID == traceID ✓
}
```

**cURL:**
```bash
TRACE_ID=$(uuidgen)  # Generate UUID
PROJECT_ID="proj-123"

# Request 1: Create project with trace ID
curl -X POST http://localhost:8001/api/v1/projects \
  -H "X-Trace-ID: $TRACE_ID" \
  -H "X-Actor-ID: user-123" \
  -H "Idempotency-Key: create-proj-alpha" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Solar Farm Alpha",
    "location": {"latitude": 37.5, "longitude": -120.5},
    "capacity": 5.0
  }'

# Request 2: Query terrain with same trace ID
curl -X GET "http://localhost:8002/api/v1/terrain/grid?lat1=37.4&lat2=37.6&lon1=-120.6&lon2=-120.4" \
  -H "X-Trace-ID: $TRACE_ID"

# All logs are now correlated under the same trace ID
```

### Viewing Correlated Logs

In your centralized logging system (ELK, Datadog, etc.):

```
Filter by: trace_id = "abc-123-def"

Results:
  [project-service] 2024-03-30T15:00:01Z [project-service] POST /api/v1/projects trace_id=abc-123-def
  [terrain-service] 2024-03-30T15:00:02Z [terrain-service] GET /api/v1/terrain/grid trace_id=abc-123-def
  [layout-service] 2024-03-30T15:00:03Z [layout-service] POST /api/v1/layouts/generate trace_id=abc-123-def
  
// Full lifecycle of request visible in single query ✓
```

---

## Idempotent Operations

### Goal
Enable safe retries for network failures without duplicating operations.

### Idempotency-Key Pattern

**Problem:** If project creation times out, you don't know if it succeeded:
```javascript
// Client times out after 5s
POST /api/v1/projects (timeout after 5s)
// Did the project get created? Unknown...
// If you retry and it gets created again, now you have 2 projects!
```

**Solution:** Use Idempotency-Key header:
```javascript
const idempotencyKey = "create-project-alpha-2024";

// Request 1: Project creation (times out)
POST /api/v1/projects
  Header: Idempotency-Key: create-project-alpha-2024
  → Timeout after 5s

// Request 2: Retry with SAME idempotency key
POST /api/v1/projects
  Header: Idempotency-Key: create-project-alpha-2024
  → Server recognizes this is a retry of the same logical operation
  → Returns the SAME project that was created in Request 1
  → No duplicate project created ✓
```

### Operations Supporting Idempotency

| Service | Operation | Example |
|---------|-----------|---------|
| **Project** | CreateProject | `POST /api/v1/projects` |
| **Project** | UpdateProject | `PUT /api/v1/projects/{id}` |
| **Asset** | CreateAsset | `POST /api/v1/assets` |
| **Asset** | VersionAsset | `POST /api/v1/assets/{id}/version` |
| **Simulation** | SubmitSimulation | `POST /api/v1/simulations` |
| **Report** | GenerateReport | `POST /api/v1/reports/generate` |

### Example: Idempotent Project Creation

**Go:**
```go
package main

import (
	"context"
	"fmt"
	"github.com/google/uuid"
	"net/http"
)

func createProjectIdempotently(ctx context.Context, projectName string) (projectID string, err error) {
	// Generate deterministic idempotency key based on project name
	idempotencyKey := "create-" + projectName
	
	// Create project
	req, _ := http.NewRequestWithContext(ctx, "POST", "http://localhost:8001/api/v1/projects", nil)
	req.Header.Set("Idempotency-Key", idempotencyKey)
	req.Header.Set("X-Trace-ID", uuid.New().String())
	req.Header.Set("X-Actor-ID", "user-123")
	
	client := &http.Client{}
	resp, _ := client.Do(req)
	defer resp.Body.Close()
	
	// Extract project ID from response
	// ... parse JSON ...
	
	return projectID, nil
}

// Usage:
projectID, _ := createProjectIdempotently(ctx, "Solar Farm Alpha")
// Safe to call multiple times—always returns same project ID
_ = createProjectIdempotently(ctx, "Solar Farm Alpha")  // Returns same project ID
_ = createProjectIdempotently(ctx, "Solar Farm Alpha")  // Returns same project ID
```

**JavaScript:**
```javascript
async function createProjectIdempotently(projectName) {
  const idempotencyKey = `create-${projectName}`;
  
  const response = await fetch('http://localhost:8001/api/v1/projects', {
    method: 'POST',
    headers: {
      'Idempotency-Key': idempotencyKey,
      'X-Trace-ID': crypto.randomUUID(),
      'X-Actor-ID': 'user-123',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: projectName,
      location: { latitude: 37.5, longitude: -120.5 },
      capacity: 5.0,
    }),
  });
  
  const data = await response.json();
  return data.data.id;  // Always returns same ID if called with same idempotency key
}
```

---

## Long-Running Jobs

### Goal
Submit work that takes >1 minute to complete (e.g., large simulations, routing optimization) without blocking the HTTP request.

### When to Use Orchestration

- ✓ Simulation for 1000+ tiles (10+ seconds)
- ✓ Routing optimization for 500+ nodes (30+ seconds)
- ✓ Terrain processing for 10,000+ elevation points (5+ seconds)
- ✓ Batch report generation (2+ seconds)

### Job Submission Pattern

**JavaScript:**
```javascript
async function submitLargeSimulation(projectID, numTiles) {
  if (numTiles > 100) {
    // Use orchestration for large projects
    
    // 1. Submit job to orchestration service
    const jobResponse = await fetch('http://localhost:9000/api/v1/jobs', {
      method: 'POST',
      headers: {
        'X-Trace-ID': crypto.randomUUID(),
        'X-Actor-ID': 'user-123',
        'Idempotency-Key': `simulation-${projectID}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        type: 'SIMULATION',
        project_id: projectID,
        metadata: {
          num_tiles: numTiles,
          simulation_type: 'yield_forecast',
        },
        payload: {
          // simulation parameters
        },
      }),
    });
    
    const job = await jobResponse.json();
    return {
      status: 'IN_PROGRESS',
      job_id: job.data.id,
      status_url: `/jobs/${job.data.id}`,
      poll_interval_seconds: 5,
    };
  } else {
    // Use direct service call for small projects (synchronous)
    const simResponse = await fetch('http://localhost:8004/api/v1/simulations', {
      method: 'POST',
      headers: {
        'X-Trace-ID': crypto.randomUUID(),
        'X-Actor-ID': 'user-123',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ project_id: projectID }),
    });
    
    const result = await simResponse.json();
    return {
      status: 'COMPLETED',
      result: result.data,
    };
  }
}

// Usage:
const result = await submitLargeSimulation('proj-123', 500);

if (result.status === 'IN_PROGRESS') {
  // Poll for job completion
  console.log(`Job submitted: ${result.job_id}`);
  console.log(`Check status at: ${result.status_url}`);
  
  let jobStatus = 'PENDING';
  while (jobStatus === 'PENDING' || jobStatus === 'RUNNING') {
    await new Promise(resolve => setTimeout(resolve, result.poll_interval_seconds * 1000));
    const statusResp = await fetch(`http://localhost:9000${result.status_url}`);
    const status = await statusResp.json();
    jobStatus = status.data.state;
    console.log(`Job status: ${jobStatus}`);
  }
} else {
  console.log(`Simulation completed: ${result.result.yield_kwh}`);
}
```

**Go:**
```go
package main

import (
	"context"
	"solar3d/services/shared/orchestration"
)

func submitLargeSimulation(ctx context.Context, projectID string, numTiles int) (string, error) {
	if numTiles > 100 {
		// Use orchestration for large projects
		orchestrationClient := orchestration.NewClient("http://localhost:9000")
		
		jobID, err := orchestrationClient.SubmitJob(ctx, projectID, "SIMULATION", map[string]interface{}{
			"num_tiles":      numTiles,
			"simulation_type": "yield_forecast",
		}, "simulation-"+projectID)
		
		if err != nil {
			return "", err
		}
		
		// Poll for job completion
		for {
			status, err := orchestrationClient.GetJobStatus(ctx, jobID)
			if err != nil {
				return "", err
			}
			
			if status.State == "COMPLETED" {
				return jobID, nil  // Job completed successfully
			} else if status.State == "FAILED" {
				return "", fmt.Errorf("job failed: %s", status.Error)
			}
			
			// Continue polling
			time.Sleep(5 * time.Second)
		}
	} else {
		// Use direct service call for small projects
		// (synchronous, blocking)
		// ...
	}
}
```

### Job Lifecycle

```
[Client submits job]
         ↓
[Orchestration receives job] → Returns job_id + status_url immediately
         ↓
[Client polls status_url every 5 seconds]
         ↓
[Job PENDING → RUNNING → COMPLETED/FAILED]
         ↓
[Client retrieves result]
```

---

## Error Handling

### Error Codes

All services return standard error codes:

| Code | HTTP Status | Meaning | Retry? |
|------|-------------|---------|--------|
| `INVALID_INPUT` | 400 | Malformed request | No |
| `UNAUTHORIZED` | 401 | Missing/invalid auth | No |
| `PERMISSION_DENIED` | 403 | Insufficient permissions | No |
| `NOT_FOUND` | 404 | Resource doesn't exist | No |
| `CONFLICT` | 409 | Duplicate idempotency key collision | No |
| `INTERNAL_ERROR` | 500 | Server error | Yes (with backoff) |
| `UNAVAILABLE` | 503 | Service temporarily down | Yes |
| `DEADLINE_EXCEEDED` | 504 | Request timeout | Maybe |

### Error Handling Examples

**JavaScript:**
```javascript
async function handleServiceCall(url, options) {
  try {
    const response = await fetch(url, options);
    
    if (!response.ok) {
      const error = await response.json();
      
      switch (error.error.code) {
        case 'INVALID_INPUT':
          console.error(`Invalid input: ${error.error.message}`);
          // Log error, don't retry
          throw new Error(`Invalid input: ${error.error.details}`);
          
        case 'NOT_FOUND':
          console.error(`Resource not found`);
          throw new Error(`Resource not found: ${error.error.details}`);
          
        case 'INTERNAL_ERROR':
        case 'UNAVAILABLE':
          // Retry with exponential backoff
          console.warn(`Service error: ${error.error.code}, retrying...`);
          await new Promise(resolve => setTimeout(resolve, 1000 * Math.random()));
          return handleServiceCall(url, options);  // Retry once
          
        case 'DEADLINE_EXCEEDED':
          // May be transient; try once
          console.warn(`Request timeout, retrying once...`);
          return handleServiceCall(url, options);
          
        default:
          throw new Error(`Unexpected error: ${error.error.code}`);
      }
    }
    
    return await response.json();
  } catch (error) {
    console.error(`Request failed: ${error.message}`, { trace_id: options.headers['X-Trace-ID'] });
    throw error;
  }
}
```

**Go:**
```go
package main

import (
	"solar3d/services/shared/transport"
	"fmt"
)

func handleServiceCall(resp *http.Response, err error) error {
	if err != nil {
		if isNetworkError(err) {
			return fmt.Errorf("network error: %w (retry eligible)", err)
		}
		return fmt.Errorf("request failed: %w", err)
	}
	
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return nil  // Success
	}
	
	// Parse error response
	var errResp struct {
		Error struct {
			Code    string `json:"code"`
			Message string `json:"message"`
			Details string `json:"details"`
		} `json:"error"`
	}
	json.NewDecoder(resp.Body).Decode(&errResp)
	
	switch errResp.Error.Code {
	case "INVALID_INPUT":
		return fmt.Errorf("invalid input: %s", errResp.Error.Details)
	case "NOT_FOUND":
		return fmt.Errorf("not found: %s", errResp.Error.Details)
	case "INTERNAL_ERROR", "UNAVAILABLE":
		return &RetryableError{Err: fmt.Errorf(errResp.Error.Code)}
	case "DEADLINE_EXCEEDED":
		return &RetryableError{Err: fmt.Errorf("deadline exceeded")}
	default:
		return fmt.Errorf("unknown error: %s", errResp.Error.Code)
	}
}

type RetryableError struct{ Err error }

func (e *RetryableError) Error() string   { return e.Err.Error() }
func (e *RetryableError) IsRetryable() bool { return true }
```

---

## Service-Specific Examples

### Project Service
**Create a project:**
```bash
curl -X POST http://localhost:8001/api/v1/projects \
  -H "X-Trace-ID: proj-2024-001" \
  -H "X-Actor-ID: user-123" \
  -H "Idempotency-Key: create-alpha-farm" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Solar Farm Alpha",
    "location": {"latitude": 37.5, "longitude": -120.5},
    "capacity": 5.0,
    "timezone": "America/Los_Angeles"
  }'
```

### Terrain Service
**Query elevation grid:**
```bash
curl -X GET "http://localhost:8002/api/v1/terrain/grid?lat1=37.4&lat2=37.6&lon1=-120.6&lon2=-120.4&resolution=10" \
  -H "X-Trace-ID: terrain-2024-001"
```

### Layout Service
**Generate tile layout:**
```bash
curl -X POST http://localhost:8003/api/v1/layouts/generate \
  -H "X-Trace-ID: layout-2024-001" \
  -H "Content-Type: application/json" \
  -d '{
    "project_id": "proj-123",
    "target_tiles": 16,
    "target_panels": 400
  }'
```

### Simulation Service
**Run solar simulation:**
```bash
curl -X POST http://localhost:8004/api/v1/simulations \
  -H "X-Trace-ID: sim-2024-001" \
  -H "Idempotency-Key: simulate-alpha" \
  -H "Content-Type: application/json" \
  -d '{
    "project_id": "proj-123",
    "weather_year": 2023
  }'
```

### Electrical Service
**Validate electrical network:**
```bash
curl -X POST http://localhost:8005/api/v1/electrical/validate \
  -H "X-Trace-ID: elec-2024-001" \
  -H "Content-Type: application/json" \
  -d '{
    "project_id": "proj-123"
  }'
```

### Routing Service
**Compute optimal routes:**
```bash
curl -X POST http://localhost:8006/api/v1/routing/optimize \
  -H "X-Trace-ID: route-2024-001" \
  -H "Content-Type: application/json" \
  -d '{
    "project_id": "proj-123",
    "optimize_for": "cost"
  }'
```

### Report Service
**Generate report:**
```bash
curl -X POST http://localhost:8007/api/v1/reports/generate \
  -H "X-Trace-ID: report-2024-001" \
  -H "Idempotency-Key: gen-report-alpha" \
  -H "Content-Type: application/json" \
  -d '{
    "project_id": "proj-123",
    "report_type": "summary",
    "format": "pdf"
  }'
```

---

## Troubleshooting Checklist

- [ ] Include `X-Trace-ID` header in all requests
- [ ] Use `Idempotency-Key` for create/update operations
- [ ] Check error response `code` field (not just HTTP status)
- [ ] Retry on `INTERNAL_ERROR`/`UNAVAILABLE` with exponential backoff
- [ ] For long-running operations (>1 min), use orchestration service
- [ ] Include `X-Actor-ID` for audit logging
- [ ] Verify service is running on correct port (check `docker ps`)
- [ ] Check centralized logs with trace ID for full request lifecycle
- [ ] Use `Accept-Encoding: gzip` for large responses

---

## Sample Client Library (Go)

Reusable client helper for all services:

```go
package solar3d

import (
	"context"
	"fmt"
	"net/http"
	"github.com/google/uuid"
)

type ServiceClient struct {
	baseURL   string
	httpClient *http.Client
}

func NewServiceClient(baseURL string) *ServiceClient {
	return &ServiceClient{
		baseURL:   baseURL,
		httpClient: &http.Client{Timeout: 30 * time.Second},
	}
}

func (c *ServiceClient) Request(ctx context.Context, method, path string, traceID, actorID, idempotencyKey string, body interface{}) (*http.Response, error) {
	if traceID == "" {
		traceID = uuid.New().String()
	}
	
	var reqBody io.Reader
	if body != nil {
		b, _ := json.Marshal(body)
		reqBody = bytes.NewReader(b)
	}
	
	req, _ := http.NewRequestWithContext(ctx, method, c.baseURL+path, reqBody)
	req.Header.Set("X-Trace-ID", traceID)
	req.Header.Set("X-Actor-ID", actorID)
	req.Header.Set("X-Request-ID", uuid.New().String())
	if idempotencyKey != "" {
		req.Header.Set("Idempotency-Key", idempotencyKey)
	}
	req.Header.Set("Content-Type", "application/json")
	
	return c.httpClient.Do(req)
}
```

---

## Additional Resources

- **Proto Definitions**: `proto/` folder (compile with `protoc` or `buf`)
- **Deployment Guide**: `DEPLOYMENT_GUIDE.md`
- **Architecture Overview**: `docs/PROJECT_OVERVIEW.md`
- **ML Integration**: `ML_LEARNING_SYSTEM.md`
- **Observability**: Forward logs to centralized logging (ELK, Datadog, etc.)

---

**Last Updated:** March 30, 2024  
**Status:** Enterprise-Ready 🟢
