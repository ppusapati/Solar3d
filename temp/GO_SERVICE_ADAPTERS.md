# Go Service Adapters - Implementation Guide

## Overview
This guide explains how to wire up the Rust compute core to Go microservices using HTTP bridge clients.

## Architecture

```
Go Microservice
  ↓
Service Layer (business logic, caching, orchestration)
  ↓ 
Handler Layer (gRPC/REST endpoints)
  ↓
Client Layer (HTTP calls to Rust bridges)
  ↓
Rust HTTP Bridge (geo_http_bridge, graph_http_bridge, etc.)
  ↓
Pure Rust Algorithms (geo-compute, graph-compute, etc.)
```

## Service Structure for Each Adapter

### 1. Geo-Analytics Service ✅ (In Progress)

**Purpose**: Wraps geo-compute HTTP bridge with caching and orchestration

**Components**:
- `client/geo_compute.go`: HTTP client to geo_http_bridge
  - ✅ DONE: BufferPoint, GenerateContours, NearestNeighbor, KNearestNeighbors
- `service/service.go`: (To create) 
  - Cache buffered regions (LRU cache)
  - Compose multiple geo operations
  - Health checking
- `handler/handler.go`: (To create)
  - gRPC or REST endpoints for above
  - Request validation
  - Metrics/tracing
- `cmd/server/main.go`: (To create)
  - Service initialization
  - HTTP bridge client setup
  - gRPC server startup

**Configuration** (via env vars):
```
GEO_COMPUTE_URL=http://localhost:8001
GEO_SERVICE_PORT=:50060
```

---

### 2. Graph Service (To Create)

**Purpose**: Wraps graph-compute HTTP bridge for network optimization

**Client** (`client/graph_compute.go`):
```go
type GraphComputeClient struct {
    baseURL string
    client  *http.Client
}

// MST(graph) → Vec<Edge>
// ApproximateSteinerTree(graph, terminals) → Vec<Edge>
// Health() → error
```

**Usage**: Electrical Service (cable network MST), Routing Service (road MST)

---

### 3. Optimization Service (To Create)

**Purpose**: Wraps optimization-compute HTTP bridge for solvers

**Client** (`client/optimization_compute.go`):
```go
type OptimizationClient struct {
    baseURL string
    client  *http.Client
}

// SolvePSO(objective, config) → (best_x, best_value)
// SolveGA(population, generations) → best_individual
// SolveSimulatedAnnealing(config) → best_solution
// GeneratePareto(multi_objective) → frontier
// MonteCarloP50P90(samples) → (p50, p90)
```

**Usage**: Layout optimization, network routing, financial tradeoff surfaces

---

### 4. ML Service (To Create)

**Purpose**: Wraps ml-inference HTTP bridge for predictions

**Client** (`client/ml_inference.go`):
```go
type MLClient struct {
    baseURL string
    client  *http.Client
}

// ForecastYield(model_output, uncertainty) → YieldForecast
// DetectAnomaly(features) → AnomalyScore
// ForecastDegradation(timeseries) → TrendForecast
// Health() → error
```

**Usage**: Simulation Service (yield prediction), Asset/Electrical Service (anomaly detection)

---

## Implementation Steps

### Step 1: Go Service Bootstrap (All 4 Services)

For each service, create:

```go
// cmd/server/main.go
package main

import (
    "context"
    "log"
    "net"
    "os"
    "time"

    "google.golang.org/grpc"
    "google.golang.org/grpc/health/grpc_health_v1"
    
    "<service>/internal/client"
    "<service>/internal/handler"
    "<service>/internal/service"
)

func main() {
    ctx := context.Background()

    // Load config from env
    rustBridgeURL := os.Getenv("RUST_BRIDGE_URL")
    if rustBridgeURL == "" {
        rustBridgeURL = "http://localhost:8001"
    }
    
    // Create Rust client
    client := client.New(rustBridgeURL)
    
    // Health check Rust bridge
    if err := client.Health(ctx); err != nil {
        log.Fatalf("Rust bridge unhealthy: %v", err)
    }

    // Create service
    svc := service.New(client)
    
    // Create gRPC handler
    h := handler.New(svc)
    
    // Start gRPC server
    lis, err := net.Listen("tcp", ":50060")
    if err != nil {
        log.Fatalf("listen: %v", err)
    }
    
    grpcServer := grpc.NewServer()
    h.Register(grpcServer)  // Register service methods
    
    log.Printf("Service listening on :50060")
    if err := grpcServer.Serve(lis); err != nil {
        log.Fatalf("serve: %v", err)
    }
}
```

### Step 2: Service Implementation

```go
// internal/service/service.go
package service

import (
    "context"
    "<service>/internal/client"
)

type Service struct {
    rustClient *client.<ServiceClient>
    // Add caching, orchestration fields as needed
}

func New(rustClient *client.<ServiceClient>) *Service {
    return &Service{
        rustClient: rustClient,
    }
}

// Business logic methods that compose Rust operations
func (s *Service) SomeOperation(ctx context.Context, inputs...) (outputs..., error) {
    // Multi-step orchestration if needed
    // Caching layer here
    return s.rustClient.SomeOperation(ctx, inputs...)
}
```

### Step 3: Proto Contract (If Exposing via gRPC)

For each service, if using gRPC (recommended for Go-to-Go communication):

```protobuf
// proto/geo-analytics/v1/service.proto
syntax = "proto3";
package geo_analytics.v1;

option go_package = "github.com/solar3d/solar3d/gen/geo_analytics/v1;geo_analyticsv1";

import "google/protobuf/empty.proto";

service GeoAnalyticsService {
  rpc BufferPoint(BufferPointRequest) returns (BufferPointResponse);
  rpc GenerateContours(GenerateContoursRequest) returns (GenerateContoursResponse);
  rpc NearestNeighbor(NearestNeighborRequest) returns (NearestNeighborResponse);
  rpc Health(google.protobuf.Empty) returns (HealthResponse);
}

message Point2D {
  double x = 1;
  double y = 2;
}

message BufferPointRequest {
  Point2D center = 1;
  double radius = 2;
  int32 segments = 3;
}

message BufferPointResponse {
  repeated Point2D ring = 1;
  string error = 2;
}

// ... more messages
```

### Step 4: Handler Implementation

```go
// internal/handler/handler.go
package handler

import (
    "context"
    "google.golang.org/grpc"
    
    "github.com/solar3d/solar3d/gen/geo_analytics/v1/geo_analyticsv1connect"
    geo_analyticsv1 "github.com/solar3d/solar3d/gen/geo_analytics/v1"
    
    "<service>/internal/service"
)

type Handler struct {
    svc *service.Service
}

func New(svc *service.Service) *Handler {
    return &Handler{svc: svc}
}

func (h *Handler) Register(server *grpc.Server) {
    geo_analyticsv1connect.RegisterGeoAnalyticsServiceServer(server, h)
}

func (h *Handler) BufferPoint(ctx context.Context, req *geo_analyticsv1.BufferPointRequest) (*geo_analyticsv1.BufferPointResponse, error) {
    // Convert proto to internal types
    // Call service
    // Convert back to proto
    result, err := h.svc.BufferPoint(ctx, ...)
    if err != nil {
        return nil, err
    }
    return toProto(result), nil
}
```

---

## Deployment Model

### Local Development
```bash
# Terminal 1: Rust geo-compute bridge
cd compute/geo-compute
cargo run --bin geo_http_bridge --release

# Terminal 2: Go geo-analytics service
cd services/geo-analytics-service
go run ./cmd/server
```

### Docker Compose
```yaml
version: '3'
services:
  geo-compute-bridge:
    build:
      context: compute/geo-compute
    ports:
      - "8001:8001"
    environment:
      LISTEN_ADDR: "0.0.0.0:8001"
  
  geo-analytics:
    build:
      context: services/geo-analytics-service
    ports:
      - "50060:50060"
    environment:
      GEO_COMPUTE_URL: "http://geo-compute-bridge:8001"
    depends_on:
      - geo-compute-bridge
    
  graph-compute-bridge:
    build:
      context: compute/graph-compute
    ports:
      - "8002:8002"
  
  graph-service:
    build:
      context: services/graph-service
    ports:
      - "50061:50061"
    environment:
      GRAPH_COMPUTE_URL: "http://graph-compute-bridge:8002"
    depends_on:
      - graph-compute-bridge
  
  # ... optimization-compute, ml-inference similarly
```

### Kubernetes
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: geo-analytics
spec:
  containers:
  - name: geo-compute-bridge
    image: solar3d/geo-compute:latest
    ports:
    - containerPort: 8001
  - name: geo-analytics
    image: solar3d/geo-analytics:latest
    ports:
    - containerPort: 50060
    env:
    - name: GEO_COMPUTE_URL
      value: "http://localhost:8001"
    livenessProbe:
      grpc:
        port: 50060
```

---

## Health & Readiness Checks

Each service should:

1. **Startup**: Check Rust bridge is healthy
```go
if err := client.Health(ctx); err != nil {
    return fmt.Errorf("startup: rust bridge unreachable")
}
```

2. **Liveness**: Expose health RPC
```protobuf
rpc Health(google.protobuf.Empty) returns (HealthResponse);

message HealthResponse {
  enum Status {
    UNKNOWN = 0;
    SERVING = 1;
    NOT_SERVING = 2;
  }
  Status status = 1;
  string rust_bridge_status = 2;
}
```

3. **Readiness**: 
   - Rust bridge responding
   - Service started
   - Database/cache available

---

## Caching Strategy (Optional)

For expensive operations (buffer, contours, MST), add LRU cache:

```go
import "github.com/lmittmann/tint" // or "github.com/hashicorp/golang-lru"

type Service struct {
    rustClient *client.Client
    bufferCache *lru.Cache[BufferKey, *Polygon]
}

type BufferKey struct {
    X        float64
    Y        float64
    Radius   float64
    Segments int
}

func (s *Service) BufferPoint(ctx context.Context, center Point2D, radius float64, segments int) (*Polygon, error) {
    key := BufferKey{center.X, center.Y, radius, segments}
    
    if cached, ok := s.bufferCache.Get(key); ok {
        return cached, nil
    }
    
    result, err := s.rustClient.BufferPoint(ctx, center, radius, segments)
    if err != nil {
        return nil, err
    }
    
    s.bufferCache.Add(key, result)
    return result, nil
}
```

---

## Monitoring & Tracing

Add to each handler:

```go
import "go.opentelemetry.io/otel"

func (h *Handler) BufferPoint(ctx context.Context, req *Request) (*Response, error) {
    tracer := otel.Tracer("geo-analytics")
    ctx, span := tracer.Start(ctx, "BufferPoint")
    defer span.End()
    
    // Log request
    log.WithContext(ctx).Infof("BufferPoint: center=%v radius=%v", req.Center, req.Radius)
    
    // Call service
    result, err := h.svc.BufferPoint(ctx, ...)
    
    // Record metrics
    if err != nil {
        span.RecordError(err)
        metrics.IncrementCounter("buffer_point_errors", 1)
    } else {
        metrics.IncrementCounter("buffer_point_success", 1)
    }
    
    return toProto(result), err
}
```

---

## Testing Strategy

### Unit Tests (Go)
```go
// internal/service/service_test.go
func TestBufferPoint(t *testing.T) {
    mockClient := &MockGeoClient{...}
    svc := service.New(mockClient)
    
    result, err := svc.BufferPoint(ctx, Point2D{100, 200}, 50, 32)
    assert.NoError(t, err)
    assert.Len(t, result.Ring, 32)
}
```

### Integration Tests (Go → Rust)
```go
// tests/integration_test.go
func TestGeoAnalyticsE2E(t *testing.T) {
    // Start Rust bridge
    bridgeCmd := exec.Command("cargo", "run", "--bin", "geo_http_bridge")
    
    // Create Go client
    client := client.New("http://localhost:8001")
    
    // Test full flow
    polygon, err := client.BufferPoint(ctx, Point2D{0, 0}, 10, 32)
    assert.NoError(t, err)
    assert.Len(t, polygon.Ring, 32)
}
```

### Benchmark Tests
```go
// internal/client/client_bench_test.go
func BenchmarkBufferPoint(b *testing.B) {
    client := NewGeoComputeClient("http://localhost:8001")
    b.ResetTimer()
    
    for i := 0; i < b.N; i++ {
        client.BufferPoint(context.Background(), Point2D{0, 0}, 10, 32)
    }
}
```

---

## Known Limitations & Workarounds

1. **HTTP Bridge Latency**: ~5-10ms per call
   - Workaround: Batch operations (multiple buffers in one request) or cache results

2. **Rust Bridge Availability**: Single point of failure if not replicated
   - Workaround: Run replica Rust bridges, use load balancer

3. **Large Result Sets**: Contours/MST can produce megabytes
   - Workaround: Stream results, pagination, compression

---

## Quick Start Checklist

- [ ] Create go.mod for each service
- [ ] Create client wrapper (HTTP to Rust bridge)
- [ ] Create service layer (business logic)
- [ ] Create proto contract (if gRPC)
- [ ] Create handler (proto → Go → client calls)
- [ ] Create main.go (server startup)
- [ ] Write integration tests
- [ ] Add health checks
- [ ] Add monitoring/tracing
- [ ] Deploy via Docker/Kubernetes

---

**Status**: 🔨 IN PROGRESS  
**Next Step**: Create Graph Service stub (same pattern as Geo-Analytics)
