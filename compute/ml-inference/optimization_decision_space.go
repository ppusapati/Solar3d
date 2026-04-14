// Package optimization provides the decision space model and constraint validation
// for ML-based candidate generation. This implements the optimization_objectives_constraints.proto
// definitions from Task 3 as executable Go code.
package ml_inference

import (
	"fmt"
	"math"
)

// ========== Decision Variable Definitions (D1–D8) ==========

// DecisionVariable represents a variable that ML algorithms can modify during optimization.
type DecisionVariable struct {
	Name         string  // Unique identifier (e.g., "tilt_panel_p1")
	VariableType string  // "CONTINUOUS" | "INTEGER" | "BINARY"
	MinValue     float64 // Lower bound
	MaxValue     float64 // Upper bound
	DefaultValue float64 // Initial value
	Unit         string  // Physical unit (e.g., "degrees", "kW", "meters")
	Description  string  // Human-readable description
}

// IsValid checks if a value is within bounds for this variable.
func (dv *DecisionVariable) IsValid(value float64) bool {
	if math.IsNaN(value) {
		return false
	}
	return value >= dv.MinValue && value <= dv.MaxValue
}

// Clamp restricts a value to the valid range.
func (dv *DecisionVariable) Clamp(value float64) float64 {
	if value < dv.MinValue {
		return dv.MinValue
	}
	if value > dv.MaxValue {
		return dv.MaxValue
	}
	return value
}

// DecisionSpace represents the complete set of variables that can be optimized.
type DecisionSpace struct {
	// D1: Panel Tilt Angle
	TiltAngle *DecisionVariable

	// D2: Panel Azimuth Angle
	AzimuthAngle *DecisionVariable

	// D3: Panel Spacing Factor
	SpacingFactor *DecisionVariable

	// D4: Inverter Block Position (3D)
	InverterPositionX *DecisionVariable
	InverterPositionY *DecisionVariable
	InverterPositionZ *DecisionVariable

	// D5: Inverter Asset Selection (categorical, handled separately)
	InverterAssetIndex *DecisionVariable

	// D6: Transformer Asset Selection (categorical, handled separately)
	TransformerAssetIndex *DecisionVariable

	// D7: String Formation Strategy (categorical)
	StringFormationMode string // "greedy_sequential" | "heuristic_balanced" | "ml_optimized"

	// D8: Cable Routing Strategy (categorical)
	CableRoutingMode string // "shortest_path" | "avoid_shade" | "follow_roads" | "ml_optimized"
}

// NewDecisionSpace creates a default decision space with standard solar project bounds.
func NewDecisionSpace() *DecisionSpace {
	return &DecisionSpace{
		// D1: Tilt angle [0°, 90°], default = latitude-based (assume 35° for northern US)
		TiltAngle: &DecisionVariable{
			Name:         "panel_tilt_degrees",
			VariableType: "CONTINUOUS",
			MinValue:     0.0,
			MaxValue:     90.0,
			DefaultValue: 35.0,
			Unit:         "degrees",
			Description:  "Angle from horizontal plane",
		},

		// D2: Azimuth angle [0°, 360°), default = 180° (south-facing)
		AzimuthAngle: &DecisionVariable{
			Name:         "panel_azimuth_degrees",
			VariableType: "CONTINUOUS",
			MinValue:     0.0,
			MaxValue:     360.0,
			DefaultValue: 180.0,
			Unit:         "degrees",
			Description:  "0=North, 90=East, 180=South, 270=West",
		},

		// D3: Spacing factor [0.85, 1.15], default = 1.0
		SpacingFactor: &DecisionVariable{
			Name:         "panel_spacing_factor",
			VariableType: "CONTINUOUS",
			MinValue:     0.85,
			MaxValue:     1.15,
			DefaultValue: 1.0,
			Unit:         "dimensionless",
			Description:  "Multiplier on ideal grid spacing (shading avoidance)",
		},

		// D4: Inverter position (X coordinate, relative to site center)
		InverterPositionX: &DecisionVariable{
			Name:         "inverter_position_x_meters",
			VariableType: "CONTINUOUS",
			MinValue:     -10000.0,
			MaxValue:     10000.0,
			DefaultValue: 0.0,
			Unit:         "meters",
			Description:  "Easting offset from site center",
		},

		// D4: Inverter position (Y coordinate)
		InverterPositionY: &DecisionVariable{
			Name:         "inverter_position_y_meters",
			VariableType: "CONTINUOUS",
			MinValue:     -10000.0,
			MaxValue:     10000.0,
			DefaultValue: 0.0,
			Unit:         "meters",
			Description:  "Northing offset from site center",
		},

		// D4: Inverter position (Z coordinate, elevation)
		InverterPositionZ: &DecisionVariable{
			Name:         "inverter_position_z_meters",
			VariableType: "CONTINUOUS",
			MinValue:     0.0,
			MaxValue:     5000.0,
			DefaultValue: 0.0,
			Unit:         "meters",
			Description:  "Elevation above MSL",
		},

		// D5: Inverter asset selection (index into available inverter list)
		InverterAssetIndex: &DecisionVariable{
			Name:         "inverter_asset_index",
			VariableType: "INTEGER",
			MinValue:     0.0,
			MaxValue:     100.0, // Assume max 100 inverter SKU options
			DefaultValue: 0.0,
			Unit:         "index",
			Description:  "Index into available inverter asset catalog",
		},

		// D6: Transformer asset selection
		TransformerAssetIndex: &DecisionVariable{
			Name:         "transformer_asset_index",
			VariableType: "INTEGER",
			MinValue:     0.0,
			MaxValue:     50.0, // Assume max 50 transformer SKU options
			DefaultValue: 0.0,
			Unit:         "index",
			Description:  "Index into available transformer asset catalog",
		},

		// D7: String formation strategy
		StringFormationMode: "heuristic_balanced", // Default

		// D8: Cable routing strategy
		CableRoutingMode: "follow_roads", // Default
	}
}

// ========== Hard Constraints (C1–C12) ==========

// HardConstraint represents an absolute requirement (infeasible if violated).
type HardConstraint struct {
	ConstraintID string                              // Unique identifier (e.g., "C1_BoundaryContainment")
	Name         string                              // Human-readable name
	Description  string                              // What this constraint enforces
	Validator    func(*CandidateArtifactGraph) error // Function to check constraint
}

// HardConstraintSet contains all hard constraints.
type HardConstraintSet struct {
	// C1: Boundary Containment
	BoundaryContainment *HardConstraint

	// C2: Constraint Zone Avoidance
	ConstraintZoneAvoidance *HardConstraint

	// C3: Electrical Voltage Limits
	VoltageConstraint *HardConstraint

	// C4: MPPT Panel Limit
	MpptPanelLimit *HardConstraint

	// C5: Inverter DC/AC Ratio
	DcAcRatioBounds *HardConstraint

	// C6: Transformer Capacity
	TransformerCapacity *HardConstraint

	// C7: Slope Limit for Equipment
	SlopeLimit *HardConstraint

	// C8: Cable Conductor Sizing
	CableAmpacity *HardConstraint

	// C9: Voltage Drop Limit
	VoltageDropLimit *HardConstraint

	// C10: Road Proximity
	RoadProximity *HardConstraint

	// C11: No Orphan Panels
	NoOrphanPanels *HardConstraint

	// C12: Topology Connectivity
	TopologyConnectivity *HardConstraint

	AllConstraints []*HardConstraint // Ordered list for iteration
}

// NewHardConstraintSet creates a complete set of hard constraints with validators.
func NewHardConstraintSet() *HardConstraintSet {
	cs := &HardConstraintSet{}

	// C1: Boundary Containment
	// (NOTE: Requires project boundary, validated externally)
	cs.BoundaryContainment = &HardConstraint{
		ConstraintID: "C1_BoundaryContainment",
		Name:         "Boundary Containment",
		Description:  "All panels must be strictly inside project boundary",
		Validator: func(g *CandidateArtifactGraph) error {
			// External validation required (needs project geometry)
			// Placeholder: always pass in unit tests
			return nil
		},
	}

	// C2: Constraint Zone Avoidance
	// (NOTE: Requires zone data, validated externally)
	cs.ConstraintZoneAvoidance = &HardConstraint{
		ConstraintID: "C2_ZoneAvoidance",
		Name:         "Constraint Zone Avoidance",
		Description:  "No intersection with exclusion zones or buffer violations",
		Validator: func(g *CandidateArtifactGraph) error {
			// External validation required (needs zone data)
			return nil
		},
	}

	// C3: Electrical Voltage Limits
	cs.VoltageConstraint = &HardConstraint{
		ConstraintID: "C3_VoltageConstraint",
		Name:         "Voltage Limits",
		Description:  "String voltage within inverter MPPT range",
		Validator: func(g *CandidateArtifactGraph) error {
			// Typical range: [200V, 900V]
			minVoltage := 200.0
			maxVoltage := 900.0
			for _, str := range g.PanelStrings {
				if str.StringVoltageVdc < minVoltage || str.StringVoltageVdc > maxVoltage {
					return fmt.Errorf("string %s voltage %.2f V outside [%.2f, %.2f] V",
						str.StringID, str.StringVoltageVdc, minVoltage, maxVoltage)
				}
			}
			return nil
		},
	}

	// C4: MPPT Panel Limit
	cs.MpptPanelLimit = &HardConstraint{
		ConstraintID: "C4_MpptPanelLimit",
		Name:         "MPPT Panel Limit",
		Description:  "Panel count per MPPT ≤ max_strings_per_mppt",
		Validator: func(g *CandidateArtifactGraph) error {
			// Typical limit: 14 strings per MPPT
			maxStringsPerMppt := 14
			mpptCounts := make(map[*InverterGroup]map[int]int) // inverter -> mppt_index -> string_count

			// Count strings per MPPT
			for _, str := range g.PanelStrings {
				for _, inv := range g.InverterGroups {
					for i, sid := range inv.StringIDs {
						if sid == str.StringID && str.MPPTIndex != nil {
							if _, ok := mpptCounts[inv]; !ok {
								mpptCounts[inv] = make(map[int]int)
							}
							mpptCounts[inv][*str.MPPTIndex]++
						}
					}
				}
			}

			// Validate limits
			for inv, mppts := range mpptCounts {
				for mpptIdx, count := range mppts {
					if count > maxStringsPerMppt {
						return fmt.Errorf("inverter %s MPPT %d has %d strings, max %d",
							inv.InverterGroupID, mpptIdx, count, maxStringsPerMppt)
					}
				}
			}
			return nil
		},
	}

	// C5: DC/AC Ratio Bounds [1.1, 1.5]
	cs.DcAcRatioBounds = &HardConstraint{
		ConstraintID: "C5_DcAcRatioBounds",
		Name:         "DC/AC Ratio Bounds",
		Description:  "DC/AC ratio in range [1.1, 1.5]",
		Validator: func(g *CandidateArtifactGraph) error {
			minRatio := 1.1
			maxRatio := 1.5
			for _, inv := range g.InverterGroups {
				if inv.DcAcRatio < minRatio || inv.DcAcRatio > maxRatio {
					return fmt.Errorf("inverter %s DC/AC ratio %.2f outside [%.2f, %.2f]",
						inv.InverterGroupID, inv.DcAcRatio, minRatio, maxRatio)
				}
			}
			return nil
		},
	}

	// C6: Transformer Capacity (load ≤ rating)
	cs.TransformerCapacity = &HardConstraint{
		ConstraintID: "C6_TransformerCapacity",
		Name:         "Transformer Capacity",
		Description:  "Transformer load ≤ nameplate capacity",
		Validator: func(g *CandidateArtifactGraph) error {
			for _, tx := range g.TransformerNodes {
				if tx.LoadKva > tx.KvaRating {
					return fmt.Errorf("transformer %s load %.2f kVA exceeds rating %.2f kVA",
						tx.TransformerID, tx.LoadKva, tx.KvaRating)
				}
			}
			return nil
		},
	}

	// C7: Slope Limit (requires DEM data)
	cs.SlopeLimit = &HardConstraint{
		ConstraintID: "C7_SlopeLimit",
		Name:         "Slope Limit",
		Description:  "Equipment siting slope ≤ project max",
		Validator: func(g *CandidateArtifactGraph) error {
			// Typical limit: 20% slope
			// Requires external DEM data, validated during synthesis
			return nil
		},
	}

	// C8: Cable Ampacity (requires cable rating tables)
	cs.CableAmpacity = &HardConstraint{
		ConstraintID: "C8_CableAmpacity",
		Name:         "Cable Ampacity",
		Description:  "Cable ampacity ≥ peak current",
		Validator: func(g *CandidateArtifactGraph) error {
			for _, cable := range g.CableCorridors {
				// Placeholder: actual validation requires NEC/IEC ampacity tables
				if cable.CurrentRatingAdc <= 0 {
					return fmt.Errorf("cable %s has invalid current rating", cable.CorridorID)
				}
			}
			return nil
		},
	}

	// C9: Voltage Drop Limit (≤ 3% of line voltage)
	cs.VoltageDropLimit = &HardConstraint{
		ConstraintID: "C9_VoltageDropLimit",
		Name:         "Voltage Drop Limit",
		Description:  "Voltage drop ≤ 3% of line voltage",
		Validator: func(g *CandidateArtifactGraph) error {
			maxDropPercent := 3.0
			// For DC: ~600V typical
			dcLineVoltage := 600.0
			dcMaxDropV := (maxDropPercent / 100.0) * dcLineVoltage

			for _, cable := range g.CableCorridors {
				if cable.CableType == "UG_DC" || cable.CableType == "OH_LV" {
					if cable.VoltageDropV > dcMaxDropV {
						return fmt.Errorf("cable %s voltage drop %.2f V exceeds limit %.2f V (%.1f%% of %f V)",
							cable.CorridorID, cable.VoltageDropV, dcMaxDropV, maxDropPercent, dcLineVoltage)
					}
				}
			}
			return nil
		},
	}

	// C10: Road Proximity
	cs.RoadProximity = &HardConstraint{
		ConstraintID: "C10_RoadProximity",
		Name:         "Road Proximity",
		Description:  "Equipment within max distance to roads",
		Validator: func(g *CandidateArtifactGraph) error {
			// Requires infrastructure layer, validated externally
			return nil
		},
	}

	// C11: No Orphan Panels
	cs.NoOrphanPanels = &HardConstraint{
		ConstraintID: "C11_NoOrphanPanels",
		Name:         "No Orphan Panels",
		Description:  "Every panel assigned to exactly one string",
		Validator: func(g *CandidateArtifactGraph) error {
			panelToStringCount := make(map[string]int)
			for _, str := range g.PanelStrings {
				for _, panelID := range str.PanelIDs {
					panelToStringCount[panelID]++
				}
			}

			for _, panel := range g.SolarPanels {
				count := panelToStringCount[panel.PanelID]
				if count != 1 {
					return fmt.Errorf("panel %s assigned to %d strings (expected 1)",
						panel.PanelID, count)
				}
			}
			return nil
		},
	}

	// C12: Topology Connectivity
	cs.TopologyConnectivity = &HardConstraint{
		ConstraintID: "C12_TopologyConnectivity",
		Name:         "Topology Connectivity",
		Description:  "All inverters connected to transformer to grid",
		Validator: func(g *CandidateArtifactGraph) error {
			if len(g.InverterGroups) == 0 {
				return fmt.Errorf("no inverter groups defined")
			}
			if len(g.TransformerNodes) == 0 {
				return fmt.Errorf("no transformer nodes defined")
			}

			// Check each inverter is referenced by transformer
			connectedInverters := make(map[string]bool)
			for _, tx := range g.TransformerNodes {
				for _, invID := range tx.ConnectedInverterGroupIDs {
					connectedInverters[invID] = true
				}
			}

			for _, inv := range g.InverterGroups {
				if !connectedInverters[inv.InverterGroupID] {
					return fmt.Errorf("inverter %s not connected to any transformer",
						inv.InverterGroupID)
				}
			}
			return nil
		},
	}

	// Collect all constraints for iteration
	cs.AllConstraints = []*HardConstraint{
		cs.BoundaryContainment,
		cs.ConstraintZoneAvoidance,
		cs.VoltageConstraint,
		cs.MpptPanelLimit,
		cs.DcAcRatioBounds,
		cs.TransformerCapacity,
		cs.SlopeLimit,
		cs.CableAmpacity,
		cs.VoltageDropLimit,
		cs.RoadProximity,
		cs.NoOrphanPanels,
		cs.TopologyConnectivity,
	}

	return cs
}

// Validate checks all hard constraints against a candidate.
// Returns nil if all pass; error if any constraint violated.
func (cs *HardConstraintSet) Validate(g *CandidateArtifactGraph) error {
	for _, constraint := range cs.AllConstraints {
		if err := constraint.Validator(g); err != nil {
			return fmt.Errorf("constraint %s (%s) violated: %w", constraint.ConstraintID, constraint.Name, err)
		}
	}
	return nil
}

// ========== Soft Constraints (S1–S5) ==========

// SoftConstraint represents a preference that guides ranking (not hard-fail).
type SoftConstraint struct {
	ConstraintID  string
	Name          string
	Description   string
	Weight        float64                               // [0, 1] importance relative to other soft constraints
	Metric        func(*CandidateArtifactGraph) float64 // Compute penalty (0=best)
	BaselineValue float64                               // Reference for normalization
}

// SoftConstraintSet contains all soft preferences.
type SoftConstraintSet struct {
	// S1: Minimize Cable Length
	MinimizeCableLength *SoftConstraint

	// S2: Minimize Voltage Drop
	MinimizeVoltageDrop *SoftConstraint

	// S3: Maximize Panel Utilization
	MaximizePanelUtilization *SoftConstraint

	// S4: Minimize Shading Losses
	MinimizeShading *SoftConstraint

	// S5: Minimize Equipment Count
	MinimizeEquipmentCount *SoftConstraint

	AllConstraints []*SoftConstraint
}

// NewSoftConstraintSet creates a complete set of soft constraints.
func NewSoftConstraintSet(baselineGraph *CandidateArtifactGraph) *SoftConstraintSet {
	cs := &SoftConstraintSet{}

	// S1: Minimize Cable Length
	cs.MinimizeCableLength = &SoftConstraint{
		ConstraintID: "S1_MinimizeCableLength",
		Name:         "Minimize Cable Length",
		Description:  "Prefer shorter cable runs (cost, complexity, losses)",
		Weight:       0.15,
		Metric: func(g *CandidateArtifactGraph) float64 {
			totalCableM := 0.0
			for _, cable := range g.CableCorridors {
				totalCableM += cable.LengthM
			}
			return totalCableM
		},
		BaselineValue: baselineCableLength(baselineGraph),
	}

	// S2: Minimize Voltage Drop
	cs.MinimizeVoltageDrop = &SoftConstraint{
		ConstraintID: "S2_MinimizeVoltageDrop",
		Name:         "Minimize Voltage Drop",
		Description:  "Prefer low voltage drop (efficiency)",
		Weight:       0.10,
		Metric: func(g *CandidateArtifactGraph) float64 {
			maxDrop := 0.0
			for _, cable := range g.CableCorridors {
				if cable.VoltageDropV > maxDrop {
					maxDrop = cable.VoltageDropV
				}
			}
			return maxDrop
		},
		BaselineValue: 50.0, // Reference baseline
	}

	// S3: Maximize Panel Utilization
	cs.MaximizePanelUtilization = &SoftConstraint{
		ConstraintID: "S3_MaximizePanelUtilization",
		Name:         "Panel Utilization",
		Description:  "Prefer higher density layouts",
		Weight:       0.20,
		Metric: func(g *CandidateArtifactGraph) float64 {
			// Penalty = 1.0 - utilization_pct / 100
			// Assume max feasible = 5000 panels (for bounded sites)
			maxFeasible := 5000.0
			utilization := float64(len(g.SolarPanels)) / maxFeasible
			if utilization > 1.0 {
				utilization = 1.0
			}
			return 1.0 - utilization
		},
		BaselineValue: 0.5,
	}

	// S4: Minimize Shading Losses
	cs.MinimizeShading = &SoftConstraint{
		ConstraintID: "S4_MinimizeShading",
		Name:         "Minimize Shading",
		Description:  "Prefer placements with minimal shading",
		Weight:       0.15,
		Metric: func(g *CandidateArtifactGraph) float64 {
			avgShadingFactor := 0.0
			if len(g.SolarPanels) > 0 {
				for _, panel := range g.SolarPanels {
					avgShadingFactor += panel.ShadingFactor
				}
				avgShadingFactor /= float64(len(g.SolarPanels))
			}
			return avgShadingFactor
		},
		BaselineValue: 0.05,
	}

	// S5: Minimize Equipment Count
	cs.MinimizeEquipmentCount = &SoftConstraint{
		ConstraintID: "S5_MinimizeEquipmentCount",
		Name:         "Equipment Count",
		Description:  "Prefer fewer, larger equipment",
		Weight:       0.10,
		Metric: func(g *CandidateArtifactGraph) float64 {
			equipmentCount := float64(len(g.InverterGroups) + len(g.TransformerNodes))
			return equipmentCount
		},
		BaselineValue: 50.0, // Reference baseline
	}

	cs.AllConstraints = []*SoftConstraint{
		cs.MinimizeCableLength,
		cs.MinimizeVoltageDrop,
		cs.MaximizePanelUtilization,
		cs.MinimizeShading,
		cs.MinimizeEquipmentCount,
	}

	return cs
}

// ComputePenalty computes normalized penalty for this soft constraint.
func (sc *SoftConstraint) ComputePenalty(g *CandidateArtifactGraph) float64 {
	metricValue := sc.Metric(g)
	if sc.BaselineValue == 0 {
		return 0 // Avoid division by zero
	}
	normalized := metricValue / sc.BaselineValue
	// Clamp to [0, 1]
	if normalized > 1.0 {
		normalized = 1.0
	}
	if normalized < 0 {
		normalized = 0
	}
	return normalized
}

// ========== Objectives (O1–O4) ==========

// Objective represents a multi-objective goal.
type Objective struct {
	ObjectiveID string
	Name        string
	Description string
	Type        string  // "MAXIMIZE" | "MINIMIZE"
	Weight      float64 // [0, 1]
	TargetValue float64 // Reference value (e.g., capacity target MW)
}

// ObjectiveSet contains all objectives with aggregation method.
type ObjectiveSet struct {
	// O1: Maximize Feasibility
	MaximizeFeasibility *Objective

	// O2: Maximize MW Fit
	MaximizeMwFit *Objective

	// O3: Minimize Cost
	MinimizeCost *Objective

	// O4: Maximize Land Utilization
	MaximizeLandUtilization *Objective

	AllObjectives     []*Objective
	AggregationMethod string // "WEIGHTED_SUM" | "LEXICOGRAPHIC" | "PARETO_FRONTIER"
	ReturnParetoFront bool
}

// NewObjectiveSet creates a complete objectives set.
func NewObjectiveSet(capacityTargetMw float64) *ObjectiveSet {
	os := &ObjectiveSet{
		// O1: Maximize Feasibility (priority: must pass hard constraints)
		MaximizeFeasibility: &Objective{
			ObjectiveID: "O1_MaximizeFeasibility",
			Name:        "Feasibility Score",
			Description: "Maximize candidate feasibility [0, 1]",
			Type:        "MAXIMIZE",
			Weight:      0.30, // Highest priority
			TargetValue: 1.0,
		},

		// O2: Maximize MW Fit (priority: meet capacity goal)
		MaximizeMwFit: &Objective{
			ObjectiveID: "O2_MaximizeMwFit",
			Name:        "MW Fit",
			Description: "Maximize installed DC power",
			Type:        "MAXIMIZE",
			Weight:      0.25, // High priority
			TargetValue: capacityTargetMw,
		},

		// O3: Minimize Cost (priority: project economics)
		MinimizeCost: &Objective{
			ObjectiveID: "O3_MinimizeCost",
			Name:        "Total Cost",
			Description: "Minimize capital expenditure proxy",
			Type:        "MINIMIZE",
			Weight:      0.25,
			TargetValue: 1.0, // Normalized
		},

		// O4: Maximize Land Utilization (priority: environmental)
		MaximizeLandUtilization: &Objective{
			ObjectiveID: "O4_MaximizeLandUtilization",
			Name:        "Land Utilization",
			Description: "Maximize land utilization / minimize GCR",
			Type:        "MAXIMIZE",
			Weight:      0.20, // Lower priority
			TargetValue: 0.35, // Target GCR
		},

		AggregationMethod: "LEXICOGRAPHIC",
		ReturnParetoFront: true,
	}

	os.AllObjectives = []*Objective{
		os.MaximizeFeasibility,
		os.MaximizeMwFit,
		os.MinimizeCost,
		os.MaximizeLandUtilization,
	}

	return os
}

// ========== Lexicographic Priority Ordering ==========

// LexicographicPriority defines the tier-based decision hierarchy.
type LexicographicPriority struct {
	Tier1_Feasibility float64 // Must be > 0
	Tier2_MwFit       float64 // Maximize within feasible set
	Tier3_Cost        float64 // Minimize within top-MW candidates
	Tier4_LandUse     float64 // Secondary preference
	Tier5_Efficiency  float64 // Tertiary preference (cable length, shading)
}

// NewLexicographicPriority creates the default priority ordering.
func NewLexicographicPriority() *LexicographicPriority {
	return &LexicographicPriority{
		Tier1_Feasibility: 0.0,  // Hard floor
		Tier2_MwFit:       0.90, // At least 90% of max MW in set
		Tier3_Cost:        0.5,  // Balanced cost within MW tier
		Tier4_LandUse:     0.3,  // Moderate preference
		Tier5_Efficiency:  0.5,  // Balanced efficiency
	}
}

// ========== Helper Functions ==========

func baselineCableLength(g *CandidateArtifactGraph) float64 {
	if g == nil {
		return 2000.0 // Default reference
	}
	total := 0.0
	for _, cable := range g.CableCorridors {
		total += cable.LengthM
	}
	if total == 0 {
		return 2000.0
	}
	return total
}

// ComputeFeasibilityScore evaluates candidate feasibility [0, 1].
func ComputeFeasibilityScore(g *CandidateArtifactGraph, hardConstraints *HardConstraintSet) float64 {
	// Base: 1.0 (perfect)
	score := 1.0

	// Deduct for constraint violations
	violations := 0
	maxViolations := 5.0

	if err := hardConstraints.Validate(g); err != nil {
		violations++
		score -= (violations / maxViolations) * 0.5 // Deduct up to 50%
	}

	// Clamp to [0, 1]
	if score < 0 {
		score = 0
	}
	return score
}

// ComputeTotalCapacity sums all panel DC ratings.
func ComputeTotalCapacity(g *CandidateArtifactGraph) float64 {
	total := 0.0
	for _, panel := range g.SolarPanels {
		total += panel.MppCapacityKw
	}
	return total / 1000.0 // Convert to MW
}

// ComputeCostProxy estimates cost from equipment count and cable length.
func ComputeCostProxy(g *CandidateArtifactGraph) float64 {
	// Cost = (# inverters * unit_cost_inv) + (# transformers * unit_cost_tx) + (cable_m * cost_per_m)
	// Assuming: inverter = $1000/unit, transformer = $2000/unit, cable = $0.5/meter
	invCost := 1000.0 * float64(len(g.InverterGroups))
	txCost := 2000.0 * float64(len(g.TransformerNodes))
	cableCost := 0.0
	for _, cable := range g.CableCorridors {
		cableCost += cable.LengthM * 0.5
	}
	return (invCost + txCost + cableCost) / 1000000.0 // Normalize to millions USD
}

// ComputeLandUtilization calculates ground coverage ratio.
func ComputeLandUtilization(g *CandidateArtifactGraph, siteBoundaryAreaM2 float64) float64 {
	// GCR = solar_panel_area / site_area
	// Assume typical panel: 2.0m x 1.0m = 2.0 m²
	panelAreaM2 := 2.0 * float64(len(g.SolarPanels))
	if siteBoundaryAreaM2 == 0 {
		return 0 // Undefined
	}
	return panelAreaM2 / siteBoundaryAreaM2
}
