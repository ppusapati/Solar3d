-- 024_data_retention.sql
-- GDPR / CCPA: data subject request tracking and soft-delete infrastructure.
--
-- Design:
--   * `data_subject_requests` records the request (access, erasure, portability,
--     rectification) and its processing state. Records are kept for 2 years
--     as proof of compliance even after the underlying user is erased.
--   * `retention_policies` centralises how long each entity type is kept after
--     it becomes dormant / deleted. Policies are data-driven so legal can
--     adjust without code changes.
--   * Soft-delete columns added where hard delete would violate accounting /
--     audit requirements (projects, financial records).

BEGIN;

CREATE TYPE data_subject_request_kind AS ENUM (
  'access',       -- GDPR art. 15 / CCPA right to know
  'erasure',      -- GDPR art. 17 / CCPA right to delete
  'rectification',-- GDPR art. 16
  'portability',  -- GDPR art. 20
  'objection'     -- GDPR art. 21
);

CREATE TYPE data_subject_request_status AS ENUM (
  'received',
  'verifying_identity',
  'in_progress',
  'awaiting_dpo_review',
  'completed',
  'rejected',
  'partially_completed'
);

CREATE TABLE data_subject_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL,
  subject_email TEXT NOT NULL,
  subject_user_id UUID,
  kind data_subject_request_kind NOT NULL,
  status data_subject_request_status NOT NULL DEFAULT 'received',
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verified_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  due_by TIMESTAMPTZ NOT NULL, -- 30 days from received_at under GDPR; 45 under CCPA
  requester_ip INET,
  notes TEXT,
  processor_id UUID, -- staff member who handled it
  export_artifact_uri TEXT, -- for access/portability: s3://... signed URL base
  rejection_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dsr_tenant_status ON data_subject_requests(tenant_id, status);
CREATE INDEX idx_dsr_due_by ON data_subject_requests(due_by) WHERE status NOT IN ('completed', 'rejected');
CREATE INDEX idx_dsr_subject_email ON data_subject_requests(lower(subject_email));

CREATE TABLE retention_policies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_kind TEXT NOT NULL UNIQUE, -- 'project', 'audit_log', 'session', 'upload_temp', ...
  keep_active_for INTERVAL,         -- time-since-last-touch before dormancy
  keep_after_delete INTERVAL NOT NULL, -- time kept in soft-deleted state before hard delete
  legal_hold BOOLEAN NOT NULL DEFAULT FALSE,
  rationale TEXT NOT NULL,
  updated_by UUID,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Defaults. Legal may adjust via admin console.
INSERT INTO retention_policies (entity_kind, keep_active_for, keep_after_delete, rationale) VALUES
  ('session',        INTERVAL '30 days',  INTERVAL '0',       'Sessions are ephemeral; purge immediately on logout'),
  ('upload_temp',    INTERVAL '24 hours', INTERVAL '0',       'Temp-upload objects in quarantine bucket'),
  ('audit_log',      NULL,                INTERVAL '7 years', 'Financial + security audit retention (SOX / contract-driven)'),
  ('project',        NULL,                INTERVAL '7 years', 'EPC contracts require long-tail retention for warranty/defect claims'),
  ('layout',         NULL,                INTERVAL '7 years', 'Linked to project retention'),
  ('report',         NULL,                INTERVAL '7 years', 'Same as project'),
  ('user_account',   NULL,                INTERVAL '30 days', 'Account deletion grace period before hard erase')
ON CONFLICT (entity_kind) DO NOTHING;

-- Soft delete columns — add to entities that need grace-period / legal-hold support.
ALTER TABLE projects ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;
ALTER TABLE projects ADD COLUMN IF NOT EXISTS delete_reason TEXT;
ALTER TABLE layouts  ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_projects_deleted_at ON projects(deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_layouts_deleted_at ON layouts(deleted_at) WHERE deleted_at IS NOT NULL;

COMMIT;
