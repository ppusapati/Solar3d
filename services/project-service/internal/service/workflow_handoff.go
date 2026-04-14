package service

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"

	"solar3d/compute/planning"
)

func (s *ProjectService) submitLayoutToElectricalHandoff(projectID uuid.UUID, actorID string, reason string, evidence planning.Evidence) {
	if s.orch == nil {
		return
	}

	payloadMap := map[string]any{
		"domain":       "workflow",
		"operation":    "layout_to_electrical_handoff",
		"project_id":   projectID.String(),
		"from_phase":   planning.LayoutReadyPhase.String(),
		"to_phase":     planning.ElectricalReadyPhase.String(),
		"actor_id":     actorID,
		"reason":       reason,
		"submitted_at": time.Now().UTC().Format(time.RFC3339),
	}

	idempotencySuffix := "no-evidence"
	if ev, ok := evidence.(*planning.LayoutApprovalEvidence); ok && ev != nil {
		payloadMap["layout_approval_evidence"] = map[string]any{
			"candidate_id":              ev.CandidateID,
			"ml_experiment_id":          ev.MLExperimentID,
			"approved_by_actor":         ev.ApprovedByActor,
			"approved_at":               ev.ApprovedAt.UTC().Format(time.RFC3339),
			"candidate_composite_score": ev.CandidateCompositeScore,
			"selection_rationale":       ev.SelectionRationale,
		}
		if ev.CandidateID != "" {
			idempotencySuffix = ev.CandidateID
		}
	}

	payloadBytes, err := json.Marshal(payloadMap)
	if err != nil {
		s.logger.Warn().Err(err).Str("project_id", projectID.String()).Msg("failed to marshal layout->electrical handoff payload")
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	jobID, err := s.orch.SubmitJob(
		ctx,
		projectID.String(),
		"custom",
		3,
		string(payloadBytes),
		fmt.Sprintf("workflow:layout_to_electrical:%s:%s", projectID.String(), idempotencySuffix),
	)
	if err != nil {
		s.logger.Warn().Err(err).Str("project_id", projectID.String()).Msg("failed to submit layout->electrical orchestration handoff")
		return
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("job_id", jobID).
		Msg("submitted layout->electrical orchestration handoff job")
}

// submitElectricalToTransmissionHandoff fires an orchestration job that carries
// the electrical signoff evidence so the compute executor can fetch the validated
// electrical network, extract anchors (FarmOutputPoint / GridInjectionPoint), and
// begin transmission route calculation.  The call is non-blocking: a submission
// failure logs a warning but does NOT roll back the already-persisted phase
// transition, preserving the immutability contract.
func (s *ProjectService) submitElectricalToTransmissionHandoff(projectID uuid.UUID, actorID string, reason string, evidence planning.Evidence) {
	if s.orch == nil {
		return
	}

	payloadMap := map[string]any{
		"domain":       "workflow",
		"operation":    "electrical_to_transmission_handoff",
		"project_id":   projectID.String(),
		"from_phase":   planning.ElectricalReadyPhase.String(),
		"to_phase":     planning.TransmissionReadyPhase.String(),
		"actor_id":     actorID,
		"reason":       reason,
		"submitted_at": time.Now().UTC().Format(time.RFC3339),
	}

	idempotencySuffix := "no-evidence"
	if ev, ok := evidence.(*planning.ElectricalSignoffEvidence); ok && ev != nil {
		violations := ev.Violations
		if violations == nil {
			violations = []string{}
		}
		payloadMap["electrical_signoff_evidence"] = map[string]any{
			"layout_id":                    ev.LayoutID,
			"electrical_analysis_id":       ev.ElectricalAnalysisID,
			"validated_by_actor":           ev.ValidatedByActor,
			"validated_at":                 ev.ValidatedAt.UTC().Format(time.RFC3339),
			"violations":                   violations,
			"electrical_feasibility_score": ev.ElectricalFeasibilityScore,
		}
		if ev.ElectricalAnalysisID != "" {
			idempotencySuffix = ev.ElectricalAnalysisID
		}
	}

	payloadBytes, err := json.Marshal(payloadMap)
	if err != nil {
		s.logger.Warn().Err(err).Str("project_id", projectID.String()).Msg("failed to marshal electrical->transmission handoff payload")
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	jobID, err := s.orch.SubmitJob(
		ctx,
		projectID.String(),
		"custom",
		3,
		string(payloadBytes),
		fmt.Sprintf("workflow:electrical_to_transmission:%s:%s", projectID.String(), idempotencySuffix),
	)
	if err != nil {
		s.logger.Warn().Err(err).Str("project_id", projectID.String()).Msg("failed to submit electrical->transmission orchestration handoff")
		return
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("job_id", jobID).
		Msg("submitted electrical->transmission orchestration handoff job")
}

// submitApprovedToCommissioningHandoff emits a commissioning handover payload
// with all linkage fields required for twin provisioning: layout, electrical,
// transmission, and design-to-physical identity mappings.
func (s *ProjectService) submitApprovedToCommissioningHandoff(projectID uuid.UUID, actorID string, reason string, evidence planning.Evidence) {
	if s.orch == nil {
		return
	}

	payloadMap := map[string]any{
		"domain":       "workflow",
		"operation":    "approved_to_commissioning_twin_handoff",
		"project_id":   projectID.String(),
		"from_phase":   planning.ApprovedPhase.String(),
		"to_phase":     planning.CommissioningReadyPhase.String(),
		"actor_id":     actorID,
		"reason":       reason,
		"submitted_at": time.Now().UTC().Format(time.RFC3339),
	}

	idempotencySuffix := "no-evidence"
	if ev, ok := evidence.(*planning.StakeholderApprovalEvidence); ok && ev != nil {
		mappings := make([]map[string]any, 0, len(ev.AssetIdentityMappings))
		for _, m := range ev.AssetIdentityMappings {
			mappings = append(mappings, map[string]any{
				"design_asset_id":         m.DesignAssetID,
				"design_asset_type":       m.DesignAssetType,
				"physical_serial_number":  m.PhysicalSerialNumber,
				"commissioning_reference": m.CommissioningRef,
			})
		}

		payloadMap["stakeholder_approval_evidence"] = map[string]any{
			"review_approved_layout_id": ev.ReviewApprovedLayoutID,
			"electrical_analysis_id":    ev.ElectricalAnalysisID,
			"transmission_route_id":     ev.TransmissionRouteID,
			"asset_identity_mappings":   mappings,
			"approved_by_actor":         ev.ApprovedByActor,
			"actor_role":                ev.ActorRole,
			"approved_at":               ev.ApprovedAt.UTC().Format(time.RFC3339),
			"approval_notes":            ev.ApprovalNotes,
		}

		switch {
		case ev.TransmissionRouteID != "":
			idempotencySuffix = ev.TransmissionRouteID
		case ev.ElectricalAnalysisID != "":
			idempotencySuffix = ev.ElectricalAnalysisID
		case ev.ReviewApprovedLayoutID != "":
			idempotencySuffix = ev.ReviewApprovedLayoutID
		}
	}

	payloadBytes, err := json.Marshal(payloadMap)
	if err != nil {
		s.logger.Warn().Err(err).Str("project_id", projectID.String()).Msg("failed to marshal approved->commissioning twin handoff payload")
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	jobID, err := s.orch.SubmitJob(
		ctx,
		projectID.String(),
		"custom",
		3,
		string(payloadBytes),
		fmt.Sprintf("workflow:approved_to_commissioning_twin:%s:%s", projectID.String(), idempotencySuffix),
	)
	if err != nil {
		s.logger.Warn().Err(err).Str("project_id", projectID.String()).Msg("failed to submit approved->commissioning twin handoff")
		return
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("job_id", jobID).
		Msg("submitted approved->commissioning twin handoff job")
}
