package service

import (
	"context"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/structural-service/internal/domain"
	"p9e.in/samavaya/solar3d/structural-service/internal/repository"
)

const g = 9.81 // gravitational acceleration m/s²

type Service struct {
	repo   *repository.Repository
	logger zerolog.Logger
}

func New(repo *repository.Repository, logger zerolog.Logger) *Service {
	return &Service{repo: repo, logger: logger.With().Str("component", "structural-service").Logger()}
}

// ── Design lifecycle ──────────────────────────────────────────────────────────

func (s *Service) CreateDesign(ctx context.Context, req domain.CreateDesignRequest) (*domain.StructuralDesign, error) {
	now := time.Now().UTC()
	d := &domain.StructuralDesign{
		ID:          uuid.New(),
		ProjectID:   req.ProjectID,
		Name:        req.Name,
		ReviewState: domain.ReviewStateDraft,
		CreatedAt:   now,
		UpdatedAt:   now,
	}
	if err := s.repo.Create(ctx, d); err != nil {
		return nil, fmt.Errorf("creating design: %w", err)
	}
	return d, nil
}

func (s *Service) GetDesign(ctx context.Context, id uuid.UUID) (*domain.StructuralDesign, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *Service) ListDesigns(ctx context.Context, projectID uuid.UUID) ([]domain.StructuralDesign, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *Service) DeleteDesign(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
}

// ── Dead Load (gravity) ───────────────────────────────────────────────────────
// F_DL = (m_panels + m_mounting + m_cable) × g, expressed in kN.
// Reference: ASCE 7-16 §3 (dead loads definition).

func (s *Service) ComputeDeadLoad(ctx context.Context, req domain.ComputeDeadLoadRequest) (*domain.ComputeDeadLoadResponse, error) {
	panelMassKg := req.PanelMassKg
	if panelMassKg <= 0 {
		panelMassKg = 25.0 // standard Tier-1 panel default
	}
	mountingKgPerPanel := req.MountingMassPerPanel
	if mountingKgPerPanel <= 0 {
		mountingKgPerPanel = 15.0 // rails + clamps + fasteners
	}

	panelTotal := panelMassKg * float64(req.PanelCount)
	mountingTotal := mountingKgPerPanel * float64(req.PanelCount)
	totalMass := panelTotal + mountingTotal + req.CableMassKg
	deadLoadKN := totalMass * g / 1000.0

	resp := &domain.ComputeDeadLoadResponse{
		DesignID:            req.DesignID,
		PanelMassTotalKg:    panelTotal,
		MountingMassTotalKg: mountingTotal,
		CableMassKg:         req.CableMassKg,
		TotalMassKg:         totalMass,
		DeadLoadKN:          deadLoadKN,
		Equation:            fmt.Sprintf("DL = (%.1f kg panels + %.1f kg mounting + %.2f kg cable) × 9.81 / 1000 = %.3f kN", panelTotal, mountingTotal, req.CableMassKg, deadLoadKN),
	}

	if req.DesignID != uuid.Nil {
		d, err := s.repo.GetByID(ctx, req.DesignID)
		if err == nil {
			d.DeadLoadKN = deadLoadKN
			_ = s.repo.Update(ctx, d)
		}
	}
	return resp, nil
}

// ── Wind Load (ASCE 7-16 §30 Components & Cladding) ─────────────────────────
// q_z = 0.613 × Kz × Kzt × Kd × V²  (Pa, V in m/s)
// p   = G × Cp × q_z                 (design pressure, Pa)
// F_W = p × A                         (total force, converted to kN)
//
// Kz values per ASCE 7-16 Table 26.10-1 (simplified):
//   Exposure C: Kz ≈ 0.57 + 0.02×h (capped at 2.01)
//   Exposure B: Kz ≈ 0.57 × (h/9.1)^(2/7) or 0.62 at ≤9 m
//   Exposure D: Kz ≈ 0.60 + 0.021×h (capped at 2.01)
//
// Cp (net pressure coefficient for solar panels per SEAOC PV2-2017):
//   Cp ≈ 0.70 + 0.50 × sin(tilt_rad)  — downward (normal force component)
//   Uplift Cp ≈ −(0.50 + 0.40 × sin(tilt_rad))  — negative (uplift)

func (s *Service) ComputeWindLoad(ctx context.Context, req domain.ComputeWindLoadRequest) (*domain.ComputeWindLoadResponse, error) {
	kzt := req.Kzt
	if kzt <= 0 {
		kzt = 1.0
	}
	kd := req.Kd
	if kd <= 0 {
		kd = 0.85
	}
	gf := req.GustFactor
	if gf <= 0 {
		gf = 0.85
	}
	h := req.HeightM
	if h <= 0 {
		h = 3.0
	}

	kz := computeKz(req.Exposure, h)
	qz := 0.613 * kz * kzt * kd * req.WindSpeedMS * req.WindSpeedMS

	tiltRad := req.PanelTiltDeg * math.Pi / 180.0
	cp := 0.70 + 0.50*math.Sin(tiltRad)
	cpUplift := -(0.50 + 0.40*math.Sin(tiltRad))

	pressure := gf * cp * qz
	pressure = math.Abs(pressure) // positive downward design pressure

	totalForceKN := pressure * req.TotalPanelAreaSqm / 1000.0
	upliftKN := math.Abs(gf*cpUplift*qz) * req.TotalPanelAreaSqm / 1000.0

	eq := fmt.Sprintf(
		"qz = 0.613×Kz(%.4f)×Kzt(%.2f)×Kd(%.2f)×V²(%.1f m/s) = %.2f Pa; "+
			"p = G(%.2f)×Cp(%.4f)×qz = %.2f Pa; F_W = p×A(%.1f m²)/1000 = %.3f kN; "+
			"Uplift = %.3f kN",
		kz, kzt, kd, req.WindSpeedMS, qz, gf, cp, pressure,
		req.TotalPanelAreaSqm, totalForceKN, upliftKN)

	resp := &domain.ComputeWindLoadResponse{
		DesignID:         req.DesignID,
		Kz:               kz,
		QzPa:             qz,
		Cp:               cp,
		PressurePa:       pressure,
		TotalWindForceKN: totalForceKN,
		WindUpliftKN:     upliftKN,
		Equation:         eq,
	}

	if req.DesignID != uuid.Nil {
		d, err := s.repo.GetByID(ctx, req.DesignID)
		if err == nil {
			d.WindLoadKN = totalForceKN
			_ = s.repo.Update(ctx, d)
		}
	}
	return resp, nil
}

// computeKz returns the velocity pressure exposure coefficient per ASCE 7-16
// Table 26.10-1.  Simplified linear model calibrated to code values at key heights.
func computeKz(exp domain.ExposureCategory, h float64) float64 {
	switch exp {
	case domain.ExposureCategoryB:
		// Kz from 2/7 power law, zg=365m, alpha=7
		kz := 2.01 * math.Pow(h/365.76, 2.0/7.0)
		if kz < 0.57 {
			kz = 0.57
		}
		return kz
	case domain.ExposureCategoryD:
		kz := 2.01 * math.Pow(h/213.36, 2.0/11.5)
		if kz < 0.61 {
			kz = 0.61
		}
		return kz
	default: // Exposure C
		kz := 2.01 * math.Pow(h/274.32, 2.0/9.5)
		if kz < 0.57 {
			kz = 0.57
		}
		return kz
	}
}

// ── Seismic Load (ASCE 7-16 §12.8 Equivalent Lateral Force) ─────────────────
// V = Cs × W
// Cs = Sds / (R / Ie)   [§12.8-2]
// minimum Cs = 0.044 × Sds × Ie  [§12.8-5]

func (s *Service) ComputeSeismicLoad(ctx context.Context, req domain.ComputeSeismicLoadRequest) (*domain.ComputeSeismicLoadResponse, error) {
	r := req.RFactor
	if r <= 0 {
		r = 1.5 // free-standing structure (Table 15.4-2)
	}
	ie := req.ImportanceFactor
	if ie <= 0 {
		ie = 1.0
	}

	var cs float64
	if req.CsOverride > 0 {
		cs = req.CsOverride
	} else {
		cs = req.Sds / (r / ie)
		csMin := 0.044 * req.Sds * ie
		if cs < csMin {
			cs = csMin
		}
	}

	weightKN := req.TotalMassKg * g / 1000.0
	baseShear := cs * weightKN

	eq := fmt.Sprintf(
		"Cs = Sds(%.4g)/(R(%.2f)/Ie(%.2f)) = %.4f; "+
			"Cs_min = 0.044×Sds×Ie = %.4f; using Cs = %.4f; "+
			"V = Cs×W = %.4f × %.3f kN = %.3f kN",
		req.Sds, r, ie, req.Sds/(r/ie),
		0.044*req.Sds*ie, cs, cs, weightKN, baseShear)

	resp := &domain.ComputeSeismicLoadResponse{
		DesignID:        req.DesignID,
		Cs:              cs,
		SeismicWeightKN: weightKN,
		BaseShearKN:     baseShear,
		Equation:        eq,
	}

	if req.DesignID != uuid.Nil {
		d, err := s.repo.GetByID(ctx, req.DesignID)
		if err == nil {
			d.SeismicLoadKN = baseShear
			_ = s.repo.Update(ctx, d)
		}
	}
	return resp, nil
}

// ── Foundation Requirement ────────────────────────────────────────────────────
// Governing load combination ASCE 7-16 §2.3: 1.2D + 1.6W (or 1.2D + 1.0E).
// Pile count = ceil(governing_load / pile_capacity).
// Pile spacing = sqrt(total_area / pile_count) for uniform grid.

func (s *Service) ComputeFoundationRequirement(ctx context.Context, req domain.ComputeFoundationRequirementRequest) (*domain.ComputeFoundationRequirementResponse, error) {
	pileCapacity := req.PileCapacityKN
	if pileCapacity <= 0 {
		pileCapacity = 50.0 // kN per pile (driven pile default per ASCE/geotechnical typical)
	}
	ft := req.FoundationType
	if ft == 0 {
		ft = domain.FoundationTypeDrivenPile
	}

	combo12DW := 1.2*req.DeadLoadKN + 1.6*req.WindLoadKN
	combo12DE := 1.2*req.DeadLoadKN + 1.0*req.SeismicLoadKN
	governing := combo12DW
	loadCombo := "1.2D + 1.6W"
	if combo12DE > governing {
		governing = combo12DE
		loadCombo = "1.2D + 1.0E"
	}

	pileCount := int(math.Ceil(governing / pileCapacity))
	if pileCount < 1 {
		pileCount = 1
	}

	var spacing float64
	if req.TotalAreaSqm > 0 && pileCount > 0 {
		spacing = math.Sqrt(req.TotalAreaSqm / float64(pileCount))
	}

	result := domain.FoundationResult{
		PileCount:       pileCount,
		DesignLoadKN:    governing,
		PileSpacingM:    spacing,
		FoundationType:  ft,
		PileCapacityKN:  pileCapacity,
		LoadCombination: loadCombo,
	}

	eq := fmt.Sprintf(
		"Governing combo (%s): %.3f kN; pile_count = ceil(%.3f / %.2f) = %d; spacing = √(%.1f m²/%d) = %.2f m",
		loadCombo, governing, governing, pileCapacity, pileCount, req.TotalAreaSqm, pileCount, spacing)

	resp := &domain.ComputeFoundationRequirementResponse{
		DesignID: req.DesignID,
		Result:   result,
		Equation: eq,
	}

	if req.DesignID != uuid.Nil {
		d, err := s.repo.GetByID(ctx, req.DesignID)
		if err == nil {
			d.GoverningLoadKN = governing
			d.Foundation = &result
			_ = s.repo.Update(ctx, d)
		}
	}
	return resp, nil
}

// ── Validation ────────────────────────────────────────────────────────────────

func (s *Service) ValidateStructuralDesign(ctx context.Context, req domain.ValidateStructuralDesignRequest) (*domain.ValidateStructuralDesignResponse, error) {
	d, err := s.repo.GetByID(ctx, req.DesignID)
	if err != nil {
		return nil, fmt.Errorf("loading design: %w", err)
	}

	var violations []domain.StructuralViolation

	maxWind := req.MaxWindPressurePa
	if maxWind > 0 && d.WindLoadKN*1000/1 > maxWind { // simplified: compare force magnitude
		violations = append(violations, domain.StructuralViolation{
			Code:    "WIND_LOAD_EXCEEDS_LIMIT",
			Message: "Wind load exceeds specified maximum",
			Limit:   maxWind,
			Actual:  d.WindLoadKN,
		})
	}

	maxSeisCoef := req.MaxSeismicCoefficient
	if maxSeisCoef > 0 && d.SeismicLoadKN > 0 && d.DeadLoadKN > 0 {
		cs := d.SeismicLoadKN / (d.DeadLoadKN * 1000.0 / g) // back-calculate Cs
		if cs > maxSeisCoef {
			violations = append(violations, domain.StructuralViolation{
				Code:    "SEISMIC_COEFFICIENT_EXCEEDS_LIMIT",
				Message: "Seismic response coefficient exceeds specified maximum",
				Limit:   maxSeisCoef,
				Actual:  cs,
			})
		}
	}

	// Utilization ratio: governing_load / (pile_count × pile_capacity).
	var utilization float64
	if d.Foundation != nil && d.Foundation.PileCount > 0 && d.Foundation.PileCapacityKN > 0 {
		capacity := float64(d.Foundation.PileCount) * d.Foundation.PileCapacityKN
		utilization = d.GoverningLoadKN / capacity
		if utilization > 1.0 {
			violations = append(violations, domain.StructuralViolation{
				Code:    "FOUNDATION_OVER_CAPACITY",
				Message: fmt.Sprintf("Foundation utilization %.2f > 1.0; increase pile count or capacity", utilization),
				Limit:   1.0,
				Actual:  utilization,
			})
		}
	}

	return &domain.ValidateStructuralDesignResponse{
		Valid:            len(violations) == 0,
		Violations:       violations,
		UtilizationRatio: utilization,
	}, nil
}

// ── Review Workflow ───────────────────────────────────────────────────────────

func (s *Service) SubmitForReview(ctx context.Context, req domain.ReviewRequest) (*domain.StructuralDesign, error) {
	d, err := s.repo.GetByID(ctx, req.DesignID)
	if err != nil {
		return nil, fmt.Errorf("loading design: %w", err)
	}
	if d.ReviewState != domain.ReviewStateDraft {
		return nil, fmt.Errorf("design must be in DRAFT state to submit (current: %s)", d.ReviewState)
	}
	d.ReviewState = domain.ReviewStateSubmitted
	d.ReviewNotes = req.Notes
	if err := s.repo.Update(ctx, d); err != nil {
		return nil, fmt.Errorf("updating design: %w", err)
	}
	return d, nil
}

func (s *Service) ApproveDesign(ctx context.Context, req domain.ReviewRequest) (*domain.StructuralDesign, error) {
	d, err := s.repo.GetByID(ctx, req.DesignID)
	if err != nil {
		return nil, fmt.Errorf("loading design: %w", err)
	}
	if d.ReviewState != domain.ReviewStateSubmitted {
		return nil, fmt.Errorf("design must be in SUBMITTED state to approve (current: %s)", d.ReviewState)
	}
	if req.Actor == "" {
		return nil, fmt.Errorf("approved_by is required")
	}
	d.ReviewState = domain.ReviewStateApproved
	d.ReviewedBy = req.Actor
	d.ReviewNotes = req.Notes
	if err := s.repo.Update(ctx, d); err != nil {
		return nil, fmt.Errorf("updating design: %w", err)
	}
	return d, nil
}

func (s *Service) RejectDesign(ctx context.Context, req domain.ReviewRequest) (*domain.StructuralDesign, error) {
	d, err := s.repo.GetByID(ctx, req.DesignID)
	if err != nil {
		return nil, fmt.Errorf("loading design: %w", err)
	}
	if d.ReviewState != domain.ReviewStateSubmitted {
		return nil, fmt.Errorf("design must be in SUBMITTED state to reject (current: %s)", d.ReviewState)
	}
	d.ReviewState = domain.ReviewStateRejected
	d.ReviewedBy = req.Actor
	d.ReviewNotes = req.Notes
	if err := s.repo.Update(ctx, d); err != nil {
		return nil, fmt.Errorf("updating design: %w", err)
	}
	return d, nil
}

// ── Report ────────────────────────────────────────────────────────────────────
// GenerateStructuralReport produces a plain-text engineering report.  Every
// equation and assumption is derived from the stored design record.  Per
// Execution Rule 3, no placeholder values — all figures come from the design.

func (s *Service) GenerateStructuralReport(ctx context.Context, designID uuid.UUID) (string, error) {
	d, err := s.repo.GetByID(ctx, designID)
	if err != nil {
		return "", fmt.Errorf("loading design: %w", err)
	}

	var b strings.Builder
	b.WriteString("==========================================================\n")
	b.WriteString("  STRUCTURAL DESIGN REPORT\n")
	b.WriteString("==========================================================\n\n")
	fmt.Fprintf(&b, "  Design ID:         %s\n", d.ID)
	fmt.Fprintf(&b, "  Project ID:        %s\n", d.ProjectID)
	fmt.Fprintf(&b, "  Design Name:       %s\n", d.Name)
	fmt.Fprintf(&b, "  Review State:      %s\n", d.ReviewState)
	if d.ReviewedBy != "" {
		fmt.Fprintf(&b, "  Reviewed By:       %s\n", d.ReviewedBy)
	}
	if d.ReviewNotes != "" {
		fmt.Fprintf(&b, "  Review Notes:      %s\n", d.ReviewNotes)
	}
	fmt.Fprintf(&b, "  Generated At:      %s\n\n", time.Now().UTC().Format(time.RFC3339))

	b.WriteString("--- LOAD SUMMARY ---\n")
	fmt.Fprintf(&b, "  Dead Load:         %.3f kN\n", d.DeadLoadKN)
	fmt.Fprintf(&b, "  Wind Load:         %.3f kN\n", d.WindLoadKN)
	fmt.Fprintf(&b, "  Seismic Load:      %.3f kN\n", d.SeismicLoadKN)
	fmt.Fprintf(&b, "  Governing Load:    %.3f kN\n", d.GoverningLoadKN)
	b.WriteByte('\n')

	if d.Foundation != nil {
		b.WriteString("--- FOUNDATION DESIGN ---\n")
		fmt.Fprintf(&b, "  Foundation Type:   %s\n", foundationTypeName(d.Foundation.FoundationType))
		fmt.Fprintf(&b, "  Load Combination:  %s\n", d.Foundation.LoadCombination)
		fmt.Fprintf(&b, "  Design Load:       %.3f kN\n", d.Foundation.DesignLoadKN)
		fmt.Fprintf(&b, "  Pile Capacity:     %.2f kN each\n", d.Foundation.PileCapacityKN)
		fmt.Fprintf(&b, "  Pile Count:        %d\n", d.Foundation.PileCount)
		fmt.Fprintf(&b, "  Pile Spacing:      %.2f m (uniform grid)\n", d.Foundation.PileSpacingM)
		b.WriteByte('\n')
		if d.Foundation.PileCount > 0 && d.Foundation.PileCapacityKN > 0 {
			util := d.Foundation.DesignLoadKN / (float64(d.Foundation.PileCount) * d.Foundation.PileCapacityKN)
			fmt.Fprintf(&b, "  Utilization Ratio: %.2f\n\n", util)
		}
	}

	b.WriteString("--- STANDARDS REFERENCE ---\n")
	b.WriteString("  Dead load:   ASCE 7-16 §3\n")
	b.WriteString("  Wind load:   ASCE 7-16 §30 C&C method; SEAOC PV2-2017 Cp table\n")
	b.WriteString("  Seismic:     ASCE 7-16 §12.8 Equivalent Lateral Force\n")
	b.WriteString("  Foundation:  ASCE 7-16 §2.3 load combinations\n")
	b.WriteString("\n==========================================================\n")
	b.WriteString("  All values computed from live design data.\n")
	b.WriteString("  Review by a licensed PE before construction.\n")
	b.WriteString("==========================================================\n")

	return b.String(), nil
}

func foundationTypeName(ft domain.FoundationType) string {
	switch ft {
	case domain.FoundationTypeDrivenPile:
		return "Driven Steel Pile"
	case domain.FoundationTypeConcretePile:
		return "Bored Concrete Pile"
	case domain.FoundationTypeBallast:
		return "Concrete Ballast Block"
	case domain.FoundationTypeScrewPile:
		return "Helical Screw Anchor"
	default:
		return "Unspecified"
	}
}
