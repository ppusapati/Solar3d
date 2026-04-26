package service_test

import (
	"context"
	"io"
	"testing"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/cad-layer-block-service/internal/service"
)

type mockRevisions struct {
	state *drawingv1.GetDrawingStateResponse
}

func (m *mockRevisions) CreateDrawing(context.Context, *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.CreateDrawingResponse{}), nil
}
func (m *mockRevisions) GetDrawing(context.Context, *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.GetDrawingResponse{}), nil
}
func (m *mockRevisions) ListDrawings(context.Context, *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
	return connect.NewResponse(&drawingv1.ListDrawingsResponse{}), nil
}
func (m *mockRevisions) UpdateDrawing(context.Context, *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.UpdateDrawingResponse{}), nil
}
func (m *mockRevisions) GetDrawingState(_ context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
	if m.state != nil {
		return connect.NewResponse(m.state), nil
	}
	return connect.NewResponse(&drawingv1.GetDrawingStateResponse{Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()}, Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}}}), nil
}
func (m *mockRevisions) ListDrawingRevisions(context.Context, *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error) {
	return connect.NewResponse(&drawingv1.ListDrawingRevisionsResponse{}), nil
}
func (m *mockRevisions) GetDrawingRevision(context.Context, *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.GetDrawingRevisionResponse{}), nil
}
func (m *mockRevisions) StoreDrawingRevision(context.Context, *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{}), nil
}

type mockCad struct {
	commitFn func(context.Context, *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error)
}

func (m *mockCad) ValidateDrawingCommand(context.Context, *connect.Request[drawingv1.ValidateDrawingCommandRequest]) (*connect.Response[drawingv1.ValidateDrawingCommandResponse], error) {
	return connect.NewResponse(&drawingv1.ValidateDrawingCommandResponse{Valid: true}), nil
}
func (m *mockCad) CommitDrawingCommand(ctx context.Context, req *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error) {
	if m.commitFn != nil {
		return m.commitFn(ctx, req)
	}
	return connect.NewResponse(&drawingv1.CommitDrawingCommandResponse{Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetCommand().GetDrawingId()}, Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}}}), nil
}
func (m *mockCad) RevertDrawingRevision(context.Context, *connect.Request[drawingv1.RevertDrawingRevisionRequest]) (*connect.Response[drawingv1.RevertDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.RevertDrawingRevisionResponse{}), nil
}

var _ drawingv1connect.DrawingRevisionServiceClient = (*mockRevisions)(nil)
var _ drawingv1connect.CadCoreServiceClient = (*mockCad)(nil)

func TestInsertBlockReference_RequiresDefinition(t *testing.T) {
	svc := service.New(&mockRevisions{}, &mockCad{}, zerolog.New(io.Discard), 5*time.Second)
	_, err := svc.InsertBlockReference(context.Background(), &drawingv1.InsertBlockReferenceRequest{DrawingId: uuid.NewString(), Author: "cad@example.com", BlockReference: &drawingv1.BlockReferenceEntity{BlockDefinitionId: "missing", InsertionPoint: &commonv1.Point2D{X: 0, Y: 0}, ScaleX: 1, ScaleY: 1}})
	if err == nil {
		t.Fatal("expected missing block definition error")
	}
}

func TestUpsertLayer_CommitsManagedLayerDefinition(t *testing.T) {
	var captured *drawingv1.CommitDrawingCommandRequest
	svc := service.New(&mockRevisions{}, &mockCad{commitFn: func(_ context.Context, req *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error) {
		captured = req.Msg
		return connect.NewResponse(&drawingv1.CommitDrawingCommandResponse{Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetCommand().GetDrawingId()}, Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}}}), nil
	}}, zerolog.New(io.Discard), 5*time.Second)

	_, err := svc.UpsertLayer(context.Background(), &drawingv1.UpsertLayerRequest{DrawingId: uuid.NewString(), Author: "cad@example.com", Layer: &drawingv1.LayerDefinitionEntity{LayerId: "site", Name: "Site", ColorHex: "#00AA00", Visible: true, Plottable: true}})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if captured == nil || captured.GetCommand().GetMutations()[0].GetAfter().GetHeader().GetEntityType() != drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_LAYER_DEFINITION {
		t.Fatal("expected layer definition mutation")
	}
}

