-- 017_review_metadata.sql
-- Adds acceptance workflow (review_metadata) columns to layouts,
-- electrical_networks, and transmission_routes tables.
-- Required by Step 15: acceptance status contracts.
--
-- Rollback strategy:
--   ALTER TABLE layouts DROP COLUMN IF EXISTS review_metadata;
--   ALTER TABLE layouts DROP COLUMN IF EXISTS candidate_id;
--   ALTER TABLE electrical_networks DROP COLUMN IF EXISTS review_metadata;
--   ALTER TABLE electrical_networks DROP COLUMN IF EXISTS validation_violations;
--   ALTER TABLE electrical_networks DROP COLUMN IF EXISTS electrical_feasibility_score;
--   ALTER TABLE transmission_routes DROP COLUMN IF EXISTS review_metadata;
--   ALTER TABLE transmission_routes DROP COLUMN IF EXISTS electrical_network_id;
--   ALTER TABLE transmission_routes DROP COLUMN IF EXISTS protection_devices;
--   ALTER TABLE transmission_routes DROP COLUMN IF EXISTS fault_isolation_points;
--   ALTER TABLE transmission_routes DROP COLUMN IF EXISTS route_conflicts;
--   ALTER TABLE transmission_routes DROP COLUMN IF EXISTS route_feasibility_score;
--
-- Lock safety: ADD COLUMN ... DEFAULT avoids table rewrite on PostgreSQL 11+.

-- ============================================================
-- layouts
-- ============================================================

-- review_metadata holds the AcceptanceStatus, reviewer, quality_score, and blockers.
-- Serialised from domain.ReviewMetadata; status defaults to DRAFT.
ALTER TABLE layouts
    ADD COLUMN IF NOT EXISTS review_metadata JSONB NOT NULL DEFAULT '{"status":"DRAFT"}'::jsonb;

-- candidate_id links a layout to an MLCandidate from the algorithm phase (optional).
ALTER TABLE layouts
    ADD COLUMN IF NOT EXISTS candidate_id UUID;

-- Index to find layouts awaiting or completed review.
CREATE INDEX IF NOT EXISTS idx_layouts_review_status
    ON layouts ((review_metadata->>'status'));

-- ============================================================
-- electrical_networks
-- ============================================================

-- review_metadata holds the AcceptanceStatus for the electrical network gate.
ALTER TABLE electrical_networks
    ADD COLUMN IF NOT EXISTS review_metadata JSONB NOT NULL DEFAULT '{"status":"DRAFT"}'::jsonb;

-- validation_violations is the ordered list of violation messages from ValidateNetwork.
-- Empty array means no violations.
ALTER TABLE electrical_networks
    ADD COLUMN IF NOT EXISTS validation_violations JSONB NOT NULL DEFAULT '[]'::jsonb;

-- electrical_feasibility_score is a [0,1] overall feasibility score from the last validation.
-- NULL means no validation has been run yet.
ALTER TABLE electrical_networks
    ADD COLUMN IF NOT EXISTS electrical_feasibility_score DOUBLE PRECISION;

CREATE INDEX IF NOT EXISTS idx_electrical_networks_review_status
    ON electrical_networks ((review_metadata->>'status'));

-- ============================================================
-- transmission_routes
-- ============================================================

-- review_metadata holds the AcceptanceStatus for the transmission route gate.
ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS review_metadata JSONB NOT NULL DEFAULT '{"status":"DRAFT"}'::jsonb;

-- electrical_network_id links this route to its origin electrical network.
ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS electrical_network_id UUID;

-- protection_devices is an ordered list of device identifiers validated on this route (IEC 60255).
ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS protection_devices JSONB NOT NULL DEFAULT '[]'::jsonb;

-- fault_isolation_points is the count of validated fault isolation points.
ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS fault_isolation_points INTEGER NOT NULL DEFAULT 0;

-- route_conflicts lists unresolved spatial or electrical conflicts.
-- Empty array means route is conflict-free.
ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS route_conflicts JSONB NOT NULL DEFAULT '[]'::jsonb;

-- route_feasibility_score is [0,1] overall engineering feasibility from the last routing run.
-- NULL means no scoring has been completed yet.
ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS route_feasibility_score DOUBLE PRECISION;

CREATE INDEX IF NOT EXISTS idx_transmission_routes_review_status
    ON transmission_routes ((review_metadata->>'status'));

CREATE INDEX IF NOT EXISTS idx_transmission_routes_electrical_network_id
    ON transmission_routes (electrical_network_id)
    WHERE electrical_network_id IS NOT NULL;
