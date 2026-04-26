# Solar3D — Status Report & Remaining Work

Generated: 2026-04-26

---

## Executive Summary

The Solar3D codebase is a **functional, production-intended microservice architecture** —
not scaffolding. It contains ~91,000 LOC across 25 Go services, 61 Rust compute files,
60 Svelte components, 49 Dart mobile files, 33 proto definitions, and 14 SQL migrations.

**Estimated completion: ~35% of the full EPC lifecycle.**
Core design workflow (site → layout → electrical → routing → report) works end-to-end.
What's missing is depth in each domain and the later EPC stages (procurement, construction,
commissioning, O&M).

---

## 1. What Exists Today (Functional)

### 1.1 Backend Services (25 services, all with real logic)

| Service | LOC | Tests | Routes | What It Does |
|---|---|---|---|---|
| project-service | 6,979 | 8 | ConnectRPC+REST | Project CRUD, phase state machine, GIS/DXF parsing |
| terrain-service | 4,132 | 3 | REST | DEM upload, elevation query, slope/aspect compute |
| layout-service | 3,922 | 1 | REST | Panel array generation, tiling, zone planning |
| simulation-service | — | — | ConnectRPC+REST | Sun position, shadow map, hourly simulation |
| electrical-service | 3,050 | 1 | REST | String sizing, inverter grouping, basic loss model |
| routing-service | 1,811 | 0 | REST | A* cable/road routing |
| report-service | 1,400 | 1 | REST | BOM, PDF/CSV/XLSX export |
| asset-service | 1,116 | 0 | REST | Component catalog CRUD |
| commissioning-service | 2,196 | 1 | ConnectRPC+REST | IEC 62446-1 checklists, signoff, handover |
| structural-service | 1,653 | 1 | ConnectRPC+REST | ASCE 7-16 wind load, foundation sizing |
| twin-service | 1,428 | 1 | ConnectRPC+REST | Digital twin snapshot provisioning |
| protection-service | 1,269 | 1 | ConnectRPC+REST | Protection relay modeling |
| compute-service | 16,559 | 16 | ConnectRPC | Job orchestration, Rust bridge |
| compute-orchestration-service | 5,878 | 5 | ConnectRPC+REST | Event streaming, job scheduling |
| transmission-routing-service | 7,330 | 8 | REST | Constraint solving, pathfinding, scoring |
| optimization-service | 1,017 | 1 | REST | PSO, GA, SA algorithms |
| ml-service | 1,411 | 1 | REST | Yield/degradation/anomaly inference |
| graph-service | 846 | 1 | REST | Graph query service |
| geo-analytics-service | 1,347 | 1 | REST | Geospatial analysis |
| drawing-revision-service | 4,513 | 7 | REST | CAD versioning, revision management |
| cad-core-service | 2,184 | 4 | REST | CAD core operations |
| cad-annotation-service | 830 | 2 | REST | CAD annotations |
| cad-layer-block-service | 691 | 2 | REST | CAD layers and blocks |
| api-gateway-service | 1,703 | 1 | REST (proxy) | API aggregation/routing |
| interop-service | 939 | 2 | REST | External system bridges |
| plot-sheet-service | 919 | 2 | REST | Plot sheet generation |
| monolith | 807 | 1 | HTTP/2 h2c | All services on :9191 |

**76 test files total across services.**

### 1.2 Rust Compute Engine (61 .rs files, 9 modules)

- **ml-inference**: Model registry, yield forecasting, degradation, anomaly detection, scoring engine
- **terrain-compute**: Aspect, transmission analysis, pathfinding, flow accumulation, sky dome
- **solar-compute**: Radiation modeling, irradiance calculation
- **optimization-compute**: PSO, GA, SA implementations
- **extended-compute**: Extended array analysis
- **graph-compute / geo-compute**: Graph and geospatial algorithms
- **bridge-core**: HTTP bridge for Go ↔ Rust communication

### 1.3 Web Frontend (60 Svelte components, 13 test files)

Working: 3D Cesium viewer, project dashboard, panel generator, simulation panel,
electrical panel, financial panel, report/export panel, map search, inspector,
asset library, CAD import (KML/KMZ/DXF), keyboard shortcuts, toast notifications,
ErrorBoundary, ConnectivityIndicator, LoadingSkeleton.

### 1.4 Mobile App (49 Dart files, 0 test files)

Working: ConnectRPC transport, 8 typed service clients, Riverpod + Bloc providers,
GoRouter with shell route, dashboard, project list/detail, layout, simulation,
electrical, reports, map, financial (LCOE/NPV/IRR/payback), terrain screen.
Material 3 dark/light theme.

### 1.5 Shared Middleware (all services)

Recovery, Request ID, CORS, structured logging (zerolog), rate limiting (token bucket),
idempotency key middleware.

### 1.6 Infrastructure

- 33 proto files (v1 API versions) covering all domains
- 14 SQL migrations (PostGIS-enabled)
- docker-compose / podman-compose for full stack
- Prometheus + Grafana config (scrape configured, no service instrumentation)

---

## 2. What's Missing — By Phase

### PHASE 0 — Platform Hardening

> Sections 0.1–0.4 (Auth, Observability, CI/CD, Testing) are **deferred**.

| Task | Status | Notes |
|---|---|---|
| OpenAPI spec from protos | MISSING | buf.gen.yaml exists but no protoc-gen-openapi |
| Dart client codegen | MISSING | Mobile uses hand-written clients |
| REST alias deprecation plan | NOT STARTED | ConnectRPC handlers exist on 10/25 services |
| pgxpool config standardized | PARTIAL | Only in 3 services; need uniform config |
| Cursor-based pagination | PARTIAL | A few protos; not consistent across services |
| Health checks with db.Ping | PARTIAL | `/healthz` returns OK but doesn't verify DB |
| Redis cache layer | MISSING | |
| DB backup/PITR procedure | MISSING | |

### PHASE 1 — EPC Engineering Core

| Task | Status | Impact |
|---|---|---|
| **PAN/OND parsers** | MISSING | Can't import real module/inverter specs |
| **Seed component catalog** | MISSING | No real Voc/Isc/Vmp/Imp/NOCT data |
| **weather-service** | MISSING | No real irradiance → all yield numbers are estimates |
| NSRDB/PVGIS/ERA5 adapters | MISSING | No weather data source |
| TMY/EPW file importers | MISSING | |
| P50/P90/P99 yield calc | MISSING | |
| Bifacial view-factor model | MISSING | Proto mentions it; no implementation |
| Tracker backtracking algorithm | MISSING | Tracker enum exists; no physics |
| IAM (ASHRAE, Martin-Ruiz) | MISSING | |
| Spectral correction | MISSING | |
| Cell temperature models | MISSING | |
| Soiling monthly curves | MISSING | Loss fields hardcoded |
| Snow loss (Marion model) | MISSING | |
| LID/PID degradation model | MISSING | |
| Inverter clipping analysis | MISSING | |
| DC/AC ratio optimizer | MISSING | |
| Loss waterfall report | MISSING | |
| Horizon profile from DEM | MISSING | |
| 3D obstacle shading (OBJ/glTF) | MISSING | |
| Per-panel hourly shading mask | MISSING | |
| LiDAR/LAS/LAZ import | MISSING | |
| GeoTIFF orthomosaic | MISSING | |
| Grading analysis (cut/fill) | MISSING | |
| Setback/exclusion zone logic | PARTIAL | Proto exists; no spatial engine |
| Drainage overlay | MISSING | |

### PHASE 2 — Electrical Detail & Compliance

| Task | Status | Impact |
|---|---|---|
| MPPT string-sizer | PARTIAL | Basic Voc/Vmp window; not production-grade |
| **Wire sizing + voltage drop** | MISSING | Critical for construction drawings |
| Conduit fill calculator | MISSING | |
| Short-circuit / fault-current | MISSING | |
| Arc-flash analysis (IEEE 1584) | MISSING | |
| Grounding / bonding design | MISSING | |
| **SLD auto-generator** | MISSING | Required for every permit package |
| 3LD generator | MISSING | |
| Stringing diagram | MISSING | |
| **NEC 690/705 rule engine** | MISSING | Required for US permitting |
| IEC 60364 rule engine | MISSING | Required for international |
| AHJ template library | MISSING | |
| **interconnection-service** | MISSING | POI modeling, IEEE 1547 forms |
| Snow load (ASCE 7) | MISSING | Wind load done; snow not |
| Stress / deflection checks | MISSING | |

### PHASE 3 — Procurement

| Task | Status |
|---|---|
| Multi-vendor pricing | MISSING |
| Lead-time tracking | MISSING |
| **procurement-service** | MISSING — directory doesn't exist |
| RFQ generator | MISSING |
| Vendor registry | MISSING |
| Purchase-order workflow | MISSING |
| ERP export (SAP/NetSuite) | MISSING |

### PHASE 4 — Construction

| Task | Status |
|---|---|
| **schedule-service** | MISSING — directory doesn't exist |
| WBS / task dependencies / CPM | MISSING |
| Gantt visualization | MISSING |
| As-built vs as-designed comparison | MISSING |
| NCR workflow | MISSING |
| RFI tracking | MISSING |
| Punch list | MISSING |
| Offline-first sync (mobile) | SCAFFOLD — Hive initialized, no queue |
| Barcode/QR scanner | MISSING |
| Photo capture with EXIF/GPS | MISSING |
| Daily report template | MISSING |

### PHASE 5 — Commissioning & O&M

| Task | Status | Notes |
|---|---|---|
| IV-curve file importer | MISSING | Commissioning-service exists but no IV-curve ingest |
| Insulation resistance test log | MISSING | |
| PR validation vs simulation | MISSING | |
| **monitoring-service** | MISSING — directory doesn't exist | |
| SCADA adapters (Modbus/OPC-UA/DNP3) | MISSING | |
| Inverter vendor APIs | MISSING | |
| Time-series store | MISSING | |
| Real-time dashboard | MISSING | |
| Performance Ratio analytics | MISSING | |
| Work-order system | MISSING | |
| Warranty tracking | MISSING | |
| Preventive maintenance | MISSING | |

### PHASE 6 — UX / A11y / Quality

| Task | Status |
|---|---|
| Responsive breakpoints (web) | MINIMAL — ~10 Tailwind prefixes, not comprehensive |
| ARIA roles / focus management | MISSING — 0 aria-* attributes found |
| Playwright e2e tests | MISSING |
| Form validation framework (web) | MISSING |
| Mobile shimmer/skeleton | MISSING |
| Mobile pull-to-refresh (all lists) | PARTIAL — 50% of lists |
| Mobile form validation | MISSING |
| Mobile connectivity monitoring | SCAFFOLD — pubspec dep only, no code |
| Mobile bloc_test coverage | MISSING — 0 test files |
| Mobile deep links | MISSING |
| Mobile routing/asset screens | MISSING |
| Circuit-breaker middleware | MISSING |
| Sentry/Honeycomb SDK | MISSING |

### PHASE 7 — Release Readiness

| Task | Status |
|---|---|
| Threat model (STRIDE) | MISSING |
| Static analysis in CI | MISSING |
| Dependency scanning | MISSING |
| Secrets scanning (gitleaks) | MISSING |
| CSP/HSTS/security headers | MISSING |
| Upload virus scan | MISSING |
| Load test (k6 scripts) | MISSING |
| Chaos tests | MISSING |
| DR drill | MISSING |
| SLO definitions | MISSING |
| Billing / metering | MISSING |
| Legal (ToS, DPA, SLA) | MISSING |
| Onboarding tour | MISSING |
| Support runbook | MISSING |

---

## 3. Recommended Priority Order

### Tier 1 — Unlocks real engineering output
1. **Weather service + NSRDB/PVGIS adapters** (Phase 1.2)
2. **PAN/OND parsers + seed catalog** (Phase 1.1)
3. **Complete loss model** (Phase 1.4)
4. **Wire sizing + voltage drop** (Phase 2.1)
5. **SLD/3LD auto-generation** (Phase 2.2)

### Tier 2 — Required for permitting
6. **NEC/IEC rule engine** (Phase 2.4)
7. **Interconnection service** (Phase 2.3)
8. **Shading analysis** (Phase 1.5)
9. **Structural snow load** (Phase 2.5)

### Tier 3 — Required for construction
10. **Procurement service** (Phase 3.2)
11. **Schedule service** (Phase 4.1)
12. **Mobile offline sync** (Phase 4.3)

### Tier 4 — Post-construction
13. **Monitoring / SCADA** (Phase 5.2)
14. **IV-curve commissioning** (Phase 5.1)
15. **O&M workflow** (Phase 5.4)

### Tier 5 — Polish & release
16. **UX / A11y** (Phase 6)
17. **Security / load testing / business** (Phase 7)

---

## 4. New Services Required

| Service | Port | Phase |
|---|---|---|
| weather-service | :8088 | 1.2 |
| interconnection-service | — | 2.3 |
| procurement-service | :8089 | 3.2 |
| schedule-service | :8090 | 4.1 |
| monitoring-service | :8092 | 5.2 |

---

## 5. EPC Coverage Estimate

| EPC Stage | Current | After Tier 1-2 | After Full Roadmap |
|---|---|---|---|
| Site assessment | 40% | 75% | 90% |
| Design (layout, shading) | 50% | 75% | 85% |
| Engineering (electrical, civil) | 25% | 65% | 85% |
| Procurement | 10% | 10% | 80% |
| Construction | 5% | 5% | 75% |
| Commissioning | 20% | 20% | 80% |
| O&M | 0% | 0% | 75% |
| **Overall** | **~20%** | **~40%** | **~85%** |
