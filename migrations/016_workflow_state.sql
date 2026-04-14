-- 016_workflow_state.sql
-- Adds planning workflow phase state to the projects table.
-- Required by Step 14: project service phase state machine.
--
-- Rollback strategy:
--   ALTER TABLE projects DROP COLUMN IF EXISTS workflow_current_phase;
--   ALTER TABLE projects DROP COLUMN IF EXISTS workflow_phase_entered_at;
--   ALTER TABLE projects DROP COLUMN IF EXISTS workflow_state_json;
--   ALTER TABLE projects DROP COLUMN IF EXISTS phase_transition_history;
--
-- Lock safety: ADD COLUMN ... DEFAULT is safe in PostgreSQL 11+ without table rewrite.
-- All columns are nullable or carry defaults so no backfill lock is needed.

-- Current workflow phase as a text enum matching planning.WorkflowPhase constants.
-- Defaults to PLANNING (the initial state for every new project).
ALTER TABLE projects
    ADD COLUMN IF NOT EXISTS workflow_current_phase TEXT NOT NULL DEFAULT 'PLANNING';

-- Timestamp when the project entered its current phase.
ALTER TABLE projects
    ADD COLUMN IF NOT EXISTS workflow_phase_entered_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Snapshot of the full WorkflowState struct serialised as JSONB (blockers, last_actor, etc.).
-- This is a denormalised cache; source of truth is phase_transition_history.
ALTER TABLE projects
    ADD COLUMN IF NOT EXISTS workflow_state_json JSONB NOT NULL DEFAULT '{}'::jsonb;

-- Append-only ordered log of all phase transitions. Each element:
-- { from_phase, to_phase, actor_id, reason, is_rollback, occurred_at }
-- Never mutated after insertion; used as the immutable audit trail.
ALTER TABLE projects
    ADD COLUMN IF NOT EXISTS phase_transition_history JSONB NOT NULL DEFAULT '[]'::jsonb;

-- Index to support queries like "show all projects in phase X".
CREATE INDEX IF NOT EXISTS idx_projects_workflow_current_phase
    ON projects (workflow_current_phase);
