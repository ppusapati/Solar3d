-- name: CreateReport :one
INSERT INTO reports (id, project_id, name, report_type, format, file_path, status, created_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetReportByID :one
SELECT * FROM reports WHERE id = $1;

-- name: ListReportsByProject :many
SELECT * FROM reports WHERE project_id = $1 ORDER BY created_at DESC;

-- name: UpdateReportStatus :exec
UPDATE reports SET status = $2, file_path = $3, completed_at = NOW() WHERE id = $1;

-- name: DeleteReport :exec
DELETE FROM reports WHERE id = $1;
