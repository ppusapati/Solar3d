-- name: CreateProject :one
INSERT INTO projects (
    id, name, description, status,
    target_capacity_mw, location_name, client_name, notes,
    created_at, updated_at
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
RETURNING *;

-- name: GetProject :one
SELECT id, name, description, status,
       target_capacity_mw, location_name, client_name, notes,
       created_at, updated_at
  FROM projects
 WHERE id = $1;

-- name: ListProjects :many
SELECT id, name, description, status,
       target_capacity_mw, location_name, client_name, notes,
       created_at, updated_at
  FROM projects
 ORDER BY created_at DESC
 LIMIT $1 OFFSET $2;

-- name: UpdateProject :one
UPDATE projects
   SET name              = $2,
       description       = $3,
       status            = $4,
       target_capacity_mw = $5,
       location_name     = $6,
       client_name       = $7,
       notes             = $8,
       updated_at        = $9
 WHERE id = $1
RETURNING *;

-- name: DeleteProject :exec
DELETE FROM projects WHERE id = $1;

-- name: CreateSite :one
INSERT INTO sites (
    id, project_id, name, boundary,
    area_sqm, latitude, longitude, timezone, created_at
) VALUES (
    $1, $2, $3, ST_GeomFromGeoJSON($4),
    $5, $6, $7, $8, $9
)
RETURNING id, project_id, name,
          ST_AsGeoJSON(boundary) AS boundary_geojson,
          area_sqm, latitude, longitude, timezone, created_at;

-- name: GetSiteByProjectID :one
SELECT id, project_id, name,
       ST_AsGeoJSON(boundary) AS boundary_geojson,
       area_sqm, latitude, longitude, timezone, created_at
  FROM sites
 WHERE project_id = $1;
