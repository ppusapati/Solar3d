package service

import (
	"context"
	"errors"
	"testing"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/project-service/internal/domain"
	"solar3d/project-service/internal/repository"
)

type siteImportRepoStub struct {
	project           *domain.Project
	upsertedSite      *domain.Site
	upsertBoundaryErr error
}

func (r *siteImportRepoStub) CreateProject(context.Context, *domain.Project) error {
	panic("unexpected CreateProject call")
}
func (r *siteImportRepoStub) ListProjects(context.Context, int, int) ([]*domain.Project, error) {
	panic("unexpected ListProjects call")
}
func (r *siteImportRepoStub) UpdateProject(context.Context, *domain.Project) error {
	panic("unexpected UpdateProject call")
}
func (r *siteImportRepoStub) DeleteProject(context.Context, uuid.UUID) error {
	panic("unexpected DeleteProject call")
}
func (r *siteImportRepoStub) CreateSite(context.Context, *domain.Site) error {
	panic("unexpected CreateSite call")
}
func (r *siteImportRepoStub) GetSiteByProjectID(context.Context, uuid.UUID) (*domain.Site, error) {
	panic("unexpected GetSiteByProjectID call")
}

func (r *siteImportRepoStub) GetProject(context.Context, uuid.UUID) (*domain.Project, error) {
	if r.project == nil {
		return nil, repository.ErrNotFound
	}
	return r.project, nil
}

func (r *siteImportRepoStub) UpsertSiteBoundary(_ context.Context, site *domain.Site) error {
	if r.upsertBoundaryErr != nil {
		return r.upsertBoundaryErr
	}
	clone := *site
	clone.ID = uuid.New()
	clone.AreaSqm = 1234.5
	clone.Latitude = 40.5
	clone.Longitude = -105.25
	r.upsertedSite = &clone
	*site = clone
	return nil
}

func (r *siteImportRepoStub) UpsertConstraintZones(context.Context, uuid.UUID, []domain.ConstraintZone) error {
	panic("unexpected UpsertConstraintZones call")
}

func (r *siteImportRepoStub) GetConstraintZonesBySite(context.Context, uuid.UUID) ([]domain.ConstraintZone, error) {
	panic("unexpected GetConstraintZonesBySite call")
}

func (r *siteImportRepoStub) DeleteConstraintZonesBySite(context.Context, uuid.UUID) error {
	panic("unexpected DeleteConstraintZonesBySite call")
}

func TestImportSiteBoundary(t *testing.T) {
	projectID := uuid.New()
	repo := &siteImportRepoStub{project: &domain.Project{ID: projectID, Name: "Boundary Project"}}
	svc := New(repo, zerolog.Nop())

	payload := []byte(`<?xml version="1.0" encoding="UTF-8"?>
	<kml xmlns="http://www.opengis.net/kml/2.2"><Placemark><name>West Parcel</name><Polygon><outerBoundaryIs><LinearRing><coordinates>
	-105.0,40.0,0 -104.0,40.0,0 -104.0,41.0,0 -105.0,41.0,0 -105.0,40.0,0
	</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark></kml>`)

	site, err := svc.ImportSiteBoundary(context.Background(), projectID, "parcel.kml", payload, "", "America/Denver")
	if err != nil {
		t.Fatalf("ImportSiteBoundary returned error: %v", err)
	}
	if site.Name != "West Parcel" {
		t.Fatalf("expected imported name West Parcel, got %q", site.Name)
	}
	if site.Timezone != "America/Denver" {
		t.Fatalf("expected timezone America/Denver, got %q", site.Timezone)
	}
	if repo.upsertedSite == nil {
		t.Fatal("expected UpsertSiteBoundary to be called")
	}
	if repo.upsertedSite.BoundaryGeoJSON == "" {
		t.Fatal("expected imported boundary geojson")
	}
	if site.AreaSqm != 1234.5 {
		t.Fatalf("expected derived area to be populated, got %v", site.AreaSqm)
	}
}

func TestImportSiteBoundaryRequiresProject(t *testing.T) {
	svc := New(&siteImportRepoStub{}, zerolog.Nop())
	_, err := svc.ImportSiteBoundary(context.Background(), uuid.New(), "parcel.kml", []byte("kml"), "", "")
	if !errors.Is(err, ErrNotFound) {
		t.Fatalf("expected ErrNotFound, got %v", err)
	}
}
