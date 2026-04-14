package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"solar3d/electrical-service/internal/domain"
	"solar3d/electrical-service/internal/repository"
	"solar3d/shared/orchestration"
)

type electricalRepository interface {
	CreateNetwork(ctx context.Context, net *domain.ElectricalNetwork) error
	GetNetworkByID(ctx context.Context, id uuid.UUID) (*domain.ElectricalNetwork, error)
	ListNetworksByProject(ctx context.Context, projectID uuid.UUID) ([]domain.ElectricalNetwork, error)
	UpdateNetwork(ctx context.Context, net *domain.ElectricalNetwork) error
	DeleteNetwork(ctx context.Context, id uuid.UUID) error
	CreateString(ctx context.Context, ps *domain.PanelString) error
	ListStringsByNetwork(ctx context.Context, networkID uuid.UUID) ([]domain.PanelString, error)
	ListStringsByIDs(ctx context.Context, networkID uuid.UUID, stringIDs []uuid.UUID) ([]domain.PanelString, error)
	CreateInverterGroup(ctx context.Context, ig *domain.InverterGroup) error
	ListInverterGroupsByNetwork(ctx context.Context, networkID uuid.UUID) ([]domain.InverterGroup, error)
	AssignStringsToInverterGroup(ctx context.Context, networkID, inverterGroupID uuid.UUID, stringIDs []uuid.UUID) error
	GetInverterACOutputKW(ctx context.Context, assetID uuid.UUID) (float64, error)
	// Acceptance gate methods.
	GetLayoutAcceptanceStatus(ctx context.Context, layoutID uuid.UUID) (string, error)
	UpdateNetworkReviewMetadata(ctx context.Context, networkID uuid.UUID, metadataJSON []byte) error
}

type ElectricalService struct {
	repo       electricalRepository
	orchClient *orchestration.Client
}

func NewElectricalService(repo *repository.ElectricalRepository, orchestrationURL string) *ElectricalService {
	return &ElectricalService{
		repo:       repo,
		orchClient: orchestration.NewClient(orchestrationURL),
	}
}

func (s *ElectricalService) CreateNetwork(ctx context.Context, req domain.CreateNetworkRequest) (*domain.ElectricalNetwork, error) {
	// Enforce LayoutReady gate: the referenced layout must be APPROVED before
	// an electrical network can be created against it.
	acceptanceStatus, err := s.repo.GetLayoutAcceptanceStatus(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("creating network: check layout acceptance: %w", err)
	}
	if acceptanceStatus != "APPROVED" {
		return nil, fmt.Errorf("creating network: layout %s is not approved (status: %s): layout must be APPROVED before creating an electrical network", req.LayoutID, acceptanceStatus)
	}

	net := &domain.ElectricalNetwork{
		ID:        uuid.New(),
		ProjectID: req.ProjectID,
		LayoutID:  req.LayoutID,
		Name:      req.Name,
	}

	if err := s.repo.CreateNetwork(ctx, net); err != nil {
		return nil, fmt.Errorf("creating network: %w", err)
	}

	log.Info().
		Str("network_id", net.ID.String()).
		Str("name", net.Name).
		Msg("electrical network created")

	return net, nil
}

func (s *ElectricalService) GetNetwork(ctx context.Context, id uuid.UUID) (*domain.ElectricalNetwork, error) {
	return s.repo.GetNetworkByID(ctx, id)
}

func (s *ElectricalService) ListNetworks(ctx context.Context, projectID uuid.UUID) ([]domain.ElectricalNetwork, error) {
	return s.repo.ListNetworksByProject(ctx, projectID)
}

func (s *ElectricalService) DeleteNetwork(ctx context.Context, id uuid.UUID) error {
	return s.repo.DeleteNetwork(ctx, id)
}

func (s *ElectricalService) ListStrings(ctx context.Context, networkID uuid.UUID) ([]domain.PanelString, error) {
	return s.repo.ListStringsByNetwork(ctx, networkID)
}

func (s *ElectricalService) ListInverterGroups(ctx context.Context, networkID uuid.UUID) ([]domain.InverterGroup, error) {
	return s.repo.ListInverterGroupsByNetwork(ctx, networkID)
}

func (s *ElectricalService) CreateString(ctx context.Context, req domain.CreateStringRequest) (*domain.PanelString, error) {
	ps := &domain.PanelString{
		ID:              uuid.New(),
		NetworkID:       req.NetworkID,
		InverterGroupID: req.InverterGroupID,
		PanelIDs:        req.PanelIDs,
		PanelCount:      len(req.PanelIDs),
		Voltage:         req.Voltage * float64(len(req.PanelIDs)),
		Current:         req.Current,
		PowerW:          req.Voltage * float64(len(req.PanelIDs)) * req.Current,
	}

	if err := s.repo.CreateString(ctx, ps); err != nil {
		return nil, fmt.Errorf("creating string: %w", err)
	}
	if err := s.syncNetworkSummary(ctx, req.NetworkID); err != nil {
		return nil, err
	}

	log.Info().
		Str("string_id", ps.ID.String()).
		Int("panel_count", ps.PanelCount).
		Float64("power_w", ps.PowerW).
		Msg("panel string created")

	return ps, nil
}

func (s *ElectricalService) AssignInverter(ctx context.Context, req domain.AssignInverterRequest) (*domain.InverterGroup, error) {
	if len(req.StringIDs) == 0 {
		return nil, fmt.Errorf("assign inverter requires at least one string_id")
	}

	network, err := s.repo.GetNetworkByID(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("loading network: %w", err)
	}

	panelStrings, err := s.repo.ListStringsByIDs(ctx, req.NetworkID, req.StringIDs)
	if err != nil {
		return nil, fmt.Errorf("loading strings: %w", err)
	}
	if len(panelStrings) != len(req.StringIDs) {
		return nil, fmt.Errorf("one or more string_ids were not found in network %s", req.NetworkID)
	}

	seen := make(map[uuid.UUID]struct{}, len(panelStrings))
	var totalDCInputKW float64
	for _, panelString := range panelStrings {
		if _, exists := seen[panelString.ID]; exists {
			return nil, fmt.Errorf("duplicate string_id provided: %s", panelString.ID)
		}
		seen[panelString.ID] = struct{}{}
		totalDCInputKW += panelString.PowerW / 1000.0
	}

	acOutputKW, err := s.repo.GetInverterACOutputKW(ctx, req.InverterAssetID)
	if err != nil {
		return nil, fmt.Errorf("loading inverter asset: %w", err)
	}

	group := &domain.InverterGroup{
		ID:              uuid.New(),
		NetworkID:       req.NetworkID,
		InverterAssetID: req.InverterAssetID,
		StringIDs:       append([]uuid.UUID(nil), req.StringIDs...),
		DCInputKW:       totalDCInputKW,
		ACOutputKW:      acOutputKW,
		Position:        req.Position,
	}
	if group.ACOutputKW > 0 {
		group.DCACRatio = group.DCInputKW / group.ACOutputKW
	}

	if err := s.repo.CreateInverterGroup(ctx, group); err != nil {
		return nil, fmt.Errorf("creating inverter group: %w", err)
	}
	if err := s.repo.AssignStringsToInverterGroup(ctx, req.NetworkID, group.ID, req.StringIDs); err != nil {
		return nil, fmt.Errorf("assigning strings: %w", err)
	}
	if err := s.syncNetworkSummary(ctx, req.NetworkID); err != nil {
		return nil, err
	}

	log.Info().
		Str("network_id", network.ID.String()).
		Str("inverter_group_id", group.ID.String()).
		Int("string_count", len(group.StringIDs)).
		Float64("dc_input_kw", group.DCInputKW).
		Float64("ac_output_kw", group.ACOutputKW).
		Msg("assigned strings to inverter group")

	return group, nil
}

func (s *ElectricalService) AutoGenerateStrings(ctx context.Context, req domain.AutoGenerateRequest) (*domain.ElectricalNetwork, error) {
	net, err := s.repo.GetNetworkByID(ctx, req.NetworkID)
	if err != nil {
		return nil, err
	}

	totalStrings := int(math.Ceil(float64(req.TotalPanels) / float64(req.PanelsPerString)))
	totalInverters := int(math.Ceil(float64(totalStrings) / float64(req.StringsPerInverter)))

	log.Info().
		Int("total_panels", req.TotalPanels).
		Int("total_strings", totalStrings).
		Int("total_inverters", totalInverters).
		Msg("auto-generating electrical strings")

	panelIndex := 0
	stringIndex := 0

	for inv := 0; inv < totalInverters; inv++ {
		ig := &domain.InverterGroup{
			ID:              uuid.New(),
			NetworkID:       req.NetworkID,
			InverterAssetID: req.InverterAssetID,
			ACOutputKW:      req.InverterACKW,
		}

		var igStringIDs []uuid.UUID
		var igDCInputKW float64

		stringsForInverter := req.StringsPerInverter
		if stringIndex+stringsForInverter > totalStrings {
			stringsForInverter = totalStrings - stringIndex
		}

		for str := 0; str < stringsForInverter; str++ {
			panelsInString := req.PanelsPerString
			remaining := req.TotalPanels - panelIndex
			if remaining < panelsInString {
				panelsInString = remaining
			}
			if panelsInString <= 0 {
				break
			}

			panelIDs := make([]uuid.UUID, panelsInString)
			for p := 0; p < panelsInString; p++ {
				panelIDs[p] = uuid.New()
				panelIndex++
			}

			stringVoltage := req.PanelVoltage * float64(panelsInString)
			stringPower := stringVoltage * req.PanelCurrent

			ps := &domain.PanelString{
				ID:              uuid.New(),
				NetworkID:       req.NetworkID,
				InverterGroupID: ig.ID,
				PanelIDs:        panelIDs,
				PanelCount:      panelsInString,
				Voltage:         stringVoltage,
				Current:         req.PanelCurrent,
				PowerW:          stringPower,
			}

			if err := s.repo.CreateString(ctx, ps); err != nil {
				return nil, fmt.Errorf("creating string %d: %w", stringIndex, err)
			}

			igStringIDs = append(igStringIDs, ps.ID)
			igDCInputKW += stringPower / 1000.0
			stringIndex++
		}

		ig.StringIDs = igStringIDs
		ig.DCInputKW = igDCInputKW
		if ig.ACOutputKW > 0 {
			ig.DCACRatio = ig.DCInputKW / ig.ACOutputKW
		}

		if err := s.repo.CreateInverterGroup(ctx, ig); err != nil {
			return nil, fmt.Errorf("creating inverter group %d: %w", inv, err)
		}
	}

	// Update network totals
	net.StringCount = totalStrings
	net.InverterCount = totalInverters
	net.TotalDCCapacityKW = float64(req.TotalPanels) * req.PanelPowerW / 1000.0
	net.TotalACCapacityKW = float64(totalInverters) * req.InverterACKW
	if net.TotalACCapacityKW > 0 {
		net.DCACRatio = net.TotalDCCapacityKW / net.TotalACCapacityKW
	}

	if err := s.repo.UpdateNetwork(ctx, net); err != nil {
		return nil, fmt.Errorf("updating network totals: %w", err)
	}

	log.Info().
		Str("network_id", net.ID.String()).
		Float64("dc_kw", net.TotalDCCapacityKW).
		Float64("ac_kw", net.TotalACCapacityKW).
		Float64("dc_ac_ratio", net.DCACRatio).
		Msg("auto-generation complete")

	return net, nil
}

func (s *ElectricalService) CalculateDCCapacity(ctx context.Context, networkID uuid.UUID) (float64, error) {
	s.submitElectricalJob(ctx, networkID, "calculate_dc_capacity")

	strings, err := s.repo.ListStringsByNetwork(ctx, networkID)
	if err != nil {
		return 0, err
	}

	var totalDC float64
	for _, ps := range strings {
		totalDC += ps.PowerW
	}
	return totalDC / 1000.0, nil
}

func (s *ElectricalService) CalculateACCapacity(ctx context.Context, networkID uuid.UUID) (float64, error) {
	s.submitElectricalJob(ctx, networkID, "calculate_ac_capacity")

	groups, err := s.repo.ListInverterGroupsByNetwork(ctx, networkID)
	if err != nil {
		return 0, err
	}

	var totalAC float64
	for _, ig := range groups {
		totalAC += ig.ACOutputKW
	}
	return totalAC, nil
}

func (s *ElectricalService) syncNetworkSummary(ctx context.Context, networkID uuid.UUID) error {
	net, err := s.repo.GetNetworkByID(ctx, networkID)
	if err != nil {
		return fmt.Errorf("loading network summary: %w", err)
	}

	panelStrings, err := s.repo.ListStringsByNetwork(ctx, networkID)
	if err != nil {
		return fmt.Errorf("listing strings for summary: %w", err)
	}
	inverterGroups, err := s.repo.ListInverterGroupsByNetwork(ctx, networkID)
	if err != nil {
		return fmt.Errorf("listing inverter groups for summary: %w", err)
	}

	var totalDC float64
	for _, panelString := range panelStrings {
		totalDC += panelString.PowerW / 1000.0
	}

	var totalAC float64
	for _, inverterGroup := range inverterGroups {
		totalAC += inverterGroup.ACOutputKW
	}

	net.StringCount = len(panelStrings)
	net.InverterCount = len(inverterGroups)
	net.TotalDCCapacityKW = totalDC
	net.TotalACCapacityKW = totalAC
	net.DCACRatio = 0
	if totalAC > 0 {
		net.DCACRatio = totalDC / totalAC
	}

	if err := s.repo.UpdateNetwork(ctx, net); err != nil {
		return fmt.Errorf("updating network summary: %w", err)
	}
	return nil
}

func (s *ElectricalService) CalculateLosses(ctx context.Context, networkID uuid.UUID) (*domain.LossBreakdown, error) {
	s.submitElectricalJob(ctx, networkID, "calculate_losses")

	dcKW, err := s.CalculateDCCapacity(ctx, networkID)
	if err != nil {
		return nil, err
	}

	// Industry-standard loss factors for utility-scale solar
	losses := &domain.LossBreakdown{
		SoilingLoss:     2.0,
		ShadingLoss:     3.0,
		MismatchLoss:    2.0,
		WiringLossDC:    2.0,
		WiringLossAC:    1.0,
		InverterLoss:    3.0,
		TransformerLoss: 1.0,
	}

	// Adjust wiring losses based on system size
	if dcKW > 1000 {
		losses.WiringLossDC = 1.5
		losses.WiringLossAC = 0.5
	}

	losses.TotalLossPercent = 1.0 - (1.0-losses.SoilingLoss/100)*
		(1.0-losses.ShadingLoss/100)*
		(1.0-losses.MismatchLoss/100)*
		(1.0-losses.WiringLossDC/100)*
		(1.0-losses.WiringLossAC/100)*
		(1.0-losses.InverterLoss/100)*
		(1.0-losses.TransformerLoss/100)
	losses.TotalLossPercent *= 100

	return losses, nil
}

// ValidateSizing runs IEC 62548-style parametric sizing checks on DC string and inverter sizing.
func (s *ElectricalService) ValidateSizing(ctx context.Context, req domain.ValidateSizingRequest) (*domain.ValidateSizingResponse, error) {
	var violations []domain.SizingViolation

	// Temperature-corrected string Voc at lowest expected temperature (cold-day max Voc).
	// Voc(T) = Voc_STC * (1 + tempCoeff/100 * (T - 25))
	// tempCoeff is negative; at low temps Voc rises.
	tempDeltaCold := req.LowestExpectedTempC - 25.0
	vocTempFactor := 1.0 + (req.TempCoeffVocPctPerC/100.0)*tempDeltaCold
	stringVocCold := req.PanelVocV * float64(req.PanelsPerString) * vocTempFactor

	// Temperature-corrected string Vmp at highest expected temperature (hot-day min Vmp).
	tempDeltaHot := req.HighestExpectedTempC - 25.0
	vmpTempFactor := 1.0 + (req.TempCoeffVocPctPerC/100.0)*tempDeltaHot // use same coeff; conservative
	stringVmpHot := req.PanelVmpV * float64(req.PanelsPerString) * vmpTempFactor

	dcStringPowerKW := req.PanelVmpV * req.PanelImpA * float64(req.PanelsPerString) / 1000.0

	// Check 1: cold Voc must not exceed inverter max DC voltage.
	if req.InverterVdcMaxV > 0 && stringVocCold > req.InverterVdcMaxV {
		violations = append(violations, domain.SizingViolation{
			Code:    "VOC_EXCEEDS_VDC_MAX",
			Message: "Cold-day string Voc exceeds inverter max DC input voltage",
			Limit:   req.InverterVdcMaxV,
			Actual:  stringVocCold,
		})
	}

	// Check 2: hot Vmp must be above MPPT min.
	if req.InverterVmpptMinV > 0 && stringVmpHot < req.InverterVmpptMinV {
		violations = append(violations, domain.SizingViolation{
			Code:    "VMP_BELOW_MPPT_MIN",
			Message: "Hot-day string Vmp falls below inverter MPPT minimum voltage",
			Limit:   req.InverterVmpptMinV,
			Actual:  stringVmpHot,
		})
	}

	// Check 3: cold Voc must be below MPPT max (operating window).
	if req.InverterVmpptMaxV > 0 && stringVocCold > req.InverterVmpptMaxV {
		violations = append(violations, domain.SizingViolation{
			Code:    "VOC_EXCEEDS_MPPT_MAX",
			Message: "Cold-day string Voc exceeds inverter MPPT maximum voltage",
			Limit:   req.InverterVmpptMaxV,
			Actual:  stringVocCold,
		})
	}

	// Check 4: string Isc must not exceed inverter max DC current (per MPPT).
	if req.InverterIdcMaxA > 0 && req.PanelIscA > req.InverterIdcMaxA {
		violations = append(violations, domain.SizingViolation{
			Code:    "ISC_EXCEEDS_IDC_MAX",
			Message: "Panel short-circuit current exceeds inverter max DC input current per MPPT",
			Limit:   req.InverterIdcMaxA,
			Actual:  req.PanelIscA,
		})
	}

	// Check 5: DC/AC ratio within user-specified bounds.
	var dcACRatio float64
	if req.InverterACKW > 0 {
		dcACRatio = dcStringPowerKW / req.InverterACKW
	}
	if req.DCACRatioMin > 0 && dcACRatio < req.DCACRatioMin {
		violations = append(violations, domain.SizingViolation{
			Code:    "DC_AC_RATIO_TOO_LOW",
			Message: "DC/AC ratio below minimum target — inverter is oversized for this string",
			Limit:   req.DCACRatioMin,
			Actual:  dcACRatio,
		})
	}
	if req.DCACRatioMax > 0 && dcACRatio > req.DCACRatioMax {
		violations = append(violations, domain.SizingViolation{
			Code:    "DC_AC_RATIO_TOO_HIGH",
			Message: "DC/AC ratio above maximum target — clipping losses will be significant",
			Limit:   req.DCACRatioMax,
			Actual:  dcACRatio,
		})
	}

	// Calculate recommended min/max panels per string based on MPPT window.
	maxPanels := req.PanelsPerString
	minPanels := req.PanelsPerString
	if req.InverterVdcMaxV > 0 && req.PanelVocV > 0 && vocTempFactor > 0 {
		maxPanels = int(req.InverterVdcMaxV / (req.PanelVocV * vocTempFactor))
	}
	if req.InverterVmpptMinV > 0 && req.PanelVmpV > 0 && vmpTempFactor > 0 {
		minPanels = int(math.Ceil(req.InverterVmpptMinV / (req.PanelVmpV * vmpTempFactor)))
	}

	return &domain.ValidateSizingResponse{
		Valid:              len(violations) == 0,
		Violations:         violations,
		StringVocColdV:     stringVocCold,
		StringVmpHotV:      stringVmpHot,
		DCStringPowerKW:    dcStringPowerKW,
		DCACRatio:          dcACRatio,
		MaxPanelsPerString: maxPanels,
		MinPanelsPerString: minPanels,
	}, nil
}

func (s *ElectricalService) submitElectricalJob(ctx context.Context, networkID uuid.UUID, operation string) {
	network, err := s.repo.GetNetworkByID(ctx, networkID)
	if err != nil {
		log.Warn().Err(err).Str("network_id", networkID.String()).Str("operation", operation).Msg("failed to load network for orchestration dispatch")
		return
	}

	payload, _ := json.Marshal(map[string]string{
		"domain":     "electrical",
		"operation":  operation,
		"network_id": networkID.String(),
	})

	jobID, err := s.orchClient.SubmitJob(
		ctx,
		network.ProjectID.String(),
		"custom",
		3,
		string(payload),
		fmt.Sprintf("electrical:%s:%s", operation, networkID.String()),
	)
	if err != nil {
		log.Warn().Err(err).Str("network_id", networkID.String()).Str("operation", operation).Msg("failed to submit electrical orchestration job; continuing inline compute")
		return
	}

	log.Info().Str("network_id", networkID.String()).Str("operation", operation).Str("job_id", jobID).Msg("submitted electrical compute job")
}

// ValidateNetwork performs a full network topology check:
//   - All strings belong to an inverter group (no orphan strings)
//   - No panel ID appears in more than one string (duplicate multi-assign)
//   - Each inverter group has at least one string
//   - Optional MPPT over-subscription check
func (s *ElectricalService) ValidateNetwork(ctx context.Context, req domain.ValidateNetworkRequest) (*domain.ValidateNetworkResponse, error) {
	strings, err := s.repo.ListStringsByNetwork(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("loading strings: %w", err)
	}
	groups, err := s.repo.ListInverterGroupsByNetwork(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("loading inverter groups: %w", err)
	}

	var issues []domain.NetworkTopologyIssue

	// Build set of assigned string IDs.
	assignedStringIDs := make(map[uuid.UUID]struct{})
	for _, g := range groups {
		for _, sid := range g.StringIDs {
			assignedStringIDs[sid] = struct{}{}
		}
		// Inverter group with no strings.
		if len(g.StringIDs) == 0 {
			issues = append(issues, domain.NetworkTopologyIssue{
				Code:     "EMPTY_INVERTER_GROUP",
				Message:  "Inverter group has no assigned strings",
				EntityID: g.ID.String(),
			})
		}
		// Optional MPPT over-subscription.
		if req.InverterMPPTCount > 0 && req.MaxStringsPerMPPT > 0 {
			maxStrings := req.InverterMPPTCount * req.MaxStringsPerMPPT
			if len(g.StringIDs) > maxStrings {
				issues = append(issues, domain.NetworkTopologyIssue{
					Code:     "MPPT_OVER_SUBSCRIBED",
					Message:  fmt.Sprintf("Inverter group has %d strings but MPPT capacity is %d (%d MPPT × %d max)", len(g.StringIDs), maxStrings, req.InverterMPPTCount, req.MaxStringsPerMPPT),
					EntityID: g.ID.String(),
				})
			}
		}
	}

	// Check for unassigned strings and count panels.
	panelSeen := make(map[uuid.UUID]int) // panel_id → count of appearances
	var totalPanels int
	assignedCount := 0
	for _, ps := range strings {
		if _, ok := assignedStringIDs[ps.ID]; ok {
			assignedCount++
		} else {
			issues = append(issues, domain.NetworkTopologyIssue{
				Code:     "UNASSIGNED_STRING",
				Message:  "Panel string is not assigned to any inverter group",
				EntityID: ps.ID.String(),
			})
		}
		for _, pid := range ps.PanelIDs {
			panelSeen[pid]++
		}
		totalPanels += ps.PanelCount
	}

	// Check for duplicate panel references.
	duplicates := 0
	for pid, count := range panelSeen {
		if count > 1 {
			duplicates += count - 1
			issues = append(issues, domain.NetworkTopologyIssue{
				Code:     "DUPLICATE_PANEL_REF",
				Message:  fmt.Sprintf("Panel appears in %d different strings", count),
				EntityID: pid.String(),
			})
		}
	}

	dcKW, _ := s.CalculateDCCapacity(ctx, req.NetworkID)
	acKW, _ := s.CalculateACCapacity(ctx, req.NetworkID)
	var ratio float64
	if acKW > 0 {
		ratio = dcKW / acKW
	}

	return &domain.ValidateNetworkResponse{
		Valid:              len(issues) == 0,
		Issues:             issues,
		TotalStrings:       len(strings),
		AssignedStrings:    assignedCount,
		UnassignedStrings:  len(strings) - assignedCount,
		TotalPanels:        totalPanels,
		DuplicatePanelRefs: duplicates,
		TotalDCKW:          dcKW,
		TotalACKW:          acKW,
		DCACRatio:          ratio,
	}, nil
}

// GenerateNetworkBOM derives BOM item counts directly from the live network
// topology so reports are always consistent with the electrical design.
func (s *ElectricalService) GenerateNetworkBOM(ctx context.Context, req domain.GenerateNetworkBOMRequest) (*domain.GenerateNetworkBOMResponse, error) {
	strings, err := s.repo.ListStringsByNetwork(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("loading strings: %w", err)
	}
	groups, err := s.repo.ListInverterGroupsByNetwork(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("loading inverter groups: %w", err)
	}

	// Count unique panels across all strings.
	panelSet := make(map[uuid.UUID]struct{})
	for _, ps := range strings {
		for _, pid := range ps.PanelIDs {
			panelSet[pid] = struct{}{}
		}
	}
	panelCount := len(panelSet)
	if panelCount == 0 {
		// Fall back to summing PanelCount fields (auto-generated UUIDs may overlap).
		for _, ps := range strings {
			panelCount += ps.PanelCount
		}
	}

	dcKW, _ := s.CalculateDCCapacity(ctx, req.NetworkID)
	acKW, _ := s.CalculateACCapacity(ctx, req.NetworkID)

	cur := req.CurrencyCode
	if cur == "" {
		cur = "USD"
	}

	var items []domain.NetworkBOMItem
	var totalCost float64

	addItem := func(cat, name, unit string, qty int, unitCost float64) {
		tc := float64(qty) * unitCost
		totalCost += tc
		items = append(items, domain.NetworkBOMItem{
			Category:  cat,
			Name:      name,
			Quantity:  qty,
			Unit:      unit,
			UnitCost:  unitCost,
			TotalCost: tc,
		})
	}

	addItem("Panels", "Solar Panel", "pcs", panelCount, req.PanelUnitCost)
	addItem("Inverters", "String Inverter", "pcs", len(groups), req.InverterUnitCost)
	// Cable estimate: 4 m DC cable per panel (rough average run length).
	cableM := panelCount * 4
	ccpm := req.CableCostPerM
	if ccpm <= 0 {
		ccpm = 15.0
	}
	addItem("Cabling", "DC Cable (4mm²)", "m", cableM, ccpm)
	// Mounting: 2 rails + 4 clamps per panel (cost combined into mounting_cost_per_panel).
	mpp := req.MountingCostPerPanel
	if mpp <= 0 {
		mpp = 28.3 // 2×8.5 (rail) + 4×1.2 (clamp) default
	}
	addItem("Mounting", "Rail & Clamp Set", "panel", panelCount, mpp)

	log.Info().
		Str("network_id", req.NetworkID.String()).
		Int("panels", panelCount).
		Int("inverter_groups", len(groups)).
		Float64("total_cost", totalCost).
		Msg("network BOM generated")

	return &domain.GenerateNetworkBOMResponse{
		NetworkID:          req.NetworkID,
		PanelCount:         panelCount,
		StringCount:        len(strings),
		InverterGroupCount: len(groups),
		TotalDCKW:          dcKW,
		TotalACKW:          acKW,
		Items:              items,
		TotalCost:          totalCost,
		CurrencyCode:       cur,
	}, nil
}
