package service

// LOD400Service evaluates the LOD 400 checklist for a given project's layout
// and electrical network against the EN 17412-1 LOD 400 (fabrication/installation
// detail) gate criteria.
//
// Scoring rules:
//   - Each check item has a Weight and an IsMandatory flag.
//   - If ANY mandatory item is FAILED, IsLOD400Ready = false regardless of aggregate_score.
//   - AggregateScore = sum(Weight of PASSED items) / sum(Weight of active items)
//     where "active" means status != SKIPPED.
//   - SKIPPED is used when the source data is entirely absent (e.g. no transmission route).
//     SKIPPED mandatory items are treated as FAILED blockers.
//
// Check catalogue (14 items):
//   Mandatory (weight 1.0 each):
//     PANEL.GEOMETRY.COUNT                — layout has ≥ 1 panel
//     PANEL.ACCEPTANCE.STATUS             — layout review_metadata.status == "APPROVED"
//     INVERTER.GEOMETRY.PLACED            — ≥ 1 inverter group exists in network
//     INVERTER.ELECTRICAL.DC_AC_RATIO     — network dc_ac_ratio ∈ [0.9, 1.5]
//     INVERTER.TOPOLOGY.STRINGS_ASSIGNED  — ≥ 1 panel string assigned to inverter group
//     ELECTRICAL.ACCEPTANCE.STATUS        — network review_metadata.status == "APPROVED"
//     TRANSMISSION.TOPOLOGY.EXISTS        — ≥ 1 transmission route exists for project
//     TRANSMISSION.ACCEPTANCE.STATUS      — route status ∈ {REVIEW_PENDING, APPROVED}
//     TRANSMISSION.FAULT.PROTECTION_DEVS  — protection_devices list is non-empty (IEC 60255)
//     TRANSMISSION.FAULT.ISOLATION_PTS    — fault_isolation_points > 0 (IEC 60909)
//
//   Non-mandatory:
//     ELECTRICAL.ELECTRICAL.FEASIBILITY   — electrical_feasibility_score ≥ 0.7  (weight 0.8)
//     TRANSFORMER.GEOMETRY.PLACED         — ≥ 1 transformer component placed      (weight 0.6)
//     COMBINER_BOX.TOPOLOGY.PLACED        — ≥ 1 combiner_box component placed     (weight 0.3)
//     ROAD.GEOMETRY.PLACED                — ≥ 1 road component placed             (weight 0.3)
//
// Total weight pool = 10.0 (mandatory) + 2.0 (non-mandatory) = 12.0

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"solar3d/project-service/internal/domain"
	"solar3d/project-service/internal/repository"
)

const (
	// dcAcRatioMin and dcAcRatioMax define the acceptable inverter loading range.
	dcAcRatioMin = 0.9
	dcAcRatioMax = 1.5

	// electricalFeasibilityThreshold is the minimum acceptable feasibility score.
	electricalFeasibilityThreshold = 0.7
)

// LOD400Service evaluates and persists LOD 400 checklist results.
type LOD400Service struct {
	repo   *repository.LOD400Repository
	logger zerolog.Logger
}

// NewLOD400Service creates a LOD400Service backed by the given repository.
func NewLOD400Service(repo *repository.LOD400Repository) *LOD400Service {
	return &LOD400Service{
		repo:   repo,
		logger: log.With().Str("component", "lod400_service").Logger(),
	}
}

// ScoreLOD400Request is the input for a LOD 400 scoring run.
type ScoreLOD400Request struct {
	// ProjectID is required.
	ProjectID uuid.UUID
	// LayoutID is required; identifies the layout to evaluate.
	LayoutID uuid.UUID
	// ScoredByActorID is required; identifies the actor triggering evaluation.
	ScoredByActorID string
}

// ScoreLOD400 evaluates all 14 checklist items, computes the aggregate score,
// enforces the mandatory-fail-blocks-ready rule, persists the result, and returns it.
func (s *LOD400Service) ScoreLOD400(ctx context.Context, req ScoreLOD400Request) (*domain.LOD400ChecklistResult, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("lod400 score: project_id is required")
	}
	if req.LayoutID == uuid.Nil {
		return nil, fmt.Errorf("lod400 score: layout_id is required")
	}
	if req.ScoredByActorID == "" {
		return nil, fmt.Errorf("lod400 score: scored_by_actor_id is required")
	}

	s.logger.Info().
		Str("project_id", req.ProjectID.String()).
		Str("layout_id", req.LayoutID.String()).
		Str("actor_id", req.ScoredByActorID).
		Msg("starting LOD400 scoring run")

	// ── 1. Gather all needed data ────────────────────────────────────────────

	layoutData, err := s.repo.GetLayoutDataForLOD(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("lod400 score: fetch layout: %w", err)
	}

	componentCounts, err := s.repo.GetComponentTypeCountsForLayout(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("lod400 score: fetch components: %w", err)
	}

	networkData, err := s.repo.GetNetworkDataForLayout(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("lod400 score: fetch network: %w", err)
	}

	var inverterGroupCount, assignedStringCount int
	var networkID *uuid.UUID
	if networkData != nil {
		id := networkData.NetworkID
		networkID = &id

		inverterGroupCount, err = s.repo.GetInverterGroupCountForNetwork(ctx, networkData.NetworkID)
		if err != nil {
			return nil, fmt.Errorf("lod400 score: fetch inverter groups: %w", err)
		}
		assignedStringCount, err = s.repo.GetAssignedStringCountForNetwork(ctx, networkData.NetworkID)
		if err != nil {
			return nil, fmt.Errorf("lod400 score: fetch strings: %w", err)
		}
	}

	transmissionData, err := s.repo.GetTransmissionRouteForProject(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("lod400 score: fetch transmission: %w", err)
	}

	// ── 2. Evaluate all checklist items ─────────────────────────────────────

	items := s.evaluateItems(layoutData, componentCounts, networkData, inverterGroupCount, assignedStringCount, transmissionData)

	// ── 3. Compute aggregate score and collect blockers ──────────────────────

	result := buildResult(req, networkID, items)

	// ── 4. Persist ───────────────────────────────────────────────────────────

	if err := s.repo.SaveLOD400Result(ctx, result); err != nil {
		return nil, fmt.Errorf("lod400 score: persist result: %w", err)
	}

	s.logger.Info().
		Str("result_id", result.ID.String()).
		Bool("is_ready", result.IsLOD400Ready).
		Float64("score", result.AggregateScore).
		Int("blockers", len(result.MandatoryBlockers)).
		Msg("LOD400 scoring run complete")

	return result, nil
}

// GetLatestResult returns the most recently persisted LOD 400 result for a layout.
// Returns repository.ErrNotFound if no scoring run exists yet.
func (s *LOD400Service) GetLatestResult(ctx context.Context, layoutID uuid.UUID) (*domain.LOD400ChecklistResult, error) {
	if layoutID == uuid.Nil {
		return nil, fmt.Errorf("lod400 get latest: layout_id is required")
	}
	res, err := s.repo.GetLatestLOD400Result(ctx, layoutID)
	if err != nil {
		return nil, fmt.Errorf("lod400 get latest: %w", err)
	}
	return res, nil
}

// ────────────────────────────────────────────────────────────────────────────
// Internal helpers
// ────────────────────────────────────────────────────────────────────────────

// evaluateItems runs all 14 checks and returns the ordered item slice.
func (s *LOD400Service) evaluateItems(
	layout *lod400LayoutSnapshot,
	components map[string]int,
	network *lod400NetworkSnapshot,
	inverterGroups int,
	assignedStrings int,
	transmission *lod400TransmissionSnapshot,
) []domain.LOD400ChecklistItem {
	items := make([]domain.LOD400ChecklistItem, 0, 14)

	// ── PANEL class ──────────────────────────────────────────────────────────

	items = append(items, evaluatePanelCount(layout))
	items = append(items, evaluatePanelAcceptance(layout))

	// ── INVERTER + ELECTRICAL class ──────────────────────────────────────────

	items = append(items, evaluateInverterPlaced(network, inverterGroups))
	items = append(items, evaluateInverterDcAcRatio(network))
	items = append(items, evaluateStringsAssigned(network, assignedStrings))
	items = append(items, evaluateElectricalAcceptance(network))
	items = append(items, evaluateElectricalFeasibility(network))

	// ── TRANSFORMER, COMBINER_BOX, ROAD (non-mandatory) ────────────────────

	items = append(items, evaluateComponentPresent(
		components, "transformer",
		"TRANSFORMER.GEOMETRY.PLACED",
		domain.LOD400AssetClassTransformer,
		"At least one transformer component must be placed (EN 17412-1 LOD 400).",
		0.6,
	))
	items = append(items, evaluateComponentPresent(
		components, "combiner_box",
		"COMBINER_BOX.TOPOLOGY.PLACED",
		domain.LOD400AssetClassCombinerBox,
		"At least one DC combiner box component must be placed.",
		0.3,
	))
	items = append(items, evaluateComponentPresent(
		components, "road",
		"ROAD.GEOMETRY.PLACED",
		domain.LOD400AssetClassRoad,
		"At least one access road component must be placed.",
		0.3,
	))

	// ── TRANSMISSION class ───────────────────────────────────────────────────

	items = append(items, evaluateTransmissionExists(transmission))
	items = append(items, evaluateTransmissionAcceptance(transmission))
	items = append(items, evaluateProtectionDevices(transmission))
	items = append(items, evaluateFaultIsolationPoints(transmission))

	return items
}

// buildResult aggregates items into a LOD400ChecklistResult.
func buildResult(req ScoreLOD400Request, networkID *uuid.UUID, items []domain.LOD400ChecklistItem) *domain.LOD400ChecklistResult {
	var passedWeight, activeWeight float64
	var blockers []string
	allMandatoryPassed := true

	for _, item := range items {
		if item.Status == domain.LOD400ItemSkipped {
			if item.IsMandatory {
				allMandatoryPassed = false
				blockers = append(blockers, item.BlockerReason)
			}
			continue // skipped items never contribute to weight pool
		}
		activeWeight += item.Weight
		if item.Status == domain.LOD400ItemPassed {
			passedWeight += item.Weight
		} else if item.IsMandatory {
			allMandatoryPassed = false
			if item.BlockerReason != "" {
				blockers = append(blockers, item.BlockerReason)
			}
		}
	}

	var score float64
	if activeWeight > 0 {
		score = passedWeight / activeWeight
	}

	if blockers == nil {
		blockers = []string{}
	}

	return &domain.LOD400ChecklistResult{
		ID:                  uuid.New(),
		ProjectID:           req.ProjectID,
		LayoutID:            req.LayoutID,
		ElectricalNetworkID: networkID,
		ScoredAt:            time.Now().UTC(),
		ScoredByActorID:     req.ScoredByActorID,
		IsLOD400Ready:       allMandatoryPassed,
		AggregateScore:      score,
		MandatoryBlockers:   blockers,
		Items:               items,
	}
}

// ── Item evaluation functions ─────────────────────────────────────────────

// lod400LayoutSnapshot is an alias to keep function signatures concise.
type lod400LayoutSnapshot = repository.LOD400LayoutData

// lod400NetworkSnapshot is an alias to keep function signatures concise.
type lod400NetworkSnapshot = repository.LOD400NetworkData

// lod400TransmissionSnapshot is an alias to keep function signatures concise.
type lod400TransmissionSnapshot = repository.LOD400TransmissionData

func evaluatePanelCount(layout *lod400LayoutSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "PANEL.GEOMETRY.COUNT",
		AssetClass:  domain.LOD400AssetClassPanel,
		CheckType:   domain.LOD400CheckGeometry,
		Description: "Layout must contain at least one placed solar panel (EN 17412-1 LOD 400 geometry completeness).",
		IsMandatory: true,
		Weight:      1.0,
	}
	item.Evidence = fmt.Sprintf("%d panels placed", layout.TotalPanels)
	if layout.TotalPanels > 0 {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = "No panels placed: layout has 0 total_panels; at least 1 panel must be placed for LOD 400."
	}
	return item
}

func evaluatePanelAcceptance(layout *lod400LayoutSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "PANEL.ACCEPTANCE.STATUS",
		AssetClass:  domain.LOD400AssetClassPanel,
		CheckType:   domain.LOD400CheckAcceptance,
		Description: "Layout must be in APPROVED acceptance status before LOD 400 gate can pass.",
		IsMandatory: true,
		Weight:      1.0,
	}
	item.Evidence = fmt.Sprintf("layout acceptance status: %s", layout.ReviewMetadataStatus)
	if layout.ReviewMetadataStatus == "APPROVED" {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = fmt.Sprintf(
			"Layout acceptance status is %q; must be APPROVED before LOD 400 gate.",
			layout.ReviewMetadataStatus,
		)
	}
	return item
}

func evaluateInverterPlaced(network *lod400NetworkSnapshot, inverterGroupCount int) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "INVERTER.GEOMETRY.PLACED",
		AssetClass:  domain.LOD400AssetClassInverter,
		CheckType:   domain.LOD400CheckGeometry,
		Description: "At least one inverter group must be assigned in the electrical network.",
		IsMandatory: true,
		Weight:      1.0,
	}
	if network == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no electrical network found"
		item.BlockerReason = "No electrical network exists for this layout; inverter placement cannot be verified."
		return item
	}
	item.Evidence = fmt.Sprintf("%d inverter groups in network %s", inverterGroupCount, network.NetworkID)
	if inverterGroupCount > 0 {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = "No inverter groups are assigned in the electrical network; at least 1 is required."
	}
	return item
}

func evaluateInverterDcAcRatio(network *lod400NetworkSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "INVERTER.ELECTRICAL.DC_AC_RATIO",
		AssetClass:  domain.LOD400AssetClassInverter,
		CheckType:   domain.LOD400CheckElectrical,
		Description: fmt.Sprintf("Network DC/AC ratio must be within [%.1f, %.1f] for safe inverter loading.", dcAcRatioMin, dcAcRatioMax),
		IsMandatory: true,
		Weight:      1.0,
	}
	if network == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no electrical network found"
		item.BlockerReason = "No electrical network exists; DC/AC ratio cannot be verified."
		return item
	}
	item.Evidence = fmt.Sprintf("dc_ac_ratio = %.3f", network.DcAcRatio)
	if network.DcAcRatio >= dcAcRatioMin && network.DcAcRatio <= dcAcRatioMax {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = fmt.Sprintf(
			"DC/AC ratio %.3f is outside acceptable range [%.1f, %.1f]; inverter loading is invalid.",
			network.DcAcRatio, dcAcRatioMin, dcAcRatioMax,
		)
	}
	return item
}

func evaluateStringsAssigned(network *lod400NetworkSnapshot, assignedStrings int) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "INVERTER.TOPOLOGY.STRINGS_ASSIGNED",
		AssetClass:  domain.LOD400AssetClassInverter,
		CheckType:   domain.LOD400CheckTopology,
		Description: "At least one panel string must be assigned to an inverter group in the network.",
		IsMandatory: true,
		Weight:      1.0,
	}
	if network == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no electrical network found"
		item.BlockerReason = "No electrical network exists; string-to-inverter topology cannot be verified."
		return item
	}
	item.Evidence = fmt.Sprintf("%d strings assigned to inverter groups", assignedStrings)
	if assignedStrings > 0 {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = "No panel strings are assigned to inverter groups; complete string-to-inverter wiring is required for LOD 400."
	}
	return item
}

func evaluateElectricalAcceptance(network *lod400NetworkSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "ELECTRICAL.ACCEPTANCE.STATUS",
		AssetClass:  domain.LOD400AssetClassElectrical,
		CheckType:   domain.LOD400CheckAcceptance,
		Description: "Electrical network must be in APPROVED acceptance status for LOD 400 gate.",
		IsMandatory: true,
		Weight:      1.0,
	}
	if network == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no electrical network found"
		item.BlockerReason = "No electrical network exists; acceptance status cannot be verified."
		return item
	}
	item.Evidence = fmt.Sprintf("electrical network acceptance status: %s", network.ReviewMetadataStatus)
	if network.ReviewMetadataStatus == "APPROVED" {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = fmt.Sprintf(
			"Electrical network acceptance status is %q; must be APPROVED for LOD 400.",
			network.ReviewMetadataStatus,
		)
	}
	return item
}

func evaluateElectricalFeasibility(network *lod400NetworkSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "ELECTRICAL.ELECTRICAL.FEASIBILITY",
		AssetClass:  domain.LOD400AssetClassElectrical,
		CheckType:   domain.LOD400CheckElectrical,
		Description: fmt.Sprintf("Electrical feasibility score should be ≥ %.1f for optimal LOD 400 rating.", electricalFeasibilityThreshold),
		IsMandatory: false,
		Weight:      0.8,
	}
	if network == nil {
		item.Status = domain.LOD400ItemSkipped
		item.Evidence = "no electrical network found"
		return item
	}
	item.Evidence = fmt.Sprintf("electrical_feasibility_score = %.3f", network.ElectricalFeasibilityScore)
	if network.ElectricalFeasibilityScore >= electricalFeasibilityThreshold {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		// Non-mandatory: no BlockerReason needed.
	}
	return item
}

func evaluateComponentPresent(
	components map[string]int,
	componentType string,
	checkID string,
	assetClass domain.LOD400AssetClass,
	description string,
	weight float64,
) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          checkID,
		AssetClass:  assetClass,
		CheckType:   domain.LOD400CheckGeometry,
		Description: description,
		IsMandatory: false,
		Weight:      weight,
	}
	count := components[componentType]
	item.Evidence = fmt.Sprintf("%d %s component(s) placed", count, componentType)
	if count > 0 {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
	}
	return item
}

func evaluateTransmissionExists(transmission *lod400TransmissionSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "TRANSMISSION.TOPOLOGY.EXISTS",
		AssetClass:  domain.LOD400AssetClassTransmission,
		CheckType:   domain.LOD400CheckTopology,
		Description: "At least one transmission route must exist for the project (IEC 62446-1 grid connection documentation).",
		IsMandatory: true,
		Weight:      1.0,
	}
	if transmission == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no transmission route found"
		item.BlockerReason = "No transmission route exists for this project; a route must be created and submitted before LOD 400."
		return item
	}
	item.Status = domain.LOD400ItemPassed
	item.Evidence = fmt.Sprintf("transmission route %s exists", transmission.RouteID)
	return item
}

func evaluateTransmissionAcceptance(transmission *lod400TransmissionSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "TRANSMISSION.ACCEPTANCE.STATUS",
		AssetClass:  domain.LOD400AssetClassTransmission,
		CheckType:   domain.LOD400CheckAcceptance,
		Description: "Transmission route must be submitted for review (REVIEW_PENDING or APPROVED) for LOD 400 gate.",
		IsMandatory: true,
		Weight:      1.0,
	}
	if transmission == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no transmission route found"
		item.BlockerReason = "No transmission route exists; acceptance status cannot be verified."
		return item
	}
	item.Evidence = fmt.Sprintf("transmission route acceptance status: %s", transmission.ReviewMetadataStatus)
	if transmission.ReviewMetadataStatus == "REVIEW_PENDING" || transmission.ReviewMetadataStatus == "APPROVED" {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = fmt.Sprintf(
			"Transmission route acceptance status is %q; must be REVIEW_PENDING or APPROVED for LOD 400.",
			transmission.ReviewMetadataStatus,
		)
	}
	return item
}

func evaluateProtectionDevices(transmission *lod400TransmissionSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "TRANSMISSION.FAULT.PROTECTION_DEVS",
		AssetClass:  domain.LOD400AssetClassTransmission,
		CheckType:   domain.LOD400CheckFaultCoverage,
		Description: "Transmission route must have protection devices assigned per IEC 60255 coordination requirements.",
		IsMandatory: true,
		Weight:      1.0,
	}
	if transmission == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no transmission route found"
		item.BlockerReason = "No transmission route exists; IEC 60255 protection device coverage cannot be verified."
		return item
	}

	// Count entries in the JSONB array.
	var devices []json.RawMessage
	if err := json.Unmarshal(transmission.ProtectionDevicesJSON, &devices); err != nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "protection_devices JSON parse error"
		item.BlockerReason = "protection_devices field could not be parsed; IEC 60255 compliance unverifiable."
		return item
	}

	item.Evidence = fmt.Sprintf("%d protection device(s) assigned to route", len(devices))
	if len(devices) > 0 {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = "No protection devices assigned to transmission route; at least 1 IEC 60255 device is required for LOD 400."
	}
	return item
}

func evaluateFaultIsolationPoints(transmission *lod400TransmissionSnapshot) domain.LOD400ChecklistItem {
	item := domain.LOD400ChecklistItem{
		ID:          "TRANSMISSION.FAULT.ISOLATION_PTS",
		AssetClass:  domain.LOD400AssetClassTransmission,
		CheckType:   domain.LOD400CheckFaultCoverage,
		Description: "Transmission route must have at least one fault isolation point per IEC 60909 fault current analysis.",
		IsMandatory: true,
		Weight:      1.0,
	}
	if transmission == nil {
		item.Status = domain.LOD400ItemFailed
		item.Evidence = "no transmission route found"
		item.BlockerReason = "No transmission route exists; IEC 60909 fault isolation cannot be verified."
		return item
	}
	item.Evidence = fmt.Sprintf("%d fault isolation point(s)", transmission.FaultIsolationPoints)
	if transmission.FaultIsolationPoints > 0 {
		item.Status = domain.LOD400ItemPassed
	} else {
		item.Status = domain.LOD400ItemFailed
		item.BlockerReason = "Transmission route has 0 fault isolation points; at least 1 is required by IEC 60909."
	}
	return item
}
