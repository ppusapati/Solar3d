-- name: CreateAsset :one
INSERT INTO assets (id, name, manufacturer, model, category, dimensions, electrical_params, model_3d_path, datasheet_path, metadata)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
RETURNING *;

-- name: GetAssetByID :one
SELECT * FROM assets WHERE id = $1;

-- name: ListAssets :many
SELECT * FROM assets ORDER BY category, name;

-- name: ListAssetsByCategory :many
SELECT * FROM assets WHERE category = $1 ORDER BY name;

-- name: SearchAssets :many
SELECT * FROM assets
WHERE ($1::asset_category IS NULL OR category = $1)
  AND ($2::text IS NULL OR manufacturer ILIKE '%' || $2 || '%')
  AND ($3::text IS NULL OR name ILIKE '%' || $3 || '%' OR model ILIKE '%' || $3 || '%')
ORDER BY category, name;

-- name: UpdateAsset :exec
UPDATE assets
SET name = $2, manufacturer = $3, model = $4, category = $5,
    dimensions = $6, electrical_params = $7, model_3d_path = $8,
    datasheet_path = $9, metadata = $10
WHERE id = $1;

-- name: DeleteAsset :exec
DELETE FROM assets WHERE id = $1;
