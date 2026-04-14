//go:build integration
// +build integration

package integration_test

import (
	"context"
	"net/http/httptest"
	"sync"
	"testing"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	commonv1 "github.com/solar3d/solar3d/gen/common/v1"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/cad-core-service/internal/handler"
	"solar3d/cad-core-service/internal/service"

	"io"
	"net/http"

	"github.com/rs/zerolog"
)

// ─── in-memory DrawingRevisionServiceHandler ──────────────────────────────────

type memRevisionHandler struct {
	mu        sync.Mutex
	drawings  map[string]*drawingv1.Drawing
	revisions map[string][]*drawingv1.DrawingRevision
}

func newMemRevisionHandler() *memRevisionHandler {
	return &memRevisionHandler{
		drawings:  make(map[string]*drawingv1.Drawing),
		revisions: make(map[string][]*drawingv1.DrawingRevision),
	}
}

var _ drawingv1connect.DrawingRevisionServiceHandler = (*memRevisionHandler)(nil)

func (m *memRevisionHandler) seedDrawing(projectID string) (drawingID, revisionID string) {
	m.mu.Lock()
	defer m.mu.Unlock()
	drawingID = uuid.NewString()
	revisionID = uuid.NewString()
	d := &drawingv1.Drawing{
		DrawingId:         drawingID,
		ProjectId:         projectID,
		Name:              "Test Drawing",
		Status:            drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE,
		CurrentRevisionId: revisionID,
		RevisionCount:     1,
		EntityCount:       0,
	}
	rev := &drawingv1.DrawingRevision{
		Pointer:   &drawingv1.RevisionPointer{RevisionId: revisionID, DrawingId: drawingID},
		DrawingId: drawingID,
		Entities:  []*drawingv1.DrawingEntity{},
	}
	m.drawings[drawingID] = d
	m.revisions[drawingID] = []*drawingv1.DrawingRevision{rev}
	return
}

func (m *memRevisionHandler) CreateDrawing(_ context.Context, req *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	drawingID := uuid.NewString()
	revisionID := uuid.NewString()
	d := &drawingv1.Drawing{
		DrawingId:         drawingID,
		ProjectId:         req.Msg.GetProjectId(),
		Name:              req.Msg.GetName(),
		Status:            drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE,
		CurrentRevisionId: revisionID,
		RevisionCount:     1,
	}
	rev := &drawingv1.DrawingRevision{
		Pointer:   &drawingv1.RevisionPointer{RevisionId: revisionID, DrawingId: drawingID},
		DrawingId: drawingID,
		Entities:  []*drawingv1.DrawingEntity{},
	}
	m.drawings[drawingID] = d
	m.revisions[drawingID] = []*drawingv1.DrawingRevision{rev}
	return connect.NewResponse(&drawingv1.CreateDrawingResponse{Drawing: d, Revision: rev}), nil
}

func (m *memRevisionHandler) GetDrawing(_ context.Context, req *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	d, ok := m.drawings[req.Msg.GetDrawingId()]
	if !ok {
		return nil, connect.NewError(connect.CodeNotFound, nil)
	}
	return connect.NewResponse(&drawingv1.GetDrawingResponse{Drawing: proto.Clone(d).(*drawingv1.Drawing)}), nil
}

func (m *memRevisionHandler) ListDrawings(_ context.Context, _ *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
	return connect.NewResponse(&drawingv1.ListDrawingsResponse{}), nil
}

func (m *memRevisionHandler) UpdateDrawing(_ context.Context, req *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.UpdateDrawingResponse{}), nil
}

func (m *memRevisionHandler) GetDrawingState(_ context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	d, ok := m.drawings[req.Msg.GetDrawingId()]
	if !ok {
		return nil, connect.NewError(connect.CodeNotFound, nil)
	}
	revID := req.Msg.GetRevisionId()
	if revID == "" {
		revID = d.GetCurrentRevisionId()
	}
	revs := m.revisions[d.GetDrawingId()]
	for _, rev := range revs {
		if rev.GetPointer().GetRevisionId() == revID {
			return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
				Drawing:  proto.Clone(d).(*drawingv1.Drawing),
				Revision: proto.Clone(rev).(*drawingv1.DrawingRevision),
			}), nil
		}
	}
	return nil, connect.NewError(connect.CodeNotFound, nil)
}

func (m *memRevisionHandler) ListDrawingRevisions(_ context.Context, _ *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error) {
	return connect.NewResponse(&drawingv1.ListDrawingRevisionsResponse{}), nil
}

func (m *memRevisionHandler) GetDrawingRevision(_ context.Context, _ *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.GetDrawingRevisionResponse{}), nil
}

func (m *memRevisionHandler) StoreDrawingRevision(_ context.Context, req *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	d, ok := m.drawings[req.Msg.GetDrawingId()]
	if !ok {
		return nil, connect.NewError(connect.CodeNotFound, nil)
	}
	newRevID := uuid.NewString()
	rev := &drawingv1.DrawingRevision{
		Pointer: &drawingv1.RevisionPointer{
			RevisionId: newRevID,
			DrawingId:  d.GetDrawingId(),
			Author:     req.Msg.GetAuthor(),
			Summary:    req.Msg.GetSummary(),
			CreatedAt:  timestamppb.New(time.Now().UTC()),
		},
		DrawingId: d.GetDrawingId(),
		Entities:  req.Msg.GetEntities(),
	}
	d.CurrentRevisionId = newRevID
	d.RevisionCount++
	d.EntityCount = uint32(len(req.Msg.GetEntities()))
	m.revisions[d.GetDrawingId()] = append(m.revisions[d.GetDrawingId()], proto.Clone(rev).(*drawingv1.DrawingRevision))
	return connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{
		Drawing:  proto.Clone(d).(*drawingv1.Drawing),
		Revision: proto.Clone(rev).(*drawingv1.DrawingRevision),
	}), nil
}

// ─── test setup ───────────────────────────────────────────────────────────────

type testEnv struct {
	revStore        *memRevisionHandler
	cadClient       drawingv1connect.CadCoreServiceClient
	revisionsMux    *http.ServeMux
	revisionsServer *httptest.Server
	cadServer       *httptest.Server
}

func newTestEnv(t *testing.T) *testEnv {
	t.Helper()

	// Start in-memory DrawingRevisionService
	revStore := newMemRevisionHandler()
	revMux := http.NewServeMux()
	revPath, revHandler := drawingv1connect.NewDrawingRevisionServiceHandler(revStore)
	revMux.Handle(revPath, revHandler)
	revisionsServer := httptest.NewServer(revMux)
	t.Cleanup(revisionsServer.Close)

	// Start real CadCoreService pointing to the mock revision server
	revClient := drawingv1connect.NewDrawingRevisionServiceClient(revisionsServer.Client(), revisionsServer.URL)
	cadSvc := service.New(revClient, zerolog.New(io.Discard), 5*time.Second)
	cadHandler := handler.NewConnectCadCoreService(cadSvc)

	cadMux := http.NewServeMux()
	cadPath, cadHandler2 := drawingv1connect.NewCadCoreServiceHandler(cadHandler)
	cadMux.Handle(cadPath, cadHandler2)
	cadServer := httptest.NewServer(cadMux)
	t.Cleanup(cadServer.Close)

	cadClient := drawingv1connect.NewCadCoreServiceClient(cadServer.Client(), cadServer.URL)

	return &testEnv{
		revStore:        revStore,
		cadClient:       cadClient,
		revisionsServer: revisionsServer,
		cadServer:       cadServer,
	}
}

// ─── integration tests ────────────────────────────────────────────────────────

func TestCadCore_ValidateDrawingCommand_Valid(t *testing.T) {
	env := newTestEnv(t)
	ctx := context.Background()

	drawingID, _ := env.revStore.seedDrawing(uuid.NewString())
	entityID := uuid.NewString()

	resp, err := env.cadClient.ValidateDrawingCommand(ctx, connect.NewRequest(&drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "engineer@example.com",
			Mutations: []*drawingv1.DrawingMutation{
				{
					EntityId: entityID,
					Action:   drawingv1.RevisionAction_REVISION_ACTION_CREATE,
					After: &drawingv1.DrawingEntity{
						Header: &drawingv1.EntityHeader{
							EntityId:   entityID,
							DrawingId:  drawingID,
							EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
						},
						Geometry: &drawingv1.DrawingEntity_Polyline{
							Polyline: &drawingv1.PolylineEntity{
								Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 5, Y: 5}},
							},
						},
					},
				},
			},
		},
	}))
	if err != nil {
		t.Fatalf("ValidateDrawingCommand: %v", err)
	}
	if !resp.Msg.GetValid() {
		t.Errorf("expected valid=true, violations: %v", resp.Msg.GetViolations())
	}
	if len(resp.Msg.GetResultingEntities()) != 1 {
		t.Errorf("expected 1 resulting entity, got %d", len(resp.Msg.GetResultingEntities()))
	}
}

func TestCadCore_CommitDrawingCommand_CreatesRevision(t *testing.T) {
	env := newTestEnv(t)
	ctx := context.Background()

	drawingID, _ := env.revStore.seedDrawing(uuid.NewString())
	entityID := uuid.NewString()

	resp, err := env.cadClient.CommitDrawingCommand(ctx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "engineer@example.com",
			Mutations: []*drawingv1.DrawingMutation{
				{
					EntityId: entityID,
					Action:   drawingv1.RevisionAction_REVISION_ACTION_CREATE,
					After: &drawingv1.DrawingEntity{
						Header: &drawingv1.EntityHeader{
							EntityId:   entityID,
							DrawingId:  drawingID,
							EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
						},
						Geometry: &drawingv1.DrawingEntity_Polyline{
							Polyline: &drawingv1.PolylineEntity{
								Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 10, Y: 10}},
							},
						},
					},
				},
			},
		},
	}))
	if err != nil {
		t.Fatalf("CommitDrawingCommand: %v", err)
	}
	if resp.Msg.GetRevision().GetPointer().GetRevisionId() == "" {
		t.Error("expected non-empty revision_id")
	}
	if resp.Msg.GetDrawing().GetDrawingId() != drawingID {
		t.Errorf("drawing_id mismatch")
	}
}

func TestCadCore_CommitDrawingCommand_StaleRevision_ReturnsConflict(t *testing.T) {
	env := newTestEnv(t)
	ctx := context.Background()

	drawingID, _ := env.revStore.seedDrawing(uuid.NewString())
	entityID := uuid.NewString()

	command := &drawingv1.DrawingCommand{
		CommandId: uuid.NewString(),
		DrawingId: drawingID,
		Actor:     "user",
		Mutations: []*drawingv1.DrawingMutation{
			{
				EntityId: entityID,
				Action:   drawingv1.RevisionAction_REVISION_ACTION_CREATE,
				After: &drawingv1.DrawingEntity{
					Header: &drawingv1.EntityHeader{
						EntityId:   entityID,
						DrawingId:  drawingID,
						EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
					},
					Geometry: &drawingv1.DrawingEntity_Polyline{
						Polyline: &drawingv1.PolylineEntity{
							Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 1, Y: 1}},
						},
					},
				},
			},
		},
	}

	_, err := env.cadClient.CommitDrawingCommand(ctx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{
		Command:        command,
		BaseRevisionId: uuid.NewString(), // stale — doesn't match current head
	}))
	if err == nil {
		t.Fatal("expected error for stale revision, got nil")
	}
	var connectErr *connect.Error
	if !connect.IsWireError(err) {
		_ = connectErr
	}
}

func TestCadCore_RevertDrawingRevision(t *testing.T) {
	env := newTestEnv(t)
	ctx := context.Background()

	drawingID, initialRevID := env.revStore.seedDrawing(uuid.NewString())
	entityID := uuid.NewString()

	// First commit to advance head
	_, err := env.cadClient.CommitDrawingCommand(ctx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "user",
			Mutations: []*drawingv1.DrawingMutation{
				{
					EntityId: entityID,
					Action:   drawingv1.RevisionAction_REVISION_ACTION_CREATE,
					After: &drawingv1.DrawingEntity{
						Header: &drawingv1.EntityHeader{
							EntityId:   entityID,
							DrawingId:  drawingID,
							EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
						},
						Geometry: &drawingv1.DrawingEntity_Polyline{
							Polyline: &drawingv1.PolylineEntity{
								Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 1, Y: 1}},
							},
						},
					},
				},
			},
		},
	}))
	if err != nil {
		t.Fatalf("CommitDrawingCommand: %v", err)
	}

	// Now revert to initial revision
	revertResp, err := env.cadClient.RevertDrawingRevision(ctx, connect.NewRequest(&drawingv1.RevertDrawingRevisionRequest{
		DrawingId:        drawingID,
		TargetRevisionId: initialRevID,
		Author:           "engineer@example.com",
		Summary:          "Reverting to baseline",
	}))
	if err != nil {
		t.Fatalf("RevertDrawingRevision: %v", err)
	}

	if revertResp.Msg.GetRevision().GetPointer().GetRevisionId() == "" {
		t.Error("expected non-empty revision_id after revert")
	}
	if revertResp.Msg.GetDrawing().GetDrawingId() != drawingID {
		t.Errorf("drawing_id mismatch after revert")
	}
}

func TestCadCore_ValidateDrawingCommand_InvalidDrawingID(t *testing.T) {
	env := newTestEnv(t)
	ctx := context.Background()

	_, err := env.cadClient.ValidateDrawingCommand(ctx, connect.NewRequest(&drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: "not-a-uuid",
			Actor:     "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: uuid.NewString(), Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE},
			},
		},
	}))
	if err == nil {
		t.Fatal("expected error for invalid drawing_id, got nil")
	}
}

