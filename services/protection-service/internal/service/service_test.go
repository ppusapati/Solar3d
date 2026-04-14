package service

import (
	"context"
	"math"
	"testing"

	"github.com/google/uuid"

	"solar3d/protection-service/internal/domain"
)

func newSvc() *Service {
	return New(nil)
}

func TestComputeShortCircuit_ThreePhase(t *testing.T) {
	svc := newSvc()
	resp, err := svc.ComputeShortCircuit(context.Background(), domain.ComputeShortCircuitRequest{
		StudyID:            uuid.New(),
		VoltageKV:          11,
		SourceImpedanceOhm: 0.4,
		CableResistanceOhm: 0.1,
		CableReactanceOhm:  0.2,
	})
	if err != nil {
		t.Fatalf("ComputeShortCircuit error: %v", err)
	}
	if resp.IFault3Ph_KA <= 0 {
		t.Fatalf("expected positive I_fault_3ph, got %.6f", resp.IFault3Ph_KA)
	}
}

func TestComputeRelaySettings_SI(t *testing.T) {
	svc := newSvc()
	resp, err := svc.ComputeRelaySettings(context.Background(), domain.ComputeRelaySettingsRequest{
		StudyID:        uuid.New(),
		Characteristic: domain.RelayCharacteristicSI,
		PickupCurrentA: 100,
		TimeDial:       0.1,
		FaultCurrentA:  1000,
	})
	if err != nil {
		t.Fatalf("ComputeRelaySettings error: %v", err)
	}
	m := 1000.0 / 100.0
	want := 0.1 * 0.14 / (math.Pow(m, 0.02) - 1)
	if math.Abs(resp.OperatingTime-want) > 1e-9 {
		t.Fatalf("operating time mismatch: got %.9f want %.9f", resp.OperatingTime, want)
	}
}

func TestValidateCoordination_DefaultMargin(t *testing.T) {
	svc := newSvc()
	resp, err := svc.ValidateCoordination(context.Background(), domain.ValidateCoordinationRequest{
		Pairs: []domain.CoordinationPair{
			{UpstreamRelayID: "R1", DownstreamRelayID: "R2", UpstreamTimeS: 0.5, DownstreamTimeS: 0.3},
		},
	})
	if err != nil {
		t.Fatalf("ValidateCoordination error: %v", err)
	}
	if resp.Valid {
		t.Fatalf("expected invalid coordination due to margin < 0.3 s")
	}
	if len(resp.Violations) != 1 {
		t.Fatalf("expected 1 violation, got %d", len(resp.Violations))
	}
}
