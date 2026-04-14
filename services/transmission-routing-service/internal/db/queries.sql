-- name: CreateTransmissionRoute :one
INSERT INTO transmission_routes (
    id,
    project_id,
    name,
    voltage_class,
    farm_output_geojson,
    grid_injection_geojson,
    path_geojson,
    tower_positions,
    distance_m,
    conductor_cost,
    tower_cost,
    row_acquisition_cost,
    crossing_premium,
    total_cost,
    cost_per_km,
    segment_explanations,
    route_score,
    approval_status,
    engineering_reviewed_at,
    engineering_reviewed_by,
    approved_at,
    approved_by,
    governance_events,
    metadata,
    route_summary
) VALUES (
    @id,
    @project_id,
    @name,
    @voltage_class,
    @farm_output_geojson,
    @grid_injection_geojson,
    @path_geojson,
    @tower_positions::jsonb,
    @distance_m,
    @conductor_cost,
    @tower_cost,
    @row_acquisition_cost,
    @crossing_premium,
    @total_cost,
    @cost_per_km,
    @segment_explanations::jsonb,
    @route_score::jsonb,
    @approval_status,
    @engineering_reviewed_at,
    @engineering_reviewed_by,
    @approved_at,
    @approved_by,
    @governance_events::jsonb,
    @metadata::jsonb,
    @route_summary
)
RETURNING id::text, project_id, name, voltage_class,
    farm_output_geojson, grid_injection_geojson, path_geojson,
    tower_positions::text AS tower_positions_json,
    distance_m, conductor_cost, tower_cost, row_acquisition_cost,
    crossing_premium, total_cost, cost_per_km,
    segment_explanations::text AS segment_explanations_json,
    route_score::text AS route_score_json,
    approval_status, engineering_reviewed_at, engineering_reviewed_by,
    approved_at, approved_by,
    governance_events::text AS governance_events_json,
    metadata::text AS metadata_json,
    route_summary, created_at;

-- name: GetTransmissionRoute :one
SELECT id::text, project_id, name, voltage_class,
    farm_output_geojson, grid_injection_geojson, path_geojson,
    tower_positions::text AS tower_positions_json,
    distance_m, conductor_cost, tower_cost, row_acquisition_cost,
    crossing_premium, total_cost, cost_per_km,
    segment_explanations::text AS segment_explanations_json,
    route_score::text AS route_score_json,
    approval_status, engineering_reviewed_at, engineering_reviewed_by,
    approved_at, approved_by,
    governance_events::text AS governance_events_json,
    metadata::text AS metadata_json,
    route_summary, created_at
FROM transmission_routes
WHERE id = @id;

-- name: ListTransmissionRoutes :many
SELECT id::text, project_id, name, voltage_class,
    farm_output_geojson, grid_injection_geojson, path_geojson,
    tower_positions::text AS tower_positions_json,
    distance_m, conductor_cost, tower_cost, row_acquisition_cost,
    crossing_premium, total_cost, cost_per_km,
    segment_explanations::text AS segment_explanations_json,
    route_score::text AS route_score_json,
    approval_status, engineering_reviewed_at, engineering_reviewed_by,
    approved_at, approved_by,
    governance_events::text AS governance_events_json,
    metadata::text AS metadata_json,
    route_summary, created_at
FROM transmission_routes
WHERE project_id = @project_id
ORDER BY created_at DESC;

-- name: SubmitTransmissionRouteForReview :one
UPDATE transmission_routes
SET approval_status = 'engineering_review',
    engineering_reviewed_at = @engineering_reviewed_at,
    engineering_reviewed_by = @engineering_reviewed_by,
    governance_events = @governance_events::jsonb,
    metadata = @metadata::jsonb,
    route_summary = @route_summary
WHERE id = @id
RETURNING id::text, project_id, name, voltage_class,
    farm_output_geojson, grid_injection_geojson, path_geojson,
    tower_positions::text AS tower_positions_json,
    distance_m, conductor_cost, tower_cost, row_acquisition_cost,
    crossing_premium, total_cost, cost_per_km,
    segment_explanations::text AS segment_explanations_json,
    route_score::text AS route_score_json,
    approval_status, engineering_reviewed_at, engineering_reviewed_by,
    approved_at, approved_by,
    governance_events::text AS governance_events_json,
    metadata::text AS metadata_json,
    route_summary, created_at;

-- name: ApproveTransmissionRoute :one
UPDATE transmission_routes
SET approval_status = 'approved',
    approved_at = @approved_at,
    approved_by = @approved_by,
    governance_events = @governance_events::jsonb,
    metadata = @metadata::jsonb,
    route_summary = @route_summary
WHERE id = @id
RETURNING id::text, project_id, name, voltage_class,
    farm_output_geojson, grid_injection_geojson, path_geojson,
    tower_positions::text AS tower_positions_json,
    distance_m, conductor_cost, tower_cost, row_acquisition_cost,
    crossing_premium, total_cost, cost_per_km,
    segment_explanations::text AS segment_explanations_json,
    route_score::text AS route_score_json,
    approval_status, engineering_reviewed_at, engineering_reviewed_by,
    approved_at, approved_by,
    governance_events::text AS governance_events_json,
    metadata::text AS metadata_json,
    route_summary, created_at;

-- name: DeleteTransmissionRoute :exec
DELETE FROM transmission_routes
WHERE id = @id;