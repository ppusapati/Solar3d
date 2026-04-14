## Plan: AI-Only Step-by-Step Implementation Plan

This plan is optimized for one programmer only (AI), executing strictly in sequence. No parallel workstreams are assumed. Each step has clear outputs and verification gates. Implementation order is fixed: ML/Algorithms -> Go backend -> Frontend.

**Execution Rules (Single Programmer Mode)**
1. Complete one step fully before starting the next.
2. Do not open new feature branches inside the same step.
3. Every step ends with tests, docs update, and a checkpoint tag.
4. If a step fails verification, fix in the same step before moving forward.
5. Keep deterministic fallback active at all times, even when adding optimization/ML.

**Canonical Workflow Chain (Boundary-to-Twin)**
1. ProjectCreated
2. BoundaryReady
3. TerrainReady
4. LayoutReady
5. ElectricalReady
6. TransmissionReady
7. LOD400Ready
8. Approved
9. TwinActivated

Notes:
- Deterministic generation is the mandatory baseline path; optimization and ML are additive layers.
- Export/report actions are gated by approval plus LOD 400 readiness.
- Frontend phase navigation (Steps 26-34) must mirror this chain and enforce prerequisites.
- CAD/GIS data ingestion (Phase 4, Steps 35-39) feeds BoundaryReady by replacing the manual draw step with an upload-driven path. All downstream workflow phases are unchanged.

**Phase 0 - Program Bootstrap and Baseline (Step 1-3)**
1. Step 1: Create program baseline doc and acceptance matrix.
   - Deliverables:
     - Unified requirements matrix for complete layout, LOD 400 gates, workflow phases, and twin readiness.
     - Traceability matrix mapping requirement -> proto -> service -> UI.
   - Verification:
     - Matrix covers all requested outputs: panels, roads, strings, inverters, cabling, transformers, AC/DC equipment, fault identifiers, precision fields.
2. Step 2: Establish deterministic baseline benchmark.
   - Deliverables:
     - Baseline run scripts for boundary -> panel layout -> electrical -> transmission current flow.
     - Baseline latency and quality metrics snapshot.
   - Verification:
     - Baseline outputs reproducible across 3 repeated runs.
3. Step 3: Freeze architectural interfaces for ML phase inputs/outputs.
   - Deliverables:
     - Candidate artifact graph schema draft.
     - Objective and constraint dictionary draft.
   - Verification:
     - Schema can represent all required asset classes and relationships.

**Phase 1 - ML/Algorithms First (Step 4-12)**
4. Step 4: Define complete-layout artifact graph contract.
   - Deliverables:
     - Canonical data model for generated artifacts including geometry, topology, electrical metadata, and precision metadata.
   - Verification:
     - Contains linkable IDs for all generated entities and parent-child relationships.
5. Step 5: Define optimization decision space and constraints.
   - Deliverables:
     - Decision variables for tilt, azimuth, spacing, inverter block positioning, transformer siting, corridor routeability.
     - Hard constraints for boundaries, exclusions, slope limits, electrical limits.
   - Verification:
     - Constraint validation examples pass for valid and invalid candidates.
6. Step 6: Implement deterministic infrastructure synthesis.
   - Deliverables:
     - Deterministic generation of non-panel classes: roads, inverter zones, transformer zones, AC/DC equipment zones, cable corridor anchors, fault marker anchors.
   - Verification:
     - Repeated identical input produces identical full artifact graph hash.
7. Step 7: Implement multi-objective scoring engine.
   - Deliverables:
     - Objective scoring for MW fit, land utilization, terrain penalty, shading proxy, cable length proxy, BOS proxy.
   - Verification:
     - Objective scoring test suite validates monotonicity and weight behavior.
8. Step 8: Implement candidate search and Pareto generation.
   - Deliverables:
     - Candidate search executor producing ranked feasible set with explainability metadata.
   - Verification:
     - Candidate set includes feasibility status, score breakdown, and deterministic fallback candidate.
9. Step 9: Add electrical-aware penalties and heuristics.
   - Deliverables:
     - Penalties for infeasible stringing/inverter assignment, transformer overload risk, excessive cable proxies.
   - Verification:
     - Electrical feasibility score aligns with backend validation thresholds in sampled cases.
10. Step 10: Implement ML ranking layer on top of candidate set.
   - Deliverables:
     - Ranking API contract for candidate scoring and confidence.
     - Model inference integration preserving deterministic/algorithmic fallback.
   - Verification:
     - If ML disabled, system still returns deterministic + optimization result without failure.
11. Step 11: Performance and reproducibility hardening for ML/algorithms.
   - Deliverables:
     - Scale tests, latency profiling, reproducibility tests, fallback chaos tests.
   - Verification:
     - Meets defined SLOs and reproducibility thresholds.
12. Step 12: Freeze ML/algorithm contracts for backend integration.
   - Deliverables:
     - Versioned contract package and migration notes for backend consumers.
   - Verification:
     - No unresolved TODO in contract package; integration test fixture published.

**Phase 2 - Go Backend Second (Step 13-25)**
13. Step 13: Add PlanningWorkflow proto contracts.
   - Deliverables:
     - Workflow phase enum and transition RPC with typed evidence payloads.
   - Verification:
     - Proto generation and compatibility checks pass.
14. Step 14: Extend project service with phase state machine.
   - Deliverables:
     - Transition enforcement, actor metadata, immutable transition history.
   - Verification:
     - Phase skip attempts rejected with explicit blocker reasons.
15. Step 15: Add acceptance status contracts to layout/electrical/transmission.
   - Deliverables:
     - Acceptance fields, review metadata, quality score fields.
   - Verification:
     - Services reject progression when predecessor acceptance not met.
16. Step 16: Implement LOD 400 checklist model and scoring service.
   - Deliverables:
     - Asset-class checklist definitions and scoring engine with mandatory blockers.
   - Verification:
     - Mandatory fail blocks LOD400Ready regardless of score.
17. Step 17: Wire report/export gates to LOD acceptance.
   - Deliverables:
     - Export/report requires approved + LOD gate pass evidence.
   - Verification:
     - Non-compliant export attempts rejected consistently.
18. Step 18: Integrate ML/algorithm candidate contract into layout service.
   - Deliverables:
     - Backend endpoint consuming frozen candidate artifacts and chosen candidate lineage.
   - Verification:
     - End-to-end layout generation uses new artifact graph without data loss.
19. Step 19: Orchestrate LayoutReady -> ElectricalReady transition.
   - Deliverables:
     - Automatic job/event handoff with evidence payload.
   - Verification:
     - Manual intervention not required in normal path.
20. Step 20: Orchestrate ElectricalReady -> TransmissionReady transition.
   - Deliverables:
     - Electrical validation success triggers transmission workflow job with anchors and constraints.
   - Verification:
     - Transmission starts with complete payload and no missing anchors.
21. Step 21: Add twin/telemetry/fault proto contracts.
   - Deliverables:
     - Twin state schema, telemetry ingestion schema, fault event schema, identity mapping schema.
   - Verification:
     - All proto generations and compatibility checks pass.
22. Step 22: Build twin service.
   - Deliverables:
     - ProvisionTwin, IngestTelemetry, GetTwinState, LinkAssetIdentity endpoints.
   - Verification:
     - Twin can be provisioned from approved lineage and accept telemetry batches.
23. Step 23: Extend commissioning handover for twin provisioning payload.
   - Deliverables:
     - Required linkage fields: layout, electrical, transmission, asset identity mappings.
   - Verification:
     - Commissioning handover can trigger twin provisioning with complete mappings.
24. Step 24: Implement rollback and exception policies in workflow.
   - Deliverables:
     - Controlled rollback transitions and incident reasons for rejected phases.
   - Verification:
     - Negative integration tests pass for rejected transmission/review failures.
25. Step 25: Backend end-to-end stabilization.
   - Deliverables:
     - Full backend flow test: boundary -> complete layout -> electrical -> transmission -> LOD gate -> approved -> twin provisioned.
   - Verification:
     - Stable pass rate and documented runbook.

**Phase 3 - Frontend Third (Step 26-34)**
26. Step 26: Add workflow store and API integration layer.
   - Deliverables:
     - Frontend workflow store synced to backend phase and blockers.
   - Verification:
     - UI state mirrors backend phase transitions in real time.
27. Step 27: Refactor workspace shell to phase-based flow.
   - Deliverables:
     - Step rail and context panels driven by workflow phase, not generic views.
   - Verification:
     - Out-of-order actions disabled with visible blocker reasons.
28. Step 28: Add planning input contract capture UX.
   - Deliverables:
     - Immutable capture UI for target MW, spacing, panel/inverter strategy, route constraints, fault coverage, standards profile.
   - Verification:
     - Captured inputs displayed as immutable baseline for downstream stages.
29. Step 29: Add complete-layout visualization and completeness panels.
   - Deliverables:
     - UI visibility for generated artifact classes and status counts.
   - Verification:
     - Every required class is visible with identity and status.
30. Step 30: Add LOD 400 dashboard and approval UX.
   - Deliverables:
     - Asset-class checklist view, gate blockers, reviewer signoff workflow.
   - Verification:
     - LOD blockers shown before approval action is enabled.
31. Step 31: Add transmission handoff and status UX.
   - Deliverables:
     - Transition controls and evidence display for transmission readiness and approvals.
   - Verification:
     - User can audit transition evidence from UI.
32. Step 32: Add twin activation UX and lineage explorer.
   - Deliverables:
     - Twin activation from approved/as-built revision and lineage navigation.
   - Verification:
     - Trace path works from operational event to design revision.
33. Step 33: Frontend integration hardening.
   - Deliverables:
     - E2E workflow tests, role-based guards, performance tuning.
   - Verification:
     - Full UI flow passes against backend integration environment.
34. Step 34: Final release readiness.
   - Deliverables:
     - Consolidated docs, deployment notes, operator guide, known limitations.
   - Verification:
     - Release checklist fully green.

**Phase 4 - Real-World CAD & GIS Data Ingestion (Step 35-39)**

Context: The KML ingestion stack (handler, service, parser, repository, migration 015) is already written in compute-service but never mounted on any HTTP server. The DXF importer in interop-service/internal/service/service.go is Solar3D-only and cannot read client AutoCAD files. This phase wires the existing stack, adds a genuine DXF parser, handles DWG gracefully, exposes a layer-selection endpoint, and integrates file upload into the project creation UX. No new microservice is introduced. Execution order is fixed: Step 35 → 36 → 37 → 38 → 39.

Current reconciliation note (2026-04-10):
- Step 35 is complete with accepted deviation: KML handler is mounted and monolith upload route is reachable; register path currently uses the existing mock KML repository implementation.
- Steps 36-37 are complete with accepted deviation: parser and format detector are implemented with tests in project-service/internal/gis instead of compute-service/internal/parser.
- Step 38 is complete: DXF/KML/DWG parse and import routing are in place, including explicit oversized-upload handling (HTTP 413) with test coverage.
- Step 39 is complete: upload, preview, candidate selection, metadata panel, auto-fly/zoom, filled layer-colored preview polygon, and explicit skip-to-manual-draw control are implemented.

Deviation Record PH4-DEV-001
- Date/time: 2026-04-10
- Step and phase affected: Phase 4, Steps 36-37
- Root cause: Stateless CAD parse/import endpoint lives in project-service, so parser/detector were implemented locally in project-service/internal/gis to avoid cross-service duplication and internal package coupling.
- Contract/version impacted: No external API/proto break. Internal file-target deviation from plan.
- Chosen action: Class B phase-impact deviation; keep current working implementation, record mismatch, and reconcile plan/tracker before declaring Phase 4 closed.
- Tests rerun: project-service GIS parser tests, handler tests, frontend pnpm run check.
- New risks introduced: Duplicate CAD parsing logic could emerge later if compute-service ingestion is expanded without refactor.
- Approval note to resume sequence: Phase 4 implementation scope closed with accepted deviations PH4-DEV-001; Gate F is ready for signoff.

35. Step 35: Wire KML ingestion service into the running monolith.
   - Context:
     - KMLIngestionServiceHandler exists at services/compute-service/internal/handler/kml.go but register/register.go never mounts it.
     - KMLUpload.svelte (frontend/src/components/KMLUpload.svelte line 46) hardcodes port 50054 which has no matching server in either standalone or monolith mode.
     - The /import route and KMLUpload component are complete and functional except for this wiring gap.
   - Reuse Audit:
     - Reuse as-is: KMLIngestionServiceHandler, KMLService, KMLRepository, CRSNormalizer, kml_upload_jobs and imported_geometries schema (migration 015).
     - Extend: register/register.go — add initialization of KMLRepository (pgxpool injection), KMLService, KMLIngestionServiceHandler and mount kmlv1connect.NewKMLIngestionServiceHandler() on mux after existing handlers.
     - New: nothing.
   - Deliverables:
     - services/compute-service/register/register.go: KML handler mounted alongside existing compute handlers.
     - frontend/src/components/KMLUpload.svelte: API_ENDPOINT changed from http://localhost:50054 to import.meta.env.PUBLIC_MONOLITH_URL with fallback http://127.0.0.1:9191.
   - Security Surface:
     - File upload: existing handler validates size (100 MB cap) and type (KML/KMZ). No change to validation posture.
     - No new credentials or secrets required.
   - Migration and Schema Impact:
     - Migration 015_kml_ingestion.sql already deployed. No new migration.
     - No proto changes. New env var PUBLIC_MONOLITH_URL defaults to http://127.0.0.1:9191.
   - Verification:
     - POST /kml.v1.KMLIngestionService/UploadKML against monolith at :9191 returns upload_job_id (not connection refused).
     - POST /kml.v1.KMLIngestionService/GetUploadStatus returns COMPLETED within 5 s for a valid KML.
     - Frontend /import page uploads a test KML and shows geometry list without console errors.

36. Step 36: Implement real AutoCAD DXF ASCII parser (pure Go, no CGo).
   - Context:
     - The existing DXF handler in interop-service writes/reads only Solar3D-specific SOLAR3D_ENTITY comment lines and cannot parse a client AutoCAD DXF.
     - Karnataka project coordinates X≈708000, Y≈1331000 are in a local projected grid (UTM Zone 43N). CRS must be detected and reprojected to WGS84 before storage.
   - Reuse Audit:
     - Reuse types: KMLDocument, KMLFeature, KMLGeometry, Point2D, Ring from kml_parser.go as output contract.
     - Reuse: CRSNormalizer.Normalize() from crs_normalizer.go for projected→WGS84 reprojection.
     - Reuse: KMLService.processUploadAsync pipeline — DXF-parsed KMLDocument feeds in unchanged.
     - New: services/compute-service/internal/parser/dxf_parser.go — no existing equivalent for real AutoCAD DXF.
   - Deliverables:
     - services/compute-service/internal/parser/dxf_parser.go (new):
       - ParseDXF(data []byte) (*KMLDocument, error): scans group-code pairs with bufio.Scanner, reads HEADER for $INSUNITS, then reads ENTITIES section.
       - Supported entities: LWPOLYLINE (FLAG 1=closed polygon, FLAG 0=linestring), POLYLINE/VERTEX, LINE (two-point LineString), INSERT (Point), TEXT/MTEXT (Point with name=text content).
       - CRS heuristic: $INSUNITS=6 (meters) and X>1000 → EPSG:32643 (UTM 43N, Karnataka). X<180 and |Y|<90 → EPSG:4326. Default for large projected coordinates: EPSG:32643.
       - Each entity as one KMLFeature; Properties carries layer (group code 8), dxf_entity_type, closed flag.
       - Maximum 10 million group-code iterations guard against malformed infinite loops.
     - services/compute-service/internal/parser/dxf_parser_test.go (new):
       - Tests: closed LWPOLYLINE, open LWPOLYLINE, LINE, INSERT, TEXT, empty ENTITIES section, truncated file, malformed group codes.
       - CRS tests: UTM Karnataka range → EPSG:32643; WGS84 range → EPSG:4326.
       - Round-trip: reprojected coordinates land in Karnataka WGS84 bounding box (lon≈76–77, lat≈11–12).
   - Security Surface:
     - Parsed with bufio.Scanner on a size-bounded byte slice; no eval, no shell, no CGo.
     - strconv.ParseFloat with explicit error check on all coordinate group codes; malformed values return error, not panic.
   - Migration and Schema Impact:
     - No new migration. DXF geometries stored in existing imported_geometries table via KMLService pipeline.
     - No proto changes.
   - Verification:
     - All dxf_parser_test.go tests pass.
     - ParseDXF on the Jannur client DXF returns at least one closed Polygon feature.
     - CRS detection for X≈708000 returns EPSG:32643; reprojected coordinates fall in Karnataka lon/lat range.

37. Step 37: Add file format detector and DWG graceful error path.
   - Context:
     - Users will upload DWG files directly. DWG (AC1015–AC1032) cannot be parsed in pure Go without CGo + ODA/libopencad. The correct behavior is: detect DWG by magic bytes, return a structured actionable error.
     - This detector guards both /api/v1/cad/parse (Step 38) and ImportSiteBoundaryREST (Step 38).
   - Reuse Audit:
     - Reuse: error wrapping and h.respondError() pattern from connect_handlers.go.
     - New: services/compute-service/internal/parser/format_detector.go — no existing format detection anywhere.
   - Deliverables:
     - services/compute-service/internal/parser/format_detector.go (new):
       - FormatType string enum: FormatDXF, FormatKML, FormatKMZ, FormatDWG, FormatUnknown.
       - DetectFormat(data []byte) FormatType: reads first 8 bytes. AC1015/AC1018/AC1021/AC1024/AC1032 → FormatDWG; "  0" + newline → FormatDXF; "<?xml"/"<kml" (case-insensitive, first 64 bytes) → FormatKML; PK ZIP magic 0x504B → FormatKMZ.
       - DWGVersionString(data []byte) string: returns 6-byte version string; bounds-checked.
       - DWGUploadError: exported error type, UserMessage: "DWG file detected (AutoCAD {Version}). Open in AutoCAD, File > Save As > AutoCAD 2010 DXF (*.dxf), upload the .dxf file."
     - services/compute-service/internal/parser/format_detector_test.go (new): tests for each DWG version, DXF preamble, KML XML, KMZ ZIP magic, empty slice, 3-byte slice, unknown binary.
   - Security Surface:
     - Only first 8 bytes read at detection; no malicious payload processing.
   - Migration and Schema Impact:
     - No migration. No proto changes.
   - Verification:
     - All format_detector_test.go tests pass.
     - Uploading client DWG to /api/v1/cad/parse returns HTTP 422 with DWGUploadError.UserMessage.
     - Uploading DXF returns FormatDXF and proceeds to parse.

38. Step 38: Extend backend boundary import endpoint to accept DXF; add stateless layer-preview endpoint.
   - Context:
     - ImportSiteBoundaryREST (connect_handlers.go line 328) rejects all non-.kml/.kmz. After Steps 35-37 the DXF parser and format detector exist and can be routed here.
     - The new POST /api/v1/cad/parse endpoint is stateless (parse only, no DB write) and is used by the frontend for interactive layer selection before the user commits a boundary choice.
   - Reuse Audit:
     - Reuse and extend: ImportSiteBoundaryREST multipart block (lines 334-366) — replace extension check with DetectFormat dispatch; add DXF branch; keep KML/KMZ branch unchanged.
     - Reuse: h.svc.ImportSiteBoundary() — DXF boundary polygon flows through it unchanged.
     - Reuse: h.respond() and h.respondError() for the new handler.
     - New: ParseCadFileREST handler function — no existing equivalent.
   - Deliverables:
     - services/project-service/internal/handler/connect_handlers.go:
       - ImportSiteBoundaryREST: replace extension check with DetectFormat dispatch. FormatDXF → ParseDXF + CRSNormalizer + extract largest closed polygon → ImportSiteBoundary. FormatDWG → HTTP 422 + DWGUploadError.UserMessage. FormatUnknown → HTTP 400. FormatKML/KMZ → existing path unchanged.
       - New handler ParseCadFileREST: accepts multipart "file" field (32 MB cap), calls DetectFormat + parser, returns GeoJSON FeatureCollection with one Feature per KMLFeature. Feature properties: layer, dxf_entity_type, feature_name, geometry_type.
       - Register(): add POST /api/v1/cad/parse → ParseCadFileREST.
     - services/monolith/main.go: verify project handler Register() is called on shared mux (confirm in Reuse Audit note at implementation time; add explicit route only if not already covered).
   - Security Surface:
     - ParseCadFileREST: 32 MB cap enforced. DetectFormat before any parsing; DWG/Unknown rejected before bytes reach parser. filepath.Base used on all filenames to prevent traversal. GeoJSON text values via json.Marshal (HTML-escaping). No DB writes in ParseCadFileREST (no SQL injection surface).
   - Migration and Schema Impact:
     - No migration. /api/v1/cad/parse is stateless.
     - No proto changes.
   - Verification:
     - POST /api/v1/cad/parse with Jannur DXF returns FeatureCollection with at least one Polygon feature.
     - POST /api/v1/cad/parse with client DWG returns HTTP 422 with DWGUploadError message.
     - POST /api/v1/cad/parse with 40 MB file returns HTTP 413.
     - POST /api/v1/projects/{id}/site/import-boundary with DXF creates site with non-empty boundary_geojson.
     - Existing KML/KMZ import-boundary flow unchanged (regression test).
     - Unit tests for ParseCadFileREST covering DXF, KML, DWG, oversized input.

39. Step 39: Frontend project creation — add file upload step with interactive layer selection.
   - Context:
     - ProjectDashboard.svelte creation form has Step 1 (draw boundary) and Step 2 (grid connection). Both remain and are the fallback path; Step 0 is additive.
     - pickedBoundaryVertices (~line 171) is the canonical boundary variable consumed by handleCreate(). File-derived polygon must populate this variable; the rest of the pipeline is unchanged.
   - Reuse Audit:
     - Reuse as-is: pickedBoundaryVertices, handleCreate(), existing Step 1 map draw, existing Tailwind form step patterns.
     - Reuse: fetch client pattern from frontend/src/lib/core/api/.
     - New: inline Step 0 block in ProjectDashboard.svelte. Extract as a separate Svelte component only if template exceeds 150 lines.
   - Deliverables:
     - frontend/src/lib/components/ProjectDashboard.svelte:
       - Step 0 "Upload Site File (optional)" block at top of creation sequence.
       - File input: accepts .kml, .kmz, .dxf; extension validated client-side before POST; spinner during POST /api/v1/cad/parse.
       - On success: layer list — one row per Feature; shows geometry_type icon, layer name, feature name. Polygon rows selectable.
       - On row select: convert GeoJSON Polygon coordinates to pickedBoundaryVertices format; advance to Step 1 with boundary pre-populated on Cesium map.
       - On DWG error (HTTP 422): inline error card with DWGUploadError.UserMessage and "Export DXF from AutoCAD" instructions.
       - On other error: generic error card with retry.
       - "Skip and draw manually" button: dismisses Step 0, shows Step 1 in default empty state.
     - frontend/src/components/KMLUpload.svelte:
       - Line 46: API_ENDPOINT = import.meta.env.PUBLIC_MONOLITH_URL ?? 'http://127.0.0.1:9191'.
   - Security Surface:
     - Client-side file type check (.kml/.kmz/.dxf only) before upload.
     - All server response text rendered via Svelte text bindings (not {@html}).
     - No file content stored in localStorage/sessionStorage/cookies.
   - Migration and Schema Impact:
     - No migration. No proto changes. No new env vars beyond PUBLIC_MONOLITH_URL.
   - Verification:
     - Upload Jannur DXF → layer list → select Polygon row → boundary shown on Cesium map → submit creates project with correct site boundary.
     - Upload KML → same selection flow.
     - Upload DWG → inline error card with DXF export instructions; no blank state, no 500.
     - Skip → manual boundary draw works unchanged (regression test).
     - Complete project creation with no file uploaded → no regression.
     - KMLUpload.svelte on /import route succeeds against monolith at :9191.
     - pnpm check and vitest pass with no new failures.

**Implementation Checkpoints (Mandatory Stop Gates)**
1. Gate A (after Step 12): ML/algorithm contract freeze approved.
2. Gate B (after Step 20): Workflow orchestration across layout/electrical/transmission fully automatic.
3. Gate C (after Step 25): Backend ready for frontend phase integration.
4. Gate D (after Step 32): Twin activation and lineage complete in UI.
5. Gate E (after Step 34): Production readiness signoff.
6. Gate F (after Step 39): Real-world CAD/GIS ingestion live end-to-end; project creation accepts DXF/KML; DWG returns actionable user error; no regression on manual boundary draw; KML /import route functional against monolith.

**Primary File Targets**
- Existing targets:
  - e:/Brahma/Solar3d/proto/project/v1/project.proto
  - e:/Brahma/Solar3d/proto/layout/v1/layout.proto
  - e:/Brahma/Solar3d/proto/electrical/v1/electrical.proto
  - e:/Brahma/Solar3d/proto/transmission/v1/transmission.proto
  - e:/Brahma/Solar3d/proto/commissioning/v1/commissioning.proto
  - e:/Brahma/Solar3d/proto/report/v1/report.proto
  - e:/Brahma/Solar3d/services/layout-service/internal/service/service.go
  - e:/Brahma/Solar3d/services/electrical-service/internal/service/service.go
  - e:/Brahma/Solar3d/services/transmission-routing-service/internal/service/governance.go
  - e:/Brahma/Solar3d/services/commissioning-service/internal/service/service.go
  - e:/Brahma/Solar3d/services/compute-orchestration-service/internal/executor/compute_executor.go
  - e:/Brahma/Solar3d/frontend/src/routes/+page.svelte
  - e:/Brahma/Solar3d/frontend/src/lib/components/InspectorPanel.svelte
  - e:/Brahma/Solar3d/frontend/src/lib/core/stores/project.ts
  - e:/Brahma/Solar3d/frontend/src/lib/core/stores/layout.ts
- Phase 4 targets:
  - e:/Brahma/Solar3d/services/compute-service/register/register.go
  - e:/Brahma/Solar3d/services/compute-service/internal/parser/dxf_parser.go (new)
  - e:/Brahma/Solar3d/services/compute-service/internal/parser/dxf_parser_test.go (new)
  - e:/Brahma/Solar3d/services/compute-service/internal/parser/format_detector.go (new)
  - e:/Brahma/Solar3d/services/compute-service/internal/parser/format_detector_test.go (new)
  - e:/Brahma/Solar3d/services/project-service/internal/handler/connect_handlers.go
  - e:/Brahma/Solar3d/services/monolith/main.go
  - e:/Brahma/Solar3d/frontend/src/lib/components/ProjectDashboard.svelte
  - e:/Brahma/Solar3d/frontend/src/components/KMLUpload.svelte
- New targets:
  - e:/Brahma/Solar3d/proto/workflow/v1/planning_workflow.proto
  - e:/Brahma/Solar3d/proto/workflow/v1/acceptance_criteria.proto
  - e:/Brahma/Solar3d/proto/twin/v1/digital_twin.proto
  - e:/Brahma/Solar3d/proto/telemetry/v1/telemetry.proto
  - e:/Brahma/Solar3d/proto/fault/v1/fault_schema.proto
  - e:/Brahma/Solar3d/proto/asset/v1/asset_identity.proto
  - e:/Brahma/Solar3d/services/twin-service/
  - e:/Brahma/Solar3d/frontend/src/lib/core/stores/workflow.ts
  - e:/Brahma/Solar3d/frontend/src/lib/core/api/workflow.ts

**Verification Ladder**
1. Unit and contract tests at each step.
2. Service integration tests at each phase boundary.
3. Deterministic reproducibility tests for generation outputs.
4. Workflow negative tests for invalid transitions.
5. Twin ingestion and lineage trace tests.
6. Full end-to-end program test before release.


**Deviation Control Plan (If We Drift Mid-Execution)**
1. Deviation detection trigger:
   - Trigger a deviation review immediately when any one condition occurs:
   - A step fails its verification gate twice.
   - New requirement conflicts with frozen contract.
   - Measured latency/quality misses SLO by more than agreed tolerance.
   - Upstream schema/proto change breaks downstream compatibility.
2. Deviation classification (decide in this order):
   - Class A (local fix): contained to current step; no contract change.
   - Class B (phase impact): affects current phase contract but not previous frozen gates.
   - Class C (program impact): breaks frozen contract/gate and impacts later phases.
3. Mandatory response by class:
   - Class A: fix in-place inside same step; do not move schedule.
   - Class B: open mini-change record, patch current phase plan, rerun affected verification ladder items.
   - Class C: execute controlled replan, roll back to last gate checkpoint, update contract version, and re-baseline downstream steps before resuming.
4. Freeze-and-unfreeze policy:
   - Contract freeze is binding after Gate A (ML), Gate B (backend), and Gate D (frontend twin UX).
   - Any change after freeze requires version bump and compatibility note.
   - No silent edits to frozen payloads.
5. Re-baselining checklist after deviation:
   - Update requirements matrix and traceability matrix.
   - Regenerate impacted test fixtures.
   - Re-run unit + integration + end-to-end subset relevant to changed contract.
   - Update runbook and known limitations if behavior changed.
6. Rollback safety rules:
   - Prefer logical rollback (state transition rollback) over code reversion unless necessary.
   - Preserve migration compatibility; do not delete already-emitted lineage IDs.
   - Keep deterministic fallback route always enabled during remediation.
7. Decision SLA (single-programmer mode):
   - Detect within same work session.
   - Classify and decide path before next step starts.
   - Do not continue sequence with unresolved Class B/C deviation.
8. Deviation log template (must fill for B/C):
   - Deviation ID
   - Date/time
   - Step and phase affected
   - Root cause
   - Contract/version impacted
   - Chosen action (fix/replan/rollback)
   - Tests rerun
   - New risks introduced
   - Approval note to resume sequence
9. Practical default strategy:
   - First try Class A local containment.
   - If any contract boundary is touched, escalate to Class B immediately.
   - If frozen gate contract is touched, escalate to Class C automatically.


**Strict Reuse-First Guardrails (AI Programmer Policy)**
1. Reuse-first mandate:
   - Before writing any new method/class/service, search for existing equivalent behavior in current modules, shared utilities, and adjacent services.
   - If an existing method can be adapted with parameterization, extend it instead of creating a new similarly-scoped method.
2. No shadow-implementation rule:
   - Do not recreate existing logic under different names.
   - Any newly proposed method must include a brief justification: which existing candidates were checked and why they were insufficient.
3. Mandatory discovery checklist before new code:
   - Search symbols/functions in target service and neighboring services.
   - Search existing proto messages/RPCs before adding new contracts.
   - Search existing store/component patterns before adding new frontend state or UI primitives.
4. Naming collision and semantic-duplication guard:
   - Reject new method if behavior overlaps an existing method by intent, even if signature differs.
   - Prefer wrapper/adaptor around existing method only when backward compatibility requires it.
5. Extension hierarchy (must follow in order):
   - Option 1: Use existing method as-is.
   - Option 2: Add optional parameter(s) to existing method.
   - Option 3: Extract shared helper from existing method and reuse in both callers.
   - Option 4: Introduce new method only if Options 1-3 are not viable.
6. Contract reuse rules:
   - Reuse existing proto enums/messages when semantically compatible.
   - New proto messages/RPCs allowed only when existing contracts cannot represent required evidence or lifecycle state.
7. Refactor-before-create threshold:
   - If planned new code duplicates more than 30% of existing logic path, stop and refactor existing code path instead.
8. Review gate per step:
   - Each step must include a Reuse Audit note: reused symbols, extended symbols, and truly new symbols with rationale.
   - Step cannot close without passing Reuse Audit.
9. Exception policy:
   - New function creation is allowed only when no existing function in codebase can satisfy behavior without introducing regression or unacceptable coupling.
   - Exception must document impact and tests proving no duplicate behavior remains.
10. Regression guard:
   - When extending existing methods, add/adjust tests around prior behavior first, then add new behavior tests.
   - Preserve backward compatibility unless a deliberate breaking-change step is explicitly approved.

**Code Quality and Production Standards (AI Programmer Policy)**
1. No TODOs, stubs, or placeholders:
   - Never commit or merge code containing TODO, FIXME, STUB, PLACEHOLDER, or any comment that defers real logic.
   - If logic cannot be completed in the current chunk, do not start writing that function. Finish the current chunk boundary cleanly first.
   - Placeholder structs or empty handler bodies are not acceptable output at any stage.
2. Production-ready definition:
   - Every function handles its error paths explicitly. No ignored errors, no bare panic, no swallowed returns.
   - Every exported function/method has documented behavior matching its actual implementation.
   - Every new database migration must be reversible or have an explicit down migration.
   - Every new service endpoint must have authentication/authorization checks consistent with the API gateway policy.
   - Every new proto contract must include field validations in the handler, not just at the caller.
3. Code standards by language:
   - Go: idiomatic Go (gofmt/goimports clean), explicit error wrapping with context, no global mutable state outside defined store patterns, context propagation on all DB/gRPC calls, structured logging.
   - Rust: clippy-clean with no warnings, safe code by default, SIMD-only where terrain-compute or layout-compute patterns already use it, no unsafe blocks without justification comment.
   - Svelte/TypeScript: strict TS mode, no any except at proven API boundaries, store patterns consistent with existing codebase, no raw DOM mutation outside Cesium integration patterns.
   - Proto: snake_case field names, explicit field numbers, required comment on every RPC describing input/output contract, backward-compatible field addition only.
4. Test coverage requirements:
   - Happy-path test for every new RPC/function.
   - At least one negative/error path test per new function.
   - Integration test at each service boundary touched by a step.
   - No mocked-out core logic in integration tests; use in-memory stores only where the existing codebase already establishes that pattern.
5. Session chunking protocol (when task is too large):
   - If a step cannot be completed within one session without risk of hallucination or incomplete output, split into numbered chunks before starting any code.
   - Chunk boundaries must align to compilable and testable units, never mid-function or mid-migration.
   - Announce chunk plan at the start: "This step has N chunks. Starting chunk 1 of N."
   - End each chunk with: compile check, test run, and explicit state summary of what is complete and what remains.
   - Do not start chunk N+1 if chunk N did not compile and pass its tests.
   - Never skip ahead to make progress look faster. A broken chunk completed honestly is better than a passing chunk with hidden stubs.
6. Anti-hallucination rules:
   - If unsure whether a function/API/field exists, search the codebase before writing code that assumes it.
   - If a dependency is not confirmed present, state it explicitly and wait for verification or search it.
   - Never invent method signatures; always read the actual proto/interface definition before calling it.
   - If the implementation requires a decision that was not previously made, surface it explicitly rather than guessing.
7. Naming and structure consistency:
   - Follow naming conventions established in the file being edited.
   - Match existing error type patterns in each service rather than introducing new error shapes.
   - Match existing handler/repository/service layering patterns in each service.
   - Do not introduce a new architectural pattern without an explicit step in the plan.
8. Security standards (aligned with OWASP Top 10 and service patterns):
   - No credentials, tokens, or secrets in code or logs.
   - All user-supplied geometry/inputs validated and sanitized before processing.
   - gRPC and Connect-RPC handlers must check authorization before accessing data.
   - No SQL string concatenation; use parameterized queries or existing sqlc patterns.
9. Observability requirements:
   - Every new service RPC must emit a structured log entry on start and error.
   - Every new workflow transition must emit a trace span consistent with existing OpenTelemetry patterns.
   - Every new background job must update its orchestration job status on start, success, and failure.
10. Step closure definition (code is done only when):
    - Compiles without warnings.
    - All new and modified tests pass.
    - Reuse audit note is written.
    - No TODOs, stubs, or placeholders remain.
    - Error paths are covered.
    - Security checklist items for the touched surface area are satisfied.



**Pre-Implementation Locked Decisions (Must Resolve Before Step 1)**
1. Twin service port assignment:
   - Allocate port 8097 for twin-service in docker-compose.yml and .env.example before any service code is written.
   - API gateway must route /api/v1/twins/* to 8097 before twin endpoints are exposed.
2. Telemetry storage backend decision (required before Step 21):
   - Options in order of operational preference for this stack:
     - Option A: PostgreSQL with TimescaleDB hypertable for sensor_readings (reuses existing DB infrastructure, lowest ops burden).
     - Option B: Redis Streams for short-duration ingestion buffer with Postgres rollup (adds Redis dependency already present for session/cache if used).
     - Option C: InfluxDB or Prometheus sidecar (adds a new operational dependency, highest complexity).
   - Recommended default: Option A. Must be confirmed and written into twin-service design before Step 21.
3. Protection device asset seed (required before Step 16):
   - Migration 016 must seed asset_library with protection device catalog entries: breakers, fuses, disconnects, relays.
   - Categories needed: PROTECTION_RELAY, CIRCUIT_BREAKER, FUSE_DISCONNECT per IEC 60255 class designations.
4. Governing standards locked before Step 1 acceptance matrix:
   - BIM information management: ISO 19650-1/2.
   - LOD level definitions: EN 17412-1 or equivalent national standard; LOD 400 = fabrication/installation detail.
   - Commissioning documentation: IEC 62446-1.
   - Fault current calculations: IEC 60909.
   - Protection coordination: IEC 60255.
   - Solar PV system documentation: IEC 62446-1 and IEC 61724-1 for performance monitoring baseline.
   - Any national grid code requirement must be listed in the planning input contract capture (Step 28/frontend).

**New Service Registration Checklist (Apply for Every New Service)**
Run this checklist before writing any service code:
1. Add service directory to go.work: ./services/<service-name>.
2. Add service block to docker-compose.yml with correct port, env vars, depends_on, and healthcheck.
3. Add SERVICE_NAME_SERVICE_URL entry to .env.example with local default.
4. Add route block to api-gateway-service routing config for all new endpoints.
5. Wire services/shared/middleware ratelimit.go into new service's server setup matching existing pattern.
6. Add DB migration if service needs its own tables (next migration number in sequence, lock-safe).
7. Add service to monitoring/observability config if applicable.
This checklist is a mandatory pre-step for twin-service (Step 22) and any other new service added during the program.

**New Rust Crate Registration Checklist (Apply for Every New Compute Crate)**
Run this checklist before writing any Rust code:
1. Add crate name to [workspace] members array in compute/Cargo.toml.
2. Create compute/<crate-name>/Cargo.toml with correct package name, edition, and dependencies.
3. Add bridge binary entry with unique [[bin]] name to avoid Windows target filename collisions.
4. Register bridge port in compute-service config and .env.example (next available port after 8087).
5. Add build validation command to build-win.ps1 or build-all.bat with -p and --bin flags.
This checklist is mandatory for layout-synthesis-compute (Step 6) and any other new compute crate.

**Proto/Buf Compliance Checklist (Apply Before Any Proto Step)**
Run this before committing any proto change:
1. Run buf lint against STANDARD rules; zero warnings required.
2. Run buf breaking against FILE and WIRE_JSON modes comparing to last stable proto state.
3. Confirm all new RPCs have required comment describing input/output contract.
4. Confirm all new messages use snake_case fields, explicit field numbers, and no reused numbers.
5. Confirm ContractMetadata is embedded or referenced where cross-service correlation is needed.
6. Confirm new packages follow <domain>/v1 path convention.
This checklist is mandatory at Steps 13, 15, 21 and any other step that touches proto files.

**Zero-Downtime Migration Rules**
Apply to every new database migration:
1. No ALTER TABLE ... ADD COLUMN ... NOT NULL without a DEFAULT value (acquires full table lock in Postgres).
2. Add NOT NULL constraints in two-phase migrations: first add nullable column + backfill, then add constraint.
3. No DROP COLUMN or DROP TABLE in a migration that runs alongside live traffic; schedule as a separate decommission step.
4. Every migration must have a corresponding rollback strategy documented in a comment at the top of the file.
5. Migration number must be next in sequence: current highest is 015, so next is 016, then 017, etc.
6. Test every new migration against existing seed data before merging.

**Feature/Env Gating for Incomplete Workflow Phases**
All new workflow phase transitions must be guarded by env flags during the implementation program:
1. Each new phase in the PlanningWorkflow gets a corresponding env flag: WORKFLOW_PHASE_<PHASE_NAME>_ENABLED.
2. Default value in .env.example is false for any phase that is not yet fully wired end-to-end.
3. Backend handlers return a clear NotImplemented or FeatureDisabled error when flag is false, not a 500.
4. Remove the flag and hard-enable the phase only when Step closure criteria are fully met and Gate is passed.
5. Frontend must respect the flag response and show a "coming soon / not yet available" state rather than a dead button.

**Commit Convention**
All AI implementation commits must follow:
- Format: [Phase/Step] type: short description
- Phase: P0, P1, P2, P3 for the four phases.
- Step: S1-S34 matching the step number.
- Type: feat, fix, refactor, test, proto, migration, chore.
- Examples:
  - [P0/S1] feat: add requirements and traceability matrix
  - [P1/S6] feat: deterministic infrastructure synthesis for inverter/transformer zones
  - [P2/S13] proto: add PlanningWorkflow phase enum and transition RPC
  - [P2/S16] migration: seed protection device asset catalog (016)
- One commit per completed chunk; never commit mid-step or mid-chunk.

**Standard Per-Step Header Template**
Every implementation step must begin with this four-section header before any code is written:
- Section 1 - Reuse Audit:
  - What was searched.
  - What existing symbols/methods/protos will be reused as-is.
  - What will be extended and how.
  - What is genuinely new and why no existing path satisfies it.
- Section 2 - Chunk Declaration:
  - If step is large: "This step has N chunks. Chunk boundaries: [list]."
  - If step fits one session: "Single chunk. Boundary: [compilable unit description]."
- Section 3 - Security Surface:
  - What authentication/authorization paths are touched.
  - What user-supplied inputs enter the system and what validation is applied.
  - Any new secrets or credentials required and how they are managed.
- Section 4 - Migration and Schema Impact:
  - Any DB schema changes, migration number, lock-safety check.
  - Any proto changes and buf compliance checklist status.
  - Any new env vars and their defaults.



**Program Reconciliation and Governance (Single Source of Truth)**
1. Authoritative source:
   - The master program plan is this document in session memory until implementation mode creates the workspace file.
   - During implementation, the workspace plan file becomes the authoritative source and session memory is treated as backup.
2. Change control model:
   - Any change to phases, sprints, or step scope requires a Change Record entry with:
   - Change ID, date, reason, impacted phase/step, contract impact, test impact, approval note.
3. Reconciliation cadence:
   - At the end of each completed step, update four fields:
   - Step status: Not Started or In Progress or Blocked or Done.
   - Evidence links: tests run, artifacts generated, migrations/proto changes.
   - Deviations: none or Class A or B or C with record ID.
   - Next step readiness: Ready or Blocked with blocker reason.
4. Sprint board structure for one programmer:
   - Sprint has ordered steps only (no parallel tracks).
   - Each sprint has entry criteria, exit criteria, and hard gate mapping.
   - A sprint is complete only when all included steps are Done and gate checks pass.
5. Scope drift prevention:
   - New requests are not inserted directly into active step.
   - New requests are added to a backlog section and triaged at the next gate only.
   - Active step remains frozen except bug fixes needed to pass its own verification.
6. Reconciliation report format (end of each sprint):
   - Planned steps.
   - Completed steps.
   - Deferred steps.
   - Defects found and resolved.
   - Contract/version changes.
   - Updated risk register.
   - Go or No-Go recommendation for next sprint.
7. Auditability requirements:
   - Every step update must include commit IDs, migration numbers, and proto package/version impacts.
   - Every gate decision must reference objective evidence, not narrative-only statements.
8. Conflict resolution rule:
   - If workspace document and code diverge, code + passing tests are truth for behavior, but plan must be updated before continuing to next step.
   - No continuation allowed with unresolved plan-code mismatch.
9. Minimum reconciliation artifacts by phase:
   - Phase 1 ML/Algorithms: benchmark report, reproducibility report, candidate contract freeze record.
   - Phase 2 Backend: transition matrix test report, proto compatibility report, orchestration e2e report.
   - Phase 3 Frontend: workflow UX gating test report, LOD dashboard verification, twin lineage walkthrough report.
10. Program closeout criteria:
   - All steps marked Done.
   - All gates passed.
   - No open Class B or Class C deviations.
   - No placeholder code debt.
   - Production-readiness signoff evidence complete.
