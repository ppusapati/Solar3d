-- name: CreateJob :exec
INSERT INTO orchestration_jobs (
    id, project_id, job_type, status, priority, attempts, max_attempts,
    payload_json, error_message, created_at, started_at, completed_at, next_retry_at
) VALUES (
    $1::uuid, $2, $3, $4, $5, $6, $7,
    $8::jsonb, $9, $10, $11, $12, $13
);

-- name: UpdateJob :exec
UPDATE orchestration_jobs
SET project_id = $2,
    job_type = $3,
    status = $4,
    priority = $5,
    attempts = $6,
    max_attempts = $7,
    payload_json = $8::jsonb,
    error_message = $9,
    started_at = $10,
    completed_at = $11,
    next_retry_at = $12
WHERE id = $1::uuid;

-- name: GetJob :one
SELECT id::text, project_id, job_type, status, priority, attempts, max_attempts,
       payload_json::text, error_message, created_at, started_at, completed_at, next_retry_at
FROM orchestration_jobs
WHERE id = $1::uuid;

-- name: ListJobs :many
SELECT id::text, project_id, job_type, status, priority, attempts, max_attempts,
       payload_json::text, error_message, created_at, started_at, completed_at, next_retry_at
FROM orchestration_jobs
WHERE ($1::text = '' OR project_id = $1)
  AND ($2::text = '' OR status = $2)
ORDER BY priority DESC, created_at ASC
LIMIT $3;

-- name: MarkRetryPending :exec
UPDATE orchestration_jobs
SET status = $2,
    error_message = $3,
    next_retry_at = $4,
    completed_at = NULL
WHERE id = $1::uuid;

-- name: DeleteArtifactsByJobID :exec
DELETE FROM orchestration_job_artifacts WHERE job_id = $1::uuid;

-- name: InsertArtifact :exec
INSERT INTO orchestration_job_artifacts (job_id, kind, uri, checksum, size_bytes)
VALUES ($1::uuid, $2, $3, $4, $5);

-- name: GetArtifactsByJobID :many
SELECT kind, uri, checksum, size_bytes
FROM orchestration_job_artifacts
WHERE job_id = $1::uuid
ORDER BY id ASC;

-- name: UpsertAttempt :exec
INSERT INTO orchestration_job_attempts (
    job_id, attempt_no, status, started_at, finished_at, error_message
) VALUES ($1::uuid, $2, $3, $4, $5, $6)
ON CONFLICT (job_id, attempt_no)
DO UPDATE SET status = EXCLUDED.status,
              started_at = EXCLUDED.started_at,
              finished_at = EXCLUDED.finished_at,
              error_message = EXCLUDED.error_message;

-- name: InsertIdempotencyKey :exec
INSERT INTO orchestration_idempotency_keys (project_id, idempotency_key, job_id)
VALUES ($1, $2, $3::uuid)
ON CONFLICT (project_id, idempotency_key) DO NOTHING;

-- name: GetIdempotencyJobID :one
SELECT job_id::text
FROM orchestration_idempotency_keys
WHERE project_id = $1
    AND idempotency_key = $2;

-- name: InsertDeadLetter :exec
INSERT INTO orchestration_dead_letters (job_id, reason, payload_json)
VALUES ($1::uuid, $2, $3::jsonb);

-- name: ListDeadLetters :many
SELECT id::text, job_id::text, reason, payload_json::text, created_at
FROM orchestration_dead_letters
WHERE job_id::text IN (
    SELECT j.id::text
    FROM orchestration_jobs j
    WHERE j.project_id = $1
)
ORDER BY created_at DESC
LIMIT $2;

-- name: GetDeadLetter :one
SELECT id::text, job_id::text, reason, payload_json::text, created_at
FROM orchestration_dead_letters
WHERE job_id = $1::uuid;
