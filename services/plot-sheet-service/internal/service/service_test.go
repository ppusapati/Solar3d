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

	"p9e.in/samavaya/solar3d/plot-sheet-service/internal/service"
)

type mockRevisions struct{}

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
	drawingID := req.Msg.GetDrawingId()
	sheet := &drawingv1.DrawingEntity{Header: &drawingv1.EntityHeader{EntityId: "sheet:a1", DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_SHEET}, Geometry: &drawingv1.DrawingEntity_Sheet{Sheet: &drawingv1.SheetEntity{SheetId: "a1", Title: "General Plan", PageWidthMm: 297, PageHeightMm: 210}}}
	polyline := &drawingv1.DrawingEntity{Header: &drawingv1.EntityHeader{EntityId: uuid.NewString(), DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE, Layer: &drawingv1.LayerRef{LayerId: "site"}}, Geometry: &drawingv1.DrawingEntity_Polyline{Polyline: &drawingv1.PolylineEntity{Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 100, Y: 0}, {X: 100, Y: 50}, {X: 0, Y: 50}}, Closed: true}}}
	layer := &drawingv1.DrawingEntity{Header: &drawingv1.EntityHeader{EntityId: "layer:site", DrawingId: drawingID, EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_LAYER_DEFINITION}, Geometry: &drawingv1.DrawingEntity_LayerDefinition{LayerDefinition: &drawingv1.LayerDefinitionEntity{LayerId: "site", Name: "Site", ColorHex: "#0055AA", Visible: true, Plottable: true}}}
	return connect.NewResponse(&drawingv1.GetDrawingStateResponse{Drawing: &drawingv1.Drawing{DrawingId: drawingID}, Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}, Entities: []*drawingv1.DrawingEntity{sheet, polyline, layer}}}), nil
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

func TestPublishDrawing_SVG(t *testing.T) {
	svc := service.New(&mockRevisions{}, &mockCad{}, zerolog.New(io.Discard), 5*time.Second)
	resp, err := svc.PublishDrawing(context.Background(), &drawingv1.PublishDrawingRequest{DrawingId: uuid.NewString(), Format: drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_SVG})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.GetArtifacts()) != 1 || resp.GetArtifacts()[0].GetContentType() != "image/svg+xml" {
		t.Fatal("expected single SVG publish artifact")
	}
}

