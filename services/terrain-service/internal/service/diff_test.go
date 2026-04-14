package service

import (
	"math"
	"testing"
)

func TestComputeDiffStatsZeroDelta(t *testing.T) {
	// Identical grids → all stats should be zero.
	deltas := []float64{0, 0, 0, 0}
	stats := computeDiffStats(deltas, 100.0)

	if stats.MeanDeltaM != 0 {
		t.Fatalf("expected mean delta 0, got %f", stats.MeanDeltaM)
	}
	if stats.RMSDeltaM != 0 {
		t.Fatalf("expected RMS 0, got %f", stats.RMSDeltaM)
	}
	if stats.MaxAbsDeltaM != 0 {
		t.Fatalf("expected max abs delta 0, got %f", stats.MaxAbsDeltaM)
	}
	if stats.VolumeAddedM3 != 0 || stats.VolumeRemovedM3 != 0 {
		t.Fatalf("expected zero volumes, got added=%f removed=%f", stats.VolumeAddedM3, stats.VolumeRemovedM3)
	}
	if stats.ValidCellCount != 4 {
		t.Fatalf("expected 4 valid cells, got %d", stats.ValidCellCount)
	}
}

func TestComputeDiffStatsUniformPositiveDelta(t *testing.T) {
	// Compare layer is uniformly +5 m above base.
	// 4 cells × 1000 m² = 4000 m³ added, none removed.
	cellArea := 1000.0
	delta := 5.0
	deltas := []float64{delta, delta, delta, delta}
	stats := computeDiffStats(deltas, cellArea)

	if math.Abs(stats.MeanDeltaM-delta) > 1e-9 {
		t.Fatalf("expected mean %f, got %f", delta, stats.MeanDeltaM)
	}
	if math.Abs(stats.RMSDeltaM-delta) > 1e-9 {
		t.Fatalf("expected RMS %f, got %f", delta, stats.RMSDeltaM)
	}
	if math.Abs(stats.MaxAbsDeltaM-delta) > 1e-9 {
		t.Fatalf("expected max abs %f, got %f", delta, stats.MaxAbsDeltaM)
	}
	expected := float64(len(deltas)) * delta * cellArea
	if math.Abs(stats.VolumeAddedM3-expected) > 1e-6 {
		t.Fatalf("expected volume_added %f m³, got %f", expected, stats.VolumeAddedM3)
	}
	if stats.VolumeRemovedM3 != 0 {
		t.Fatalf("expected volume_removed 0, got %f", stats.VolumeRemovedM3)
	}
	if math.Abs(stats.NetVolumeM3-expected) > 1e-6 {
		t.Fatalf("expected net_volume %f, got %f", expected, stats.NetVolumeM3)
	}
}

func TestComputeDiffStatsMixedDeltas(t *testing.T) {
	// Two cells +10 m, two cells -3 m.
	cellArea := 500.0
	deltas := []float64{10, 10, -3, -3}
	stats := computeDiffStats(deltas, cellArea)

	wantAdded := 2 * 10.0 * cellArea
	wantRemoved := 2 * 3.0 * cellArea
	wantNet := wantAdded - wantRemoved
	wantMean := (10 + 10 - 3 - 3) / 4.0

	if math.Abs(stats.VolumeAddedM3-wantAdded) > 1e-6 {
		t.Fatalf("volume_added: want %f got %f", wantAdded, stats.VolumeAddedM3)
	}
	if math.Abs(stats.VolumeRemovedM3-wantRemoved) > 1e-6 {
		t.Fatalf("volume_removed: want %f got %f", wantRemoved, stats.VolumeRemovedM3)
	}
	if math.Abs(stats.NetVolumeM3-wantNet) > 1e-6 {
		t.Fatalf("net_volume: want %f got %f", wantNet, stats.NetVolumeM3)
	}
	if math.Abs(stats.MeanDeltaM-wantMean) > 1e-9 {
		t.Fatalf("mean_delta: want %f got %f", wantMean, stats.MeanDeltaM)
	}
	if math.Abs(stats.MaxAbsDeltaM-10) > 1e-9 {
		t.Fatalf("max_abs_delta: want 10 got %f", stats.MaxAbsDeltaM)
	}
}

func TestComputeDiffStatsOutputLength(t *testing.T) {
	deltas := make([]float64, 6)
	for i := range deltas {
		deltas[i] = float64(i)
	}
	stats := computeDiffStats(deltas, 1.0)
	if stats.ValidCellCount != len(deltas) {
		t.Fatalf("valid_cell_count: want %d got %d", len(deltas), stats.ValidCellCount)
	}
}
