package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/twin-service/internal/domain"
	"p9e.in/samavaya/solar3d/twin-service/internal/repository"
	"p9e.in/samavaya/solar3d/twin-service/internal/service"
)

// ConnectRPC-style handlers. These accept a JSON body matching the proto
// request message and return the proto response message. Paths follow the
// /twin.v1.DigitalTwinService/<Method> convention.

type rpcProvisionTwinRequest struct {
	ProjectID           string  `json:"project_id"`
	LayoutID            *string `json:"layout_id,omitempty"`
	ElectricalNetworkID *string `json:"electrical_network_id,omitempty"`
	TransmissionRouteID *string `json:"transmission_route_id,omitempty"`
}

type rpcIDRequest struct {
	TwinID string `json:"twin_id"`
}

type rpcIngestTelemetryRequest struct {
	TwinID   string             `json:"twin_id"`
	Readings []sensorReadingDTO `json:"readings"`
}

type rpcLinkAssetIdentityRequest struct {
	TwinID               string `json:"twin_id"`
	DesignAssetID        string `json:"design_asset_id"`
	DesignAssetType      string `json:"design_asset_type"`
	PhysicalSerialNumber string `json:"physical_serial_number"`
	CommissioningRef     string `json:"commissioning_ref,omitempty"`
}

type rpcGetLatestTelemetryRequest struct {
	TwinID string `json:"twin_id"`
	Limit  int    `json:"limit"`
}

// ProvisionTwinRPC handles POST /twin.v1.DigitalTwinService/ProvisionTwin.
func (h *TwinHandler) ProvisionTwinRPC(w http.ResponseWriter, r *http.Request) {
	var req rpcProvisionTwinRequest
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

	writeJSON(w, http.StatusOK, map[string]any{"twin": twin})
}

// GetTwinStateRPC handles POST /twin.v1.DigitalTwinService/GetTwinState.
func (h *TwinHandler) GetTwinStateRPC(w http.ResponseWriter, r *http.Request) {
	var req rpcIDRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	twinID, err := uuid.Parse(req.TwinID)
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

	writeJSON(w, http.StatusOK, map[string]any{"twin": twin})
}

// IngestTelemetryRPC handles POST /twin.v1.DigitalTwinService/IngestTelemetry.
func (h *TwinHandler) IngestTelemetryRPC(w http.ResponseWriter, r *http.Request) {
	var req rpcIngestTelemetryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	twinID, err := uuid.Parse(req.TwinID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
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

	writeJSON(w, http.StatusOK, map[string]int{"ingested": count})
}

// LinkAssetIdentityRPC handles POST /twin.v1.DigitalTwinService/LinkAssetIdentity.
func (h *TwinHandler) LinkAssetIdentityRPC(w http.ResponseWriter, r *http.Request) {
	var req rpcLinkAssetIdentityRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	twinID, err := uuid.Parse(req.TwinID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
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

	writeJSON(w, http.StatusOK, map[string]any{"asset_identity": identity})
}

// GetLatestTelemetryRPC handles POST /twin.v1.DigitalTwinService/GetLatestTelemetry.
func (h *TwinHandler) GetLatestTelemetryRPC(w http.ResponseWriter, r *http.Request) {
	var req rpcGetLatestTelemetryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON body")
		return
	}

	twinID, err := uuid.Parse(req.TwinID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid twin_id UUID")
		return
	}

	readings, err := h.svc.LatestReadings(r.Context(), twinID, req.Limit)
	if err != nil {
		h.logger.Error().Err(err).Str("twin_id", twinID.String()).Msg("latest telemetry RPC failed")
		writeError(w, http.StatusInternalServerError, "failed to fetch telemetry")
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"twin_id":  twinID,
		"count":    len(readings),
		"readings": readings,
	})
}
