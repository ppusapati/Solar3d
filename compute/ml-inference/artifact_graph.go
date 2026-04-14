// Package ml_inference provides ML/algorithm types and interfaces for candidate generation and ranking.
package ml_inference

import (
	"crypto/sha256"
	"fmt"
	"time"

	"github.com/google/uuid"
)

// ========== Core Entity Types ==========

// SolarPanel represents a single photovoltaic panel placement with geometry and electrical parameters.
type SolarPanel struct {
	// Identity
	PanelID  string  // UUID format: panel-<project>-<tile>-<seq>
	AssetID  string  // Reference to Asset entity (Category = SOLAR_PANEL)
	TileID   string  // Parent tile UUID (for hierarchical queries)
	StringID *string // Optional FK to PanelString (assigned during electrical phase)

	// Geometry (WGS84 / EPSG:4326)
	Geometry Geometry `json:"geometry"` // Polygon3D: 4 corners in CCW order (viewed from above)

	// Orientation (electrical performance driver)
	TiltDegrees    float64 // [0..90] Ground to horizontal plane
	AzimuthDegrees float64 // [0..360] 0=N, 90=E, 180=S, 270=W

	// Precision fields
	LayoutScore   float64 // [0..1] Feasibility/utilization score
	MppCapacityKw float64 // DC nameplate power
	ShadingFactor float64 // [0..1] Proxy penalty (>0 = shade loss)

	// Lineage
	CreatedBy         string  // "deterministic_synthesis" | "ml_optimization" | "user_manual"
	OptimizationRunID *string // If created by ML, which run?
	ParentCandidateID *string // If ranked/modified from prior candidate
	FeasibilityStatus string  // "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
	FeasibilityReason *string // If INVALID, why?

	// Audit
	Checksum  string // SHA256(geometry || orientation)
	CreatedAt time.Time

	// Precision metadata
	PrecisionMetadata *PrecisionMetadata `json:"precision_metadata,omitempty"`
}

// PanelString represents an electrical string (series-connected panels to a single MPPT).
type PanelString struct {
	// Identity
	StringID  string  // UUID
	NetworkID *string // FK to ElectricalNetwork (null during ML phase)

	// Composition
	PanelIDs        []string // Ordered list (series electrical path)
	PanelCount      int32
	InverterGroupID *string // FK to InverterGroup (assigned later)
	MPPTIndex       *int32  // Which MPPT on inverter? (assigned later)

	// Electrical attributes
	StringVoltageVdc float64 // Voc of all panels in series
	StringCurrentAdc float64 // Isc of any panel (bottleneck)
	StringPowerKw    float64 // Sum of panel mpp_capacity_kw

	// Feasibility
	FeasibilityStatus string  // "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
	FeasibilityReason *string // If INVALID, why?

	// Lineage
	CreatedBy         string // "deterministic_synthesis" | "optimizer"
	OptimizationRunID *string

	// Audit
	CreatedAt time.Time

	// Precision metadata
	PrecisionMetadata *PrecisionMetadata `json:"precision_metadata,omitempty"`
}

// InverterGroup represents a group of strings fed to a single inverter.
type InverterGroup struct {
	// Identity
	InverterGroupID string  // UUID
	NetworkID       *string // FK to ElectricalNetwork
	InverterAssetID string  // Reference to Asset (Category = STRING_INVERTER | CENTRAL_INVERTER)

	// Composition
	StringIDs   []string // List of PanelString IDs
	StringCount int32

	// Siting
	Position                 Point3D // Inverter physical location {lon, lat, elev_m}
	PositionSnappedToFeature *string // "road" | "foundation" | "building" | null

	// Electrical aggregate
	DcInputKw     float64 // Sum of string_power_kw
	AcOutputKw    float64 // Inverter rated AC output
	DcAcRatio     float64 // dc_input_kw / ac_output_kw
	EfficiencyPct float64 // [0..100]

	// Feasibility
	FeasibilityStatus string // "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
	FeasibilityReason *string

	// Lineage
	CreatedBy         string // "deterministic_synthesis" | "optimizer"
	OptimizationRunID *string

	// Audit
	CreatedAt time.Time

	// Precision metadata
	PrecisionMetadata *PrecisionMetadata `json:"precision_metadata,omitempty"`
}

// TransformerNode represents a transformer in the transmission network.
type TransformerNode struct {
	// Identity
	TransformerID      string // UUID
	TransformerAssetID string // Reference to Asset (Category = TRANSFORMER)

	// Siting
	Position                 Point3D // Transformer physical location
	PositionSnappedToFeature *string

	// Electrical
	PrimaryVoltageKv   float64 // Should match project AC voltage
	SecondaryVoltageKv float64
	KvaRating          float64

	// Network connectivity
	ConnectedInverterGroupIDs []string // Which InverterGroups feed this?
	LoadKva                   float64  // Sum of connected inverter AC output
	LoadUtilizationPct        float64  // [0..100]

	// Feasibility
	FeasibilityStatus string // "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
	FeasibilityReason *string

	// Lineage
	CreatedBy         string // "deterministic_synthesis"
	OptimizationRunID *string

	// Audit
	CreatedAt time.Time

	// Precision metadata
	PrecisionMetadata *PrecisionMetadata `json:"precision_metadata,omitempty"`
}

// CableCorridorSegment represents a cable run between electrical nodes.
type CableCorridorSegment struct {
	// Identity
	CorridorID string // UUID

	// Routing
	Path          LineString3D // Ordered waypoints
	LengthM       float64
	HeightProfile string // "flat" | "hilly" | "mountainous"

	// Cable specification
	CableType        string // "UG_DC" | "UG_AC" | "UG_MV" | "OH_LV" | "OH_MV"
	ConductorCount   int32
	ConductorSizeMm2 float64

	// Network role
	SourceLocation SourceLocation
	TargetLocation TargetLocation

	// Electrical constraints
	CurrentRatingAdc float64 // Ampacity
	VoltageDropV     float64

	// Feasibility
	FeasibilityStatus string // "PENDING" | "VALID" | "INVALID" | "UNVALIDATED"
	FeasibilityReason *string

	// BoM
	BomCountM float64 // Meters for bill of materials

	// Lineage
	CreatedBy         string // "deterministic_synthesis" | "routing_optimizer"
	OptimizationRunID *string

	// Audit
	CreatedAt time.Time

	// Precision metadata
	PrecisionMetadata *PrecisionMetadata `json:"precision_metadata,omitempty"`
}

// SourceLocation identifies the source of a cable segment.
type SourceLocation struct {
	LocationType string // "inverter_group" | "combiner_box" | "string_combiner"
	EntityID     string // UUID
}

// TargetLocation identifies the target of a cable segment.
type TargetLocation struct {
	LocationType string  // "transformer" | "collector_substation" | "grid_interconnect"
	EntityID     *string // UUID or null
}

// FaultIdentifier represents a fault isolation point in the network.
type FaultIdentifier struct {
	// Identity
	FaultID string // UUID

	// Location and scope
	Position Point3D // {lon, lat, elev_m}
	Scope    string  // "string_combiner" | "inverter_protection" | "transformer_protection" | etc.

	// Fault chain (upstream topology)
	UpstreamEntities UpstreamEntities // Affected strings, inverters, transformers

	// Protection device
	ProtectionType    string // "fuse" | "breaker" | "recloser" | "manual_disconnect"
	ProtectionAssetID *string

	// Fault scenario
	FaultScenario   string  // "conductor_short" | "ground_fault" | "overvoltage" | "overcurrent"
	DetectionMethod string  // "relay" | "monitoring" | "manual"
	IsolationTimeMs float64 // [0..10000] Response time

	// Lineage
	CreatedBy         string // "deterministic_synthesis" | "electrical_analyzer"
	OptimizationRunID *string

	// Audit
	CreatedAt time.Time

	// Precision metadata
	PrecisionMetadata *PrecisionMetadata `json:"precision_metadata,omitempty"`
}

// UpstreamEntities captures fault isolation scope.
type UpstreamEntities struct {
	AffectedStringIDs      []string
	AffectedInverterIDs    []string
	AffectedTransformerIDs []string
}

// ========== Geometry Types ==========

// Point3D represents a point in 3D space (WGS84 + elevation).
type Point3D struct {
	Longitude  float64 // [-180, 180]
	Latitude   float64 // [-90, 90]
	ElevationM float64 // Height above MSL (meters)
}

// Polygon3D represents a closed polygon in 3D space.
type Geometry struct {
	Vertices        []Point3D // 4+ points
	ElevationSource string    // "DEM" | "interpolated" | "constant"
	DatumOffsetM    float64   // Height offset above MSL
}

// LineString3D represents an ordered sequence of 3D points (not closed).
type LineString3D struct {
	Vertices      []Point3D
	LengthM       float64
	HeightProfile string // "flat" | "hilly" | "mountainous"
}

// ========== Artifact Graph Container ==========

// CandidateArtifactGraph represents a complete feasible layout solution.
// This is the primary output of ML algorithms and input to backend services.
type CandidateArtifactGraph struct {
	// Identity
	LayoutID  string // UUID
	ProjectID string // UUID

	// Deterministic infrastructure artifacts (Task 6)
	Infrastructure *InfrastructureLayout

	// Entities (layers)
	SolarPanels      []*SolarPanel
	PanelStrings     []*PanelString
	InverterGroups   []*InverterGroup
	TransformerNodes []*TransformerNode
	CableCorridors   []*CableCorridorSegment
	FaultIdentifiers []*FaultIdentifier

	// Lineage and audit
	Lineage *CandidateLineage

	// Metadata
	CreatedAt time.Time
	Version   string // e.g., "1.0"
}

// InfrastructureLayout contains deterministic non-panel artifacts synthesized in Task 6.
type InfrastructureLayout struct {
	RoadSegments       []*RoadSegment
	InverterZones      []*EquipmentZone
	TransformerZones   []*EquipmentZone
	ACEquipmentZones   []*EquipmentZone
	DCEquipmentZones   []*EquipmentZone
	CableAnchors       []*CorridorAnchor
	FaultMarkerAnchors []*FaultMarkerAnchor
}

// RoadSegment is an access/service route segment.
type RoadSegment struct {
	RoadID      string
	RoadType    string // "primary" | "secondary" | "service"
	Path        LineString3D
	WidthM      float64
	CreatedBy   string
	CreatedAt   time.Time
	Determinism string // hash token used to prove deterministic synthesis
}

// EquipmentZone is a deterministic site zone for equipment siting.
type EquipmentZone struct {
	ZoneID       string
	ZoneType     string // "inverter" | "transformer" | "ac_equipment" | "dc_equipment"
	Boundary     Geometry
	Center       Point3D
	AreaM2       float64
	CreatedBy    string
	CreatedAt    time.Time
	Determinism  string
	SlopePercent float64
}

// CorridorAnchor is a deterministic anchor point for cable routing.
type CorridorAnchor struct {
	AnchorID     string
	AnchorType   string // "inverter_pickup" | "transformer_hub" | "junction"
	Position     Point3D
	EntityID     string // upstream/downstream entity id
	CreatedBy    string
	CreatedAt    time.Time
	Determinism  string
	ElevationMsl float64
}

// FaultMarkerAnchor is a deterministic anchor for protection/fault markers.
type FaultMarkerAnchor struct {
	MarkerID     string
	Position     Point3D
	Scope        string
	LinkedZoneID string
	CreatedBy    string
	CreatedAt    time.Time
	Determinism  string
}

// CandidateLineage tracks optimization history and selection reasoning.
type CandidateLineage struct {
	RootCandidateIDs     []string
	OptimizationHistory  []*OptimizationStep
	FinalSelectionReason string
	Checksum             string // SHA256 of entire graph
}

// OptimizationStep records a single algorithm execution.
type OptimizationStep struct {
	RunID                string
	AlgorithmName        string
	GenerationCount      int32
	ParetoImprovementPct float64
	CompletedAt          time.Time
}

// ========== Precision Metadata ==========

// PrecisionMetadata tracks reproducibility and generation parameters per entity.
type PrecisionMetadata struct {
	// Scoring
	FeasibilityScore   float64
	QualityScore       float64 // [-1, 1]
	ConfidenceInterval float64 // [0, 1]

	// Generation
	GenerationAlgorithm string
	GenerationParams    map[string]interface{} // Algorithm-specific params
	GenerationSeed      int64

	// Linkage
	ParentCandidateID string
	OptimizationRunID string
	RootBoundaryID    string
	TerrainDemSource  string

	// Audit
	EntityChecksum string // SHA256(geometry + electrical_params + orientation)
}

// ========== Candidate Set and Ranking ==========

// MLCandidate wraps an artifact graph with ranking metadata.
type MLCandidate struct {
	CandidateID           string
	ArtifactGraph         *CandidateArtifactGraph
	ObjectiveScores       map[string]float64 // e.g., {"feasibility": 0.95, "mw_fit": 0.88}
	CompositeScore        float64            // Normalized [0, 1]
	Rank                  int32              // 1=best
	ConfidenceLower       float64
	ConfidenceUpper       float64
	SelectionReasoning    string
	ParentCandidateIDs    []string
	OptimizationAlgorithm string
	CreatedAt             time.Time
}

// MLPhaseOutput is the primary output of all ML algorithms.
type MLPhaseOutput struct {
	ProjectID                     string
	LayoutID                      string
	ExperimentID                  string         // UUID, unique run identifier
	Candidates                    []*MLCandidate // Sorted by rank
	TotalGenerated                int32
	TotalFeasible                 int32
	TotalRanked                   int32
	ExecutionTime                 time.Duration
	AlgorithmName                 string // e.g., "genetic_algorithm_v1"
	IterationCount                int32
	DeterministicFallbackIncluded bool
	CompletedAt                   time.Time
}

// ========== Helper Methods ==========

// ComputeChecksum computes SHA256 hash of the artifact graph for reproducibility verification.
func (g *CandidateArtifactGraph) ComputeChecksum() string {
	h := sha256.New()
	if g.Infrastructure != nil {
		for _, road := range g.Infrastructure.RoadSegments {
			fmt.Fprintf(h, "road:%s:%s:%.2f", road.RoadID, road.RoadType, road.WidthM)
		}
		for _, zone := range g.Infrastructure.InverterZones {
			fmt.Fprintf(h, "zone:%s:%s:%.6f:%.6f", zone.ZoneID, zone.ZoneType, zone.Center.Longitude, zone.Center.Latitude)
		}
		for _, zone := range g.Infrastructure.TransformerZones {
			fmt.Fprintf(h, "zone:%s:%s:%.6f:%.6f", zone.ZoneID, zone.ZoneType, zone.Center.Longitude, zone.Center.Latitude)
		}
		for _, zone := range g.Infrastructure.ACEquipmentZones {
			fmt.Fprintf(h, "zone:%s:%s:%.6f:%.6f", zone.ZoneID, zone.ZoneType, zone.Center.Longitude, zone.Center.Latitude)
		}
		for _, zone := range g.Infrastructure.DCEquipmentZones {
			fmt.Fprintf(h, "zone:%s:%s:%.6f:%.6f", zone.ZoneID, zone.ZoneType, zone.Center.Longitude, zone.Center.Latitude)
		}
		for _, anchor := range g.Infrastructure.CableAnchors {
			fmt.Fprintf(h, "anchor:%s:%s:%.6f:%.6f", anchor.AnchorID, anchor.AnchorType, anchor.Position.Longitude, anchor.Position.Latitude)
		}
		for _, marker := range g.Infrastructure.FaultMarkerAnchors {
			fmt.Fprintf(h, "fault_anchor:%s:%s:%.6f:%.6f", marker.MarkerID, marker.Scope, marker.Position.Longitude, marker.Position.Latitude)
		}
	}
	for _, panel := range g.SolarPanels {
		fmt.Fprintf(h, "panel:%s:%.4f:%.4f", panel.PanelID, panel.TiltDegrees, panel.AzimuthDegrees)
	}
	for _, str := range g.PanelStrings {
		fmt.Fprintf(h, "string:%s:%d:%.2f", str.StringID, str.PanelCount, str.StringPowerKw)
	}
	for _, inv := range g.InverterGroups {
		fmt.Fprintf(h, "inverter:%s:%.2f:%.2f", inv.InverterGroupID, inv.DcInputKw, inv.DcAcRatio)
	}
	for _, tx := range g.TransformerNodes {
		fmt.Fprintf(h, "transformer:%s:%.2f", tx.TransformerID, tx.LoadKva)
	}
	return fmt.Sprintf("%x", h.Sum(nil))
}

// ValidateFeasibility checks that all hard constraints are satisfied.
// Returns error if any constraint violated; nil if valid.
func (g *CandidateArtifactGraph) ValidateFeasibility() error {
	// C1: All panels inside boundary (must be checked externally with project boundary)

	// C3: String voltage limits (requires asset data)
	for _, str := range g.PanelStrings {
		if str.FeasibilityStatus == "INVALID" {
			return fmt.Errorf("string %s is INVALID: %v", str.StringID, str.FeasibilityReason)
		}
	}

	// C5: DC/AC ratio
	for _, inv := range g.InverterGroups {
		if inv.DcAcRatio < 1.1 || inv.DcAcRatio > 1.5 {
			return fmt.Errorf("inverter %s DC/AC ratio %.2f out of bounds [1.1, 1.5]", inv.InverterGroupID, inv.DcAcRatio)
		}
		if inv.FeasibilityStatus == "INVALID" {
			return fmt.Errorf("inverter %s is INVALID: %v", inv.InverterGroupID, inv.FeasibilityReason)
		}
	}

	// C6: Transformer capacity
	for _, tx := range g.TransformerNodes {
		if tx.LoadKva > tx.KvaRating {
			return fmt.Errorf("transformer %s load %.2f kVA exceeds rating %.2f kVA", tx.TransformerID, tx.LoadKva, tx.KvaRating)
		}
		if tx.FeasibilityStatus == "INVALID" {
			return fmt.Errorf("transformer %s is INVALID: %v", tx.TransformerID, tx.FeasibilityReason)
		}
	}

	// C8: Cable ampacity (requires ampacity tables)
	for _, cable := range g.CableCorridors {
		if cable.FeasibilityStatus == "INVALID" {
			return fmt.Errorf("cable %s is INVALID: %v", cable.CorridorID, cable.FeasibilityReason)
		}
	}

	// C11: No orphan panels
	panelToStringCount := make(map[string]int)
	for _, str := range g.PanelStrings {
		for _, panelID := range str.PanelIDs {
			panelToStringCount[panelID]++
		}
	}
	for _, panel := range g.SolarPanels {
		if panelToStringCount[panel.PanelID] != 1 {
			return fmt.Errorf("panel %s assigned to %d strings (expected 1)", panel.PanelID, panelToStringCount[panel.PanelID])
		}
	}

	return nil
}

// Summary returns a human-readable summary of the artifact graph.
func (g *CandidateArtifactGraph) Summary() string {
	totalCapacityKw := 0.0
	for _, panel := range g.SolarPanels {
		totalCapacityKw += panel.MppCapacityKw
	}

	infraRoads := 0
	infraAnchors := 0
	if g.Infrastructure != nil {
		infraRoads = len(g.Infrastructure.RoadSegments)
		infraAnchors = len(g.Infrastructure.CableAnchors)
	}

	return fmt.Sprintf(
		"CandidateArtifactGraph(layout=%s, panels=%d capacity=%.1f kW, strings=%d, inverters=%d, transformers=%d, cables=%d, faults=%d, roads=%d, cable_anchors=%d)",
		g.LayoutID,
		len(g.SolarPanels),
		totalCapacityKw,
		len(g.PanelStrings),
		len(g.InverterGroups),
		len(g.TransformerNodes),
		len(g.CableCorridors),
		len(g.FaultIdentifiers),
		infraRoads,
		infraAnchors,
	)
}

// IDsUnique generates a new UUID for entity identification.
func NewEntityID(prefix string) string {
	return prefix + "-" + uuid.New().String()
}
