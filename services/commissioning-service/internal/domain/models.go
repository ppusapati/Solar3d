package domain

import (
	"errors"
	"time"

	"github.com/google/uuid"
)

// ErrNotFound is returned when a requested entity does not exist.
var ErrNotFound = errors.New("not found")

// CommissioningStatus mirrors the proto enum.
type CommissioningStatus int32

const (
	CommissioningStatusPending    CommissioningStatus = 1
	CommissioningStatusInProgress CommissioningStatus = 2
	CommissioningStatusCompleted  CommissioningStatus = 3
	CommissioningStatusSignedOff  CommissioningStatus = 4
	CommissioningStatusHandedOver CommissioningStatus = 5
)

func (s CommissioningStatus) String() string {
	switch s {
	case CommissioningStatusPending:
		return "PENDING"
	case CommissioningStatusInProgress:
		return "IN_PROGRESS"
	case CommissioningStatusCompleted:
		return "COMPLETED"
	case CommissioningStatusSignedOff:
		return "SIGNED_OFF"
	case CommissioningStatusHandedOver:
		return "HANDED_OVER"
	default:
		return "UNSPECIFIED"
	}
}

// ChecklistItemStatus mirrors the proto enum.
type ChecklistItemStatus int32

const (
	ChecklistItemStatusPending       ChecklistItemStatus = 1
	ChecklistItemStatusPass          ChecklistItemStatus = 2
	ChecklistItemStatusFail          ChecklistItemStatus = 3
	ChecklistItemStatusNotApplicable ChecklistItemStatus = 4
)

// ChecklistSection mirrors the proto enum.
type ChecklistSection int32

const (
	ChecklistSectionCivil         ChecklistSection = 1
	ChecklistSectionMechanical    ChecklistSection = 2
	ChecklistSectionElectrical    ChecklistSection = 3
	ChecklistSectionProtection    ChecklistSection = 4
	ChecklistSectionSCADA         ChecklistSection = 5
	ChecklistSectionSafety        ChecklistSection = 6
	ChecklistSectionDocumentation ChecklistSection = 7
)

// AsBuiltArtifactType mirrors the proto enum.
type AsBuiltArtifactType int32

const (
	AsBuiltArtifactTypeDrawing       AsBuiltArtifactType = 1
	AsBuiltArtifactTypeReport        AsBuiltArtifactType = 2
	AsBuiltArtifactTypeSpecification AsBuiltArtifactType = 3
	AsBuiltArtifactTypePhoto         AsBuiltArtifactType = 4
	AsBuiltArtifactTypeTestRecord    AsBuiltArtifactType = 5
	AsBuiltArtifactTypeCertificate   AsBuiltArtifactType = 6
)

// ── Domain structs ─────────────────────────────────────────────────────────

type ChecklistItem struct {
	ID          uuid.UUID           `json:"id"`
	ChecklistID uuid.UUID           `json:"checklist_id"`
	Description string              `json:"description"`
	Section     ChecklistSection    `json:"section"`
	Status      ChecklistItemStatus `json:"status"`
	Required    bool                `json:"required"`
	CompletedBy string              `json:"completed_by,omitempty"`
	CompletedAt *time.Time          `json:"completed_at,omitempty"`
	Notes       string              `json:"notes,omitempty"`
	Sequence    int32               `json:"sequence"`
}

type CommissioningSignoff struct {
	ID          uuid.UUID `json:"id"`
	ChecklistID uuid.UUID `json:"checklist_id"`
	SignedBy    string    `json:"signed_by"`
	Role        string    `json:"role"`
	Comments    string    `json:"comments,omitempty"`
	SignedAt    time.Time `json:"signed_at"`
}

type CommissioningChecklist struct {
	ID        uuid.UUID              `json:"id"`
	ProjectID uuid.UUID              `json:"project_id"`
	Name      string                 `json:"name"`
	Status    CommissioningStatus    `json:"status"`
	Items     []ChecklistItem        `json:"items,omitempty"`
	Signoffs  []CommissioningSignoff `json:"signoffs,omitempty"`
	CreatedAt time.Time              `json:"created_at"`
	UpdatedAt time.Time              `json:"updated_at"`
	CreatedBy string                 `json:"created_by,omitempty"`
}

// DerivedCounts returns completed/failed item totals from Items slice.
func (c *CommissioningChecklist) DerivedCounts() (total, completed, failed int32) {
	for _, item := range c.Items {
		total++
		switch item.Status {
		case ChecklistItemStatusPass, ChecklistItemStatusNotApplicable:
			completed++
		case ChecklistItemStatusFail:
			failed++
		}
	}
	return
}

type HandoverRecord struct {
	ID           uuid.UUID   `json:"id"`
	ProjectID    uuid.UUID   `json:"project_id"`
	ChecklistID  uuid.UUID   `json:"checklist_id"`
	HandedOverBy string      `json:"handed_over_by"`
	ReceivedBy   string      `json:"received_by"`
	Notes        string      `json:"notes,omitempty"`
	ArtifactIDs  []uuid.UUID `json:"artifact_ids,omitempty"`
	HandoverDate time.Time   `json:"handover_date"`
	CreatedAt    time.Time   `json:"created_at"`
}

type AsBuiltArtifact struct {
	ID            uuid.UUID           `json:"id"`
	ProjectID     uuid.UUID           `json:"project_id"`
	Name          string              `json:"name"`
	ArtifactType  AsBuiltArtifactType `json:"artifact_type"`
	StorageURL    string              `json:"storage_url"`
	UploadedBy    string              `json:"uploaded_by"`
	UploadedAt    time.Time           `json:"uploaded_at"`
	Description   string              `json:"description,omitempty"`
	FileSizeBytes int64               `json:"file_size_bytes,omitempty"`
	Revision      string              `json:"revision,omitempty"`
}

// ── Request / Response types ───────────────────────────────────────────────

type CreateChecklistRequest struct {
	ProjectID uuid.UUID `json:"project_id"`
	Name      string    `json:"name"`
	CreatedBy string    `json:"created_by"`
}

type AddChecklistItemRequest struct {
	ChecklistID uuid.UUID        `json:"checklist_id"`
	Description string           `json:"description"`
	Section     ChecklistSection `json:"section"`
	Required    bool             `json:"required"`
	Sequence    int32            `json:"sequence"`
}

type UpdateChecklistItemRequest struct {
	ItemID      uuid.UUID           `json:"item_id"`
	Status      ChecklistItemStatus `json:"status"`
	CompletedBy string              `json:"completed_by"`
	Notes       string              `json:"notes"`
}

type SignOffChecklistRequest struct {
	ChecklistID uuid.UUID `json:"checklist_id"`
	SignedBy    string    `json:"signed_by"`
	Role        string    `json:"role"`
	Comments    string    `json:"comments,omitempty"`
}

type CreateHandoverRequest struct {
	ProjectID    uuid.UUID   `json:"project_id"`
	ChecklistID  uuid.UUID   `json:"checklist_id"`
	HandedOverBy string      `json:"handed_over_by"`
	ReceivedBy   string      `json:"received_by"`
	Notes        string      `json:"notes,omitempty"`
	ArtifactIDs  []uuid.UUID `json:"artifact_ids,omitempty"`
}

type RecordAsBuiltRequest struct {
	ProjectID     uuid.UUID           `json:"project_id"`
	Name          string              `json:"name"`
	ArtifactType  AsBuiltArtifactType `json:"artifact_type"`
	StorageURL    string              `json:"storage_url"`
	UploadedBy    string              `json:"uploaded_by"`
	Description   string              `json:"description,omitempty"`
	FileSizeBytes int64               `json:"file_size_bytes,omitempty"`
	Revision      string              `json:"revision,omitempty"`
}

type GenerateReportRequest struct {
	ChecklistID uuid.UUID `json:"checklist_id"`
}
