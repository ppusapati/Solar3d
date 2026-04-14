package handler

import (
	"encoding/json"
	"net/http"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"solar3d/asset-service/internal/domain"
	"solar3d/asset-service/internal/service"
)

type AssetHandler struct {
	svc *service.AssetService
}

func NewAssetHandler(svc *service.AssetService) *AssetHandler {
	return &AssetHandler{svc: svc}
}

func (h *AssetHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/assets", h.Create)
	mux.HandleFunc("GET /api/v1/assets/{id}", h.GetByID)
	mux.HandleFunc("GET /api/v1/assets", h.List)
	mux.HandleFunc("PUT /api/v1/assets/{id}", h.Update)
	mux.HandleFunc("DELETE /api/v1/assets/{id}", h.Delete)
	mux.HandleFunc("GET /api/v1/assets/search", h.Search)
}

func (h *AssetHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateAssetRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if req.Name == "" || req.Category == "" {
		writeError(w, http.StatusBadRequest, "name and category are required")
		return
	}

	asset, err := h.svc.Create(r.Context(), req)
	if err != nil {
		log.Error().Err(err).Msg("failed to create asset")
		writeError(w, http.StatusInternalServerError, "failed to create asset")
		return
	}

	writeJSON(w, http.StatusCreated, asset)
}

func (h *AssetHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid asset ID")
		return
	}

	asset, err := h.svc.GetByID(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "asset not found")
		return
	}

	writeJSON(w, http.StatusOK, asset)
}

func (h *AssetHandler) List(w http.ResponseWriter, r *http.Request) {
	category := r.URL.Query().Get("category")

	var assets []domain.Asset
	var err error

	if category != "" {
		assets, err = h.svc.ListByCategory(r.Context(), domain.AssetCategory(category))
	} else {
		assets, err = h.svc.List(r.Context())
	}

	if err != nil {
		log.Error().Err(err).Msg("failed to list assets")
		writeError(w, http.StatusInternalServerError, "failed to list assets")
		return
	}

	writeJSON(w, http.StatusOK, assets)
}

func (h *AssetHandler) Update(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid asset ID")
		return
	}

	var req domain.UpdateAssetRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	asset, err := h.svc.Update(r.Context(), id, req)
	if err != nil {
		log.Error().Err(err).Str("id", id.String()).Msg("failed to update asset")
		writeError(w, http.StatusNotFound, "asset not found")
		return
	}

	writeJSON(w, http.StatusOK, asset)
}

func (h *AssetHandler) Delete(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid asset ID")
		return
	}

	if err := h.svc.Delete(r.Context(), id); err != nil {
		writeError(w, http.StatusNotFound, "asset not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *AssetHandler) Search(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	filter := domain.AssetFilter{}

	if cat := q.Get("category"); cat != "" {
		c := domain.AssetCategory(cat)
		filter.Category = &c
	}
	if mfg := q.Get("manufacturer"); mfg != "" {
		filter.Manufacturer = &mfg
	}
	if search := q.Get("q"); search != "" {
		filter.SearchQuery = &search
	}

	assets, err := h.svc.Search(r.Context(), filter)
	if err != nil {
		log.Error().Err(err).Msg("failed to search assets")
		writeError(w, http.StatusInternalServerError, "failed to search assets")
		return
	}

	writeJSON(w, http.StatusOK, assets)
}

func writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		log.Error().Err(err).Msg("failed to encode response")
	}
}

func writeError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(map[string]string{"error": message}); err != nil {
		log.Error().Err(err).Str("message", message).Msg("failed to encode error response")
	}
}

