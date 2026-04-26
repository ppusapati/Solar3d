package repository

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/types/known/timestamppb"
)

const (
	IntegrityIssueEntityCountMismatch   = "entity_count_mismatch"
	IntegrityIssueRevisionCountMismatch = "revision_count_mismatch"
	IntegrityIssueHeadPointerDrift      = "head_pointer_drift"
	IntegrityIssueEntityRevisionDrift   = "entity_revision_drift"
	IntegrityIssueOrphanedEntityIndex   = "orphaned_entity_index"
	IntegrityIssueMissingEntityIndex    = "missing_entity_index"
	IntegrityIssueMissingHeadRevision   = "missing_head_revision"
)

type IntegrityFinding struct {
	DrawingID          string
	IssueKey           string
	IssueCode          string
	Severity           string
	CurrentRevisionID  string
	ExpectedRevisionID string
	ExpectedCount      int
	ActualCount        int
	DetailsJSON        string
}

type IntegrityAuditReport struct {
	RunID           string
	CheckedDrawings int
	Findings        []IntegrityFinding
}

type IntegrityRepairResult struct {
	DrawingID      string
	Mode           string
	RevisionID     string
	EntityCount    int
	RevisionCount  int
	ResolvedIssues int
}

func (r *PgRepository) RunIntegrityAudit(ctx context.Context, limit int, auditedAt time.Time) (report *IntegrityAuditReport, err error) {
	if limit <= 0 {
		limit = 250
	}
	if auditedAt.IsZero() {
		auditedAt = time.Now().UTC()
	}

	runID, err := r.insertIntegrityAuditRun(ctx, auditedAt)
	if err != nil {
		return nil, err
	}

	report = &IntegrityAuditReport{RunID: runID}
	defer func() {
		status := "completed"
		errMessage := ""
		if err != nil {
			status = "failed"
			errMessage = err.Error()
			recordIntegrityAuditFailure()
		}
		checkedDrawings := 0
		findingsCount := 0
		if report != nil {
			checkedDrawings = report.CheckedDrawings
			findingsCount = len(report.Findings)
		}
		_ = r.finishIntegrityAuditRun(context.Background(), runID, checkedDrawings, findingsCount, 0, status, errMessage, time.Now().UTC())
	}()

	rows, err := r.pool.Query(ctx, `
		SELECT id
		  FROM drawings
		 ORDER BY updated_at DESC, id DESC
		 LIMIT $1
	`, limit)
	if err != nil {
		return nil, fmt.Errorf("query integrity audit drawings: %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		var drawingID string
		if scanErr := rows.Scan(&drawingID); scanErr != nil {
			return nil, fmt.Errorf("scan integrity audit drawing id: %w", scanErr)
		}
		findings, auditErr := r.auditDrawing(ctx, drawingID)
		if auditErr != nil {
			return nil, auditErr
		}
		if resolveErr := r.syncIntegrityFindings(ctx, runID, drawingID, findings, auditedAt); resolveErr != nil {
			return nil, resolveErr
		}
		report.CheckedDrawings++
		report.Findings = append(report.Findings, findings...)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate integrity audit drawings: %w", err)
	}

	recordIntegrityDrift(len(report.Findings))
	return report, nil
}

func (r *PgRepository) VerifyDrawingIntegrity(ctx context.Context, drawingID string) ([]IntegrityFinding, error) {
	return r.auditDrawing(ctx, drawingID)
}

func (r *PgRepository) RepairDrawingEntityIndex(ctx context.Context, drawingID string, repairedAt time.Time) (*IntegrityRepairResult, error) {
	if repairedAt.IsZero() {
		repairedAt = time.Now().UTC()
	}
	return r.repairDrawing(ctx, drawingID, repairedAt, false)
}

func (r *PgRepository) RepairDrawingHead(ctx context.Context, drawingID string, repairedAt time.Time) (*IntegrityRepairResult, error) {
	if repairedAt.IsZero() {
		repairedAt = time.Now().UTC()
	}
	return r.repairDrawing(ctx, drawingID, repairedAt, true)
}

func (r *PgRepository) repairDrawing(ctx context.Context, drawingID string, repairedAt time.Time, repairHead bool) (*IntegrityRepairResult, error) {
	tx, err := r.pool.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return nil, fmt.Errorf("begin repair tx: %w", err)
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	drawing, latestRevision, revisionCount, err := r.loadRepairState(ctx, tx, drawingID, repairHead)
	if err != nil {
		return nil, err
	}
	entities := latestRevision.GetEntities()
	entityCount := len(entities)
	currentRevisionID := latestRevision.GetPointer().GetRevisionId()

	if _, err := tx.Exec(ctx, `
		UPDATE drawings
		   SET current_revision_id = $2,
		       revision_count = $3,
		       entity_count = $4,
		       updated_at = $5
		 WHERE id = $1
	`, drawingID, currentRevisionID, revisionCount, entityCount, repairedAt); err != nil {
		return nil, fmt.Errorf("update drawing during repair: %w", err)
	}
	if err := rebuildEntityIndexTx(ctx, tx, drawingID, currentRevisionID, entities, repairedAt); err != nil {
		return nil, err
	}
	if err := tx.Commit(ctx); err != nil {
		return nil, fmt.Errorf("commit repair tx: %w", err)
	}

	resolved, err := r.resolveOpenIntegrityFindings(ctx, drawingID, repairedAt)
	if err != nil {
		return nil, err
	}
	recordIntegrityRepair(resolved)
	mode := "entity-index"
	if repairHead {
		mode = "head-and-index"
	}
	_ = drawing
	return &IntegrityRepairResult{
		DrawingID:      drawingID,
		Mode:           mode,
		RevisionID:     currentRevisionID,
		EntityCount:    entityCount,
		RevisionCount:  revisionCount,
		ResolvedIssues: resolved,
	}, nil
}

func (r *PgRepository) PostCommitIntegrityCheck(ctx context.Context, drawingID string, _ string, auditedAt time.Time) error {
	findings, err := r.auditDrawing(ctx, drawingID)
	if err != nil {
		return err
	}
	if err := r.syncIntegrityFindings(ctx, "", drawingID, findings, auditedAt); err != nil {
		return err
	}
	recordIntegrityDrift(len(findings))
	return nil
}

func (r *PgRepository) auditDrawing(ctx context.Context, drawingID string) ([]IntegrityFinding, error) {
	drawing, err := r.GetDrawing(ctx, drawingID)
	if err != nil {
		return nil, err
	}

	latestRevision, latestRevisionCount, err := r.loadLatestRevision(ctx, drawingID)
	if err != nil {
		return nil, err
	}
	currentRevision, err := r.loadCurrentRevision(ctx, drawingID, drawing.GetCurrentRevisionId())
	if err != nil && !errors.Is(err, ErrNotFound) {
		return nil, err
	}

	indexEntities, err := r.loadIndexedEntities(ctx, drawingID)
	if err != nil {
		return nil, err
	}
	findings := make([]IntegrityFinding, 0)

	if drawing.GetCurrentRevisionId() == "" || currentRevision == nil {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueMissingHeadRevision, "error", drawing.GetCurrentRevisionId(), latestRevision.GetPointer().GetRevisionId(), int(drawing.GetEntityCount()), len(indexEntities), map[string]any{"message": "drawing current_revision_id is missing or unreadable"}))
		return findings, nil
	}

	if drawing.GetCurrentRevisionId() != latestRevision.GetPointer().GetRevisionId() {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueHeadPointerDrift, "error", drawing.GetCurrentRevisionId(), latestRevision.GetPointer().GetRevisionId(), int(drawing.GetRevisionCount()), latestRevisionCount, map[string]any{"message": "drawing current revision does not match latest committed revision"}))
	}
	if int(drawing.GetRevisionCount()) != latestRevisionCount {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueRevisionCountMismatch, "error", drawing.GetCurrentRevisionId(), latestRevision.GetPointer().GetRevisionId(), latestRevisionCount, int(drawing.GetRevisionCount()), map[string]any{"message": "drawing revision_count does not match actual revision rows"}))
	}

	snapshotEntityIDs := make(map[string]struct{}, len(currentRevision.GetEntities()))
	for _, entity := range currentRevision.GetEntities() {
		snapshotEntityIDs[entity.GetHeader().GetEntityId()] = struct{}{}
	}
	if int(drawing.GetEntityCount()) != len(currentRevision.GetEntities()) {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueEntityCountMismatch, "error", drawing.GetCurrentRevisionId(), drawing.GetCurrentRevisionId(), len(currentRevision.GetEntities()), int(drawing.GetEntityCount()), map[string]any{"message": "drawing entity_count does not match current revision snapshot"}))
	}
	if int(drawing.GetEntityCount()) != len(indexEntities) {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueEntityCountMismatch, "error", drawing.GetCurrentRevisionId(), drawing.GetCurrentRevisionId(), len(indexEntities), int(drawing.GetEntityCount()), map[string]any{"message": "drawing entity_count does not match drawing_entities index"}))
	}

	orphaned := make([]string, 0)
	missing := make([]string, 0)
	entityRevisionDriftCount := 0
	indexEntityIDs := make(map[string]struct{}, len(indexEntities))
	for entityID, revisionID := range indexEntities {
		indexEntityIDs[entityID] = struct{}{}
		if revisionID != drawing.GetCurrentRevisionId() {
			entityRevisionDriftCount++
		}
		if _, ok := snapshotEntityIDs[entityID]; !ok {
			orphaned = append(orphaned, entityID)
		}
	}
	for entityID := range snapshotEntityIDs {
		if _, ok := indexEntityIDs[entityID]; !ok {
			missing = append(missing, entityID)
		}
	}
	sort.Strings(orphaned)
	sort.Strings(missing)
	if entityRevisionDriftCount > 0 {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueEntityRevisionDrift, "error", drawing.GetCurrentRevisionId(), drawing.GetCurrentRevisionId(), 0, entityRevisionDriftCount, map[string]any{"message": "drawing_entities rows reference revisions other than drawing current_revision_id"}))
	}
	if len(orphaned) > 0 {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueOrphanedEntityIndex, "error", drawing.GetCurrentRevisionId(), drawing.GetCurrentRevisionId(), 0, len(orphaned), map[string]any{"entity_ids": orphaned, "message": "drawing_entities contains rows absent from current head snapshot"}))
	}
	if len(missing) > 0 {
		findings = append(findings, newIntegrityFinding(drawingID, IntegrityIssueMissingEntityIndex, "error", drawing.GetCurrentRevisionId(), drawing.GetCurrentRevisionId(), len(missing), 0, map[string]any{"entity_ids": missing, "message": "current head snapshot entities are missing from drawing_entities index"}))
	}
	return findings, nil
}

func (r *PgRepository) loadLatestRevision(ctx context.Context, drawingID string) (*drawingv1.DrawingRevision, int, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, drawing_id, parent_revision_id, author, summary, command_id,
		       entity_count, snapshot_json::text, contract_json::text, committed_at,
		       (SELECT COUNT(*) FROM drawing_revisions WHERE drawing_id = $1)
		  FROM drawing_revisions
		 WHERE drawing_id = $1
		 ORDER BY committed_at DESC, id DESC
		 LIMIT 1
	`, drawingID)
	var revisionID string
	var currentDrawingID string
	var parentRevisionID *string
	var author string
	var summary string
	var commandID string
	var entityCount int
	var snapshotJSON string
	var contractJSON string
	var committedAt time.Time
	var revisionCount int
	if err := row.Scan(&revisionID, &currentDrawingID, &parentRevisionID, &author, &summary, &commandID, &entityCount, &snapshotJSON, &contractJSON, &committedAt, &revisionCount); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, 0, ErrNotFound
		}
		return nil, 0, fmt.Errorf("load latest revision: %w", err)
	}
	entities, err := unmarshalEntities(snapshotJSON)
	if err != nil {
		return nil, 0, err
	}
	contract, err := unmarshalContract(contractJSON)
	if err != nil {
		return nil, 0, err
	}
	return &drawingv1.DrawingRevision{
		Pointer:   &drawingv1.RevisionPointer{RevisionId: revisionID, ParentRevisionId: derefString(parentRevisionID), Author: author, Summary: summary, CommittedAt: timestamppb.New(committedAt), Contract: contract},
		DrawingId: currentDrawingID,
		CommandId: commandID,
		Entities:  entities,
	}, revisionCount, nil
}

func (r *PgRepository) loadCurrentRevision(ctx context.Context, drawingID string, revisionID string) (*drawingv1.DrawingRevision, error) {
	if strings.TrimSpace(revisionID) == "" {
		return nil, ErrNotFound
	}
	row := r.pool.QueryRow(ctx, `
		SELECT id, drawing_id, parent_revision_id, author, summary, command_id,
		       entity_count, snapshot_json::text, contract_json::text, committed_at
		  FROM drawing_revisions
		 WHERE drawing_id = $1 AND id = $2
	`, drawingID, revisionID)
	return scanRevision(row)
}

func (r *PgRepository) loadIndexedEntities(ctx context.Context, drawingID string) (map[string]string, error) {
	rows, err := r.pool.Query(ctx, `SELECT entity_id, revision_id FROM drawing_entities WHERE drawing_id = $1`, drawingID)
	if err != nil {
		return nil, fmt.Errorf("load indexed entities: %w", err)
	}
	defer rows.Close()
	result := make(map[string]string)
	for rows.Next() {
		var entityID string
		var revisionID string
		if err := rows.Scan(&entityID, &revisionID); err != nil {
			return nil, fmt.Errorf("scan indexed entity: %w", err)
		}
		result[entityID] = revisionID
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate indexed entities: %w", err)
	}
	return result, nil
}

func newIntegrityFinding(drawingID string, issueCode string, severity string, currentRevisionID string, expectedRevisionID string, expectedCount int, actualCount int, details map[string]any) IntegrityFinding {
	encodedDetails, _ := json.Marshal(details)
	issueKey := fmt.Sprintf("%s|%s|%s|%s|%d|%d", drawingID, issueCode, currentRevisionID, expectedRevisionID, expectedCount, actualCount)
	return IntegrityFinding{DrawingID: drawingID, IssueKey: issueKey, IssueCode: issueCode, Severity: severity, CurrentRevisionID: currentRevisionID, ExpectedRevisionID: expectedRevisionID, ExpectedCount: expectedCount, ActualCount: actualCount, DetailsJSON: string(encodedDetails)}
}

func (r *PgRepository) upsertIntegrityFinding(ctx context.Context, runID string, finding IntegrityFinding, auditedAt time.Time) error {
	_, err := r.pool.Exec(ctx, `
		INSERT INTO drawing_integrity_findings (
			id, audit_run_id, drawing_id, issue_key, issue_code, severity,
			current_revision_id, expected_revision_id, expected_count, actual_count,
			details_json, status, first_detected_at, last_detected_at
		) VALUES ($1,NULLIF($2, '')::uuid,$3,$4,$5,$6,NULLIF($7, '')::uuid,NULLIF($8, '')::uuid,$9,$10,$11::jsonb,'open',$12,$12)
		ON CONFLICT (issue_key) WHERE status = 'open'
		DO UPDATE SET audit_run_id = NULLIF($2, '')::uuid,
		              severity = EXCLUDED.severity,
		              details_json = EXCLUDED.details_json,
		              actual_count = EXCLUDED.actual_count,
		              expected_count = EXCLUDED.expected_count,
		              last_detected_at = EXCLUDED.last_detected_at
	`, uuid.NewString(), runID, finding.DrawingID, finding.IssueKey, finding.IssueCode, finding.Severity, strings.TrimSpace(finding.CurrentRevisionID), strings.TrimSpace(finding.ExpectedRevisionID), finding.ExpectedCount, finding.ActualCount, jsonOrDefault(finding.DetailsJSON, "{}"), auditedAt)
	if err != nil {
		return fmt.Errorf("upsert integrity finding: %w", err)
	}
	return nil
}

func (r *PgRepository) syncIntegrityFindings(ctx context.Context, runID string, drawingID string, findings []IntegrityFinding, auditedAt time.Time) error {
	activeKeys := make([]string, 0, len(findings))
	for _, finding := range findings {
		if err := r.upsertIntegrityFinding(ctx, runID, finding, auditedAt); err != nil {
			return err
		}
		activeKeys = append(activeKeys, finding.IssueKey)
	}
	if err := r.resolveInactiveIntegrityFindings(ctx, drawingID, activeKeys, auditedAt); err != nil {
		return err
	}
	return nil
}

func (r *PgRepository) resolveInactiveIntegrityFindings(ctx context.Context, drawingID string, activeKeys []string, resolvedAt time.Time) error {
	if len(activeKeys) == 0 {
		_, err := r.resolveOpenIntegrityFindings(ctx, drawingID, resolvedAt)
		return err
	}
	_, err := r.pool.Exec(ctx, `
		UPDATE drawing_integrity_findings
		   SET status = 'resolved',
		       resolved_at = $3,
		       last_detected_at = $3
		 WHERE drawing_id = $1
		   AND status = 'open'
		   AND NOT (issue_key = ANY($2))
	`, drawingID, activeKeys, resolvedAt)
	if err != nil {
		return fmt.Errorf("resolve inactive integrity findings: %w", err)
	}
	return nil
}

func (r *PgRepository) resolveOpenIntegrityFindings(ctx context.Context, drawingID string, resolvedAt time.Time) (int, error) {
	tag, err := r.pool.Exec(ctx, `
		UPDATE drawing_integrity_findings
		   SET status = 'resolved',
		       resolved_at = $2,
		       last_detected_at = $2
		 WHERE drawing_id = $1 AND status = 'open'
	`, drawingID, resolvedAt)
	if err != nil {
		return 0, fmt.Errorf("resolve integrity findings: %w", err)
	}
	return int(tag.RowsAffected()), nil
}

func (r *PgRepository) insertIntegrityAuditRun(ctx context.Context, startedAt time.Time) (string, error) {
	runID := uuid.NewString()
	_, err := r.pool.Exec(ctx, `
		INSERT INTO drawing_integrity_audit_runs (
			id, checked_drawings, findings_count, repaired_count, status, error_message, started_at
		) VALUES ($1,0,0,0,'running','',$2)
	`, runID, startedAt)
	if err != nil {
		return "", fmt.Errorf("insert integrity audit run: %w", err)
	}
	return runID, nil
}

func (r *PgRepository) finishIntegrityAuditRun(ctx context.Context, runID string, checkedDrawings int, findingsCount int, repairedCount int, status string, errorMessage string, finishedAt time.Time) error {
	_, err := r.pool.Exec(ctx, `
		UPDATE drawing_integrity_audit_runs
		   SET checked_drawings = $2,
		       findings_count = $3,
		       repaired_count = $4,
		       status = $5,
		       error_message = $6,
		       finished_at = $7
		 WHERE id = $1
	`, runID, checkedDrawings, findingsCount, repairedCount, status, errorMessage, finishedAt)
	if err != nil {
		return fmt.Errorf("finish integrity audit run: %w", err)
	}
	return nil
}

func (r *PgRepository) loadRepairState(ctx context.Context, tx pgx.Tx, drawingID string, repairHead bool) (*drawingv1.Drawing, *drawingv1.DrawingRevision, int, error) {
	row := tx.QueryRow(ctx, `
		SELECT id, project_id, name, description, metadata_json::text, status,
		       current_revision_id, revision_count, entity_count, contract_json::text,
		       created_at, updated_at
		  FROM drawings
		 WHERE id = $1
		 FOR UPDATE
	`, drawingID)
	drawing, err := scanDrawing(row)
	if err != nil {
		return nil, nil, 0, err
	}
	latestRevision, revisionCount, err := r.loadLatestRevision(ctx, drawingID)
	if err != nil {
		return nil, nil, 0, err
	}
	if !repairHead {
		currentRevision, loadErr := r.loadCurrentRevision(ctx, drawingID, drawing.GetCurrentRevisionId())
		if loadErr == nil {
			return drawing, currentRevision, revisionCount, nil
		}
		if !errors.Is(loadErr, ErrNotFound) {
			return nil, nil, 0, loadErr
		}
	}
	return drawing, latestRevision, revisionCount, nil
}

func rebuildEntityIndexTx(ctx context.Context, tx pgx.Tx, drawingID string, revisionID string, entities []*drawingv1.DrawingEntity, updatedAt time.Time) error {
	if _, err := tx.Exec(ctx, `DELETE FROM drawing_entities WHERE drawing_id = $1`, drawingID); err != nil {
		return fmt.Errorf("clear entity index: %w", err)
	}
	for _, entity := range entities {
		entityJSON, marshalErr := protojson.Marshal(entity)
		if marshalErr != nil {
			return fmt.Errorf("marshal entity %s: %w", entity.GetHeader().GetEntityId(), marshalErr)
		}
		if _, err := tx.Exec(ctx, `
			INSERT INTO drawing_entities (
				id, drawing_id, entity_id, entity_type,
				layer_id, layer_name, style_id,
				revision_id, body_json, metadata_json, updated_at
			) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9::jsonb,$10::jsonb,$11)
		`, uuid.NewString(), drawingID, entity.GetHeader().GetEntityId(), entity.GetHeader().GetEntityType().String(), entity.GetHeader().GetLayer().GetLayerId(), entity.GetHeader().GetLayer().GetLayerName(), entity.GetHeader().GetStyle().GetStyleId(), revisionID, string(entityJSON), jsonOrDefault(entity.GetHeader().GetMetadataJson(), "{}"), updatedAt); err != nil {
			return fmt.Errorf("insert rebuilt entity index %s: %w", entity.GetHeader().GetEntityId(), err)
		}
	}
	return nil
}

