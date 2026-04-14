## Compute Service - Clean Architecture with connectRPC

This microservice exposes Rust compute crates via **connectRPC** using clean architecture layers.

### Architecture

```
connectRPC Request → Handler Layer → Service Layer → Repository Layer → Rust Crate
Proto Message        Request Mapping   Business Logic    FFI/HTTP Bridge   Computation
                     Response Mapping  Validation        Crate Call        Result
```

### Folder Structure

```
compute-service/
├── cmd/
│   └── main.go                          # Server entry point + dependency injection
├── internal/
│   ├── handler/                         # Handler layer (implements connectRPC interface)
│   │   └── ml_inference.go              # ML Inference RPC handlers
│   ├── service/                         # Service layer (business logic)
│   │   └── ml_inference.go              # ML Inference orchestration
│   ├── repository/                      # Repository layer (Rust crate bridge)
│   │   ├── interfaces.go                # Repository interfaces
│   │   └── ml_inference_impl.go         # Rust ML crate bindings
│   ├── models/                          # Domain models (proto-independent)
│   │   └── feature_extraction.go        # Domain structs for features
│   └── mappers/                         # Proto ↔ Domain converters
│       └── ml_inference.go              # Mapper implementations
└── go.mod/go.sum                        # Dependencies
```

### Data Flow Example: ExtractFeatures

1. **Client** sends proto `FeatureExtractionRequest` to `/ml_inference.v1.MLInferenceService/ExtractFeatures`
2. **Handler** (ml_inference.go) receives connectRPC request
3. **Mapper** converts proto message → domain model
4. **Service** validates input, calls repository
5. **Repository** (ml_inference_impl.go) calls Rust feature_pipeline compute
6. **Mapper** converts domain response → proto message
7. **Handler** returns connectRPC response to client

### How to Add a New Endpoint

#### Example: Adding PredictYield

##### 1. Define Domain Model
Add to `internal/models/yield_forecasting.go`:
```go
type YieldForecastModel struct {
    PredictedYield float64
    ConfidenceLower float64
    ConfidenceUpper float64
}

type YieldPredictionRequest struct {
    Features []float64
    ModelOutput float64
}
```

##### 2. Create Mapper
Add to `internal/mappers/ml_inference.go`:
```go
func ProtoToYieldPrediction(protoReq *ml_inferencev1.YieldPredictionRequest) *models.YieldPredictionRequest {
    return &models.YieldPredictionRequest{
        Features: protoReq.Features.Features,
        ModelOutput: protoReq.ModelOutput,
    }
}

func YieldForecastToProto(domainResp *models.YieldForecastModel) *ml_inferencev1.YieldForecast {
    return &ml_inferencev1.YieldForecast{
        PredictedYieldKwh: domainResp.PredictedYield,
        ConfidenceLower: domainResp.ConfidenceLower,
        ConfidenceUpper: domainResp.ConfidenceUpper,
    }
}
```

##### 3. Add Repository Method
Add to `internal/repository/interfaces.go`:
```go
type MLInferenceRepository interface {
    PredictYield(ctx context.Context, req *models.YieldPredictionRequest) (*models.YieldForecastModel, error)
}
```

Implement in `internal/repository/ml_inference_impl.go`:
```go
func (r *RustMLInferenceRepository) PredictYield(ctx context.Context, req *models.YieldPredictionRequest) (*models.YieldForecastModel, error) {
    // Call Rust ml-inference::yield_forecasting via FFI/HTTP
    // Return domain model
}
```

##### 4. Add Service Method
Add to `internal/service/ml_inference.go`:
```go
func (s *MLInferenceService) PredictYield(ctx context.Context, req *models.YieldPredictionRequest) (*models.YieldForecastModel, error) {
    return s.repo.PredictYield(ctx, req)
}
```

##### 5. Implement Handler
Update `internal/handler/ml_inference.go`:
```go
func (h *MLInferenceServiceHandler) PredictYield(
    ctx context.Context,
    req *connect.Request[ml_inferencev1.YieldPredictionRequest],
) (*connect.Response[ml_inferencev1.YieldPredictionResponse], error) {
    domainReq := mappers.ProtoToYieldPrediction(req.Msg)
    if domainReq == nil {
        return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid request"))
    }
    
    domainResp, err := h.svc.PredictYield(ctx, domainReq)
    if err != nil {
        return nil, connect.NewError(connect.CodeInternal, err)
    }
    
    protoResp := &ml_inferencev1.YieldPredictionResponse{
        Forecast: mappers.YieldForecastToProto(domainResp),
    }
    return connect.NewResponse(protoResp), nil
}
```

### Testing the Vertical Slice

#### Start Server
```bash
cd services/compute-service
go run ./cmd
# Server listens on :50051
```

#### Test ExtractFeatures with curl
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "weather": {"temperature_c": 25, "irradiance_w_m2": 800, "humidity_percent": 50, "pressure_mb": 1013, "wind_speed_m_s": 3},
    "solar": {"solar_altitude_deg": 45, "solar_azimuth_deg": 180, "air_mass": 1.4, "clearness_index": 0.7},
    "time": {"hour_of_day": 12, "day_of_year": 180, "month": 6, "is_weekend": false}
  }' \
  http://localhost:50051/ml_inference.v1.MLInferenceService/ExtractFeatures
```

### Rust Integration Strategy

The `repository/ml_inference_impl.go` currently simulates Rust compute. To integrate real Rust:

**Option 1: FFI (Foreign Function Interface)**
- Use `cgo` to call Rust crate functions compiled as `cdylib`
- Add FFI bindings in a `ffi/` package
- Call bindings from repository layer

**Option 2: HTTP Bridge**
- Wrap Rust crate in HTTP server (separate process)
- Call HTTP endpoints from repository layer
- Easier debugging, process isolation

**Option 3: WASM**
- Compile Rust to WebAssembly
- Load WASM runtime in Go
- Call WASM functions from repository

**Current: Simulation**
- Mock implementation validates logic
- Simplifies development/testing without Rust build complexity

### Dependency Injection

[cmd/main.go](cmd/main.go) shows the wiring pattern:
```go
// Repository → Service → Handler chain
repo := repository.NewRustMLInferenceRepository()
svc := service.NewMLInferenceService(repo)
handler := handler.NewMLInferenceServiceHandler(svc)

// Register with connectRPC
path, connectHandler := ml_inferencev1connect.NewMLInferenceServiceHandler(handler)
mux.Handle(path, connectHandler)
```

### Error Handling

- **Handler**: Maps domain errors to connectRPC codes (CodeInvalidArgument, CodeInternal, etc.)
- **Service**: Validates business logic, returns descriptive errors
- **Repository**: Wraps external call errors, adds context

### Next Steps

1. **Expand ML Inference**: Add PredictYield, DetectAnomaly, ForecastDegradation handlers
2. **Add Optimization Service**: Create handlers for ParallelFrontier, MonteCarloSampling, etc.
3. **Integrate Rust**: Replace repository impl with real Rust bindings via FFI/HTTP
4. **Add Caching**: Implement optional result caching in repository layer
5. **Add Tests**: Unit test handlers, services, mappers
