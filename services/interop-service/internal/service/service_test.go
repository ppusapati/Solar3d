package service_test

import (
	"context"
	"io"
	"strings"
	"testing"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "github.com/solar3d/solar3d/gen/common/v1"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/interop-service/internal/service"
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
	entity := &drawingv1.DrawingEntity{Header: &drawingv1.EntityHeader{EntityId: uuid.NewString(), DrawingId: req.Msg.GetDrawingId(), EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE}, Geometry: &drawingv1.DrawingEntity_Polyline{Polyline: &drawingv1.PolylineEntity{Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 10, Y: 0}}}}}
	return connect.NewResponse(&drawingv1.GetDrawingStateResponse{Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId(), Name: "Demo"}, Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}, Entities: []*drawingv1.DrawingEntity{entity}}}), nil
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

type mockCad struct{}

func (m *mockCad) ValidateDrawingCommand(context.Context, *connect.Request[drawingv1.ValidateDrawingCommandRequest]) (*connect.Response[drawingv1.ValidateDrawingCommandResponse], error) {
	return connect.NewResponse(&drawingv1.ValidateDrawingCommandResponse{Valid: true}), nil
}
func (m *mockCad) CommitDrawingCommand(_ context.Context, req *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error) {
	return connect.NewResponse(&drawingv1.CommitDrawingCommandResponse{Drawing: &drawingv1.Drawing{DrawingId: req.Msg.GetCommand().GetDrawingId()}, Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}}}), nil
}
func (m *mockCad) RevertDrawingRevision(context.Context, *connect.Request[drawingv1.RevertDrawingRevisionRequest]) (*connect.Response[drawingv1.RevertDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.RevertDrawingRevisionResponse{}), nil
}

var _ drawingv1connect.DrawingRevisionServiceClient = (*mockRevisions)(nil)
var _ drawingv1connect.CadCoreServiceClient = (*mockCad)(nil)

func TestValidateDrawingRoundTrip_JSON(t *testing.T) {
	svc := service.New(&mockRevisions{}, &mockCad{}, zerolog.New(io.Discard), 5*time.Second)
	resp, err := svc.ValidateDrawingRoundTrip(context.Background(), &drawingv1.ValidateDrawingRoundTripRequest{DrawingId: uuid.NewString(), RevisionId: uuid.NewString(), Format: drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetReport().GetMatchedEntityCount() != 1 {
		t.Fatalf("expected 1 matched entity, got %d", resp.GetReport().GetMatchedEntityCount())
	}
}

func TestExportDrawing_DXF(t *testing.T) {
	svc := service.New(&mockRevisions{}, &mockCad{}, zerolog.New(io.Discard), 5*time.Second)
	resp, err := svc.ExportDrawing(context.Background(), &drawingv1.ExportDrawingRequest{DrawingId: uuid.NewString(), RevisionId: uuid.NewString(), Format: drawingv1.FileFormat_FILE_FORMAT_DXF_ASCII})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetContentType() != "application/dxf" || len(resp.GetPayload()) == 0 {
		t.Fatal("expected non-empty DXF payload")
	}
	if !strings.Contains(string(resp.GetPayload()), "SOLAR3D_LINEAGE") {
		t.Fatal("expected DXF payload to include export lineage comments")
	}
}

func TestExportDrawing_RequiresPinnedRevision(t *testing.T) {
	svc := service.New(&mockRevisions{}, &mockCad{}, zerolog.New(io.Discard), 5*time.Second)
	_, err := svc.ExportDrawing(context.Background(), &drawingv1.ExportDrawingRequest{DrawingId: uuid.NewString(), Format: drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON})
	if err == nil || !strings.Contains(err.Error(), "revision_id is required") {
		t.Fatalf("expected pinned revision validation error, got %v", err)
	}
}

func TestValidateDrawingRoundTrip_RequiresPinnedRevision(t *testing.T) {
	svc := service.New(&mockRevisions{}, &mockCad{}, zerolog.New(io.Discard), 5*time.Second)
	_, err := svc.ValidateDrawingRoundTrip(context.Background(), &drawingv1.ValidateDrawingRoundTripRequest{DrawingId: uuid.NewString(), Format: drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON})
	if err == nil || !strings.Contains(err.Error(), "revision_id is required") {
		t.Fatalf("expected pinned revision validation error, got %v", err)
	}
}

