package service

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"github.com/solar3d/solar3d/services/project-service/internal/domain"
	"github.com/solar3d/solar3d/services/project-service/internal/repository"
)

// Sentinel errors returned by the service layer.
var (
	ErrNotFound       = errors.New("not found")
	ErrInvalidInput   = errors.New("invalid input")
)

// ProjectService contains business logic for managing projects and sites.
type ProjectService struct {
	repo   repository.ProjectRepository
	logger zerolog.Logger
}

// New creates a new ProjectService.
func New(repo repository.ProjectRepository, logger zerolog.Logger) *ProjectService {
	return &ProjectService{
		repo:   repo,
		logger: logger.With().Str("component", "service").Logger(),
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
