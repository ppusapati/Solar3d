package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/solar3d/routing-service/internal/domain"
)

type RouteRepository struct {
	pool *pgxpool.Pool
}

func NewRouteRepository(pool *pgxpool.Pool) *RouteRepository {
	return &RouteRepository{pool: pool}
}

func (r *RouteRepository) Create(ctx context.Context, route *domain.Route) error {
	query := `
		INSERT INTO routes (id, project_id, route_type, name, geometry_geojson, distance_m, cost_estimate, metadata)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err := r.pool.Exec(ctx, query,
		route.ID, route.ProjectID, route.RouteType, route.Name,
		route.GeometryGeoJSON, route.DistanceM, route.CostEstimate, route.Metadata,
	)
	if err != nil {
		return fmt.Errorf("inserting route: %w", err)
	}
	return nil
}

func (r *RouteRepository) GetByID(ctx context.Context, id uuid.UUID) (*domain.Route, error) {
	query := `
		SELECT id, project_id, route_type, name, geometry_geojson, distance_m, cost_estimate, metadata
		FROM routes WHERE id = $1`

	var route domain.Route
	err := r.pool.QueryRow(ctx, query, id).Scan(
		&route.ID, &route.ProjectID, &route.RouteType, &route.Name,
		&route.GeometryGeoJSON, &route.DistanceM, &route.CostEstimate, &route.Metadata,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("route not found: %s", id)
		}
		return nil, fmt.Errorf("querying route: %w", err)
	}
	return &route, nil
}

func (r *RouteRepository) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.Route, error) {
	query := `
		SELECT id, project_id, route_type, name, geometry_geojson, distance_m, cost_estimate, metadata
		FROM routes WHERE project_id = $1 ORDER BY name`

	rows, err := r.pool.Query(ctx, query, projectID)
	if err != nil {
		return nil, fmt.Errorf("querying routes: %w", err)
	}
	defer rows.Close()

	var routes []domain.Route
	for rows.Next() {
		var route domain.Route
		if err := rows.Scan(
			&route.ID, &route.ProjectID, &route.RouteType, &route.Name,
			&route.GeometryGeoJSON, &route.DistanceM, &route.CostEstimate, &route.Metadata,
		); err != nil {
			return nil, fmt.Errorf("scanning route: %w", err)
		}
		routes = append(routes, route)
	}
	return routes, nil
}

func (r *RouteRepository) ListByType(ctx context.Context, projectID uuid.UUID, routeType domain.RouteType) ([]domain.Route, error) {
	query := `
		SELECT id, project_id, route_type, name, geometry_geojson, distance_m, cost_estimate, metadata
		FROM routes WHERE project_id = $1 AND route_type = $2 ORDER BY name`

	rows, err := r.pool.Query(ctx, query, projectID, routeType)
	if err != nil {
		return nil, fmt.Errorf("querying routes: %w", err)
	}
	defer rows.Close()

	var routes []domain.Route
	for rows.Next() {
		var route domain.Route
		if err := rows.Scan(
			&route.ID, &route.ProjectID, &route.RouteType, &route.Name,
			&route.GeometryGeoJSON, &route.DistanceM, &route.CostEstimate, &route.Metadata,
		); err != nil {
			return nil, fmt.Errorf("scanning route: %w", err)
		}
		routes = append(routes, route)
	}
	return routes, nil
}

func (r *RouteRepository) Delete(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM routes WHERE id = $1`
	tag, err := r.pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("deleting route: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("route not found: %s", id)
	}
	return nil
}

