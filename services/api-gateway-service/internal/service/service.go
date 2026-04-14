package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"
	projectv1 "github.com/solar3d/solar3d/gen/project/v1"
	projectv1connect "github.com/solar3d/solar3d/gen/project/v1/projectv1connect"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
)

var (
	ErrInvalidInput = errors.New("invalid input")
	ErrNotFound     = errors.New("not found")
	ErrConflict     = errors.New("conflict")
)

type Service struct {
	projects       projectv1connect.ProjectServiceClient
	drawings       drawingv1connect.DrawingRevisionServiceClient
	cad            drawingv1connect.CadCoreServiceClient
	annotation     drawingv1connect.CadAnnotationServiceClient
	layerBlock     drawingv1connect.CadLayerBlockServiceClient
	interop        drawingv1connect.InteropServiceClient
	plotSheet      drawingv1connect.PlotSheetServiceClient
	healthClient   *http.Client
	projectURL     string
	drawingURL     string
	cadURL         string
	annotationURL  string
	layerBlockURL  string
	interopURL     string
	plotSheetURL   string
	requestTimeout time.Duration
	logger         zerolog.Logger
}

type ProjectWorkspace struct {
	Project    *projectv1.Project
	Drawings   []*drawingv1.Drawing
	TotalCount uint32
}

type DrawingWorkspace struct {
	Project   *projectv1.Project
	Drawing   *drawingv1.Drawing
	Revision  *drawingv1.DrawingRevision
	Revisions []*drawingv1.RevisionPointer
}

type HealthStatus struct {
	Status     string                 `json:"status"`
	Downstream map[string]HealthCheck `json:"downstream"`
}

type HealthCheck struct {
	Status string `json:"status"`
	Error  string `json:"error,omitempty"`
}

func New(
	projects projectv1connect.ProjectServiceClient,
	drawings drawingv1connect.DrawingRevisionServiceClient,
	cad drawingv1connect.CadCoreServiceClient,
	annotation drawingv1connect.CadAnnotationServiceClient,
	layerBlock drawingv1connect.CadLayerBlockServiceClient,
	interop drawingv1connect.InteropServiceClient,
	plotSheet drawingv1connect.PlotSheetServiceClient,
	healthClient *http.Client,
	projectURL string,
	drawingURL string,
	cadURL string,
	annotationURL string,
	layerBlockURL string,
	interopURL string,
	plotSheetURL string,
	requestTimeout time.Duration,
	logger zerolog.Logger,
) *Service {
	return &Service{
		projects:       projects,
		drawings:       drawings,
		cad:            cad,
		annotation:     annotation,
		layerBlock:     layerBlock,
		interop:        interop,
		plotSheet:      plotSheet,
		healthClient:   healthClient,
		projectURL:     strings.TrimRight(projectURL, "/"),
		drawingURL:     strings.TrimRight(drawingURL, "/"),
		cadURL:         strings.TrimRight(cadURL, "/"),
		annotationURL:  strings.TrimRight(annotationURL, "/"),
		layerBlockURL:  strings.TrimRight(layerBlockURL, "/"),
		interopURL:     strings.TrimRight(interopURL, "/"),
		plotSheetURL:   strings.TrimRight(plotSheetURL, "/"),
		requestTimeout: requestTimeout,
		logger:         logger.With().Str("component", "service").Logger(),
	}
}

func (s *Service) GetProjectWorkspace(ctx context.Context, projectID string) (*ProjectWorkspace, error) {
	if _, err := parseUUID(projectID, "project_id"); err != nil {
		return nil, err
	}

	projectCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	projectResponse, err := s.projects.GetProject(projectCtx, connect.NewRequest(&projectv1.GetProjectRequest{Id: projectID}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	drawingCtx, drawingCancel := context.WithTimeout(ctx, s.requestTimeout)
	defer drawingCancel()
	drawingResponse, err := s.drawings.ListDrawings(drawingCtx, connect.NewRequest(&drawingv1.ListDrawingsRequest{ProjectId: projectID, PageSize: 100}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	return &ProjectWorkspace{
		Project:    projectResponse.Msg.GetProject(),
		Drawings:   drawingResponse.Msg.GetDrawings(),
		TotalCount: drawingResponse.Msg.GetTotalCount(),
	}, nil
}

func (s *Service) GetDrawingWorkspace(ctx context.Context, drawingID string) (*DrawingWorkspace, error) {
	if _, err := parseUUID(drawingID, "drawing_id"); err != nil {
		return nil, err
	}

	stateCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	stateResponse, err := s.drawings.GetDrawingState(stateCtx, connect.NewRequest(&drawingv1.GetDrawingStateRequest{DrawingId: drawingID}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	revisionsCtx, revisionsCancel := context.WithTimeout(ctx, s.requestTimeout)
	defer revisionsCancel()
	revisionsResponse, err := s.drawings.ListDrawingRevisions(revisionsCtx, connect.NewRequest(&drawingv1.ListDrawingRevisionsRequest{DrawingId: drawingID, PageSize: 20}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	projectCtx, projectCancel := context.WithTimeout(ctx, s.requestTimeout)
	defer projectCancel()
	projectResponse, err := s.projects.GetProject(projectCtx, connect.NewRequest(&projectv1.GetProjectRequest{Id: stateResponse.Msg.GetDrawing().GetProjectId()}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	return &DrawingWorkspace{
		Project:   projectResponse.Msg.GetProject(),
		Drawing:   stateResponse.Msg.GetDrawing(),
		Revision:  stateResponse.Msg.GetRevision(),
		Revisions: revisionsResponse.Msg.GetRevisions(),
	}, nil
}

func (s *Service) CreateDrawing(ctx context.Context, projectID string, req *drawingv1.CreateDrawingRequest) (*drawingv1.CreateDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.ProjectId = projectID
	workspace, err := s.GetProjectWorkspace(ctx, projectID)
	if err != nil {
		return nil, err
	}
	if workspace.Project == nil {
		return nil, ErrNotFound
	}

	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.drawings.CreateDrawing(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) UpdateDrawing(ctx context.Context, drawingID string, req *drawingv1.UpdateDrawingRequest) (*drawingv1.UpdateDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.drawings.UpdateDrawing(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) CommitDrawingCommand(ctx context.Context, drawingID string, req *drawingv1.CommitDrawingCommandRequest) (*drawingv1.CommitDrawingCommandResponse, error) {
	if req == nil || req.GetCommand() == nil {
		return nil, fmt.Errorf("%w: command is required", ErrInvalidInput)
	}
	req.Command.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.cad.CommitDrawingCommand(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) RevertDrawingRevision(ctx context.Context, drawingID string, req *drawingv1.RevertDrawingRevisionRequest) (*drawingv1.RevertDrawingRevisionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.cad.RevertDrawingRevision(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) CreateAnnotation(ctx context.Context, drawingID string, req *drawingv1.CreateAnnotationRequest) (*drawingv1.CreateAnnotationResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.annotation.CreateAnnotation(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) RegenerateAssociativeAnnotations(ctx context.Context, drawingID string, req *drawingv1.RegenerateAssociativeAnnotationsRequest) (*drawingv1.RegenerateAssociativeAnnotationsResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.annotation.RegenerateAssociativeAnnotations(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) UpsertLayer(ctx context.Context, drawingID string, req *drawingv1.UpsertLayerRequest) (*drawingv1.UpsertLayerResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.layerBlock.UpsertLayer(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) CreateBlockDefinition(ctx context.Context, drawingID string, req *drawingv1.CreateBlockDefinitionRequest) (*drawingv1.CreateBlockDefinitionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.layerBlock.CreateBlockDefinition(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) InsertBlockReference(ctx context.Context, drawingID string, req *drawingv1.InsertBlockReferenceRequest) (*drawingv1.InsertBlockReferenceResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.layerBlock.InsertBlockReference(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) ExportDrawing(ctx context.Context, drawingID string, req *drawingv1.ExportDrawingRequest) (*drawingv1.ExportDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.interop.ExportDrawing(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) ImportDrawing(ctx context.Context, drawingID string, req *drawingv1.ImportDrawingRequest) (*drawingv1.ImportDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.interop.ImportDrawing(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) ValidateDrawingRoundTrip(ctx context.Context, drawingID string, req *drawingv1.ValidateDrawingRoundTripRequest) (*drawingv1.ValidateDrawingRoundTripResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.interop.ValidateDrawingRoundTrip(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) CreateSheet(ctx context.Context, drawingID string, req *drawingv1.CreateSheetRequest) (*drawingv1.CreateSheetResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.plotSheet.CreateSheet(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) PublishDrawing(ctx context.Context, drawingID string, req *drawingv1.PublishDrawingRequest) (*drawingv1.PublishDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	req.DrawingId = drawingID
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.plotSheet.PublishDrawing(callCtx, connect.NewRequest(req))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) Health(ctx context.Context) HealthStatus {
	checks := map[string]HealthCheck{
		"project_service":          s.ping(ctx, s.projectURL),
		"drawing_revision_service": s.ping(ctx, s.drawingURL),
		"cad_core_service":         s.ping(ctx, s.cadURL),
		"cad_annotation_service":   s.ping(ctx, s.annotationURL),
		"cad_layer_block_service":  s.ping(ctx, s.layerBlockURL),
		"interop_service":          s.ping(ctx, s.interopURL),
		"plot_sheet_service":       s.ping(ctx, s.plotSheetURL),
	}
	overall := "ok"
	for _, check := range checks {
		if check.Status != "ok" {
			overall = "degraded"
			break
		}
	}
	return HealthStatus{Status: overall, Downstream: checks}
}

func (s *Service) ping(ctx context.Context, baseURL string) HealthCheck {
	requestCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	request, err := http.NewRequestWithContext(requestCtx, http.MethodGet, baseURL+"/healthz", nil)
	if err != nil {
		return HealthCheck{Status: "down", Error: err.Error()}
	}
	response, err := s.healthClient.Do(request)
	if err != nil {
		return HealthCheck{Status: "down", Error: err.Error()}
	}
	defer response.Body.Close()
	if response.StatusCode >= http.StatusBadRequest {
		return HealthCheck{Status: "down", Error: response.Status}
	}
	return HealthCheck{Status: "ok"}
}

func MarshalProto(message proto.Message) (json.RawMessage, error) {
	if message == nil {
		return json.RawMessage("null"), nil
	}
	payload, err := protojson.Marshal(message)
	if err != nil {
		return nil, err
	}
	return json.RawMessage(payload), nil
}

func translateConnectError(err error) error {
	var connectErr *connect.Error
	if !errors.As(err, &connectErr) {
		return err
	}
	switch connectErr.Code() {
	case connect.CodeInvalidArgument:
		return fmt.Errorf("%w: %v", ErrInvalidInput, connectErr.Message())
	case connect.CodeNotFound:
		return fmt.Errorf("%w: %v", ErrNotFound, connectErr.Message())
	case connect.CodeAlreadyExists, connect.CodeFailedPrecondition, connect.CodeAborted:
		return fmt.Errorf("%w: %v", ErrConflict, connectErr.Message())
	default:
		return err
	}
}

func parseUUID(value string, field string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(strings.TrimSpace(value))
	if err != nil {
		return uuid.Nil, fmt.Errorf("%w: %s must be a UUID", ErrInvalidInput, field)
	}
	return parsed, nil
}

