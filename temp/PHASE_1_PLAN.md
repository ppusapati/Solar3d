# Phase 1: Land Intake & Constraint Intelligence

**Goal**: Make land intake and constraint intelligence production-grade.

**Status**: In Progress (Sprint 1.1: KML/KMZ Ingestion)

---

## Sprint 1.1: KML/KMZ Ingestion & Upload Flows

**Objective**: Implement production-grade KML/KMZ ingestion with validation, CRS normalization, and canonical geometry conversion across web and mobile.

**Deliverables**:
1. ✅ KML/KMZ parser with schema
2. ✅ CRS detection and normalization (EPSG code mapping)
3. ✅ Geometry type canonicalization (Point, LineString, Polygon, MultiPolygon)
4. ✅ Validation pipeline (schema, bounds, topology, feature count limits)
5. ✅ Backend upload handler (multipart form, async processing, progress tracking)
6. ✅ Database schema for imported geometries and metadata
7. ✅ Web upload UI with drag-and-drop, progress, error reporting
8. ✅ Mobile upload UI (camera intent for mobile KML capture)
9. ✅ Integration tests (roundtrip: upload → parse → store → query)

**Key Decisions**:
- Use Go `encoding/xml` for KML parsing (no external dependencies initially)
- Store normalized geometries in PostGIS with SRID tracking
- Canonical format: WGS84 (EPSG:4326) for API, preserve source SRID in metadata
- Async processing pipeline: parse → validate → normalize → store
- Frontend: Svelte/Tailwind for web upload, Flutter for mobile capture

**Files to Create/Modify**:

### Backend
- [ ] `services/compute-service/proto/kml_ingestion.proto` - KML service contract
- [ ] `services/compute-service/internal/service/kml_service.go` - Business logic
- [ ] `services/compute-service/internal/handler/kml_handler.go` - gRPC handlers
- [ ] `services/compute-service/internal/repository/kml_repository.go` - Data persistence
- [ ] `migrations/005_kml_ingestion.sql` - Schema for imported KML/geometries
- [ ] `services/compute-service/internal/parser/kml_parser.go` - KML parsing logic
- [ ] `services/compute-service/internal/parser/crs_normalizer.go` - EPSG/CRS mapping

### Frontend
- [ ] `frontend/src/components/KMLUpload.svelte` - Upload widget
- [ ] `frontend/src/routes/import/+page.svelte` - Import workflow page
- [ ] `frontend/src/lib/kml.ts` - KML client SDK

### Mobile
- [ ] `mobile/lib/screens/kml_import_screen.dart` - KML import UI
- [ ] `mobile/lib/services/kml_service.dart` - KML client

### Tests
- [ ] `services/compute-service/internal/parser/kml_parser_test.go`
- [ ] `services/compute-service/internal/service/kml_service_test.go`
- [ ] Integration test: `services/compute-service/internal/service/kml_integration_test.go`

---

## Sprint 1.2: Constraint Zone Domain

**Objective**: Build first-class constraint-zone domain with schema, CRUD, and editing workflows.

**Deliverables**:
1. Constraint zone domain model (Water, Restricted, Setback, Exclusion)
2. Database schema with zone geometry and metadata
3. CRUD service (Create, Read, Update, Delete, List)
4. Constraint category management
5. Zone editing workflow (draw, edit, delete)
6. Constraint query engine (geometry intersection)

**Status**: Planned

---

## Sprint 1.3: Constraint Integration

**Objective**: Integrate constraints into routing, layout validation, and siting.

**Deliverables**:
1. Constraint-aware routing (avoid zones)
2. Layout validation against constraints
3. Siting workflow with constraint checking

**Status**: Planned

---

## Sprint 1.4: DEM Hardening

**Objective**: Harden DEM ingestion and terrain-layer lifecycle.

**Deliverables**:
1. DEM upload error handling
2. Observability (DEM processing metrics)
3. Provenance tracking (source, timestamp, checksum)
4. Terrain-layer versioning

**Status**: Planned

---

## Phase 1 Release Gate

✅ All tests passing
✅ Zero unimplemented runtime paths in KML/constraint domains
✅ End-to-end integration: upload → parse → store → query
✅ Frontend and mobile upload flows verified
✅ Observability in place (logs, metrics, traces)
