# Solar3D — Detailed Project Documentation

Canonical reference for the current state of the Solar3D EPC platform: what exists,
how it is wired, and what is still required to reach production-grade EPC maturity.

> For the narrative / problem-statement / architecture sketch, see
> [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md).
> For the concrete task list to finish the product, see
> [ROADMAP_TO_COMPLETE.md](ROADMAP_TO_COMPLETE.md).

---

## 1. Repository Layout

```
Solar3d/
├── proto/                        # Protobuf API contracts (buf-managed)
├── services/                     # Go microservices (one per domain)
│   ├── project-service/          # :8080 — project lifecycle
│   ├── terrain-service/          # :8081 — DEM, slope, aspect
│   ├── layout-service/           # :8082 — panel arrays, tiling
│   ├── simulation-service/       # :8083 — sun position, shading
│   ├── electrical-service/       # :8084 — strings, inverters, losses
│   ├── routing-service/          # :8085 — cable / road A*
│   ├── report-service/           # :8086 — BOM, PDF/CSV/XLSX
│   ├── asset-service/            # :8087 — component catalog
│   ├── compute-orchestration-service/  # long-running job queue
│   └── shared/                   # shared middleware (recovery/requestid/cors/log/ratelimit)
├── compute/                      # Rust SIMD compute (FFI via cgo)
│   ├── solar-compute/
│   └── terrain-compute/
├── frontend/                     # SvelteKit + Cesium web app
├── mobile/                       # Flutter app (Riverpod + Bloc + ConnectRPC)
├── migrations/                   # PostgreSQL + PostGIS migrations
├── deploy/                       # Docker / k8s / Helm configs
├── monitoring/                   # Prometheus / Grafana / Alertmanager config
├── scripts/                      # smoke-test, validate-* scripts
└── docs/                         # Project documentation (this directory)
```

---

## 2. Technology Stack

| Layer | Technology | Version Target |
|---|---|---|
| Backend services | Go | 1.22+ |
| High-perf compute | Rust (SIMD, no-std where possible) | 1.76+ |
| Web frontend | SvelteKit + TypeScript + TailwindCSS | Svelte 5 / TS 5 |
| 3D rendering | CesiumJS | 1.120+ |
| Mobile | Flutter + Dart | Flutter 3.24 / Dart 3.5 |
| State (mobile) | Riverpod (DI) + Bloc (business logic) | riverpod 2, bloc 8 |
| Database | PostgreSQL + PostGIS | 16 / 3.4 |
| Object storage | S3-compatible (MinIO in dev) | — |
| API protocol | ConnectRPC (JSON over HTTP) | connect-go v1, protoc |
| Query layer | sqlc | latest |
| Build tooling | buf, make, docker, podman | — |

---

## 3. Current Feature Coverage

### 3.1 Backend services — implemented RPC methods

| Service | Methods | Notes |
|---|---|---|
| project-service | 5 (CRUD + List) | ConnectRPC path format; pagination ✅ |
| terrain-service | 8 (upload, list, get, elevation, grid, slope, aspect, delete) | REST routes |
| layout-service | 11 (CRUD, array gen, tiles, components) | REST routes |
| simulation-service | 7 (CRUD + sun-position + shadow-map) | REST routes |
| electrical-service | 12 (network CRUD, strings, inverters, losses) | REST routes |
| routing-service | 6 (calculate, cable/road create, list, optimize, delete) | REST routes |
| report-service | 6 (generate, BOM, export, list, get, delete) | REST routes |
| asset-service | 5 (CRUD + list with filter) | REST routes |

**Total: 60 RPC methods across 8 services.**

### 3.2 Shared middleware (all 8 services)

- Panic recovery (returns ConnectRPC-style JSON error)
- Request ID injection (`X-Request-ID`)
- CORS (env-driven allowed origin)
- Structured logging (zerolog, RFC3339 timestamps, caller info)
- Per-IP token-bucket rate limiting (100 rps / 200 burst default)

### 3.3 Web frontend (SvelteKit)

- 3D Cesium viewer with terrain
- Project dashboard (create, list, delete)
- Panel generator form (tilt, spacing, row count)
- Simulation panel (sun path, shadow overlay)
- Electrical panel (network auto-generation, losses)
- Financial panel (LCOE, payback)
- Report / export panel (BOM, PDF/CSV/Excel)
- Map search (geocoding)
- Inspector panel, asset library
- Toast notifications + keyboard shortcuts
- **Added this iteration**: `ConnectivityIndicator`, `ErrorBoundary`, `LoadingSkeleton`
- CAD import flow: KML / KMZ / DXF → GeoJSON preview → boundary selection

### 3.4 Mobile app (Flutter)

- ConnectRPC transport with per-service port mapping
- 8 typed service clients covering all 60 RPC methods
- Riverpod providers: transport + 8 service clients + 5 Bloc providers
- GoRouter with shell route + nested detail routes
- Screens: dashboard, project list/detail, layout, simulation, electrical, reports, map
- **Added this iteration**: financial screen (LCOE/NPV/IRR/payback), terrain screen
- Material 3 theme (dark/light via `ThemeMode.system`)

### 3.5 CAD / GIS ingestion (completed Phase 4)

- DXF parser (LWPOLYLINE, POLYLINE, LINE, INSERT, TEXT/MTEXT)
- Format detector by magic bytes (DXF / DWG / KML / KMZ)
- DWG graceful rejection with export instructions
- `POST /api/v1/cad/parse` stateless layer-preview endpoint
- Frontend boundary import with interactive layer selection

### 3.6 Planning / Workflow (completed core)

- Phase state machine in project service
- LOD 400 checklist & approval
- Layout → Electrical → Transmission → Twin gates
- Rollback and exception policies
- Twin service with provisioning payload

---

## 4. Data Model (current)

### 4.1 Core tables (PostgreSQL + PostGIS)

```
projects                (id, name, client, location GEOGRAPHY, capacity_kw, status, …)
terrain_layers          (id, project_id, layer_type, bounds GEOMETRY, resolution_m, …)
layouts                 (id, project_id, total_panels, total_capacity_kw, status, …)
components              (id, layout_id, type, position GEOMETRY(POINT), rotation, …)
panel_tiles             (id, layout_id, tile_x, tile_y, panel_count, envelope GEOMETRY)
simulations             (id, project_id, type, status, results JSONB, …)
electrical_networks     (id, project_id, strings_per_inverter, dc_ac_ratio, losses JSONB)
routes                  (id, project_id, route_type, geometry GEOMETRY(LINESTRING), …)
reports                 (id, project_id, type, format, s3_uri, status, …)
assets                  (id, name, category, manufacturer, model, specs JSONB)
workflow_state          (project_id, phase, lod, gates JSONB, …)
twin_snapshots          (id, project_id, lineage JSONB, commissioned_at)
```

### 4.2 Object storage layout (MinIO / S3)

```
solar3d/
├── terrain/<project_id>/<layer_id>.tif           # GeoTIFFs
├── exports/<project_id>/<report_id>.<ext>        # PDF/CSV/XLSX
├── uploads/<project_id>/<hash>.<ext>             # raw CAD inputs
└── twin/<project_id>/<snapshot_id>.json          # commissioned snapshots
```

---

## 5. API Conventions

### 5.1 Protocol

- **ConnectRPC JSON over HTTP/1.1** (not gRPC binary).
- Requests: `POST /<package>.<Service>/<Method>` with `Content-Type: application/json`.
- `Connect-Protocol-Version: 1` header required.
- Errors: `{ "code": "<connect_code>", "message": "<detail>" }`.

### 5.2 Known inconsistency (to fix)

- `project-service` uses canonical ConnectRPC paths
  (`/solar.project.v1.ProjectService/CreateProject`).
- Other 7 services use REST-style paths (`/api/v1/assets`, `/api/v1/layouts/:id/…`).
- Mobile `ConnectRpcTransport` currently targets ConnectRPC paths for all 8 services
  → calls to the other 7 services will 404 until they are normalized.
- **Fix direction**: add ConnectRPC handlers to the remaining 7 services (keep REST as
  an alias for the existing web frontend, or migrate the web frontend too).

### 5.3 Versioning

- All proto packages are `solar.<domain>.v1`.
- REST prefix is `/api/v1/`.
- Breaking changes require a new `v2` package; maintain v1 side-by-side.
- See `docs/API_VERSIONING.md` for the full policy.

---

## 6. Deployment Topology (current)

- `docker-compose.yml` / `podman-compose.yml` bring up:
  - postgres (PostGIS), minio, prometheus, grafana
  - all 8 Go services
  - monolith variant for local / benchmark mode on :9191
- `deploy/` holds draft k8s manifests (not yet GitOps-managed).
- `monitoring/` has Prometheus scrape config + Grafana dashboards
  (no metrics exporters wired into services yet).

---

## 7. Known Gaps (condensed — see roadmap for detail)

### 7.1 Cross-cutting

- No authentication / authorization / multi-tenancy.
- No metrics / tracing (Prometheus scrape configured but no instrumentation).
- No unit tests in services / mobile (web has scattered Vitest coverage only).
- No CI pipeline committed (only validate scripts).
- No OpenAPI / proto-generated docs site.

### 7.2 EPC domain coverage

- Panel physics: no bifacial, no trackers, no IAM, no spectral correction.
- Weather: no TMY / NSRDB / PVGIS / Meteonorm ingestion.
- Loss model: no soiling, no snow, no inverter clipping.
- Shading: no near/far shading from 3D obstacles.
- Electrical: no wire sizing, no voltage drop, no NEC/IEC checks, no SLD/3LD generation.
- Structural: no foundation sizing, no ASCE 7 wind/snow loads.
- Permitting: no AHJ packages, no interconnection forms.
- Procurement: no RFQ / PO / vendor catalog.
- Construction: no schedule / crew / QC / RFI.
- Commissioning: no IV-curve ingest, no PR validation.
- O&M: no SCADA ingestion, no work orders, no warranty tracking.

### 7.3 UX / a11y / responsive

- No responsive breakpoints (desktop-only web).
- No ARIA roles / focus management.
- Mobile: no shimmer, no pull-to-refresh on 4 of 6 lists, no form validation,
  no connectivity monitoring despite deps.

---

## 8. Quality Gates & Definition of Done

Before any feature is considered shipped, it must satisfy:

1. **Proto contract** — defined in `proto/…/v1/*.proto` and buf-lint-clean.
2. **Backend** — handler + service + repo, with at least one unit test per
   non-trivial public function and one integration test per RPC method.
3. **Migration** — a forward + backward migration in `migrations/`.
4. **Web** — Svelte component, typed API call, error + loading states, toast on
   failure/success, and a Vitest test for pure logic.
5. **Mobile** — Bloc event/state, screen, bloc_test, and wired into router.
6. **Docs** — updated `PROJECT_DOCUMENTATION.md` feature matrix and
   `ROADMAP_TO_COMPLETE.md` checkbox.
7. **Observability** — metrics emitted (counter / histogram) and a log line at
   boundary with request_id.
8. **CI** — lint + test + build green on the branch.

---

## 9. Security Baseline (target)

- All traffic behind TLS (TLS-terminating ingress).
- JWT auth via shared middleware; claims carry `tenant_id`, `role`, `user_id`.
- RBAC policy file (OPA / Casbin) per service; enforced in middleware.
- All database writes scoped by `tenant_id` filter.
- Secrets via Vault / sealed-secrets / cloud KMS — never env-vars in prod.
- Upload endpoints cap size, virus-scan, and reject unknown MIME types.
- Rate limits scoped per-tenant, not just per-IP.
- Audit log of every mutation, retention ≥ 1 year.

---

## 10. Performance Targets

| Operation | p50 | p95 |
|---|---|---|
| Project CRUD | < 50 ms | < 150 ms |
| Layout generation (100k panels) | < 3 s | < 8 s |
| Simulation (hourly, 1 year) | < 5 s | < 15 s |
| Report PDF (full engineering) | < 10 s | < 30 s |
| Tile fetch (viewport) | < 100 ms | < 300 ms |

Targets driven by the determinism benchmark in `scripts/smoke-test.sh` and the
integration test `services/integration_test.go`.

---

## 11. Glossary

- **EPC** — Engineering, Procurement, Construction.
- **AHJ** — Authority Having Jurisdiction.
- **BOM** — Bill of Materials.
- **LOD 400** — Level of Development 400 (construction-ready detail).
- **NEC** — National Electrical Code.
- **POI** — Point of Interconnection.
- **PR** — Performance Ratio.
- **SLD / 3LD** — Single-Line Diagram / Three-Line Diagram.
- **TMY** — Typical Meteorological Year.
- **IAM** — Incidence Angle Modifier.
- **PID / LID** — Potential / Light-Induced Degradation.
