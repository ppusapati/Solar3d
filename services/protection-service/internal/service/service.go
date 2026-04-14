// Package service implements IEC 60909 short-circuit analysis and
// IEC 60255 protective relay calculations for solar plant HV/MV networks.
package service

import (
	"context"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/google/uuid"

	"solar3d/protection-service/internal/domain"
	"solar3d/protection-service/internal/repository"
)

type Service struct {
	repo *repository.Repository
}

func New(repo *repository.Repository) *Service {
	return &Service{repo: repo}
}

// ── Study lifecycle ──────────────────────────────────────────────────────────

func (s *Service) CreateStudy(ctx context.Context, req domain.CreateStudyRequest) (*domain.ProtectionStudy, error) {
	study := &domain.ProtectionStudy{
		ID:                uuid.New(),
		ProjectID:         req.ProjectID,
		Name:              req.Name,
		SystemVoltageKV:   req.SystemVoltageKV,
		SourceImpedancePU: req.SourceImpedancePU,
		MVABase:           req.MVABase,
		CreatedAt:         time.Now().UTC(),
	}
	if err := s.repo.Create(ctx, study); err != nil {
		return nil, fmt.Errorf("creating study: %w", err)
	}
	return study, nil
}

func (s *Service) GetStudy(ctx context.Context, id uuid.UUID) (*domain.ProtectionStudy, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *Service) ListStudies(ctx context.Context, projectID uuid.UUID) ([]domain.ProtectionStudy, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *Service) DeleteStudy(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
}

// ── Short-Circuit (IEC 60909 symmetrical components) ────────────────────────
//
// Three-phase fault (bolted):
//   Z1 = Z_source + Z_cable (magnitude: √(R²+X²))
//   I_f3φ = V_LN / |Z1|   where V_LN = V_LL / √3
//
// Single-line-to-ground (SLG):
//   I_f1φ ≈ 3 × V_LN / (2|Z1| + |Z0|)   (Z2 = Z1 per transposed network)
//
// Reference: IEC 60909-0:2016 §4.3, §4.6

func (s *Service) ComputeShortCircuit(ctx context.Context, req domain.ComputeShortCircuitRequest) (*domain.ComputeShortCircuitResponse, error) {
	sqrt3 := math.Sqrt(3)
	vLN_kV := req.VoltageKV / sqrt3 // line-to-neutral (kV)
	vLN_V := vLN_kV * 1000.0

	rTotal := req.SourceImpedanceOhm + req.CableResistanceOhm
	xTotal := req.CableReactanceOhm
	z1 := math.Sqrt(rTotal*rTotal + xTotal*xTotal)
	if z1 < 1e-9 {
		z1 = 1e-9
	}

	iFault3ph := vLN_V / z1 / 1000.0 // kA

	var slgComputed bool
	var z0, iFaultSLG float64
	if req.IncludeSingleLineToGround {
		slgComputed = true
		z0 = req.ZeroSeqImpedanceOhm
		if z0 < 1e-9 {
			z0 = z1
		}
		iFaultSLG = 3.0 * vLN_V / (2.0*z1 + z0) / 1000.0
	}

	governing := iFault3ph
	if iFaultSLG > governing {
		governing = iFaultSLG
	}

	eq := fmt.Sprintf(
		"|Z1| = √(R(%.4f)²+X(%.4f)²) = %.4f Ω; V_LN = %.2f V; "+
			"I_3ph = V_LN/|Z1| = %.3f kA",
		rTotal, xTotal, z1, vLN_V, iFault3ph)
	if slgComputed {
		eq += fmt.Sprintf("; I_SLG = 3×V_LN/(2|Z1|+|Z0|) = %.3f kA", iFaultSLG)
	}

	return &domain.ComputeShortCircuitResponse{
		StudyID:        req.StudyID,
		VLN_KV:         vLN_kV,
		ZTotalPosSeq:   z1,
		IFault3Ph_KA:   iFault3ph,
		SLGComputed:    slgComputed,
		ZTotalZeroSeq:  z0,
		IFaultSLG_KA:   iFaultSLG,
		GoverningFault: governing,
		Equation:       eq,
	}, nil
}

// ── Earth Fault ──────────────────────────────────────────────────────────────
//
// Solid earthing:   I_ef = V_LN / R_cable
// NGR earthing:     I_ef = V_LN / (R_NGR + R_cable)
// Petersen coil:    I_ef ≈ 0 (resonant, capacitive residual)
// Isolated neutral: I_ef ≈ 0 (capacitive only)
//
// Touch voltage: V_touch = I_ef × R_earth_grid (1 Ω default per IEC 80364)

func (s *Service) ComputeEarthFault(ctx context.Context, req domain.ComputeEarthFaultRequest) (*domain.ComputeEarthFaultResponse, error) {
	vLN_V := req.VoltageKV / math.Sqrt(3) * 1000.0

	var iFaultKA float64
	var eq string

	switch req.EarthingMethod {
	case domain.NeutralEarthingSolid:
		denom := req.CableResistance
		if denom < 1e-9 {
			denom = 1e-9
		}
		iFaultKA = vLN_V / denom / 1000.0
		eq = fmt.Sprintf("I_ef = V_LN(%.2f V) / R_cable(%.4f Ω) = %.3f kA [solid earthing]",
			vLN_V, req.CableResistance, iFaultKA)

	case domain.NeutralEarthingResistance:
		denom := req.NGRResistanceOhm + req.CableResistance
		if denom < 1e-9 {
			denom = 1e-9
		}
		iFaultKA = vLN_V / denom / 1000.0
		eq = fmt.Sprintf("I_ef = V_LN(%.2f V) / (R_NGR(%.2f Ω)+R_cable(%.4f Ω)) = %.3f kA [NGR]",
			vLN_V, req.NGRResistanceOhm, req.CableResistance, iFaultKA)

	case domain.NeutralEarthingPetersen:
		iFaultKA = 0.0
		eq = "I_ef ≈ 0 kA [Petersen coil — resonant neutral, capacitive residual only]"

	case domain.NeutralEarthingIsolated:
		iFaultKA = 0.0
		eq = "I_ef ≈ 0 kA [isolated neutral — transient capacitive; full transient study required]"

	default:
		return nil, fmt.Errorf("unknown earthing method: %d", req.EarthingMethod)
	}

	const earthGridOhm = 1.0 // IEC 80364 default ground grid resistance
	touchV := iFaultKA * 1000.0 * earthGridOhm

	return &domain.ComputeEarthFaultResponse{
		StudyID:             req.StudyID,
		EarthingMethod:      req.EarthingMethod,
		EarthFaultCurrentKA: iFaultKA,
		TouchVoltageV:       touchV,
		Equation:            eq,
	}, nil
}

// ── Relay Selection ──────────────────────────────────────────────────────────
//
// Pickup = 1.2 × I_load (IEC 60255 CTR margin)
// TDS starting point = 0.1

func (s *Service) SelectRelay(ctx context.Context, req domain.SelectRelayRequest) (*domain.SelectRelayResponse, error) {
	char := req.PreferredCharacteristic
	if char == 0 {
		char = domain.RelayCharacteristicSI
	}

	pickup := 1.2 * req.LoadCurrentA
	tds := 0.1

	relayID := fmt.Sprintf("RELAY-%s", req.StudyID.String()[:8])

	rationale := fmt.Sprintf(
		"Pickup = 1.2×I_load(%.2f A) = %.2f A (IEC 60255 CTR margin). "+
			"Characteristic %s selected. Max fault: %.3f kA.",
		req.LoadCurrentA, pickup, char.String(), req.FaultCurrentKA)

	return &domain.SelectRelayResponse{
		StudyID: req.StudyID,
		Relay: domain.RelaySelection{
			RelayID:        relayID,
			MakeModel:      "IEC 60255-151 compliant OCDT relay",
			Characteristic: char,
			PickupCurrentA: pickup,
			TimeDial:       tds,
			Rationale:      rationale,
		},
	}, nil
}

// ── Relay Operating Time (IEC 60255-3) ──────────────────────────────────────
//
//   SI:  t = TDS × 0.14 / (M^0.02 − 1)
//   VI:  t = TDS × 13.5 / (M − 1)
//   EI:  t = TDS × 80   / (M² − 1)
//   DT:  t = TDS (constant time)

func (s *Service) ComputeRelaySettings(ctx context.Context, req domain.ComputeRelaySettingsRequest) (*domain.ComputeRelaySettingsResponse, error) {
	if req.PickupCurrentA <= 0 {
		return nil, fmt.Errorf("pickup_current_a must be > 0")
	}
	m := req.FaultCurrentA / req.PickupCurrentA
	if m <= 1.0 {
		return nil, fmt.Errorf("fault current must exceed pickup (M=%.3f ≤ 1.0)", m)
	}

	var t float64
	var eq string

	switch req.Characteristic {
	case domain.RelayCharacteristicSI:
		t = req.TimeDial * 0.14 / (math.Pow(m, 0.02) - 1)
		eq = fmt.Sprintf("t = TDS(%.3f)×0.14/(M(%.3f)^0.02−1) = %.3f s [SI]", req.TimeDial, m, t)
	case domain.RelayCharacteristicVI:
		t = req.TimeDial * 13.5 / (m - 1)
		eq = fmt.Sprintf("t = TDS(%.3f)×13.5/(M(%.3f)−1) = %.3f s [VI]", req.TimeDial, m, t)
	case domain.RelayCharacteristicEI:
		t = req.TimeDial * 80 / (m*m - 1)
		eq = fmt.Sprintf("t = TDS(%.3f)×80/(M(%.3f)²−1) = %.3f s [EI]", req.TimeDial, m, t)
	case domain.RelayCharacteristicDT:
		t = req.TimeDial
		eq = fmt.Sprintf("t = TDS = %.3f s [Definite Time]", t)
	default:
		return nil, fmt.Errorf("unknown relay characteristic: %d", req.Characteristic)
	}

	return &domain.ComputeRelaySettingsResponse{
		StudyID:        req.StudyID,
		Multiplier:     m,
		OperatingTime:  t,
		Characteristic: req.Characteristic,
		Equation:       eq,
	}, nil
}

// ── Coordination Validation ──────────────────────────────────────────────────
//
// IEC 60255-3 §8.2: minimum coordination margin = 0.3 s (default).

func (s *Service) ValidateCoordination(ctx context.Context, req domain.ValidateCoordinationRequest) (*domain.ValidateCoordinationResponse, error) {
	minMargin := req.MinimumMarginS
	if minMargin <= 0 {
		minMargin = 0.3
	}

	var violations []domain.CoordinationViolation
	for _, pair := range req.Pairs {
		margin := pair.UpstreamTimeS - pair.DownstreamTimeS
		if margin < minMargin {
			violations = append(violations, domain.CoordinationViolation{
				UpstreamRelayID:   pair.UpstreamRelayID,
				DownstreamRelayID: pair.DownstreamRelayID,
				MarginS:           margin,
				MinimumRequiredS:  minMargin,
			})
		}
	}

	return &domain.ValidateCoordinationResponse{
		Valid:      len(violations) == 0,
		Violations: violations,
	}, nil
}

// ── Report ───────────────────────────────────────────────────────────────────

func (s *Service) GenerateProtectionReport(ctx context.Context, studyID uuid.UUID) (string, error) {
	study, err := s.repo.GetByID(ctx, studyID)
	if err != nil {
		return "", fmt.Errorf("loading study: %w", err)
	}

	var b strings.Builder
	b.WriteString("=================================================================\n")
	b.WriteString("             PROTECTION ENGINEERING STUDY REPORT\n")
	b.WriteString("=================================================================\n\n")
	fmt.Fprintf(&b, "Study ID   : %s\n", study.ID)
	fmt.Fprintf(&b, "Project ID : %s\n", study.ProjectID)
	fmt.Fprintf(&b, "Name       : %s\n", study.Name)
	fmt.Fprintf(&b, "Date       : %s\n\n", time.Now().UTC().Format("2006-01-02"))

	b.WriteString("-----------------------------------------------------------------\n")
	b.WriteString("SYSTEM PARAMETERS\n")
	b.WriteString("-----------------------------------------------------------------\n")
	fmt.Fprintf(&b, "Nominal System Voltage : %.3f kV (L-L)\n", study.SystemVoltageKV)
	fmt.Fprintf(&b, "Source Impedance       : %.4f p.u. on %.1f MVA base\n",
		study.SourceImpedancePU, study.MVABase)

	b.WriteString("\n-----------------------------------------------------------------\n")
	b.WriteString("STANDARDS REFERENCES\n")
	b.WriteString("-----------------------------------------------------------------\n")
	b.WriteString("IEC 60909-0:2016      Short-circuit currents in three-phase a.c. systems\n")
	b.WriteString("IEC 60255-151:2009    Inverse time overcurrent protection function\n")
	b.WriteString("IEC 60255-127:2010    Overcurrent protection\n")
	b.WriteString("IEC 80364-4-44        Low-voltage installations — earthing\n\n")

	b.WriteString("NOTE: Run individual /short-circuit, /earth-fault, /relay-settings\n")
	b.WriteString("      and /coordination endpoints for full numerical output.\n")
	b.WriteString("=================================================================\n")

	return b.String(), nil
}
