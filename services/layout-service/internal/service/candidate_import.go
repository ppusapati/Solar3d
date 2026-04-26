package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"sort"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"p9e.in/samavaya/solar3d/layout-service/internal/domain"
	"p9e.in/samavaya/solar3d/layout-service/internal/repository"
)

const defaultPanelPowerKW = 0.55

// ImportCandidateArtifacts materializes a frozen CandidateArtifactGraph into the
// layout-service panel/tile tables and links the layout to the selected candidate.
func (s *Service) ImportCandidateArtifacts(ctx context.Context, layoutID, candidateID uuid.UUID) (*domain.CandidateImportResult, error) {
	if layoutID == uuid.Nil {
		return nil, fmt.Errorf("layout_id is required")
	}
	if candidateID == uuid.Nil {
		return nil, fmt.Errorf("candidate_id is required")
	}

	layout, err := s.repo.GetLayout(ctx, layoutID)
	if err != nil {
		return nil, fmt.Errorf("load layout: %w", err)
	}

	payload, err := s.repo.GetCandidateImportPayload(ctx, candidateID)
	if err != nil {
		return nil, err
	}
	if payload.ProjectID != layout.ProjectID {
		return nil, domain.ErrCandidateProjectScope
	}

	tiles, panels, totalCapacityKW, err := buildTilesAndPanelsFromCandidate(payload.Panels, layoutID, s.cfg.TileSize)
	if err != nil {
		return nil, err
	}

	if err := s.repo.DeleteTilesByLayout(ctx, layoutID); err != nil {
		return nil, fmt.Errorf("clear existing layout geometry: %w", err)
	}
	if err := s.repo.BulkInsertTiles(ctx, tiles); err != nil {
		return nil, fmt.Errorf("insert imported tiles: %w", err)
	}
	if err := s.repo.BulkInsertPanels(ctx, panels); err != nil {
		return nil, fmt.Errorf("insert imported panels: %w", err)
	}

	layout.TotalPanels = int64(len(panels))
	layout.TileCount = len(tiles)
	layout.TotalCapacityKW = totalCapacityKW
	layout.CandidateID = &candidateID
	if err := s.repo.UpdateLayout(ctx, layout); err != nil {
		return nil, fmt.Errorf("update layout after candidate import: %w", err)
	}

	log.Info().
		Str("layout_id", layoutID.String()).
		Str("candidate_id", candidateID.String()).
		Int("panels", len(panels)).
		Int("tiles", len(tiles)).
		Float64("capacity_kw", totalCapacityKW).
		Msg("candidate artifact graph imported into layout")

	return &domain.CandidateImportResult{
		LayoutID:              layoutID,
		CandidateID:           candidateID,
		ArtifactGraphLayoutID: payload.ArtifactGraphLayoutID,
		ImportedPanels:        int64(len(panels)),
		ImportedTiles:         len(tiles),
		TotalCapacityKW:       totalCapacityKW,
		SelectionReason:       payload.SelectionReason,
	}, nil
}

type tileBucket struct {
	tile   *domain.LayoutTile
	panels []*domain.Panel
}

func buildTilesAndPanelsFromCandidate(artifacts []repository.CandidatePanelArtifact, layoutID uuid.UUID, tileSize float64) ([]*domain.LayoutTile, []*domain.Panel, float64, error) {
	if len(artifacts) == 0 {
		return nil, nil, 0, domain.ErrCandidateEmpty
	}
	if tileSize <= 0 {
		tileSize = 0.01
	}

	buckets := make(map[string]*tileBucket)
	totalCapacityKW := 0.0

	for _, artifact := range artifacts {
		polygonGeoJSON, bbox, elevation, err := normalizeCandidatePanelGeometry(artifact.Geometry)
		if err != nil {
			return nil, nil, 0, fmt.Errorf("%w: %v", domain.ErrInvalidCandidateGeom, err)
		}

		centerX := (bbox.MinX + bbox.MaxX) / 2
		centerY := (bbox.MinY + bbox.MaxY) / 2
		tileX := int(math.Floor(centerX / tileSize))
		tileY := int(math.Floor(centerY / tileSize))
		key := fmt.Sprintf("%d:%d", tileX, tileY)

		bucket, ok := buckets[key]
		if !ok {
			bucket = &tileBucket{
				tile: &domain.LayoutTile{
					ID:       uuid.New(),
					LayoutID: layoutID,
					BBox: domain.BoundingBox{
						MinX: float64(tileX) * tileSize,
						MinY: float64(tileY) * tileSize,
						MaxX: float64(tileX+1) * tileSize,
						MaxY: float64(tileY+1) * tileSize,
					},
					LODLevel: 0,
				},
			}
			buckets[key] = bucket
		}

		panel := &domain.Panel{
			TileID:          bucket.tile.ID,
			StringID:        artifact.StringID,
			GeometryGeoJSON: polygonGeoJSON,
			Tilt:            artifact.Tilt,
			Azimuth:         artifact.Azimuth,
			Elevation:       elevation,
			Metadata:        artifact.Metadata,
		}
		bucket.panels = append(bucket.panels, panel)

		if artifact.PowerKW > 0 {
			totalCapacityKW += artifact.PowerKW
		} else {
			totalCapacityKW += defaultPanelPowerKW
		}
	}

	keys := make([]string, 0, len(buckets))
	for key := range buckets {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	tiles := make([]*domain.LayoutTile, 0, len(keys))
	panels := make([]*domain.Panel, 0, len(artifacts))
	for _, key := range keys {
		bucket := buckets[key]
		bucket.tile.PanelCount = len(bucket.panels)
		tiles = append(tiles, bucket.tile)
		panels = append(panels, bucket.panels...)
	}

	return tiles, panels, totalCapacityKW, nil
}

func normalizeCandidatePanelGeometry(raw json.RawMessage) (json.RawMessage, domain.BoundingBox, float64, error) {
	var direct struct {
		Type        string          `json:"type"`
		Coordinates json.RawMessage `json:"coordinates"`
	}
	if err := json.Unmarshal(raw, &direct); err == nil && direct.Type == "Polygon" && len(direct.Coordinates) > 0 {
		bbox, elevation, err := polygonBBoxAndElevation(raw)
		if err != nil {
			return nil, domain.BoundingBox{}, 0, err
		}
		return raw, bbox, elevation, nil
	}

	var obj map[string]json.RawMessage
	if err := json.Unmarshal(raw, &obj); err != nil {
		return nil, domain.BoundingBox{}, 0, fmt.Errorf("decode geometry: %w", err)
	}

	if geom, ok := obj["geometry_geom"]; ok {
		trimmed := string(geom)
		if len(trimmed) > 0 && trimmed[0] == '"' {
			var s string
			if err := json.Unmarshal(geom, &s); err != nil {
				return nil, domain.BoundingBox{}, 0, fmt.Errorf("decode geometry_geom string: %w", err)
			}
			geom = json.RawMessage(s)
		}
		bbox, elevation, err := polygonBBoxAndElevation(geom)
		if err != nil {
			return nil, domain.BoundingBox{}, 0, err
		}
		return geom, bbox, elevation, nil
	}

	if vertices, ok := obj["vertices"]; ok {
		polygon, bbox, elevation, err := polygonFromVertices(vertices)
		if err != nil {
			return nil, domain.BoundingBox{}, 0, err
		}
		return polygon, bbox, elevation, nil
	}

	return nil, domain.BoundingBox{}, 0, fmt.Errorf("unsupported candidate panel geometry shape")
}

func polygonBBoxAndElevation(geoJSON json.RawMessage) (domain.BoundingBox, float64, error) {
	var p struct {
		Type        string        `json:"type"`
		Coordinates [][][]float64 `json:"coordinates"`
	}
	if err := json.Unmarshal(geoJSON, &p); err != nil {
		return domain.BoundingBox{}, 0, fmt.Errorf("decode polygon: %w", err)
	}
	if p.Type != "Polygon" || len(p.Coordinates) == 0 || len(p.Coordinates[0]) < 3 {
		return domain.BoundingBox{}, 0, fmt.Errorf("invalid polygon coordinates")
	}

	ring := p.Coordinates[0]
	bbox := domain.BoundingBox{MinX: ring[0][0], MinY: ring[0][1], MaxX: ring[0][0], MaxY: ring[0][1]}
	elevation := 0.0
	elevationCount := 0.0
	for _, point := range ring {
		if len(point) < 2 {
			return domain.BoundingBox{}, 0, fmt.Errorf("polygon point requires lon/lat")
		}
		if point[0] < bbox.MinX {
			bbox.MinX = point[0]
		}
		if point[0] > bbox.MaxX {
			bbox.MaxX = point[0]
		}
		if point[1] < bbox.MinY {
			bbox.MinY = point[1]
		}
		if point[1] > bbox.MaxY {
			bbox.MaxY = point[1]
		}
		if len(point) > 2 {
			elevation += point[2]
			elevationCount++
		}
	}
	if elevationCount > 0 {
		elevation /= elevationCount
	}
	return bbox, elevation, nil
}

func polygonFromVertices(verticesRaw json.RawMessage) (json.RawMessage, domain.BoundingBox, float64, error) {
	var vertices []map[string]float64
	if err := json.Unmarshal(verticesRaw, &vertices); err != nil {
		return nil, domain.BoundingBox{}, 0, fmt.Errorf("decode vertices: %w", err)
	}
	if len(vertices) < 3 {
		return nil, domain.BoundingBox{}, 0, fmt.Errorf("vertices must contain at least 3 points")
	}

	ring := make([][]float64, 0, len(vertices)+1)
	bbox := domain.BoundingBox{}
	elevation := 0.0
	for i, v := range vertices {
		lon, okLon := v["lon"]
		lat, okLat := v["lat"]
		if !okLon || !okLat {
			return nil, domain.BoundingBox{}, 0, fmt.Errorf("vertex missing lon/lat")
		}
		point := []float64{lon, lat}
		if elev, ok := v["elev_m"]; ok {
			point = append(point, elev)
			elevation += elev
		}
		ring = append(ring, point)

		if i == 0 {
			bbox = domain.BoundingBox{MinX: lon, MinY: lat, MaxX: lon, MaxY: lat}
		} else {
			if lon < bbox.MinX {
				bbox.MinX = lon
			}
			if lon > bbox.MaxX {
				bbox.MaxX = lon
			}
			if lat < bbox.MinY {
				bbox.MinY = lat
			}
			if lat > bbox.MaxY {
				bbox.MaxY = lat
			}
		}
	}
	if len(ring) > 0 {
		first := ring[0]
		last := ring[len(ring)-1]
		if len(first) >= 2 && len(last) >= 2 && (first[0] != last[0] || first[1] != last[1]) {
			ring = append(ring, first)
		}
	}

	polygon := map[string]any{
		"type":        "Polygon",
		"coordinates": []any{ring},
	}
	encoded, err := json.Marshal(polygon)
	if err != nil {
		return nil, domain.BoundingBox{}, 0, fmt.Errorf("encode polygon from vertices: %w", err)
	}

	if len(vertices) > 0 {
		elevation /= float64(len(vertices))
	}
	return encoded, bbox, elevation, nil
}
