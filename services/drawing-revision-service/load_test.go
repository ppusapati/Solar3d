package service_test

import (
	"context"
	"io"
	"testing"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"

	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/repository"
	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/service"
)

// ─── minimal in-process mock repo for benchmarks ─────────────────────────────

type benchRepo struct{}

func (b *benchRepo) CreateDrawing(_ context.Context, drawing *drawingv1.Drawing, _ string) (*drawingv1.DrawingRevision, error) {
	revID := uuid.NewString()
	drawing.DrawingId = uuid.NewString()
	drawing.CurrentRevisionId = revID
	return &drawingv1.DrawingRevision{
		Pointer: &drawingv1.RevisionPointer{RevisionId: revID},
	}, nil
}
func (b *benchRepo) GetDrawing(_ context.Context, drawingID string) (*drawingv1.Drawing, error) {
	return &drawingv1.Drawing{DrawingId: drawingID}, nil
}
func (b *benchRepo) ListDrawings(_ context.Context, _ string, limit, _ int, _ bool) ([]*drawingv1.Drawing, int, error) {
	result := make([]*drawingv1.Drawing, limit)
	for i := range result {
		result[i] = &drawingv1.Drawing{DrawingId: uuid.NewString()}
	}
	return result, limit * 2, nil
}
func (b *benchRepo) UpdateDrawing(_ context.Context, _ *drawingv1.Drawing) error { return nil }
func (b *benchRepo) GetDrawingState(_ context.Context, drawingID, _ string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error) {
	return &drawingv1.Drawing{DrawingId: drawingID},
		&drawingv1.DrawingRevision{
			Pointer:  &drawingv1.RevisionPointer{RevisionId: uuid.NewString()},
			Entities: benchEntities(drawingID, 10),
		}, nil
}
func (b *benchRepo) ListDrawingRevisions(_ context.Context, _ string, limit, _ int) ([]*drawingv1.RevisionPointer, int, error) {
	result := make([]*drawingv1.RevisionPointer, limit)
	for i := range result {
		result[i] = &drawingv1.RevisionPointer{RevisionId: uuid.NewString()}
	}
	return result, limit * 2, nil
}
func (b *benchRepo) StoreDrawingRevision(_ context.Context, input repository.StoreRevisionInput) (*drawingv1.Drawing, *drawingv1.DrawingRevision, repository.StoreRevisionOutcome, error) {
	revID := uuid.NewString()
	return &drawingv1.Drawing{DrawingId: input.DrawingID, CurrentRevisionId: revID},
		&drawingv1.DrawingRevision{
			Pointer:  &drawingv1.RevisionPointer{RevisionId: revID},
			Entities: input.Entities,
		}, repository.StoreRevisionOutcome{Code: repository.OutcomeCommitted, HeadVersion: 1, HeadRevisionID: revID}, nil
}

func (b *benchRepo) RecordConflictEvent(_ context.Context, _ repository.ConflictEventInput) error {
	return nil
}

func benchEntities(drawingID string, count int) []*drawingv1.DrawingEntity {
	entities := make([]*drawingv1.DrawingEntity, count)
	for i := range entities {
		entityID := uuid.NewString()
		entities[i] = &drawingv1.DrawingEntity{
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
	}
	return entities
}

func newBenchService() *service.Service {
	return service.New(&benchRepo{}, zerolog.New(io.Discard))
}

// ─── benchmarks ───────────────────────────────────────────────────────────────

// BenchmarkCreateDrawing measures the overhead of drawing creation validation + repo round-trip.
func BenchmarkCreateDrawing(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	projectID := uuid.NewString()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := svc.CreateDrawing(ctx, &drawingv1.CreateDrawingRequest{
			ProjectId: projectID,
			Name:      "Bench Drawing",
			Author:    "bench@example.com",
		})
		if err != nil {
			b.Fatalf("CreateDrawing: %v", err)
		}
	}
}

// BenchmarkCreateDrawing_Parallel measures concurrent drawing creation throughput.
func BenchmarkCreateDrawing_Parallel(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	projectID := uuid.NewString()

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, err := svc.CreateDrawing(ctx, &drawingv1.CreateDrawingRequest{
				ProjectId: projectID,
				Name:      "Bench Drawing",
				Author:    "bench@example.com",
			})
			if err != nil {
				b.Fatalf("CreateDrawing: %v", err)
			}
		}
	})
}

// BenchmarkStoreRevision_Serial measures revision store latency with 10 entities per revision.
func BenchmarkStoreRevision_Serial(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	drawingID := uuid.NewString()
	entities := benchEntities(drawingID, 10)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _, err := svc.StoreDrawingRevision(ctx, &drawingv1.StoreDrawingRevisionRequest{
			DrawingId: drawingID,
			Author:    "bench@example.com",
			Summary:   "bench revision",
			CommandId: uuid.NewString(),
			Entities:  entities,
		}, "", 0)
		if err != nil {
			b.Fatalf("StoreDrawingRevision: %v", err)
		}
	}
}

// BenchmarkStoreRevision_Parallel measures concurrent revision store throughput with 10 entities.
func BenchmarkStoreRevision_Parallel(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	drawingID := uuid.NewString()
	entities := benchEntities(drawingID, 10)

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, _, err := svc.StoreDrawingRevision(ctx, &drawingv1.StoreDrawingRevisionRequest{
				DrawingId: drawingID,
				Author:    "bench@example.com",
				Summary:   "bench",
				CommandId: uuid.NewString(),
				Entities:  entities,
			}, "", 0)
			if err != nil {
				b.Fatalf("StoreDrawingRevision: %v", err)
			}
		}
	})
}

// BenchmarkStoreRevision_100Entities measures revision store latency with 100 entities.
func BenchmarkStoreRevision_100Entities(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	drawingID := uuid.NewString()
	entities := benchEntities(drawingID, 100)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _, err := svc.StoreDrawingRevision(ctx, &drawingv1.StoreDrawingRevisionRequest{
			DrawingId: drawingID,
			Author:    "bench@example.com",
			Summary:   "bench",
			CommandId: uuid.NewString(),
			Entities:  entities,
		}, "", 0)
		if err != nil {
			b.Fatalf("StoreDrawingRevision: %v", err)
		}
	}
}

// BenchmarkGetDrawingState_Parallel measures concurrent read throughput.
func BenchmarkGetDrawingState_Parallel(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	drawingID := uuid.NewString()
	revisionID := uuid.NewString()

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, err := svc.GetDrawingState(ctx, drawingID, revisionID)
			if err != nil {
				b.Fatalf("GetDrawingState: %v", err)
			}
		}
	})
}

// BenchmarkListDrawings_Parallel measures concurrent list throughput.
func BenchmarkListDrawings_Parallel(b *testing.B) {
	svc := newBenchService()
	ctx := context.Background()
	projectID := uuid.NewString()

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, err := svc.ListDrawings(ctx, &drawingv1.ListDrawingsRequest{
				ProjectId: projectID,
				PageSize:  20,
			})
			if err != nil {
				b.Fatalf("ListDrawings: %v", err)
			}
		}
	})
}

