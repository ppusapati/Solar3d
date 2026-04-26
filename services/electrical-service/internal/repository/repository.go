package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/solar3d/electrical-service/internal/domain"
)

type ElectricalRepository struct {
	pool *pgxpool.Pool
}

func NewElectricalRepository(pool *pgxpool.Pool) *ElectricalRepository {
	return &ElectricalRepository{pool: pool}
}

func (r *ElectricalRepository) CreateNetwork(ctx context.Context, net *domain.ElectricalNetwork) error {
	query := `
		INSERT INTO electrical_networks (id, project_id, layout_id, name, total_dc_capacity_kw, total_ac_capacity_kw, dc_ac_ratio, string_count, inverter_count)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	_, err := r.pool.Exec(ctx, query,
		net.ID, net.ProjectID, net.LayoutID, net.Name,
		net.TotalDCCapacityKW, net.TotalACCapacityKW, net.DCACRatio,
		net.StringCount, net.InverterCount,
	)
	if err != nil {
		return fmt.Errorf("inserting network: %w", err)
	}
	return nil
}

func (r *ElectricalRepository) GetNetworkByID(ctx context.Context, id uuid.UUID) (*domain.ElectricalNetwork, error) {
	query := `
		SELECT id, project_id, layout_id, name, total_dc_capacity_kw, total_ac_capacity_kw, dc_ac_ratio, string_count, inverter_count
		FROM electrical_networks WHERE id = $1`

	var net domain.ElectricalNetwork
	err := r.pool.QueryRow(ctx, query, id).Scan(
		&net.ID, &net.ProjectID, &net.LayoutID, &net.Name,
		&net.TotalDCCapacityKW, &net.TotalACCapacityKW, &net.DCACRatio,
		&net.StringCount, &net.InverterCount,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("network not found: %s", id)
		}
		return nil, fmt.Errorf("querying network: %w", err)
	}
	return &net, nil
}

func (r *ElectricalRepository) ListNetworksByProject(ctx context.Context, projectID uuid.UUID) ([]domain.ElectricalNetwork, error) {
	query := `
		SELECT id, project_id, layout_id, name, total_dc_capacity_kw, total_ac_capacity_kw, dc_ac_ratio, string_count, inverter_count
		FROM electrical_networks WHERE project_id = $1 ORDER BY name`

	rows, err := r.pool.Query(ctx, query, projectID)
	if err != nil {
		return nil, fmt.Errorf("querying networks: %w", err)
	}
	defer rows.Close()

	var networks []domain.ElectricalNetwork
	for rows.Next() {
		var net domain.ElectricalNetwork
		if err := rows.Scan(
			&net.ID, &net.ProjectID, &net.LayoutID, &net.Name,
			&net.TotalDCCapacityKW, &net.TotalACCapacityKW, &net.DCACRatio,
			&net.StringCount, &net.InverterCount,
		); err != nil {
			return nil, fmt.Errorf("scanning network: %w", err)
		}
		networks = append(networks, net)
	}
	return networks, nil
}

func (r *ElectricalRepository) UpdateNetwork(ctx context.Context, net *domain.ElectricalNetwork) error {
	query := `
		UPDATE electrical_networks
		SET name = $2, total_dc_capacity_kw = $3, total_ac_capacity_kw = $4, dc_ac_ratio = $5, string_count = $6, inverter_count = $7
		WHERE id = $1`

	tag, err := r.pool.Exec(ctx, query,
		net.ID, net.Name, net.TotalDCCapacityKW, net.TotalACCapacityKW,
		net.DCACRatio, net.StringCount, net.InverterCount,
	)
	if err != nil {
		return fmt.Errorf("updating network: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("network not found: %s", net.ID)
	}
	return nil
}

func (r *ElectricalRepository) DeleteNetwork(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM electrical_networks WHERE id = $1`
	tag, err := r.pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("deleting network: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("network not found: %s", id)
	}
	return nil
}

// GetLayoutAcceptanceStatus queries the layouts table for the acceptance gate status.
// Returns the status string (e.g. "APPROVED", "DRAFT") or an error if the layout is not found.
// This cross-table query is intentional in the monolith: layouts and electrical_networks share
// the same database and the acceptance gate must be enforced before network creation.
func (r *ElectricalRepository) GetLayoutAcceptanceStatus(ctx context.Context, layoutID uuid.UUID) (string, error) {
	var status string
	err := r.pool.QueryRow(ctx,
		`SELECT COALESCE(review_metadata->>'status', 'DRAFT') FROM layouts WHERE id = $1`,
		layoutID,
	).Scan(&status)
	if err != nil {
		if err == pgx.ErrNoRows {
			return "", fmt.Errorf("layout not found: %s", layoutID)
		}
		return "", fmt.Errorf("query layout acceptance status: %w", err)
	}
	return status, nil
}

// UpdateNetworkReviewMetadata persists the acceptance workflow state for an electrical network.
func (r *ElectricalRepository) UpdateNetworkReviewMetadata(ctx context.Context, networkID uuid.UUID, metadataJSON []byte) error {
	tag, err := r.pool.Exec(ctx,
		`UPDATE electrical_networks SET review_metadata = $2 WHERE id = $1`,
		networkID, metadataJSON,
	)
	if err != nil {
		return fmt.Errorf("update network review_metadata: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("network not found: %s", networkID)
	}
	return nil
}

func (r *ElectricalRepository) CreateString(ctx context.Context, ps *domain.PanelString) error {
	panelIDsJSON, err := json.Marshal(ps.PanelIDs)
	if err != nil {
		return fmt.Errorf("marshaling panel IDs: %w", err)
	}

	var inverterGroupID any
	if ps.InverterGroupID != uuid.Nil {
		inverterGroupID = ps.InverterGroupID
	}

	query := `
		INSERT INTO panel_strings (id, network_id, inverter_group_id, panel_ids, panel_count, voltage, current, power_w)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err = r.pool.Exec(ctx, query,
		ps.ID, ps.NetworkID, inverterGroupID, panelIDsJSON,
		ps.PanelCount, ps.Voltage, ps.Current, ps.PowerW,
	)
	if err != nil {
		return fmt.Errorf("inserting string: %w", err)
	}
	return nil
}

func (r *ElectricalRepository) ListStringsByNetwork(ctx context.Context, networkID uuid.UUID) ([]domain.PanelString, error) {
	query := `
		SELECT id, network_id, inverter_group_id, panel_ids, panel_count, voltage, current, power_w
		FROM panel_strings WHERE network_id = $1 ORDER BY id`

	rows, err := r.pool.Query(ctx, query, networkID)
	if err != nil {
		return nil, fmt.Errorf("querying strings: %w", err)
	}
	defer rows.Close()

	var strings []domain.PanelString
	for rows.Next() {
		var ps domain.PanelString
		var inverterGroupID *uuid.UUID
		var panelIDsJSON []byte
		if err := rows.Scan(
			&ps.ID, &ps.NetworkID, &inverterGroupID, &panelIDsJSON,
			&ps.PanelCount, &ps.Voltage, &ps.Current, &ps.PowerW,
		); err != nil {
			return nil, fmt.Errorf("scanning string: %w", err)
		}
		if inverterGroupID != nil {
			ps.InverterGroupID = *inverterGroupID
		}
		if err := json.Unmarshal(panelIDsJSON, &ps.PanelIDs); err != nil {
			return nil, fmt.Errorf("unmarshaling panel IDs: %w", err)
		}
		strings = append(strings, ps)
	}
	return strings, nil
}

func (r *ElectricalRepository) ListStringsByIDs(ctx context.Context, networkID uuid.UUID, stringIDs []uuid.UUID) ([]domain.PanelString, error) {
	query := `
		SELECT id, network_id, inverter_group_id, panel_ids, panel_count, voltage, current, power_w
		FROM panel_strings
		WHERE network_id = $1 AND id = ANY($2)
		ORDER BY id`

	rows, err := r.pool.Query(ctx, query, networkID, stringIDs)
	if err != nil {
		return nil, fmt.Errorf("querying strings by id: %w", err)
	}
	defer rows.Close()

	var strings []domain.PanelString
	for rows.Next() {
		var ps domain.PanelString
		var inverterGroupID *uuid.UUID
		var panelIDsJSON []byte
		if err := rows.Scan(
			&ps.ID, &ps.NetworkID, &inverterGroupID, &panelIDsJSON,
			&ps.PanelCount, &ps.Voltage, &ps.Current, &ps.PowerW,
		); err != nil {
			return nil, fmt.Errorf("scanning string by id: %w", err)
		}
		if inverterGroupID != nil {
			ps.InverterGroupID = *inverterGroupID
		}
		if err := json.Unmarshal(panelIDsJSON, &ps.PanelIDs); err != nil {
			return nil, fmt.Errorf("unmarshaling panel IDs: %w", err)
		}
		strings = append(strings, ps)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterating string rows: %w", err)
	}
	return strings, nil
}

func (r *ElectricalRepository) CreateInverterGroup(ctx context.Context, ig *domain.InverterGroup) error {
	stringIDsJSON, err := json.Marshal(ig.StringIDs)
	if err != nil {
		return fmt.Errorf("marshaling string IDs: %w", err)
	}

	var positionGeoJSON any
	if ig.Position != [2]float64{} {
		positionGeoJSON = fmt.Sprintf(`{"type":"Point","coordinates":[%v,%v]}`, ig.Position[0], ig.Position[1])
	}

	query := `
		INSERT INTO inverter_groups (id, network_id, inverter_asset_id, string_ids, dc_input_kw, ac_output_kw, dc_ac_ratio, position)
		VALUES ($1, $2, $3, $4, $5, $6, $7, CASE WHEN $8::text = '' OR $8 IS NULL THEN NULL ELSE ST_SetSRID(ST_GeomFromGeoJSON($8::text), 4326) END)`

	_, err = r.pool.Exec(ctx, query,
		ig.ID, ig.NetworkID, ig.InverterAssetID, stringIDsJSON,
		ig.DCInputKW, ig.ACOutputKW, ig.DCACRatio, positionGeoJSON,
	)
	if err != nil {
		return fmt.Errorf("inserting inverter group: %w", err)
	}
	return nil
}

func (r *ElectricalRepository) ListInverterGroupsByNetwork(ctx context.Context, networkID uuid.UUID) ([]domain.InverterGroup, error) {
	query := `
		SELECT id, network_id, inverter_asset_id, string_ids, dc_input_kw, ac_output_kw, dc_ac_ratio, ST_AsGeoJSON(position)
		FROM inverter_groups WHERE network_id = $1 ORDER BY id`

	rows, err := r.pool.Query(ctx, query, networkID)
	if err != nil {
		return nil, fmt.Errorf("querying inverter groups: %w", err)
	}
	defer rows.Close()

	var groups []domain.InverterGroup
	for rows.Next() {
		var ig domain.InverterGroup
		var stringIDsJSON []byte
		var posGeoJSON *string
		if err := rows.Scan(
			&ig.ID, &ig.NetworkID, &ig.InverterAssetID, &stringIDsJSON,
			&ig.DCInputKW, &ig.ACOutputKW, &ig.DCACRatio, &posGeoJSON,
		); err != nil {
			return nil, fmt.Errorf("scanning inverter group: %w", err)
		}
		if err := json.Unmarshal(stringIDsJSON, &ig.StringIDs); err != nil {
			return nil, fmt.Errorf("unmarshaling string IDs: %w", err)
		}
		if posGeoJSON != nil && *posGeoJSON != "" {
			if err := unmarshalPointGeoJSON(*posGeoJSON, &ig.Position); err != nil {
				return nil, fmt.Errorf("unmarshaling position: %w", err)
			}
		}
		groups = append(groups, ig)
	}
	return groups, nil
}

func (r *ElectricalRepository) AssignStringsToInverterGroup(ctx context.Context, networkID, inverterGroupID uuid.UUID, stringIDs []uuid.UUID) error {
	query := `
		UPDATE panel_strings
		SET inverter_group_id = $3
		WHERE network_id = $1 AND id = ANY($2)`

	tag, err := r.pool.Exec(ctx, query, networkID, stringIDs, inverterGroupID)
	if err != nil {
		return fmt.Errorf("assigning strings to inverter group: %w", err)
	}
	if int(tag.RowsAffected()) != len(stringIDs) {
		return fmt.Errorf("expected to assign %d strings, assigned %d", len(stringIDs), tag.RowsAffected())
	}
	return nil
}

func (r *ElectricalRepository) GetInverterACOutputKW(ctx context.Context, assetID uuid.UUID) (float64, error) {
	query := `
		SELECT COALESCE(
			NULLIF(electrical_params->>'max_ac_output_kw', '')::double precision,
			NULLIF(electrical_params->>'rated_ac_output_kw', '')::double precision,
			NULLIF(electrical_params->>'maxACOutputW', '')::double precision / 1000.0,
			NULLIF(electrical_params->>'ratedPowerW', '')::double precision / 1000.0,
			0
		)
		FROM assets
		WHERE id = $1`

	var acOutputKW float64
	if err := r.pool.QueryRow(ctx, query, assetID).Scan(&acOutputKW); err != nil {
		if err == pgx.ErrNoRows {
			return 0, fmt.Errorf("asset not found: %s", assetID)
		}
		return 0, fmt.Errorf("querying inverter asset: %w", err)
	}
	return acOutputKW, nil
}

func unmarshalPointGeoJSON(raw string, position *[2]float64) error {
	if position == nil {
		return fmt.Errorf("position target is nil")
	}

	var payload struct {
		Type        string    `json:"type"`
		Coordinates []float64 `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(raw), &payload); err != nil {
		return err
	}
	if payload.Type != "Point" || len(payload.Coordinates) < 2 {
		return fmt.Errorf("invalid point geojson")
	}
	position[0] = payload.Coordinates[0]
	position[1] = payload.Coordinates[1]
	return nil
}
