package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"testing"
	"time"
)

func TestMonolithWorkflowHTTP(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping monolith workflow test in short mode")
	}

	baseURL := strings.TrimRight(envOrDefault("MONOLITH_BASE_URL", "http://127.0.0.1:9191"), "/")
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	client := &http.Client{Timeout: 10 * time.Second}

	if err := requireHealthy(ctx, client, baseURL); err != nil {
		if strings.EqualFold(strings.TrimSpace(os.Getenv("MONOLITH_REQUIRE_RUNNING")), "true") {
			t.Fatalf("monolith health check failed: %v", err)
		}
		t.Skipf("skipping monolith workflow test: monolith is not reachable at %s (%v)", baseURL, err)
	}
	verifyComputeOnlyRoutesMounted(ctx, t, client, baseURL)
	verifyDeferredServiceRoutesNotMounted(ctx, t, client, baseURL)

	projectID := createProject(ctx, t, client, baseURL)
	if projectID == "" {
		t.Fatal("create project returned empty id")
	}

	layoutID := createLayout(ctx, t, client, baseURL, projectID)
	if layoutID == "" {
		t.Fatal("create layout returned empty id")
	}

	verifyProjectInList(ctx, t, client, baseURL, projectID)
	verifyLayoutInProjectList(ctx, t, client, baseURL, projectID, layoutID)
	verifyTerrainMetrics(ctx, t, client, baseURL, projectID)

	cleanupProject(ctx, t, client, baseURL, projectID)
}

func envOrDefault(key string, fallback string) string {
	if v := strings.TrimSpace(os.Getenv(key)); v != "" {
		return v
	}
	return fallback
}

func requireHealthy(ctx context.Context, client *http.Client, baseURL string) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/healthz", nil)
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
		return fmt.Errorf("status=%d body=%s", resp.StatusCode, strings.TrimSpace(string(body)))
	}
	return nil
}

func createProject(ctx context.Context, t *testing.T, client *http.Client, baseURL string) string {
	t.Helper()

	payload := map[string]any{
		"name":               fmt.Sprintf("Monolith Integration %d", time.Now().UnixNano()),
		"description":        "integration workflow test",
		"status":             "draft",
		"target_capacity_mw": 2.5,
		"location_name":      "Workflow Test Site",
		"client_name":        "integration-suite",
		"notes":              "created by monolith workflow test",
		"initial_latitude":   17.385,
		"initial_longitude":  78.4867,
	}

	resp := doJSON(t, ctx, client, http.MethodPost, baseURL+"/api/v1/projects", payload)
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "create project")

	var out struct {
		Project struct {
			ID string `json:"id"`
		} `json:"project"`
	}
	decodeJSON(t, resp.Body, &out)
	return strings.TrimSpace(out.Project.ID)
}

func createLayout(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) string {
	t.Helper()
	payload := map[string]any{
		"project_id": projectID,
		"name":       fmt.Sprintf("Layout %d", time.Now().UnixNano()),
	}

	resp := doJSON(t, ctx, client, http.MethodPost, baseURL+"/api/v1/layouts", payload)
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "create layout")

	var out struct {
		ID string `json:"id"`
	}
	decodeJSON(t, resp.Body, &out)
	return strings.TrimSpace(out.ID)
}

func verifyProjectInList(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) {
	t.Helper()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/api/v1/projects?page_size=50", nil)
	if err != nil {
		t.Fatalf("failed to build list projects request: %v", err)
	}
	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("list projects request failed: %v", err)
	}
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "list projects")

	var out struct {
		Projects []struct {
			ID string `json:"id"`
		} `json:"projects"`
	}
	decodeJSON(t, resp.Body, &out)

	for _, p := range out.Projects {
		if p.ID == projectID {
			return
		}
	}
	t.Fatalf("created project %s not found in list", projectID)
}

func verifyLayoutInProjectList(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string, layoutID string) {
	t.Helper()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/api/v1/projects/"+projectID+"/layouts", nil)
	if err != nil {
		t.Fatalf("failed to build list layouts request: %v", err)
	}
	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("list layouts request failed: %v", err)
	}
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "list layouts")

	var out []struct {
		ID string `json:"id"`
	}
	decodeJSON(t, resp.Body, &out)

	for _, l := range out {
		if l.ID == layoutID {
			return
		}
	}
	t.Fatalf("created layout %s not found for project %s", layoutID, projectID)
}

func verifyTerrainMetrics(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) {
	t.Helper()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/api/v1/terrain/dem/metrics?project_id="+projectID, nil)
	if err != nil {
		t.Fatalf("failed to build terrain metrics request: %v", err)
	}
	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("terrain metrics request failed: %v", err)
	}
	defer resp.Body.Close()
	requireHTTP2xx(t, resp, "terrain metrics")

	var out map[string]any
	decodeJSON(t, resp.Body, &out)
	if _, ok := out["cached_tile_count"]; !ok {
		t.Fatalf("terrain metrics missing cached_tile_count field")
	}
}

func verifyComputeOnlyRoutesMounted(ctx context.Context, t *testing.T, client *http.Client, baseURL string) {
	t.Helper()

	// We intentionally send minimal payloads to verify route wiring only.
	// These requests may fail validation, but they must not return 404/501.
	routes := []string{
		"/terrain.v1.TerrainComputeService/GetElevation",
		"/terrain.v1.TerrainComputeService/GetElevationGrid",
		"/simulation.v1.SimulationComputeService/GetSunPosition",
		"/simulation.v1.SimulationComputeService/GetShadowMap",
		"/geo.v1.GeoService/BufferPoint",
		"/graph.v1.GraphService/MinimumSpanningTree",
		"/optimization.v1.OptimizationService/ParetoFrontier",
		"/ml_inference.v1.MLInferenceService/PredictYield",
		"/electrical.v1.ElectricalService/CreateNetwork",
		"/report.v1.ReportService/GenerateReport",
	}

	for _, route := range routes {
		req, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL+route, bytes.NewReader([]byte("{}")))
		if err != nil {
			t.Fatalf("failed to build request for %s: %v", route, err)
		}
		req.Header.Set("Content-Type", "application/json")

		resp, err := client.Do(req)
		if err != nil {
			t.Fatalf("route probe failed for %s: %v", route, err)
		}
		func() {
			defer resp.Body.Close()
			if resp.StatusCode == http.StatusNotFound || resp.StatusCode == http.StatusNotImplemented {
				body, _ := io.ReadAll(resp.Body)
				t.Fatalf("compute route %s not mounted correctly: status=%d body=%s", route, resp.StatusCode, strings.TrimSpace(string(body)))
			}
		}()
	}
}

func verifyDeferredServiceRoutesNotMounted(ctx context.Context, t *testing.T, client *http.Client, baseURL string) {
	t.Helper()

	// Phase 0 scope boundary: these dedicated services are explicitly deferred in monolith wiring.
	// Requests should return 404 when those handlers are not mounted.
	deferredRoutes := []string{
		"/commissioning.v1.CommissioningService/CreateChecklist",
		"/protection.v1.ProtectionService/CreateProtectionStudy",
		"/structural.v1.StructuralService/CreateDesign",
	}

	for _, route := range deferredRoutes {
		req, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL+route, bytes.NewReader([]byte("{}")))
		if err != nil {
			t.Fatalf("failed to build request for deferred route %s: %v", route, err)
		}
		req.Header.Set("Content-Type", "application/json")

		resp, err := client.Do(req)
		if err != nil {
			t.Fatalf("deferred route probe failed for %s: %v", route, err)
		}
		func() {
			defer resp.Body.Close()
			if resp.StatusCode != http.StatusNotFound {
				body, _ := io.ReadAll(resp.Body)
				t.Fatalf("deferred route %s unexpectedly mounted: status=%d body=%s", route, resp.StatusCode, strings.TrimSpace(string(body)))
			}
		}()
	}
}

func cleanupProject(ctx context.Context, t *testing.T, client *http.Client, baseURL string, projectID string) {
	t.Helper()
	req, err := http.NewRequestWithContext(ctx, http.MethodDelete, baseURL+"/api/v1/projects/"+projectID, nil)
	if err != nil {
		t.Logf("cleanup: failed to build delete project request: %v", err)
		return
	}
	resp, err := client.Do(req)
	if err != nil {
		t.Logf("cleanup: delete project request failed: %v", err)
		return
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		body, _ := io.ReadAll(resp.Body)
		t.Logf("cleanup: delete project returned status=%d body=%s", resp.StatusCode, strings.TrimSpace(string(body)))
	}
}

func doJSON(t *testing.T, ctx context.Context, client *http.Client, method string, url string, payload any) *http.Response {
	t.Helper()
	body, err := json.Marshal(payload)
	if err != nil {
		t.Fatalf("failed to marshal payload: %v", err)
	}
	req, err := http.NewRequestWithContext(ctx, method, url, bytes.NewReader(body))
	if err != nil {
		t.Fatalf("failed to build request %s %s: %v", method, url, err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Idempotency-Key", fmt.Sprintf("test-%d", time.Now().UnixNano()))

	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("request failed %s %s: %v", method, url, err)
	}
	return resp
}

func decodeJSON(t *testing.T, r io.Reader, out any) {
	t.Helper()
	if err := json.NewDecoder(r).Decode(out); err != nil {
		t.Fatalf("failed to decode JSON response: %v", err)
	}
}

func requireHTTP2xx(t *testing.T, resp *http.Response, label string) {
	t.Helper()
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return
	}
	body, _ := io.ReadAll(resp.Body)
	t.Fatalf("%s failed: status=%d body=%s", label, resp.StatusCode, strings.TrimSpace(string(body)))
}
