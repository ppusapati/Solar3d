package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/solar3d/simulation-service/internal/domain"
)

type SimulationRepository struct {
	pool *pgxpool.Pool
}

func NewSimulationRepository(pool *pgxpool.Pool) *SimulationRepository {
	return &SimulationRepository{pool: pool}
}

func (r *SimulationRepository) Create(ctx context.Context, sim *domain.Simulation) error {
	paramsJSON, err := json.Marshal(sim.Params)
	if err != nil {
		return fmt.Errorf("marshaling params: %w", err)
	}

	query := `
		INSERT INTO simulations (id, project_id, layout_id, name, simulation_type, status, params, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err = r.pool.Exec(ctx, query,
		sim.ID, sim.ProjectID, sim.LayoutID, sim.Name,
		sim.SimulationType, sim.Status, paramsJSON, sim.CreatedAt,
	)
	if err != nil {
		return fmt.Errorf("inserting simulation: %w", err)
	}
	return nil
}

func (r *SimulationRepository) GetByID(ctx context.Context, id uuid.UUID) (*domain.Simulation, error) {
	query := `
		SELECT id, project_id, layout_id, name, simulation_type, status, params, result, created_at, completed_at
		FROM simulations WHERE id = $1`

	var sim domain.Simulation
	var paramsJSON, resultJSON []byte

	err := r.pool.QueryRow(ctx, query, id).Scan(
		&sim.ID, &sim.ProjectID, &sim.LayoutID, &sim.Name,
		&sim.SimulationType, &sim.Status, &paramsJSON, &resultJSON,
		&sim.CreatedAt, &sim.CompletedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("simulation not found: %s", id)
		}
		return nil, fmt.Errorf("querying simulation: %w", err)
	}

	if err := json.Unmarshal(paramsJSON, &sim.Params); err != nil {
		return nil, fmt.Errorf("unmarshaling params: %w", err)
	}
	if resultJSON != nil {
		sim.Result = &domain.SimulationResult{}
		if err := json.Unmarshal(resultJSON, sim.Result); err != nil {
			return nil, fmt.Errorf("unmarshaling result: %w", err)
		}
	}
	return &sim, nil
}

func (r *SimulationRepository) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.Simulation, error) {
	query := `
		SELECT id, project_id, layout_id, name, simulation_type, status, params, result, created_at, completed_at
		FROM simulations WHERE project_id = $1 ORDER BY created_at DESC`

	rows, err := r.pool.Query(ctx, query, projectID)
	if err != nil {
		return nil, fmt.Errorf("querying simulations: %w", err)
	}
	defer rows.Close()

	var simulations []domain.Simulation
	for rows.Next() {
		var sim domain.Simulation
		var paramsJSON, resultJSON []byte
		if err := rows.Scan(
			&sim.ID, &sim.ProjectID, &sim.LayoutID, &sim.Name,
			&sim.SimulationType, &sim.Status, &paramsJSON, &resultJSON,
			&sim.CreatedAt, &sim.CompletedAt,
		); err != nil {
			return nil, fmt.Errorf("scanning simulation: %w", err)
		}
		if err := json.Unmarshal(paramsJSON, &sim.Params); err != nil {
			return nil, fmt.Errorf("unmarshaling params: %w", err)
		}
		if resultJSON != nil {
			sim.Result = &domain.SimulationResult{}
			if err := json.Unmarshal(resultJSON, sim.Result); err != nil {
				return nil, fmt.Errorf("unmarshaling result: %w", err)
			}
		}
		simulations = append(simulations, sim)
	}
	return simulations, nil
}

func (r *SimulationRepository) UpdateStatus(ctx context.Context, id uuid.UUID, status domain.SimulationStatus) error {
	query := `UPDATE simulations SET status = $1 WHERE id = $2`
	tag, err := r.pool.Exec(ctx, query, status, id)
	if err != nil {
		return fmt.Errorf("updating status: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("simulation not found: %s", id)
	}
	return nil
}

func (r *SimulationRepository) UpdateResult(ctx context.Context, id uuid.UUID, result *domain.SimulationResult) error {
	resultJSON, err := json.Marshal(result)
	if err != nil {
		return fmt.Errorf("marshaling result: %w", err)
	}

	query := `UPDATE simulations SET result = $1, status = 'completed', completed_at = NOW() WHERE id = $2`
	tag, err := r.pool.Exec(ctx, query, resultJSON, id)
	if err != nil {
		return fmt.Errorf("updating result: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("simulation not found: %s", id)
	}
	return nil
}

func (r *SimulationRepository) Delete(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM simulations WHERE id = $1`
	tag, err := r.pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("deleting simulation: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("simulation not found: %s", id)
	}
	return nil
}

