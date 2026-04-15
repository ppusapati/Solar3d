# Solar3D — Roadmap to Completion

Scope: everything required to take Solar3D from its current conceptual-design state
to a production-grade Solar EPC platform.
**Explicitly OUT OF SCOPE for this roadmap**: collaboration features (multi-cursor,
comments, review/approval workflows, client portals). Those are deferred.

Progress legend: `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked

---

## PHASE 0 — Platform Hardening (prerequisite for everything)
<!-- 
### 0.1 AuthN / AuthZ / Multi-tenancy
- [ ] Shared JWT middleware in `services/shared/auth/` (verify RS256, extract claims)
- [ ] Claims schema: `tenant_id`, `user_id`, `role`, `exp`, `iat`
- [ ] RBAC policy (Casbin) per service: Admin / Engineer / PM / Viewer
- [ ] Add `tenant_id` column to every table + row-level scoping in queries
- [ ] Login/refresh endpoints in a new `auth-service` (bcrypt + refresh tokens)
- [ ] OIDC / SAML SSO adapter (Auth0 / Keycloak compatible)
- [ ] Rate limiter keyed by `tenant_id` + IP (not just IP)
- [ ] Audit-log table + middleware writing every mutation

### 0.2 Observability
- [ ] Prometheus `/metrics` endpoint in each service (`promhttp.Handler`)
- [ ] Standard counters: `http_requests_total`, `http_request_duration_seconds`
- [ ] Business counters: `projects_created_total`, `simulations_run_total`, …
- [ ] OpenTelemetry SDK + OTLP exporter, tracing middleware
- [ ] W3C `traceparent` propagation between services
- [ ] Grafana dashboards per service (latency, errors, saturation)
- [ ] Alertmanager rules: high-error-rate, high-latency, DB down, queue depth

### 0.3 CI/CD
- [ ] `.github/workflows/ci.yml`: lint (golangci, eslint, dart analyze), test, build
- [ ] Proto breaking-change check (`buf breaking`)
- [ ] Docker image build + push per service (tagged by SHA)
- [ ] Mobile build: iOS (fastlane) + Android (Gradle) artifacts
- [ ] CD: ArgoCD / FluxCD applying `deploy/k8s/` manifests per env
- [ ] Secrets via Sealed-Secrets or External-Secrets Operator

### 0.4 Testing foundation
- [ ] Go test harness with `testcontainers-go` for Postgres
- [ ] Integration test per RPC method (minimum 60 tests)
- [ ] Flutter `bloc_test` for every Bloc (5 Blocs → ≥ 25 state transitions)
- [ ] Vitest + Playwright for web (smoke + critical path e2e)
- [ ] Coverage gate in CI: ≥ 70% line coverage per service -->

### 0.5 API consistency
- [ ] Migrate 7 REST services to ConnectRPC path format
  (`/solar.<domain>.v1.<Service>/<Method>`)
- [ ] Keep `/api/v1/*` routes as aliases for 1 minor version, then deprecate
- [ ] Regenerate mobile service clients (remove hand-written JSON)
- [ ] `buf generate` pipeline for Go + TS + Dart clients
- [ ] OpenAPI spec generated from protos (`protoc-gen-openapi`)
- [ ] Buf Schema Registry published for external consumers

### 0.6 Data / DB
- [ ] Pool config: `MaxConns=20, MinConns=4, MaxConnLifetime=30m, MaxConnIdleTime=5m` in all 8 services
- [ ] Add pagination (`limit`, `cursor`) to every `List*` RPC (7 services remaining)
- [ ] Health checks with `db.Ping` in all 8 services
- [ ] Redis cache layer (`services/shared/cache/`) with TTL helpers
- [ ] Database backup + PITR procedure documented + tested

---

## PHASE 1 — EPC Engineering Core

### 1.1 Component catalog (real data)
- [ ] PAN file parser (PVsyst modules) → `asset-service`
- [ ] OND file parser (PVsyst inverters) → `asset-service`
- [ ] Seed catalog: top 20 modules (Trina, Jinko, LONGi, JA, Canadian) + top 10 inverters (SMA, Sungrow, SolarEdge, Huawei)
- [ ] Electrical params: Voc, Isc, Vmp, Imp, Pmax, NOCT, temp coefficients
- [ ] Mechanical params: weight, dimensions, frame type, mounting holes
- [ ] Tracker catalog: Nextracker, Array Technologies, PV Hardware
- [ ] BOS component catalog: combiners, transformers, cables, fuses

### 1.2 Weather / irradiance data
- [ ] `weather-service` (new) with adapters for:
  - [ ] NSRDB (NREL) — hourly TMY
  - [ ] PVGIS (EU) — monthly & hourly
  - [ ] NASA POWER — daily
  - [ ] ERA5 reanalysis
- [ ] EPW / TM2 / TM3 / CSV TMY importer
- [ ] P50 / P90 / P99 probabilistic yield calc
- [ ] Cached per-site weather bundle in S3

### 1.3 Advanced PV modeling
- [ ] Bifacial model (view-factor + ground-reflectance)
- [ ] Fixed-tilt / single-axis / dual-axis tracker support in `layout-service`
- [ ] Tracker backtracking algorithm
- [ ] Cell temperature model: Sandia, Faiman, NOCT
- [ ] IAM (Incidence Angle Modifier) — ASHRAE, Martin-Ruiz
- [ ] Spectral correction (FirstSolar, Sandia)
- [ ] Mismatch / partial-shading model at string level

### 1.4 Loss model (full)
- [ ] Soiling monthly curves (region-keyed defaults)
- [ ] Snow losses (Marion model)
- [ ] LID / PID degradation
- [ ] Inverter clipping analysis
- [ ] DC/AC ratio optimizer
- [ ] Thermal losses (cable resistance vs temp)
- [ ] Transformer / transmission losses
- [ ] Availability derating

### 1.5 Shading analysis
- [ ] Horizon profile from terrain DEM (near + far)
- [ ] 3D obstacle import (OBJ / glTF / IFC)
- [ ] Tree / building catalog with shadow casting
- [ ] Self-shading inter-row optimization
- [ ] Hourly shading mask per panel

### 1.6 Site data ingestion (extend existing CAD flow)
- [ ] LiDAR / LAS / LAZ point-cloud importer (via PDAL or pure Go)
- [ ] GeoTIFF orthomosaic layer support
- [ ] Drone imagery overlay (WebODM integration)
- [ ] Parcel / cadastral data fetch (county GIS adapters)
- [ ] Google / Bing / Mapbox imagery layer switcher

### 1.7 Civil / site engineering
- [ ] Grading analysis (cut/fill volume from target plane)
- [ ] Setback / easement / exclusion-zone polygons
- [ ] Drainage overlay (flow accumulation from DEM)
- [ ] Geotechnical layer import (soil type, bearing capacity)
- [ ] Access road designer extension

---

## PHASE 2 — Electrical Detail & Compliance

### 2.1 Detailed electrical design
- [ ] MPPT string-sizer (Voc_cold / Vmp_hot window)
- [ ] Wire ampacity + voltage-drop calculator (NEC Chapter 9)
- [ ] Conduit fill calculator
- [ ] Short-circuit / fault-current analysis
- [ ] Grounding / bonding design (GEC sizing)
- [ ] Arc-flash analysis (IEEE 1584)
- [ ] Lightning protection / SPD placement

### 2.2 Diagram generation
- [ ] SLD auto-generator (SVG → PDF)
- [ ] 3LD with transformers, meters, switchgear
- [ ] Stringing diagram (MPPT → module mapping)
- [ ] Combiner / recombiner schematics
- [ ] AC collection system diagrams
- [ ] SCADA / monitoring architecture diagram

### 2.3 Interconnection
- [ ] `interconnection-service` (new)
- [ ] POI modeling (utility side)
- [ ] Transformer + substation sizing
- [ ] Reactive-power / voltage-support study
- [ ] Application form templates (SGIP, FERC, IEEE 1547)

### 2.4 Code compliance
- [ ] NEC 690 / 705 / 706 rule engine
- [ ] IEC 60364 rule engine
- [ ] AHJ template library (top 20 US jurisdictions)
- [ ] UL listing validation checks
- [ ] Rule violations surfaced in web + mobile with fix suggestions

### 2.5 Structural
- [ ] Foundation designer (driven pile, ballast, helical)
- [ ] ASCE 7 wind-load calculator
- [ ] Snow-load per zone (IBC)
- [ ] Rack / tracker structural selection from load criteria
- [ ] Stress / deflection checks

---

## PHASE 3 — Procurement

### 3.1 BOM enhancements
- [ ] Multi-vendor pricing per line item
- [ ] Lead-time field + supply-chain flags
- [ ] Regional availability matrix
- [ ] Tariff / duty / logistics cost layer
- [ ] Spare parts allocator (% of installed base)

### 3.2 Procurement workflow
- [ ] `procurement-service` (new)
- [ ] RFQ generator (PDF + email)
- [ ] Vendor registry + approved-vendor list
- [ ] Purchase-order CRUD with status machine
- [ ] Shipment / delivery tracking integration
- [ ] Incoterms + trade-document uploader

---

## PHASE 4 — Construction

### 4.1 Scheduling
- [ ] `schedule-service` (new)
- [ ] WBS / task hierarchy
- [ ] Gantt chart (web) with critical path
- [ ] Milestone tracking
- [ ] Dependencies (FS / SS / FF / SF)
- [ ] Resource allocation (crews, equipment)
- [ ] EVM calculations (PV, EV, AC, CPI, SPI)

### 4.2 Construction execution
- [ ] As-built vs as-designed comparison tool
- [ ] Daily progress reports (mobile-first)
- [ ] Crew / time tracking (clock-in/out, GPS)
- [ ] QC checklists (foundation, racking, module, electrical)
- [ ] Punch list with photo + location
- [ ] NCR (non-conformance report) workflow
- [ ] RFI tracking

### 4.3 Safety & compliance
- [ ] JSA template library
- [ ] Incident tracker (OSHA 300 / 301)
- [ ] Toolbox-talk logs
- [ ] Permit (hot work, LOTO) manager

### 4.4 Mobile field features
- [ ] Offline-first sync (Hive local queue)
- [ ] Photo capture with EXIF geotag
- [ ] Barcode / QR scan for serial-number tracking
- [ ] Signature capture widget
- [ ] GPS-guided panel placement AR overlay
- [ ] On-site checklist runner

---

## PHASE 5 — Commissioning & O&M

### 5.1 Commissioning
- [ ] `commissioning-service` (new)
- [ ] IV-curve file importer (Daystar, Solmetric formats)
- [ ] Thermal imagery ingest (FLIR, DJI)
- [ ] Insulation resistance / PI test logs
- [ ] PR validation vs simulation model
- [ ] Turnover document pack generator

### 5.2 O&M / monitoring
- [ ] `monitoring-service` (new)
- [ ] SCADA adapters: Modbus TCP, DNP3, OPC-UA
- [ ] String-level monitoring ingestion
- [ ] Inverter fault-code dictionary
- [ ] Alarm manager with priority + acknowledge
- [ ] Preventive maintenance scheduler
- [ ] Work-order system (open → dispatch → complete)
- [ ] Warranty tracker per serial number
- [ ] Degradation analysis (year-over-year PR)

### 5.3 Performance analytics
- [ ] PVWatts vs actual benchmarking
- [ ] Availability / MTBF / MTTR metrics
- [ ] Revenue-grade metering ingestion
- [ ] Portfolio dashboard (MW, $, PR across projects)

---

## PHASE 6 — UX / a11y / Quality Polish

### 6.1 Web frontend
- [ ] Responsive breakpoints (mobile / tablet / desktop) in all panels
- [ ] ARIA labels + roles on every interactive element
- [ ] Keyboard focus ring + skip-to-content
- [ ] Branded confirmation modal (replace native `confirm()`)
- [ ] Replace silent `catch {}` blocks with toast + structured log
- [ ] Form validation framework (zod or similar)
- [ ] Status filter on project list; search/filter on every list
- [ ] Pagination UI aligned with backend cursor pagination
- [ ] Cesium lazy-loaded via dynamic import
- [ ] Design tokens via CSS custom properties (replace scattered hex)
- [ ] Light mode + theme toggle
- [ ] Wire `ConnectivityIndicator` / `ErrorBoundary` / `LoadingSkeleton` everywhere

### 6.2 Mobile (Flutter)
- [ ] Use `validators.dart` in every form (convert TextField → TextFormField)
- [ ] Add RefreshIndicator to Layout, Simulation, Electrical, Reports screens
- [ ] Add search to Layout, Simulation, Electrical, Reports screens
- [ ] Shimmer skeletons for list loads (replace spinners)
- [ ] Connectivity monitoring Bloc (use `connectivity_plus`)
- [ ] Offline cache via Hive for reads; write-queue for mutations
- [ ] Bloc `EventTransformer.debounce` on search events
- [ ] Typed exceptions in service layer; Bloc maps to user-friendly messages
- [ ] Deep linking (`solar3d://project/<id>/layout`)
- [ ] Missing screens: Routing, Asset catalog
- [ ] Dark-mode audit of every screen

### 6.3 Integrations / export
- [ ] PVsyst project export (.PRJ)
- [ ] Helioscope project import
- [ ] SketchUp / Rhino / AutoCAD round-trip via IFC
- [ ] ArcGIS / QGIS plugin
- [ ] ERP webhooks (SAP, NetSuite, QuickBooks)
- [ ] IEC 61724 performance data format export
- [ ] IFC (BIM) export for construction package

---

## PHASE 7 — Release Readiness

- [ ] Threat model + pentest against staging
- [ ] Load test: 500 concurrent users, 100k-panel layouts
- [ ] Chaos testing (Litmus / Chaos Mesh) on staging cluster
- [ ] DR drill: restore from PITR in < 1 hr, < 15 min RPO
- [ ] SLO definitions + error budgets documented
- [ ] Runbooks: incident, on-call rotation, escalation
- [ ] Data retention + GDPR/CCPA deletion flows
- [ ] Billing integration (Stripe) — plans, metering, invoicing
- [ ] Legal: ToS, privacy policy, DPA
- [ ] Production go-live checklist signed off

---

## Sequencing & Dependencies

Phase 0 (Platform) ──┐
├─► Phase 1 (Engineering Core) ──┐
│ ├─► Phase 3 (Procurement)
│ │
└─► Phase 2 (Electrical/Code) ───┴─► Phase 4 (Construction) ─► Phase 5 (O&M)
│
Phase 6 (UX polish) ─ parallel ─┤
│
Phase 7 (Release)


Phase 0 is a hard blocker for everything. Phases 1 and 2 can run in parallel once 0 lands.
Phase 6 (UX) runs in parallel with all feature phases.

---

## Summary metrics

- **Checkbox count**: ~220 discrete tasks.
- **New services required**: 6 (auth, weather, interconnection, procurement, schedule, commissioning, monitoring).
- **Estimated EPC coverage**: 15% today → ~85% at roadmap completion.
- **Out of scope (by request)**: all collaboration features — deferred to a future roadmap.
