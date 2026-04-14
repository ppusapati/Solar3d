package service

import (
	"context"
	"math"
	"testing"

	"github.com/rs/zerolog"

	"solar3d/structural-service/internal/domain"
)

func newTestService() *Service {
	return New(nil, zerolog.Nop())
}

func TestComputeDeadLoad_DefaultMasses(t *testing.T) {
	svc := newTestService()
	resp, err := svc.ComputeDeadLoad(context.Background(), domain.ComputeDeadLoadRequest{
		PanelCount:  10,
		CableMassKg: 20,
	})
	if err != nil {
		t.Fatalf("ComputeDeadLoad error: %v", err)
	}

	want := (10*25.0 + 10*15.0 + 20.0) * 9.81 / 1000.0
	if math.Abs(resp.DeadLoadKN-want) > 1e-9 {
		t.Fatalf("dead load mismatch: got %.9f want %.9f", resp.DeadLoadKN, want)
	}
}

func TestComputeWindLoad_ExposureCPositive(t *testing.T) {
	svc := newTestService()
	resp, err := svc.ComputeWindLoad(context.Background(), domain.ComputeWindLoadRequest{
		WindSpeedMS:       35,
		Exposure:          domain.ExposureCategoryC,
		HeightM:           3,
		PanelTiltDeg:      20,
		TotalPanelAreaSqm: 100,
	})
	if err != nil {
		t.Fatalf("ComputeWindLoad error: %v", err)
	}
	if resp.Kz <= 0 || resp.TotalWindForceKN <= 0 {
		t.Fatalf("expected positive wind response, got kz=%.4f force=%.4f", resp.Kz, resp.TotalWindForceKN)
	}
}

func TestComputeSeismicLoad_UsesMinimumCs(t *testing.T) {
	svc := newTestService()
	resp, err := svc.ComputeSeismicLoad(context.Background(), domain.ComputeSeismicLoadRequest{
		Sds:         0.3,
		TotalMassKg: 1000,
		RFactor:     50,
	})
	if err != nil {
		t.Fatalf("ComputeSeismicLoad error: %v", err)
	}
	csMin := 0.044 * 0.3 * 1.0
	if math.Abs(resp.Cs-csMin) > 1e-9 {
		t.Fatalf("expected minimum Cs %.6f, got %.6f", csMin, resp.Cs)
	}
}

func TestComputeFoundationRequirement_GoverningCombo(t *testing.T) {
	svc := newTestService()
	resp, err := svc.ComputeFoundationRequirement(context.Background(), domain.ComputeFoundationRequirementRequest{
		DeadLoadKN:     10,
		WindLoadKN:     20,
		SeismicLoadKN:  50,
		PileCapacityKN: 50,
		TotalAreaSqm:   100,
	})
	if err != nil {
		t.Fatalf("ComputeFoundationRequirement error: %v", err)
	}
	if resp.Result.LoadCombination != "1.2D + 1.0E" {
		t.Fatalf("expected seismic combo to govern, got %s", resp.Result.LoadCombination)
	}
	if resp.Result.PileCount < 1 {
		t.Fatalf("expected pile count >= 1, got %d", resp.Result.PileCount)
	}
}
