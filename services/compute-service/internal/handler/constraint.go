package handler

import (
	"context"
	"fmt"

	"connectrpc.com/connect"
	commonv1 "github.com/solar3d/solar3d/gen/common/v1"
	constraint "github.com/solar3d/solar3d/gen/constraint/v1"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/service"
)

// ConstraintZoneHandler implements constraint zone RPC handlers.
type ConstraintZoneHandler struct {
	service *service.ConstraintZoneService
}

// NewConstraintZoneHandler creates a new handler.
func NewConstraintZoneHandler(svc *service.ConstraintZoneService) *ConstraintZoneHandler {
	return &ConstraintZoneHandler{
		service: svc,
	}
}

// ================== RPC Handlers ==================

// CreateZone creates a new constraint zone.
func (h *ConstraintZoneHandler) CreateZone(ctx context.Context, req *connect.Request[constraint.CreateZoneRequest]) (*connect.Response[constraint.CreateZoneResponse], error) {
	// Extract user from context (simplified)
	userID := "user-123" // In prod: extract from auth context

	// Map proto to model
	zone := &models.ConstraintZone{
		Name:            req.Msg.Name,
		Description:     req.Msg.Description,
		ZoneType:        zoneTypeToString(req.Msg.ZoneType),
		ZoneCategory:    zoneCategoryToString(req.Msg.ZoneCategory),
		ZoneStatus:      "ACTIVE",
		GeometryWKT:     req.Msg.GeometryWkt,
		GeometryType:    req.Msg.GeometryType,
		Source:          req.Msg.Source,
		SourceID:        req.Msg.SourceId,
		BufferDistanceM: req.Msg.BufferDistanceMeters,
		Tags:            req.Msg.Tags,
		Metadata:        req.Msg.Metadata,
		CreatedBy:       userID,
		ProjectID:       req.Msg.ProjectId,
		IsPublic:        req.Msg.IsPublic,
	}

	// Set effective dates
	if req.Msg.EffectiveStart != nil {
		start := req.Msg.EffectiveStart.AsTime()
		zone.EffectiveStartAt = &start
	}
	if req.Msg.EffectiveEnd != nil {
		end := req.Msg.EffectiveEnd.AsTime()
		zone.EffectiveEndAt = &end
	}

	// Create zone
	createdZone, err := h.service.CreateZone(ctx, zone)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("failed to create zone: %w", err))
	}

	// Map model back to proto
	resp := &constraint.CreateZoneResponse{
		ZoneId:    createdZone.ZoneID,
		Zone:      h.modelToProtoZone(createdZone),
		CreatedAt: timestamppb.New(createdZone.CreatedAt),
	}

	return connect.NewResponse(resp), nil
}

// UpdateZone updates an existing zone.
func (h *ConstraintZoneHandler) UpdateZone(ctx context.Context, req *connect.Request[constraint.UpdateZoneRequest]) (*connect.Response[constraint.UpdateZoneResponse], error) {
	userID := "user-123" // Extract from context

	// Get existing zone
	existing, _, err := h.service.ListZones(ctx, "", "", 0, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("zone not found"))
	}

	var zone *models.ConstraintZone
	for _, z := range existing {
		if z.ZoneID == req.Msg.ZoneId {
			zone = z
			break
		}
	}
	if zone == nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("zone not found: %s", req.Msg.ZoneId))
	}

	// Update fields
	if req.Msg.Name != "" {
		zone.Name = req.Msg.Name
	}
	if req.Msg.Description != "" {
		zone.Description = req.Msg.Description
	}
	if req.Msg.ZoneType != constraint.ZoneType_ZONE_TYPE_UNSPECIFIED {
		zone.ZoneType = zoneTypeToString(req.Msg.ZoneType)
	}
	if req.Msg.ZoneCategory != constraint.ZoneCategory_ZONE_CATEGORY_UNSPECIFIED {
		zone.ZoneCategory = zoneCategoryToString(req.Msg.ZoneCategory)
	}
	if req.Msg.ZoneStatus != constraint.ZoneStatus_ZONE_STATUS_UNSPECIFIED {
		zone.ZoneStatus = zoneStatusToString(req.Msg.ZoneStatus)
	}
	if req.Msg.GeometryWkt != "" {
		zone.GeometryWKT = req.Msg.GeometryWkt
	}
	if req.Msg.BufferDistanceMeters > 0 {
		zone.BufferDistanceM = req.Msg.BufferDistanceMeters
	}
	if req.Msg.EffectiveStart != nil {
		start := req.Msg.EffectiveStart.AsTime()
		zone.EffectiveStartAt = &start
	}
	if req.Msg.EffectiveEnd != nil {
		end := req.Msg.EffectiveEnd.AsTime()
		zone.EffectiveEndAt = &end
	}

	zone.CreatedBy = userID
	updatedZone, err := h.service.UpdateZone(ctx, zone)
	if err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("failed to update zone: %w", err))
	}

	resp := &constraint.UpdateZoneResponse{
		Zone:      h.modelToProtoZone(updatedZone),
		UpdatedAt: timestamppb.New(updatedZone.UpdatedAt),
	}

	return connect.NewResponse(resp), nil
}

// DeleteZone soft-deletes a zone.
func (h *ConstraintZoneHandler) DeleteZone(ctx context.Context, req *connect.Request[constraint.DeleteZoneRequest]) (*connect.Response[constraint.DeleteZoneResponse], error) {
	userID := "user-123" // Extract from context

	err := h.service.DeleteZone(ctx, req.Msg.ZoneId, userID, req.Msg.Reason)
	if err != nil {
		if err.Error() == "permission denied" {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &constraint.DeleteZoneResponse{
		ZoneId:    req.Msg.ZoneId,
		DeletedAt: timestamppb.Now(),
	}

	return connect.NewResponse(resp), nil
}

// GetZone retrieves a single zone.
func (h *ConstraintZoneHandler) GetZone(ctx context.Context, req *connect.Request[constraint.GetZoneRequest]) (*connect.Response[constraint.GetZoneResponse], error) {
	zones, _, err := h.service.ListZones(ctx, "", "", 0, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to get zone: %w", err))
	}

	var zone *models.ConstraintZone
	for _, z := range zones {
		if z.ZoneID == req.Msg.ZoneId {
			zone = z
			break
		}
	}

	if zone == nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("zone not found: %s", req.Msg.ZoneId))
	}

	resp := &constraint.GetZoneResponse{
		Zone: h.modelToProtoZone(zone),
	}

	return connect.NewResponse(resp), nil
}

// ListZones retrieves zones with filtering.
func (h *ConstraintZoneHandler) ListZones(ctx context.Context, req *connect.Request[constraint.ListZonesRequest]) (*connect.Response[constraint.ListZonesResponse], error) {
	zoneType := ""
	if req.Msg.ZoneType != constraint.ZoneType_ZONE_TYPE_UNSPECIFIED {
		zoneType = zoneTypeToString(req.Msg.ZoneType)
	}

	zones, total, err := h.service.ListZones(ctx, req.Msg.ProjectId, zoneType, req.Msg.Limit, req.Msg.Offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list zones: %w", err))
	}

	protoZones := make([]*constraint.Zone, len(zones))
	for i, z := range zones {
		protoZones[i] = h.modelToProtoZone(z)
	}

	resp := &constraint.ListZonesResponse{
		Zones:      protoZones,
		TotalCount: total,
	}

	return connect.NewResponse(resp), nil
}

// QueryZonesByLocation finds zones near a location.
func (h *ConstraintZoneHandler) QueryZonesByLocation(ctx context.Context, req *connect.Request[constraint.QueryZonesByLocationRequest]) (*connect.Response[constraint.QueryZonesByLocationResponse], error) {
	zones, _, err := h.service.ListZones(ctx, req.Msg.ProjectId, "", req.Msg.Limit, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to query zones: %w", err))
	}

	protoZones := make([]*constraint.Zone, len(zones))
	for i, z := range zones {
		protoZones[i] = h.modelToProtoZone(z)
	}

	resp := &constraint.QueryZonesByLocationResponse{
		NearbyZones: protoZones,
	}

	return connect.NewResponse(resp), nil
}

// CheckSitingConflicts analyzes conflicts for a proposed site.
func (h *ConstraintZoneHandler) CheckSitingConflicts(ctx context.Context, req *connect.Request[constraint.CheckSitingConflictsRequest]) (*connect.Response[constraint.CheckSitingConflictsResponse], error) {
	conflictReq := &models.SitingConflictAnalysisRequest{
		ProjectID:               req.Msg.ProjectId,
		ProposedSiteGeometryWKT: req.Msg.ProposedSiteGeometryWkt,
		ProposedGeometryType:    req.Msg.GeometryType,
		IncludeBufferZones:      req.Msg.IncludeBufferZones,
		IncludeExpiredZones:     req.Msg.IncludeExpiredZones,
	}

	riskScore, conflicts, err := h.service.CheckSitingConflicts(ctx, conflictReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("failed to analyze conflicts: %w", err))
	}

	protoConflicts := make([]*constraint.SitingConflict, len(conflicts))
	for i, c := range conflicts {
		protoConflicts[i] = h.modelToProtoConflict(c)
	}

	resp := &constraint.CheckSitingConflictsResponse{
		Conflicts:            protoConflicts,
		RiskScore:            h.modelToProtoRiskScore(riskScore),
		SitingRecommendation: riskScore.SitingRecommendation,
		TotalZonesChecked:    riskScore.TotalConflicts,
	}

	return connect.NewResponse(resp), nil
}

// ListZoneCategories returns the zone category taxonomy.
func (h *ConstraintZoneHandler) ListZoneCategories(ctx context.Context, req *connect.Request[constraint.ListZoneCategoriesRequest]) (*connect.Response[constraint.ListZoneCategoriesResponse], error) {
	categories := []*constraint.CategoryDef{
		{
			Category:    constraint.ZoneCategory_ZONE_CATEGORY_GEOLOGICAL,
			DisplayName: "Geological",
			Description: "Seismic zones, fault lines, subsidence areas",
		},
		{
			Category:    constraint.ZoneCategory_ZONE_CATEGORY_ENVIRONMENTAL,
			DisplayName: "Environmental",
			Description: "Wetlands, wildlife habitat, sensitive ecosystems",
		},
		{
			Category:    constraint.ZoneCategory_ZONE_CATEGORY_REGULATORY,
			DisplayName: "Regulatory",
			Description: "Zoning laws, protected areas, permits required",
		},
		{
			Category:    constraint.ZoneCategory_ZONE_CATEGORY_INFRASTRUCTURE,
			DisplayName: "Infrastructure",
			Description: "Power lines, roads, water systems",
		},
		{
			Category:    constraint.ZoneCategory_ZONE_CATEGORY_MILITARY,
			DisplayName: "Military",
			Description: "Military bases, restricted airspace",
		},
		{
			Category:    constraint.ZoneCategory_ZONE_CATEGORY_PROTECTED,
			DisplayName: "Protected",
			Description: "National parks, nature reserves, cultural sites",
		},
	}

	resp := &constraint.ListZoneCategoriesResponse{
		Categories: categories,
	}

	return connect.NewResponse(resp), nil
}

// ================== Helper Functions ==================

func (h *ConstraintZoneHandler) modelToProtoZone(m *models.ConstraintZone) *constraint.Zone {
	z := &constraint.Zone{
		ZoneId:               m.ZoneID,
		Name:                 m.Name,
		Description:          m.Description,
		ZoneType:             stringToZoneType(m.ZoneType),
		ZoneCategory:         stringToZoneCategory(m.ZoneCategory),
		ZoneStatus:           stringToZoneStatus(m.ZoneStatus),
		GeometryWkt:          m.GeometryWKT,
		GeometryType:         m.GeometryType,
		Source:               m.Source,
		SourceId:             m.SourceID,
		BufferDistanceMeters: m.BufferDistanceM,
		Tags:                 m.Tags,
		Metadata:             m.Metadata,
		CreatedBy:            m.CreatedBy,
		ProjectId:            m.ProjectID,
		IsPublic:             m.IsPublic,
		CreatedAt:            timestamppb.New(m.CreatedAt),
		UpdatedAt:            timestamppb.New(m.UpdatedAt),
	}

	if m.EffectiveStartAt != nil {
		z.EffectiveStart = timestamppb.New(*m.EffectiveStartAt)
	}
	if m.EffectiveEndAt != nil {
		z.EffectiveEnd = timestamppb.New(*m.EffectiveEndAt)
	}
	if m.DeletedAt != nil {
		z.DeletedAt = timestamppb.New(*m.DeletedAt)
	}

	if m.BBoxMinX != 0 || m.BBoxMaxX != 0 {
		z.BoundingBox = &commonv1.BoundingBox2D{
			MinX: m.BBoxMinX,
			MinY: m.BBoxMinY,
			MaxX: m.BBoxMaxX,
			MaxY: m.BBoxMaxY,
		}
	}

	return z
}

func (h *ConstraintZoneHandler) modelToProtoConflict(m *models.SitingConflict) *constraint.SitingConflict {
	return &constraint.SitingConflict{
		ConflictId:            m.ConflictID,
		ZoneId:                m.ZoneID,
		ConflictReason:        m.ConflictReason,
		Severity:              stringToConflictSeverity(m.ConflictSeverity),
		DistanceMeters:        float32(m.DistanceMeters),
		OverlapAreaSqm:        float32(m.OverlapAreaSqm),
		MitigationSuggestions: m.MitigationSuggestions,
	}
}

func (h *ConstraintZoneHandler) modelToProtoRiskScore(m *models.RiskScore) *constraint.RiskScore {
	return &constraint.RiskScore{
		TotalConflicts:        m.TotalConflicts,
		BlockerCount:          m.BlockerCount,
		ErrorCount:            m.ErrorCount,
		WarningCount:          m.WarningCount,
		OverallRiskPercentage: m.OverallRiskPercentage,
		IsSiteable:            m.IsSiteable,
	}
}

// ================== Enum Conversion Functions ==================

func zoneTypeToString(t constraint.ZoneType) string {
	switch t {
	case constraint.ZoneType_ZONE_TYPE_EXCLUSION:
		return "EXCLUSION"
	case constraint.ZoneType_ZONE_TYPE_INCLUSION:
		return "INCLUSION"
	case constraint.ZoneType_ZONE_TYPE_BUFFER:
		return "BUFFER"
	default:
		return "EXCLUSION"
	}
}

func stringToZoneType(s string) constraint.ZoneType {
	switch s {
	case "INCLUSION":
		return constraint.ZoneType_ZONE_TYPE_INCLUSION
	case "BUFFER":
		return constraint.ZoneType_ZONE_TYPE_BUFFER
	case "EXCLUSION":
		fallthrough
	default:
		return constraint.ZoneType_ZONE_TYPE_EXCLUSION
	}
}

func zoneCategoryToString(c constraint.ZoneCategory) string {
	switch c {
	case constraint.ZoneCategory_ZONE_CATEGORY_GEOLOGICAL:
		return "GEOLOGICAL"
	case constraint.ZoneCategory_ZONE_CATEGORY_ENVIRONMENTAL:
		return "ENVIRONMENTAL"
	case constraint.ZoneCategory_ZONE_CATEGORY_REGULATORY:
		return "REGULATORY"
	case constraint.ZoneCategory_ZONE_CATEGORY_INFRASTRUCTURE:
		return "INFRASTRUCTURE"
	case constraint.ZoneCategory_ZONE_CATEGORY_MILITARY:
		return "MILITARY"
	case constraint.ZoneCategory_ZONE_CATEGORY_PROTECTED:
		return "PROTECTED"
	default:
		return "ENVIRONMENTAL"
	}
}

func stringToZoneCategory(s string) constraint.ZoneCategory {
	switch s {
	case "GEOLOGICAL":
		return constraint.ZoneCategory_ZONE_CATEGORY_GEOLOGICAL
	case "REGULATORY":
		return constraint.ZoneCategory_ZONE_CATEGORY_REGULATORY
	case "INFRASTRUCTURE":
		return constraint.ZoneCategory_ZONE_CATEGORY_INFRASTRUCTURE
	case "MILITARY":
		return constraint.ZoneCategory_ZONE_CATEGORY_MILITARY
	case "PROTECTED":
		return constraint.ZoneCategory_ZONE_CATEGORY_PROTECTED
	case "ENVIRONMENTAL":
		fallthrough
	default:
		return constraint.ZoneCategory_ZONE_CATEGORY_ENVIRONMENTAL
	}
}

func zoneStatusToString(s constraint.ZoneStatus) string {
	switch s {
	case constraint.ZoneStatus_ZONE_STATUS_ACTIVE:
		return "ACTIVE"
	case constraint.ZoneStatus_ZONE_STATUS_INACTIVE:
		return "INACTIVE"
	case constraint.ZoneStatus_ZONE_STATUS_EXPIRED:
		return "EXPIRED"
	case constraint.ZoneStatus_ZONE_STATUS_PENDING:
		return "PENDING"
	default:
		return "ACTIVE"
	}
}

func stringToZoneStatus(s string) constraint.ZoneStatus {
	switch s {
	case "INACTIVE":
		return constraint.ZoneStatus_ZONE_STATUS_INACTIVE
	case "EXPIRED":
		return constraint.ZoneStatus_ZONE_STATUS_EXPIRED
	case "PENDING":
		return constraint.ZoneStatus_ZONE_STATUS_PENDING
	case "ACTIVE":
		fallthrough
	default:
		return constraint.ZoneStatus_ZONE_STATUS_ACTIVE
	}
}

func stringToConflictSeverity(s string) constraint.ConflictSeverity {
	switch s {
	case "WARNING":
		return constraint.ConflictSeverity_CONFLICT_SEVERITY_WARNING
	case "ERROR":
		return constraint.ConflictSeverity_CONFLICT_SEVERITY_ERROR
	case "BLOCKER":
		return constraint.ConflictSeverity_CONFLICT_SEVERITY_BLOCKER
	case "INFO":
		fallthrough
	default:
		return constraint.ConflictSeverity_CONFLICT_SEVERITY_INFO
	}
}
