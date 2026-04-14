package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/drawing-revision-service/internal/repository"
)

type commandOutput struct {
	Mode      string                            `json:"mode"`
	DrawingID string                            `json:"drawing_id,omitempty"`
	Audit     *repository.IntegrityAuditReport  `json:"audit,omitempty"`
	Findings  []repository.IntegrityFinding     `json:"findings,omitempty"`
	Repair    *repository.IntegrityRepairResult `json:"repair,omitempty"`
}

func main() {
	mode := flag.String("mode", "audit", "audit | verify | repair-index | repair-head")
	drawingID := flag.String("drawing-id", "", "target drawing ID for verify and repair operations")
	batchSize := flag.Int("batch-size", 250, "number of drawings to scan during audit mode")
	timeout := flag.Duration("timeout", 60*time.Second, "operation timeout")
	flag.Parse()

	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		fail("DATABASE_URL environment variable is required")
	}
	if *timeout <= 0 {
		fail("timeout must be greater than zero")
	}

	ctx, cancel := context.WithTimeout(context.Background(), *timeout)
	defer cancel()

	pool, err := pgxpool.New(ctx, databaseURL)
	if err != nil {
		failf("create connection pool: %v", err)
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		failf("ping database: %v", err)
	}

	repo := repository.NewPgRepository(pool)
	now := time.Now().UTC()
	output := commandOutput{Mode: *mode, DrawingID: *drawingID}

	switch *mode {
	case "audit":
		report, err := repo.RunIntegrityAudit(ctx, *batchSize, now)
		if err != nil {
			failf("run audit: %v", err)
		}
		output.Audit = report
	case "verify":
		requireDrawingID(*drawingID)
		findings, err := repo.VerifyDrawingIntegrity(ctx, *drawingID)
		if err != nil {
			failf("verify drawing integrity: %v", err)
		}
		output.Findings = findings
	case "repair-index":
		requireDrawingID(*drawingID)
		result, err := repo.RepairDrawingEntityIndex(ctx, *drawingID, now)
		if err != nil {
			failf("repair drawing entity index: %v", err)
		}
		output.Repair = result
	case "repair-head":
		requireDrawingID(*drawingID)
		result, err := repo.RepairDrawingHead(ctx, *drawingID, now)
		if err != nil {
			failf("repair drawing head: %v", err)
		}
		output.Repair = result
	default:
		fail("invalid mode; expected audit, verify, repair-index, or repair-head")
	}

	encoder := json.NewEncoder(os.Stdout)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(output); err != nil {
		failf("encode output: %v", err)
	}
}

func requireDrawingID(drawingID string) {
	if drawingID == "" {
		fail("drawing-id is required for verify and repair modes")
	}
}

func fail(message string) {
	_, _ = fmt.Fprintln(os.Stderr, message)
	os.Exit(1)
}

func failf(format string, args ...any) {
	fail(fmt.Sprintf(format, args...))
}

