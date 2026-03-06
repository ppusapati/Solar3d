-- name: CreateNetwork :one
INSERT INTO electrical_networks (id, project_id, layout_id, name, total_dc_capacity_kw, total_ac_capacity_kw, dc_ac_ratio, string_count, inverter_count)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
RETURNING *;

-- name: GetNetworkByID :one
SELECT * FROM electrical_networks WHERE id = $1;

-- name: ListNetworksByProject :many
SELECT * FROM electrical_networks WHERE project_id = $1 ORDER BY name;

-- name: UpdateNetwork :exec
UPDATE electrical_networks
SET name = $2, total_dc_capacity_kw = $3, total_ac_capacity_kw = $4, dc_ac_ratio = $5, string_count = $6, inverter_count = $7
WHERE id = $1;

-- name: DeleteNetwork :exec
DELETE FROM electrical_networks WHERE id = $1;

-- name: CreateString :one
INSERT INTO panel_strings (id, network_id, inverter_group_id, panel_ids, panel_count, voltage, current, power_w)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: ListStringsByNetwork :many
SELECT * FROM panel_strings WHERE network_id = $1 ORDER BY id;

-- name: CreateInverterGroup :one
INSERT INTO inverter_groups (id, network_id, inverter_asset_id, string_ids, dc_input_kw, ac_output_kw, dc_ac_ratio, position)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: ListInverterGroupsByNetwork :many
SELECT * FROM inverter_groups WHERE network_id = $1 ORDER BY id;
