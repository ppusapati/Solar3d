-- name: CreateSimulation :one
INSERT INTO simulations (id, project_id, layout_id, name, simulation_type, status, params, created_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetSimulationByID :one
SELECT * FROM simulations WHERE id = $1;

-- name: ListSimulationsByProject :many
SELECT * FROM simulations WHERE project_id = $1 ORDER BY created_at DESC;

-- name: UpdateSimulationStatus :exec
UPDATE simulations SET status = $2 WHERE id = $1;

-- name: UpdateSimulationResult :exec
UPDATE simulations SET result = $2, status = 'completed', completed_at = NOW() WHERE id = $1;

-- name: DeleteSimulation :exec
DELETE FROM simulations WHERE id = $1;
