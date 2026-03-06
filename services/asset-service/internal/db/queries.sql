-- name: CreateAsset :one
INSERT INTO assets (id, name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg,
    electrical_params, model_3d_path, datasheet_path, metadata, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
RETURNING *;

-- name: GetAsset :one
SELECT * FROM assets WHERE id = $1;

-- name: ListAssets :many
SELECT * FROM assets ORDER BY name LIMIT $1 OFFSET $2;

-- name: ListAssetsByCategory :many
SELECT * FROM assets WHERE category = $1 ORDER BY name LIMIT $2 OFFSET $3;

-- name: CountAssets :one
SELECT COUNT(*) FROM assets;

-- name: CountAssetsByCategory :one
SELECT COUNT(*) FROM assets WHERE category = $1;

-- name: UpdateAsset :exec
UPDATE assets SET name=$2, manufacturer=$3, model=$4, width_mm=$5, height_mm=$6,
    depth_mm=$7, weight_kg=$8, electrical_params=$9, model_3d_path=$10, metadata=$11, updated_at=$12
WHERE id = $1;

-- name: DeleteAsset :exec
DELETE FROM assets WHERE id = $1;
