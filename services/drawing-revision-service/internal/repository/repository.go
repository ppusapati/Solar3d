package repository

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrNotFound = errors.New("not found")
	ErrConflict = errors.New("conflict")
)

type StoreRevisionInput struct {
	DrawingID            string
	Author               string
	Summary              string
	CommandID            string
	BaseRevisionID       string
	RequestedHeadVersion uint32
	Entities             []*drawingv1.DrawingEntity
	Contract             *commonv1.ContractMetadata
	At                   time.Time
}

type Repository interface {
	CreateDrawing(ctx context.Context, drawing *drawingv1.Drawing, author string) (*drawingv1.DrawingRevision, error)
	GetDrawing(ctx context.Context, drawingID string) (*drawingv1.Drawing, error)
	ListDrawings(ctx context.Context, projectID string, limit, offset int, includeArchived bool) ([]*drawingv1.Drawing, int, error)
	UpdateDrawing(ctx context.Context, drawing *drawingv1.Drawing) error
	GetDrawingState(ctx context.Context, drawingID, revisionID string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error)
	ListDrawingRevisions(ctx context.Context, drawingID string, limit, offset int) ([]*drawingv1.RevisionPointer, int, error)
	StoreDrawingRevision(ctx context.Context, input StoreRevisionInput) (*drawingv1.Drawing, *drawingv1.DrawingRevision, StoreRevisionOutcome, error)
	RecordConflictEvent(ctx context.Context, input ConflictEventInput) error
}

type PgRepository struct {
	pool *pgxpool.Pool
}

func NewPgRepository(pool *pgxpool.Pool) *PgRepository {
	return &PgRepository{pool: pool}
}

func (r *PgRepository) CreateDrawing(ctx context.Context, drawing *drawingv1.Drawing, author string) (*drawingv1.DrawingRevision, error) {
	if drawing == nil {
		return nil, fmt.Errorf("drawing is required")
	}

	initialRevisionID := uuid.NewString()
	now := drawing.GetCreatedAt().AsTime()
	if now.IsZero() {
		now = time.Now().UTC()
	}

	contractJSON, err := marshalContract(drawing.GetContract())
	if err != nil {
		return nil, err
	}

	tx, err := r.pool.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return nil, fmt.Errorf("begin create drawing tx: %w", err)
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	_, err = tx.Exec(ctx, `
		INSERT INTO drawings (
			id, project_id, name, description, metadata_json, status,
			current_revision_id, revision_count, entity_count, contract_json,
			created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5::jsonb,$6,$7,$8,$9,$10::jsonb,$11,$12)
	`,
		drawing.GetDrawingId(),
		drawing.GetProjectId(),
		drawing.GetName(),
		drawing.GetDescription(),
		jsonOrDefault(drawing.GetMetadataJson(), "{}"),
		statusToDB(drawing.GetStatus()),
		initialRevisionID,
		1,
		0,
		contractJSON,
		now,
		now,
	)
	if err != nil {
		return nil, classifyWriteError("insert drawing", err, "")
	}

	revisionContractJSON, err := marshalContract(drawing.GetContract())
	if err != nil {
		return nil, err
	}

	_, err = tx.Exec(ctx, `
		INSERT INTO drawing_revisions (
			id, drawing_id, parent_revision_id, author, summary, command_id,
			entity_count, snapshot_json, contract_json, committed_at
		) VALUES ($1,$2,NULL,$3,$4,$5,$6,$7::jsonb,$8::jsonb,$9)
	`, initialRevisionID, drawing.GetDrawingId(), author, "Initial revision", "", 0, "[]", revisionContractJSON, now)
	if err != nil {
		return nil, classifyWriteError("insert initial drawing revision", err, "")
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, fmt.Errorf("commit create drawing tx: %w", err)
	}

	revision := &drawingv1.DrawingRevision{
		Pointer: &drawingv1.RevisionPointer{
			RevisionId:       initialRevisionID,
			ParentRevisionId: "",
			Author:           author,
			Summary:          "Initial revision",
			CommittedAt:      timestamppb.New(now),
			Contract:         cloneContract(drawing.GetContract()),
		},
		DrawingId: drawing.GetDrawingId(),
		CommandId: "",
		Entities:  []*drawingv1.DrawingEntity{},
	}

	return revision, nil
}

func (r *PgRepository) GetDrawing(ctx context.Context, drawingID string) (*drawingv1.Drawing, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, project_id, name, description, metadata_json::text, status,
		       current_revision_id, revision_count, entity_count, contract_json::text,
		       created_at, updated_at
		  FROM drawings
		 WHERE id = $1
	`, drawingID)

	return scanDrawing(row)
}

func (r *PgRepository) ListDrawings(ctx context.Context, projectID string, limit, offset int, includeArchived bool) ([]*drawingv1.Drawing, int, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 200 {
		limit = 200
	}
	if offset < 0 {
		offset = 0
	}

	where := "project_id = $1"
	args := []any{projectID}
	if !includeArchived {
		where += " AND status <> 'archived'"
	}

	countRow := r.pool.QueryRow(ctx, `SELECT COUNT(*) FROM drawings WHERE `+where, args...)
	var total int
	if err := countRow.Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count drawings: %w", err)
	}

	args = append(args, limit, offset)
	rows, err := r.pool.Query(ctx, `
		SELECT id, project_id, name, description, metadata_json::text, status,
		       current_revision_id, revision_count, entity_count, contract_json::text,
		       created_at, updated_at
		  FROM drawings
		 WHERE `+where+`
		 ORDER BY updated_at DESC, id DESC
		 LIMIT $2 OFFSET $3
	`, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("list drawings: %w", err)
	}
	defer rows.Close()

	var drawings []*drawingv1.Drawing
	for rows.Next() {
		drawing, scanErr := scanDrawing(rows)
		if scanErr != nil {
			return nil, 0, scanErr
		}
		drawings = append(drawings, drawing)
	}
	if err := rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("iterate drawings: %w", err)
	}

	return drawings, total, nil
}

func (r *PgRepository) UpdateDrawing(ctx context.Context, drawing *drawingv1.Drawing) error {
	contractJSON, err := marshalContract(drawing.GetContract())
	if err != nil {
		return err
	}

	tag, err := r.pool.Exec(ctx, `
		UPDATE drawings
		   SET name = $2,
		       description = $3,
		       metadata_json = $4::jsonb,
		       status = $5,
		       contract_json = $6::jsonb,
		       updated_at = $7
		 WHERE id = $1
	`, drawing.GetDrawingId(), drawing.GetName(), drawing.GetDescription(), jsonOrDefault(drawing.GetMetadataJson(), "{}"), statusToDB(drawing.GetStatus()), contractJSON, drawing.GetUpdatedAt().AsTime())
	if err != nil {
		return classifyWriteError("update drawing", err, "")
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

func (r *PgRepository) GetDrawingState(ctx context.Context, drawingID, revisionID string) (*drawingv1.Drawing, *drawingv1.DrawingRevision, error) {
	drawing, err := r.GetDrawing(ctx, drawingID)
	if err != nil {
		return nil, nil, err
	}

	if strings.TrimSpace(revisionID) == "" {
		revisionID = drawing.GetCurrentRevisionId()
	}

	row := r.pool.QueryRow(ctx, `
		SELECT id, drawing_id, parent_revision_id, author, summary, command_id,
		       entity_count, snapshot_json::text, contract_json::text, committed_at
		  FROM drawing_revisions
		 WHERE drawing_id = $1 AND id = $2
	`, drawingID, revisionID)

	revision, err := scanRevision(row)
	if err != nil {
		return nil, nil, err
	}
	return drawing, revision, nil
}

func (r *PgRepository) ListDrawingRevisions(ctx context.Context, drawingID string, limit, offset int) ([]*drawingv1.RevisionPointer, int, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 200 {
		limit = 200
	}
	if offset < 0 {
		offset = 0
	}

	countRow := r.pool.QueryRow(ctx, `SELECT COUNT(*) FROM drawing_revisions WHERE drawing_id = $1`, drawingID)
	var total int
	if err := countRow.Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count drawing revisions: %w", err)
	}

	rows, err := r.pool.Query(ctx, `
		SELECT id, parent_revision_id, author, summary, contract_json::text, committed_at
		  FROM drawing_revisions
		 WHERE drawing_id = $1
		 ORDER BY committed_at DESC, id DESC
		 LIMIT $2 OFFSET $3
	`, drawingID, limit, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("list drawing revisions: %w", err)
	}
	defer rows.Close()

	var revisions []*drawingv1.RevisionPointer
	for rows.Next() {
		var revisionID string
		var parentRevisionID *string
		var author string
		var summary string
		var contractJSON string
		var committedAt time.Time
		if err := rows.Scan(&revisionID, &parentRevisionID, &author, &summary, &contractJSON, &committedAt); err != nil {
			return nil, 0, fmt.Errorf("scan drawing revision pointer: %w", err)
		}
		contract, err := unmarshalContract(contractJSON)
		if err != nil {
			return nil, 0, err
		}
		parent := ""
		if parentRevisionID != nil {
			parent = *parentRevisionID
		}
		revisions = append(revisions, &drawingv1.RevisionPointer{
			RevisionId:       revisionID,
			ParentRevisionId: parent,
			Author:           author,
			Summary:          summary,
			CommittedAt:      timestamppb.New(committedAt),
			Contract:         contract,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("iterate drawing revisions: %w", err)
	}

	return revisions, total, nil
}

func (r *PgRepository) StoreDrawingRevision(ctx context.Context, input StoreRevisionInput) (*drawingv1.Drawing, *drawingv1.DrawingRevision, StoreRevisionOutcome, error) {
	now := input.At.UTC()
	if now.IsZero() {
		now = time.Now().UTC()
	}
	if err := r.cleanupExpiredCommandAttempts(ctx, now); err != nil {
		return nil, nil, StoreRevisionOutcome{}, err
	}
	attemptID, err := r.createCommandAttempt(ctx, input, now)
	if err != nil {
		return nil, nil, StoreRevisionOutcome{}, err
	}
	outcome := StoreRevisionOutcome{AttemptID: attemptID}

	tx, err := r.pool.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, OutcomeLockTimeout, "", "", 0, fmt.Sprintf("begin store revision tx: %v", err), now)
		return nil, nil, outcome, fmt.Errorf("begin store revision tx: %w", err)
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	var drawing drawingv1.Drawing
	var metadataJSON string
	var status string
	var contractJSON string
	var revisionCount int
	var currentRevisionID *string
	var createdAt time.Time
	var updatedAt time.Time

	row := tx.QueryRow(ctx, `
		SELECT id, project_id, name, description, metadata_json::text, status,
		       current_revision_id, revision_count, entity_count, contract_json::text,
		       created_at, updated_at
		  FROM drawings
		 WHERE id = $1
		 FOR UPDATE
	`, input.DrawingID)

	var entityCount int
	if err := row.Scan(
		&drawing.DrawingId,
		&drawing.ProjectId,
		&drawing.Name,
		&drawing.Description,
		&metadataJSON,
		&status,
		&currentRevisionID,
		&revisionCount,
		&entityCount,
		&contractJSON,
		&createdAt,
		&updatedAt,
	); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, "not_found", "", "", 0, "drawing not found", now)
			return nil, nil, outcome, ErrNotFound
		}
		classified := classifyWriteError("lock drawing", err, attemptID)
		r.finalizeAttemptFromError(ctx, attemptID, input, "", 0, classified, now)
		return nil, nil, outcome, classified
	}

	storedContract, err := unmarshalContract(contractJSON)
	if err != nil {
		r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, "internal", "", "", 0, err.Error(), now)
		return nil, nil, outcome, err
	}
	drawing.MetadataJson = metadataJSON
	drawing.Status = statusFromDB(status)
	drawing.CurrentRevisionId = derefString(currentRevisionID)
	drawing.RevisionCount = uint32(revisionCount)
	drawing.EntityCount = uint32(entityCount)
	drawing.CreatedAt = timestamppb.New(createdAt)
	drawing.UpdatedAt = timestamppb.New(updatedAt)
	drawing.Contract = storedContract

	if drawing.GetStatus() == drawingv1.DrawingStatus_DRAWING_STATUS_ARCHIVED {
		conflictErr := &ConflictError{OutcomeCode: "archived_drawing", Message: "drawing is archived", AttemptID: attemptID, HeadRevisionID: drawing.GetCurrentRevisionId(), HeadVersion: drawing.GetRevisionCount()}
		r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, conflictErr.OutcomeCode, "", drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), conflictErr.Message, now)
		return nil, nil, outcome, conflictErr
	}

	if isStaleBase(input.BaseRevisionID, input.RequestedHeadVersion, derefString(currentRevisionID), uint32(revisionCount)) {
		conflictErr := &ConflictError{
			OutcomeCode:    OutcomeStaleBase,
			Message:        "base revision is stale",
			AttemptID:      attemptID,
			BaseRevisionID: strings.TrimSpace(input.BaseRevisionID),
			HeadRevisionID: derefString(currentRevisionID),
			HeadVersion:    uint32(revisionCount),
		}
		r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, conflictErr.OutcomeCode, "", conflictErr.HeadRevisionID, conflictErr.HeadVersion, conflictErr.Message, now)
		_ = r.RecordConflictEvent(ctx, ConflictEventInput{
			DrawingID:      input.DrawingID,
			CommandID:      input.CommandID,
			Actor:          input.Author,
			Summary:        input.Summary,
			BaseRevisionID: input.BaseRevisionID,
			HeadRevisionID: conflictErr.HeadRevisionID,
			HeadVersion:    conflictErr.HeadVersion,
			OutcomeCode:    conflictErr.OutcomeCode,
			DetailsJSON:    jsonOrDefault(fmt.Sprintf(`{"message":%q}`, conflictErr.Message), "{}"),
		})
		return nil, nil, outcome, conflictErr
	}

	revisionContractJSON, err := marshalContract(input.Contract)
	if err != nil {
		r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, "internal", "", drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), err.Error(), now)
		return nil, nil, outcome, err
	}
	snapshotJSON, err := marshalEntities(input.Entities)
	if err != nil {
		r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, "internal", "", drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), err.Error(), now)
		return nil, nil, outcome, err
	}

	revisionID := uuid.NewString()
	committedAt := now

	_, err = tx.Exec(ctx, `
		INSERT INTO drawing_revisions (
			id, drawing_id, parent_revision_id, author, summary, command_id,
			entity_count, snapshot_json, contract_json, committed_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8::jsonb,$9::jsonb,$10)
	`, revisionID, input.DrawingID, currentRevisionID, input.Author, input.Summary, input.CommandID, len(input.Entities), snapshotJSON, revisionContractJSON, committedAt)
	if err != nil {
		if isDuplicateCommandIDError(err) && strings.TrimSpace(input.CommandID) != "" {
			recordDuplicateCommandReplay()
			existingRevision, getErr := getRevisionByCommandID(ctx, tx, input.DrawingID, input.CommandID)
			if getErr != nil {
				r.finalizeAttemptFromError(ctx, attemptID, input, drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), getErr, now)
				return nil, nil, outcome, getErr
			}

			// Idempotent replay path: command already stored previously.
			drawing.CurrentRevisionId = derefString(currentRevisionID)
			drawing.RevisionCount = uint32(revisionCount)
			drawing.EntityCount = uint32(entityCount)
			drawing.UpdatedAt = timestamppb.New(updatedAt)

			if err := tx.Commit(ctx); err != nil {
				classified := fmt.Errorf("commit idempotent revision tx: %w", err)
				r.finalizeAttemptFromError(ctx, attemptID, input, drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), classified, now)
				return nil, nil, outcome, classified
			}
			outcome = StoreRevisionOutcome{
				Code:             OutcomeIdempotentDuplicate,
				AttemptID:        attemptID,
				HeadVersion:      drawing.GetRevisionCount(),
				HeadRevisionID:   drawing.GetCurrentRevisionId(),
				IdempotentReplay: true,
			}
			r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusSucceeded, outcome.Code, existingRevision.GetPointer().GetRevisionId(), drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), "idempotent replay", now)
			return &drawing, existingRevision, outcome, nil
		}
		classified := classifyWriteError("insert drawing revision", err, attemptID)
		r.finalizeAttemptFromError(ctx, attemptID, input, drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), classified, now)
		return nil, nil, outcome, classified
	}

	updatedAt = committedAt
	_, err = tx.Exec(ctx, `
		UPDATE drawings
		   SET current_revision_id = $2,
		       revision_count = revision_count + 1,
		       entity_count = $3,
		       updated_at = $4
		 WHERE id = $1
	`, input.DrawingID, revisionID, len(input.Entities), updatedAt)
	if err != nil {
		classified := classifyWriteError("advance drawing head", err, attemptID)
		r.finalizeAttemptFromError(ctx, attemptID, input, drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), classified, now)
		return nil, nil, outcome, classified
	}

	if err := rebuildEntityIndexTx(ctx, tx, input.DrawingID, revisionID, input.Entities, committedAt); err != nil {
		classified := err
		r.finalizeAttemptFromError(ctx, attemptID, input, drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), classified, now)
		return nil, nil, outcome, classified
	}

	if err := tx.Commit(ctx); err != nil {
		classified := fmt.Errorf("commit store revision tx: %w", err)
		r.finalizeAttemptFromError(ctx, attemptID, input, drawing.GetCurrentRevisionId(), drawing.GetRevisionCount(), classified, now)
		return nil, nil, outcome, classified
	}

	drawing.CurrentRevisionId = revisionID
	drawing.RevisionCount++
	drawing.EntityCount = uint32(len(input.Entities))
	drawing.UpdatedAt = timestamppb.New(updatedAt)

	revision := &drawingv1.DrawingRevision{
		Pointer: &drawingv1.RevisionPointer{
			RevisionId:       revisionID,
			ParentRevisionId: derefString(currentRevisionID),
			Author:           input.Author,
			Summary:          input.Summary,
			CommittedAt:      timestamppb.New(committedAt),
			Contract:         cloneContract(input.Contract),
		},
		DrawingId: input.DrawingID,
		CommandId: input.CommandID,
		Entities:  cloneEntities(input.Entities),
	}

	outcome = StoreRevisionOutcome{
		Code:           OutcomeCommitted,
		AttemptID:      attemptID,
		HeadVersion:    drawing.GetRevisionCount(),
		HeadRevisionID: revisionID,
	}
	r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusSucceeded, outcome.Code, revisionID, revisionID, drawing.GetRevisionCount(), "commit succeeded", now)
	if err := r.PostCommitIntegrityCheck(ctx, input.DrawingID, revisionID, now); err != nil {
		recordIntegrityAuditFailure()
	}
	return &drawing, revision, outcome, nil
}

func (r *PgRepository) RecordConflictEvent(ctx context.Context, input ConflictEventInput) error {
	when := time.Now().UTC()
	_, err := r.pool.Exec(ctx, `
		INSERT INTO drawing_conflict_events (
			id, drawing_id, command_id, actor, summary, base_revision_id,
			head_revision_id, head_version, outcome_code, details_json, created_at
		) VALUES ($1,$2,$3,$4,$5,NULLIF($6, '')::uuid,NULLIF($7, '')::uuid,$8,$9,$10::jsonb,$11)
	`, uuid.NewString(), input.DrawingID, strings.TrimSpace(input.CommandID), strings.TrimSpace(input.Actor), strings.TrimSpace(input.Summary), strings.TrimSpace(input.BaseRevisionID), strings.TrimSpace(input.HeadRevisionID), input.HeadVersion, input.OutcomeCode, jsonOrDefault(input.DetailsJSON, "{}"), when)
	if err != nil {
		return fmt.Errorf("insert drawing conflict event: %w", err)
	}
	return nil
}

type drawingScanner interface {
	Scan(dest ...any) error
}

func scanDrawing(row drawingScanner) (*drawingv1.Drawing, error) {
	var drawing drawingv1.Drawing
	var metadataJSON string
	var status string
	var currentRevisionID *string
	var contractJSON string
	var createdAt time.Time
	var updatedAt time.Time

	err := row.Scan(
		&drawing.DrawingId,
		&drawing.ProjectId,
		&drawing.Name,
		&drawing.Description,
		&metadataJSON,
		&status,
		&currentRevisionID,
		&drawing.RevisionCount,
		&drawing.EntityCount,
		&contractJSON,
		&createdAt,
		&updatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("scan drawing: %w", err)
	}

	contract, err := unmarshalContract(contractJSON)
	if err != nil {
		return nil, err
	}

	drawing.MetadataJson = metadataJSON
	drawing.Status = statusFromDB(status)
	drawing.CurrentRevisionId = derefString(currentRevisionID)
	drawing.Contract = contract
	drawing.CreatedAt = timestamppb.New(createdAt)
	drawing.UpdatedAt = timestamppb.New(updatedAt)
	return &drawing, nil
}

func scanRevision(row drawingScanner) (*drawingv1.DrawingRevision, error) {
	var revisionID string
	var drawingID string
	var parentRevisionID *string
	var author string
	var summary string
	var commandID string
	var entityCount int
	var snapshotJSON string
	var contractJSON string
	var committedAt time.Time

	err := row.Scan(&revisionID, &drawingID, &parentRevisionID, &author, &summary, &commandID, &entityCount, &snapshotJSON, &contractJSON, &committedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("scan drawing revision: %w", err)
	}

	entities, err := unmarshalEntities(snapshotJSON)
	if err != nil {
		return nil, err
	}
	contract, err := unmarshalContract(contractJSON)
	if err != nil {
		return nil, err
	}

	return &drawingv1.DrawingRevision{
		Pointer: &drawingv1.RevisionPointer{
			RevisionId:       revisionID,
			ParentRevisionId: derefString(parentRevisionID),
			Author:           author,
			Summary:          summary,
			CommittedAt:      timestamppb.New(committedAt),
			Contract:         contract,
		},
		DrawingId: drawingID,
		CommandId: commandID,
		Entities:  entities,
	}, nil
}

func marshalEntities(entities []*drawingv1.DrawingEntity) (string, error) {
	encoded := make([]json.RawMessage, 0, len(entities))
	for _, entity := range entities {
		payload, err := protojson.Marshal(entity)
		if err != nil {
			return "", fmt.Errorf("marshal drawing entity: %w", err)
		}
		encoded = append(encoded, payload)
	}
	payload, err := json.Marshal(encoded)
	if err != nil {
		return "", fmt.Errorf("marshal drawing entity snapshot: %w", err)
	}
	return string(payload), nil
}

func unmarshalEntities(raw string) ([]*drawingv1.DrawingEntity, error) {
	if strings.TrimSpace(raw) == "" {
		return []*drawingv1.DrawingEntity{}, nil
	}
	var encoded []json.RawMessage
	if err := json.Unmarshal([]byte(raw), &encoded); err != nil {
		return nil, fmt.Errorf("unmarshal drawing entity snapshot: %w", err)
	}
	entities := make([]*drawingv1.DrawingEntity, 0, len(encoded))
	for _, item := range encoded {
		entity := &drawingv1.DrawingEntity{}
		if err := protojson.Unmarshal(item, entity); err != nil {
			return nil, fmt.Errorf("unmarshal drawing entity: %w", err)
		}
		entities = append(entities, entity)
	}
	return entities, nil
}

func marshalContract(contract *commonv1.ContractMetadata) (string, error) {
	if contract == nil {
		return `{}`, nil
	}
	payload, err := protojson.Marshal(contract)
	if err != nil {
		return "", fmt.Errorf("marshal contract metadata: %w", err)
	}
	return string(payload), nil
}

func unmarshalContract(raw string) (*commonv1.ContractMetadata, error) {
	if strings.TrimSpace(raw) == "" || strings.TrimSpace(raw) == "{}" {
		return nil, nil
	}
	contract := &commonv1.ContractMetadata{}
	if err := protojson.Unmarshal([]byte(raw), contract); err != nil {
		return nil, fmt.Errorf("unmarshal contract metadata: %w", err)
	}
	return contract, nil
}

func classifyWriteError(operation string, err error, attemptID string) error {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && (pgErr.Code == "55P03" || pgErr.Code == "40P01") {
		recordLockWaitConflict()
		return &ConflictError{OutcomeCode: OutcomeLockTimeout, Message: fmt.Sprintf("%s: %v", operation, err), AttemptID: attemptID}
	}
	if errors.As(err, &pgErr) && pgErr.Code == "23505" {
		return fmt.Errorf("%s: %w", operation, ErrConflict)
	}
	return fmt.Errorf("%s: %w", operation, err)
}

func isStaleBase(baseRevisionID string, requestedHeadVersion uint32, currentRevisionID string, currentHeadVersion uint32) bool {
	trimmedBase := strings.TrimSpace(baseRevisionID)
	if trimmedBase != "" && trimmedBase != strings.TrimSpace(currentRevisionID) {
		return true
	}
	if requestedHeadVersion > 0 && requestedHeadVersion != currentHeadVersion {
		return true
	}
	return false
}

func (r *PgRepository) cleanupExpiredCommandAttempts(ctx context.Context, now time.Time) error {
	_, err := r.pool.Exec(ctx, `DELETE FROM drawing_command_attempts WHERE expires_at < $1`, now)
	if err != nil {
		return fmt.Errorf("cleanup expired command attempts: %w", err)
	}
	return nil
}

func (r *PgRepository) createCommandAttempt(ctx context.Context, input StoreRevisionInput, now time.Time) (string, error) {
	if strings.TrimSpace(input.CommandID) == "" {
		return "", nil
	}
	attemptID := uuid.NewString()
	_, err := r.pool.Exec(ctx, `
		INSERT INTO drawing_command_attempts (
			id, drawing_id, command_id, actor, summary, base_revision_id,
			requested_head_version, status, outcome_code, outcome_message,
			attempt_hash, expires_at, created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,NULLIF($6, '')::uuid,$7,$8,$9,$10,$11,$12,$13,$14)
	`, attemptID, input.DrawingID, strings.TrimSpace(input.CommandID), strings.TrimSpace(input.Author), strings.TrimSpace(input.Summary), strings.TrimSpace(input.BaseRevisionID), input.RequestedHeadVersion, AttemptStatusPending, "", "", attemptHash(input), now.Add(24*time.Hour), now, now)
	if err != nil {
		return "", fmt.Errorf("insert command attempt: %w", err)
	}
	return attemptID, nil
}

func (r *PgRepository) finalizeCommandAttempt(ctx context.Context, attemptID string, status string, outcomeCode string, revisionID string, observedHeadRevisionID string, observedHeadVersion uint32, message string, now time.Time) {
	if strings.TrimSpace(attemptID) == "" {
		return
	}
	_, _ = r.pool.Exec(ctx, `
		UPDATE drawing_command_attempts
		   SET status = $2,
		       outcome_code = $3,
		       outcome_message = $4,
		       revision_id = NULLIF($5, '')::uuid,
		       observed_head_revision_id = NULLIF($6, '')::uuid,
		       observed_head_version = $7,
		       expires_at = $8,
		       updated_at = $9
		 WHERE id = $1
	`, attemptID, status, outcomeCode, strings.TrimSpace(message), strings.TrimSpace(revisionID), strings.TrimSpace(observedHeadRevisionID), observedHeadVersion, now.Add(24*time.Hour), now)
}

func (r *PgRepository) finalizeAttemptFromError(ctx context.Context, attemptID string, input StoreRevisionInput, observedHeadRevisionID string, observedHeadVersion uint32, err error, now time.Time) {
	if strings.TrimSpace(attemptID) == "" {
		return
	}
	outcomeCode := "internal"
	message := err.Error()
	var conflictErr *ConflictError
	if errors.As(err, &conflictErr) {
		if conflictErr.OutcomeCode != "" {
			outcomeCode = conflictErr.OutcomeCode
		}
		if conflictErr.HeadRevisionID != "" {
			observedHeadRevisionID = conflictErr.HeadRevisionID
		}
		if conflictErr.HeadVersion > 0 {
			observedHeadVersion = conflictErr.HeadVersion
		}
		if conflictErr.Message != "" {
			message = conflictErr.Message
		}
	}
	r.finalizeCommandAttempt(ctx, attemptID, AttemptStatusFailed, outcomeCode, "", observedHeadRevisionID, observedHeadVersion, message, now)
	if outcomeCode == OutcomeStaleBase || outcomeCode == OutcomeLockTimeout {
		_ = r.RecordConflictEvent(ctx, ConflictEventInput{
			DrawingID:      input.DrawingID,
			CommandID:      input.CommandID,
			Actor:          input.Author,
			Summary:        input.Summary,
			BaseRevisionID: input.BaseRevisionID,
			HeadRevisionID: observedHeadRevisionID,
			HeadVersion:    observedHeadVersion,
			OutcomeCode:    outcomeCode,
			DetailsJSON:    fmt.Sprintf(`{"message":%q,"attempt_id":%q}`, message, attemptID),
		})
	}
}

func attemptHash(input StoreRevisionInput) string {
	payload := fmt.Sprintf("%s|%s|%s|%s|%d|%d", input.DrawingID, input.CommandID, input.Author, input.BaseRevisionID, input.RequestedHeadVersion, len(input.Entities))
	hash := sha256.Sum256([]byte(payload))
	return hex.EncodeToString(hash[:])
}

func isDuplicateCommandIDError(err error) bool {
	var pgErr *pgconn.PgError
	if !errors.As(err, &pgErr) {
		return false
	}
	if pgErr.Code != "23505" {
		return false
	}
	// Unique partial index from migration 006.
	return strings.Contains(pgErr.ConstraintName, "idx_drawing_revisions_command_id")
}

func getRevisionByCommandID(ctx context.Context, tx pgx.Tx, drawingID string, commandID string) (*drawingv1.DrawingRevision, error) {
	row := tx.QueryRow(ctx, `
		SELECT id, drawing_id, parent_revision_id, author, summary, command_id,
		       entity_count, snapshot_json::text, contract_json::text, committed_at
		  FROM drawing_revisions
		 WHERE drawing_id = $1 AND command_id = $2
		 LIMIT 1
	`, drawingID, commandID)
	revision, err := scanRevision(row)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			return nil, fmt.Errorf("lookup revision by command_id: %w", ErrConflict)
		}
		return nil, fmt.Errorf("lookup revision by command_id: %w", err)
	}
	return revision, nil
}

func statusToDB(status drawingv1.DrawingStatus) string {
	if status == drawingv1.DrawingStatus_DRAWING_STATUS_ARCHIVED {
		return "archived"
	}
	return "active"
}

func statusFromDB(status string) drawingv1.DrawingStatus {
	if status == "archived" {
		return drawingv1.DrawingStatus_DRAWING_STATUS_ARCHIVED
	}
	return drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE
}

func jsonOrDefault(value string, fallback string) string {
	if strings.TrimSpace(value) == "" {
		return fallback
	}
	return value
}

func cloneContract(contract *commonv1.ContractMetadata) *commonv1.ContractMetadata {
	if contract == nil {
		return nil
	}
	return proto.Clone(contract).(*commonv1.ContractMetadata)
}

func cloneEntities(entities []*drawingv1.DrawingEntity) []*drawingv1.DrawingEntity {
	cloned := make([]*drawingv1.DrawingEntity, 0, len(entities))
	for _, entity := range entities {
		payload, err := protojson.Marshal(entity)
		if err != nil {
			continue
		}
		copy := &drawingv1.DrawingEntity{}
		if err := protojson.Unmarshal(payload, copy); err != nil {
			continue
		}
		cloned = append(cloned, copy)
	}
	return cloned
}

func derefString(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

