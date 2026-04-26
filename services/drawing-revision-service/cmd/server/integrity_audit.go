package main

import (
	"context"
	"time"

	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/config"
	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/repository"
)

func startIntegrityAuditLoop(ctx context.Context, logger zerolog.Logger, cfg *config.Config, repo *repository.PgRepository) {
	if !cfg.IntegrityAuditEnabled {
		logger.Info().Msg("integrity audit loop disabled")
		return
	}

	go func() {
		if cfg.IntegrityAuditStartupDelay > 0 {
			timer := time.NewTimer(cfg.IntegrityAuditStartupDelay)
			defer timer.Stop()
			select {
			case <-ctx.Done():
				return
			case <-timer.C:
			}
		}

		runAudit := func() {
			report, err := repo.RunIntegrityAudit(ctx, cfg.IntegrityAuditBatchSize, time.Now().UTC())
			if err != nil {
				logger.Error().Err(err).Int("batch_size", cfg.IntegrityAuditBatchSize).Msg("integrity audit run failed")
				return
			}
			logger.Info().Str("audit_run_id", report.RunID).Int("checked_drawings", report.CheckedDrawings).Int("findings", len(report.Findings)).Msg("integrity audit run completed")
		}

		runAudit()
		ticker := time.NewTicker(cfg.IntegrityAuditInterval)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				runAudit()
			}
		}
	}()
}

