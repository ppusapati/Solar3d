package service

import (
	"encoding/json"
	"errors"
	"testing"

	"github.com/google/uuid"

	"solar3d/layout-service/internal/domain"
	"solar3d/layout-service/internal/repository"
)

func TestNormalizeCandidatePanelGeometry_DirectPolygon(t *testing.T) {
	raw := json.RawMessage(`{"type":"Polygon","coordinates":[[[10,20,5],[11,20,5],[11,21,5],[10,21,5],[10,20,5]]]}`)
	poly, bbox, elev, err := normalizeCandidatePanelGeometry(raw)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(poly) == 0 {
		t.Fatal("expected normalized polygon")
	}
	if bbox.MinX != 10 || bbox.MaxX != 11 || bbox.MinY != 20 || bbox.MaxY != 21 {
		t.Fatalf("unexpected bbox: %+v", bbox)
	}
	if elev != 5 {
		t.Fatalf("expected avg elevation 5, got %f", elev)
	}
}

func TestNormalizeCandidatePanelGeometry_GeometryGeomWrapper(t *testing.T) {
	raw := json.RawMessage(`{"geometry_geom":"{\"type\":\"Polygon\",\"coordinates\":[[[1,2],[2,2],[2,3],[1,3],[1,2]]]}"}`)
	poly, bbox, elev, err := normalizeCandidatePanelGeometry(raw)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(poly) == 0 {
		t.Fatal("expected normalized polygon")
	}
	if bbox.MinX != 1 || bbox.MaxX != 2 || bbox.MinY != 2 || bbox.MaxY != 3 {
		t.Fatalf("unexpected bbox: %+v", bbox)
	}
	if elev != 0 {
		t.Fatalf("expected elevation 0, got %f", elev)
	}
}

func TestBuildTilesAndPanelsFromCandidate_EmptyArtifacts(t *testing.T) {
	_, _, _, err := buildTilesAndPanelsFromCandidate(nil, uuid.New(), 0.01)
	if !errors.Is(err, domain.ErrCandidateEmpty) {
		t.Fatalf("expected ErrCandidateEmpty, got %v", err)
	}
}

func TestBuildTilesAndPanelsFromCandidate_GroupsPanelsAndCapacity(t *testing.T) {
	layoutID := uuid.New()
	artifacts := []repository.CandidatePanelArtifact{
		{
			Geometry: json.RawMessage(`{"type":"Polygon","coordinates":[[[0.0,0.0],[0.004,0.0],[0.004,0.004],[0.0,0.004],[0.0,0.0]]]}`),
			Tilt:     20,
			Azimuth:  180,
			PowerKW:  0.62,
			StringID: "s1",
		},
		{
			Geometry: json.RawMessage(`{"type":"Polygon","coordinates":[[[0.02,0.02],[0.024,0.02],[0.024,0.024],[0.02,0.024],[0.02,0.02]]]}`),
			Tilt:     20,
			Azimuth:  180,
			PowerKW:  0.63,
			StringID: "s2",
		},
	}

	tiles, panels, capacity, err := buildTilesAndPanelsFromCandidate(artifacts, layoutID, 0.01)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(tiles) != 2 {
		t.Fatalf("expected 2 tiles, got %d", len(tiles))
	}
	if len(panels) != 2 {
		t.Fatalf("expected 2 panels, got %d", len(panels))
	}
	if capacity != 1.25 {
		t.Fatalf("expected capacity 1.25, got %.3f", capacity)
	}
	if panels[0].TileID == panels[1].TileID {
		t.Fatal("expected panels in different tiles")
	}
}

func TestBuildTilesAndPanelsFromCandidate_InvalidGeometry(t *testing.T) {
	layoutID := uuid.New()
	artifacts := []repository.CandidatePanelArtifact{{Geometry: json.RawMessage(`{"foo":"bar"}`)}}
	_, _, _, err := buildTilesAndPanelsFromCandidate(artifacts, layoutID, 0.01)
	if err == nil {
		t.Fatal("expected error for invalid geometry")
	}
	if !errors.Is(err, domain.ErrInvalidCandidateGeom) {
		t.Fatalf("expected ErrInvalidCandidateGeom, got %v", err)
	}
}

func TestBuildTilesAndPanelsFromCandidate_PreservesStringAndMetadata_WithPowerFallback(t *testing.T) {
	layoutID := uuid.New()
	artifacts := []repository.CandidatePanelArtifact{
		{
			Geometry: json.RawMessage(`{"type":"Polygon","coordinates":[[[5.0,5.0],[5.004,5.0],[5.004,5.004],[5.0,5.004],[5.0,5.0]]]}`),
			Tilt:     22,
			Azimuth:  175,
			PowerKW:  0, // should fall back to defaultPanelPowerKW
			StringID: "string-a",
			Metadata: json.RawMessage(`{"source":"ml_artifacts","confidence":0.91}`),
		},
	}

	_, panels, capacity, err := buildTilesAndPanelsFromCandidate(artifacts, layoutID, 0.01)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(panels) != 1 {
		t.Fatalf("expected 1 panel, got %d", len(panels))
	}
	if panels[0].StringID != "string-a" {
		t.Fatalf("expected string_id to be preserved, got %q", panels[0].StringID)
	}
	if string(panels[0].Metadata) != `{"source":"ml_artifacts","confidence":0.91}` {
		t.Fatalf("expected metadata to be preserved, got %s", string(panels[0].Metadata))
	}
	if capacity != defaultPanelPowerKW {
		t.Fatalf("expected default fallback capacity %.2f, got %.2f", defaultPanelPowerKW, capacity)
	}
}
