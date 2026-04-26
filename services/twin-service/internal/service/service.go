package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/twin-service/internal/domain"
	"p9e.in/samavaya/solar3d/twin-service/internal/repository"
)

// TwinService implements twin provisioning, state retrieval, telemetry ingestion,
// and asset-identity linkage.
type TwinService struct {
	repo   repository.TwinRepository
	logger zerolog.Logger
}

// New creates a TwinService wired to the given repository.
func New(repo repository.TwinRepository, logger zerolog.Logger) *TwinService {
	return &TwinService{
		repo:   repo,
		logger: logger.With().Str("component", "twin-service").Logger(),
	}
}

// ProvisionTwinInput carries the caller-supplied fields for twin creation.
type ProvisionTwinInput struct {
	ProjectID           uuid.UUID
	LayoutID            *uuid.UUID
	ElectricalNetworkID *uuid.UUID
	TransmissionRouteID *uuid.UUID
}

// ProvisionTwin creates a new DigitalTwin in PROVISIONING status.
func (s *TwinService) ProvisionTwin(ctx context.Context, in ProvisionTwinInput) (*domain.DigitalTwin, error) {
	if in.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("project_id is required")
	}

	twin := &domain.DigitalTwin{
		ProjectID:           in.ProjectID,
		LayoutID:            in.LayoutID,
		ElectricalNetworkID: in.ElectricalNetworkID,
		TransmissionRouteID: in.TransmissionRouteID,
		Status:              domain.TwinStatusProvisioning,
		Operational:         domain.OperationalState{HealthScore: 1.0},
	}

	if err := s.repo.CreateTwin(ctx, twin); err != nil {
		return nil, fmt.Errorf("provision twin: %w", err)
	}

	s.logger.Info().
		Str("twin_id", twin.ID.String()).
		Str("project_id", in.ProjectID.String()).
		Msg("twin provisioned")
	return twin, nil
}

// GetTwinState retrieves a twin and its current operational state by ID.
func (s *TwinService) GetTwinState(ctx context.Context, twinID uuid.UUID) (*domain.DigitalTwin, error) {
	if twinID == uuid.Nil {
		return nil, fmt.Errorf("twin_id is required")
	}

	twin, err := s.repo.GetTwinByID(ctx, twinID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, repository.ErrNotFound
		}
		return nil, fmt.Errorf("get twin state: %w", err)
	}
	return twin, nil
}

// IngestReadingsInput carries a batch of readings plus the owning twin ID.
type IngestReadingsInput struct {
	TwinID   uuid.UUID
	Readings []*domain.SensorReading
}

// IngestReadings validates and persists a batch of sensor readings.
// Readings already associated with a twin are idempotent via ON CONFLICT DO NOTHING.
func (s *TwinService) IngestReadings(ctx context.Context, in IngestReadingsInput) (int, error) {
	if in.TwinID == uuid.Nil {
		return 0, fmt.Errorf("twin_id is required")
	}
	if len(in.Readings) == 0 {
		return 0, nil
	}
	if len(in.Readings) > 5000 {
		return 0, fmt.Errorf("batch size %d exceeds maximum of 5000", len(in.Readings))
	}

	// Stamp every reading with the owning twin.
	for _, rd := range in.Readings {
		rd.TwinID = in.TwinID
		if rd.Quality == "" {
			rd.Quality = domain.ReadingQualityGood
		}
	}

	if err := s.repo.InsertReadingsBatch(ctx, in.Readings); err != nil {
		return 0, fmt.Errorf("ingest readings: %w", err)
	}

	s.logger.Debug().
		Str("twin_id", in.TwinID.String()).
		Int("count", len(in.Readings)).
		Msg("readings ingested")
	return len(in.Readings), nil
}

// LatestReadings returns the most recent sensor readings for a twin, sorted
// newest-first. Limit must be positive; values above 1000 are clamped to
// keep response sizes bounded for telemetry dashboards.
func (s *TwinService) LatestReadings(ctx context.Context, twinID uuid.UUID, limit int) ([]*domain.SensorReading, error) {
	if twinID == uuid.Nil {
		return nil, fmt.Errorf("twin_id is required")
	}
	if limit <= 0 {
		limit = 100
	}
	if limit > 1000 {
		limit = 1000
	}
	readings, err := s.repo.GetLatestReadingsByTwin(ctx, twinID, limit)
	if err != nil {
		return nil, fmt.Errorf("fetch latest readings: %w", err)
	}
	return readings, nil
}

// LinkAssetIdentityInput carries the caller-supplied fields for asset linkage.
type LinkAssetIdentityInput struct {
	TwinID               uuid.UUID
	DesignAssetID        uuid.UUID
	DesignAssetType      domain.DesignAssetType
	PhysicalSerialNumber string
	CommissioningRef     string
}

// LinkAssetIdentity creates an AssetIdentity tying a design asset to a physical
// commissioned asset under the given twin. Commissioning reference follows IEC 62446-1 §7.
func (s *TwinService) LinkAssetIdentity(ctx context.Context, in LinkAssetIdentityInput) (*domain.AssetIdentity, error) {
	if in.TwinID == uuid.Nil {
		return nil, fmt.Errorf("twin_id is required")
	}
	if in.DesignAssetID == uuid.Nil {
		return nil, fmt.Errorf("design_asset_id is required")
	}
	if in.PhysicalSerialNumber == "" {
		return nil, fmt.Errorf("physical_serial_number is required")
	}

	// Verify the target twin exists.
	if _, err := s.repo.GetTwinByID(ctx, in.TwinID); err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, repository.ErrNotFound
		}
		return nil, fmt.Errorf("verify twin: %w", err)
	}

	identity := &domain.AssetIdentity{
		TwinID:               in.TwinID,
		DesignAssetID:        in.DesignAssetID,
		DesignAssetType:      in.DesignAssetType,
		PhysicalSerialNumber: in.PhysicalSerialNumber,
		CommissioningRef:     in.CommissioningRef,
	}

	if err := s.repo.CreateAssetIdentity(ctx, identity); err != nil {
		return nil, fmt.Errorf("link asset identity: %w", err)
	}

	s.logger.Info().
		Str("twin_id", in.TwinID.String()).
		Str("asset_identity_id", identity.ID.String()).
		Str("design_asset_id", in.DesignAssetID.String()).
		Msg("asset identity linked")
	return identity, nil
}
