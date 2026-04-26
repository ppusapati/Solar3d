-- 017_siting_analysis_conflicts_link.sql
-- Adds an analysis→conflicts join so a SitingAnalysis can be replayed in full.
-- Migration 016 created `siting_conflicts` and `siting_analyses` independently;
-- without a link table the API contract (`GetConflictsForAnalysis`) cannot be
-- served correctly. This migration is additive — existing rows continue to
-- work and new analyses populate the link table.

BEGIN;

CREATE TABLE IF NOT EXISTS siting_analysis_conflicts (
    analysis_id UUID NOT NULL REFERENCES siting_analyses(analysis_id) ON DELETE CASCADE,
    conflict_id UUID NOT NULL REFERENCES siting_conflicts(conflict_id) ON DELETE CASCADE,
    sequence INT NOT NULL DEFAULT 0,
    PRIMARY KEY (analysis_id, conflict_id)
);

CREATE INDEX IF NOT EXISTS idx_siting_analysis_conflicts_analysis
    ON siting_analysis_conflicts(analysis_id, sequence);

COMMIT;
