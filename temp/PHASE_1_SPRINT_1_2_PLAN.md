# Phase 1 Sprint 1.2 - Constraint Zones (Land Siting Constraints)

## Sprint Overview
**Objective**: Build constraint zone management system for landing site analysis - enable users to define, categorize, and query exclusion/inclusion zones affecting solar project siting.

**Duration**: 2 weeks (Weeks 3-4 of Phase 1)

**User Value**: Users can define complex constraint zones (geological, environmental, regulatory) that restrict/enable solar placement, integrating with Phase 1.1 imported geometries.

## Deliverables (12 Tasks)

### Backend Infrastructure (Tasks 1-6)

**Task 1: Design Constraint Zone Domain Model**
- Create proto contract: `proto/constraint/v1/constraint_zones.proto`
- Define zone types: ExclusionZone, InclusionZone, BufferZone
- Define zone categories: Geological, Environmental, Regulatory, Infrastructure, Military, Protected
- Define zone metadata: Name, description, severity, effective_dates, geometry
- RPC methods: CreateZone, UpdateZone, DeleteZone, GetZone, ListZones, QueryZonesByLocation
- Status: NOT STARTED

**Task 2: Build Constraint Zone Data Models**
- File: `internal/models/constraint.go`
- Models: ConstraintZone, ZoneCategory, ZoneHistory (audit trail)
- Relationships: Zone → ImportedGeometry (from Sprint 1.1)
- Validation constraints: Max zones per project, geometry size limits
- Status: NOT STARTED

**Task 3: Create Database Schema**
- File: `migrations/016_constraint_zones.sql`
- Tables: constraint_zones, zone_categories, zone_permissions, zone_audit_log
- Spatial queries: ST_Contains, ST_Intersects for landing site siting
- Indexes: Zone type, category, effective_dates, spatial (GIST)
- Status: NOT STARTED

**Task 4: Build Constraint Zone Repository**
- File: `internal/repository/constraint.go`
- Interface: Create, Get, List, Update, Delete, FindZonesIntersecting
- Mock implementation for testing
- Query optimization: Spatial index usage for siting queries
- Status: NOT STARTED

**Task 5: Implement Constraint Zone Service**
- File: `internal/service/constraint_service.go`
- Business logic:
  - Zone creation with geometry validation
  - Category enforcement
  - Conflict detection (overlapping zones of same type)
  - Siting workflow: Query zones near proposed landing site
  - Permission checking (user access to zones)
- Error handling: Validation, conflict, permission errors
- Status: NOT STARTED

**Task 6: Create gRPC Handlers**
- File: `internal/handler/constraint.go`
- Handlers: CreateZone, UpdateZone, DeleteZone, GetZone, ListZones, QueryZonesByLocation
- Error mapping: Connect/gRPC status codes
- Proto mapping: Domain → proto structs
- Status: NOT STARTED

### Testing & Integration (Tasks 7-9)

**Task 7: Write Constraint Zone Tests**
- Parser/normalizer: Inherit validation from Sprint 1.1
- Repository: CRUD tests, spatial queries
- Service: Create/update/delete flows, conflict detection
- Handler: gRPC endpoint tests
- Expected: 40+ tests covering all zone types and operations
- Status: NOT STARTED

**Task 8: Integration Tests (Siting Workflow)**
- File: `internal/service/constraint_integration_test.go`
- Test scenario 1: User defines exclusion zones, imports landing site geometries, system flags conflicts
- Test scenario 2: Multi-category zones with hierarchy (protected land → buffer zones)
- Test scenario 3: Temporal zones (effective_dates) - seasonal restrictions
- Test scenario 4: Zone permission scoping (user A can't view user B's proprietary zones)
- Expected: 8-10 integration tests
- Status: NOT STARTED

**Task 9: Database Integration Tests**
- Test PostGIS spatial queries: ST_Contains, ST_Intersects
- Test zone inheritance and cascading deletes
- Test audit log triggering on zone modifications
- Expected: 5 tests for spatial operations
- Status: NOT STARTED

### Frontend Implementation (Tasks 10-11)

**Task 10: Build Zone Management UI (Svelte)**
- File: `frontend/src/components/ConstraintZoneManager.svelte`
- Features:
  - Zone list with filters (type, category, date range)
  - Create/edit/delete zone workflows
  - Zone geometry editor (draw on map, import from file)
  - Category selector with descriptions
  - Effective date picker (calendar UI)
  - Conflict warning display
- Status: NOT STARTED

**Task 11: Build Siting Query Interface (Svelte)**
- File: `frontend/src/components/SitingAnalyzer.svelte`
- Features:
  - Query zones near proposed site (radius search)
  - Show relevant constraints (exclusion/inclusion zones)
  - Risk score calculation (count conflicts, severity weighting)
  - Export report (PDF with zone summary, recommendations)
- Status: NOT STARTED

### Documentation (Task 12)

**Task 12: Update Status Reports & Create Integration Guides**
- Update COMPLETE_STATUS_REPORT.md with Sprint 1.2 entry
- Create CONSTRAINT_ZONE_INTEGRATION_GUIDE.md
- Document zone category taxonomy
- Document API usage examples
- Status: NOT STARTED

## Architecture Overview

```
Frontend UI (Svelte)
   ↓ (gRPC)
Orchestration Service (Go)
   ↓ (gRPC)
Constraint Service (Go)
   ├─ Models: ConstraintZone, ZoneCategory, ZoneHistory
   ├─ Repository: CRUD + spatial queries
   ├─ Service: Business logic (validation, conflict detection)
   └─ Handler: gRPC endpoints
   ↓
PostgreSQL + PostGIS
   ├─ constraint_zones (geometry column, PostGIS ST type)
   ├─ zone_categories
   ├─ zone_permissions
   └─ zone_audit_log
```

## Dependencies & Integrations

- **Sprint 1.1 Output**: ImportedGeometry (landing sites) imported from KML
- **PostGIS**: Spatial queries ST_Contains, ST_Intersects for zone analysis
- **Proto**: gRPC service contract generation
- **Repository Pattern**: Consistent with Sprint 1.1 implementation

## Success Criteria

✅ All 12 tasks completed to same production standard as Sprint 1.1
✅ 50+ unit tests + 13+ integration tests passing
✅ Web UI responsive and accessible
✅ Documentation complete and integrated
✅ Spatial queries validated against real PostGIS instances
✅ Zone conflict detection working (verified in integration tests)

## User Stories Enabled

1. **"As a solar analyst, I want to draw exclusion zones on a map so that proposed landing sites are checked against them"**
   - Deliverable: Zone management UI + siting query interface

2. **"As a project manager, I want to see conflicts between my landing sites and protected zones so I can adjust placement"**
   - Deliverable: Siting analyzer with risk scoring

3. **"As a regulatory officer, I want to define regulatory zones that automatically restrict placement in sensitive areas"**
   - Deliverable: Zone categories with enforcement rules

## Phase 1 Progress (After Sprint 1.2)

```
Phase 1 Total: 24 tasks (2 sprints × 12 tasks)

After Sprint 1.1: 12 tasks ✅ (100% complete, validated)
After Sprint 1.2: 12 tasks 🔄 (in progress)

Remaining Phase 1 work: Sprint 1.3 (constraint integration) + Sprint 1.4 (DEM hardening)
```

## Next Steps

1. Review this sprint plan with stakeholders
2. Create 12-item todo list
3. Begin Task 1: Proto contract design
4. Estimated completion: 2 weeks

---

**Sprint Owner**: Solar3D Platform Team  
**Last Updated**: 2026-04-04  
**Related Files**: [PHASE_1_PLAN.md](PHASE_1_PLAN.md), [COMPLETE_STATUS_REPORT.md](COMPLETE_STATUS_REPORT.md)
