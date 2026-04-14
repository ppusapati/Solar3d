package service

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/project-service/internal/domain"
	"solar3d/project-service/internal/gis"
	"solar3d/project-service/internal/repository"
	"solar3d/shared/orchestration"
)

// Sentinel errors returned by the service layer.
var (
	ErrNotFound     = errors.New("not found")
	ErrInvalidInput = errors.New("invalid input")
)

// ProjectService contains business logic for managing projects and sites.
type ProjectService struct {
	repo   repository.ProjectRepository
	logger zerolog.Logger
	orch   orchestrationSubmitter
}

type orchestrationSubmitter interface {
	SubmitJob(ctx context.Context, projectID, jobType string, maxAttempts int32, payload string, idempotencyKey string) (string, error)
}

// New creates a new ProjectService.
func New(repo repository.ProjectRepository, logger zerolog.Logger, orchestrationURL ...string) *ProjectService {
	url := "http://127.0.0.1:50059"
	if len(orchestrationURL) > 0 && strings.TrimSpace(orchestrationURL[0]) != "" {
		url = strings.TrimSpace(orchestrationURL[0])
	}
	return &ProjectService{
		repo:   repo,
		logger: logger.With().Str("component", "service").Logger(),
		orch:   orchestration.NewClient(url),
	}
}

// CreateProject validates inputs and persists a new project.
func (s *ProjectService) CreateProject(ctx context.Context, p *domain.Project) error {
	if err := s.validateProject(p); err != nil {
		return err
	}
	if p.Status == "" {
		p.Status = domain.ProjectStatusDraft
	}

	if err := s.repo.CreateProject(ctx, p); err != nil {
		s.logger.Error().Err(err).Str("name", p.Name).Msg("failed to create project")
		return fmt.Errorf("create project: %w", err)
	}

	s.logger.Info().Str("project_id", p.ID.String()).Str("name", p.Name).Msg("project created")
	return nil
}

// GetProject retrieves a project by ID.
func (s *ProjectService) GetProject(ctx context.Context, id uuid.UUID) (*domain.Project, error) {
	p, err := s.repo.GetProject(ctx, id)
	if errors.Is(err, repository.ErrNotFound) {
		return nil, ErrNotFound
	}
	if err != nil {
		s.logger.Error().Err(err).Str("project_id", id.String()).Msg("failed to get project")
		return nil, fmt.Errorf("get project: %w", err)
	}
	return p, nil
}

// ListProjects returns a paginated list of projects.
func (s *ProjectService) ListProjects(ctx context.Context, limit, offset int) ([]*domain.Project, error) {
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}

	projects, err := s.repo.ListProjects(ctx, limit, offset)
	if err != nil {
		s.logger.Error().Err(err).Msg("failed to list projects")
		return nil, fmt.Errorf("list projects: %w", err)
	}
	return projects, nil
}

// UpdateProject validates and persists changes to an existing project.
func (s *ProjectService) UpdateProject(ctx context.Context, p *domain.Project) error {
	if p.ID == uuid.Nil {
		return fmt.Errorf("%w: project id is required", ErrInvalidInput)
	}
	if err := s.validateProject(p); err != nil {
		return err
	}

	if err := s.repo.UpdateProject(ctx, p); err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return ErrNotFound
		}
		s.logger.Error().Err(err).Str("project_id", p.ID.String()).Msg("failed to update project")
		return fmt.Errorf("update project: %w", err)
	}

	s.logger.Info().Str("project_id", p.ID.String()).Msg("project updated")
	return nil
}

// DeleteProject removes a project by ID.
func (s *ProjectService) DeleteProject(ctx context.Context, id uuid.UUID) error {
	if err := s.repo.DeleteProject(ctx, id); err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return ErrNotFound
		}
		s.logger.Error().Err(err).Str("project_id", id.String()).Msg("failed to delete project")
		return fmt.Errorf("delete project: %w", err)
	}

	s.logger.Info().Str("project_id", id.String()).Msg("project deleted")
	return nil
}

// CreateSite validates and persists a new site.
func (s *ProjectService) CreateSite(ctx context.Context, site *domain.Site) error {
	if site.ProjectID == uuid.Nil {
		return fmt.Errorf("%w: project_id is required", ErrInvalidInput)
	}
	if strings.TrimSpace(site.Name) == "" {
		return fmt.Errorf("%w: site name is required", ErrInvalidInput)
	}

	// Verify the parent project exists.
	if _, err := s.repo.GetProject(ctx, site.ProjectID); err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return fmt.Errorf("%w: parent project does not exist", ErrNotFound)
		}
		return fmt.Errorf("check parent project: %w", err)
	}

	if err := s.repo.CreateSite(ctx, site); err != nil {
		s.logger.Error().Err(err).
			Str("project_id", site.ProjectID.String()).
			Str("name", site.Name).
			Msg("failed to create site")
		return fmt.Errorf("create site: %w", err)
	}

	s.logger.Info().
		Str("site_id", site.ID.String()).
		Str("project_id", site.ProjectID.String()).
		Msg("site created")
	return nil
}

// GetSiteByProjectID retrieves the site belonging to a project.
func (s *ProjectService) GetSiteByProjectID(ctx context.Context, projectID uuid.UUID) (*domain.Site, error) {
	site, err := s.repo.GetSiteByProjectID(ctx, projectID)
	if errors.Is(err, repository.ErrNotFound) {
		return nil, ErrNotFound
	}
	if err != nil {
		s.logger.Error().Err(err).Str("project_id", projectID.String()).Msg("failed to get site")
		return nil, fmt.Errorf("get site: %w", err)
	}
	return site, nil
}

// ImportSiteBoundary parses a KML or KMZ payload and upserts the project's site boundary.
func (s *ProjectService) ImportSiteBoundary(ctx context.Context, projectID uuid.UUID, sourceName string, payload []byte, siteName, timezone string) (*domain.Site, error) {
	if projectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id is required", ErrInvalidInput)
	}
	if len(payload) == 0 {
		return nil, fmt.Errorf("%w: boundary payload is required", ErrInvalidInput)
	}

	if _, err := s.repo.GetProject(ctx, projectID); err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, fmt.Errorf("%w: parent project does not exist", ErrNotFound)
		}
		return nil, fmt.Errorf("check parent project: %w", err)
	}

	importedBoundary, err := gis.ParseSiteBoundary(sourceName, payload)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}

	resolvedName := strings.TrimSpace(siteName)
	if resolvedName == "" {
		resolvedName = importedBoundary.Name
	}
	if resolvedName == "" {
		resolvedName = "Imported Site"
	}

	site := &domain.Site{
		ProjectID:       projectID,
		Name:            resolvedName,
		BoundaryGeoJSON: importedBoundary.GeoJSON,
		Timezone:        strings.TrimSpace(timezone),
	}

	if err := s.repo.UpsertSiteBoundary(ctx, site); err != nil {
		s.logger.Error().Err(err).
			Str("project_id", projectID.String()).
			Str("source_name", sourceName).
			Msg("failed to import site boundary")
		return nil, fmt.Errorf("import site boundary: %w", err)
	}

	s.logger.Info().
		Str("site_id", site.ID.String()).
		Str("project_id", site.ProjectID.String()).
		Str("source_name", sourceName).
		Msg("site boundary imported")
	return site, nil
}

// ImportConstraintZones parses a KML or KMZ payload and imports constraint zones for a site.
func (s *ProjectService) ImportConstraintZones(ctx context.Context, projectID uuid.UUID, sourceName string, payload []byte) ([]domain.ConstraintZone, error) {
	if projectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id is required", ErrInvalidInput)
	}
	if len(payload) == 0 {
		return nil, fmt.Errorf("%w: zones payload is required", ErrInvalidInput)
	}

	// Verify project exists and get its site
	project, err := s.repo.GetProject(ctx, projectID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, fmt.Errorf("%w: parent project does not exist", ErrNotFound)
		}
		return nil, fmt.Errorf("check parent project: %w", err)
	}
	_ = project // Verify project exists but don't need its data

	site, err := s.repo.GetSiteByProjectID(ctx, projectID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, fmt.Errorf("%w: site not found for project; import boundary first", ErrInvalidInput)
		}
		return nil, fmt.Errorf("check site: %w", err)
	}

	// Parse constraint zones from KML/KMZ
	parsedZones, err := gis.ParseConstraintZones(payload)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}

	if len(parsedZones) == 0 {
		return nil, fmt.Errorf("%w: no valid constraint zones found in payload", ErrInvalidInput)
	}

	// Convert parsed zones to domain model with area calculation
	var zones []domain.ConstraintZone
	for _, pz := range parsedZones {
		zone := domain.ConstraintZone{
			SiteID:          site.ID,
			Name:            pz.Name,
			ZoneType:        pz.ZoneType,
			BoundaryGeoJSON: pz.GeoJSON,
			SeverityLevel:   pz.SeverityLevel,
			Source:          sourceName,
			// Area will be calculated by database via ST_Area
			AreaSqm: 0,
		}
		zones = append(zones, zone)
	}

	// Persist zones
	if err := s.repo.UpsertConstraintZones(ctx, site.ID, zones); err != nil {
		s.logger.Error().Err(err).
			Str("project_id", projectID.String()).
			Str("site_id", site.ID.String()).
			Str("source_name", sourceName).
			Int("zone_count", len(zones)).
			Msg("failed to import constraint zones")
		return nil, fmt.Errorf("import constraint zones: %w", err)
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("site_id", site.ID.String()).
		Str("source_name", sourceName).
		Int("zone_count", len(zones)).
		Msg("constraint zones imported")

	return zones, nil
}

// GetConstraintZonesByProject returns all persisted constraint zones for the project's site.
func (s *ProjectService) GetConstraintZonesByProject(ctx context.Context, projectID uuid.UUID) ([]domain.ConstraintZone, error) {
	if projectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id is required", ErrInvalidInput)
	}

	if _, err := s.repo.GetProject(ctx, projectID); err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, fmt.Errorf("%w: parent project does not exist", ErrNotFound)
		}
		return nil, fmt.Errorf("check parent project: %w", err)
	}

	site, err := s.repo.GetSiteByProjectID(ctx, projectID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return []domain.ConstraintZone{}, nil
		}
		return nil, fmt.Errorf("check site: %w", err)
	}

	zones, err := s.repo.GetConstraintZonesBySite(ctx, site.ID)
	if err != nil {
		return nil, fmt.Errorf("get constraint zones: %w", err)
	}

	if zones == nil {
		return []domain.ConstraintZone{}, nil
	}

	return zones, nil
}

// validateProject checks required fields on a project.
func (s *ProjectService) validateProject(p *domain.Project) error {
	if strings.TrimSpace(p.Name) == "" {
		return fmt.Errorf("%w: project name is required", ErrInvalidInput)
	}
	if p.Status != "" && !p.Status.IsValid() {
		return fmt.Errorf("%w: invalid project status %q", ErrInvalidInput, p.Status)
	}
	if p.TargetCapacityMW < 0 {
		return fmt.Errorf("%w: target_capacity_mw must be non-negative", ErrInvalidInput)
	}
	return nil
}
