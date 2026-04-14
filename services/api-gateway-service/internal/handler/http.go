package handler

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"

	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"

	"solar3d/api-gateway-service/internal/service"
)

type Handler struct {
	svc *service.Service
}

func New(svc *service.Service) *Handler {
	return &Handler{svc: svc}
}

func (h *Handler) Register(mux *http.ServeMux) {
	h.registerRoutes(mux, true)
}

// RegisterWithoutHealth mounts API gateway routes except /healthz.
// This is used when another parent service already owns a global health endpoint.
func (h *Handler) RegisterWithoutHealth(mux *http.ServeMux) {
	h.registerRoutes(mux, false)
}

func (h *Handler) registerRoutes(mux *http.ServeMux, includeHealth bool) {
	if includeHealth {
	mux.HandleFunc("GET /healthz", h.handleHealth)
	}
	mux.HandleFunc("GET /api/v1/workspace/projects/{projectID}", h.handleGetProjectWorkspace)
	mux.HandleFunc("GET /api/v1/workspace/drawings/{drawingID}", h.handleGetDrawingWorkspace)
	mux.HandleFunc("POST /api/v1/workspace/projects/{projectID}/drawings", h.handleCreateDrawing)
	mux.HandleFunc("PATCH /api/v1/workspace/drawings/{drawingID}", h.handleUpdateDrawing)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/commands", h.handleCommitCommand)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/revert", h.handleRevertDrawing)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/annotations", h.handleCreateAnnotation)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/annotations/regenerate", h.handleRegenerateAnnotations)
	mux.HandleFunc("PUT /api/v1/workspace/drawings/{drawingID}/layers", h.handleUpsertLayer)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/blocks", h.handleCreateBlockDefinition)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/blocks/insert", h.handleInsertBlockReference)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/interop/export", h.handleExportDrawing)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/interop/import", h.handleImportDrawing)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/interop/roundtrip", h.handleRoundTrip)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/sheets", h.handleCreateSheet)
	mux.HandleFunc("POST /api/v1/workspace/drawings/{drawingID}/publish", h.handlePublishDrawing)
}

func (h *Handler) handleHealth(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, h.svc.Health(r.Context()))
}

func (h *Handler) handleGetProjectWorkspace(w http.ResponseWriter, r *http.Request) {
	workspace, err := h.svc.GetProjectWorkspace(r.Context(), r.PathValue("projectID"))
	if err != nil {
		writeServiceError(w, err)
		return
	}
	projectJSON, err := service.MarshalProto(workspace.Project)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	drawingsJSON := make([]json.RawMessage, 0, len(workspace.Drawings))
	for _, drawing := range workspace.Drawings {
		payload, marshalErr := service.MarshalProto(drawing)
		if marshalErr != nil {
			writeServiceError(w, marshalErr)
			return
		}
		drawingsJSON = append(drawingsJSON, payload)
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"project":     projectJSON,
		"drawings":    drawingsJSON,
		"total_count": workspace.TotalCount,
	})
}

func (h *Handler) handleGetDrawingWorkspace(w http.ResponseWriter, r *http.Request) {
	workspace, err := h.svc.GetDrawingWorkspace(r.Context(), r.PathValue("drawingID"))
	if err != nil {
		writeServiceError(w, err)
		return
	}
	projectJSON, err := service.MarshalProto(workspace.Project)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	drawingJSON, err := service.MarshalProto(workspace.Drawing)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	revisionJSON, err := service.MarshalProto(workspace.Revision)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	revisionsJSON := make([]json.RawMessage, 0, len(workspace.Revisions))
	for _, revision := range workspace.Revisions {
		payload, marshalErr := service.MarshalProto(revision)
		if marshalErr != nil {
			writeServiceError(w, marshalErr)
			return
		}
		revisionsJSON = append(revisionsJSON, payload)
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"project":   projectJSON,
		"drawing":   drawingJSON,
		"revision":  revisionJSON,
		"revisions": revisionsJSON,
	})
}

func (h *Handler) handleCreateDrawing(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.CreateDrawingRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.CreateDrawing(r.Context(), r.PathValue("projectID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusCreated, response)
}

func (h *Handler) handleUpdateDrawing(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.UpdateDrawingRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.UpdateDrawing(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleCommitCommand(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.CommitDrawingCommandRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.CommitDrawingCommand(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleRevertDrawing(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.RevertDrawingRevisionRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.RevertDrawingRevision(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleCreateAnnotation(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.CreateAnnotationRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.CreateAnnotation(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusCreated, response)
}

func (h *Handler) handleRegenerateAnnotations(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.RegenerateAssociativeAnnotationsRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.RegenerateAssociativeAnnotations(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleUpsertLayer(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.UpsertLayerRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.UpsertLayer(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleCreateBlockDefinition(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.CreateBlockDefinitionRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.CreateBlockDefinition(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusCreated, response)
}

func (h *Handler) handleInsertBlockReference(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.InsertBlockReferenceRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.InsertBlockReference(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusCreated, response)
}

func (h *Handler) handleExportDrawing(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.ExportDrawingRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.ExportDrawing(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleImportDrawing(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.ImportDrawingRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.ImportDrawing(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleRoundTrip(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.ValidateDrawingRoundTripRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.ValidateDrawingRoundTrip(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func (h *Handler) handleCreateSheet(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.CreateSheetRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.CreateSheet(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusCreated, response)
}

func (h *Handler) handlePublishDrawing(w http.ResponseWriter, r *http.Request) {
	req := &drawingv1.PublishDrawingRequest{}
	if err := readProtoJSON(r, req); err != nil {
		writeServiceError(w, err)
		return
	}
	response, err := h.svc.PublishDrawing(r.Context(), r.PathValue("drawingID"), req)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	writeProtoJSON(w, http.StatusOK, response)
}

func readProtoJSON(r *http.Request, message proto.Message) error {
	body, err := io.ReadAll(io.LimitReader(r.Body, 1<<20))
	if err != nil {
		return err
	}
	if len(body) == 0 {
		body = []byte(`{}`)
	}
	return protojson.Unmarshal(body, message)
}

func writeProtoJSON(w http.ResponseWriter, status int, message proto.Message) {
	payload, err := protojson.Marshal(message)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_, _ = w.Write(payload)
}

func writeJSON(w http.ResponseWriter, status int, value any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(value)
}

func writeServiceError(w http.ResponseWriter, err error) {
	status := http.StatusInternalServerError
	switch {
	case errors.Is(err, service.ErrInvalidInput):
		status = http.StatusBadRequest
	case errors.Is(err, service.ErrNotFound):
		status = http.StatusNotFound
	case errors.Is(err, service.ErrConflict):
		status = http.StatusConflict
	}
	writeJSON(w, status, map[string]string{"error": err.Error()})
}

