package executor

import (
	"context"
	"encoding/json"
	"strings"
	"testing"

	"connectrpc.com/connect"
	commissioningv1 "github.com/solar3d/solar3d/gen/commissioning/v1"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	geov1 "github.com/solar3d/solar3d/gen/geo/v1"
	graphv1 "github.com/solar3d/solar3d/gen/graph/v1"
	mlinferencev1 "github.com/solar3d/solar3d/gen/ml_inference/v1"
	optimizationv1 "github.com/solar3d/solar3d/gen/optimization/v1"
	protectionv1 "github.com/solar3d/solar3d/gen/protection/v1"
	simulationv1 "github.com/solar3d/solar3d/gen/simulation/v1"
	structuralv1 "github.com/solar3d/solar3d/gen/structural/v1"

	"solar3d/compute-orchestration-service/internal/domain"
)

func TestExecuteAdvancedAnalyticsWorkflowSuccess(t *testing.T) {
	exec := &ComputeExecutor{
		simulationClient:   &mockSimulationClient{resp: &simulationv1.RunSimulationResponse{Simulation: &simulationv1.Simulation{Result: &simulationv1.SimulationResult{AnnualYieldKwh: 812.4}}}},
		optimizationClient: &mockOptimizationClient{psoResp: &optimizationv1.PSOResponse{BestValue: 0.92, BestPosition: 11.2, IterationsCompleted: 6}},
		geoClient:          &mockGeoClient{bufferResp: &geov1.BufferPointResponse{Polygon: &geov1.Polygon{Ring: []*geov1.Point2D{{X: 0, Y: 0}, {X: 1, Y: 1}}}}},
		graphClient:        &mockGraphClient{mstResp: &graphv1.MinimumSpanningTreeResponse{Edges: []*graphv1.GraphEdge{{U: 0, V: 1, Weight: 1}}}},
		mlClient:           &mockMLClient{yieldResp: &mlinferencev1.YieldPredictionResponse{Forecast: &mlinferencev1.YieldForecast{PredictedYieldKwh: 801.1}}},
		plotClient:         &mockPlotClient{resp: &drawingv1.PublishDrawingResponse{ManifestJson: `{"version":"v1"}`, Artifacts: []*drawingv1.PublishedSheetArtifact{{FileName: "sheet-a.pdf", Payload: []byte("pdf-data")}}}},
	}

	payload := advancedAnalyticsWorkflowPayload{
		Workflow:      "advanced_analytics_v1",
		ProjectID:     "project-1",
		DrawingID:     "drawing-1",
		RevisionID:    "revision-1",
		SheetIDs:      []string{"sheet-1"},
		PublishFormat: "pdf",
		Geo: &geoWorkflowInput{
			Center:   &geov1.Point2D{X: -122.2, Y: 37.4},
			Radius:   25,
			Segments: 16,
		},
		Graph: &graphWorkflowInput{
			NodeCount: 3,
			Edges: []*graphv1.GraphEdge{
				{U: 0, V: 1, Weight: 1.0},
				{U: 1, V: 2, Weight: 1.5},
			},
		},
		Optimization: &optimizationWorkflowInput{Method: "pso", PSO: &optimizationv1.PSORequest{NumParticles: 8, Iterations: 6, C1: 1.1, C2: 1.2, W: 0.7, BoundaryMin: 0, BoundaryMax: 1}},
		Simulation:   &simulationWorkflowInput{SimulationID: "sim-1"},
		ML:           &mlWorkflowInput{FeatureNames: []string{"a", "b", "c"}, Features: []float64{0.1, 0.2, 0.3}},
	}
	payloadJSON, err := json.Marshal(payload)
	if err != nil {
		t.Fatalf("marshal payload: %v", err)
	}

	artifacts, err := exec.Execute(context.Background(), &domain.Job{ID: "job-1", Type: domain.JobTypeCustom, PayloadJSON: string(payloadJSON)})
	if err != nil {
		t.Fatalf("execute advanced workflow failed: %v", err)
	}
	if len(artifacts) < 8 {
		t.Fatalf("expected at least 8 artifacts, got %d", len(artifacts))
	}

	requiredKinds := []string{"geo_buffer", "graph_topology", "optimization_result", "simulation_result", "ml_yield_prediction", "publish_manifest", "published_sheet", "workflow_summary"}
	for _, kind := range requiredKinds {
		if !hasArtifactKind(artifacts, kind) {
			t.Fatalf("expected artifact kind %q", kind)
		}
	}
}

func TestExecuteAdvancedAnalyticsWorkflowValidation(t *testing.T) {
	exec := &ComputeExecutor{}
	payload := advancedAnalyticsWorkflowPayload{
		Workflow:   "advanced_analytics_v1",
		ProjectID:  "project-1",
		RevisionID: "revision-1",
		SheetIDs:   []string{"sheet-1"},
		Geo:        &geoWorkflowInput{Center: &geov1.Point2D{X: 0, Y: 0}, Radius: 10},
		Graph:      &graphWorkflowInput{NodeCount: 2, Edges: []*graphv1.GraphEdge{{U: 0, V: 1, Weight: 1}}},
		Optimization: &optimizationWorkflowInput{
			Method: "pso",
		},
		Simulation: &simulationWorkflowInput{SimulationID: "sim-1"},
		ML:         &mlWorkflowInput{},
	}
	payloadJSON, err := json.Marshal(payload)
	if err != nil {
		t.Fatalf("marshal payload: %v", err)
	}

	_, err = exec.Execute(context.Background(), &domain.Job{ID: "job-2", Type: domain.JobTypeCustom, PayloadJSON: string(payloadJSON)})
	if err == nil {
		t.Fatal("expected validation error")
	}
	if !strings.Contains(err.Error(), "drawing_id") {
		t.Fatalf("expected drawing_id validation error, got: %v", err)
	}
}

func TestExecutePublishSuccess(t *testing.T) {
	exec := &ComputeExecutor{
		plotClient: &mockPlotClient{resp: &drawingv1.PublishDrawingResponse{
			ManifestJson: `{"ok":true}`,
			Artifacts: []*drawingv1.PublishedSheetArtifact{
				{FileName: "sheet-01.svg", Payload: []byte("svg")},
			},
		}},
	}
	payload := publishWorkflowInput{DrawingID: "drawing-1", RevisionID: "rev-2", SheetIDs: []string{"sheet-1"}, PublishFormat: "svg"}
	payloadJSON, _ := json.Marshal(payload)

	artifacts, err := exec.Execute(context.Background(), &domain.Job{ID: "job-3", Type: domain.JobTypePublish, PayloadJSON: string(payloadJSON)})
	if err != nil {
		t.Fatalf("execute publish failed: %v", err)
	}
	if len(artifacts) != 2 {
		t.Fatalf("expected 2 artifacts, got %d", len(artifacts))
	}
	if !hasArtifactKind(artifacts, "publish_manifest") {
		t.Fatal("missing publish_manifest artifact")
	}
	if !hasArtifactKind(artifacts, "published_sheet") {
		t.Fatal("missing published_sheet artifact")
	}
}

func TestExecuteStructuralStudySuccess(t *testing.T) {
	exec := &ComputeExecutor{
		structuralClient: &mockStructuralClient{deadLoadResp: &structuralv1.ComputeDeadLoadResponse{DeadLoadKn: 12.3}},
	}
	payload := map[string]any{
		"operation":   "compute_dead_load",
		"design_id":   "design-1",
		"panel_count": 10,
	}
	payloadJSON, _ := json.Marshal(payload)

	artifacts, err := exec.Execute(context.Background(), &domain.Job{ID: "job-struct-1", Type: domain.JobTypeStructural, PayloadJSON: string(payloadJSON)})
	if err != nil {
		t.Fatalf("execute structural study failed: %v", err)
	}
	if !hasArtifactKind(artifacts, "structural_compute_dead_load") {
		t.Fatalf("expected structural artifact kind, got %+v", artifacts)
	}
}

func TestExecuteProtectionStudySuccess(t *testing.T) {
	exec := &ComputeExecutor{
		protectionClient: &mockProtectionClient{shortCircuitResp: &protectionv1.ComputeShortCircuitResponse{IFault_3PhKa: 8.7}},
	}
	payload := map[string]any{
		"operation":            "short_circuit",
		"study_id":             "study-1",
		"voltage_kv":           11.0,
		"source_impedance_ohm": 0.4,
		"cable_resistance_ohm": 0.1,
		"cable_reactance_ohm":  0.2,
	}
	payloadJSON, _ := json.Marshal(payload)

	artifacts, err := exec.Execute(context.Background(), &domain.Job{ID: "job-prot-1", Type: domain.JobTypeProtection, PayloadJSON: string(payloadJSON)})
	if err != nil {
		t.Fatalf("execute protection study failed: %v", err)
	}
	if !hasArtifactKind(artifacts, "protection_short_circuit") {
		t.Fatalf("expected protection artifact kind, got %+v", artifacts)
	}
}

func hasArtifactKind(artifacts []domain.Artifact, kind string) bool {
	for _, artifact := range artifacts {
		if artifact.Kind == kind {
			return true
		}
	}
	return false
}

type mockSimulationClient struct {
	resp *simulationv1.RunSimulationResponse
	err  error
}

func (m *mockSimulationClient) RunSimulation(ctx context.Context, req *connect.Request[simulationv1.RunSimulationRequest]) (*connect.Response[simulationv1.RunSimulationResponse], error) {
	if m.err != nil {
		return nil, m.err
	}
	return connect.NewResponse(m.resp), nil
}

type mockOptimizationClient struct {
	psoResp *optimizationv1.PSOResponse
	gaResp  *optimizationv1.GAResponse
	mcResp  *optimizationv1.MonteCarloResponse
}

func (m *mockOptimizationClient) ParticleSwarmOptimization(ctx context.Context, req *connect.Request[optimizationv1.PSORequest]) (*connect.Response[optimizationv1.PSOResponse], error) {
	if m.psoResp == nil {
		m.psoResp = &optimizationv1.PSOResponse{}
	}
	return connect.NewResponse(m.psoResp), nil
}

func (m *mockOptimizationClient) GeneticAlgorithm(ctx context.Context, req *connect.Request[optimizationv1.GARequest]) (*connect.Response[optimizationv1.GAResponse], error) {
	if m.gaResp == nil {
		m.gaResp = &optimizationv1.GAResponse{}
	}
	return connect.NewResponse(m.gaResp), nil
}

func (m *mockOptimizationClient) MonteCarloSampling(ctx context.Context, req *connect.Request[optimizationv1.MonteCarloRequest]) (*connect.Response[optimizationv1.MonteCarloResponse], error) {
	if m.mcResp == nil {
		m.mcResp = &optimizationv1.MonteCarloResponse{}
	}
	return connect.NewResponse(m.mcResp), nil
}

type mockGeoClient struct {
	bufferResp  *geov1.BufferPointResponse
	contourResp *geov1.GenerateContoursResponse
}

func (m *mockGeoClient) BufferPoint(ctx context.Context, req *connect.Request[geov1.BufferPointRequest]) (*connect.Response[geov1.BufferPointResponse], error) {
	if m.bufferResp == nil {
		m.bufferResp = &geov1.BufferPointResponse{}
	}
	return connect.NewResponse(m.bufferResp), nil
}

func (m *mockGeoClient) GenerateContours(ctx context.Context, req *connect.Request[geov1.GenerateContoursRequest]) (*connect.Response[geov1.GenerateContoursResponse], error) {
	if m.contourResp == nil {
		m.contourResp = &geov1.GenerateContoursResponse{}
	}
	return connect.NewResponse(m.contourResp), nil
}

type mockGraphClient struct {
	mstResp     *graphv1.MinimumSpanningTreeResponse
	steinerResp *graphv1.ApproximateSteinerTreeResponse
}

func (m *mockGraphClient) MinimumSpanningTree(ctx context.Context, req *connect.Request[graphv1.MinimumSpanningTreeRequest]) (*connect.Response[graphv1.MinimumSpanningTreeResponse], error) {
	if m.mstResp == nil {
		m.mstResp = &graphv1.MinimumSpanningTreeResponse{}
	}
	return connect.NewResponse(m.mstResp), nil
}

func (m *mockGraphClient) ApproximateSteinerTree(ctx context.Context, req *connect.Request[graphv1.ApproximateSteinerTreeRequest]) (*connect.Response[graphv1.ApproximateSteinerTreeResponse], error) {
	if m.steinerResp == nil {
		m.steinerResp = &graphv1.ApproximateSteinerTreeResponse{}
	}
	return connect.NewResponse(m.steinerResp), nil
}

type mockMLClient struct {
	yieldResp *mlinferencev1.YieldPredictionResponse
}

func (m *mockMLClient) PredictYield(ctx context.Context, req *connect.Request[mlinferencev1.YieldPredictionRequest]) (*connect.Response[mlinferencev1.YieldPredictionResponse], error) {
	if m.yieldResp == nil {
		m.yieldResp = &mlinferencev1.YieldPredictionResponse{}
	}
	return connect.NewResponse(m.yieldResp), nil
}

type mockPlotClient struct {
	resp *drawingv1.PublishDrawingResponse
	err  error
}

type mockStructuralClient struct {
	deadLoadResp *structuralv1.ComputeDeadLoadResponse
}

func (m *mockStructuralClient) ComputeDeadLoad(ctx context.Context, req *connect.Request[structuralv1.ComputeDeadLoadRequest]) (*connect.Response[structuralv1.ComputeDeadLoadResponse], error) {
	if m.deadLoadResp == nil {
		m.deadLoadResp = &structuralv1.ComputeDeadLoadResponse{}
	}
	return connect.NewResponse(m.deadLoadResp), nil
}

func (m *mockStructuralClient) ComputeWindLoad(ctx context.Context, req *connect.Request[structuralv1.ComputeWindLoadRequest]) (*connect.Response[structuralv1.ComputeWindLoadResponse], error) {
	return connect.NewResponse(&structuralv1.ComputeWindLoadResponse{}), nil
}

func (m *mockStructuralClient) ComputeSeismicLoad(ctx context.Context, req *connect.Request[structuralv1.ComputeSeismicLoadRequest]) (*connect.Response[structuralv1.ComputeSeismicLoadResponse], error) {
	return connect.NewResponse(&structuralv1.ComputeSeismicLoadResponse{}), nil
}

func (m *mockStructuralClient) ComputeFoundationRequirement(ctx context.Context, req *connect.Request[structuralv1.ComputeFoundationRequirementRequest]) (*connect.Response[structuralv1.ComputeFoundationRequirementResponse], error) {
	return connect.NewResponse(&structuralv1.ComputeFoundationRequirementResponse{}), nil
}

func (m *mockStructuralClient) ValidateStructuralDesign(ctx context.Context, req *connect.Request[structuralv1.ValidateStructuralDesignRequest]) (*connect.Response[structuralv1.ValidateStructuralDesignResponse], error) {
	return connect.NewResponse(&structuralv1.ValidateStructuralDesignResponse{}), nil
}

func (m *mockStructuralClient) GenerateStructuralReport(ctx context.Context, req *connect.Request[structuralv1.GenerateStructuralReportRequest]) (*connect.Response[structuralv1.GenerateStructuralReportResponse], error) {
	return connect.NewResponse(&structuralv1.GenerateStructuralReportResponse{ReportText: "ok"}), nil
}

type mockProtectionClient struct {
	shortCircuitResp *protectionv1.ComputeShortCircuitResponse
}

func (m *mockProtectionClient) ComputeShortCircuit(ctx context.Context, req *connect.Request[protectionv1.ComputeShortCircuitRequest]) (*connect.Response[protectionv1.ComputeShortCircuitResponse], error) {
	if m.shortCircuitResp == nil {
		m.shortCircuitResp = &protectionv1.ComputeShortCircuitResponse{}
	}
	return connect.NewResponse(m.shortCircuitResp), nil
}

func (m *mockProtectionClient) ComputeEarthFault(ctx context.Context, req *connect.Request[protectionv1.ComputeEarthFaultRequest]) (*connect.Response[protectionv1.ComputeEarthFaultResponse], error) {
	return connect.NewResponse(&protectionv1.ComputeEarthFaultResponse{}), nil
}

func (m *mockProtectionClient) SelectRelay(ctx context.Context, req *connect.Request[protectionv1.SelectRelayRequest]) (*connect.Response[protectionv1.SelectRelayResponse], error) {
	return connect.NewResponse(&protectionv1.SelectRelayResponse{}), nil
}

func (m *mockProtectionClient) ComputeRelaySettings(ctx context.Context, req *connect.Request[protectionv1.ComputeRelaySettingsRequest]) (*connect.Response[protectionv1.ComputeRelaySettingsResponse], error) {
	return connect.NewResponse(&protectionv1.ComputeRelaySettingsResponse{}), nil
}

func (m *mockProtectionClient) ValidateCoordination(ctx context.Context, req *connect.Request[protectionv1.ValidateCoordinationRequest]) (*connect.Response[protectionv1.ValidateCoordinationResponse], error) {
	return connect.NewResponse(&protectionv1.ValidateCoordinationResponse{}), nil
}

func (m *mockProtectionClient) GenerateProtectionReport(ctx context.Context, req *connect.Request[protectionv1.GenerateProtectionReportRequest]) (*connect.Response[protectionv1.GenerateProtectionReportResponse], error) {
	return connect.NewResponse(&protectionv1.GenerateProtectionReportResponse{ReportText: "ok"}), nil
}

func (m *mockPlotClient) PublishDrawing(ctx context.Context, req *connect.Request[drawingv1.PublishDrawingRequest]) (*connect.Response[drawingv1.PublishDrawingResponse], error) {
	if m.err != nil {
		return nil, m.err
	}
	if m.resp == nil {
		m.resp = &drawingv1.PublishDrawingResponse{}
	}
	return connect.NewResponse(m.resp), nil
}

// ── Commissioning mock ──────────────────────────────────────────────────────

type mockCommissioningClient struct {
	signoffResp *commissioningv1.SignOffChecklistResponse
}

func (m *mockCommissioningClient) CreateChecklist(_ context.Context, _ *connect.Request[commissioningv1.CreateChecklistRequest]) (*connect.Response[commissioningv1.CreateChecklistResponse], error) {
	return connect.NewResponse(&commissioningv1.CreateChecklistResponse{}), nil
}

func (m *mockCommissioningClient) UpdateChecklistItem(_ context.Context, _ *connect.Request[commissioningv1.UpdateChecklistItemRequest]) (*connect.Response[commissioningv1.UpdateChecklistItemResponse], error) {
	return connect.NewResponse(&commissioningv1.UpdateChecklistItemResponse{}), nil
}

func (m *mockCommissioningClient) SignOffChecklist(_ context.Context, _ *connect.Request[commissioningv1.SignOffChecklistRequest]) (*connect.Response[commissioningv1.SignOffChecklistResponse], error) {
	if m.signoffResp != nil {
		return connect.NewResponse(m.signoffResp), nil
	}
	return connect.NewResponse(&commissioningv1.SignOffChecklistResponse{}), nil
}

func (m *mockCommissioningClient) CreateHandover(_ context.Context, _ *connect.Request[commissioningv1.CreateHandoverRequest]) (*connect.Response[commissioningv1.CreateHandoverResponse], error) {
	return connect.NewResponse(&commissioningv1.CreateHandoverResponse{}), nil
}

func (m *mockCommissioningClient) RecordAsBuilt(_ context.Context, _ *connect.Request[commissioningv1.RecordAsBuiltRequest]) (*connect.Response[commissioningv1.RecordAsBuiltResponse], error) {
	return connect.NewResponse(&commissioningv1.RecordAsBuiltResponse{}), nil
}

func (m *mockCommissioningClient) GenerateCommissioningReport(_ context.Context, _ *connect.Request[commissioningv1.GenerateCommissioningReportRequest]) (*connect.Response[commissioningv1.GenerateCommissioningReportResponse], error) {
	return connect.NewResponse(&commissioningv1.GenerateCommissioningReportResponse{ReportText: "Test commissioning report"}), nil
}

func TestExecuteCommissioningWorkflowSignoff(t *testing.T) {
	executor := &ComputeExecutor{
		commissioningClient: &mockCommissioningClient{},
	}
	payload, _ := json.Marshal(map[string]interface{}{
		"operation":    "signoff",
		"checklist_id": "cl-001",
		"signed_by":    "engineer@example.com",
		"role":         "Lead Engineer",
		"comments":     "All checks passed",
	})
	job := &domain.Job{
		ID:          "job-commissioning-01",
		Type:        domain.JobTypeCommissioning,
		PayloadJSON: string(payload),
	}
	artifacts, err := executor.Execute(context.Background(), job)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(artifacts) != 1 {
		t.Fatalf("expected 1 artifact, got %d", len(artifacts))
	}
	if !strings.HasPrefix(artifacts[0].Kind, "commissioning_") {
		t.Errorf("unexpected artifact kind: %s", artifacts[0].Kind)
	}
}

func TestExecuteCommissioningWorkflowReport(t *testing.T) {
	executor := &ComputeExecutor{
		commissioningClient: &mockCommissioningClient{},
	}
	payload, _ := json.Marshal(map[string]interface{}{
		"operation":    "generate_report",
		"checklist_id": "cl-001",
	})
	job := &domain.Job{
		ID:          "job-commissioning-02",
		Type:        domain.JobTypeCommissioning,
		PayloadJSON: string(payload),
	}
	artifacts, err := executor.Execute(context.Background(), job)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(artifacts) != 1 {
		t.Fatalf("expected 1 artifact, got %d", len(artifacts))
	}
	if !strings.Contains(string(artifacts[0].URI), "generate_report") {
		t.Errorf("unexpected artifact URI: %s", artifacts[0].URI)
	}
}
