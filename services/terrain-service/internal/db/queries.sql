-- name: CreateTerrainLayer :one
INSERT INTO terrain_layers (
    id, project_id, name, layer_type, source_file,
    bounds, resolution_m, crs,
    min_elevation, max_elevation
) VALUES (
    @id, @project_id, @name, @layer_type, @source_file,
    ST_MakeEnvelope(@min_x, @min_y, @max_x, @max_y, 4326),
    @resolution_m, @crs,
    @min_elevation, @max_elevation
)
RETURNING id, project_id, name, layer_type, source_file,
    ST_XMin(bounds) AS min_x, ST_YMin(bounds) AS min_y,
    ST_XMax(bounds) AS max_x, ST_YMax(bounds) AS max_y,
    resolution_m, crs, min_elevation, max_elevation, created_at;

-- name: GetTerrainLayer :one
SELECT
    id, project_id, name, layer_type, source_file,
    ST_XMin(bounds) AS min_x, ST_YMin(bounds) AS min_y,
    ST_XMax(bounds) AS max_x, ST_YMax(bounds) AS max_y,
    resolution_m, crs, min_elevation, max_elevation, created_at
FROM terrain_layers
WHERE id = @id;

-- name: ListTerrainLayers :many
SELECT
    id, project_id, name, layer_type, source_file,
    ST_XMin(bounds) AS min_x, ST_YMin(bounds) AS min_y,
    ST_XMax(bounds) AS max_x, ST_YMax(bounds) AS max_y,
    resolution_m, crs, min_elevation, max_elevation, created_at
FROM terrain_layers
WHERE project_id = @project_id
ORDER BY created_at DESC;

-- name: DeleteTerrainLayer :exec
DELETE FROM terrain_layers
WHERE id = @id;
