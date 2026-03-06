-- name: GetLayout :one
SELECT id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at
FROM layouts
WHERE id = $1;

-- name: ListLayoutsByProject :many
SELECT id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at
FROM layouts
WHERE project_id = $1
ORDER BY created_at DESC;

-- name: CreateLayout :one
INSERT INTO layouts (id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: UpdateLayout :exec
UPDATE layouts
SET name = $2, total_panels = $3, total_capacity_kw = $4, tile_count = $5, updated_at = $6
WHERE id = $1;

-- name: DeleteLayout :exec
DELETE FROM layouts WHERE id = $1;

-- name: GetComponent :one
SELECT id, layout_id, asset_id, component_type, position, rotation, metadata, created_at
FROM components
WHERE id = $1;

-- name: ListComponentsByLayout :many
SELECT id, layout_id, asset_id, component_type, position, rotation, metadata, created_at
FROM components
WHERE layout_id = $1
ORDER BY created_at;

-- name: CreateComponent :one
INSERT INTO components (id, layout_id, asset_id, component_type, position, rotation, metadata, created_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: DeleteComponent :exec
DELETE FROM components WHERE id = $1;

-- name: GetTilesByViewport :many
-- Spatial query using PostGIS GIST index on the generated geometry column.
-- ST_MakeEnvelope creates an envelope from the viewport bounds and the && operator
-- checks for bounding box intersection, which uses the GIST index.
SELECT id, layout_id, min_x, min_y, max_x, max_y, lod_level, panel_count, metadata, created_at
FROM layout_tiles
WHERE layout_id = $1
  AND geom && ST_MakeEnvelope($2, $3, $4, $5, 0)
ORDER BY min_x, min_y;

-- name: GetTilesByViewportAndLOD :many
SELECT id, layout_id, min_x, min_y, max_x, max_y, lod_level, panel_count, metadata, created_at
FROM layout_tiles
WHERE layout_id = $1
  AND geom && ST_MakeEnvelope($2, $3, $4, $5, 0)
  AND lod_level = $6
ORDER BY min_x, min_y;

-- name: GetPanelsByTile :many
SELECT id, tile_id, string_id, geometry_geojson, tilt, azimuth, elevation, metadata
FROM panels
WHERE tile_id = $1
ORDER BY string_id;

-- name: DeleteTilesByLayout :exec
DELETE FROM layout_tiles WHERE layout_id = $1;

-- name: GetLayoutPanelCount :one
SELECT layout_panel_count($1) AS count;
