package handler

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/asset-service/internal/domain"
	"github.com/solar3d/solar3d/services/asset-service/internal/service"
)

type Handler struct {
	svc *service.Service
}

func New(svc *service.Service) *Handler {
	return &Handler{svc: svc}
}

func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/assets", h.CreateAsset)
	mux.HandleFunc("GET /api/v1/assets/{id}", h.GetAsset)
	mux.HandleFunc("GET /api/v1/assets", h.ListAssets)
	mux.HandleFunc("PUT /api/v1/assets/{id}", h.UpdateAsset)
	mux.HandleFunc("DELETE /api/v1/assets/{id}", h.DeleteAsset)
}

func (h *Handler) CreateAsset(w http.ResponseWriter, r *http.Request) {
	var asset domain.Asset
	if err := json.NewDecoder(r.Body).Decode(&asset); err != nil {
		http.Error(w, `{"error":"invalid request body"}`, http.StatusBadRequest)
		return
	}

	if err := h.svc.CreateAsset(r.Context(), &asset); err != nil {
		log.Error().Err(err).Msg("Failed to create asset")
		http.Error(w, `{"error":"`+err.Error()+`"}`, http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]interface{}{"asset": asset})
}

func (h *Handler) GetAsset(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		http.Error(w, `{"error":"invalid id"}`, http.StatusBadRequest)
		return
	}

	asset, err := h.svc.GetAsset(r.Context(), id)
	if err != nil {
		http.Error(w, `{"error":"not found"}`, http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"asset": asset})
}

func (h *Handler) ListAssets(w http.ResponseWriter, r *http.Request) {
	category := r.URL.Query().Get("category")
	pageSize, _ := strconv.Atoi(r.URL.Query().Get("page_size"))
	pageToken := r.URL.Query().Get("page_token")

	assets, totalCount, err := h.svc.ListAssets(r.Context(), category, pageSize, pageToken)
	if err != nil {
		log.Error().Err(err).Msg("Failed to list assets")
		http.Error(w, `{"error":"internal error"}`, http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"assets":      assets,
		"total_count": totalCount,
	})
}

func (h *Handler) UpdateAsset(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		http.Error(w, `{"error":"invalid id"}`, http.StatusBadRequest)
		return
	}

	var asset domain.Asset
	if err := json.NewDecoder(r.Body).Decode(&asset); err != nil {
		http.Error(w, `{"error":"invalid request body"}`, http.StatusBadRequest)
		return
	}
	asset.ID = id

	if err := h.svc.UpdateAsset(r.Context(), &asset); err != nil {
		log.Error().Err(err).Msg("Failed to update asset")
		http.Error(w, `{"error":"internal error"}`, http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"asset": asset})
}

func (h *Handler) DeleteAsset(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		http.Error(w, `{"error":"invalid id"}`, http.StatusBadRequest)
		return
	}

	if err := h.svc.DeleteAsset(r.Context(), id); err != nil {
		log.Error().Err(err).Msg("Failed to delete asset")
		http.Error(w, `{"error":"internal error"}`, http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
