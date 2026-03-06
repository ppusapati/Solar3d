package service

import (
	"context"
	"fmt"
	"math"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/electrical-service/internal/domain"
	"github.com/solar3d/solar3d/services/electrical-service/internal/repository"
)

type ElectricalService struct {
	repo *repository.ElectricalRepository
}

func NewElectricalService(repo *repository.ElectricalRepository) *ElectricalService {
	return &ElectricalService{repo: repo}
}

func (s *ElectricalService) CreateNetwork(ctx context.Context, req domain.CreateNetworkRequest) (*domain.ElectricalNetwork, error) {
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

	log.Info().
		Str("string_id", ps.ID.String()).
		Int("panel_count", ps.PanelCount).
		Float64("power_w", ps.PowerW).
		Msg("panel string created")

	return ps, nil
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

func (s *ElectricalService) CalculateLosses(ctx context.Context, networkID uuid.UUID) (*domain.LossBreakdown, error) {
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
