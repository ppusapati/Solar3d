package handler

import (
	"context"
	"fmt"

	connect "connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/compute/planning"
	paginationv1 "p9e.in/samavaya/packages/api/v1/pagination"
	pkgErrors "p9e.in/samavaya/packages/errors"
	planningv1 "p9e.in/samavaya/solar3d/gen/planning/v1"
	projectv1 "p9e.in/samavaya/solar3d/gen/project/v1"
	"p9e.in/samavaya/solar3d/project-service/internal/domain"
	"p9e.in/samavaya/solar3d/project-service/internal/service"
)

// TransitionPhase advances a project to the requested workflow phase, recording
// an immutable transition with the provided evidence.
func (h *ConnectProjectService) TransitionPhase(
	ctx context.Context,
	req *connect.Request[projectv1.TransitionPhaseRequest],
) (*connect.Response[projectv1.TransitionPhaseResponse], error) {
	projectID, err := parseUUID(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project_id: %v", err).ToConnectError()
	}

	evidence, err := protoEvidenceToDomain(req.Msg.GetEvidence())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid evidence: %v", err).ToConnectError()
	}

	result, err := h.svc.TransitionPhase(ctx, &service.TransitionPhaseRequest{
		ProjectID:   projectID,
		TargetPhase: protoPhaseToDomain(req.Msg.GetTargetPhase()),
		Evidence:    evidence,
		ActorID:     req.Msg.GetActorId(),
		Reason:      req.Msg.GetReason(),
	})
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&projectv1.TransitionPhaseResponse{
		ProjectId:         result.ProjectID.String(),
		PreviousPhase:     domainPhaseToProto(result.PreviousPhase),
		CurrentPhase:      domainPhaseToProto(result.CurrentPhase),
		TransitionRecord:  transitionRecordToProto(result.TransitionRecord),
		WasNoop:           result.WasNoop,
	}), nil
}

// GetPhaseState returns the current workflow phase of a project plus its most
// recent transition record.
func (h *ConnectProjectService) GetPhaseState(
	ctx context.Context,
	req *connect.Request[projectv1.GetPhaseStateRequest],
) (*connect.Response[projectv1.GetPhaseStateResponse], error) {
	projectID, err := parseUUID(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project_id: %v", err).ToConnectError()
	}

	result, err := h.svc.GetPhaseState(ctx, &service.GetPhaseStateRequest{
		ProjectID: projectID,
	})
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&projectv1.GetPhaseStateResponse{
		ProjectId:      result.ProjectID.String(),
		CurrentPhase:   domainPhaseToProto(result.CurrentPhase),
		PhaseEnteredAt: timestamppb.New(result.PhaseEnteredAt),
		LastTransition: transitionRecordToProto(result.LastTransition),
	}), nil
}

// ListPhaseTransitions returns the immutable transition history for a project.
// Pagination is offset-based via PaginationRequest.
func (h *ConnectProjectService) ListPhaseTransitions(
	ctx context.Context,
	req *connect.Request[projectv1.ListPhaseTransitionsRequest],
) (*connect.Response[projectv1.ListPhaseTransitionsResponse], error) {
	projectID, err := parseUUID(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project_id: %v", err).ToConnectError()
	}

	pagination := req.Msg.GetPagination()
	offset := int(pagination.GetPageOffset())
	limit := int(pagination.GetPageSize())
	if limit <= 0 {
		limit = 50
	}
	if limit > 200 {
		limit = 200
	}

	result, err := h.svc.ListPhaseTransitions(ctx, &service.ListPhaseTransitionsRequest{
		ProjectID: projectID,
		Limit:     limit,
		Offset:    offset,
	})
	if err != nil {
		return nil, toConnectError(err)
	}

	transitions := make([]*projectv1.PhaseTransitionHistoryEntry, 0, len(result.Transitions))
	for _, tr := range result.Transitions {
		transitions = append(transitions, transitionRecordToProto(tr))
	}

	return connect.NewResponse(&projectv1.ListPhaseTransitionsResponse{
		Transitions: transitions,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: int32(result.Total),
			PageOffset: int32(offset),
			PageSize:   int32(limit),
			HasNext:    offset+len(result.Transitions) < result.Total,
		},
	}), nil
}

// ValidatePhaseReadiness checks whether a proposed transition would succeed,
// without performing it. Returns blocker reasons if the transition is blocked.
func (h *ConnectProjectService) ValidatePhaseReadiness(
	ctx context.Context,
	req *connect.Request[projectv1.ValidatePhaseReadinessRequest],
) (*connect.Response[projectv1.ValidatePhaseReadinessResponse], error) {
	projectID, err := parseUUID(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project_id: %v", err).ToConnectError()
	}

	evidence, err := protoEvidenceToDomain(req.Msg.GetEvidence())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid evidence: %v", err).ToConnectError()
	}

	result, err := h.svc.ValidatePhaseReadiness(ctx, &service.ValidatePhaseReadinessRequest{
		ProjectID:   projectID,
		TargetPhase: protoPhaseToDomain(req.Msg.GetTargetPhase()),
		Evidence:    evidence,
	})
	if err != nil {
		return nil, toConnectError(err)
	}

	resp := &projectv1.ValidatePhaseReadinessResponse{
		ProjectId:      result.ProjectID.String(),
		CurrentPhase:   domainPhaseToProto(result.CurrentPhase),
		TargetPhase:    domainPhaseToProto(result.TargetPhase),
		IsValid:        result.IsValid,
		BlockerReasons: result.BlockerReasons,
	}
	if !result.CanTransitionAfter.IsZero() {
		resp.CanTransitionAfter = timestamppb.New(result.CanTransitionAfter)
	}

	return connect.NewResponse(resp), nil
}

// ---------- Proto ↔ Domain conversions ----------

// protoPhaseToDomain converts a planning.v1.WorkflowPhase enum to the domain
// equivalent. Proto values and domain constants are defined with matching ordinals.
func protoPhaseToDomain(p planningv1.WorkflowPhase) planning.WorkflowPhase {
	return planning.WorkflowPhase(p)
}

// domainPhaseToProto converts a domain WorkflowPhase to the proto enum.
func domainPhaseToProto(p planning.WorkflowPhase) planningv1.WorkflowPhase {
	return planningv1.WorkflowPhase(p)
}

// protoEvidenceToDomain converts a proto TransitionEvidence (oneof) into the
// domain Evidence interface. Returns nil evidence + nil error when the proto
// is nil or its oneof is unset — callers that require evidence for a given
// phase should enforce that separately via ValidateTransition.
func protoEvidenceToDomain(p *planningv1.TransitionEvidence) (planning.Evidence, error) {
	if p == nil || p.EvidenceType == nil {
		return nil, nil
	}
	switch ev := p.EvidenceType.(type) {
	case *planningv1.TransitionEvidence_PlanningAcceptance:
		pa := ev.PlanningAcceptance
		if pa == nil {
			return nil, fmt.Errorf("planning_acceptance is nil")
		}
		return &planning.PlanningAcceptanceEvidence{
			BoundaryID:      pa.GetBoundaryId(),
			AcceptedByActor: pa.GetAcceptedByActorId(),
			AcceptedAt:      pa.GetAcceptedAt().AsTime(),
			Notes:           pa.GetNotes(),
		}, nil
	case *planningv1.TransitionEvidence_LayoutApproval:
		la := ev.LayoutApproval
		if la == nil {
			return nil, fmt.Errorf("layout_approval is nil")
		}
		return &planning.LayoutApprovalEvidence{
			CandidateID:             la.GetCandidateId(),
			MLExperimentID:          la.GetMlExperimentId(),
			ApprovedByActor:         la.GetApprovedByActorId(),
			ApprovedAt:              la.GetApprovedAt().AsTime(),
			CandidateCompositeScore: la.GetCandidateCompositeScore(),
			SelectionRationale:      la.GetSelectionRationale(),
		}, nil
	case *planningv1.TransitionEvidence_ElectricalSignoff:
		es := ev.ElectricalSignoff
		if es == nil {
			return nil, fmt.Errorf("electrical_signoff is nil")
		}
		return &planning.ElectricalSignoffEvidence{
			LayoutID:                   es.GetLayoutId(),
			ElectricalAnalysisID:       es.GetElectricalAnalysisId(),
			ValidatedByActor:           es.GetValidatedByActorId(),
			ValidatedAt:                es.GetValidatedAt().AsTime(),
			Violations:                 es.GetViolations(),
			ElectricalFeasibilityScore: es.GetElectricalFeasibilityScore(),
		}, nil
	case *planningv1.TransitionEvidence_TransmissionSignoff:
		ts := ev.TransmissionSignoff
		if ts == nil {
			return nil, fmt.Errorf("transmission_signoff is nil")
		}
		return &planning.TransmissionSignoffEvidence{
			ElectricalLayoutID:   ts.GetElectricalLayoutId(),
			TransmissionRouteID:  ts.GetTransmissionRouteId(),
			ApprovedByActor:      ts.GetApprovedByActorId(),
			ApprovedAt:           ts.GetApprovedAt().AsTime(),
			ProtectionDevices:    ts.GetProtectionDevices(),
			FaultIsolationPoints: ts.GetFaultIsolationPoints(),
		}, nil
	case *planningv1.TransitionEvidence_ReviewApproval:
		ra := ev.ReviewApproval
		if ra == nil {
			return nil, fmt.Errorf("review_approval is nil")
		}
		return &planning.ReviewApprovalEvidence{
			TransmissionRouteID:    ra.GetTransmissionRouteId(),
			LOD400ChecklistID:      ra.GetLod_400ChecklistId(),
			ReviewedByActor:        ra.GetReviewedByActorId(),
			ReviewedAt:             ra.GetReviewedAt().AsTime(),
			MandatoryItemsVerified: ra.GetMandatoryItemsVerified(),
			Blockers:               ra.GetBlockers(),
			QualityScore:           ra.GetQualityScore(),
		}, nil
	case *planningv1.TransitionEvidence_StakeholderApproval:
		sa := ev.StakeholderApproval
		if sa == nil {
			return nil, fmt.Errorf("stakeholder_approval is nil")
		}
		// Proto StakeholderApproval is narrower than the domain struct; the
		// extra domain fields (ElectricalAnalysisID, TransmissionRouteID,
		// AssetIdentityMappings) are populated server-side if and when the
		// proto is extended to carry them.
		return &planning.StakeholderApprovalEvidence{
			ReviewApprovedLayoutID: sa.GetReviewApprovedLayoutId(),
			ApprovedByActor:        sa.GetApprovedByActorId(),
			ActorRole:              sa.GetActorRole(),
			ApprovedAt:             sa.GetApprovedAt().AsTime(),
			ApprovalNotes:          sa.GetApprovalNotes(),
		}, nil
	case *planningv1.TransitionEvidence_CommissioningConfirmation:
		cc := ev.CommissioningConfirmation
		if cc == nil {
			return nil, fmt.Errorf("commissioning_confirmation is nil")
		}
		return &planning.CommissioningConfirmationEvidence{
			ApprovedProjectID:      cc.GetApprovedProjectId(),
			TwinID:                 cc.GetTwinId(),
			ProvisionedByActor:     cc.GetProvisionedByActorId(),
			ProvisionedAt:          cc.GetProvisionedAt().AsTime(),
			AssetIdentityLinkCount: cc.GetAssetIdentityLinks(),
		}, nil
	default:
		return nil, fmt.Errorf("unknown evidence type %T", ev)
	}
}

// transitionRecordToProto maps a domain transition record to the proto entry.
// Returns nil when the input is nil so callers can pass optional fields through
// unchanged.
func transitionRecordToProto(rec *domain.PhaseTransitionRecord) *projectv1.PhaseTransitionHistoryEntry {
	if rec == nil {
		return nil
	}
	return &projectv1.PhaseTransitionHistoryEntry{
		Id:             rec.ID,
		FromPhase:      domainPhaseToProto(rec.FromPhase),
		ToPhase:        domainPhaseToProto(rec.ToPhase),
		OccurredAt:     timestamppb.New(rec.OccurredAt),
		ActorId:        rec.ActorID,
		Reason:         rec.Reason,
		IsRollback:     rec.IsRollback,
		RollbackReason: rec.RollbackReason,
	}
}
