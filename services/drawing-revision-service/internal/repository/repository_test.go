//go:build db
// +build db

// Run with: TEST_DATABASE_URL=postgres://... go test -tags=db ./internal/repository/...
package repository_test

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"os"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/types/known/timestamppb"

	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/repository"
)

// ─── helpers ─────────────────────────────────────────────────────────────────

func openPool(tb testing.TB) *pgxpool.Pool {
	tb.Helper()
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		tb.Skip("TEST_DATABASE_URL not set — skipping database tests")
	}
	return openPoolWithDSN(tb, dsn)
}

func openPoolWithDSN(tb testing.TB, dsn string) *pgxpool.Pool {
	tb.Helper()
	pool, err := pgxpool.New(context.Background(), dsn)
	if err != nil {
		tb.Fatalf("pgxpool.New: %v", err)
	}
	if err := pool.Ping(context.Background()); err != nil {
		tb.Fatalf("db ping: %v", err)
	}
	tb.Cleanup(pool.Close)
	return pool
}

func dsnWithParam(tb testing.TB, rawDSN, key, value string) string {
	tb.Helper()
	parsed, err := url.Parse(rawDSN)
	if err != nil {
		tb.Fatalf("parse TEST_DATABASE_URL: %v", err)
	}
	query := parsed.Query()
	query.Set(key, value)
	parsed.RawQuery = query.Encode()
	return parsed.String()
}

func newDrawing(projectID string) *drawingv1.Drawing {
	now := time.Now().UTC()
	return &drawingv1.Drawing{
		DrawingId:   uuid.NewString(),
		ProjectId:   projectID,
		Name:        "Test Drawing " + uuid.NewString()[:8],
		Description: "repo unit test",
		Status:      drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE,
		CreatedAt:   timestamppb.New(now),
		UpdatedAt:   timestamppb.New(now),
	}
}

func polylineEntity(drawingID string) *drawingv1.DrawingEntity {
	return &drawingv1.DrawingEntity{
		Header: &drawingv1.EntityHeader{
			EntityId:   uuid.NewString(),
			DrawingId:  drawingID,
			EntityType: drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_POLYLINE,
		},
		Geometry: &drawingv1.DrawingEntity_Polyline{
			Polyline: &drawingv1.PolylineEntity{
				Vertices: []*commonv1.Point2D{{X: 0, Y: 0}, {X: 10, Y: 10}},
			},
		},
	}
}

// ─── tests ────────────────────────────────────────────────────────────────────

// TestRepo_CreateAndGet verifies CreateDrawing writes to the DB and GetDrawing reads it back.
func TestRepo_CreateAndGet(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	rev, err := repo.CreateDrawing(ctx, drawing, "tester@example.com")
	if err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}
	initialRevID := rev.GetPointer().GetRevisionId()
	if initialRevID == "" {
		t.Fatal("expected non-empty initial revision ID")
	}
	if rev.GetDrawingId() != drawing.GetDrawingId() {
		t.Errorf("revision drawing_id: want %s got %s", drawing.GetDrawingId(), rev.GetDrawingId())
	}
	if len(rev.GetEntities()) != 0 {
		t.Errorf("initial entity count: want 0 got %d", len(rev.GetEntities()))
	}

	got, err := repo.GetDrawing(ctx, drawing.GetDrawingId())
	if err != nil {
		t.Fatalf("GetDrawing: %v", err)
	}
	if got.GetName() != drawing.GetName() {
		t.Errorf("name: want %q got %q", drawing.GetName(), got.GetName())
	}
	if got.GetCurrentRevisionId() != initialRevID {
		t.Errorf("current_revision_id: want %q got %q", initialRevID, got.GetCurrentRevisionId())
	}
	if got.GetRevisionCount() != 1 {
		t.Errorf("revision_count: want 1 got %d", got.GetRevisionCount())
	}
}

// TestRepo_GetDrawing_NotFound verifies ErrNotFound is returned for unknown IDs.
func TestRepo_GetDrawing_NotFound(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	_, err := repo.GetDrawing(context.Background(), uuid.NewString())
	if !errors.Is(err, repository.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

// TestRepo_ListDrawings verifies filtering by projectID and archive status.
func TestRepo_ListDrawings(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	projectID := uuid.NewString()

	// Create three drawings in the same project.
	for i := 0; i < 3; i++ {
		d := newDrawing(projectID)
		if _, err := repo.CreateDrawing(ctx, d, "tester@example.com"); err != nil {
			t.Fatalf("CreateDrawing[%d]: %v", i, err)
		}
	}

	drawings, total, err := repo.ListDrawings(ctx, projectID, 10, 0, false)
	if err != nil {
		t.Fatalf("ListDrawings: %v", err)
	}
	if total < 3 {
		t.Errorf("total: want >=3, got %d", total)
	}
	if len(drawings) < 3 {
		t.Errorf("len(drawings): want >=3, got %d", len(drawings))
	}
	// Unrelated project must be isolated.
	_, otherTotal, _ := repo.ListDrawings(ctx, uuid.NewString(), 10, 0, false)
	if otherTotal != 0 {
		t.Errorf("other project total: want 0, got %d", otherTotal)
	}
}

// TestRepo_UpdateDrawing verifies mutable fields are persisted.
func TestRepo_UpdateDrawing(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}

	drawing.Name = "Renamed Drawing"
	drawing.Description = "updated description"
	drawing.UpdatedAt = timestamppb.New(time.Now().UTC())
	if err := repo.UpdateDrawing(ctx, drawing); err != nil {
		t.Fatalf("UpdateDrawing: %v", err)
	}

	got, err := repo.GetDrawing(ctx, drawing.GetDrawingId())
	if err != nil {
		t.Fatalf("GetDrawing after update: %v", err)
	}
	if got.GetName() != "Renamed Drawing" {
		t.Errorf("name after update: want %q got %q", "Renamed Drawing", got.GetName())
	}
	if got.GetDescription() != "updated description" {
		t.Errorf("description after update: want %q got %q", "updated description", got.GetDescription())
	}
}

// TestRepo_UpdateDrawing_NotFound verifies ErrNotFound for an unknown drawing.
func TestRepo_UpdateDrawing_NotFound(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ghost := &drawingv1.Drawing{
		DrawingId: uuid.NewString(),
		Name:      "ghost",
		UpdatedAt: timestamppb.Now(),
	}
	err := repo.UpdateDrawing(context.Background(), ghost)
	if !errors.Is(err, repository.ErrNotFound) {
		t.Errorf("want ErrNotFound, got %v", err)
	}
}

// TestRepo_StoreDrawingRevision verifies a new revision is persisted and the drawing head advances.
func TestRepo_StoreDrawingRevision(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}

	entities := []*drawingv1.DrawingEntity{
		polylineEntity(drawing.GetDrawingId()),
		polylineEntity(drawing.GetDrawingId()),
	}
	cmdID := uuid.NewString()
	updatedDrawing, rev, outcome, err := repo.StoreDrawingRevision(ctx, repository.StoreRevisionInput{
		DrawingID: drawing.GetDrawingId(),
		Author:    "tester@example.com",
		Summary:   "first real revision",
		CommandID: cmdID,
		Entities:  entities,
		At:        time.Now().UTC(),
	})
	if err != nil {
		t.Fatalf("StoreDrawingRevision: %v", err)
	}
	if updatedDrawing.GetRevisionCount() < 2 {
		t.Errorf("revision_count after store: want >=2, got %d", updatedDrawing.GetRevisionCount())
	}
	if updatedDrawing.GetEntityCount() != 2 {
		t.Errorf("entity_count: want 2, got %d", updatedDrawing.GetEntityCount())
	}
	rev2ID := rev.GetPointer().GetRevisionId()
	if rev2ID == "" {
		t.Fatal("expected non-empty revision ID from StoreDrawingRevision")
	}
	if rev.GetCommandId() != cmdID {
		t.Errorf("command_id: want %q got %q", cmdID, rev.GetCommandId())
	}
	if outcome.Code != repository.OutcomeCommitted {
		t.Errorf("outcome code: want %q got %q", repository.OutcomeCommitted, outcome.Code)
	}
}

// TestRepo_StoreDrawingRevision_DuplicateCommandID verifies idempotency: a duplicate command_id returns existing revision.
func TestRepo_StoreDrawingRevision_DuplicateCommandID(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}

	cmdID := uuid.NewString()
	input := repository.StoreRevisionInput{
		DrawingID: drawing.GetDrawingId(),
		Author:    "tester@example.com",
		Summary:   "idempotent revision",
		CommandID: cmdID,
		Entities:  []*drawingv1.DrawingEntity{polylineEntity(drawing.GetDrawingId())},
		At:        time.Now().UTC(),
	}
	firstDrawing, firstRevision, firstOutcome, err := repo.StoreDrawingRevision(ctx, input)
	if err != nil {
		t.Fatalf("first StoreDrawingRevision: %v", err)
	}
	secondDrawing, secondRevision, secondOutcome, err := repo.StoreDrawingRevision(ctx, input)
	if err != nil {
		t.Fatalf("second StoreDrawingRevision: %v", err)
	}
	if firstRevision.GetPointer().GetRevisionId() != secondRevision.GetPointer().GetRevisionId() {
		t.Errorf(
			"duplicate command_id should return same revision: first=%s second=%s",
			firstRevision.GetPointer().GetRevisionId(),
			secondRevision.GetPointer().GetRevisionId(),
		)
	}
	if firstDrawing.GetDrawingId() != secondDrawing.GetDrawingId() {
		t.Errorf("drawing id mismatch: first=%s second=%s", firstDrawing.GetDrawingId(), secondDrawing.GetDrawingId())
	}
	if firstOutcome.Code != repository.OutcomeCommitted {
		t.Errorf("first outcome: want committed got %s", firstOutcome.Code)
	}
	if secondOutcome.Code != repository.OutcomeIdempotentDuplicate {
		t.Errorf("second outcome: want idempotent_duplicate got %s", secondOutcome.Code)
	}
}

// TestRepo_GetDrawingState verifies that the entity snapshot is correctly materialised.
func TestRepo_GetDrawingState(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}
	entities := []*drawingv1.DrawingEntity{polylineEntity(drawing.GetDrawingId())}
	_, rev, _, err := repo.StoreDrawingRevision(ctx, repository.StoreRevisionInput{
		DrawingID: drawing.GetDrawingId(),
		Author:    "tester@example.com",
		Summary:   "state test",
		CommandID: uuid.NewString(),
		Entities:  entities,
		At:        time.Now().UTC(),
	})
	if err != nil {
		t.Fatalf("StoreDrawingRevision: %v", err)
	}
	revID := rev.GetPointer().GetRevisionId()

	// Explicit revision ID.
	_, state, err := repo.GetDrawingState(ctx, drawing.GetDrawingId(), revID)
	if err != nil {
		t.Fatalf("GetDrawingState(explicit): %v", err)
	}
	if len(state.GetEntities()) != 1 {
		t.Errorf("entity count in revision: want 1, got %d", len(state.GetEntities()))
	}

	// Empty revision ID must return the current head.
	_, headState, err := repo.GetDrawingState(ctx, drawing.GetDrawingId(), "")
	if err != nil {
		t.Fatalf("GetDrawingState(head): %v", err)
	}
	if headState.GetPointer().GetRevisionId() != revID {
		t.Errorf("head revision ID: want %q got %q", revID, headState.GetPointer().GetRevisionId())
	}
}

// TestRepo_ListDrawingRevisions verifies revision history ordering and pagination.
func TestRepo_ListDrawingRevisions(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}
	// Add three more revisions.
	for i := 0; i < 3; i++ {
		_, _, _, err := repo.StoreDrawingRevision(ctx, repository.StoreRevisionInput{
			DrawingID: drawing.GetDrawingId(),
			Author:    "tester@example.com",
			Summary:   "revision",
			CommandID: uuid.NewString(),
			Entities:  []*drawingv1.DrawingEntity{polylineEntity(drawing.GetDrawingId())},
			At:        time.Now().UTC(),
		})
		if err != nil {
			t.Fatalf("StoreDrawingRevision[%d]: %v", i, err)
		}
	}

	ptrs, total, err := repo.ListDrawingRevisions(ctx, drawing.GetDrawingId(), 10, 0)
	if err != nil {
		t.Fatalf("ListDrawingRevisions: %v", err)
	}
	if total < 4 { // initial + 3
		t.Errorf("total: want >=4, got %d", total)
	}
	if len(ptrs) < 4 {
		t.Errorf("len(ptrs): want >=4, got %d", len(ptrs))
	}
	// Revisions should be ordered newest-first.
	for i := 1; i < len(ptrs); i++ {
		a := ptrs[i-1].GetCommittedAt().AsTime()
		b := ptrs[i].GetCommittedAt().AsTime()
		if a.Before(b) {
			t.Errorf("revision order: ptrs[%d] (%s) should be newer than ptrs[%d] (%s)", i-1, a, i, b)
		}
	}
	// Pagination: offset=3 should return only 1 (the initial revision).
	paged, _, err := repo.ListDrawingRevisions(ctx, drawing.GetDrawingId(), 10, 3)
	if err != nil {
		t.Fatalf("ListDrawingRevisions(offset=3): %v", err)
	}
	if len(paged) < 1 {
		t.Errorf("paged len: want >=1, got %d", len(paged))
	}
}

func TestRepo_StoreDrawingRevision_TwoUserStaleRace(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}
	head, err := repo.GetDrawing(ctx, drawing.GetDrawingId())
	if err != nil {
		t.Fatalf("GetDrawing: %v", err)
	}

	baseRevisionID := head.GetCurrentRevisionId()
	baseHeadVersion := head.GetRevisionCount()

	type result struct {
		outcome repository.StoreRevisionOutcome
		err     error
	}
	results := make(chan result, 2)
	var start sync.WaitGroup
	start.Add(1)

	for i := 0; i < 2; i++ {
		i := i
		go func() {
			defer func() {
				if recovered := recover(); recovered != nil {
					results <- result{err: fmt.Errorf("panic: %v", recovered)}
				}
			}()
			start.Wait()
			_, _, outcome, err := repo.StoreDrawingRevision(ctx, repository.StoreRevisionInput{
				DrawingID:            drawing.GetDrawingId(),
				Author:               fmt.Sprintf("user-%d@example.com", i+1),
				Summary:              "stale race",
				CommandID:            uuid.NewString(),
				BaseRevisionID:       baseRevisionID,
				RequestedHeadVersion: baseHeadVersion,
				Entities:             []*drawingv1.DrawingEntity{polylineEntity(drawing.GetDrawingId())},
				At:                   time.Now().UTC(),
			})
			results <- result{outcome: outcome, err: err}
		}()
	}
	start.Done()

	committed := 0
	stale := 0
	for i := 0; i < 2; i++ {
		entry := <-results
		if entry.err == nil {
			if entry.outcome.Code != repository.OutcomeCommitted {
				t.Fatalf("expected committed outcome, got %q", entry.outcome.Code)
			}
			committed++
			continue
		}
		var conflictErr *repository.ConflictError
		if !errors.As(entry.err, &conflictErr) {
			t.Fatalf("expected conflict error, got %v", entry.err)
		}
		if conflictErr.OutcomeCode != repository.OutcomeStaleBase {
			t.Fatalf("expected stale_base conflict, got %q", conflictErr.OutcomeCode)
		}
		stale++
	}

	if committed != 1 || stale != 1 {
		t.Fatalf("expected exactly one commit and one stale conflict; got committed=%d stale=%d", committed, stale)
	}
}

func TestRepo_StoreDrawingRevision_NUserContention(t *testing.T) {
	repo := repository.NewPgRepository(openPool(t))
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := repo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}
	head, err := repo.GetDrawing(ctx, drawing.GetDrawingId())
	if err != nil {
		t.Fatalf("GetDrawing: %v", err)
	}

	const workers = 8
	baseRevisionID := head.GetCurrentRevisionId()
	baseHeadVersion := head.GetRevisionCount()

	var committed atomic.Int32
	var stale atomic.Int32
	var other atomic.Int32
	var wg sync.WaitGroup
	var start sync.WaitGroup
	start.Add(1)

	for i := 0; i < workers; i++ {
		i := i
		wg.Add(1)
		go func() {
			defer wg.Done()
			start.Wait()
			_, _, outcome, err := repo.StoreDrawingRevision(ctx, repository.StoreRevisionInput{
				DrawingID:            drawing.GetDrawingId(),
				Author:               fmt.Sprintf("n-user-%d@example.com", i+1),
				Summary:              "n-user contention",
				CommandID:            uuid.NewString(),
				BaseRevisionID:       baseRevisionID,
				RequestedHeadVersion: baseHeadVersion,
				Entities:             []*drawingv1.DrawingEntity{polylineEntity(drawing.GetDrawingId())},
				At:                   time.Now().UTC(),
			})
			if err == nil {
				if outcome.Code == repository.OutcomeCommitted {
					committed.Add(1)
					return
				}
				other.Add(1)
				return
			}
			var conflictErr *repository.ConflictError
			if errors.As(err, &conflictErr) && conflictErr.OutcomeCode == repository.OutcomeStaleBase {
				stale.Add(1)
				return
			}
			other.Add(1)
		}()
	}
	start.Done()
	wg.Wait()

	if committed.Load() != 1 {
		t.Fatalf("expected exactly 1 committed write, got %d", committed.Load())
	}
	if stale.Load() != workers-1 {
		t.Fatalf("expected %d stale conflicts, got %d", workers-1, stale.Load())
	}
	if other.Load() != 0 {
		t.Fatalf("expected zero unexpected outcomes, got %d", other.Load())
	}
}

func TestRepo_StoreDrawingRevision_ReplayAfterLockTimeout(t *testing.T) {
	baseDSN := os.Getenv("TEST_DATABASE_URL")
	if baseDSN == "" {
		t.Skip("TEST_DATABASE_URL not set — skipping database tests")
	}

	lockerPool := openPoolWithDSN(t, baseDSN)
	timeoutDSN := dsnWithParam(t, baseDSN, "lock_timeout", "100ms")
	timeoutPool := openPoolWithDSN(t, timeoutDSN)

	lockerRepo := repository.NewPgRepository(lockerPool)
	timeoutRepo := repository.NewPgRepository(timeoutPool)
	ctx := context.Background()
	drawing := newDrawing(uuid.NewString())

	if _, err := lockerRepo.CreateDrawing(ctx, drawing, "tester@example.com"); err != nil {
		t.Fatalf("CreateDrawing: %v", err)
	}
	head, err := lockerRepo.GetDrawing(ctx, drawing.GetDrawingId())
	if err != nil {
		t.Fatalf("GetDrawing: %v", err)
	}

	lockConn, err := lockerPool.Acquire(ctx)
	if err != nil {
		t.Fatalf("Acquire lock connection: %v", err)
	}
	defer lockConn.Release()

	lockTx, err := lockConn.Begin(ctx)
	if err != nil {
		t.Fatalf("Begin lock tx: %v", err)
	}
	defer func() { _ = lockTx.Rollback(ctx) }()

	if _, err := lockTx.Exec(ctx, `SELECT id FROM drawings WHERE id = $1 FOR UPDATE`, drawing.GetDrawingId()); err != nil {
		t.Fatalf("lock drawing row: %v", err)
	}

	commandID := uuid.NewString()
	baseInput := repository.StoreRevisionInput{
		DrawingID:            drawing.GetDrawingId(),
		Author:               "timeout-user@example.com",
		Summary:              "timeout then replay",
		CommandID:            commandID,
		BaseRevisionID:       head.GetCurrentRevisionId(),
		RequestedHeadVersion: head.GetRevisionCount(),
		Entities:             []*drawingv1.DrawingEntity{polylineEntity(drawing.GetDrawingId())},
		At:                   time.Now().UTC(),
	}

	_, _, _, err = timeoutRepo.StoreDrawingRevision(ctx, baseInput)
	if err == nil {
		t.Fatal("expected lock timeout conflict, got nil")
	}
	var conflictErr *repository.ConflictError
	if !errors.As(err, &conflictErr) {
		t.Fatalf("expected conflict error, got %v", err)
	}
	if conflictErr.OutcomeCode != repository.OutcomeLockTimeout {
		t.Fatalf("expected lock_timeout, got %q", conflictErr.OutcomeCode)
	}

	if err := lockTx.Rollback(ctx); err != nil {
		t.Fatalf("rollback lock tx: %v", err)
	}

	_, _, replayOutcome, err := timeoutRepo.StoreDrawingRevision(ctx, baseInput)
	if err != nil {
		t.Fatalf("replay after lock timeout should commit: %v", err)
	}
	if replayOutcome.Code != repository.OutcomeCommitted {
		t.Fatalf("expected committed replay, got %q", replayOutcome.Code)
	}

	_, _, duplicateOutcome, err := timeoutRepo.StoreDrawingRevision(ctx, baseInput)
	if err != nil {
		t.Fatalf("idempotent duplicate replay should succeed: %v", err)
	}
	if duplicateOutcome.Code != repository.OutcomeIdempotentDuplicate {
		t.Fatalf("expected idempotent_duplicate on second replay, got %q", duplicateOutcome.Code)
	}
}

