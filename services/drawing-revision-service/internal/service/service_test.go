package service_test

import (
	"context"
	"errors"
	"io"
	"testing"
	"time"

	"solar3d/drawing-revision-service/internal/repository"
	"solar3d/drawing-revision-service/internal/service"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "github.com/solar3d/solar3d/gen/common/v1"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// ─── mock repository ────────────────────────────────────────────────────────

type mockRepo struct {
	createDrawingFn        func(context.Context, *drawingv1.Drawing, string) (*drawingv1.DrawingRevision, error)
	getDrawingFn           func(context.Context, string) (*drawingv1.Drawing, error)
	listDrawingsFn         func(context.Context, string, int, int, bool) ([]*drawingv1.Drawing, int, error)
	updateDrawingFn        func(context.Context, *drawingv1.Drawing) error
	getDrawingStateFn      func(context.Context, string, string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error)
	listDrawingRevisionsFn func(context.Context, string, int, int) ([]*drawingv1.RevisionPointer, int, error)
	storeDrawingRevisionFn func(context.Context, repository.StoreRevisionInput) (*drawingv1.Drawing, *drawingv1.DrawingRevision, repository.StoreRevisionOutcome, error)
	recordConflictEventFn  func(context.Context, repository.ConflictEventInput) error
}

var _ repository.Repository = (*mockRepo)(nil)

func (m *mockRepo) CreateDrawing(ctx context.Context, d *drawingv1.Drawing, author string) (*drawingv1.DrawingRevision, error) {
	if m.createDrawingFn != nil {
		return m.createDrawingFn(ctx, d, author)
	}
	return &drawingv1.DrawingRevision{
		Pointer:   &drawingv1.RevisionPointer{RevisionId: uuid.NewString()},
		DrawingId: d.GetDrawingId(),
	}, nil
}

func (m *mockRepo) GetDrawing(ctx context.Context, id string) (*drawingv1.Drawing, error) {
	if m.getDrawingFn != nil {
		return m.getDrawingFn(ctx, id)
	}
	return &drawingv1.Drawing{
		DrawingId:         id,
		Status:            drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE,
		CurrentRevisionId: uuid.NewString(),
		CreatedAt:         timestamppb.New(time.Now()),
		UpdatedAt:         timestamppb.New(time.Now()),
	}, nil
}

func (m *mockRepo) ListDrawings(ctx context.Context, projectID string, limit, offset int, includeArchived bool) ([]*drawingv1.Drawing, int, error) {
	if m.listDrawingsFn != nil {
		return m.listDrawingsFn(ctx, projectID, limit, offset, includeArchived)
	}
	return []*drawingv1.Drawing{}, 0, nil
}

func (m *mockRepo) UpdateDrawing(ctx context.Context, d *drawingv1.Drawing) error {
	if m.updateDrawingFn != nil {
		return m.updateDrawingFn(ctx, d)
	}
	return nil
}

func (m *mockRepo) GetDrawingState(ctx context.Context, drawingID, revisionID string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error) {
	if m.getDrawingStateFn != nil {
		return m.getDrawingStateFn(ctx, drawingID, revisionID)
	}
	return &drawingv1.Drawing{DrawingId: drawingID}, &drawingv1.DrawingRevision{
		Pointer:   &drawingv1.RevisionPointer{RevisionId: uuid.NewString()},
		DrawingId: drawingID,
	}, nil
}

func (m *mockRepo) ListDrawingRevisions(ctx context.Context, drawingID string, limit, offset int) ([]*drawingv1.RevisionPointer, int, error) {
	if m.listDrawingRevisionsFn != nil {
		return m.listDrawingRevisionsFn(ctx, drawingID, limit, offset)
	}
	return []*drawingv1.RevisionPointer{}, 0, nil
}

func (m *mockRepo) StoreDrawingRevision(ctx context.Context, input repository.StoreRevisionInput) (*drawingv1.Drawing, *drawingv1.DrawingRevision, repository.StoreRevisionOutcome, error) {
	if m.storeDrawingRevisionFn != nil {
		return m.storeDrawingRevisionFn(ctx, input)
	}
	revisionID := uuid.NewString()
	return &drawingv1.Drawing{DrawingId: input.DrawingID, CurrentRevisionId: revisionID},
		&drawingv1.DrawingRevision{
			Pointer:   &drawingv1.RevisionPointer{RevisionId: revisionID},
			DrawingId: input.DrawingID,
		}, repository.StoreRevisionOutcome{Code: repository.OutcomeCommitted, HeadVersion: 2}, nil
}

func (m *mockRepo) RecordConflictEvent(ctx context.Context, input repository.ConflictEventInput) error {
	if m.recordConflictEventFn != nil {
		return m.recordConflictEventFn(ctx, input)
	}
	return nil
}

// ─── helpers ─────────────────────────────────────────────────────────────────

func newTestService(repo repository.Repository) *service.Service {
	return service.New(repo, zerolog.New(io.Discard))
}

func validProjectID() string { return uuid.NewString() }
func validDrawingID() string { return uuid.NewString() }

// ─── CreateDrawing ────────────────────────────────────────────────────────────

func TestCreateDrawing_Success(t *testing.T) {
	projectID := validProjectID()
	revisionID := uuid.NewString()

	repo := &mockRepo{
		createDrawingFn: func(_ context.Context, d *drawingv1.Drawing, author string) (*drawingv1.DrawingRevision, error) {
			if d.GetProjectId() != projectID {
				t.Errorf("unexpected project_id: got %s", d.GetProjectId())
			}
			return &drawingv1.DrawingRevision{
				Pointer:   &drawingv1.RevisionPointer{RevisionId: revisionID},
				DrawingId: d.GetDrawingId(),
			}, nil
		},
	}
	svc := newTestService(repo)

	resp, err := svc.CreateDrawing(context.Background(), &drawingv1.CreateDrawingRequest{
		ProjectId: projectID,
		Name:      "Main Layout",
		Author:    "engineer@example.com",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetDrawing() == nil {
		t.Fatal("expected drawing in response")
	}
	if resp.GetDrawing().GetCurrentRevisionId() != revisionID {
		t.Errorf("current_revision_id: want %s, got %s", revisionID, resp.GetDrawing().GetCurrentRevisionId())
	}
	if resp.GetRevision() == nil {
		t.Fatal("expected revision in response")
	}
	if resp.GetDrawing().GetStatus() != drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE {
		t.Errorf("expected ACTIVE status")
	}
}

func TestCreateDrawing_InvalidProjectID(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.CreateDrawing(context.Background(), &drawingv1.CreateDrawingRequest{
		ProjectId: "not-a-uuid",
		Name:      "Layout",
		Author:    "user@example.com",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestCreateDrawing_EmptyAuthor(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.CreateDrawing(context.Background(), &drawingv1.CreateDrawingRequest{
		ProjectId: validProjectID(),
		Name:      "Layout",
		Author:    "",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestCreateDrawing_EmptyName(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.CreateDrawing(context.Background(), &drawingv1.CreateDrawingRequest{
		ProjectId: validProjectID(),
		Name:      "   ",
		Author:    "user@example.com",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestCreateDrawing_InvalidMetadataJSON(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.CreateDrawing(context.Background(), &drawingv1.CreateDrawingRequest{
		ProjectId:    validProjectID(),
		Name:         "Layout",
		Author:       "user@example.com",
		MetadataJson: `{bad json`,
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestCreateDrawing_RepositoryError(t *testing.T) {
	want := errors.New("db unavailable")
	repo := &mockRepo{
		createDrawingFn: func(_ context.Context, _ *drawingv1.Drawing, _ string) (*drawingv1.DrawingRevision, error) {
			return nil, want
		},
	}
	svc := newTestService(repo)
	_, err := svc.CreateDrawing(context.Background(), &drawingv1.CreateDrawingRequest{
		ProjectId: validProjectID(), Name: "Layout", Author: "user@example.com",
	})
	if !errors.Is(err, want) {
		t.Errorf("want underlying repo error, got %v", err)
	}
}

// ─── GetDrawing ───────────────────────────────────────────────────────────────

func TestGetDrawing_Success(t *testing.T) {
	drawingID := validDrawingID()
	svc := newTestService(&mockRepo{
		getDrawingFn: func(_ context.Context, id string) (*drawingv1.Drawing, error) {
			return &drawingv1.Drawing{DrawingId: id, Name: "Layout"}, nil
		},
	})
	drawing, err := svc.GetDrawing(context.Background(), drawingID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if drawing.GetDrawingId() != drawingID {
		t.Errorf("got wrong drawing_id: %s", drawing.GetDrawingId())
	}
}

func TestGetDrawing_NotFound(t *testing.T) {
	svc := newTestService(&mockRepo{
		getDrawingFn: func(_ context.Context, _ string) (*drawingv1.Drawing, error) {
			return nil, repository.ErrNotFound
		},
	})
	_, err := svc.GetDrawing(context.Background(), validDrawingID())
	if !errors.Is(err, service.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

func TestGetDrawing_InvalidID(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.GetDrawing(context.Background(), "not-uuid")
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

// ─── ListDrawings ─────────────────────────────────────────────────────────────

func TestListDrawings_Success(t *testing.T) {
	projectID := validProjectID()
	svc := newTestService(&mockRepo{
		listDrawingsFn: func(_ context.Context, pid string, limit, offset int, _ bool) ([]*drawingv1.Drawing, int, error) {
			if pid != projectID {
				t.Errorf("wrong project_id")
			}
			return []*drawingv1.Drawing{
				{DrawingId: uuid.NewString()},
				{DrawingId: uuid.NewString()},
			}, 5, nil
		},
	})
	resp, err := svc.ListDrawings(context.Background(), &drawingv1.ListDrawingsRequest{
		ProjectId: projectID, PageSize: 2,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.GetDrawings()) != 2 {
		t.Errorf("want 2 drawings, got %d", len(resp.GetDrawings()))
	}
	if resp.GetTotalCount() != 5 {
		t.Errorf("want total_count=5, got %d", resp.GetTotalCount())
	}
	if resp.GetNextPageToken() != "2" {
		t.Errorf("want next_page_token=2, got %q", resp.GetNextPageToken())
	}
}

func TestListDrawings_InvalidProjectID(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.ListDrawings(context.Background(), &drawingv1.ListDrawingsRequest{ProjectId: "bad"})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestListDrawings_LastPage_NoNextToken(t *testing.T) {
	projectID := validProjectID()
	svc := newTestService(&mockRepo{
		listDrawingsFn: func(_ context.Context, _ string, _, _ int, _ bool) ([]*drawingv1.Drawing, int, error) {
			return []*drawingv1.Drawing{{DrawingId: uuid.NewString()}}, 1, nil
		},
	})
	resp, err := svc.ListDrawings(context.Background(), &drawingv1.ListDrawingsRequest{
		ProjectId: projectID, PageSize: 10,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetNextPageToken() != "" {
		t.Errorf("expected empty next_page_token, got %q", resp.GetNextPageToken())
	}
}

// ─── UpdateDrawing ────────────────────────────────────────────────────────────

func TestUpdateDrawing_Success(t *testing.T) {
	drawingID := validDrawingID()
	svc := newTestService(&mockRepo{
		getDrawingFn: func(_ context.Context, id string) (*drawingv1.Drawing, error) {
			return &drawingv1.Drawing{DrawingId: id, Name: "Old Name"}, nil
		},
		updateDrawingFn: func(_ context.Context, d *drawingv1.Drawing) error {
			if d.GetName() != "New Name" {
				t.Errorf("name not updated: got %s", d.GetName())
			}
			return nil
		},
	})
	resp, err := svc.UpdateDrawing(context.Background(), &drawingv1.UpdateDrawingRequest{
		DrawingId: drawingID,
		Name:      "New Name",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetDrawing().GetName() != "New Name" {
		t.Errorf("want name=New Name, got %s", resp.GetDrawing().GetName())
	}
}

func TestUpdateDrawing_NotFound(t *testing.T) {
	svc := newTestService(&mockRepo{
		getDrawingFn: func(_ context.Context, _ string) (*drawingv1.Drawing, error) {
			return nil, repository.ErrNotFound
		},
	})
	_, err := svc.UpdateDrawing(context.Background(), &drawingv1.UpdateDrawingRequest{
		DrawingId: validDrawingID(), Name: "X",
	})
	if !errors.Is(err, service.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

func TestUpdateDrawing_InvalidID(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.UpdateDrawing(context.Background(), &drawingv1.UpdateDrawingRequest{
		DrawingId: "bad-id", Name: "X",
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestUpdateDrawing_InvalidMetadataJSON(t *testing.T) {
	drawingID := validDrawingID()
	svc := newTestService(&mockRepo{
		getDrawingFn: func(_ context.Context, id string) (*drawingv1.Drawing, error) {
			return &drawingv1.Drawing{DrawingId: id}, nil
		},
	})
	_, err := svc.UpdateDrawing(context.Background(), &drawingv1.UpdateDrawingRequest{
		DrawingId:    drawingID,
		MetadataJson: `{"bad": }`,
	})
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

// ─── StoreDrawingRevision ─────────────────────────────────────────────────────

func validEntity(drawingID, entityID string) *drawingv1.DrawingEntity {
	return &drawingv1.DrawingEntity{
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

func TestStoreDrawingRevision_Success(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	stored := false

	svc := newTestService(&mockRepo{
		storeDrawingRevisionFn: func(_ context.Context, input repository.StoreRevisionInput) (*drawingv1.Drawing, *drawingv1.DrawingRevision, repository.StoreRevisionOutcome, error) {
			stored = true
			if input.Author != "engineer@example.com" {
				t.Errorf("want author=engineer@example.com, got %s", input.Author)
			}
			if len(input.Entities) != 1 {
				t.Errorf("want 1 entity, got %d", len(input.Entities))
			}
			if input.BaseRevisionID != "base-rev" {
				t.Errorf("want base revision propagated, got %s", input.BaseRevisionID)
			}
			if input.RequestedHeadVersion != 7 {
				t.Errorf("want requested head version 7, got %d", input.RequestedHeadVersion)
			}
			return &drawingv1.Drawing{DrawingId: drawingID}, &drawingv1.DrawingRevision{
				Pointer: &drawingv1.RevisionPointer{RevisionId: uuid.NewString()},
			}, repository.StoreRevisionOutcome{Code: repository.OutcomeIdempotentDuplicate, AttemptID: "attempt-1", HeadVersion: 7}, nil
		},
	})
	_, metadata, err := svc.StoreDrawingRevision(context.Background(), &drawingv1.StoreDrawingRevisionRequest{
		DrawingId: drawingID,
		Author:    "engineer@example.com",
		Summary:   "Added panel layout",
		Entities:  []*drawingv1.DrawingEntity{validEntity(drawingID, entityID)},
	}, "base-rev", 7)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !stored {
		t.Error("StoreDrawingRevision was not called on repo")
	}
	if metadata.OutcomeCode != repository.OutcomeIdempotentDuplicate {
		t.Errorf("want idempotent outcome metadata, got %s", metadata.OutcomeCode)
	}
}

func TestStoreDrawingRevision_EmptyAuthor(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, _, err := svc.StoreDrawingRevision(context.Background(), &drawingv1.StoreDrawingRevisionRequest{
		DrawingId: validDrawingID(), Summary: "s", Author: "",
	}, "", 0)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestStoreDrawingRevision_EmptySummary(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, _, err := svc.StoreDrawingRevision(context.Background(), &drawingv1.StoreDrawingRevisionRequest{
		DrawingId: validDrawingID(), Author: "user", Summary: "  ",
	}, "", 0)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestStoreDrawingRevision_InvalidDrawingID(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, _, err := svc.StoreDrawingRevision(context.Background(), &drawingv1.StoreDrawingRevisionRequest{
		DrawingId: "bad", Author: "user", Summary: "s",
	}, "", 0)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

func TestStoreDrawingRevision_DuplicateEntityID(t *testing.T) {
	drawingID := validDrawingID()
	entityID := uuid.NewString()
	svc := newTestService(&mockRepo{})
	_, _, err := svc.StoreDrawingRevision(context.Background(), &drawingv1.StoreDrawingRevisionRequest{
		DrawingId: drawingID,
		Author:    "user",
		Summary:   "s",
		Entities: []*drawingv1.DrawingEntity{
			validEntity(drawingID, entityID),
			validEntity(drawingID, entityID), // duplicate
		},
	}, "", 0)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput on duplicate entity_id, got %v", err)
	}
}

func TestStoreDrawingRevision_EntityDrawingIDMismatch(t *testing.T) {
	drawingID := validDrawingID()
	entity := &drawingv1.DrawingEntity{
		Header: &drawingv1.EntityHeader{
			EntityId:   uuid.NewString(),
			DrawingId:  uuid.NewString(), // different drawing
			EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
		},
	}
	svc := newTestService(&mockRepo{})
	_, _, err := svc.StoreDrawingRevision(context.Background(), &drawingv1.StoreDrawingRevisionRequest{
		DrawingId: drawingID, Author: "user", Summary: "s",
		Entities: []*drawingv1.DrawingEntity{entity},
	}, "", 0)
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput on drawing_id mismatch, got %v", err)
	}
}

// ─── GetDrawingState ──────────────────────────────────────────────────────────

func TestGetDrawingState_Success(t *testing.T) {
	drawingID := validDrawingID()
	revisionID := validDrawingID()
	svc := newTestService(&mockRepo{
		getDrawingStateFn: func(_ context.Context, did, rid string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error) {
			return &drawingv1.Drawing{DrawingId: did},
				&drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: rid}}, nil
		},
	})
	resp, err := svc.GetDrawingState(context.Background(), drawingID, revisionID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetRevision().GetPointer().GetRevisionId() != revisionID {
		t.Errorf("wrong revision_id in response")
	}
}

func TestGetDrawingState_HeadRevision(t *testing.T) {
	drawingID := validDrawingID()
	svc := newTestService(&mockRepo{
		getDrawingStateFn: func(_ context.Context, _, revisionID string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error) {
			// empty revisionID means current head
			return &drawingv1.Drawing{DrawingId: drawingID},
				&drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: "head"}}, nil
		},
	})
	resp, err := svc.GetDrawingState(context.Background(), drawingID, "")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetDrawing().GetDrawingId() != drawingID {
		t.Errorf("wrong drawing_id in response")
	}
}

func TestGetDrawingState_InvalidDrawingID(t *testing.T) {
	svc := newTestService(&mockRepo{})
	_, err := svc.GetDrawingState(context.Background(), "not-uuid", "")
	if !errors.Is(err, service.ErrInvalidInput) {
		t.Errorf("want ErrInvalidInput, got %v", err)
	}
}

// ─── ListDrawingRevisions ─────────────────────────────────────────────────────

func TestListDrawingRevisions_Success(t *testing.T) {
	drawingID := validDrawingID()
	svc := newTestService(&mockRepo{
		listDrawingRevisionsFn: func(_ context.Context, _ string, limit, offset int) ([]*drawingv1.RevisionPointer, int, error) {
			return []*drawingv1.RevisionPointer{
				{RevisionId: uuid.NewString(), Author: "a"},
				{RevisionId: uuid.NewString(), Author: "b"},
			}, 10, nil
		},
	})
	resp, err := svc.ListDrawingRevisions(context.Background(), &drawingv1.ListDrawingRevisionsRequest{
		DrawingId: drawingID, PageSize: 2,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.GetRevisions()) != 2 {
		t.Errorf("want 2 revisions, got %d", len(resp.GetRevisions()))
	}
	if resp.GetTotalCount() != 10 {
		t.Errorf("want total_count=10, got %d", resp.GetTotalCount())
	}
}

// ─── GetDrawingRevision ───────────────────────────────────────────────────────

func TestGetDrawingRevision_Success(t *testing.T) {
	drawingID := validDrawingID()
	revisionID := validDrawingID()
	svc := newTestService(&mockRepo{
		getDrawingStateFn: func(_ context.Context, did, rid string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error) {
			return &drawingv1.Drawing{DrawingId: did},
				&drawingv1.DrawingRevision{Pointer: &drawingv1.RevisionPointer{RevisionId: rid}}, nil
		},
	})
	resp, err := svc.GetDrawingRevision(context.Background(), drawingID, revisionID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if resp.GetRevision().GetPointer().GetRevisionId() != revisionID {
		t.Errorf("wrong revision_id in GetDrawingRevision response")
	}
}

