CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE report_status AS ENUM ('pending', 'running', 'completed', 'failed');
CREATE TYPE report_type AS ENUM ('bom', 'layout', 'electrical', 'simulation', 'full');
CREATE TYPE report_format AS ENUM ('json', 'csv', 'pdf');

CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    report_type report_type NOT NULL,
    format report_format NOT NULL DEFAULT 'json',
    file_path VARCHAR(1024) NOT NULL DEFAULT '',
    status report_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX idx_reports_project_id ON reports(project_id);
CREATE INDEX idx_reports_status ON reports(status);
