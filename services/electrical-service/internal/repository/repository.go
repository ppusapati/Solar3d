package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/solar3d/solar3d/services/electrical-service/internal/domain"
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

func (r *ElectricalRepository) CreateString(ctx context.Context, ps *domain.PanelString) error {
	panelIDsJSON, err := json.Marshal(ps.PanelIDs)
	if err != nil {
		return fmt.Errorf("marshaling panel IDs: %w", err)
	}

	query := `
		INSERT INTO panel_strings (id, network_id, inverter_group_id, panel_ids, panel_count, voltage, current, power_w)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err = r.pool.Exec(ctx, query,
		ps.ID, ps.NetworkID, ps.InverterGroupID, panelIDsJSON,
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
		var panelIDsJSON []byte
		if err := rows.Scan(
			&ps.ID, &ps.NetworkID, &ps.InverterGroupID, &panelIDsJSON,
			&ps.PanelCount, &ps.Voltage, &ps.Current, &ps.PowerW,
		); err != nil {
			return nil, fmt.Errorf("scanning string: %w", err)
		}
		if err := json.Unmarshal(panelIDsJSON, &ps.PanelIDs); err != nil {
			return nil, fmt.Errorf("unmarshaling panel IDs: %w", err)
		}
		strings = append(strings, ps)
	}
	return strings, nil
}

func (r *ElectricalRepository) CreateInverterGroup(ctx context.Context, ig *domain.InverterGroup) error {
	stringIDsJSON, err := json.Marshal(ig.StringIDs)
	if err != nil {
		return fmt.Errorf("marshaling string IDs: %w", err)
	}
	posJSON, err := json.Marshal(ig.Position)
	if err != nil {
		return fmt.Errorf("marshaling position: %w", err)
	}

	query := `
		INSERT INTO inverter_groups (id, network_id, inverter_asset_id, string_ids, dc_input_kw, ac_output_kw, dc_ac_ratio, position)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err = r.pool.Exec(ctx, query,
		ig.ID, ig.NetworkID, ig.InverterAssetID, stringIDsJSON,
		ig.DCInputKW, ig.ACOutputKW, ig.DCACRatio, posJSON,
	)
	if err != nil {
		return fmt.Errorf("inserting inverter group: %w", err)
	}
	return nil
}

func (r *ElectricalRepository) ListInverterGroupsByNetwork(ctx context.Context, networkID uuid.UUID) ([]domain.InverterGroup, error) {
	query := `
		SELECT id, network_id, inverter_asset_id, string_ids, dc_input_kw, ac_output_kw, dc_ac_ratio, position
		FROM inverter_groups WHERE network_id = $1 ORDER BY id`

	rows, err := r.pool.Query(ctx, query, networkID)
	if err != nil {
		return nil, fmt.Errorf("querying inverter groups: %w", err)
	}
	defer rows.Close()

	var groups []domain.InverterGroup
	for rows.Next() {
		var ig domain.InverterGroup
		var stringIDsJSON, posJSON []byte
		if err := rows.Scan(
			&ig.ID, &ig.NetworkID, &ig.InverterAssetID, &stringIDsJSON,
			&ig.DCInputKW, &ig.ACOutputKW, &ig.DCACRatio, &posJSON,
		); err != nil {
			return nil, fmt.Errorf("scanning inverter group: %w", err)
		}
		if err := json.Unmarshal(stringIDsJSON, &ig.StringIDs); err != nil {
			return nil, fmt.Errorf("unmarshaling string IDs: %w", err)
		}
		if err := json.Unmarshal(posJSON, &ig.Position); err != nil {
			return nil, fmt.Errorf("unmarshaling position: %w", err)
		}
		groups = append(groups, ig)
	}
	return groups, nil
}
