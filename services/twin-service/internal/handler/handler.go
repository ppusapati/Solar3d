package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/twin-service/internal/domain"
	"p9e.in/samavaya/solar3d/twin-service/internal/repository"
	"p9e.in/samavaya/solar3d/twin-service/internal/service"
)

// TwinHandler exposes the twin service over HTTP/JSON.
type TwinHandler struct {
	svc    *service.TwinService
	logger zerolog.Logger
}

// NewTwinHandler creates a TwinHandler wired to the given service.
func NewTwinHandler(svc *service.TwinService, logger zerolog.Logger) *TwinHandler {
	return &TwinHandler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

// Register mounts all twin-service REST routes onto the provided mux.
func (h *TwinHandler) Register(mux *http.ServeMux) {
	// REST routes (deprecated — kept as aliases for one minor version).
	mux.HandleFunc("POST /api/v1/twins", h.ProvisionTwin)
	mux.HandleFunc("GET /api/v1/twins/{twinId}", h.GetTwinState)
	mux.HandleFunc("POST /api/v1/twins/{twinId}/telemetry", h.IngestTelemetry)
	mux.HandleFunc("POST /api/v1/twins/{twinId}/asset-identities", h.LinkAssetIdentity)
	mux.HandleFunc("GET /api/v1/twins/{twinId}/telemetry", h.GetLatestTelemetry)

	// ConnectRPC-style routes.
	mux.HandleFunc("POST /twin.v1.DigitalTwinService/ProvisionTwin", h.ProvisionTwinRPC)
	mux.HandleFunc("POST /twin.v1.DigitalTwinService/GetTwinState", h.GetTwinStateRPC)
	mux.HandleFunc("POST /twin.v1.DigitalTwinService/IngestTelemetry", h.IngestTelemetryRPC)
	mux.HandleFunc("POST /twin.v1.DigitalTwinService/LinkAssetIdentity", h.LinkAssetIdentityRPC)
	mux.HandleFunc("POST /twin.v1.DigitalTwinService/GetLatestTelemetry", h.GetLatestTelemetryRPC)
}

// --- Request / Response DTOs ---

type provisionTwinRequest struct {
	ProjectID           string  `json:"project_id"`
	LayoutID            *string `json:"layout_id,omitempty"`
	ElectricalNetworkID *string `json:"electrical_network_id,omitempty"`
	TransmissionRouteID *string `json:"transmission_route_id,omitempty"`
}

type ingestTelemetryRequest struct {
	Readings []sensorReadingDTO `json:"readings"`
}

type sensorReadingDTO struct {
	SensorID        string  `json:"sensor_id"`
	AssetIdentityID *string `json:"asset_identity_id,omitempty"`
	Metric          string  `json:"metric"`
	Value           float64 `json:"value"`
	Unit            string  `json:"unit"`
	Quality         string  `json:"quality,omitempty"`
	RecordedAt      string  `json:"recorded_at"`
}

type linkAssetIdentityRequest struct {
	DesignAssetID        string `json:"design_asset_id"`
	DesignAssetType      string `json:"design_asset_type"`
	PhysicalSerialNumber string `json:"physical_serial_number"`
	CommissioningRef     string `json:"commissioning_ref,omitempty"`
}

// --- Handlers ---

// ProvisionTwin handles POST /api/v1/twins
func (h *TwinHandler) ProvisionTwin(w http.ResponseWriter, r *http.Request) {
	var req provisionTwinRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	projectID, err := uuid.Parse(req.ProjectID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id UUID")
		return
	}

	in := service.ProvisionTwinInput{ProjectID: projectID}

	if req.LayoutID != nil {
		id, err := uuid.Parse(*req.LayoutID)
		if err != nil {
			writeError(w, http.StatusBadRequest, "invalid layout_id UUID")
			return
		}
		in.LayoutID = &id
	}
	if req.ElectricalNetworkID != nil {
		id, err := uuid.Parse(*req.ElectricalNetworkID)
		if err != nil {
			writeError(w, http.StatusBadRequest, "invalid electrical_network_id UUID")
			return
		}
		in.ElectricalNetworkID = &id
	}
	if req.TransmissionRouteID != nil {
		id, err := uuid.Parse(*req.TransmissionRouteID)
		if err != nil {
			writeError(w, http.StatusBadRequest, "invalid transmission_route_id UUID")
			return
		}
		in.TransmissionRouteID = &id
	}

	twin, err := h.svc.ProvisionTwin(r.Context(), in)
	if err != nil {
		h.logger.Error().Err(err).Msg("provision twin failed")
		writeError(w, http.StatusInternalServerError, "failed to provision twin")
		return
	}

	writeJSON(w, http.StatusCreated, twin)
}

// GetTwinState handles GET /api/v1/twins/{twinId}
func (h *TwinHandler) GetTwinState(w http.ResponseWriter, r *http.Request) {
	twinID, err := uuid.Parse(r.PathValue("twinId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
		return
	}

	twin, err := h.svc.GetTwinState(r.Context(), twinID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			writeError(w, http.StatusNotFound, "twin not found")
			return
		}
		h.logger.Error().Err(err).Msg("get twin state failed")
		writeError(w, http.StatusInternalServerError, "failed to get twin state")
		return
	}

	writeJSON(w, http.StatusOK, twin)
}

// IngestTelemetry handles POST /api/v1/twins/{twinId}/telemetry
func (h *TwinHandler) IngestTelemetry(w http.ResponseWriter, r *http.Request) {
	twinID, err := uuid.Parse(r.PathValue("twinId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
		return
	}

	var req ingestTelemetryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	readings, err := parseReadings(req.Readings)
	if err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}

	count, err := h.svc.IngestReadings(r.Context(), service.IngestReadingsInput{
		TwinID:   twinID,
		Readings: readings,
	})
	if err != nil {
		h.logger.Error().Err(err).Msg("ingest telemetry failed")
		writeError(w, http.StatusInternalServerError, "failed to ingest telemetry")
		return
	}

	writeJSON(w, http.StatusAccepted, map[string]int{"ingested": count})
}

// GetLatestTelemetry handles GET /api/v1/twins/{twinId}/telemetry
func (h *TwinHandler) GetLatestTelemetry(w http.ResponseWriter, r *http.Request) {
	twinID, err := uuid.Parse(r.PathValue("twinId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
		return
	}

	limit := 100
	if v := r.URL.Query().Get("limit"); v != "" {
		n, err := strconv.Atoi(v)
		if err != nil || n <= 0 {
			writeError(w, http.StatusBadRequest, "invalid limit parameter")
			return
		}
		limit = n
	}

	readings, err := h.svc.LatestReadings(r.Context(), twinID, limit)
	if err != nil {
		h.logger.Error().Err(err).Str("twin_id", twinID.String()).Msg("latest telemetry fetch failed")
		writeError(w, http.StatusInternalServerError, "failed to fetch telemetry")
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"twin_id":  twinID,
		"limit":    limit,
		"count":    len(readings),
		"readings": readings,
	})
}

// LinkAssetIdentity handles POST /api/v1/twins/{twinId}/asset-identities
func (h *TwinHandler) LinkAssetIdentity(w http.ResponseWriter, r *http.Request) {
	twinID, err := uuid.Parse(r.PathValue("twinId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
		return
	}

	var req linkAssetIdentityRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	designAssetID, err := uuid.Parse(req.DesignAssetID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design_asset_id UUID")
		return
	}

	identity, err := h.svc.LinkAssetIdentity(r.Context(), service.LinkAssetIdentityInput{
		TwinID:               twinID,
		DesignAssetID:        designAssetID,
		DesignAssetType:      domain.DesignAssetType(req.DesignAssetType),
		PhysicalSerialNumber: req.PhysicalSerialNumber,
		CommissioningRef:     req.CommissioningRef,
	})
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			writeError(w, http.StatusNotFound, "twin not found")
			return
		}
		h.logger.Error().Err(err).Msg("link asset identity failed")
		writeError(w, http.StatusInternalServerError, "failed to link asset identity")
		return
	}

	writeJSON(w, http.StatusCreated, identity)
}

// --- Helpers ---

func parseReadings(dtos []sensorReadingDTO) ([]*domain.SensorReading, error) {
	if len(dtos) == 0 {
		return nil, nil
	}
	out := make([]*domain.SensorReading, 0, len(dtos))
	for i, dto := range dtos {
		if dto.SensorID == "" {
			return nil, fmt.Errorf("readings[%d]: sensor_id is required", i)
		}
		if dto.Metric == "" {
			return nil, fmt.Errorf("readings[%d]: metric is required", i)
		}
		rd := &domain.SensorReading{
			SensorID: dto.SensorID,
			Metric:   domain.TelemetryMetric(dto.Metric),
			Value:    dto.Value,
			Unit:     dto.Unit,
			Quality:  domain.ReadingQuality(dto.Quality),
		}
		if dto.AssetIdentityID != nil {
			id, err := uuid.Parse(*dto.AssetIdentityID)
			if err != nil {
				return nil, fmt.Errorf("readings[%d]: invalid asset_identity_id UUID", i)
			}
			rd.AssetIdentityID = &id
		}
		if dto.RecordedAt != "" {
			t, err := time.Parse(time.RFC3339, dto.RecordedAt)
			if err != nil {
				return nil, fmt.Errorf("readings[%d]: recorded_at must be RFC3339", i)
			}
			rd.RecordedAt = t.UTC()
		} else {
			rd.RecordedAt = time.Now().UTC()
		}
		out = append(out, rd)
	}
	return out, nil
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(v); err != nil {
		// Nothing useful can be done after WriteHeader; log only.
		return
	}
}

func writeError(w http.ResponseWriter, status int, msg string) {
	writeJSON(w, status, map[string]string{"error": msg})
}
