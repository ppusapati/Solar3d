package domain

import (
	"time"

	"github.com/google/uuid"
)

// ProjectStatus represents the lifecycle state of a project.
type ProjectStatus string

const (
	ProjectStatusDraft      ProjectStatus = "draft"
	ProjectStatusDesign     ProjectStatus = "design"
	ProjectStatusSimulation ProjectStatus = "simulation"
	ProjectStatusReview     ProjectStatus = "review"
	ProjectStatusApproved   ProjectStatus = "approved"
	ProjectStatusArchived   ProjectStatus = "archived"
)

// ValidProjectStatuses contains all valid status values for validation.
var ValidProjectStatuses = map[ProjectStatus]bool{
	ProjectStatusDraft:      true,
	ProjectStatusDesign:     true,
	ProjectStatusSimulation: true,
	ProjectStatusReview:     true,
	ProjectStatusApproved:   true,
	ProjectStatusArchived:   true,
}

// IsValid reports whether the status is a recognized project status.
func (s ProjectStatus) IsValid() bool {
	return ValidProjectStatuses[s]
}

// Project represents a solar EPC project.
type Project struct {
	ID               uuid.UUID     `json:"id"`
	Name             string        `json:"name"`
	Description      string        `json:"description"`
	Status           ProjectStatus `json:"status"`
	TargetCapacityMW float64       `json:"target_capacity_mw"`
	LocationName     string        `json:"location_name"`
	ClientName       string        `json:"client_name"`
	Notes            string        `json:"notes"`
	CreatedAt        time.Time     `json:"created_at"`
	UpdatedAt        time.Time     `json:"updated_at"`
}

// Site represents a physical site belonging to a project.
type Site struct {
	ID              uuid.UUID `json:"id"`
	ProjectID       uuid.UUID `json:"project_id"`
	Name            string    `json:"name"`
	BoundaryGeoJSON string    `json:"boundary_geojson"`
	AreaSqm         float64   `json:"area_sqm"`
	Latitude        float64   `json:"latitude"`
	Longitude       float64   `json:"longitude"`
	Timezone        string    `json:"timezone"`
	CreatedAt       time.Time `json:"created_at"`
}
