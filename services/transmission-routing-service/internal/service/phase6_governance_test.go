package service

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/repository"
)

type fakeTransmissionRepo struct {
	routes map[uuid.UUID]*domain.TransmissionRoute
}

func newFakeTransmissionRepo(routes ...*domain.TransmissionRoute) *fakeTransmissionRepo {
	store := map[uuid.UUID]*domain.TransmissionRoute{}
	for _, route := range routes {
		store[route.ID] = cloneRoute(route)
	}
	return &fakeTransmissionRepo{routes: store}
}

func (f *fakeTransmissionRepo) Create(_ context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	f.routes[route.ID] = cloneRoute(route)
	return cloneRoute(route), nil
}

func (f *fakeTransmissionRepo) GetByID(_ context.Context, id uuid.UUID) (*domain.TransmissionRoute, error) {
	route, ok := f.routes[id]
	if !ok {
		return nil, repository.ErrNotFound
	}
	return cloneRoute(route), nil
}

func (f *fakeTransmissionRepo) ListByProject(_ context.Context, projectID uuid.UUID) ([]domain.TransmissionRoute, error) {
	routes := []domain.TransmissionRoute{}
	for _, route := range f.routes {
		if route.ProjectID == projectID {
			routes = append(routes, *cloneRoute(route))
		}
	}
	return routes, nil
}

func (f *fakeTransmissionRepo) Delete(_ context.Context, id uuid.UUID) error {
	delete(f.routes, id)
	return nil
}

func (f *fakeTransmissionRepo) SubmitForReview(_ context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	f.routes[route.ID] = cloneRoute(route)
	return cloneRoute(route), nil
}

func (f *fakeTransmissionRepo) Approve(_ context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	f.routes[route.ID] = cloneRoute(route)
	return cloneRoute(route), nil
}

func (f *fakeTransmissionRepo) Reject(_ context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	f.routes[route.ID] = cloneRoute(route)
	return cloneRoute(route), nil
}

func cloneRoute(route *domain.TransmissionRoute) *domain.TransmissionRoute {
	payload, _ := json.Marshal(route)
	var cloned domain.TransmissionRoute
	_ = json.Unmarshal(payload, &cloned)
	return &cloned
}

func phase6TestRoute() *domain.TransmissionRoute {
	routeID := uuid.New()
	projectID := uuid.New()
	route := &domain.TransmissionRoute{
		ID:                  routeID,
		ProjectID:           projectID,
		Name:                "Phase6 Route",
		VoltageClass:        domain.VoltageClass132kV,
		PathGeoJSON:         `{"type":"LineString","coordinates":[[0,0,0],[0.001,0,0],[0.002,0,0]]}`,
		DistanceM:           220,
		ApprovalStatus:      domain.ApprovalStatusDraft,
		TowerPositions:      []domain.TowerPosition{{Lon: 0, Lat: 0, Elevation: 0, SpanToNextM: 110, HeightM: 20}, {Lon: 0.001, Lat: 0, Elevation: 0, SpanToNextM: 110, HeightM: 22}, {Lon: 0.002, Lat: 0, Elevation: 0, SpanToNextM: 0, HeightM: 20}},
		SegmentExplanations: []domain.SegmentExplanation{{FromIndex: 0, LandType: "underground_cable", DecisionReason: "blocked overhead"}, {FromIndex: 1, LandType: "overhead", DecisionReason: "clear corridor"}},
		CostBreakdown:       domain.CostBreakdown{ConductorCost: 100, TowerCost: 200, RowAcquisitionCost: 50, CrossingPremium: 25, TotalCost: 375, CostPerKm: 1704},
		RouteScore:          &domain.RouteScore{CostScore: 0.8, RiskScore: 0.7, ConstructabilityScore: 0.9, ScheduleScore: 0.85, CompositeScore: 0.805, RecommendationReason: "Balanced route."},
		Metadata:            map[string]interface{}{},
	}
	snapshot := domain.DataSourceSnapshot{SnapshotID: "snap-123", SnapshotAt: time.Now().UTC()}
	req := domain.CalculateTransmissionRouteRequest{ProjectID: projectID, Name: route.Name, VoltageClass: route.VoltageClass, ElevationRaster: domain.ElevationRaster{Width: 2, Height: 2, CellSizeM: 100, Elevations: []float64{0, 0, 0, 0}}}
	_ = populateRouteTraceability(route, req, snapshot)
	return route
}

func TestPhase6SubmitForReviewTransitionsDraftRoute(t *testing.T) {
	route := phase6TestRoute()
	repo := newFakeTransmissionRepo(route)
	svc := NewTransmissionService(nil, "", "", "")
	svc.repo = repo

	updated, err := svc.SubmitTransmissionRouteForReview(context.Background(), route.ID, "planner", "initial engineering handoff")
	if err != nil {
		t.Fatalf("submit for review failed: %v", err)
	}
	if updated.ApprovalStatus != domain.ApprovalStatusEngineeringReview {
		t.Fatalf("expected engineering review status, got %s", updated.ApprovalStatus)
	}
	if updated.EngineeringReviewedBy != "planner" {
		t.Fatalf("expected reviewer planner, got %s", updated.EngineeringReviewedBy)
	}
	if len(updated.GovernanceEvents) == 0 || updated.GovernanceEvents[len(updated.GovernanceEvents)-1].EventType != "submitted_for_review" {
		t.Fatal("expected submitted_for_review governance event")
	}
}

func TestPhase6ApproveRouteRequiresReviewAndTraceability(t *testing.T) {
	route := phase6TestRoute()
	repo := newFakeTransmissionRepo(route)
	svc := NewTransmissionService(nil, "", "", "")
	svc.repo = repo

	if _, err := svc.ApproveTransmissionRoute(context.Background(), route.ID, "approver", "skip review"); err == nil {
		t.Fatal("expected approval to fail before engineering review")
	}

	_, err := svc.SubmitTransmissionRouteForReview(context.Background(), route.ID, "planner", "reviewed")
	if err != nil {
		t.Fatalf("submit for review failed: %v", err)
	}
	approved, err := svc.ApproveTransmissionRoute(context.Background(), route.ID, "approver", "approved for delivery")
	if err != nil {
		t.Fatalf("approve route failed: %v", err)
	}
	if approved.ApprovalStatus != domain.ApprovalStatusApproved {
		t.Fatalf("expected approved status, got %s", approved.ApprovalStatus)
	}
	if approved.ApprovedBy != "approver" {
		t.Fatalf("expected approved by approver, got %s", approved.ApprovedBy)
	}
	traceability, err := extractTraceability(approved.Metadata)
	if err != nil {
		t.Fatalf("expected traceability in approved metadata: %v", err)
	}
	if traceability.ApprovedBy != "approver" {
		t.Fatalf("expected traceability approved_by approver, got %s", traceability.ApprovedBy)
	}
}

func TestPhase6ExportPackBuildsGovernedArtifacts(t *testing.T) {
	route := phase6TestRoute()
	now := time.Now().UTC()
	route.ApprovalStatus = domain.ApprovalStatusApproved
	route.ApprovedAt = &now
	route.ApprovedBy = "approver"
	traceability, err := extractTraceability(route.Metadata)
	if err != nil {
		t.Fatalf("extract traceability: %v", err)
	}
	traceability.ApprovedAt = now
	traceability.ApprovedBy = "approver"
	route.Metadata["traceability"] = traceability
	repo := newFakeTransmissionRepo(route)
	svc := NewTransmissionService(nil, "", "", "")
	svc.repo = repo

	pack, err := svc.ExportTransmissionRoutePack(context.Background(), route.ID, "delivery-bot")
	if err != nil {
		t.Fatalf("export pack failed: %v", err)
	}
	if len(pack.TowerSchedule) != len(route.TowerPositions) {
		t.Fatalf("expected %d tower schedule entries, got %d", len(route.TowerPositions), len(pack.TowerSchedule))
	}
	if len(pack.UndergroundChainage) != 1 {
		t.Fatalf("expected 1 underground chainage entry, got %d", len(pack.UndergroundChainage))
	}
	if len(pack.CostBook) < 5 {
		t.Fatalf("expected populated cost book, got %d entries", len(pack.CostBook))
	}
	if pack.Traceability.RouteFingerprint == "" || pack.Traceability.InputFingerprint == "" {
		t.Fatal("expected traceability fingerprints in export pack")
	}
	if pack.GeneratedBy != "delivery-bot" {
		t.Fatalf("expected generated by delivery-bot, got %s", pack.GeneratedBy)
	}
}

func TestPhase6RejectsTamperedTraceabilityBundle(t *testing.T) {
	route := phase6TestRoute()
	traceability, err := extractTraceability(route.Metadata)
	if err != nil {
		t.Fatalf("extract traceability: %v", err)
	}
	traceability.AlgorithmVersion = "transmission-routing-phase5.0.0"
	route.Metadata["traceability"] = traceability
	repo := newFakeTransmissionRepo(route)
	svc := NewTransmissionService(nil, "", "", "")
	svc.repo = repo

	if _, err := svc.SubmitTransmissionRouteForReview(context.Background(), route.ID, "planner", "review"); err == nil {
		t.Fatal("expected tampered traceability to block engineering review")
	}
}
