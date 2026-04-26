package models

import (
	"time"
)

// ConstraintZone represents a geographic constraint zone (exclusion, inclusion, or buffer).
type ConstraintZone struct {
	ID           int64
	ZoneID       string // UUID
	Name         string
	Description  string
	ZoneType     string // EXCLUSION, INCLUSION, BUFFER
	ZoneCategory string // GEOLOGICAL, ENVIRONMENTAL, REGULATORY, INFRASTRUCTURE, MILITARY, PROTECTED
	ZoneStatus   string // ACTIVE, INACTIVE, EXPIRED, PENDING

	// Geometry
	GeometryWKT  string // Well-Known Text format
	GeometryType string // POINT, LINESTRING, POLYGON, MULTIPOLYGON
	BBoxMinX     float64
	BBoxMinY     float64
	BBoxMaxX     float64
	BBoxMaxY     float64

	// Temporal
	EffectiveStartAt *time.Time
	EffectiveEndAt   *time.Time

	// Source tracking
	Source          string  // e.g., "regulatory_db", "user_defined", "import"
	SourceID        string  // Reference to external system
	BufferDistanceM float32 // For buffer zones

	// Metadata
	Tags     []string          // Classification tags
	Metadata map[string]string // Custom key-value pairs

	// Access control
	CreatedBy string // User ID
	ProjectID string // Associated project
	IsPublic  bool   // Visibility scope (false = project-private)

	// Audit trail
	CreatedAt     time.Time
	UpdatedAt     time.Time
	DeletedAt     *time.Time
	DeletedReason string // Why zone was deleted
}

// ZoneCategoryDef defines a category in the zone taxonomy.
type ZoneCategoryDef struct {
	Category              string
	DisplayName           string
	Description           string
	AllowedTags           []string
	AssociatedRegulations []string
}

// ZoneHistory maintains audit trail of zone modifications.
type ZoneHistory struct {
	ID              int64
	ZoneID          string // Reference to ConstraintZone.ZoneID
	ChangeType      string // CREATE, UPDATE, DELETE, STATUS_CHANGE
	OldValues       map[string]string
	NewValues       map[string]string
	ChangedBy       string // User ID
	ChangeReason    string // Why change occurred
	DetailedChanges string // Structured JSON of field diffs
	ChangedAt       time.Time
}

// SitingConflict represents identified conflict between site and constraint zone.
type SitingConflict struct {
	ID                    int64
	ConflictID            string  // UUID
	ZoneID                string  // Reference to conflicting zone
	AnalysisID            string  // Optional link to parent SitingAnalysis (populated by repo)
	ProposedSiteGeometry  string  // WKT of proposed site
	ConflictSeverity      string  // INFO, WARNING, ERROR, BLOCKER
	ConflictReason        string  // e.g., "Site inside exclusion zone"
	DistanceMeters        float64 // Distance to zone (0 if intersecting)
	OverlapAreaSqm        float64 // Polygon overlap area in m²
	MitigationSuggestions []string
	DetectedAt            time.Time
}

// RiskScore aggregates conflict analysis for siting decision.
type RiskScore struct {
	TotalConflicts        int32
	BlockerCount          int32
	ErrorCount            int32
	WarningCount          int32
	InfoCount             int32
	OverallRiskPercentage float32 // 0-100, higher = more restrictive
	IsSiteable            bool    // True if conflicts are resolvable
	SitingRecommendation  string  // Human-readable assessment
}

// SitingAnalysis holds full results of proposed site conflict checking.
type SitingAnalysis struct {
	AnalysisID           string // UUID
	ProjectID            string
	ProposedSiteGeometry string // WKT
	ProposedSiteBounds   BoundingBox2D
	Conflicts            []SitingConflict
	RiskScore            RiskScore
	TotalZonesChecked    int32
	AnalyzedBy           string // User who initiated the analysis
	AnalyzedAt           time.Time
}

// ZonePermission controls access to shared constraint zones.
type ZonePermission struct {
	ID         int64
	ZoneID     string
	UserID     string
	Permission string // VIEW, EDIT, ADMIN
	GrantedBy  string // User ID who granted permission
	GrantedAt  time.Time
}

// BoundingBox2D represents geographic bounds (reused from common models).
type BoundingBox2D struct {
	MinX float64
	MinY float64
	MaxX float64
	MaxY float64
}

// ZoneQueryFilter is used for searching and filtering zones.
type ZoneQueryFilter struct {
	ProjectID     string
	ZoneType      string
	ZoneCategory  string
	ZoneStatus    string
	SearchQuery   string
	CreatedByUser string
	IsPublicOnly  bool
	Limit         int32
	Offset        int32
}

// SitingConflictAnalysisRequest bundles parameters for conflict checking.
type SitingConflictAnalysisRequest struct {
	ProjectID               string
	ProposedSiteGeometryWKT string
	ProposedGeometryType    string
	ProposedSiteBounds      BoundingBox2D
	CheckZoneTypes          []string // Which zone types to check (empty = all)
	IncludeBufferZones      bool
	IncludeExpiredZones     bool
	AnalyzedByUser          string
}

// ZoneImportRequest represents bulk zone import from external source.
type ZoneImportRequest struct {
	ProjectID      string
	Source         string // Import source identifier
	Zones          []ConstraintZone
	ImportedByUser string
	ImportedAt     time.Time
}

// ZoneImportResult holds import operation results.
type ZoneImportResult struct {
	ImportID     string
	ProjectID    string
	TotalZones   int32
	SuccessCount int32
	FailureCount int32
	Errors       []ZoneImportError
	ImportedAt   time.Time
}

// ZoneImportError details a single failed zone import.
type ZoneImportError struct {
	RowNumber      int32
	ZoneName       string
	Error          string
	Recommendation string
}

// ConstraintZoneStats aggregates zone statistics for a project.
type ConstraintZoneStats struct {
	ProjectID            string
	TotalZones           int32
	ActiveZones          int32
	InactiveZones        int32
	ExpiredZones         int32
	ByType               map[string]int32 // Count by zone type
	ByCategory           map[string]int32 // Count by category
	TotalAreaCoveredSqkm float64
	LastZoneModifiedAt   time.Time
}

// SitingDecisionRecord documents a siting decision made using zone analysis.
type SitingDecisionRecord struct {
	DecisionID             string
	ProjectID              string
	ProposedSiteID         string // Reference to landing site
	AnalysisID             string // Reference to SitingAnalysis
	DecisionMadeBy         string // User ID
	Decision               string // APPROVED, REJECTED, DEFER
	Rationale              string
	ApprovedZoneExceptions []string // Zone IDs where conflicts were waived
	MitigationPlan         string   // How conflicts will be mitigated
	DecidedAt              time.Time
}
