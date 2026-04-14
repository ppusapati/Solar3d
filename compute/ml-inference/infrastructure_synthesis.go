package ml_inference

import (
	"crypto/sha256"
	"fmt"
	"math"
	"time"
)

// SynthesisInput contains deterministic inputs for infrastructure generation.
type SynthesisInput struct {
	ProjectID           string
	LayoutID            string
	Boundary            Geometry
	DEM                 *DEMGrid
	DecisionSpace       *DecisionSpace
	Seed                int64
	TargetInverterCount int
	TargetTxCount       int
}

// DEMGrid is a compact terrain representation used for deterministic slope proxies.
type DEMGrid struct {
	Rows      int
	Cols      int
	CellSizeM float64
	ValuesM   [][]float64
}

// SynthesizeInfrastructure deterministically generates non-panel infrastructure artifacts.
// It returns a candidate artifact graph and validates all configured hard constraints.
func SynthesizeInfrastructure(input *SynthesisInput, constraints *HardConstraintSet) (*CandidateArtifactGraph, error) {
	if input == nil {
		return nil, fmt.Errorf("synthesis input is required")
	}
	if len(input.Boundary.Vertices) < 4 {
		return nil, fmt.Errorf("boundary requires at least 4 vertices")
	}
	if input.ProjectID == "" || input.LayoutID == "" {
		return nil, fmt.Errorf("project_id and layout_id are required")
	}

	inverterCount := input.TargetInverterCount
	if inverterCount <= 0 {
		inverterCount = 2
	}
	txCount := input.TargetTxCount
	if txCount <= 0 {
		txCount = 1
	}

	now := time.Now().UTC()
	center, minLon, maxLon, minLat, maxLat := boundaryStats(input.Boundary)
	spanLon := maxLon - minLon
	spanLat := maxLat - minLat

	infra := &InfrastructureLayout{}

	// Deterministic roads: one east-west trunk and one north-south spine.
	infra.RoadSegments = []*RoadSegment{
		{
			RoadID:   deterministicID("road", input.Seed, input.LayoutID, "primary-ew"),
			RoadType: "primary",
			Path: LineString3D{Vertices: []Point3D{
				{Longitude: minLon + 0.05*spanLon, Latitude: center.Latitude, ElevationM: center.ElevationM},
				{Longitude: maxLon - 0.05*spanLon, Latitude: center.Latitude, ElevationM: center.ElevationM},
			}},
			WidthM:      8,
			CreatedBy:   "deterministic_synthesis",
			CreatedAt:   now,
			Determinism: determinismToken(input.Seed, "road-primary", input.LayoutID),
		},
		{
			RoadID:   deterministicID("road", input.Seed, input.LayoutID, "service-ns"),
			RoadType: "service",
			Path: LineString3D{Vertices: []Point3D{
				{Longitude: center.Longitude, Latitude: minLat + 0.05*spanLat, ElevationM: center.ElevationM},
				{Longitude: center.Longitude, Latitude: maxLat - 0.05*spanLat, ElevationM: center.ElevationM},
			}},
			WidthM:      6,
			CreatedBy:   "deterministic_synthesis",
			CreatedAt:   now,
			Determinism: determinismToken(input.Seed, "road-service", input.LayoutID),
		},
	}

	graph := &CandidateArtifactGraph{
		LayoutID:         input.LayoutID,
		ProjectID:        input.ProjectID,
		Infrastructure:   infra,
		InverterGroups:   make([]*InverterGroup, 0, inverterCount),
		TransformerNodes: make([]*TransformerNode, 0, txCount),
		CableCorridors:   make([]*CableCorridorSegment, 0, inverterCount),
		FaultIdentifiers: make([]*FaultIdentifier, 0, inverterCount),
		CreatedAt:        now,
		Version:          "1.1",
	}

	for i := 0; i < inverterCount; i++ {
		frac := float64(i+1) / float64(inverterCount+1)
		pos := Point3D{
			Longitude: minLon + frac*spanLon,
			Latitude:  center.Latitude - 0.2*spanLat,
			ElevationM: center.ElevationM +
				sampleTerrainSlope(input.DEM, i),
		}

		invZone := createZone(input, now, "inverter", fmt.Sprintf("inv-%d", i), pos, spanLon*0.04, spanLat*0.04, sampleTerrainSlope(input.DEM, i))
		dcZone := createZone(input, now, "dc_equipment", fmt.Sprintf("dc-%d", i), shiftPoint(pos, spanLon*0.01, -spanLat*0.01), spanLon*0.03, spanLat*0.03, sampleTerrainSlope(input.DEM, i+11))
		acZone := createZone(input, now, "ac_equipment", fmt.Sprintf("ac-%d", i), shiftPoint(pos, -spanLon*0.01, spanLat*0.01), spanLon*0.03, spanLat*0.03, sampleTerrainSlope(input.DEM, i+23))

		infra.InverterZones = append(infra.InverterZones, invZone)
		infra.DCEquipmentZones = append(infra.DCEquipmentZones, dcZone)
		infra.ACEquipmentZones = append(infra.ACEquipmentZones, acZone)

		invID := deterministicID("inv", input.Seed, input.LayoutID, fmt.Sprintf("%d", i))
		inv := &InverterGroup{
			InverterGroupID:   invID,
			InverterAssetID:   "asset-inverter-default",
			StringIDs:         []string{},
			StringCount:       0,
			Position:          pos,
			DcInputKw:         1200,
			AcOutputKw:        1000,
			DcAcRatio:         1.2,
			EfficiencyPct:     98,
			FeasibilityStatus: "VALID",
			CreatedBy:         "deterministic_synthesis",
			CreatedAt:         now,
		}
		graph.InverterGroups = append(graph.InverterGroups, inv)

		infra.CableAnchors = append(infra.CableAnchors, &CorridorAnchor{
			AnchorID:     deterministicID("anchor", input.Seed, invID, "pickup"),
			AnchorType:   "inverter_pickup",
			Position:     pos,
			EntityID:     invID,
			CreatedBy:    "deterministic_synthesis",
			CreatedAt:    now,
			Determinism:  determinismToken(input.Seed, "anchor-pickup", invID),
			ElevationMsl: pos.ElevationM,
		})

		infra.FaultMarkerAnchors = append(infra.FaultMarkerAnchors, &FaultMarkerAnchor{
			MarkerID:     deterministicID("fault_anchor", input.Seed, invID, "marker"),
			Position:     shiftPoint(pos, 0, 0.01*spanLat),
			Scope:        "inverter_protection",
			LinkedZoneID: invZone.ZoneID,
			CreatedBy:    "deterministic_synthesis",
			CreatedAt:    now,
			Determinism:  determinismToken(input.Seed, "fault-anchor", invID),
		})
	}

	for i := 0; i < txCount; i++ {
		frac := float64(i+1) / float64(txCount+1)
		pos := Point3D{
			Longitude: minLon + frac*spanLon,
			Latitude:  center.Latitude + 0.25*spanLat,
			ElevationM: center.ElevationM +
				sampleTerrainSlope(input.DEM, 100+i),
		}
		txZone := createZone(input, now, "transformer", fmt.Sprintf("tx-%d", i), pos, spanLon*0.05, spanLat*0.05, sampleTerrainSlope(input.DEM, 100+i))
		infra.TransformerZones = append(infra.TransformerZones, txZone)

		txID := deterministicID("tx", input.Seed, input.LayoutID, fmt.Sprintf("%d", i))
		tx := &TransformerNode{
			TransformerID:             txID,
			TransformerAssetID:        "asset-transformer-default",
			Position:                  pos,
			PrimaryVoltageKv:          33,
			SecondaryVoltageKv:        0.8,
			KvaRating:                 2500,
			ConnectedInverterGroupIDs: []string{},
			LoadKva:                   0,
			LoadUtilizationPct:        0,
			FeasibilityStatus:         "VALID",
			CreatedBy:                 "deterministic_synthesis",
			CreatedAt:                 now,
		}
		graph.TransformerNodes = append(graph.TransformerNodes, tx)

		infra.CableAnchors = append(infra.CableAnchors, &CorridorAnchor{
			AnchorID:     deterministicID("anchor", input.Seed, txID, "hub"),
			AnchorType:   "transformer_hub",
			Position:     pos,
			EntityID:     txID,
			CreatedBy:    "deterministic_synthesis",
			CreatedAt:    now,
			Determinism:  determinismToken(input.Seed, "anchor-hub", txID),
			ElevationMsl: pos.ElevationM,
		})
	}

	if len(graph.TransformerNodes) == 0 {
		return nil, fmt.Errorf("no transformer nodes generated")
	}

	// Deterministic assignment: modulo fanout from inverter groups to transformer nodes.
	for i, inv := range graph.InverterGroups {
		tx := graph.TransformerNodes[i%len(graph.TransformerNodes)]
		tx.ConnectedInverterGroupIDs = append(tx.ConnectedInverterGroupIDs, inv.InverterGroupID)
		tx.LoadKva += inv.AcOutputKw
		tx.LoadUtilizationPct = (tx.LoadKva / tx.KvaRating) * 100

		corridorID := deterministicID("cable", input.Seed, inv.InverterGroupID, tx.TransformerID)
		path := LineString3D{Vertices: []Point3D{
			inv.Position,
			{Longitude: inv.Position.Longitude, Latitude: tx.Position.Latitude, ElevationM: (inv.Position.ElevationM + tx.Position.ElevationM) / 2},
			tx.Position,
		}}
		length := pathLengthMeters(path)

		graph.CableCorridors = append(graph.CableCorridors, &CableCorridorSegment{
			CorridorID:        corridorID,
			Path:              path,
			LengthM:           length,
			HeightProfile:     "hilly",
			CableType:         "UG_AC",
			ConductorCount:    3,
			ConductorSizeMm2:  300,
			SourceLocation:    SourceLocation{LocationType: "inverter_group", EntityID: inv.InverterGroupID},
			TargetLocation:    TargetLocation{LocationType: "transformer", EntityID: &tx.TransformerID},
			CurrentRatingAdc:  900,
			VoltageDropV:      math.Max(1.0, length*0.002),
			FeasibilityStatus: "VALID",
			BomCountM:         length,
			CreatedBy:         "deterministic_synthesis",
			CreatedAt:         now,
		})

		graph.FaultIdentifiers = append(graph.FaultIdentifiers, &FaultIdentifier{
			FaultID:          deterministicID("fault", input.Seed, inv.InverterGroupID, tx.TransformerID),
			Position:         shiftPoint(inv.Position, 0, 0.002*spanLat),
			Scope:            "inverter_protection",
			UpstreamEntities: UpstreamEntities{AffectedInverterIDs: []string{inv.InverterGroupID}, AffectedTransformerIDs: []string{tx.TransformerID}},
			ProtectionType:   "breaker",
			FaultScenario:    "overcurrent",
			DetectionMethod:  "relay",
			IsolationTimeMs:  120,
			CreatedBy:        "deterministic_synthesis",
			CreatedAt:        now,
		})
	}

	if constraints != nil {
		if err := constraints.Validate(graph); err != nil {
			return nil, fmt.Errorf("hard constraints validation failed: %w", err)
		}
	}

	graph.Lineage = &CandidateLineage{
		RootCandidateIDs: []string{},
		OptimizationHistory: []*OptimizationStep{
			{
				RunID:                deterministicID("run", input.Seed, input.ProjectID, input.LayoutID),
				AlgorithmName:        "deterministic_infrastructure_synthesis_v1",
				GenerationCount:      int32(len(graph.InverterGroups) + len(graph.TransformerNodes) + len(graph.CableCorridors)),
				ParetoImprovementPct: 0,
				CompletedAt:          now,
			},
		},
		FinalSelectionReason: "deterministic baseline candidate",
	}
	graph.Lineage.Checksum = graph.ComputeChecksum()

	return graph, nil
}

func createZone(input *SynthesisInput, ts time.Time, zoneType, token string, center Point3D, halfLon, halfLat, slope float64) *EquipmentZone {
	geom := Geometry{
		Vertices: []Point3D{
			{Longitude: center.Longitude - halfLon, Latitude: center.Latitude - halfLat, ElevationM: center.ElevationM},
			{Longitude: center.Longitude + halfLon, Latitude: center.Latitude - halfLat, ElevationM: center.ElevationM},
			{Longitude: center.Longitude + halfLon, Latitude: center.Latitude + halfLat, ElevationM: center.ElevationM},
			{Longitude: center.Longitude - halfLon, Latitude: center.Latitude + halfLat, ElevationM: center.ElevationM},
		},
		ElevationSource: "DEM",
	}
	return &EquipmentZone{
		ZoneID:       deterministicID("zone", input.Seed, zoneType, token),
		ZoneType:     zoneType,
		Boundary:     geom,
		Center:       center,
		AreaM2:       approxPolygonAreaM2(geom),
		CreatedBy:    "deterministic_synthesis",
		CreatedAt:    ts,
		Determinism:  determinismToken(input.Seed, zoneType, token),
		SlopePercent: math.Abs(slope),
	}
}

func boundaryStats(boundary Geometry) (Point3D, float64, float64, float64, float64) {
	minLon, maxLon := boundary.Vertices[0].Longitude, boundary.Vertices[0].Longitude
	minLat, maxLat := boundary.Vertices[0].Latitude, boundary.Vertices[0].Latitude
	totalLon, totalLat, totalEle := 0.0, 0.0, 0.0
	for _, p := range boundary.Vertices {
		if p.Longitude < minLon {
			minLon = p.Longitude
		}
		if p.Longitude > maxLon {
			maxLon = p.Longitude
		}
		if p.Latitude < minLat {
			minLat = p.Latitude
		}
		if p.Latitude > maxLat {
			maxLat = p.Latitude
		}
		totalLon += p.Longitude
		totalLat += p.Latitude
		totalEle += p.ElevationM
	}
	n := float64(len(boundary.Vertices))
	return Point3D{Longitude: totalLon / n, Latitude: totalLat / n, ElevationM: totalEle / n}, minLon, maxLon, minLat, maxLat
}

func shiftPoint(p Point3D, dLon, dLat float64) Point3D {
	return Point3D{Longitude: p.Longitude + dLon, Latitude: p.Latitude + dLat, ElevationM: p.ElevationM}
}

func pathLengthMeters(path LineString3D) float64 {
	if len(path.Vertices) < 2 {
		return 0
	}
	total := 0.0
	for i := 1; i < len(path.Vertices); i++ {
		total += distanceMeters(path.Vertices[i-1], path.Vertices[i])
	}
	return total
}

func distanceMeters(a, b Point3D) float64 {
	latMeters := (b.Latitude - a.Latitude) * 111_320.0
	lonMeters := (b.Longitude - a.Longitude) * 111_320.0 * math.Cos((a.Latitude+b.Latitude)*0.5*math.Pi/180.0)
	dz := b.ElevationM - a.ElevationM
	return math.Sqrt(latMeters*latMeters + lonMeters*lonMeters + dz*dz)
}

func approxPolygonAreaM2(g Geometry) float64 {
	if len(g.Vertices) < 4 {
		return 0
	}
	width := distanceMeters(g.Vertices[0], g.Vertices[1])
	height := distanceMeters(g.Vertices[1], g.Vertices[2])
	return math.Abs(width * height)
}

func sampleTerrainSlope(dem *DEMGrid, idx int) float64 {
	if dem == nil || dem.Rows < 2 || dem.Cols < 2 || len(dem.ValuesM) == 0 {
		return 2.5
	}
	r := idx % (dem.Rows - 1)
	c := idx % (dem.Cols - 1)
	v00 := dem.ValuesM[r][c]
	v01 := dem.ValuesM[r][c+1]
	v10 := dem.ValuesM[r+1][c]
	dx := math.Abs(v01-v00) / math.Max(1.0, dem.CellSizeM)
	dy := math.Abs(v10-v00) / math.Max(1.0, dem.CellSizeM)
	return math.Sqrt(dx*dx+dy*dy) * 100
}

func determinismToken(seed int64, parts ...string) string {
	h := sha256.New()
	fmt.Fprintf(h, "%d", seed)
	for _, p := range parts {
		fmt.Fprintf(h, "|%s", p)
	}
	return fmt.Sprintf("%x", h.Sum(nil))[:16]
}

func deterministicID(prefix string, seed int64, parts ...string) string {
	return fmt.Sprintf("%s-%s", prefix, determinismToken(seed, parts...))
}
