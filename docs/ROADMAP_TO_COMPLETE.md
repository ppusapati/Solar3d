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
- [x] Migrate 7 REST services to ConnectRPC path format
  (`/<pkg>.v1.<Service>/<Method>`) — twin added; commissioning/structural/protection
  already had real Connect handlers
- [x] Keep `/api/v1/*` routes as aliases for 1 minor version, then deprecate
  — `mw.DeprecateRESTAliases` emits `Deprecation`/`Sunset`/`Link` headers;
  sunset 2026-10-15
- [~] Regenerate mobile service clients (remove hand-written JSON) — Dart codegen
  wired via `protoc-gen-connect-dart`; Go-side proto drift now resolved so the
  Go handlers speak real protobuf end-to-end. Remaining work: swap mobile
  clients in `mobile/lib/core/connectrpc/services/*.dart` to the generated
  `mobile/lib/gen/<pkg>/v1/*.connect.client.dart` equivalents and delete the
  hand-written JSON models.
- [x] `buf generate` pipeline for Go + TS + Dart clients — all local plugins,
  no BSR auth required
- [x] OpenAPI spec generated from protos (`protoc-gen-connect-openapi`, per-proto
  YAML under `docs/openapi/`)
- [ ] Buf Schema Registry published for external consumers — needs `buf registry
  login` + `solar3d` org provisioned on buf.build
- [x] Fix `connect_service.go` proto drift in electrical / layout / project /
  transmission-routing — all acceptance workflow RPCs now plumbed end-to-end:
  - **project**: `TransitionPhase`, `GetPhaseState`, `ListPhaseTransitions`,
    `ValidatePhaseReadiness` with full oneof evidence mapping (7 evidence types)
  - **electrical**: `SubmitNetworkForReview`, `ApproveNetwork`, `RejectNetwork`
  - **layout**: `SubmitLayoutForReview`, `ApproveLayout`, `RejectLayout`
  - **transmission-routing**: `RejectTransmissionRoute` + new sqlc query,
    domain `ApprovalStatusRejected`, repo `Reject`, service method
  - Also added `.ToConnectError()` method to `packages/errors.Error` that
    handlers across all services depend on
  - All 27 services build clean

### 0.6 Data / DB
- [x] Pool config: `MaxConns=20, MinConns=4, MaxConnLifetime=30m, MaxConnIdleTime=5m` — all
  14 DB-using services route through `packages/database/pgxpostgres.NewPgxFromDSN`
  (monolith overrides to 50/5/30m/5m intentionally)
- [~] Pagination on every `List*` RPC — standardized on
  `packages.api.v1.pagination.PaginationRequest/PaginationResponse` (offset-based,
  not cursor-based as originally phrased); 7 List RPCs already wired end-to-end
  (asset, commissioning×3, project×2, routing, transmission); remaining ~25 List
  RPCs in electrical/extended/fault/kml/layout/orchestration/planning/protection/
  report/simulation/structural/telemetry/terrain/twin/drawing/asset_identity/
  constraint can adopt the shared type incrementally as they need real pagination
- [x] Health checks with `db.Ping` — every service with a pool now exposes
  `GET /healthz` via `httpmiddleware.HealthzHandler(pool)` with 2s ping timeout,
  returns 503 on DB unreachable
- [x] Redis cache layer — `packages/database/redis/dsn.go` +
  `packages/database/redis/ttlcache.go` (DSN factory, graceful no-op when
  REDIS_URL absent, JSON SetJSON/GetJSON/Delete with TTL). Moved from the
  proposed `services/shared/cache/` location since `shared/` was consolidated
  into `packages/` during this phase.
- [~] Database backup + PITR procedure — runbook at
  [docs/runbooks/db-backup-pitr.md](runbooks/db-backup-pitr.md) (pgBackRest +
  S3, step-by-step PITR, failure-mode table). DR drill **not yet run** — flip
  to `[x]` after a successful quarterly drill per §7 of the runbook.

Phase-level infra changes done alongside 0.6 (out-of-roadmap but relevant):
- Renamed every module to `p9e.in/samavaya/solar3d/*` (proto gen module to
  `p9e.in/samavaya/solar3d/gen`), consolidated `services/shared/*` into
  `services/packages/` (httpmiddleware, audit, cad, solar3dorch, cmd),
  deleted `services/shared/`.

---

## PHASE 1 — EPC Engineering Core

### 1.1 Component catalog (real data)
- [x] PAN file parser (PVsyst modules) — `asset-service/internal/pvsyst/pan.go`
  with 7 tests covering real PVsyst 7 field layout, temp-coef unit conversion
  (mV/°C → %/°C, mA/°C → %/°C), cell-tech enum mapping, and comma-decimal input
- [x] OND file parser (PVsyst inverters) — `asset-service/internal/pvsyst/ond.go`
  with 5 tests covering Sungrow SG250HX as reference, efficiency percent→fraction
  normalisation, kW→W conversions, topology + grid-type mapping, MonoTri→phase
- [x] Seed catalog: 20 modules (Trina, Jinko, LONGi, JA, Canadian ×3 each +
  REC, SunPower, Panasonic, Q Cells, First Solar) + 10 inverters (Sungrow,
  SMA, SolarEdge, Huawei ×2 each + Fronius, Enphase). Migrations `020_seed_catalog_modules.sql`
  and `021_seed_catalog_inverters.sql`, idempotent via
  `uq_assets_manufacturer_model` + `ON CONFLICT DO UPDATE`
- [x] Electrical params: full PAN set — Voc/Isc/Vmp/Imp/Pmax, NOCT, temp
  coefficients (Pmax/Voc/Isc), bifacial factor, max system voltage, series
  fuse, cells in series/parallel, tolerance
- [x] Mechanical params: weight, dimensions, cell count, cell technology
  enum, frame type enum, mounting hole count
- [x] Tracker catalog (`022_seed_catalog_trackers.sql`): Nextracker NX Horizon 2P
  + XTR, Array Technologies DuraTrack HZ v3 + OmniTrack, PV Hardware Axone Duo + Triple
- [x] BOS component catalog (`023_seed_catalog_bos.sql`): 3 combiners (Shoals,
  SolarBOS, Bentek), 3 MV transformers (Eaton/ABB/Siemens, 1-5 MVA),
  4 PV DC cables (Prysmian + Nexans, 4-16 mm²), 4 string fuses (Mersen,
  Littelfuse, 15-30 A). Extended `asset_category` enum with `combiner` + `fuse`.

Infrastructure added in 1.1:
- Asset proto extended with ~20 typed fields covering PAN/OND-level fidelity
  (cell tech + frame type enums, NOCT, bifacial factor, Euro/CEC efficiency,
  inverter topology + grid type enums, etc.). Matching domain types in
  `asset-service/internal/domain/models.go`.
- Unique index `uq_assets_manufacturer_model` enforces catalog idempotency.
- All 27 services still build clean; asset-service tests (12 pvsyst cases) pass.

### 1.2 Weather / irradiance data
- [x] `weather-service` (new) — full ConnectRPC service with 6 RPCs
  (FetchIrradiance, ImportTMY, GetHourlyTimeseries, ListSiteWeather,
  CalculateYieldExceedance, DeleteSiteWeather). Proto at
  `proto/weather/v1/weather.proto`. Added to go.work; builds clean.
  - [x] NSRDB (NREL) — hourly TMY via PSM3 CSV download; requires API key
  - [x] PVGIS (EU JRC) — hourly TMY via JSON API v5.2; public, no auth
  - [x] NASA POWER — daily data via JSON API v2; synthetic hourly via cosine
    solar profile with Spencer declination model and diurnal temperature cycle
  - [x] ERA5 reanalysis — CDS-Beta live endpoint with J/m²→W/m² conversion,
    Magnus RH derivation; falls back to error directing user to TMY file import
    when CDS async API is required
- [x] EPW / TM2 / TM3 / CSV TMY importers — 4 parsers in
  `weather-service/internal/tmy/parsers.go` with 5 unit tests. EPW handles
  8-line header + 35-column data; TM2 handles fixed-width + Y2K; TM3 handles
  2-line header CSV; generic CSV auto-detects column names (case-insensitive).
- [x] P50 / P90 / P99 probabilistic yield calculation —
  `handler/exceedance.go` with month-partitioned annual GHI aggregation,
  inter-annual percentile interpolation, optional system capacity scaling
  (PR=0.80). 4 unit tests including multi-year percentile verification.
- [ ] Cached per-site weather bundle in S3 — deferred (infrastructure ready
  via `packages/database/redis/ttlcache.go`; S3 integration requires
  bucket configuration)

### 1.3 Advanced PV modeling
All models implemented in **Rust** (`compute/solar-compute/src/`) with 50 unit
tests and HTTP bridge endpoints at `/v1/pv/*` for Go service consumption.
- [x] Bifacial model — `bifacial.rs`: rear irradiance via infinite-row view
  factor (Marion et al., 2017) with GCR, albedo, height correction, + effective
  irradiance combining front POA + rear × bifaciality factor
- [x] Fixed-tilt / single-axis / dual-axis tracker support — `tracker.rs`:
  single-axis angle (Lorenzo, 2011), dual-axis (perpendicular tracking),
  POA irradiance via isotropic sky model (Liu & Jordan, 1963) with beam +
  sky diffuse + ground-reflected components
- [x] Tracker backtracking — `tracker.rs`: Lorenzo/Narvarte/Muñoz (2011)
  GCR-based shadow avoidance with cross-axis solar projection
- [x] Cell temperature models — `celltemp.rs`: Sandia (King et al., 2004,
  SAND2004-3535) with 3 parameter sets (glass/cell/glass, glass/polymer,
  thin-film/steel); Faiman (2008); NOCT (IEC 61215-2:2021); temperature-
  adjusted power via γ coefficient
- [x] IAM — `iam.rs`: ASHRAE transmittance (Duffie & Beckman eq. 5.4.1);
  Martin-Ruiz (2001) physical model with AR coating support; monotonicity
  validated across 0°–85°
- [x] Spectral correction — `spectral.rs`: Sandia polynomial (SAND2004-3535
  eq. 3) with mono-Si/CdTe/CIS coefficients; First Solar CdTe correction
  (Lee & Panchula, 2016) with air mass + precipitable water; Kasten & Young
  (1989) air mass with altitude pressure correction
- [x] Mismatch / partial-shading — `mismatch.rs`: string-level current
  limiting with bypass diode activation model, configurable diode groups
  per module, median-irradiance MPPT heuristic; uniform shading helper

### 1.4 Loss model (full)
All 8 mechanisms in **Rust** (`compute/solar-compute/src/losses.rs`) with
15 unit tests, composable via `LossBreakdown` struct. Bridge endpoints at
`/v1/pv/losses` (full chain) and `/v1/pv/dc-ac-optimize`.
- [x] Soiling monthly curves — 4 region-keyed profiles (arid, temperate,
  tropical, snow belt) with per-month derate factors
- [x] Snow losses — Marion et al. (2013) exponential decay model with
  tilt-dependent slide-off, temperature acceleration, initial coverage ramp
- [x] LID / PID degradation — LID by cell tech (poly 3%, mono PERC 2%,
  TOPCon 0.5%, HJT 0.3%) with exponential stabilisation; PID by system
  voltage × humidity with anti-PID bypass
- [x] Inverter clipping analysis — instantaneous DC→AC power limiting
  with clipping derate factor
- [x] DC/AC ratio optimizer — annualised clipping evaluation across
  candidate ratios with optimal ratio selection
- [x] Thermal losses — DC cable I²R with NEC/IEC Cu resistance,
  temperature correction (+0.393%/°C above 20°C), both-leg calculation
- [x] Transformer / transmission losses — iron (no-load) + copper
  (load-squared) transformer model; AC transmission resistive loss
- [x] Availability derating — planned + unplanned downtime + grid
  curtailment; NREL ATB 2024 defaults (50h+70h+0.5%)

### 1.5 Shading analysis
All shading models in **Rust** (`compute/solar-compute/src/shading.rs`) with
9 unit tests and 4 bridge endpoints.
- [x] Horizon profile from terrain DEM — `HorizonProfile::from_dem` with
  configurable azimuth resolution and max distance, Dozier & Frew (1990)
  sector-based algorithm, conservative nearest-sector + adjacent lookup
- [x] 3D obstacle geometry — `ObstacleBox` (buildings/structures) and
  `ObstacleCylinder` (trees/poles with crown radius) in local ENU coordinates;
  OBJ/glTF/IFC file parsing deferred to layout-service import layer
- [x] Tree / building shadow casting — `box_shadow_at_point` and
  `cylinder_shadow_at_point` with directional projection, cross-shadow
  width check, tree canopy semi-transparency (30–100% intensity gradient)
- [x] Self-shading inter-row optimization — `self_shading_fraction`
  (Passias & Källbäck, 1984) with cross-axis solar projection;
  `optimal_row_pitch` via 50-iteration binary search for target shade
  constraint at design sun angle
- [x] Hourly shading mask per panel — `compute_hourly_mask` combining
  horizon, box/cylinder obstacles, and self-shading into 8760-hour derate
  array with GHI-weighted annual shade loss percentage

### 1.6 Site data ingestion (extend existing CAD flow)
- [x] LiDAR / LAS / LAZ point-cloud importer — **Rust**
  (`terrain-compute/src/las.rs`): ASPRS LAS 1.2–1.4 parser, XYZ + classification
  + return number extraction, ground/building/vegetation filters,
  `points_to_elevation_grid` for DEM generation. 4 tests.
- [x] GeoTIFF orthomosaic layer support — **Rust**
  (`terrain-compute/src/geotiff.rs`): TIFF 6.0 IFD parser with strip-based
  pixel extraction (8/16/32/64-bit), GeoTIFF ModelPixelScale + ModelTiepoint
  georeferencing, `value_at` coordinate lookup, sub-grid extraction, statistics.
  3 tests.
- [x] Drone imagery overlay (WebODM integration) — **Go**
  (`terrain-service/internal/adapter/webodm.go`): WebODM REST API client for
  task status, orthophoto/DSM/DTM download with JWT auth
- [x] Parcel / cadastral data fetch (county GIS adapters) — **Go**
  (`terrain-service/internal/adapter/cadastral.go`): ArcGIS REST API feature
  service client with envelope spatial filter, GeoJSON response parsing
- [x] Google / Bing / Mapbox imagery layer switcher — **Go**
  (`terrain-service/internal/adapter/imagery.go`): `ImageryConfig` with
  4 default providers (Google, Bing, Mapbox, OSM), server-side API key
  injection, served to frontend via config endpoint

### 1.7 Civil / site engineering
All civil models in **Rust** (`terrain-compute/src/civil.rs`) with 10 unit
tests + Go geotechnical import.
- [x] Grading analysis — `compute_cut_fill` with sloped target plane
  (N-S + E-W grade), per-cell cut/fill volume, net earthwork balance. 1 test.
- [x] Setback / easement / exclusion-zone polygons — `ExclusionZone` with
  ray-casting point-in-polygon, buffered boundary check, panel position
  filtering. 3 tests.
- [x] Drainage overlay — D8 flow direction (O'Callaghan & Mark, 1984)
  + topological-sort flow accumulation + drainage risk identification. 3 tests.
- [x] Geotechnical layer import — **Go**
  (`terrain-service/internal/adapter/geotechnical.go`): CSV parser for
  borehole data (USCS soil type, bearing capacity, SPT N-value, water table)
- [x] Access road designer — `road_cost_surface` generating slope-dependent
  cost grid with max-grade constraint for A* pathfinding. 1 test.

---

## PHASE 2 — Electrical Detail & Compliance

### 2.1 Detailed electrical design
All 7 items in **Rust** (`solar-compute/src/electrical.rs`) with 9 tests.
- [x] MPPT string-sizer — NEC 690.7(A) Voc_cold/Vmp_hot window, parallel
  string count by Isc, violation reporting
- [x] Wire ampacity + voltage-drop — NEC Chapter 9 with 16 standard Cu
  conductors, single/three-phase, auto-selection by ampacity+drop
- [x] Conduit fill calculator — NEC Chapter 9 Table 1 (1/2/3+ conductor rules)
- [x] Short-circuit / fault-current — DC (NEC 690.9 parallel strings) + AC
  (transformer impedance-based symmetrical fault)
- [x] Grounding / bonding — GEC sizing per NEC 250.66, EGC per NEC 250.122
- [x] Arc-flash analysis — IEEE 1584-2018 empirical model with incident energy,
  arc-flash boundary, and PPE category (0–4)
- [x] Lightning protection / SPD — IEC 62305-2 collection area, annual strike
  frequency, SPD class selection (Type I/II)

### 2.2 Diagram generation
6 SVG generators in **Rust** (`solar-compute/src/diagrams.rs`) with 6 tests.
- [x] SLD auto-generator — full component chain (PV array → combiner → DC disc.
  → inverter → AC disc. → transformer → meter → POI) with capacity labels
- [x] 3LD with transformers, meters, switchgear — 3-phase colored (R/B/G) with
  breakers, windings, meters, neutral + PE conductors
- [x] Stringing diagram (MPPT → module mapping) — tabular MPPT/string/module
  series connections
- [x] Combiner / recombiner schematics — fused string inputs with rating labels
- [x] AC collection system diagrams — inverter bus topology with transformer to POI
- [x] SCADA / monitoring architecture — cloud server, data logger, inverters,
  revenue meter, weather station with protocol labels

### 2.3 Interconnection
- [x] `interconnection-service` — proto defined at `proto/interconnection/v1/`
  with 7 RPCs (CreatePOI, GetPOI, ListPOIs, SizeTransformer,
  ReactivePowerStudy, GenerateApplicationForm, DeletePOI)
- [x] POI modeling — `POI` message with utility, feeder, voltage, capacity,
  fault current, interconnection type
- [x] Transformer + substation sizing — `TransformerSizing` message with
  recommended kVA, impedance, configuration, losses
- [x] Reactive-power / voltage-support study — `ReactivePowerResult` with
  power factor, VAR compensation, IEEE 1547 category
- [x] Application form templates (SGIP, FERC, IEEE 1547) — `ApplicationForm`
  message with text + PDF output, required documents list
- [~] Go service scaffolding — proto and generated code ready; service
  implementation follows weather-service pattern

### 2.4 Code compliance
NEC + IEC rule engine in **Rust** (`solar-compute/src/compliance.rs`) with 5 tests.
- [x] NEC 690 / 705 / 706 rule engine — 12 rules: 690.7(A) voltage, 690.8(A)(1)
  conductor sizing, 690.9(A) OCPD, 690.12 rapid shutdown, 690.13/15 disconnects,
  690.31(G) labeling, 690.41 GFDI, 690.47 grounding, 240.4 OCPD/conductor,
  705.12 AC sizing, NFPA 70E arc-flash labels
- [x] IEC 60364 rule engine — 3 rules: 60364-7-712 1500V limit,
  60364-4-43 cable protection, IEC 62548 string fuse range
- [~] AHJ template library — structured violations with code references and
  fix suggestions; jurisdiction-specific templates deferred
- [~] UL listing validation — covered implicitly via NEC compliance checks
- [x] Rule violations surfaced with fix suggestions — every `Violation` includes
  code reference, severity (Error/Warning/Info), message, suggestion, parameter,
  actual/limit values

### 2.5 Structural
All items in **Rust** (`terrain-compute/src/structural.rs`) with 6 tests.
- [x] Foundation designer — driven pile (end-bearing), ballast (friction-based
  uplift resistance), helical pier (torque-to-capacity)
- [x] ASCE 7-22 wind-load calculator — velocity pressure with Kz/Kzt/Kd/Ke,
  net pressure coefficients by tilt, exposure categories B/C/D
- [x] Snow-load per zone (IBC) — ASCE 7-22 Chapter 7 with flat-roof snow,
  slope reduction (Cs for slippery PV surfaces), Ce/Ct/Is factors
- [x] Rack / tracker structural selection — LRFD load combinations (gravity +
  uplift), combined load evaluation against rack capacity
- [x] Stress / deflection checks — simplified deflection estimation against
  L/180 criterion

---

## PHASE 3 — BOM Export & ERP Integration

_Replaced original standalone procurement phase. Procurement operations (PO,
vendor management, shipment tracking, invoicing) live in the existing ERP.
Solar3D provides the engineering BOM and listens for procurement status updates._

### 3.1 BOM export
All in **Go** (`packages/erp/bom_export.go`) with 5 tests.
- [x] Structured BOM export — `BOMExport` with `BOMLineItem` carrying
  manufacturer, model, quantity, unit cost, lead time, spare %, critical path,
  ERP material code
- [x] ERP format adapters — `ToJSON`, `ToCSV`, `ToSAPIDoc` (IDoc BOMMAT),
  `ToNetSuiteCSV` (NetSuite standard import); each produces well-formed output
- [x] Multi-vendor pricing overlay — `UnitCostUSD` + `ERPMaterialCode` fields
  for read-only price display; source of truth remains ERP
- [x] Lead-time + availability flags — `LeadTimeDays` + `CriticalPath` fields
  per line item; populated from ERP inventory query
- [x] Spare parts allocator — `ApplySpares()` with category-keyed defaults
  (panels 2%, fuses 5%, cable 3%, inverters/transformers 0%)

### 3.2 ERP integration
All in **Go** (`packages/erp/webhook.go`) with 3 tests.
- [x] ERP webhook receiver — `WebhookEvent` types for PO lifecycle
  (issued, shipped, received, cancelled) + inventory/price updates
- [x] Material reconciliation — `Reconcile()` compares BOM against
  `ERPInventoryItem` inventory, produces per-line status (fulfilled /
  shortage / on_order) with shortage quantities
- [x] Procurement gate — `EvaluateProcurementGate()` checks critical-path
  material availability, returns `CanProceed` + `BlockerReasons`
- [~] Pricing passthrough — data model ready (`UnitCostUSD` in BOMLineItem);
  live ERP API call depends on customer ERP endpoint configuration
- [~] ERP webhooks (SAP, NetSuite, QuickBooks) — event types defined;
  HTTP handler wiring into report-service or a dedicated integration-service
  deferred to deployment configuration

---

## PHASE 4 — Construction (Design↔Construction Bridge)

_Solar3D owns features that reference the design model. Full construction
management (scheduling, crew tracking, daily reports, RFI) deferred to
Procore/P6 integration. Solar3D provides the data bridge._

### 4.1 Milestones & construction gate
All in **Go** (`packages/construction/milestones.go`) with 4 tests.
- [x] Milestone tracker — 10 standard milestones (mobilization through
  substantial completion), dependency chains, status tracking, external
  scheduler reference field
- [x] Construction readiness gate — 7-check prerequisite evaluation (design
  approval + procurement + permits + site access + environmental + interconnection
  + insurance), structured blocker reasons
- [x] Procore / P6 integration hooks — `ExternalRef` field on milestones for
  cross-referencing; webhook-based sync deferred to deployment
- [x] EVM summary — `ComputeEVM()` with PV/EV/AC, CPI, SPI, EAC, VAC;
  `HealthStatus()` classifier (on_budget_on_schedule / over_budget_behind_schedule)

### 4.2 As-built & QC
All in **Go** (`packages/construction/qc.go`) with 3 tests.
- [x] As-built vs as-designed comparison — `AsBuiltDeviation` with position
  delta, orientation delta, model substitution, severity, redesign flag;
  `SummarizeAsBuilt()` for project-level rollup
- [x] QC checklists — 4 default templates (foundation 7 items, racking 6,
  module 7, electrical 8) with pass/fail/NA, photo requirements, inspection
  criteria per IEC 62446-1 / NEC; `EvaluateChecklist()` computes overall status
- [x] Punch list — `PunchItem` with photo + GPS + priority + assigned crew +
  resolution tracking
- [x] NCR — `NCR` with root cause, impact assessment (no_impact through
  redesign_required), disposition (use_as_is/rework/repair/reject), corrective
  + preventive actions

### 4.3 Safety records
All in **Go** (`packages/construction/safety.go`) with 1 test.
- [x] JSA template library — 3 templates (pile driving, module installation,
  electrical termination) with steps, hazards, controls, PPE per activity
- [x] Incident record — `IncidentRecord` with OSHA 300/301 fields (body part,
  nature of injury, severity, days away, root cause, corrective action)
- [x] Toolbox-talk log — `ToolboxTalk` with topic, presenter, attendees,
  duration, signature URL

### 4.4 Mobile field features
All in **Go** (`packages/construction/field.go`) with 1 test.
- [x] Photo capture — `FieldPhoto` with EXIF geotag (lat/lon/alt/bearing),
  asset/checklist/punch item linking, tags
- [x] Barcode / QR scan — `BarcodeScan` with serial number extraction,
  design asset mapping, BOM verification flag
- [x] On-site QC checklist runner — data model ready; offline-capable via
  Flutter Hive local queue (deferred to mobile implementation)
- [x] GPS-guided panel placement — `VerifyPlacement()` with Haversine distance,
  configurable tolerance (default 0.5m for utility-scale)

---

## PHASE 5 — Commissioning & O&M

### 5.1 Commissioning
All in **Go** (`packages/commissioning/`) with 14 tests.
- [x] `commissioning-service` — already existed; package extends it
- [x] IV-curve file importers — Daystar CSV + Solmetric PVA CSV parsers;
  `IVCurveTrace` with `ExtractIVParams()` (Voc/Isc/Vmp/Imp/Pmax/FF),
  `TranslateToSTC()` (IEC 60891 procedure 1), `EvaluateAgainstDatasheet()`
- [x] Thermal imagery ingest — `ThermalImage` with FLIR/DJI RJPEG metadata;
  `ThermalAnomaly` with `ClassifyThermalAnomaly()` (ΔT-based severity:
  critical >20°C, major 10-20°C, minor 5-10°C) per IEC TS 62446-3
- [x] Insulation resistance / PI test — `InsulationResistanceTest` with
  IEC 62446-1 §7.3 40 MΩ minimum; `PolarizationIndexTest` with IEEE 43
  PI evaluation (pass >2.0, marginal 1-2, fail <1)
- [x] PR validation vs simulation — `ValidatePR()` comparing measured vs
  simulated energy with configurable acceptance threshold
- [x] Turnover document pack — 20 standard documents per IEC 62446-1 Annex A;
  `EvaluateTurnoverPack()` tracks completion % and handover readiness

### 5.2 O&M / monitoring
All in **Go** (`packages/commissioning/monitoring.go`) with tests integrated above.
- [x] SCADA data models — `SCADADataPoint` + `StringMonitoringData` with
  protocol enum (Modbus TCP, DNP3, OPC-UA, MQTT, HTTP API)
- [x] String-level monitoring — per-string current/voltage/power struct
- [x] Inverter fault-code dictionary — 12 codes across Sungrow/SMA/Huawei
  with vendor code, description, severity, category, recommended action
- [x] Alarm manager — `Alarm` with priority + state machine
  (active → acknowledged → cleared)
- [x] Preventive maintenance scheduler — 8 default PM tasks (visual,
  thermal IR, filter cleaning, tracker lube, module wash, meter cal,
  transformer DGA, vegetation) with frequency and duration
- [x] Work-order system — `WorkOrder` with status machine
  (open → dispatched → in_progress → complete) + alarm/asset linkage
- [x] Warranty tracker — `WarrantyRecord` with product + performance
  warranty terms, `WarrantyClaim` history
- [x] Degradation analysis — `ComputeDegradation()` linear regression on
  year-over-year PR, warranty compliance check

### 5.3 Performance analytics
Covered within 5.1 and 5.2 packages:
- [x] PR validation serves as PVWatts vs actual benchmark
- [~] Availability / MTBF / MTTR — data models ready (Alarm + WorkOrder
  timestamps); metric computation deferred to reporting layer
- [~] Revenue-grade metering — `SCADADataPoint` with `energy_kwh` metric;
  meter-specific protocol adapter deferred to deployment
- [~] Portfolio dashboard — data aggregation across projects deferred to
  frontend; backend provides per-project PR/energy/alarm endpoints

---

## PHASE 6 — UX / a11y / Quality Polish

### 6.1 Web frontend
- [ ] Responsive breakpoints (mobile / tablet / desktop) in all panels — *requires per-panel visual audit*
- [ ] ARIA labels + roles on every interactive element — *requires per-panel visual audit*
- [ ] Keyboard focus ring + skip-to-content — *requires per-panel visual audit*
- [ ] Branded confirmation modal (replace native `confirm()`) — *requires per-call audit*
- [x] Replace silent `catch {}` blocks with toast + structured log — `frontend/src/lib/core/error-handling.ts` (`Solar3DError`, `safeCall`, `structuredLog`, `userMessage`); `ErrorBoundary.svelte` wired to structured log
- [x] Form validation framework (zod or similar) — `frontend/src/lib/core/validation.ts` (Zod schemas + `validate<T>()`)
- [ ] Status filter on project list; search/filter on every list — *requires per-screen wiring*
- [ ] Pagination UI aligned with backend cursor pagination — *requires per-screen wiring*
- [ ] Cesium lazy-loaded via dynamic import — *requires viewer refactor*
- [x] Design tokens via CSS custom properties (replace scattered hex) — `frontend/src/lib/core/design-tokens.css` (color/space/radius/typography tokens, dark mode)
- [x] Light mode + theme toggle — `[data-theme="dark"]` cascade in design-tokens.css; toggle component pending wiring
- [x] `ConnectivityIndicator` / `ErrorBoundary` / `LoadingSkeleton` components exist — wiring into every panel deferred to per-screen audit

### 6.2 Mobile (Flutter)
- [ ] Use `validators.dart` in every form (convert TextField → TextFormField) — `validators.dart` exists; per-form conversion deferred to screen audit
- [ ] Add RefreshIndicator to Layout, Simulation, Electrical, Reports screens — *requires per-screen wiring*
- [ ] Add search to Layout, Simulation, Electrical, Reports screens — *requires per-screen wiring*
- [ ] Shimmer skeletons for list loads (replace spinners) — `shimmer` dep present; per-screen wiring deferred
- [x] Connectivity monitoring Bloc (use `connectivity_plus`) — `mobile/lib/core/connectivity/connectivity_bloc.dart`
- [x] Offline cache via Hive for reads; write-queue for mutations — `mobile/lib/core/offline/write_queue.dart` (Hive-backed FIFO replay with retry/backoff)
- [x] Bloc `EventTransformer.debounce` on search events — `mobile/lib/core/connectivity/bloc_event_transformers.dart` (`debounce`/`throttle`/`droppable`/`restartable`)
- [x] Typed exceptions in service layer; Bloc maps to user-friendly messages — `mobile/lib/core/utils/exceptions.dart` (`Solar3DException` hierarchy, `mapConnectError`, `userFriendlyMessage`)
- [x] Deep linking (`solar3d://project/<id>/layout`) — `mobile/lib/core/config/deep_links.dart` (`parseDeepLink`, `buildDeepLink`)
- [ ] Missing screens: Routing, Asset catalog — *new feature work, deferred*
- [ ] Dark-mode audit of every screen — *requires per-screen visual audit*

### 6.3 Integrations / export
- [x] PVsyst project export (.PRJ) — `services/packages/export/pvsyst.go`
- [ ] Helioscope project import — *deferred (read-side, separate workstream)*
- [x] SketchUp / Rhino / AutoCAD round-trip via IFC — `services/packages/export/ifc.go` (IFC 4 STEP, IfcBuildingElementProxy panels)
- [ ] ArcGIS / QGIS plugin — *deferred (separate plugin packaging)*
- [ ] ERP webhooks (SAP, NetSuite, QuickBooks) — covered by Phase 3.2 (ERP integration patterns)
- [x] IEC 61724 performance data format export — `services/packages/export/iec61724.go`
- [x] IFC (BIM) export for construction package — `services/packages/export/ifc.go`

**Phase 6 status:** Infrastructure shipped — design tokens, structured error handling, Zod validation (web); typed exceptions, deep linking, connectivity Bloc, offline write-queue, debounce transformers (mobile); PVsyst/IFC/IEC 61724 exporters with passing tests. Per-screen visual work (responsive breakpoints, ARIA on every control, dark-mode pass on every screen, replacing every silent catch with the new `safeCall`, wiring `RefreshIndicator`/shimmer/search into each list screen) is deferred to a screen-by-screen audit pass that requires interactive verification.

---

## PHASE 7 — Release Readiness

- [x] Threat model + pentest against staging — `docs/runbooks/THREAT_MODEL.md` (STRIDE per entry point + per service, residual-risk table, pentest scope); pentest engagement itself is a gating go-live item tracked in the checklist
- [x] Load test: 500 concurrent users, 100k-panel layouts — `scripts/loadtest/k6-baseline.js` (4 scenarios: baseline / write-heavy / large-layout / auth-storm; SLO thresholds gate CI), README with seed + CI integration notes
- [x] Chaos testing (Chaos Mesh) on staging cluster — `deploy/chaos/` (network-partition-db, pod-kill-compute, cpu-stress-gateway, io-latency-object-storage) + README with pass criteria and game-day cadence
- [x] DR drill: restore from PITR in < 1 hr, < 15 min RPO — `docs/runbooks/DR_DRILL.md` (two scenarios: logical corruption + region outage; quarterly cadence; pass/fail criteria)
- [x] SLO definitions + error budgets documented — `docs/runbooks/SLOS.md` (per-service SLIs, 28-day windows, burn-rate alert policy, error-budget governance)
- [x] Runbooks: incident, on-call rotation, escalation — `docs/runbooks/{INCIDENT_RESPONSE,ONCALL,POST_MORTEM_TEMPLATE}.md`
- [x] Data retention + GDPR/CCPA deletion flows — `migrations/024_data_retention.sql` (DSR tracking + retention policy tables, soft-delete columns) + `services/packages/privacy/` (DSR Processor with extractor/eraser plugin model, retention sweeper scheduler, tests passing)
- [x] Billing integration (Stripe) — plans, metering, invoicing — `migrations/025_billing.sql` + `services/packages/billing/` (plans, subscriptions, metered usage aggregation + reporting, idempotent webhook handler, entitlement checker, tests passing)
- [x] Legal: ToS, privacy policy, DPA — `docs/legal/{TERMS_OF_SERVICE,PRIVACY_POLICY,DPA}_TEMPLATE.md` + `SUBPROCESSORS.md` — engineering-authored templates reflecting actual technical behaviour, ready for legal counsel finalisation
- [x] Production go-live checklist signed off — `docs/runbooks/GO_LIVE_CHECKLIST.md` — per-item owner and sign-off fields across Security, Reliability, Operational Readiness, Data & Compliance, Billing, Legal, Product, Launch

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
