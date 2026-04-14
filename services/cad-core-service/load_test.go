package service_test

import (
	"context"
	"io"
	"testing"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "github.com/solar3d/solar3d/gen/common/v1"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/cad-core-service/internal/service"
)

// ─── minimal mock DrawingRevisionServiceClient for benchmarks ─────────────────

type benchRevisions struct {
	currentRevID string
	entities     []*drawingv1.DrawingEntity
}

var _ drawingv1connect.DrawingRevisionServiceClient = (*benchRevisions)(nil)

func (b *benchRevisions) CreateDrawing(_ context.Context, req *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.CreateDrawingResponse{}), nil
}
func (b *benchRevisions) GetDrawing(_ context.Context, req *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.GetDrawingResponse{
		Drawing: &drawingv1.Drawing{
			DrawingId:         req.Msg.GetDrawingId(),
			CurrentRevisionId: b.currentRevID,
		},
	}), nil
}
func (b *benchRevisions) ListDrawings(_ context.Context, _ *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
	return connect.NewResponse(&drawingv1.ListDrawingsResponse{}), nil
}
func (b *benchRevisions) UpdateDrawing(_ context.Context, _ *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
	return connect.NewResponse(&drawingv1.UpdateDrawingResponse{}), nil
}
func (b *benchRevisions) GetDrawingState(_ context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
	return connect.NewResponse(&drawingv1.GetDrawingStateResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId()},
		Revision: &drawingv1.DrawingRevision{Entities: b.entities},
	}), nil
}
func (b *benchRevisions) ListDrawingRevisions(_ context.Context, _ *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error) {
	return connect.NewResponse(&drawingv1.ListDrawingRevisionsResponse{}), nil
}
func (b *benchRevisions) GetDrawingRevision(_ context.Context, _ *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.GetDrawingRevisionResponse{}), nil
}
func (b *benchRevisions) StoreDrawingRevision(_ context.Context, req *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
	return connect.NewResponse(&drawingv1.StoreDrawingRevisionResponse{
		Drawing:  &drawingv1.Drawing{DrawingId: req.Msg.GetDrawingId(), CurrentRevisionId: uuid.NewString()},
		Revision: &drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}},
	}), nil
}

// ─── helpers ──────────────────────────────────────────────────────────────────

func newBenchRevisions(entityCount int, drawingID string) *benchRevisions {
	entities := make([]*drawingv1.DrawingEntity, entityCount)
	for i := range entities {
		eid := uuid.NewString()
		entities[i] = &drawingv1.DrawingEntity{
			Header: &drawingv1.EntityHeader{
				EntityId:   eid,
				DrawingId:  drawingID,
				EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
			},
			Geometry: &drawingv1.DrawingEntity_Polyline{
				Polyline: &drawingv1.PolylineEntity{
					Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 1, Y: 1}},
				},
			},
		}
	}
	return &benchRevisions{
		currentRevID: uuid.NewString(),
		entities:     entities,
	}
}

func newBenchService(revisions drawingv1connect.DrawingRevisionServiceClient) *service.Service {
	return service.New(revisions, zerolog.New(io.Discard), 30*time.Second)
}

func createBenchCommand(drawingID string) *drawingv1.DrawingCommand {
	entityID := uuid.NewString()
	return &drawingv1.DrawingCommand{
		CommandId: uuid.NewString(),
		DrawingId: drawingID,
		Actor:     "bench@example.com",
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
}

// ─── benchmarks ───────────────────────────────────────────────────────────────

// BenchmarkValidateCommand_EmptyDrawing measures validation throughput on an empty drawing.
func BenchmarkValidateCommand_EmptyDrawing(b *testing.B) {
	drawingID := uuid.NewString()
	svc := newBenchService(newBenchRevisions(0, drawingID))
	ctx := context.Background()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := svc.ValidateDrawingCommand(ctx, &drawingv1.ValidateDrawingCommandRequest{
			Command: createBenchCommand(drawingID),
		})
		if err != nil {
			b.Fatalf("ValidateDrawingCommand: %v", err)
		}
	}
}

// BenchmarkValidateCommand_100Entities measures validation throughput with 100 existing entities.
func BenchmarkValidateCommand_100Entities(b *testing.B) {
	drawingID := uuid.NewString()
	svc := newBenchService(newBenchRevisions(100, drawingID))
	ctx := context.Background()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := svc.ValidateDrawingCommand(ctx, &drawingv1.ValidateDrawingCommandRequest{
			Command: createBenchCommand(drawingID),
		})
		if err != nil {
			b.Fatalf("ValidateDrawingCommand: %v", err)
		}
	}
}

// BenchmarkValidateCommand_Parallel measures concurrent validation throughput.
func BenchmarkValidateCommand_Parallel(b *testing.B) {
	drawingID := uuid.NewString()
	svc := newBenchService(newBenchRevisions(10, drawingID))
	ctx := context.Background()

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, err := svc.ValidateDrawingCommand(ctx, &drawingv1.ValidateDrawingCommandRequest{
				Command: createBenchCommand(drawingID),
			})
			if err != nil {
				b.Fatalf("ValidateDrawingCommand: %v", err)
			}
		}
	})
}

// BenchmarkCommitCommand_Serial measures commit latency including revision service round-trip.
func BenchmarkCommitCommand_Serial(b *testing.B) {
	drawingID := uuid.NewString()
	svc := newBenchService(newBenchRevisions(10, drawingID))
	ctx := context.Background()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _, err := svc.CommitDrawingCommand(ctx, &drawingv1.CommitDrawingCommandRequest{
			Command: createBenchCommand(drawingID),
		})
		if err != nil {
			b.Fatalf("CommitDrawingCommand: %v", err)
		}
	}
}

// BenchmarkCommitCommand_Parallel measures concurrent commit throughput.
func BenchmarkCommitCommand_Parallel(b *testing.B) {
	drawingID := uuid.NewString()
	svc := newBenchService(newBenchRevisions(10, drawingID))
	ctx := context.Background()

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, _, err := svc.CommitDrawingCommand(ctx, &drawingv1.CommitDrawingCommandRequest{
				Command: createBenchCommand(drawingID),
			})
			if err != nil {
				b.Fatalf("CommitDrawingCommand: %v", err)
			}
		}
	})
}

// BenchmarkRevertDrawingRevision_Serial measures revert latency.
func BenchmarkRevertDrawingRevision_Serial(b *testing.B) {
	drawingID := uuid.NewString()
	svc := newBenchService(newBenchRevisions(10, drawingID))
	ctx := context.Background()
	targetRevID := uuid.NewString()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := svc.RevertDrawingRevision(ctx, &drawingv1.RevertDrawingRevisionRequest{
			DrawingId:        drawingID,
			TargetRevisionId: targetRevID,
			Author:           "bench@example.com",
		})
		if err != nil {
			b.Fatalf("RevertDrawingRevision: %v", err)
		}
	}
}

