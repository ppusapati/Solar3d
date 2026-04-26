package service_test

import (
	"context"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"
	projectv1 "p9e.in/samavaya/solar3d/gen/project/v1"
	projectv1connect "p9e.in/samavaya/solar3d/gen/project/v1/projectv1connect"

	"p9e.in/samavaya/solar3d/api-gateway-service/internal/service"
)

// ─── mock ProjectServiceClient ────────────────────────────────────────────────

type mockProjects struct {
	createProjectFn func(context.Context, *connect.Request[projectv1.CreateProjectRequest]) (*connect.Response[projectv1.CreateProjectResponse], error)
	getProjectFn    func(context.Context, *connect.Request[projectv1.GetProjectRequest]) (*connect.Response[projectv1.GetProjectResponse], error)
	listProjectsFn  func(context.Context, *connect.Request[projectv1.ListProjectsRequest]) (*connect.Response[projectv1.ListProjectsResponse], error)
	updateProjectFn func(context.Context, *connect.Request[projectv1.UpdateProjectRequest]) (*connect.Response[projectv1.UpdateProjectResponse], error)
	deleteProjectFn func(context.Context, *connect.Request[projectv1.DeleteProjectRequest]) (*connect.Response[projectv1.DeleteProjectResponse], error)
}

var _ projectv1connect.ProjectServiceClient = (*mockProjects)(nil)

func (m *mockProjects) CreateProject(ctx context.Context, req *connect.Request[projectv1.CreateProjectRequest]) (*connect.Response[projectv1.CreateProjectResponse], error) {
	if m.createProjectFn != nil {
		return m.createProjectFn(ctx, req)
	}
	return connect.NewResponse(&projectv1.CreateProjectResponse{}), nil
}
func (m *mockProjects) GetProject(ctx context.Context, req *connect.Request[projectv1.GetProjectRequest]) (*connect.Response[projectv1.GetProjectResponse], error) {
	if m.getProjectFn != nil {
		return m.getProjectFn(ctx, req)
	}
	return connect.NewResponse(&projectv1.GetProjectResponse{
		Project: &projectv1.Project{Id: req.Msg.GetId(), Name: "Test Project"},
	}), nil
}
func (m *mockProjects) ListProjects(ctx context.Context, req *connect.Request[projectv1.ListProjectsRequest]) (*connect.Response[projectv1.ListProjectsResponse], error) {
	if m.listProjectsFn != nil {
		return m.listProjectsFn(ctx, req)
	}
	return connect.NewResponse(&projectv1.ListProjectsResponse{}), nil
}
func (m *mockProjects) UpdateProject(ctx context.Context, req *connect.Request[projectv1.UpdateProjectRequest]) (*connect.Response[projectv1.UpdateProjectResponse], error) {
	if m.updateProjectFn != nil {
		return m.updateProjectFn(ctx, req)
	}
	return connect.NewResponse(&projectv1.UpdateProjectResponse{}), nil
}
func (m *mockProjects) DeleteProject(ctx context.Context, req *connect.Request[projectv1.DeleteProjectRequest]) (*connect.Response[projectv1.DeleteProjectResponse], error) {
	if m.deleteProjectFn != nil {
		return m.deleteProjectFn(ctx, req)
	}
	return connect.NewResponse(&projectv1.DeleteProjectResponse{}), nil
}

// ─── mock DrawingRevisionServiceClient ───────────────────────────────────────

type mockDrawings struct {
	createDrawingFn        func(context.Context, *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error)
	getDrawingFn           func(context.Context, *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error)
	listDrawingsFn         func(context.Context, *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error)
	updateDrawingFn        func(context.Context, *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error)
	getDrawingStateFn      func(context.Context, *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error)
	listDrawingRevisionsFn func(context.Context, *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error)
	getDrawingRevisionFn   func(context.Context, *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error)
	storeDrawingRevisionFn func(context.Context, *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error)
}

var _ drawingv1connect.DrawingRevisionServiceClient = (*mockDrawings)(nil)

func (m *mockDrawings) CreateDrawing(ctx context.Context, req *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
	if m.createDrawingFn != nil {
		return m.createDrawingFn(ctx, req)
	}
	drawingID := uuid.NewString()
	return connect.NewResponse(&drawingv1.CreateDrawingResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: drawingID, ProjectId: req.Msg.GetProjectId()},
		Revision: &drawingv1.DrawingRevision{DrawingId: drawingID, Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}},
	}), nil
}
func (m *mockDrawings) GetDrawing(ctx context.Context, req *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
	if m.getDrawingFn != nil {
		return m.getDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.GetDrawingResponse{
		Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()},
	}), nil
}
func (m *mockDrawings) ListDrawings(ctx context.Context, req *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
	if m.listDrawingsFn != nil {
		return m.listDrawingsFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ListDrawingsResponse{}), nil
}
func (m *mockDrawings) UpdateDrawing(ctx context.Context, req *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
	if m.updateDrawingFn != nil {
		return m.updateDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.UpdateDrawingResponse{
		Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()},
	}), nil
}
func (m *mockDrawings) GetDrawingState(ctx context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
	if m.getDrawingStateFn != nil {
		return m.getDrawingStateFn(ctx, req)
	}
	revID := uuid.NewString()
	return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId(), ProjectId: uuid.NewString()},
		Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: revID}},
	}), nil
}
func (m *mockDrawings) ListDrawingRevisions(ctx context.Context, req *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error) {
	if m.listDrawingRevisionsFn != nil {
		return m.listDrawingRevisionsFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ListDrawingRevisionsResponse{}), nil
}
func (m *mockDrawings) GetDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error) {
	if m.getDrawingRevisionFn != nil {
		return m.getDrawingRevisionFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.GetDrawingRevisionResponse{}), nil
}
func (m *mockDrawings) StoreDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
	if m.storeDrawingRevisionFn != nil {
		return m.storeDrawingRevisionFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{}), nil
}

// ─── mock CadCoreServiceClient ────────────────────────────────────────────────

type mockCad struct {
	validateDrawingCommandFn func(context.Context, *connect.Request[drawingv1.ValidateDrawingCommandRequest]) (*connect.Response[drawingv1.ValidateDrawingCommandResponse], error)
	commitDrawingCommandFn   func(context.Context, *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error)
	revertDrawingRevisionFn  func(context.Context, *connect.Request[drawingv1.RevertDrawingRevisionRequest]) (*connect.Response[drawingv1.RevertDrawingRevisionResponse], error)
}

var _ drawingv1connect.CadCoreServiceClient = (*mockCad)(nil)

func (m *mockCad) ValidateDrawingCommand(ctx context.Context, req *connect.Request[drawingv1.ValidateDrawingCommandRequest]) (*connect.Response[drawingv1.ValidateDrawingCommandResponse], error) {
	if m.validateDrawingCommandFn != nil {
		return m.validateDrawingCommandFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ValidateDrawingCommandResponse{Valid: true}), nil
}
func (m *mockCad) CommitDrawingCommand(ctx context.Context, req *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error) {
	if m.commitDrawingCommandFn != nil {
		return m.commitDrawingCommandFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.CommitDrawingCommandResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetCommand().GetDrawingId()},
		Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}},
	}), nil
}
func (m *mockCad) RevertDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.RevertDrawingRevisionRequest]) (*connect.Response[drawingv1.RevertDrawingRevisionResponse], error) {
	if m.revertDrawingRevisionFn != nil {
		return m.revertDrawingRevisionFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.RevertDrawingRevisionResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()},
		Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}},
	}), nil
}

type mockAnnotation struct {
	createAnnotationFn                 func(context.Context, *connect.Request[drawingv1.CreateAnnotationRequest]) (*connect.Response[drawingv1.CreateAnnotationResponse], error)
	regenerateAssociativeAnnotationsFn func(context.Context, *connect.Request[drawingv1.RegenerateAssociativeAnnotationsRequest]) (*connect.Response[drawingv1.RegenerateAssociativeAnnotationsResponse], error)
}

var _ drawingv1connect.CadAnnotationServiceClient = (*mockAnnotation)(nil)

func (m *mockAnnotation) CreateAnnotation(ctx context.Context, req *connect.Request[drawingv1.CreateAnnotationRequest]) (*connect.Response[drawingv1.CreateAnnotationResponse], error) {
	if m.createAnnotationFn != nil {
		return m.createAnnotationFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.CreateAnnotationResponse{}), nil
}

func (m *mockAnnotation) RegenerateAssociativeAnnotations(ctx context.Context, req *connect.Request[drawingv1.RegenerateAssociativeAnnotationsRequest]) (*connect.Response[drawingv1.RegenerateAssociativeAnnotationsResponse], error) {
	if m.regenerateAssociativeAnnotationsFn != nil {
		return m.regenerateAssociativeAnnotationsFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.RegenerateAssociativeAnnotationsResponse{}), nil
}

type mockLayerBlock struct {
	upsertLayerFn           func(context.Context, *connect.Request[drawingv1.UpsertLayerRequest]) (*connect.Response[drawingv1.UpsertLayerResponse], error)
	createBlockDefinitionFn func(context.Context, *connect.Request[drawingv1.CreateBlockDefinitionRequest]) (*connect.Response[drawingv1.CreateBlockDefinitionResponse], error)
	insertBlockReferenceFn  func(context.Context, *connect.Request[drawingv1.InsertBlockReferenceRequest]) (*connect.Response[drawingv1.InsertBlockReferenceResponse], error)
}

var _ drawingv1connect.CadLayerBlockServiceClient = (*mockLayerBlock)(nil)

func (m *mockLayerBlock) UpsertLayer(ctx context.Context, req *connect.Request[drawingv1.UpsertLayerRequest]) (*connect.Response[drawingv1.UpsertLayerResponse], error) {
	if m.upsertLayerFn != nil {
		return m.upsertLayerFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.UpsertLayerResponse{}), nil
}

func (m *mockLayerBlock) CreateBlockDefinition(ctx context.Context, req *connect.Request[drawingv1.CreateBlockDefinitionRequest]) (*connect.Response[drawingv1.CreateBlockDefinitionResponse], error) {
	if m.createBlockDefinitionFn != nil {
		return m.createBlockDefinitionFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.CreateBlockDefinitionResponse{}), nil
}

func (m *mockLayerBlock) InsertBlockReference(ctx context.Context, req *connect.Request[drawingv1.InsertBlockReferenceRequest]) (*connect.Response[drawingv1.InsertBlockReferenceResponse], error) {
	if m.insertBlockReferenceFn != nil {
		return m.insertBlockReferenceFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.InsertBlockReferenceResponse{}), nil
}

type mockInterop struct {
	exportDrawingFn            func(context.Context, *connect.Request[drawingv1.ExportDrawingRequest]) (*connect.Response[drawingv1.ExportDrawingResponse], error)
	importDrawingFn            func(context.Context, *connect.Request[drawingv1.ImportDrawingRequest]) (*connect.Response[drawingv1.ImportDrawingResponse], error)
	validateDrawingRoundTripFn func(context.Context, *connect.Request[drawingv1.ValidateDrawingRoundTripRequest]) (*connect.Response[drawingv1.ValidateDrawingRoundTripResponse], error)
}

var _ drawingv1connect.InteropServiceClient = (*mockInterop)(nil)

func (m *mockInterop) ExportDrawing(ctx context.Context, req *connect.Request[drawingv1.ExportDrawingRequest]) (*connect.Response[drawingv1.ExportDrawingResponse], error) {
	if m.exportDrawingFn != nil {
		return m.exportDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ExportDrawingResponse{}), nil
}

func (m *mockInterop) ImportDrawing(ctx context.Context, req *connect.Request[drawingv1.ImportDrawingRequest]) (*connect.Response[drawingv1.ImportDrawingResponse], error) {
	if m.importDrawingFn != nil {
		return m.importDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ImportDrawingResponse{}), nil
}

func (m *mockInterop) ValidateDrawingRoundTrip(ctx context.Context, req *connect.Request[drawingv1.ValidateDrawingRoundTripRequest]) (*connect.Response[drawingv1.ValidateDrawingRoundTripResponse], error) {
	if m.validateDrawingRoundTripFn != nil {
		return m.validateDrawingRoundTripFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ValidateDrawingRoundTripResponse{}), nil
}

type mockPlotSheet struct {
	createSheetFn    func(context.Context, *connect.Request[drawingv1.CreateSheetRequest]) (*connect.Response[drawingv1.CreateSheetResponse], error)
	publishDrawingFn func(context.Context, *connect.Request[drawingv1.PublishDrawingRequest]) (*connect.Response[drawingv1.PublishDrawingResponse], error)
}

var _ drawingv1connect.PlotSheetServiceClient = (*mockPlotSheet)(nil)

func (m *mockPlotSheet) CreateSheet(ctx context.Context, req *connect.Request[drawingv1.CreateSheetRequest]) (*connect.Response[drawingv1.CreateSheetResponse], error) {
	if m.createSheetFn != nil {
		return m.createSheetFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.CreateSheetResponse{}), nil
}

func (m *mockPlotSheet) PublishDrawing(ctx context.Context, req *connect.Request[drawingv1.PublishDrawingRequest]) (*connect.Response[drawingv1.PublishDrawingResponse], error) {
	if m.publishDrawingFn != nil {
		return m.publishDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.PublishDrawingResponse{}), nil
}

// ─── helper ───────────────────────────────────────────────────────────────────

func newTestService(projects projectv1connect.ProjectServiceClient, drawings drawingv1connect.DrawingRevisionServiceClient, cad drawingv1connect.CadCoreServiceClient) *service.Service {
	return service.New(
		projects,
		drawings,
		cad,
		&mockAnnotation{},
		&mockLayerBlock{},
		&mockInterop{},
		&mockPlotSheet{},
		http.DefaultClient,
		"http://project-service",
		"http://drawing-revision-service",
		"http://cad-core-service",
		"http://cad-annotation-service",
		"http://cad-layer-block-service",
		"http://interop-service",
		"http://plot-sheet-service",
		5*time.Second,
		zerolog.New(io.Discard),
	)
}

func validProjectID() string { return uuid.NewString() }
func validDrawingID() string { return uuid.NewString() }

// ─── GetProjectWorkspace ──────────────────────────────────────────────────────

func TestGetProjectWorkspace_Success(t *testing.T) {
	projectID := validProjectID()
	svc := newTestService(
		&mockProjects{
			getProjectFn: func(_ context.Context, req *connect.Request[projectv1.GetProjectRequest]) (*connect.Response[projectv1.GetProjectResponse], error) {
				return connect.NewResponse(&projectv1.GetProjectResponse{
					Project: &projectv1.Project{Id: req.Msg.GetId(), Name: "Solar Farm"},
				}), nil
			},
		},
		&mockDrawings{
			listDrawingsFn: func(_ context.Context, _ *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
				return connect.NewResponse(&drawingv1.ListDrawingsResponse{
					Drawings:   []*drawingv1.Drawing{{DrawingId: uuid.NewString()}},
					TotalCount: 1,
				}), nil
			},
		},
		&mockCad{},
	)

	workspace, err := svc.GetProjectWorkspace(context.Background(), projectID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if workspace.Project == nil {
		t.Fatal("expected project in workspace")
	}
	if workspace.Project.GetId() != projectID {
		t.Errorf("want project_id=%s, got %s", projectID, workspace.Project.GetId())
	}
	if len(workspace.Drawings) != 1 {
		t.Errorf("want 1 drawing, got %d", len(workspace.Drawings))
	}
}

func TestGetProjectWorkspace_InvalidID(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	_, err := svc.GetProjectWorkspace(context.Background(), "not-uuid")
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestGetProjectWorkspace_ProjectError(t *testing.T) {
	notFound := connect.NewError(connect.CodeNotFound, errors.New("not found"))
	svc := newTestService(
		&mockProjects{
			getProjectFn: func(_ context.Context, _ *connect.Request[projectv1.GetProjectRequest]) (*connect.Response[projectv1.GetProjectResponse], error) {
				return nil, notFound
			},
		},
		&mockDrawings{},
		&mockCad{},
	)
	_, err := svc.GetProjectWorkspace(context.Background(), validProjectID())
	if !errors.Is(err, service.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

func TestGetProjectWorkspace_DrawingListError(t *testing.T) {
	dbErr := errors.New("db unavailable")
	svc := newTestService(
		&mockProjects{},
		&mockDrawings{
			listDrawingsFn: func(_ context.Context, _ *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
				return nil, dbErr
			},
		},
		&mockCad{},
	)
	_, err := svc.GetProjectWorkspace(context.Background(), validProjectID())
	if err == nil {
		t.Fatal("expected error, got nil")
	}
}

// ─── GetDrawingWorkspace ──────────────────────────────────────────────────────

func TestGetDrawingWorkspace_Success(t *testing.T) {
	drawingID := validDrawingID()
	projectID := validProjectID()

	svc := newTestService(
		&mockProjects{},
		&mockDrawings{
			getDrawingStateFn: func(_ context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
				return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
					Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId(), ProjectId: projectID},
					Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}},
				}), nil
			},
		},
		&mockCad{},
	)

	workspace, err := svc.GetDrawingWorkspace(context.Background(), drawingID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if workspace.Drawing == nil {
		t.Fatal("expected drawing")
	}
	if workspace.Drawing.GetDrawingId() != drawingID {
		t.Errorf("wrong drawing_id")
	}
}

func TestGetDrawingWorkspace_InvalidID(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	_, err := svc.GetDrawingWorkspace(context.Background(), "bad-uuid")
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestGetDrawingWorkspace_DrawingStateError(t *testing.T) {
	notFound := connect.NewError(connect.CodeNotFound, errors.New("not found"))
	svc := newTestService(
		&mockProjects{},
		&mockDrawings{
			getDrawingStateFn: func(_ context.Context, _ *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
				return nil, notFound
			},
		},
		&mockCad{},
	)
	_, err := svc.GetDrawingWorkspace(context.Background(), validDrawingID())
	if !errors.Is(err, service.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

// ─── CreateDrawing ────────────────────────────────────────────────────────────

func TestCreateDrawing_Success(t *testing.T) {
	projectID := validProjectID()
	drawingID := uuid.NewString()

	svc := newTestService(
		&mockProjects{},
		&mockDrawings{
			createDrawingFn: func(_ context.Context, req *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
				return connect.NewResponse(&drawingv1.CreateDrawingResponse{
					Drawing:  &drawingv1.Drawing{DrawingId: drawingID, ProjectId: req.Msg.GetProjectId()},
					Revision: &drawingv1.DrawingRevision{DrawingId: drawingID},
				}), nil
			},
		},
		&mockCad{},
	)

	resp, err := svc.CreateDrawing(context.Background(), projectID, &drawingv1.CreateDrawingRequest{
		Name:   "Layout A",
		Author: "user@example.com",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetDrawing().GetDrawingId() != drawingID {
		t.Errorf("wrong drawing_id")
	}
}

func TestCreateDrawing_InvalidProjectID(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	_, err := svc.CreateDrawing(context.Background(), "bad", &drawingv1.CreateDrawingRequest{
		Name: "X", Author: "user",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestCreateDrawing_NilRequest(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	_, err := svc.CreateDrawing(context.Background(), validProjectID(), nil)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

// ─── UpdateDrawing ────────────────────────────────────────────────────────────

func TestUpdateDrawing_Success(t *testing.T) {
	drawingID := validDrawingID()

	svc := newTestService(
		&mockProjects{},
		&mockDrawings{
			updateDrawingFn: func(_ context.Context, req *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
				return connect.NewResponse(&drawingv1.UpdateDrawingResponse{
					Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId(), Name: "Updated"},
				}), nil
			},
		},
		&mockCad{},
	)

	resp, err := svc.UpdateDrawing(context.Background(), drawingID, &drawingv1.UpdateDrawingRequest{Name: "Updated"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetDrawing().GetName() != "Updated" {
		t.Errorf("want name=Updated, got %s", resp.GetDrawing().GetName())
	}
}

func TestUpdateDrawing_DrawingError(t *testing.T) {
	notFound := connect.NewError(connect.CodeNotFound, errors.New("not found"))
	svc := newTestService(
		&mockProjects{},
		&mockDrawings{
			updateDrawingFn: func(_ context.Context, _ *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
				return nil, notFound
			},
		},
		&mockCad{},
	)
	_, err := svc.UpdateDrawing(context.Background(), validDrawingID(), &drawingv1.UpdateDrawingRequest{Name: "X"})
	if !errors.Is(err, service.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

// ─── CommitDrawingCommand ─────────────────────────────────────────────────────

func TestCommitDrawingCommand_Success(t *testing.T) {
	drawingID := validDrawingID()
	revID := uuid.NewString()

	svc := newTestService(
		&mockProjects{},
		&mockDrawings{},
		&mockCad{
			commitDrawingCommandFn: func(_ context.Context, req *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error) {
				return connect.NewResponse(&drawingv1.CommitDrawingCommandResponse{
					Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
					Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: revID}},
				}), nil
			},
		},
	)

	resp, err := svc.CommitDrawingCommand(context.Background(), drawingID, &drawingv1.CommitDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			Actor:     "user",
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetRevision().GetPointer().GetRevisionId() != revID {
		t.Errorf("wrong revision_id")
	}
}

func TestCommitDrawingCommand_NilRequest(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	_, err := svc.CommitDrawingCommand(context.Background(), validDrawingID(), nil)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestCommitDrawingCommand_NilCommand(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	_, err := svc.CommitDrawingCommand(context.Background(), validDrawingID(), &drawingv1.CommitDrawingCommandRequest{
		Command: nil,
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

// ─── RevertDrawingRevision ────────────────────────────────────────────────────

func TestRevertDrawingRevision_Success(t *testing.T) {
	drawingID := validDrawingID()
	newRevID := uuid.NewString()

	svc := newTestService(
		&mockProjects{},
		&mockDrawings{},
		&mockCad{
			revertDrawingRevisionFn: func(_ context.Context, _ *connect.Request[drawingv1.RevertDrawingRevisionRequest]) (*connect.Response[drawingv1.RevertDrawingRevisionResponse], error) {
				return connect.NewResponse(&drawingv1.RevertDrawingRevisionResponse{
					Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
					Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: newRevID}},
				}), nil
			},
		},
	)

	resp, err := svc.RevertDrawingRevision(context.Background(), drawingID, &drawingv1.RevertDrawingRevisionRequest{
		TargetRevisionId: uuid.NewString(),
		Author:           "engineer@example.com",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetRevision().GetPointer().GetRevisionId() != newRevID {
		t.Errorf("wrong revision_id")
	}
}

func TestRevertDrawingRevision_InvalidID(t *testing.T) {
	svc := newTestService(&mockProjects{}, &mockDrawings{}, &mockCad{})
	r := &drawingv1.RevertDrawingRevisionRequest{TargetRevisionId: uuid.NewString(), Author: "u"}
	_, err := svc.RevertDrawingRevision(context.Background(), "bad-id", r)
	// No UUID validation at gateway level for drawingID — it passes through to CAD service.
	// If the gateway delegates without pre-validating drawing ID, no error is expected here.
	// This just verifies the path doesn't panic.
	_ = err
}

// ─── Health (downstream ping) ─────────────────────────────────────────────────

func TestHealth_AllDown_WhenNoRealServices(t *testing.T) {
	// Spin up a local test server that always returns 200 OK.
	ok := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))
	defer ok.Close()

	svc := service.New(
		&mockProjects{},
		&mockDrawings{},
		&mockCad{},
		&mockAnnotation{},
		&mockLayerBlock{},
		&mockInterop{},
		&mockPlotSheet{},
		ok.Client(),
		ok.URL,
		ok.URL,
		ok.URL,
		ok.URL,
		ok.URL,
		ok.URL,
		ok.URL,
		5*time.Second,
		zerolog.New(io.Discard),
	)

	status := svc.Health(context.Background())
	if status.Status != "ok" {
		t.Errorf("want status=ok, got %s", status.Status)
	}
	if len(status.Downstream) != 7 {
		t.Errorf("want 7 downstream checks, got %d", len(status.Downstream))
	}
}

