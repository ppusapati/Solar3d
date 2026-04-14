package service

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/google/uuid"

	"solar3d/transmission-routing-service/internal/domain"
)

func TestValidateRouteAnchorsAcceptsProjectAndGridAnchors(t *testing.T) {
	projectID := uuid.New()
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/api/v1/projects/"+projectID.String() {
			w.WriteHeader(http.StatusNotFound)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"id":"` + projectID.String() + `","initial_latitude":17.385000,"initial_longitude":78.486700,"notes":"{\"grid_connection_center\":{\"latitude\":17.401000,\"longitude\":78.501700}}"}`))
	}))
	defer server.Close()

	svc := &TransmissionService{projectURL: server.URL, httpClient: server.Client()}
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          projectID,
		FarmOutputPoint:    domain.Waypoint{Lat: 17.38505, Lon: 78.48675},
		GridInjectionPoint: domain.Waypoint{Lat: 17.40102, Lon: 78.50171},
	}

	if err := svc.validateRouteAnchors(context.Background(), req); err != nil {
		t.Fatalf("expected anchors to validate, got error: %v", err)
	}
}

func TestValidateRouteAnchorsRejectsFarmMismatch(t *testing.T) {
	projectID := uuid.New()
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(fmt.Sprintf(`{"id":"%s","initial_latitude":17.385000,"initial_longitude":78.486700,"notes":"{\"grid_connection_center\":{\"latitude\":17.401000,\"longitude\":78.501700}}"}`, projectID.String())))
	}))
	defer server.Close()

	svc := &TransmissionService{projectURL: server.URL, httpClient: server.Client()}
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          projectID,
		FarmOutputPoint:    domain.Waypoint{Lat: 17.5000, Lon: 78.6000},
		GridInjectionPoint: domain.Waypoint{Lat: 17.4010, Lon: 78.5017},
	}

	err := svc.validateRouteAnchors(context.Background(), req)
	if err == nil {
		t.Fatal("expected farm mismatch to fail validation")
	}
	if !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput, got: %v", err)
	}
}

func TestValidateRouteAnchorsRejectsMissingGridConnectionCenter(t *testing.T) {
	projectID := uuid.New()
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(fmt.Sprintf(`{"id":"%s","initial_latitude":17.385000,"initial_longitude":78.486700,"notes":""}`, projectID.String())))
	}))
	defer server.Close()

	svc := &TransmissionService{projectURL: server.URL, httpClient: server.Client()}
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          projectID,
		FarmOutputPoint:    domain.Waypoint{Lat: 17.3850, Lon: 78.4867},
		GridInjectionPoint: domain.Waypoint{Lat: 17.4010, Lon: 78.5017},
	}

	err := svc.validateRouteAnchors(context.Background(), req)
	if err == nil {
		t.Fatal("expected missing grid_connection_center to fail validation")
	}
	if !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput, got: %v", err)
	}
}

func TestValidateRouteAnchorsAcceptsFarmLocationFromNotes(t *testing.T) {
	projectID := uuid.New()
	// Project has initial_latitude=0 (not set), but farm_location in notes
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/api/v1/projects/"+projectID.String() {
			w.Header().Set("Content-Type", "application/json")
			notes := `{\"farm_location\":{\"latitude\":17.385000,\"longitude\":78.486700},\"grid_connection_center\":{\"latitude\":17.401000,\"longitude\":78.501700}}`
			_, _ = w.Write([]byte(`{"project":{"id":"` + projectID.String() + `","initial_latitude":0,"initial_longitude":0,"notes":"` + notes + `"}}`))
			return
		}
		w.WriteHeader(http.StatusNotFound)
	}))
	defer server.Close()

	svc := &TransmissionService{projectURL: server.URL, httpClient: server.Client()}
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          projectID,
		FarmOutputPoint:    domain.Waypoint{Lat: 17.38505, Lon: 78.48675},
		GridInjectionPoint: domain.Waypoint{Lat: 17.40102, Lon: 78.50171},
	}

	if err := svc.validateRouteAnchors(context.Background(), req); err != nil {
		t.Fatalf("expected notes farm_location fallback to work, got error: %v", err)
	}
}

func TestValidateRouteAnchorsAcceptsBoundaryVerticesCentroid(t *testing.T) {
	projectID := uuid.New()
	// Project has initial_latitude=0, notes contain solar_farm_boundary_vertices as [[lon,lat],...] (GeoJSON convention)
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/api/v1/projects/"+projectID.String() {
			w.Header().Set("Content-Type", "application/json")
			// Vertices form a simple quadrilateral; centroid = avg of 4 corners
			// Lons: 78.48, 78.50, 78.50, 78.48 → avg = 78.49
			// Lats: 17.38, 17.38, 17.40, 17.40 → avg = 17.39
			notes := `{\"solar_farm_boundary_vertices\":[[78.48,17.38],[78.50,17.38],[78.50,17.40],[78.48,17.40]],\"grid_connection_center\":{\"latitude\":17.401000,\"longitude\":78.501700}}`
			_, _ = w.Write([]byte(`{"project":{"id":"` + projectID.String() + `","initial_latitude":0,"initial_longitude":0,"notes":"` + notes + `"}}`))
			return
		}
		w.WriteHeader(http.StatusNotFound)
	}))
	defer server.Close()

	svc := &TransmissionService{projectURL: server.URL, httpClient: server.Client()}
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          projectID,
		FarmOutputPoint:    domain.Waypoint{Lat: 17.39, Lon: 78.49}, // matches centroid
		GridInjectionPoint: domain.Waypoint{Lat: 17.40102, Lon: 78.50171},
	}

	if err := svc.validateRouteAnchors(context.Background(), req); err != nil {
		t.Fatalf("expected boundary vertices centroid fallback to work, got error: %v", err)
	}
}
