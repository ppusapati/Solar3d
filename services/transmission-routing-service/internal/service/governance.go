package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/repository"
)

const transmissionAlgorithmVersion = "transmission-routing-phase6.0.0"

var ErrInvalidWorkflowTransition = errors.New("invalid transmission route workflow transition")
var ErrTraceabilityIncomplete = errors.New("traceability bundle is incomplete")

func (s *TransmissionService) SubmitTransmissionRouteForReview(ctx context.Context, id uuid.UUID, actor, note string) (*domain.TransmissionRoute, error) {
	actor = strings.TrimSpace(actor)
	if actor == "" {
		return nil, fmt.Errorf("%w: actor is required", ErrInvalidInput)
	}
	route, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if route == nil {
		return nil, repository.ErrNotFound
	}
	if route.ApprovalStatus == "" {
		route.ApprovalStatus = domain.ApprovalStatusDraft
	}
	if route.ApprovalStatus != domain.ApprovalStatusDraft {
		return nil, fmt.Errorf("%w: route must be in draft before engineering review", ErrInvalidWorkflowTransition)
	}
	traceability, err := extractTraceability(route.Metadata)
	if err != nil {
		return nil, err
	}
	if err := validateTraceability(route, traceability); err != nil {
		return nil, err
	}
	now := time.Now().UTC()
	route.ApprovalStatus = domain.ApprovalStatusEngineeringReview
	route.EngineeringReviewedAt = &now
	route.EngineeringReviewedBy = actor
	appendGovernanceEvent(route, "submitted_for_review", actor, note, domain.ApprovalStatusDraft, domain.ApprovalStatusEngineeringReview, now)
	appendRouteSummary(route, fmt.Sprintf("workflow: submitted for engineering review by %s", actor))
	return s.repo.SubmitForReview(ctx, route)
}

func (s *TransmissionService) ApproveTransmissionRoute(ctx context.Context, id uuid.UUID, actor, note string) (*domain.TransmissionRoute, error) {
	actor = strings.TrimSpace(actor)
	if actor == "" {
		return nil, fmt.Errorf("%w: actor is required", ErrInvalidInput)
	}
	route, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if route == nil {
		return nil, repository.ErrNotFound
	}
	if route.ApprovalStatus == "" {
		route.ApprovalStatus = domain.ApprovalStatusDraft
	}
	if route.ApprovalStatus != domain.ApprovalStatusEngineeringReview {
		return nil, fmt.Errorf("%w: route must be in engineering review before approval", ErrInvalidWorkflowTransition)
	}
	traceability, err := extractTraceability(route.Metadata)
	if err != nil {
		return nil, err
	}
	if err := validateTraceability(route, traceability); err != nil {
		return nil, err
	}
	now := time.Now().UTC()
	traceability.ApprovedAt = now
	traceability.ApprovedBy = actor
	ensureMetadata(route)
	route.Metadata["traceability"] = traceability
	route.ApprovalStatus = domain.ApprovalStatusApproved
	route.ApprovedAt = &now
	route.ApprovedBy = actor
	appendGovernanceEvent(route, "approved", actor, note, domain.ApprovalStatusEngineeringReview, domain.ApprovalStatusApproved, now)
	appendRouteSummary(route, fmt.Sprintf("workflow: approved by %s", actor))
	return s.repo.Approve(ctx, route)
}

// RejectTransmissionRoute transitions a route from engineering_review to
// rejected with at least one documented reason. The transition is captured in
// the governance event stream (single source of truth for audit); dedicated
// rejected_at / rejected_by columns are intentionally not persisted.
func (s *TransmissionService) RejectTransmissionRoute(ctx context.Context, id uuid.UUID, actor string, reasons []string, note string) (*domain.TransmissionRoute, error) {
	actor = strings.TrimSpace(actor)
	if actor == "" {
		return nil, fmt.Errorf("%w: actor is required", ErrInvalidInput)
	}
	if len(reasons) == 0 {
		return nil, fmt.Errorf("%w: at least one rejection reason is required", ErrInvalidInput)
	}
	route, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if route == nil {
		return nil, repository.ErrNotFound
	}
	if route.ApprovalStatus == "" {
		route.ApprovalStatus = domain.ApprovalStatusDraft
	}
	if route.ApprovalStatus != domain.ApprovalStatusEngineeringReview {
		return nil, fmt.Errorf("%w: route must be in engineering review before rejection", ErrInvalidWorkflowTransition)
	}
	now := time.Now().UTC()
	from := route.ApprovalStatus
	route.ApprovalStatus = domain.ApprovalStatusRejected
	rejectionNote := note
	if rejectionNote == "" {
		rejectionNote = strings.Join(reasons, "; ")
	} else {
		rejectionNote = rejectionNote + " | reasons: " + strings.Join(reasons, "; ")
	}
	appendGovernanceEvent(route, "rejected", actor, rejectionNote, from, domain.ApprovalStatusRejected, now)
	appendRouteSummary(route, fmt.Sprintf("workflow: rejected by %s", actor))
	return s.repo.Reject(ctx, route)
}

func appendGovernanceEvent(route *domain.TransmissionRoute, eventType, actor, note string, fromStatus, toStatus domain.ApprovalStatus, occurredAt time.Time) {
	route.GovernanceEvents = append(route.GovernanceEvents, domain.GovernanceEvent{
		EventType:  eventType,
		Actor:      actor,
		Note:       note,
		FromStatus: fromStatus,
		ToStatus:   toStatus,
		OccurredAt: occurredAt,
	})
}

func appendRouteSummary(route *domain.TransmissionRoute, entry string) {
	if route.RouteSummary != "" {
		route.RouteSummary += "; "
	}
	route.RouteSummary += entry
}

func ensureMetadata(route *domain.TransmissionRoute) {
	if route.Metadata == nil {
		route.Metadata = map[string]interface{}{}
	}
}

func populateRouteTraceability(route *domain.TransmissionRoute, req domain.CalculateTransmissionRouteRequest, snapshot domain.DataSourceSnapshot) error {
	ensureMetadata(route)
	requestJSON, err := json.Marshal(req)
	if err != nil {
		return fmt.Errorf("marshal request snapshot: %w", err)
	}
	traceability := domain.TraceabilityBundle{
		AlgorithmVersion:    transmissionAlgorithmVersion,
		InputFingerprint:    hashBytes(requestJSON),
		RouteFingerprint:    computeRouteFingerprint(route),
		RegressionSignature: computeRegressionSignature(route),
		RequestSnapshotJSON: string(requestJSON),
		DataSnapshotID:      snapshot.SnapshotID,
	}
	route.Metadata["traceability"] = traceability
	return nil
}

func extractTraceability(metadata map[string]interface{}) (domain.TraceabilityBundle, error) {
	if len(metadata) == 0 {
		return domain.TraceabilityBundle{}, ErrTraceabilityIncomplete
	}
	raw, ok := metadata["traceability"]
	if !ok {
		return domain.TraceabilityBundle{}, ErrTraceabilityIncomplete
	}
	payload, err := json.Marshal(raw)
	if err != nil {
		return domain.TraceabilityBundle{}, fmt.Errorf("marshal traceability metadata: %w", err)
	}
	var traceability domain.TraceabilityBundle
	if err := json.Unmarshal(payload, &traceability); err != nil {
		return domain.TraceabilityBundle{}, fmt.Errorf("unmarshal traceability metadata: %w", err)
	}
	return traceability, nil
}

func validateTraceability(route *domain.TransmissionRoute, traceability domain.TraceabilityBundle) error {
	if traceability.AlgorithmVersion == "" ||
		traceability.InputFingerprint == "" ||
		traceability.RouteFingerprint == "" ||
		traceability.RegressionSignature == "" ||
		traceability.RequestSnapshotJSON == "" ||
		traceability.DataSnapshotID == "" {
		return ErrTraceabilityIncomplete
	}
	if traceability.AlgorithmVersion != transmissionAlgorithmVersion {
		return fmt.Errorf("%w: algorithm version mismatch", ErrTraceabilityIncomplete)
	}
	if hashBytes([]byte(traceability.RequestSnapshotJSON)) != traceability.InputFingerprint {
		return fmt.Errorf("%w: input fingerprint mismatch", ErrTraceabilityIncomplete)
	}
	currentFingerprint := computeRouteFingerprint(route)
	if currentFingerprint != traceability.RouteFingerprint {
		return fmt.Errorf("%w: route fingerprint drift detected", ErrTraceabilityIncomplete)
	}
	if computeRegressionSignature(route) != traceability.RegressionSignature {
		return fmt.Errorf("%w: regression signature mismatch", ErrTraceabilityIncomplete)
	}
	return nil
}

func computeRouteFingerprint(route *domain.TransmissionRoute) string {
	projection := struct {
		PathGeoJSON         string                      `json:"path_geojson"`
		DistanceM           float64                     `json:"distance_m"`
		TowerPositions      []domain.TowerPosition      `json:"tower_positions"`
		CostBreakdown       domain.CostBreakdown        `json:"cost_breakdown"`
		SegmentExplanations []domain.SegmentExplanation `json:"segment_explanations"`
	}{
		PathGeoJSON:         route.PathGeoJSON,
		DistanceM:           route.DistanceM,
		TowerPositions:      route.TowerPositions,
		CostBreakdown:       route.CostBreakdown,
		SegmentExplanations: route.SegmentExplanations,
	}
	payload, _ := json.Marshal(projection)
	return hashBytes(payload)
}

func computeRegressionSignature(route *domain.TransmissionRoute) string {
	payload, _ := json.Marshal(struct {
		AlgorithmVersion string `json:"algorithm_version"`
		RouteFingerprint string `json:"route_fingerprint"`
		TowerCount       int    `json:"tower_count"`
		SegmentCount     int    `json:"segment_count"`
	}{
		AlgorithmVersion: transmissionAlgorithmVersion,
		RouteFingerprint: computeRouteFingerprint(route),
		TowerCount:       len(route.TowerPositions),
		SegmentCount:     len(route.SegmentExplanations),
	})
	return hashBytes(payload)
}

func hashBytes(payload []byte) string {
	digest := sha256.Sum256(payload)
	return hex.EncodeToString(digest[:])
}

