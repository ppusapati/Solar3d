package service_test

import (
	"context"
	"errors"
	"io"
	"testing"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/cad-core-service/internal/service"
)

// ─── mock DrawingRevisionServiceClient ───────────────────────────────────────

type mockRevisions struct {
	createDrawingFn        func(context.Context, *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error)
	getDrawingFn           func(context.Context, *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error)
	listDrawingsFn         func(context.Context, *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error)
	updateDrawingFn        func(context.Context, *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error)
	getDrawingStateFn      func(context.Context, *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error)
	listDrawingRevisionsFn func(context.Context, *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error)
	getDrawingRevisionFn   func(context.Context, *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error)
	storeDrawingRevisionFn func(context.Context, *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error)
}

var _ drawingv1connect.DrawingRevisionServiceClient = (*mockRevisions)(nil)

func (m *mockRevisions) CreateDrawing(ctx context.Context, req *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
	if m.createDrawingFn != nil {
		return m.createDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.CreateDrawingResponse{}), nil
}
func (m *mockRevisions) GetDrawing(ctx context.Context, req *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
	if m.getDrawingFn != nil {
		return m.getDrawingFn(ctx, req)
	}
	revID := uuid.NewString()
	return connect.NewResponse(&drawingv1.GetDrawingResponse{
		Drawing: &drawingv1.Drawing{
			DrawingId:         req.Msg.GetDrawingId(),
			CurrentRevisionId: revID,
		},
	}), nil
}
func (m *mockRevisions) ListDrawings(ctx context.Context, req *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
	if m.listDrawingsFn != nil {
		return m.listDrawingsFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ListDrawingsResponse{}), nil
}
func (m *mockRevisions) UpdateDrawing(ctx context.Context, req *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
	if m.updateDrawingFn != nil {
		return m.updateDrawingFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.UpdateDrawingResponse{}), nil
}
func (m *mockRevisions) GetDrawingState(ctx context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
	if m.getDrawingStateFn != nil {
		return m.getDrawingStateFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()},
		Revision: &drawingv1.DrawingRevision{Entities: []*drawingv1.DrawingEntity{}},
	}), nil
}
func (m *mockRevisions) ListDrawingRevisions(ctx context.Context, req *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error) {
	if m.listDrawingRevisionsFn != nil {
		return m.listDrawingRevisionsFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.ListDrawingRevisionsResponse{}), nil
}
func (m *mockRevisions) GetDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error) {
	if m.getDrawingRevisionFn != nil {
		return m.getDrawingRevisionFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.GetDrawingRevisionResponse{}), nil
}
func (m *mockRevisions) StoreDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
	if m.storeDrawingRevisionFn != nil {
		return m.storeDrawingRevisionFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()},
		Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}},
	}), nil
}

// ─── helpers ──────────────────────────────────────────────────────────────────

func newTestService(revisions drawingv1connect.DrawingRevisionServiceClient) *service.Service {
	return service.New(revisions, zerolog.New(io.Discard), 5*time.Second)
}

func validDrawingID() string { return uuid.NewString() }

func createMutation(drawingID, entityID string, action drawingv1.RevisionAction) *drawingv1.DrawingMutation {
	entity := &drawingv1.DrawingEntity{
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
	}
	mut := &drawingv1.DrawingMutation{
		EntityId: entityID,
		Action:   action,
		After:    entity,
	}
	if action == drawingv1.RevisionAction_REVISION_ACTION_DELETE {
		mut.Before = entity
		mut.After = nil
	}
	return mut
}

func validCommand(drawingID string) *drawingv1.DrawingCommand {
	return &drawingv1.DrawingCommand{
		CommandId: uuid.NewString(),
		DrawingId: drawingID,
		Actor:     "engineer@example.com",
		Mutations: []*drawingv1.DrawingMutation{
			createMutation(drawingID, uuid.NewString(), drawingv1.RevisionAction_REVISION_ACTION_CREATE),
		},
	}
}

// ─── ValidateDrawingCommand ───────────────────────────────────────────────────

func TestValidateDrawingCommand_ValidCreate(t *testing.T) {
	drawingID := validDrawingID()
	svc := newTestService(&mockRevisions{})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: validCommand(drawingID),
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !resp.GetValid() {
		t.Errorf("expected valid=true, got violations: %v", resp.GetViolations())
	}
}

func TestValidateDrawingCommand_InvalidDrawingID(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	_, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			DrawingId: "not-a-uuid",
			Actor:     "user",
			CommandId: uuid.NewString(),
			Mutations: []*drawingv1.DrawingMutation{createMutation("bad", uuid.NewString(), drawingv1.RevisionAction_REVISION_ACTION_CREATE)},
		},
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestValidateDrawingCommand_EmptyActor(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	drawingID := validDrawingID()
	_, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			DrawingId: drawingID,
			Actor:     "",
			CommandId: uuid.NewString(),
			Mutations: []*drawingv1.DrawingMutation{createMutation(drawingID, uuid.NewString(), drawingv1.RevisionAction_REVISION_ACTION_CREATE)},
		},
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestValidateDrawingCommand_EmptyCommandID(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	drawingID := validDrawingID()
	_, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			DrawingId: drawingID,
			Actor:     "user",
			CommandId: "   ",
			Mutations: []*drawingv1.DrawingMutation{createMutation(drawingID, uuid.NewString(), drawingv1.RevisionAction_REVISION_ACTION_CREATE)},
		},
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestValidateDrawingCommand_NoMutations(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	drawingID := validDrawingID()
	_, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			DrawingId: drawingID,
			Actor:     "user",
			CommandId: uuid.NewString(),
			Mutations: nil,
		},
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestValidateDrawingCommand_CreateWithoutAfter(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	svc := newTestService(&mockRevisions{})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE, After: nil},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected validation violations for CREATE without after")
	}
	if len(resp.GetViolations()) == 0 {
		t.Error("expected at least one violation")
	}
}

func TestValidateDrawingCommand_UpdateWithoutBefore(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	after := &drawingv1.DrawingEntity{
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
	}
	svc := newTestService(&mockRevisions{
		getDrawingStateFn: func(_ context.Context, _ *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
			return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
				Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
				Revision: &drawingv1.DrawingRevision{Entities: []*drawingv1.DrawingEntity{after}},
			}), nil
		},
	})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_UPDATE, Before: nil, After: after},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected violation for UPDATE without before")
	}
}

func TestValidateDrawingCommand_DeleteWithoutBefore(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	svc := newTestService(&mockRevisions{})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_DELETE, Before: nil},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected violation for DELETE without before")
	}
}

func TestValidateDrawingCommand_EntityAlreadyExists(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	existing := &drawingv1.DrawingEntity{
		Header: &drawingv1.EntityHeader{EntityId: entityID, DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE},
		Geometry: &drawingv1.DrawingEntity_Polyline{
			Polyline: &drawingv1.PolylineEntity{Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 1, Y: 1}}},
		},
	}
	svc := newTestService(&mockRevisions{
		getDrawingStateFn: func(_ context.Context, _ *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
			return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
				Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
				Revision: &drawingv1.DrawingRevision{Entities: []*drawingv1.DrawingEntity{existing}},
			}), nil
		},
	})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(), DrawingId: drawingID, Actor: "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE, After: existing},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected violation: entity already exists")
	}
}

func TestValidateDrawingCommand_PolylineTooFewVertices(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	badEntity := &drawingv1.DrawingEntity{
		Header: &drawingv1.EntityHeader{EntityId: entityID, DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE},
		Geometry: &drawingv1.DrawingEntity_Polyline{
			Polyline: &drawingv1.PolylineEntity{Vertices: []*commonv1.Point2D{{X: 0, Y: 0}}},
		},
	}
	svc := newTestService(&mockRevisions{})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(), DrawingId: drawingID, Actor: "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE, After: badEntity},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected violation: polyline too few vertices")
	}
}

func TestValidateDrawingCommand_TextEmptyContent(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	badEntity := &drawingv1.DrawingEntity{
		Header: &drawingv1.EntityHeader{EntityId: entityID, DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_TEXT},
		Geometry: &drawingv1.DrawingEntity_Text{
			Text: &drawingv1.TextEntity{Text: "   ", Height: 12},
		},
	}
	svc := newTestService(&mockRevisions{})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(), DrawingId: drawingID, Actor: "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE, After: badEntity},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected violation: text content is empty")
	}
}

func TestValidateDrawingCommand_BlockReferenceEmptyDefinition(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	badEntity := &drawingv1.DrawingEntity{
		Header: &drawingv1.EntityHeader{EntityId: entityID, DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_BLOCK_REFERENCE},
		Geometry: &drawingv1.DrawingEntity_BlockReference{
			BlockReference: &drawingv1.BlockReferenceEntity{BlockDefinitionId: "", ScaleX: 1, ScaleY: 1},
		},
	}
	svc := newTestService(&mockRevisions{})

	resp, err := svc.ValidateDrawingCommand(context.Background(), &drawingv1.ValidateDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(), DrawingId: drawingID, Actor: "user",
			Mutations: []*drawingv1.DrawingMutation{
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE, After: badEntity},
			},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetValid() {
		t.Error("expected violation: block_definition_id is required")
	}
}

// ─── CommitDrawingCommand ─────────────────────────────────────────────────────

func TestCommitDrawingCommand_Success(t *testing.T) {
	drawingID := validDrawingID()
	revisionID := uuid.NewString()
	stored := false

	svc := newTestService(&mockRevisions{
		storeDrawingRevisionFn: func(_ context.Context, req *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
			stored = true
			resp := connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{
				Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
				Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: revisionID}},
			})
			resp.Header().Set(service.HeaderOutcomeCode, service.OutcomeCommitted)
			resp.Header().Set(service.HeaderAttemptID, "attempt-1")
			resp.Header().Set(service.HeaderHeadVersion, "2")
			return resp, nil
		},
	})

	resp, metadata, err := svc.CommitDrawingCommand(context.Background(), &drawingv1.CommitDrawingCommandRequest{
		Command: validCommand(drawingID),
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !stored {
		t.Error("StoreDrawingRevision was not called")
	}
	if resp.GetRevision().GetPointer().GetRevisionId() != revisionID {
		t.Errorf("wrong revision_id: got %s", resp.GetRevision().GetPointer().GetRevisionId())
	}
	if metadata.OutcomeCode != service.OutcomeCommitted {
		t.Errorf("wrong outcome code: got %s", metadata.OutcomeCode)
	}
	if metadata.AttemptID != "attempt-1" {
		t.Errorf("wrong attempt id: got %s", metadata.AttemptID)
	}
}

func TestCommitDrawingCommand_StaleRevision(t *testing.T) {
	drawingID := validDrawingID()
	baseRevID := uuid.NewString()
	headRevID := uuid.NewString()

	svc := newTestService(&mockRevisions{
		getDrawingFn: func(_ context.Context, _ *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
			return connect.NewResponse(&drawingv1.GetDrawingResponse{
				Drawing: &drawingv1.Drawing{DrawingId: drawingID, CurrentRevisionId: headRevID, RevisionCount: 7},
			}), nil
		},
		storeDrawingRevisionFn: func(_ context.Context, _ *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
			connectErr := connect.NewError(connect.CodeFailedPrecondition, errors.New("base revision is stale"))
			connectErr.Meta().Set(service.HeaderOutcomeCode, service.OutcomeStaleBase)
			connectErr.Meta().Set(service.HeaderAttemptID, "attempt-stale")
			connectErr.Meta().Set(service.HeaderHeadVersion, "7")
			connectErr.Meta().Set("x-solar3d-error-code", service.ConflictCodeStaleRevision)
			connectErr.Meta().Set("x-solar3d-base-revision-id", baseRevID)
			connectErr.Meta().Set("x-solar3d-head-revision-id", headRevID)
			connectErr.Meta().Set("retry-after", "0.300")
			return nil, connectErr
		},
	})

	_, _, err := svc.CommitDrawingCommand(context.Background(), &drawingv1.CommitDrawingCommandRequest{
		Command:        validCommand(drawingID),
		BaseRevisionId: baseRevID, // stale — different from headRevID
	})
	if !errors.Is(err, service.ErrConflict) {
		t.Errorf("want ErrConflict on stale revision, got %v", err)
	}
	var conflictErr *service.ConflictError
	if !errors.As(err, &conflictErr) {
		t.Fatalf("expected *service.ConflictError, got %T", err)
	}
	if conflictErr.Code != service.ConflictCodeStaleRevision {
		t.Errorf("want stale conflict code %q, got %q", service.ConflictCodeStaleRevision, conflictErr.Code)
	}
	if conflictErr.OutcomeCode != service.OutcomeStaleBase {
		t.Errorf("want stale_base outcome, got %q", conflictErr.OutcomeCode)
	}
	if conflictErr.AttemptID != "attempt-stale" {
		t.Errorf("want attempt id attempt-stale, got %q", conflictErr.AttemptID)
	}
	if conflictErr.BaseRevisionID != baseRevID {
		t.Errorf("want base revision id %s, got %s", baseRevID, conflictErr.BaseRevisionID)
	}
	if conflictErr.HeadRevisionID != headRevID {
		t.Errorf("want head revision id %s, got %s", headRevID, conflictErr.HeadRevisionID)
	}
	if conflictErr.RetryAfterMs <= 0 {
		t.Errorf("want positive retry delay, got %d", conflictErr.RetryAfterMs)
	}
}

func TestCommitDrawingCommand_ValidationViolations_ReturnsErrInvalidInput(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	svc := newTestService(&mockRevisions{})

	_, _, err := svc.CommitDrawingCommand(context.Background(), &drawingv1.CommitDrawingCommandRequest{
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     "user",
			Mutations: []*drawingv1.DrawingMutation{
				// CREATE with missing after → violation
				{EntityId: entityID, Action: drawingv1.RevisionAction_REVISION_ACTION_CREATE, After: nil},
			},
		},
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput on commit with violations, got %v", err)
	}
}

func TestCommitDrawingCommand_DrawingNotFound(t *testing.T) {
	drawingID := validDrawingID()
	notFound := connect.NewError(connect.CodeNotFound, errors.New("drawing not found"))

	svc := newTestService(&mockRevisions{
		getDrawingFn: func(_ context.Context, _ *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
			return nil, notFound
		},
	})

	_, _, err := svc.CommitDrawingCommand(context.Background(), &drawingv1.CommitDrawingCommandRequest{
		Command: validCommand(drawingID),
	})
	if !errors.Is(err, service.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

// ─── RevertDrawingRevision ────────────────────────────────────────────────────

func TestRevertDrawingRevision_Success(t *testing.T) {
	drawingID := validDrawingID()
	targetRevID := uuid.NewString()
	newRevID := uuid.NewString()
	stored := false

	svc := newTestService(&mockRevisions{
		getDrawingStateFn: func(_ context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
			return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
				Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
				Revision: &drawingv1.DrawingRevision{Entities: []*drawingv1.DrawingEntity{}},
			}), nil
		},
		storeDrawingRevisionFn: func(_ context.Context, _ *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
			stored = true
			return connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{
				Drawing:  &drawingv1.Drawing{DrawingId: drawingID},
				Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: newRevID}},
			}), nil
		},
	})

	resp, err := svc.RevertDrawingRevision(context.Background(), &drawingv1.RevertDrawingRevisionRequest{
		DrawingId:        drawingID,
		TargetRevisionId: targetRevID,
		Author:           "engineer@example.com",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !stored {
		t.Error("StoreDrawingRevision was not called")
	}
	if resp.GetRevision().GetPointer().GetRevisionId() != newRevID {
		t.Errorf("want revision_id=%s, got %s", newRevID, resp.GetRevision().GetPointer().GetRevisionId())
	}
}

func TestRevertDrawingRevision_InvalidDrawingID(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	_, err := svc.RevertDrawingRevision(context.Background(), &drawingv1.RevertDrawingRevisionRequest{
		DrawingId:        "not-uuid",
		TargetRevisionId: uuid.NewString(),
		Author:           "user",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestRevertDrawingRevision_InvalidTargetRevisionID(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	_, err := svc.RevertDrawingRevision(context.Background(), &drawingv1.RevertDrawingRevisionRequest{
		DrawingId:        validDrawingID(),
		TargetRevisionId: "bad",
		Author:           "user",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestRevertDrawingRevision_EmptyAuthor(t *testing.T) {
	svc := newTestService(&mockRevisions{})
	_, err := svc.RevertDrawingRevision(context.Background(), &drawingv1.RevertDrawingRevisionRequest{
		DrawingId:        validDrawingID(),
		TargetRevisionId: uuid.NewString(),
		Author:           "",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

