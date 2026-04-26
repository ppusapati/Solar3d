package service

import (
	"math"
	"testing"

	"p9e.in/samavaya/solar3d/terrain-service/internal/domain"
)

func TestComputeEarthworkVolumesBalanced(t *testing.T) {
	cells := []earthworkCell{
		{X: 0, Y: 0, Elevation: 99},
		{X: 1, Y: 0, Elevation: 101},
		{X: 0, Y: 1, Elevation: 99},
		{X: 1, Y: 1, Elevation: 101},
	}
	result := computeEarthworkVolumes(cells, 100, 1, 0.01, 1.0)

	if math.Abs(result.CutVolumeM3-2) > 1e-9 {
		t.Fatalf("expected cut volume 2, got %f", result.CutVolumeM3)
	}
	if math.Abs(result.FillVolumeM3-2) > 1e-9 {
		t.Fatalf("expected fill volume 2, got %f", result.FillVolumeM3)
	}
	if math.Abs(result.BalancedVolumeRatio-1.0) > 1e-9 {
		t.Fatalf("expected balance ratio 1, got %f", result.BalancedVolumeRatio)
	}
	if result.IncludedCellCount != 4 {
		t.Fatalf("expected 4 included cells, got %d", result.IncludedCellCount)
	}
}

func TestComputeEarthworkVolumesThresholdFiltering(t *testing.T) {
	cells := []earthworkCell{
		{X: 0, Y: 0, Elevation: 100.02},
		{X: 1, Y: 0, Elevation: 99.98},
		{X: 0, Y: 1, Elevation: 101.0},
		{X: 1, Y: 1, Elevation: 99.0},
	}
	result := computeEarthworkVolumes(cells, 100, 4, 0.05, 1.0)

	if result.IncludedCellCount != 2 {
		t.Fatalf("expected 2 included cells after threshold, got %d", result.IncludedCellCount)
	}
	if math.Abs(result.CutVolumeM3-4) > 1e-9 {
		t.Fatalf("expected cut volume 4, got %f", result.CutVolumeM3)
	}
	if math.Abs(result.FillVolumeM3-4) > 1e-9 {
		t.Fatalf("expected fill volume 4, got %f", result.FillVolumeM3)
	}
	if math.Abs(result.AffectedAreaSqm-8) > 1e-9 {
		t.Fatalf("expected affected area 8, got %f", result.AffectedAreaSqm)
	}
}

func TestComputeEarthworkVolumesHaulDistance(t *testing.T) {
	cells := []earthworkCell{
		{X: 0.0, Y: 0.0, Elevation: 101.0},
		{X: 0.001, Y: 0.0, Elevation: 99.0},
	}
	result := computeEarthworkVolumes(cells, 100, 1, 0.01, 1.0)

	if result.HaulDistanceM <= 0 {
		t.Fatalf("expected positive haul distance, got %f", result.HaulDistanceM)
	}
	if result.HaulEffortM3M <= 0 {
		t.Fatalf("expected positive haul effort, got %f", result.HaulEffortM3M)
	}
}

func TestEstimateCellAreaSqm(t *testing.T) {
	bounds := domain.BoundingBox{MinX: 0, MinY: 0, MaxX: 0.01, MaxY: 0.01}
	area := estimateCellAreaSqm(bounds, 10, 10)

	if area <= 0 {
		t.Fatalf("expected positive cell area, got %f", area)
	}

	// At equator, 0.001 deg ~ 111.32m, so a cell is roughly 12,392 sqm.
	if area < 10000 || area > 15000 {
		t.Fatalf("unexpected cell area magnitude: %f", area)
	}
}
