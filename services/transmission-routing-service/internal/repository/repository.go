package repository

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"solar3d/transmission-routing-service/internal/db"
	"solar3d/transmission-routing-service/internal/domain"
	"solar3d/transmission-routing-service/internal/mappers"
)

var ErrNotFound = errors.New("transmission route not found")

type Repository struct {
	q db.Querier
}

func New(q db.Querier) *Repository {
	return &Repository{q: q}
}

func (r *Repository) Create(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	params, err := mappers.DomainCreateParams(route)
	if err != nil {
		return nil, err
	}
	row, err := r.q.CreateTransmissionRoute(ctx, params)
	if err != nil {
		return nil, fmt.Errorf("create transmission route: %w", err)
	}
	return mappers.CreateTransmissionRouteRowToDomain(row)
}

func (r *Repository) GetByID(ctx context.Context, id uuid.UUID) (*domain.TransmissionRoute, error) {
	row, err := r.q.GetTransmissionRoute(ctx, pgtype.UUID{Bytes: id, Valid: true})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("get transmission route: %w", err)
	}
	return mappers.GetTransmissionRouteRowToDomain(row)
}

func (r *Repository) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.TransmissionRoute, error) {
	rows, err := r.q.ListTransmissionRoutes(ctx, pgtype.UUID{Bytes: projectID, Valid: true})
	if err != nil {
		return nil, fmt.Errorf("list transmission routes: %w", err)
	}
	routes := make([]domain.TransmissionRoute, 0, len(rows))
	for _, row := range rows {
		route, err := mappers.ListTransmissionRouteRowToDomain(row)
		if err != nil {
			return nil, err
		}
		routes = append(routes, *route)
	}
	return routes, nil
}

func (r *Repository) SubmitForReview(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	governanceEvents, err := route.MarshalGovernanceEvents()
	if err != nil {
		return nil, err
	}
	metadata := route.MarshalMetadata()
	row, err := r.q.SubmitTransmissionRouteForReview(ctx, db.SubmitTransmissionRouteForReviewParams{
		EngineeringReviewedAt: pgTime(route.EngineeringReviewedAt),
		EngineeringReviewedBy: route.EngineeringReviewedBy,
		GovernanceEvents:      governanceEvents,
		Metadata:              metadata,
		RouteSummary:          route.RouteSummary,
		ID:                    pgtype.UUID{Bytes: route.ID, Valid: true},
	})
	if err != nil {
		return nil, fmt.Errorf("submit transmission route for review: %w", err)
	}
	return mappers.SubmitTransmissionRouteForReviewRowToDomain(row)
}

func (r *Repository) Approve(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error) {
	governanceEvents, err := route.MarshalGovernanceEvents()
	if err != nil {
		return nil, err
	}
	metadata := route.MarshalMetadata()
	row, err := r.q.ApproveTransmissionRoute(ctx, db.ApproveTransmissionRouteParams{
		ApprovedAt:       pgTime(route.ApprovedAt),
		ApprovedBy:       route.ApprovedBy,
		GovernanceEvents: governanceEvents,
		Metadata:         metadata,
		RouteSummary:     route.RouteSummary,
		ID:               pgtype.UUID{Bytes: route.ID, Valid: true},
	})
	if err != nil {
		return nil, fmt.Errorf("approve transmission route: %w", err)
	}
	return mappers.ApproveTransmissionRouteRowToDomain(row)
}

func (r *Repository) Delete(ctx context.Context, id uuid.UUID) error {
	if err := r.q.DeleteTransmissionRoute(ctx, pgtype.UUID{Bytes: id, Valid: true}); err != nil {
		return fmt.Errorf("delete transmission route: %w", err)
	}
	return nil
}

func pgTime(value *time.Time) pgtype.Timestamptz {
	if value == nil {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: *value, Valid: true}
}

