-- name: CreateRoute :one
INSERT INTO routes (id, project_id, route_type, name, geometry_geojson, distance_m, cost_estimate, metadata)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetRouteByID :one
SELECT * FROM routes WHERE id = $1;

-- name: ListRoutesByProject :many
SELECT * FROM routes WHERE project_id = $1 ORDER BY name;

-- name: ListRoutesByType :many
SELECT * FROM routes WHERE project_id = $1 AND route_type = $2 ORDER BY name;

-- name: DeleteRoute :exec
DELETE FROM routes WHERE id = $1;
