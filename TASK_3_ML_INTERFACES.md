# Task 3: Freeze Architectural Interfaces for ML Phase Inputs/Outputs

## Overview

This document defines the **authoritative contract boundary** between the ML/Algorithm phase (Tasks 4–12) and the backend integration phase (Tasks 13–25). All ML algorithms must accept **ML Phase Inputs** and produce **ML Phase Outputs** conforming to these interfaces. Backend services must consume these outputs without modification.

**Lock Status**: FROZEN for Phase 1–2. Changes require Phase gate signoff and impact assessment.

**Version**: 1.0 (Active)  
**Date**: 2026-04-05  
**Scope**: ML candidate generation, multi-objective scoring, Pareto ranking, and artifact graph construction.

---

## Part 1: Candidate Artifact Graph Schema (Draft)

### Purpose

The **Candidate Artifact Graph** is the complete, deterministic data model representing a feasible layout solution. It includes all asset placements, topology, electrical connections, routing paths, and precision metadata required for:
- Complete-layout LOD 300 visualization
- Electrical validation and string formation
- Transmission routing and BOM generation
- Twin provisioning and commissioning handoff

### 1.1 Core Entity Model

The artifact graph contains **six entity classes**, each with mandatory and optional precision fields:

#### 1.1.1 **SolarPanel** (Entity)
```
SolarPanel {
  panel_id: UUID                          // Unique identifier, format: panel-<project>-<tile>-<seq>
  asset_id: UUID                          // Reference to Asset.Category = SOLAR_PANEL
  tile_id: UUID                           // Parent tile (for hierarchical bounds queries)
  string_id: UUID | null                  // FK to PanelString (assigned during electrical phase)
  
  // Geometry (WGS84 / EPSG:4326)
  geometry: Polygon3D {
    vertices: [Point3D, ...]              // 4 corners in order (CCW when viewed from above)
    elevation_source: "DEM" | "interpolated" | "constant"
    datum_offset_m: float                 // Height above MSL
  }
  
  // Orientation (electrical performance driver)
  tilt_degrees: float [0..90]             // Ground to horizontal plane
  azimuth_degrees: float [0..360]         // 0=N, 90=E, 180=S, 270=W
  
  // Precision fields (for reproducibility and tracking)
  layout_score: float [0..1]              // Feasibility / utilization score
  mpp_capacity_kw: float                  // Nameplate DC power
  shading_factor: float [0..1]            // Proxy penalty (>0 = some shade loss)
  
  // Lineage
  created_by: "deterministic_synthesis" | "ml_optimization" | "user_manual"
  optimization_run_id: UUID | null        // If created by ML, which run?
  parent_candidate_id: UUID | null        // If ranked/modified from prior candidate
  
  // Audit
  checksum: string                        // SHA256(geometry || orientation)
  created_at: Timestamp
}
```

**Multiplicity**: Typically 1000–50,000 per layout (depends on site area and density).

---

#### 1.1.2 **PanelString** (Electrical Entity)
```
PanelString {
  string_id: UUID                         // Unique within ElectricalNetwork
  network_id: UUID | null                 // FK to ElectricalNetwork (null during ML phase)
  
  // Composition
  panel_ids: [UUID, ...]                  // Ordered list (series electrical path)
  panel_count: int                        // Length of panel_ids
  inverter_group_id: UUID | null          // FK to InverterGroup (assigned later)
  
  // Electrical attributes
  string_voltage_vdc: float                // Voc of all panels in series
  string_current_adc: float               // Isc of any panel (bottles current)
  string_power_kw: float                  // Sum of panel mpp_capacity_kw
  
  // Constraints (used by electrical validator)
  mppt_index: int | null                  // Which MPPT on inverter? (assigned later)
  
  // Precision fields
  feasibility_status: "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
  feasibility_reason: string | null       // If INVALID, why?
  
  created_by: "deterministic_synthesis" | "optimizer"
  optimization_run_id: UUID | null
}
```

**Multiplicity**: Typically 50–500 per layout (depends on inverter/MPPT count).

---

#### 1.1.3 **InverterGroup** (Electrical Entity)
```
InverterGroup {
  inverter_group_id: UUID                 // Unique within ElectricalNetwork
  network_id: UUID | null                 // FK to ElectricalNetwork
  
  // Asset
  inverter_asset_id: UUID                 // Reference to Asset.Category = STRING_INVERTER | CENTRAL_INVERTER
  
  // Composition
  string_ids: [UUID, ...]                 // List of PanelString IDs fed to this inverter
  string_count: int
  
  // Siting
  position: Point3D {                     // Inverter physical location
    longitude: float
    latitude: float
    elevation_m: float
  }
  position_snapped_to_feature: "road" | "foundation" | "building" | null
  
  // Electrical aggregate
  dc_input_kw: float                      // Sum of string_power_kw; must fit inverter capacity
  ac_output_kw: float                     // Inverter rated AC output
  dc_ac_ratio: float                      // dc_input_kw / ac_output_kw
  efficiency_pct: float [0..100]
  
  // Feasibility
  feasibility_status: "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
  feasibility_reason: string | null
  
  created_by: "deterministic_synthesis" | "optimizer"
  optimization_run_id: UUID | null
}
```

**Multiplicity**: Typically 10–100 per layout (depends on DC/AC sizing strategy).

---

#### 1.1.4 **TransformerNode** (Infrastructure Entity)
```
TransformerNode {
  transformer_id: UUID                    // Unique identifier
  
  // Asset
  transformer_asset_id: UUID              // Reference to Asset.Category = TRANSFORMER
  
  // Siting
  position: Point3D {
    longitude: float
    latitude: float
    elevation_m: float
  }
  position_snapped_to_feature: "substation" | "pad_mount" | "pole" | "building" | null
  
  // Electrical
  primary_voltage_kv: float               // Should match project AC voltage
  secondary_voltage_kv: float
  kva_rating: float                       // Apparent power capacity
  
  // Network connectivity
  connected_inverter_group_ids: [UUID]    // Which InverterGroups feed this?
  load_kva: float                         // Sum of connected inverter AC output
  load_utilization_pct: float [0..100]
  
  // Feasibility
  feasibility_status: "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
  feasibility_reason: string | null
  
  created_by: "deterministic_synthesis"
  optimization_run_id: UUID | null
}
```

**Multiplicity**: Typically 1–10 per layout (depends on project size and AC voltage profile).

---

#### 1.1.5 **CableCorridorSegment** (Infrastructure Entity)
```
CableCorridorSegment {
  corridor_id: UUID                       // Segment identifier
  
  // Routing
  path: LineString3D {
    vertices: [Point3D, ...]              // Ordered waypoints (start to end)
    length_m: float
    height_profile: "flat" | "hilly" | "mountainous"
  }
  
  // Cable specification
  cable_type: "UG_DC" | "UG_AC" | "UG_MV" | "OH_LV" | "OH_MV"
  conductor_count: int [1..4]
  conductor_size_mm2: float
  
  // Network role
  source_location: {
    location_type: "inverter_group" | "combiner_box" | "string_combiner"
    entity_id: UUID
  }
  target_location: {
    location_type: "transformer" | "collector_substation" | "grid_interconnect"
    entity_id: UUID | null
  }
  
  // Electrical constraints
  current_rating_adc: float
  voltage_drop_v: float
  
  // Feasibility
  feasibility_status: "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
  feasibility_reason: string | null
  
  bom_count_m: float                      // Meters for BoM
  created_by: "deterministic_synthesis" | "routing_optimizer"
  optimization_run_id: UUID | null
}
```

**Multiplicity**: Typically 50–200 per layout.

---

#### 1.1.6 **FaultIdentifier** (Diagnostic Entity)
```
FaultIdentifier {
  fault_id: UUID                          // Unique fault marker
  
  // Location and scope
  position: Point3D {
    longitude: float
    latitude: float
    elevation_m: float
  }
  scope: "string_combiner" | "inverter_protection" | "transformer_protection" | 
         "ac_disconnect" | "dc_disconnect" | "combiner_box"
  
  // Fault chain path (electrical topology upstream)
  upstream_entities: {
    affected_string_ids: [UUID]           // Which strings can be isolated?
    affected_inverter_ids: [UUID]
    affected_transformer_ids: [UUID]
  }
  
  // Protection device
  protection_type: "fuse" | "breaker" | "recloser" | "manual_disconnect"
  protection_asset_id: UUID | null
  
  // Fault scenario metadata
  fault_scenario: "conductor_short" | "ground_fault" | "overvoltage" | "overcurrent"
  detection_method: "relay" | "monitoring" | "manual"
  isolation_time_ms: float [0..10000]    // Response time for fault clearing
  
  created_by: "deterministic_synthesis" | "electrical_analyzer"
  optimization_run_id: UUID | null
}
```

**Multiplicity**: Typically 20–100 per layout (depends on protection philosophy).

---

### 1.2 Graph Structure

All entities form a **directed acyclic graph (DAG)** with mandatory parent-child relationships:

```
Layout {
  layout_id
  artifact_graph: {
    layout_tiles: [LayoutTile, ...]
    
    // Layer 1: Physical generation
    solar_panels: [SolarPanel, ...]
    infrastructure_zones: [InfrastructureZone, ...]    // roads, combiner areas
    terrain_anchors: [AnchorPoint, ...]                 // height samples
    
    // Layer 2: Electrical composition
    panel_strings: [PanelString, ...]                   // Each references panel_ids
    inverter_groups: [InverterGroup, ...]              // Each references string_ids
    transformer_nodes: [TransformerNode, ...]          // Each references inverter_group_ids
    
    // Layer 3: Routing and cabling
    cable_corridors: [CableCorridorSegment, ...]
    fault_identifiers: [FaultIdentifier, ...]
    
    // Audit
    lineage: CandidateLineage {
      root_candidates: [UUID]                          // Original search seeds
      optimization_history: [OptimizationStep]
      final_selection_reason: string
      checksum: SHA256                                  // Hash of entire graph
    }
  }
}
```

**Invariants**:
- Every `PanelString` must have 1+ panels referenced in `solar_panels` list.
- Every `InverterGroup` must have 1+ strings referenced in `panel_strings` list.
- Every `FaultIdentifier` must reference only valid upstream entity IDs.
- No cycles (DAG property guaranteed by layer ordering).
- **All entity IDs are UUIDs (RFC 4122)** for distributed generation and idempotent merging.

---

### 1.3 Precision Metadata Fields (Per Entity)

Every entity includes a **precision package** for reproducibility tracking:

```
PrecisionMetadata {
  // Scoring and selection history
  feasibility_score: float [0..1]         // Base feasibility during candidate generation
  quality_score: float [-1..1]            // ML ranking score (if applicable)
  confidence_interval: float [0..1]       // ML confidence in score
  
  // Generation metadata
  generation_algorithm: string             // "tiling_grid", "heuristic_sweep", "2d_layout", etc.
  generation_params: {                    // The exact parameters used
    [key: string]: Any                     // E.g., tile_size_m, spacing_factor, tilt_min/max
  }
  generation_seed: int64                  // For deterministic reproducibility
  
  // Linked evidence
  links_to: {
    parent_candidate_id: UUID | null
    optimization_run_id: UUID | null
    root_boundary_id: UUID                // Which boundary was this from?
    terrain_dem_source: string            // Which DEM version?
  }
  
  // Audit checksum
  entity_checksum: SHA256                 // Hash(geometry + electrical_params + orientation)
}
```

---

### 1.4 Full Artifact Graph Message Definition (Protobuf 3)

```proto
// proto/ml/v1/candidate_artifact_graph.proto

syntax = "proto3";
package ml.v1;

import "google/protobuf/timestamp.proto";
import "solar/v1/solar.proto";
import "asset/v1/asset.proto";
import "common/v1/primitives.proto";

message SolarPanel {
  string panel_id = 1;
  string asset_id = 2;
  string tile_id = 3;
  optional string string_id = 4;
  
  common.v1.Polygon3D geometry = 5;
  float tilt_degrees = 6;
  float azimuth_degrees = 7;
  
  float layout_score = 8;
  float mpp_capacity_kw = 9;
  float shading_factor = 10;
  
  enum CreatedBy {
    CREATED_BY_UNSPECIFIED = 0;
    DETERMINISTIC_SYNTHESIS = 1;
    ML_OPTIMIZATION = 2;
    USER_MANUAL = 3;
  }
  CreatedBy created_by = 11;
  optional string optimization_run_id = 12;
  optional string parent_candidate_id = 13;
  
  string checksum = 14;
  google.protobuf.Timestamp created_at = 15;
}

message PanelString {
  string string_id = 1;
  optional string network_id = 2;
  repeated string panel_ids = 3;
  int32 panel_count = 4;
  optional string inverter_group_id = 5;
  
  float string_voltage_vdc = 6;
  float string_current_adc = 7;
  float string_power_kw = 8;
  optional int32 mppt_index = 9;
  
  enum FeasibilityStatus {
    FEASIBILITY_STATUS_UNSPECIFIED = 0;
    PENDING = 1;
    VALID = 2;
    INVALID = 3;
    UNVALIDATED = 4;
  }
  FeasibilityStatus feasibility_status = 10;
  optional string feasibility_reason = 11;
  
  enum CreatedBy {
    CREATED_BY_UNSPECIFIED = 0;
    DETERMINISTIC_SYNTHESIS = 1;
    OPTIMIZER = 2;
  }
  CreatedBy created_by = 12;
  optional string optimization_run_id = 13;
}

message InverterGroup {
  string inverter_group_id = 1;
  optional string network_id = 2;
  string inverter_asset_id = 3;
  repeated string string_ids = 4;
  int32 string_count = 5;
  
  common.v1.Point3D position = 6;
  optional string position_snapped_to_feature = 7;
  
  float dc_input_kw = 8;
  float ac_output_kw = 9;
  float dc_ac_ratio = 10;
  float efficiency_pct = 11;
  
  enum FeasibilityStatus {
    FEASIBILITY_STATUS_UNSPECIFIED = 0;
    PENDING = 1;
    VALID = 2;
    INVALID = 3;
    UNVALIDATED = 4;
  }
  FeasibilityStatus feasibility_status = 12;
  optional string feasibility_reason = 13;
  
  optional string optimization_run_id = 14;
}

message TransformerNode {
  string transformer_id = 1;
  string transformer_asset_id = 2;
  
  common.v1.Point3D position = 3;
  optional string position_snapped_to_feature = 4;
  
  float primary_voltage_kv = 5;
  float secondary_voltage_kv = 6;
  float kva_rating = 7;
  
  repeated string connected_inverter_group_ids = 8;
  float load_kva = 9;
  float load_utilization_pct = 10;
  
  enum FeasibilityStatus {
    FEASIBILITY_STATUS_UNSPECIFIED = 0;
    PENDING = 1;
    VALID = 2;
    INVALID = 3;
    UNVALIDATED = 4;
  }
  FeasibilityStatus feasibility_status = 11;
  optional string feasibility_reason = 12;
  
  optional string optimization_run_id = 13;
}

message CableCorridorSegment {
  string corridor_id = 1;
  
  common.v1.LineString3D path = 2;
  float length_m = 3;
  
  string cable_type = 4; // UG_DC, UG_AC, etc.
  int32 conductor_count = 5;
  float conductor_size_mm2 = 6;
  
  message SourceLocation {
    string location_type = 1;
    string entity_id = 2;
  }
  SourceLocation source_location = 7;
  
  message TargetLocation {
    string location_type = 1;
    optional string entity_id = 2;
  }
  TargetLocation target_location = 8;
  
  float current_rating_adc = 9;
  float voltage_drop_v = 10;
  
  enum FeasibilityStatus {
    FEASIBILITY_STATUS_UNSPECIFIED = 0;
    PENDING = 1;
    VALID = 2;
    INVALID = 3;
    UNVALIDATED = 4;
  }
  FeasibilityStatus feasibility_status = 11;
  optional string feasibility_reason = 12;
  
  float bom_count_m = 13;
  optional string optimization_run_id = 14;
}

message FaultIdentifier {
  string fault_id = 1;
  common.v1.Point3D position = 2;
  string scope = 3;
  
  message UpstreamEntities {
    repeated string affected_string_ids = 1;
    repeated string affected_inverter_ids = 2;
    repeated string affected_transformer_ids = 3;
  }
  UpstreamEntities upstream_entities = 4;
  
  string protection_type = 5;
  optional string protection_asset_id = 6;
  string fault_scenario = 7;
  string detection_method = 8;
  float isolation_time_ms = 9;
  
  optional string optimization_run_id = 10;
}

message CandidateArtifactGraph {
  string layout_id = 1;
  string project_id = 2;
  
  repeated SolarPanel solar_panels = 3;
  repeated PanelString panel_strings = 4;
  repeated InverterGroup inverter_groups = 5;
  repeated TransformerNode transformer_nodes = 6;
  repeated CableCorridorSegment cable_corridors = 7;
  repeated FaultIdentifier fault_identifiers = 8;
  
  message CandidateLineage {
    repeated string root_candidates = 1;
    repeated OptimizationStep optimization_history = 2;
    string final_selection_reason = 3;
    string checksum = 4;
  }
  CandidateLineage lineage = 9;
  
  common.v1.ContractMetadata contract = 10;
}

message OptimizationStep {
  string run_id = 1;
  string algorithm_name = 2;
  int32 generation_count = 3;
  float pareto_improvement_pct = 4;
  google.protobuf.Timestamp completed_at = 5;
}
```

---

## Part 2: Objective and Constraint Dictionary (Draft)

### Purpose

This section defines the **decision space** and **feasibility rules** that ML algorithms use during candidate generation and ranking. It encompasses:
1. **Decision Variables** – What can ML vary?
2. **Hard Constraints** – What must never be violated?
3. **Soft Constraints** – What should be minimized/penalized?
4. **Objectives** – What are we optimizing?

---

### 2.1 Decision Variables (D1–D8)

#### **D1: Panel Tilt Angle** (per panel)
```
Variable: tilt_degrees[panel_id]
Domain: [0°, 90°]
Type: CONTINUOUS
Default: 20° (latitude-dependent heuristic)
Notes:
  - 0° = horizontal (maximum irradiance but rainwater pooling)
  - 90° = vertical (poor irradiance but better drainage)
  - Typical optimal: latitude ± 15°
  - Must respect inverter voltage limits via chain effect on Voc
Precision: 0.1° (1 decimal place)
```

---

#### **D2: Panel Azimuth Angle** (per panel)
```
Variable: azimuth_degrees[panel_id]
Domain: [0°, 360°)
Type: CONTINUOUS
Default: 180° (south-facing in Northern Hemisphere)
Notes:
  - 0° = North, 90° = East, 180° = South, 270° = West
  - Single-axis tracking: azimuth varies with season/day (handled by tracker model)
  - Fixed: azimuth uniform per tile or per string for simplicity
Precision: 1° (integer degrees)
```

---

#### **D3: Panel Spacing Factor** (per tile)
```
Variable: spacing_factor[tile_id]
Domain: [0.85, 1.15]
Type: CONTINUOUS
Default: 1.0
Notes:
  - 0.85 = 15% tighter spacing (more panels, potentially more shading)
  - 1.15 = 15% looser spacing (fewer panels, less shading)
  - Controls row-to-row distance (avoidance of mutual shading)
  - Multiplier on ideal grid spacing
Precision: 0.01 (2 decimals)
```

---

#### **D4: Inverter Block Position** (per inverter group)
```
Variable: position[inverter_group_id] = {lat, lon, elevation}
Domain: Sitable locations within project boundary
Type: DISCRETE (grid-snapped to 10m–50m grid)
Default: Centroid of served inverter footprint
Notes:
  - Can move within siting eligibility zone
  - Must avoid constraint zones (geological, environmental, regulatory)
  - Affects cable routing and land use
  - Subject to: road access, infrastructure proximity, slope limits
Precision: 1 meter (grid snapping)
```

---

#### **D5: Inverter Asset Selection** (per group)
```
Variable: inverter_asset_id[inverter_group_id]
Domain: [asset_1, asset_2, ..., asset_N] (available inverter SKUs)
Type: DISCRETE/CATEGORICAL
Default: Largest available inverter matching DC/AC ratio target
Notes:
  - Defines inverter nameplate (DC input, AC output, MPPT count, efficiency)
  - Higher efficiency → higher cost
  - More MPPTs → higher DC capacity potential
  - Choice locked once in LayoutReady phase
```

---

#### **D6: Transformer Asset Selection** (per transformer)
```
Variable: transformer_asset_id[transformer_id]
Domain: [asset_1, ..., asset_M] (available transformer SKUs)
Type: DISCRETE/CATEGORICAL
Default: Smallest transformer not underutilized
Notes:
  - Defines primary/secondary voltage, KVA rating
  - Must match project AC voltage
  - Larger KVA → higher capital cost, lower kVA utilization
```

---

#### **D7: String Formation Strategy** (global)
```
Variable: string_formation_mode
Domain: {"greedy_sequential", "heuristic_balanced", "ml_optimized"}
Type: CATEGORICAL
Default: "heuristic_balanced"
Notes:
  - greedy_sequential: Fill MPPT 1, then 2, etc. with maximum panels until limit
  - heuristic_balanced: Distribute panels evenly across MPPTs
  - ml_optimized: ML algorithm selects optimal assignment (hidden variable)
```

---

#### **D8: Cable Routing Strategy** (global)
```
Variable: routing_mode
Domain: {"shortest_path", "avoid_shade", "follow_roads", "ml_optimized"}
Type: CATEGORICAL
Default: "follow_roads"
Notes:
  - shortest_path: Euclidean distance (ignores obstacles)
  - avoid_shade: Prevent cable under shadow-casting structures
  - follow_roads: Constrain to existing/proposed road corridors
  - ml_optimized: ML selects routes minimizing cost + complexity
```

---

### 2.2 Hard Constraints (C1–C12)

Hard constraints are **absolute requirements**. Violation = infeasible candidate. ML must guarantee feasibility before returning.

---

#### **C1: Boundary Containment**
```
Constraint: All solar panels must lie strictly inside project boundary.
Formulation: 
  ∀ panel in solar_panels:
    Contains(project_boundary.polygon, panel.geometry) == true
Penalty for Violation: Infinite (candidate rejected)
Checked By: Geometry validation in artifact graph verification
Data Source: project.boundary_polygon (WGS84 Polygon)
```

---

#### **C2: Constraint Zone Avoidance**
```
Constraint: Inverters, transformers, and cable corridors must NOT intersect 
            ZONE_TYPE_EXCLUSION zones or violate ZONE_TYPE_BUFFER distances.
Formulation:
  ∀ inverter in inverter_groups:
    ¬Intersects(inverter.position, exclusion_zones) == true
    Distance(inverter.position, buffer_zones) >= buffer_distance
  ∀ transformer in transformers:
    (same as inverter)
  ∀ corridor in cable_corridors:
    ¬Intersects(corridor.path, exclusion_zones) == true
Penalty: Infinite (candidate rejected)
Checked By: Constraint zone service (CheckSitingConflicts)
Data Source: constraint_v1.Zone entities from project
```

---

#### **C3: Electrical Voltage Limits (String Level)**
```
Constraint: Every string's voltage must fit within inverter MPPT range.
Formulation:
  ∀ string in panel_strings:
    string.string_voltage_vdc <= inverter_asset.max_input_voltage
    string.string_voltage_vdc >= inverter_asset.min_input_voltage
Penalty: Infinite (candidate rejected)
Rationale: Over-voltage damages MPPT; under-voltage wastes capacity
Reference: asset_v1.Asset.ElectricalParameters
```

---

#### **C4: MPPT Panel Limit**
```
Constraint: Panels assigned to a single inverter MPPT must not exceed
            the inverter's max_strings_per_mppt.
Formulation:
  ∀ inverter in inverter_groups:
    ∀ mppt_i in [0, inverter_asset.mppt_count):
      count(strings assigned to mppt_i) <= inverter_asset.max_strings_per_mppt
Penalty: Infinite (candidate rejected)
Reference: asset_v1.Asset.ElectricalParameters.max_strings_per_mppt
```

---

#### **C5: Inverter DC/AC Ratio Bounds**
```
Constraint: DC-to-AC ratio must not exceed nameplate limit or fall below
            minimum safe operating point.
Formulation:
  ∀ inverter in inverter_groups:
    1.1 <= inverter.dc_ac_ratio <= 1.5  [typical for utility-scale]
Penalty: Infinite (candidate rejected)
Rationale: DC/AC < 1.0 = wasted inverter capacity; > 1.5 = chronic clipping
Data Source: optimization.v1.OptimizationProblem.constraints
```

---

#### **C6: Transformer Capacity Bounds**
```
Constraint: Transformer load must not exceed 100% of nameplate KVA.
Formulation:
  ∀ transformer in transformer_nodes:
    transformer.load_kva <= transformer.kva_rating
Penalty: Infinite (candidate rejected)
Rationale: Overload → thermal damage; underload → poor utilization
Checked Mode: Electrical validation (Task 15)
```

---

#### **C7: Slope Limit for Equipment Siting**
```
Constraint: Inverters and transformers must be sited on ground with 
            slope ≤ max_slope_percent (project-specific, typ. 20%).
Formulation:
  ∀ inverter in inverter_groups:
    slope_at(inverter.position) <= project_config.max_equipment_slope_pct
  ∀ transformer in transformer_nodes:
    slope_at(transformer.position) <= project_config.max_equipment_slope_pct
Penalty: Infinite (candidate rejected)
Data Source: terrain service (slope computed from DEM)
```

---

#### **C8: Cable Conductor Sizing (Current Carrying Capacity)**
```
Constraint: Cable ampacity must be ≥ peak current on segment.
Formulation:
  ∀ corridor in cable_corridors:
    CEC_ampacity(conductor_type, conductor_size_mm2) >= corridor.current_rating_adc
Penalty: Infinite (candidate rejected)
Rationale: Undersized conductors → overheating → fire
Reference: Cable ampacity tables (NEC or IEC standards)
```

---

#### **C9: Voltage Drop Limit**
```
Constraint: AC voltage drop from inverter to point of common coupling
            must not exceed 3% (or project-specified limit).
Formulation:
  ∀ path in transmission_network:
    sum(corridor.voltage_drop_v for corridor in path) <= 0.03 * primary_voltage_kv * 1000
Penalty: Infinite (candidate rejected)
Rationale: Excessive drop → inefficiency and grid code violation
Compliance: IEEE 1547, IEC 61727
```

---

#### **C10: Road/Infrastructure Siting Proximity**
```
Constraint: Inverters and transformers must be within max_distance_m
            of road/access infrastructure for installation, maintenance.
Formulation:
  ∀ inverter in inverter_groups:
    min_distance(inverter.position, roads) <= project.max_equipment_distance_from_road_m
  ∀ transformer in transformer_nodes:
    (same)
Penalty: Infinite (candidate rejected)
Data Source: infrastructure layer (from CAD or terrain analysis)
```

---

#### **C11: No Orphan Panels**
```
Constraint: Every panel must be assigned to exactly one string.
Formulation:
  ∀ panel in solar_panels:
    count(strings where panel.id in string.panel_ids) == 1
Penalty: Infinite (candidate rejected)
Checked By: String formation algorithm
```

---

#### **C12: Electrical Topology Connectivity**
```
Constraint: All inverter groups must have a connected path to a transformer
            and ultimately to grid interconnect point.
Formulation:
  ∀ inverter in inverter_groups:
    PathExists(inverter, grid_interconnect, transformer_nodes, cables) == true
Penalty: Infinite (candidate rejected)
Checked By: Transmission routing validator
```

---

### 2.3 Soft Constraints (S1–S5)

Soft constraints are **preferences** that guide candidate ranking. Violations incur penalties, not rejection.

---

#### **S1: Minimize Cable Length**
```
Constraint: Prefer shorter cable runs (cost, complexity, losses)
Metric: total_cable_length_m = sum(corridor.length_m for all corridors)
Penalty Function: penalty_cable = w_cable * (total_cable_length_m / baseline_cable_m)
where w_cable = 0.15 (example weight)
Baseline: reference_solution.total_cable_m (from deterministic fallback)
```

---

#### **S2: Minimize Voltage Drop**
```
Constraint: Prefer designs with low voltage drop (efficiency)
Metric: max_voltage_drop_v = max(
  sum(corridor.voltage_drop_v) for each transmission path
)
Penalty Function: penalty_drop = w_drop * (max_voltage_drop_v / 50)
where w_drop = 0.10
Rationale: <3% drop is hard constraint, but <1% is preferred
```

---

#### **S3: Maximize Panel Utilization (Land Efficiency)**
```
Constraint: Prefer higher density layouts ($/MW, more production)
Metric: utilization_pct = 100 * (count(panels) / max_feasible_panels_for_boundary)
Penalty Function: penalty_utilization = w_util * (1 - utilization_pct / 100)
where w_util = 0.20
Rationale: Balance between panel density and feasibility
```

---

#### **S4: Minimize Shading Losses**
```
Constraint: Prefer panel placements with minimal mutual or terrain shading
Metric: avg_shading_factor = mean([panel.shading_factor for all panels])
Penalty Function: penalty_shading = w_shade * avg_shading_factor
where w_shade = 0.15
Rationale: Shading proxy (to be refined by detailed irradiance model in Task 9)
```

---

#### **S5: Minimize Transformer/Inverter Count**
```
Constraint: Prefer fewer, larger equipment (cost, footprint)
Metric: equipment_count = count(transformers) + count(inverters)
Penalty Function: penalty_equipment = w_equip * (equipment_count / baseline_equipment_count)
where w_equip = 0.10
Rationale: Fewer devices = fewer failure modes, lower O&M
```

---

### 2.4 Objectives (O1–O3)

ML algorithms score and rank candidates against these **multi-objective** goals:

---

#### **O1: Maximize Feasibility Score**
```
Objective: Maximize candidate feasibility (0..1 scale)
Definition:
  feasibility_score = (1.0
    - penalty_hard_constraint_violations
    - 0.1 * penalty_voltage_margin
    - 0.1 * penalty_capacity_margin
    - 0.05 * penalty_routing_complexity)
Range: [0, 1]
Extremum: MAXIMIZE
Weight (in multi-objective): 0.30 (high priority: must be feasible)
```

---

#### **O2: Maximize MW Fit (DC Capacity)**
```
Objective: Maximize installed DC power (project goal)
Definition:
  mw_fit = sum(panel.mpp_capacity_kw for all panels) / 1000
Range: [0, project.capacity_target_mw]
Extremum: MAXIMIZE
Weight: 0.25 (important: revenue driver)
Reference: project.capacity_target_mw, project.min_capacity_mw
```

---

#### **O3: Minimize Total Infrastructure Cost**
```
Objective: Minimize capital expenditure (proxy: equipment count + cable length)
Definition:
  cost_proxy = (
    count(inverters) * inv_cost_unit
    + count(transformers) * tx_cost_unit
    + total_cable_length_m * cable_cost_per_m
    + count(combiner_boxes) * combiner_cost_unit)
Unit: USD (or relative cost index)
Extremum: MINIMIZE
Weight: 0.25 (important: project economics)
Reference: cost_database reference
Alternative: Use actual BOM pricing if available (Task 4 bridge)
```

---

#### **O4: Minimize Land Use (GCR)**
```
Objective: Maximize land utilization / minimize ground coverage ratio (GCR)
Definition:
  gcr = solar_panel_area_m2 / project_area_m2
Range: [0, 1]
Extremum: MAXIMIZE (equivalent to minimizing land use per MW)
Weight: 0.20 (secondary: environmental/permitting)
```

---

### 2.5 Priorities and Lexicographic Ordering

If multiple objectives conflict, apply this **priority hierarchy**:

```
Tier 1 (HARD):  Feasibility must be > 0 (no infeasible candidates returned)
Tier 2 (SOFT):  Maximize MW_fit within feasible set (project capacity goal)
Tier 3 (SOFT):  Minimize cost within top-MW candidates (economics)
Tier 4 (SOFT):  Minimize land use / GCR (environmental)
Tier 5 (SOFT):  Minimize cable/shading (efficiency / reliability)
```

**Example**:
- Candidate A: feasible, 85 MW, $4.2M, 0.35 GCR → Preferred if top in MW
- Candidate B: feasible, 80 MW, $3.8M, 0.30 GCR → Considered if MW difference < 10%
- Candidate C: infeasible (voltage violation) → Rejected immediately

---

### 2.6 Constraint Dictionary (Protobuf Message)

```proto
// proto/ml/v1/optimization_objectives_constraints.proto

syntax = "proto3";
package ml.v1;

option go_package = "github.com/solar3d/solar3d/gen/ml/v1;mlv1";

import "common/v1/primitives.proto";
import "optimization/v1/optimization_domain.proto";

// === Hard Constraints ===

message BoundaryContainmentConstraint {
  string boundary_polygon_wkt = 1;
  bool enforce_strict_containment = 2;
}

message ConstraintZoneAvoidanceConstraint {
  repeated string exclusion_zone_ids = 1;
  map<string, float> buffer_distance_by_zone_id = 2; // meters
}

message VoltageConstraint {
  float min_string_voltage_vdc = 1;
  float max_string_voltage_vdc = 2;
  float min_system_voltage_vdc = 3;
  float max_system_voltage_vdc = 4;
}

message SlopeConstraint {
  float max_equipment_slope_pct = 1;
  string dem_source = 2;
}

message RoadProximityConstraint {
  float max_distance_to_road_m = 1;
  string infrastructure_layer_id = 2;
}

message HardConstraintSet {
  BoundaryContainmentConstraint boundary = 1;
  ConstraintZoneAvoidanceConstraint zones = 2;
  VoltageConstraint voltage = 3;
  SlopeConstraint slope = 4;
  RoadProximityConstraint road_access = 5;
  
  float transformer_capacity_margin_pct = 6; // e.g., 90 (max 90% load)
  float cable_ampacity_margin_pct = 7;        // e.g., 80 (min 80% capacity)
  float voltage_drop_limit_pct = 8;           // e.g., 3.0
}

// === Soft Constraints (Preferences) ===

message SoftConstraint {
  string name = 1;
  string metric_definition = 2;
  float weight = 3;                // [0..1] normalized
  float baseline_value = 4;        // reference for normalization
}

message SoftConstraintSet {
  SoftConstraint minimize_cable_length = 1;
  SoftConstraint minimize_voltage_drop = 2;
  SoftConstraint maximize_panel_utilization = 3;
  SoftConstraint minimize_shading = 4;
  SoftConstraint minimize_equipment_count = 5;
}

// === Objectives ===

enum ObjectiveType {
  OBJECTIVE_TYPE_UNSPECIFIED = 0;
  MAXIMIZE_FEASIBILITY = 1;
  MAXIMIZE_MW_FIT = 2;
  MINIMIZE_COST = 3;
  MAXIMIZE_LAND_UTILIZATION = 4;
}

message Objective {
  ObjectiveType type = 1;
  float weight = 2;               // [0..1] for weighted sum
  float target_value = 3;         // e.g., capacity target in MW
}

message ObjectiveSet {
  repeated Objective objectives = 1;
  
  enum AggregationMethod {
    AGGREGATION_METHOD_UNSPECIFIED = 0;
    WEIGHTED_SUM = 1;              // Sum of (weight * normalized_obj)
    LEXICOGRAPHIC = 2;             // Tier-based priority
    PARETO_FRONTIER = 3;           // Return non-dominated set
  }
  AggregationMethod aggregation = 2;
  bool return_pareto_frontier = 3;
}

message OptimizationObjectivesAndConstraints {
  string version = 1;              // e.g., "1.0"
  string project_id = 2;
  
  HardConstraintSet hard_constraints = 3;
  SoftConstraintSet soft_constraints = 4;
  ObjectiveSet objectives = 5;
  
  string lexicographic_priority_order = 6; // e.g., "Tier1=Feasibility, Tier2=MW, ..."
  
  common.v1.ContractMetadata contract = 7;
}
```

---

## Part 3: ML Phase Input Contract

### 3.1 Required Inputs

Every ML algorithm receives this **input envelope** at startup:

```proto
message MLPhaseInput {
  string project_id = 1;
  string layout_id = 2;
  
  // Boundary and terrain
  solar.v1.ProjectBoundary site_boundary =3;
  terrain.v1.DEMSnapshot terrain_dem = 4;
  
  // Asset catalog
  repeated asset.v1.Asset available_assets = 5;
  
  // Constraints and objectives (frozen from Part 2)
  OptimizationObjectivesAndConstraints optimization_spec = 6;
  
  // Configuration
  int64 random_seed = 7;          // For deterministic reproducibility
  int32 max_candidates_to_generate = 8; // e.g., 1000
  
  // Fallback (deterministic)
  CandidateArtifactGraph deterministic_fallback = 9;
  
  google.protobuf.Timestamp created_at = 10;
}
```

---

### 3.2 ML Phase Output Contract

Every ML algorithm **MUST** return:

```proto
message MLPhaseOutput {
  string project_id = 1;
  string layout_id = 2;
  string experiment_id = 3;       // Unique run identifier (UUID)
  
  // Generated candidates (sorted by rank)
  repeated MLCandidate candidates = 4;
  
  // Statistics
  int32 total_generated = 5;
  int32 total_feasible = 6;
  int32 total_ranked = 7;
  
  // Execution metadata
  google.protobuf.Duration execution_time = 8;
  string algorithm_name = 9;      // e.g., "genetic_algorithm_v1"
  int32 iteration_count = 10;
  
  // Deterministic fallback inclusion
  bool deterministic_fallback_included = 11;
  
  google.protobuf.Timestamp completed_at = 12;
}

message MLCandidate {
  string candidate_id = 1;
  
  // Artifact graph (complete layout)
  CandidateArtifactGraph artifact_graph = 2;
  
  // Objective scores
  map<string, float> objective_scores = 3; // e.g., {"feasibility": 0.95, "mw_fit": 0.88, ...}
  
  // Ranking metadata
  float composite_score = 4;      // Normalized [0, 1]
  int32 rank = 5;                 // 1 = best, N = worst in set
  
  // Confidence interval (if ML model provides uncertainty)
  float confidence_lower_bound = 6;
  float confidence_upper_bound = 7;
  
  // Selection reason (for explainability)
  string selection_reasoning = 8; // E.g., "Balanced MW + cost on Pareto frontier"
  
  // Lineage
  repeated string parent_candidate_ids = 9; // Which prior candidates were parents?
  string optimization_algorithm_used = 10;
}
```

---

## Part 4: Task 3 Verification Checklist

✓ **Schema Capability Check**: Does the artifact graph schema represent all required asset classes and relationships?

- ✓ SolarPanel: geometry, tilt, azimuth, electrical params
- ✓ PanelString: panel ordering, voltage/current, inverter FK
- ✓ InverterGroup: asset, siting, electrical aggregate
- ✓ TransformerNode: asset, siting, load tracking, connectivity
- ✓ CableCorridorSegment: routing, ampacity, voltage drop
- ✓ FaultIdentifier: protection scope, upstream isolation
- ✓ Lineage: root candidates, optimization history, checksums

**Result**: All required entity types present. Schema complete.

---

✓ **Constraint Coverage Check**: Do objectives and constraints cover all ML decision points?

Hard Constraints:
- ✓ C1: Boundary containment
- ✓ C2: Exclusion/buffer zone avoidance
- ✓ C3–C4: Voltage and MPPT limits
- ✓ C5–C6: Inverter and transformer capacity
- ✓ C7–C10: Siting, cable, road access
- ✓ C11–C12: Topology connectivity

Soft Constraints:
- ✓ S1–S2: Cable and voltage drop minimization
- ✓ S3–S4: Utilization and shading
- ✓ S5: Equipment count minimization

Objectives:
- ✓ O1: Feasibility maximization
- ✓ O2: MW fit (capacity target)
- ✓ O3: Cost minimization
- ✓ O4: Land utilization

**Result**: All major ML decision points covered. Dictionary complete.

---

✓ **Reproducibility Check**: Can deterministic fallback be called with frozen seed?

- Design includes: `random_seed` in MLPhaseInput
- Design includes: `deterministic_fallback` in MLPhaseInput
- Design includes: Lineage tracking (optimization_run_id, parent_candidate_id)
- Design includes: Entity checksums (for output verification)

**Result**: Reproducibility guardrails present. Fallback capable.

---

✓ **Backwards Compatibility Check**: Can existing proto imports (asset, layout, electrical, terrain) consume these new types?

- ✓ CandidateArtifactGraph imports only common/v1 and asset/v1 types (already exist)
- ✓ MLPhaseInput/Output import project, terrain, asset (already published)
- ✓ No circular dependencies between ml/v1 and existing packages

**Result**: Backwards compatible. No breaking changes to existing consumers.

---

## Part 5: Handoff to Task 4

**What Task 4 Must Deliver**:
- Implementation of CandidateArtifactGraph as a Go struct in `compute/ml-inference/` package
- Migration path from this proto to actual SQL schema (for persistence)
- Integrated test suite validating artifact graph construction against schema

**Inputs from Task 3 (Frozen)**:
- ✓ Full Protobuf definitions (6 entity types + metadata)
- ✓ Objective weight vector and constraint priorities
- ✓ Hard constraint validation checklist
- ✓ Soft constraint penalty functions

**Non-Negotiable Invariants**:
1. All entity IDs must be UUIDs (RFC 4122) for distributed generation
2. All entities must include feasibility_status enum for progressive validation
3. All entities must include optimization_run_id lineage for traceability
4. No modification to artifact graph after `feasibility_status = VALID`
5. Every artifact graph must have a deterministic checksum (SHA256 of geometry + topology)

---

## Summary

**Task 3 Deliverables: COMPLETE** ✓

1. **Candidate Artifact Graph Schema (Draft)** – 6 entity types with full proto definitions
   - SolarPanel, PanelString, InverterGroup, TransformerNode, CableCorridorSegment, FaultIdentifier
   - Mandatory precision/lineage metadata per entity
   - Invariant: Directed acyclic graph with ordered layers

2. **Objective and Constraint Dictionary (Draft)** – 8 decision variables, 12 hard constraints, 5 soft constraints, 4 objectives
   - Decision variables: tilt, azimuth, spacing, inverter/transformer siting, string formation, cable routing
   - Hard constraints: boundary, zones, voltage limits, equipment capacity, topology connectivity
   - Soft constraints: cable length, voltage drop, utilization, shading, equipment count
   - Objectives: feasibility, MW fit, cost, land utilization
   - Lexicographic priority: Feasibility > MW > Cost > Land Use > Efficiency

3. **ML Phase Input/Output Contracts** – Protobuf messages defining operational boundary
   - Input: boundary, terrain, asset catalog, constraints/objectives, seed, fallback
   - Output: ranked candidate set with scores, confidence intervals, explainability

**Verification Gate A (Task 3 → Task 4)**:
- ✓ Schema covers all required asset classes
- ✓ Constraints cover all decision points
- ✓ Reproducibility guardrails present
- ✓ Backwards compatible with existing protos
- ✓ Ready for implementation in Task 4

---

**Next**: Task 4 – Define complete-layout artifact graph contract (sql schema + Go struct migration)
