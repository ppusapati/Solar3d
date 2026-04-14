ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS approval_status TEXT NOT NULL DEFAULT 'draft';

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS engineering_reviewed_at TIMESTAMPTZ;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS engineering_reviewed_by TEXT NOT NULL DEFAULT '';

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS approved_by TEXT NOT NULL DEFAULT '';

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS governance_events JSONB NOT NULL DEFAULT '[]'::jsonb;