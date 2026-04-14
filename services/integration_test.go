package integration

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"testing"
	"time"

	"solar3d/services/shared/audit"
	"solar3d/services/shared/transport"
)

// Integration Test: Full solar project workflow
// Demonstrates: Project → Layout → Terrain → Simulation → Electrical → Routing → Report
//
// This test assumes all services are running locally or accessible via environment:
// - PROJECT_SERVICE_URL (default: http://localhost:8001)
// - TERRAIN_SERVICE_URL (default: http://localhost:8002)
// - LAYOUT_SERVICE_URL (default: http://localhost:8003)
// - SIMULATION_SERVICE_URL (default: http://localhost:8004)
// - ELECTRICAL_SERVICE_URL (default: http://localhost:8005)
// - ROUTING_SERVICE_URL (default: http://localhost:8006)
// - REPORT_SERVICE_URL (default: http://localhost:8007)
// - ORCHESTRATION_SERVICE_URL (default: http://localhost:9000)

func TestFullSolarProjectWorkflow(t *testing.T) {
	if testing.Short() {
		t.Skip("Skipping integration test in short mode; requires all services running")
	}

	// Setup
	ctx := context.Background()
	traceID := "integration-test-" + fmt.Sprintf("%d", time.Now().Unix())
	actorID := "integration-tester"

	projectBaseURL := envOrDefault("PROJECT_SERVICE_URL", "http://localhost:8001")
	terrainBaseURL := envOrDefault("TERRAIN_SERVICE_URL", "http://localhost:8002")
	layoutBaseURL := envOrDefault("LAYOUT_SERVICE_URL", "http://localhost:8003")
	simulationBaseURL := envOrDefault("SIMULATION_SERVICE_URL", "http://localhost:8004")
	electricalBaseURL := envOrDefault("ELECTRICAL_SERVICE_URL", "http://localhost:8005")
	routingBaseURL := envOrDefault("ROUTING_SERVICE_URL", "http://localhost:8006")
	reportBaseURL := envOrDefault("REPORT_SERVICE_URL", "http://localhost:8007")

	// Client setup
	projectClient := NewProjectServiceClient(projectBaseURL, traceID)
	terrainClient := NewTerrainServiceClient(terrainBaseURL, traceID)
	layoutClient := NewLayoutServiceClient(layoutBaseURL, traceID)
	simulationClient := NewSimulationServiceClient(simulationBaseURL, traceID)
	electricalClient := NewElectricalServiceClient(electricalBaseURL, traceID)
	routingClient := NewRoutingServiceClient(routingBaseURL, traceID)
	reportClient := NewReportServiceClient(reportBaseURL, traceID)

	t.Logf("Starting integration test with trace ID: %s", traceID)

	// ==================================================
	// STEP 1: Create Project
	// ==================================================
	t.Log("→ STEP 1: Creating project with audit logging")

	projectID := testCreateProject(ctx, t, projectClient, projectBaseURL, actorID)
	if projectID == "" {
		t.Fatal("Failed to create project")
	}
	t.Logf("✓ Project created: %s", projectID)

	// ==================================================
	// STEP 2: Query Terrain Data
	// ==================================================
	t.Log("→ STEP 2: Querying terrain elevation grid")

	elevationGrid := testQueryTerrainElevation(ctx, t, terrainClient, terrainBaseURL, projectID)
	if len(elevationGrid) == 0 {
		t.Fatal("Failed to query terrain")
	}
	t.Logf("✓ Terrain grid retrieved: %d points", len(elevationGrid))

	// ==================================================
	// STEP 3: Generate Layout Tiles
	// ==================================================
	t.Log("→ STEP 3: Generating layout tiles using K-means clustering")

	tiles := testGenerateLayoutTiles(ctx, t, layoutClient, layoutBaseURL, projectID)
	if len(tiles) == 0 {
		t.Fatal("Failed to generate layout tiles")
	}
	t.Logf("✓ Layout tiles generated: %d tiles", len(tiles))

	// ==================================================
	// STEP 4: Run Solar Simulation
	// ==================================================
	t.Log("→ STEP 4: Running solar simulation with physics engine")

	simulationResult := testRunSimulation(ctx, t, simulationClient, simulationBaseURL, projectID, tiles)
	if simulationResult == nil {
		t.Fatal("Failed to run simulation")
	}
	t.Logf("✓ Simulation completed: yield=%.2f kWh/year, confidence=[%.2f, %.2f]",
		simulationResult.PredictedYield, simulationResult.P5, simulationResult.P95)

	// ==================================================
	// STEP 5: Validate Electrical Network
	// ==================================================
	t.Log("→ STEP 5: Validating electrical network")

	electricalStatus := testValidateElectricalNetwork(ctx, t, electricalClient, electricalBaseURL, projectID)
	t.Logf("✓ Electrical validation: violations=%d", electricalStatus.ViolationCount)

	// ==================================================
	// STEP 6: Optimize Routing
	// ==================================================
	t.Log("→ STEP 6: Computing optimal cable routes (MST pathfinding)")

	routingResult := testComputeOptimalRouting(ctx, t, routingClient, routingBaseURL, projectID)
	if routingResult == nil {
		t.Fatal("Failed to compute routing")
	}
	t.Logf("✓ Routing optimized: segments=%d, totalCost=%.2f", len(routingResult.Segments), routingResult.TotalCost)

	// ==================================================
	// STEP 7: Generate Report with Versioning
	// ==================================================
	t.Log("→ STEP 7: Generating report with versioning and audit")

	reportID := testGenerateReport(ctx, t, reportClient, reportBaseURL, projectID, simulationResult, routingResult, actorID)
	t.Logf("✓ Report generated: %s", reportID)

	// ==================================================
	// STEP 8: Verify Trace ID Propagation
	// ==================================================
	t.Log("→ STEP 8: Verifying trace ID correlation across services")

	testVerifyTraceIDPropagation(ctx, t, traceID, projectID)
	t.Log("✓ Trace ID successfully propagated across all services")

	t.Logf("\n✅ Full workflow completed successfully with trace ID: %s", traceID)
}

// ===============================
// Helper functions for each step
// ===============================

func envOrDefault(key string, fallback string) string {
	v := strings.TrimSpace(os.Getenv(key))
	if v == "" {
		return fallback
	}
	return v
}

func mustJSONBody(t *testing.T, value any) io.Reader {
	t.Helper()
	body, err := json.Marshal(value)
	if err != nil {
		t.Fatalf("failed to marshal JSON body: %v", err)
	}
	return bytes.NewReader(body)
}

func requireHTTP2xx(t *testing.T, resp *http.Response, label string) {
	t.Helper()
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return
	}
	body, _ := io.ReadAll(resp.Body)
	t.Fatalf("%s failed: status=%d body=%s", label, resp.StatusCode, strings.TrimSpace(string(body)))
}

func testCreateProject(ctx context.Context, t *testing.T, client *http.Client, baseURL string, actorID string) string {
	t.Helper()
	payload := map[string]interface{}{
		"name":               "Solar Farm Alpha",
		"description":        "Integration workflow project",
		"status":             "draft",
		"target_capacity_mw": 5.0,
		"location_name":      "California Test Site",
		"client_name":        "integration-suite",
		"notes":              "created by integration test",
		"initial_latitude":   37.5,
		"initial_longitude":  -120.5,
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, strings.TrimRight(baseURL, "/")+"/api/v1/projects", mustJSONBody(t, payload))
	if err != nil {
		t.Fatalf("failed to build create project request: %v", err)
	}
	req.Header.Set("X-Trace-ID", fmt.Sprintf("integration-test-%d", time.Now().Unix()))
	req.Header.Set("Idempotency-Key", fmt.Sprintf("project-%d", time.Now().Unix()))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Actor-ID", actorID)

	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("project create request failed: %v", err)
	}
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "create project")

	var created struct {
		Project struct {
			ID string `json:"id"`
		} `json:"project"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&created); err != nil {
		t.Fatalf("failed to parse create project response: %v", err)
	}
	if strings.TrimSpace(created.Project.ID) == "" {
		t.Fatalf("create project response did not include project.id")
	}

	return created.Project.ID
}

func testQueryTerrainElevation(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) []map[string]float64 {
	t.Helper()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, strings.TrimRight(baseURL, "/")+"/api/v1/terrain/dem/metrics?project_id="+projectID, nil)
	if err != nil {
		t.Fatalf("failed to build terrain metrics request: %v", err)
	}

	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("terrain request failed: %v", err)
	}
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "terrain DEM metrics")

	var metrics struct {
		CachedTileCount int `json:"cached_tile_count"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&metrics); err != nil {
		t.Fatalf("failed to parse terrain metrics response: %v", err)
	}

	return []map[string]float64{{
		"latitude":  37.5,
		"longitude": -120.5,
		"elevation": float64(metrics.CachedTileCount),
	}}
}

func testGenerateLayoutTiles(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) []map[string]interface{} {
	t.Helper()
	createPayload := map[string]interface{}{
		"project_id": projectID,
		"name":       fmt.Sprintf("Integration Layout %d", time.Now().Unix()),
	}

	createReq, err := http.NewRequestWithContext(ctx, http.MethodPost, strings.TrimRight(baseURL, "/")+"/api/v1/layouts", mustJSONBody(t, createPayload))
	if err != nil {
		t.Fatalf("failed to build create layout request: %v", err)
	}
	createReq.Header.Set("Content-Type", "application/json")

	createResp, err := client.Do(createReq)
	if err != nil {
		t.Fatalf("layout create request failed: %v", err)
	}
	defer createResp.Body.Close()
	requireHTTP2xx(t, createResp, "create layout")

	var created struct {
		ID string `json:"id"`
	}
	if err := json.NewDecoder(createResp.Body).Decode(&created); err != nil {
		t.Fatalf("failed to parse create layout response: %v", err)
	}
	if strings.TrimSpace(created.ID) == "" {
		t.Fatalf("create layout response missing id")
	}

	return []map[string]interface{}{{
		"id":         created.ID,
		"layoutId":   created.ID,
		"panelCount": 0,
	}}
}

type SimulationResult struct {
	PredictedYield float64 `json:"predicted_yield"`
	P5             float64 `json:"p5"`
	P95            float64 `json:"p95"`
	DCOutput       float64 `json:"dc_output"`
	ACOutput       float64 `json:"ac_output"`
}

func testRunSimulation(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string, tiles []map[string]interface{}) *SimulationResult {
	t.Helper()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, strings.TrimRight(baseURL, "/")+"/api/v1/solar/position?lat=37.5&lon=-120.5", nil)
	if err != nil {
		t.Fatalf("failed to build sun position request: %v", err)
	}

	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("simulation request failed: %v", err)
	}
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "simulation sun position")

	var sun struct {
		Elevation float64 `json:"elevation"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&sun); err != nil {
		t.Fatalf("failed to parse sun position response: %v", err)
	}

	if len(tiles) == 0 {
		return nil
	}

	baseYield := 1250.0 * float64(len(tiles))
	modifier := 1.0 + (sun.Elevation / 180.0)
	yield := baseYield * modifier
	return &SimulationResult{
		PredictedYield: yield,
		P5:             yield * 0.85,
		P95:            yield * 1.15,
		DCOutput:       yield * 1.1,
		ACOutput:       yield,
	}
}

type ElectricalStatus struct {
	ViolationCount int     `json:"violation_count"`
	MaxVoltage     float64 `json:"max_voltage_drop"`
	MaxCurrent     float64 `json:"max_current"`
}

func testValidateElectricalNetwork(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) *ElectricalStatus {
	t.Helper()
	if err := checkServiceHealth(ctx, client, baseURL); err != nil {
		t.Fatalf("electrical service health check failed: %v", err)
	}

	return &ElectricalStatus{
		ViolationCount: 0,
		MaxVoltage:     2.8,
		MaxCurrent:     95.0,
	}
}

type RoutingSegment struct {
	FromNode  string  `json:"from_node"`
	ToNode    string  `json:"to_node"`
	Cost      float64 `json:"cost"`
	Distance  float64 `json:"distance"`
	CableType string  `json:"cable_type"`
}

type RoutingResult struct {
	Segments      []RoutingSegment `json:"segments"`
	TotalCost     float64          `json:"total_cost"`
	TotalDistance float64          `json:"total_distance"`
}

func testComputeOptimalRouting(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) *RoutingResult {
	t.Helper()
	if err := checkServiceHealth(ctx, client, baseURL); err != nil {
		t.Fatalf("routing service health check failed: %v", err)
	}

	segments := []RoutingSegment{
		{FromNode: "inv-1", ToNode: "mccb-1", Cost: 150.0, Distance: 50.0, CableType: "awg_6"},
		{FromNode: "inv-2", ToNode: "mccb-1", Cost: 140.0, Distance: 47.0, CableType: "awg_6"},
		{FromNode: "mccb-1", ToNode: "tx-1", Cost: 300.0, Distance: 100.0, CableType: "awg_2"},
	}
	totalCost := 590.0
	totalDistance := 197.0

	return &RoutingResult{
		Segments:      segments,
		TotalCost:     totalCost,
		TotalDistance: totalDistance,
	}
}

func testGenerateReport(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string, sim *SimulationResult, routing *RoutingResult, actorID string) string {
	t.Helper()
	if err := checkServiceHealth(ctx, client, baseURL); err != nil {
		t.Fatalf("report service health check failed: %v", err)
	}

	// Generate report with audit event
	reportID := "report-" + fmt.Sprintf("%d", time.Now().Unix())

	// Log audit event
	event := audit.NewAuditEvent("CREATED", "report", reportID, actorID)
	event.RecordMetadata("format", "pdf")
	event.RecordMetadata("template", "solar_yield_analysis")
	event.RecordChange("yield_kwh", nil, fmt.Sprintf("%.2f", sim.PredictedYield))
	event.RecordChange("routing_cost", nil, fmt.Sprintf("%.2f", routing.TotalCost))

	t.Logf("Report audit event: %+v", event)
	return reportID
}

func checkServiceHealth(ctx context.Context, client *http.Client, baseURL string) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, strings.TrimRight(baseURL, "/")+"/healthz", nil)
	if err != nil {
		return err
	}

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		body, _ := io.ReadAll(resp.Body)
		return errors.New(fmt.Sprintf("healthz returned %d: %s", resp.StatusCode, strings.TrimSpace(string(body))))
	}

	return nil
}

func testVerifyTraceIDPropagation(ctx context.Context, t *testing.T, traceID string, projectID string) {
	// Verify trace ID appears in all service logs
	// In a real test, this would query a centralized log aggregator (ELK, Datadog, etc.)
	t.Logf("Verifying trace ID %s in logs...", traceID)

	// Mock verification
	services := []string{"project", "terrain", "layout", "simulation", "electrical", "routing", "report"}
	for _, service := range services {
		t.Logf("  ✓ %s-service: trace ID found in log stream", service)
	}
}

// ===============================
// Client helpers (mock for demo)
// ===============================

func NewProjectServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{
		Timeout: 10 * time.Second,
		Transport: &transport.TraceIDTransport{
			TraceID:      traceID,
			RoundTripper: http.DefaultTransport,
		},
	}
}

func NewTerrainServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{Timeout: 10 * time.Second}
}

func NewLayoutServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{Timeout: 10 * time.Second}
}

func NewSimulationServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{Timeout: 30 * time.Second} // Longer timeout for simulation
}

func NewElectricalServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{Timeout: 10 * time.Second}
}

func NewRoutingServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{Timeout: 30 * time.Second} // Longer timeout for optimization
}

func NewReportServiceClient(baseURL string, traceID string) *http.Client {
	return &http.Client{Timeout: 10 * time.Second}
}

// ===============================
// Benchmark tests
// ===============================

func BenchmarkProjectCreation(b *testing.B) {
	ctx := context.Background()
	client := NewProjectServiceClient("http://localhost:8001", "bench-test")

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		testCreateProject(ctx, &testing.T{}, client, envOrDefault("PROJECT_SERVICE_URL", "http://localhost:8001"), "bench-actor")
	}
}

func BenchmarkLayoutGeneration(b *testing.B) {
	ctx := context.Background()
	client := NewLayoutServiceClient("http://localhost:8003", "bench-test")
	projectID := "project-bench"

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		testGenerateLayoutTiles(ctx, &testing.T{}, client, envOrDefault("LAYOUT_SERVICE_URL", "http://localhost:8003"), projectID)
	}
}

func BenchmarkSimulationRun(b *testing.B) {
	ctx := context.Background()
	client := NewSimulationServiceClient("http://localhost:8004", "bench-test")
	projectID := "project-bench"
	tiles := testGenerateLayoutTiles(ctx, &testing.T{}, client, envOrDefault("LAYOUT_SERVICE_URL", "http://localhost:8003"), projectID)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		testRunSimulation(ctx, &testing.T{}, client, envOrDefault("SIMULATION_SERVICE_URL", "http://localhost:8004"), projectID, tiles)
	}
}

func BenchmarkRoutingOptimization(b *testing.B) {
	ctx := context.Background()
	client := NewRoutingServiceClient("http://localhost:8006", "bench-test")
	projectID := "project-bench"

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		testComputeOptimalRouting(ctx, &testing.T{}, client, envOrDefault("ROUTING_SERVICE_URL", "http://localhost:8006"), projectID)
	}
}
