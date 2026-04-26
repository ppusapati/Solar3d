package handler

import (
	"context"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	commissioningv1 "p9e.in/samavaya/solar3d/gen/commissioning/v1"
	commissioningv1connect "p9e.in/samavaya/solar3d/gen/commissioning/v1/commissioningv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"
	paginationv1 "p9e.in/samavaya/packages/api/v1/pagination"
	pkgErrors "p9e.in/samavaya/packages/errors"

	"p9e.in/samavaya/solar3d/commissioning-service/internal/domain"
	"p9e.in/samavaya/solar3d/commissioning-service/internal/service"
)

// ConnectCommissioningService implements commissioningv1connect.CommissioningServiceHandler.
type ConnectCommissioningService struct {
	svc *service.Service
}

var _ commissioningv1connect.CommissioningServiceHandler = (*ConnectCommissioningService)(nil)

func NewConnectCommissioningService(svc *service.Service) *ConnectCommissioningService {
	return &ConnectCommissioningService{svc: svc}
}

// ── Checklist ─────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) CreateChecklist(
	ctx context.Context, req *connect.Request[commissioningv1.CreateChecklistRequest],
) (*connect.Response[commissioningv1.CreateChecklistResponse], error) {
	pid, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project id: %v", err).ToConnectError()
	}
	cl, err := s.svc.CreateChecklist(ctx, domain.CreateChecklistRequest{
		ProjectID: pid,
		Name:      req.Msg.GetName(),
		CreatedBy: req.Msg.GetCreatedBy(),
	})
	if err != nil {
		return nil, pkgErrors.Internal("create checklist failed", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.CreateChecklistResponse{
		Checklist: checklistToProto(cl),
	}), nil
}

func (s *ConnectCommissioningService) GetChecklist(
	ctx context.Context, req *connect.Request[commissioningv1.GetChecklistRequest],
) (*connect.Response[commissioningv1.GetChecklistResponse], error) {
	id, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid checklist id: %v", err).ToConnectError()
	}
	cl, err := s.svc.GetChecklist(ctx, id)
	if err != nil {
		return nil, pkgErrors.NotFound("checklist", id.String()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.GetChecklistResponse{
		Checklist: checklistToProto(cl),
	}), nil
}

func (s *ConnectCommissioningService) ListChecklists(
	ctx context.Context, req *connect.Request[commissioningv1.ListChecklistsRequest],
) (*connect.Response[commissioningv1.ListChecklistsResponse], error) {
	pid, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project id: %v", err).ToConnectError()
	}
	cls, err := s.svc.ListChecklists(ctx, pid)
	if err != nil {
		return nil, pkgErrors.Internal("list checklists failed", err.Error()).ToConnectError()
	}

	pagination := req.Msg.GetPagination()
	offset := pagination.GetPageOffset()
	size := pagination.GetPageSize()
	if size <= 0 {
		size = 20
	}
	if size > 100 {
		size = 100
	}

	totalCount := int32(len(cls))
	start := int(offset)
	if start > len(cls) {
		start = len(cls)
	}
	end := start + int(size)
	if end > len(cls) {
		end = len(cls)
	}

	paged := cls[start:end]
	protos := make([]*commissioningv1.CommissioningChecklist, 0, len(paged))
	for i := range paged {
		protos = append(protos, checklistToProto(&paged[i]))
	}
	return connect.NewResponse(&commissioningv1.ListChecklistsResponse{
		Checklists: protos,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: totalCount,
			PageOffset: int32(start),
			PageSize:   size,
			HasNext:    end < len(cls),
		},
	}), nil
}

// ── ChecklistItem ─────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) AddChecklistItem(
	ctx context.Context, req *connect.Request[commissioningv1.AddChecklistItemRequest],
) (*connect.Response[commissioningv1.AddChecklistItemResponse], error) {
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid checklist id: %v", err).ToConnectError()
	}
	item, err := s.svc.AddChecklistItem(ctx, domain.AddChecklistItemRequest{
		ChecklistID: clID,
		Description: req.Msg.GetDescription(),
		Section:     domain.ChecklistSection(req.Msg.GetSection()),
		Required:    req.Msg.GetRequired(),
		Sequence:    req.Msg.GetSequence(),
	})
	if err != nil {
		return nil, pkgErrors.Internal("add checklist item failed", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.AddChecklistItemResponse{
		Item: itemToProto(item),
	}), nil
}

func (s *ConnectCommissioningService) UpdateChecklistItem(
	ctx context.Context, req *connect.Request[commissioningv1.UpdateChecklistItemRequest],
) (*connect.Response[commissioningv1.UpdateChecklistItemResponse], error) {
	itemID, err := uuid.Parse(req.Msg.GetItemId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid item id: %v", err).ToConnectError()
	}
	item, err := s.svc.UpdateChecklistItem(ctx, domain.UpdateChecklistItemRequest{
		ItemID:      itemID,
		Status:      domain.ChecklistItemStatus(req.Msg.GetStatus()),
		CompletedBy: req.Msg.GetCompletedBy(),
		Notes:       req.Msg.GetNotes(),
	})
	if err != nil {
		return nil, pkgErrors.Internal("update checklist item failed", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.UpdateChecklistItemResponse{
		Item: itemToProto(item),
	}), nil
}

// ── Signoff ───────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) SignOffChecklist(
	ctx context.Context, req *connect.Request[commissioningv1.SignOffChecklistRequest],
) (*connect.Response[commissioningv1.SignOffChecklistResponse], error) {
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid checklist id: %v", err).ToConnectError()
	}
	signoff, updated, err := s.svc.SignOffChecklist(ctx, domain.SignOffChecklistRequest{
		ChecklistID: clID,
		SignedBy:    req.Msg.GetSignedBy(),
		Role:        req.Msg.GetRole(),
		Comments:    req.Msg.GetComments(),
	})
	if err != nil {
		return nil, pkgErrors.NewValidation("failed_precondition", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.SignOffChecklistResponse{
		Signoff:          signoffToProto(signoff),
		UpdatedChecklist: checklistToProto(updated),
	}), nil
}

func (s *ConnectCommissioningService) ListSignoffs(
	ctx context.Context, req *connect.Request[commissioningv1.ListSignoffsRequest],
) (*connect.Response[commissioningv1.ListSignoffsResponse], error) {
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid checklist id: %v", err).ToConnectError()
	}
	signoffs, err := s.svc.ListSignoffs(ctx, clID)
	if err != nil {
		return nil, pkgErrors.Internal("list signoffs failed", err.Error()).ToConnectError()
	}

	pagination := req.Msg.GetPagination()
	offset := pagination.GetPageOffset()
	size := pagination.GetPageSize()
	if size <= 0 {
		size = 20
	}
	if size > 100 {
		size = 100
	}

	totalCount := int32(len(signoffs))
	start := int(offset)
	if start > len(signoffs) {
		start = len(signoffs)
	}
	end := start + int(size)
	if end > len(signoffs) {
		end = len(signoffs)
	}

	paged := signoffs[start:end]
	protos := make([]*commissioningv1.CommissioningSignoff, 0, len(paged))
	for i := range paged {
		protos = append(protos, signoffToProto(&paged[i]))
	}
	return connect.NewResponse(&commissioningv1.ListSignoffsResponse{
		Signoffs: protos,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: totalCount,
			PageOffset: int32(start),
			PageSize:   size,
			HasNext:    end < len(signoffs),
		},
	}), nil
}

// ── Handover ──────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) CreateHandover(
	ctx context.Context, req *connect.Request[commissioningv1.CreateHandoverRequest],
) (*connect.Response[commissioningv1.CreateHandoverResponse], error) {
	pid, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project id: %v", err).ToConnectError()
	}
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid checklist id: %v", err).ToConnectError()
	}
	var artifactIDs []uuid.UUID
	for _, idStr := range req.Msg.GetArtifactIds() {
		id, err := uuid.Parse(idStr)
		if err != nil {
			return nil, pkgErrors.InvalidArgumentf("invalid artifact id: %v", err).ToConnectError()
		}
		artifactIDs = append(artifactIDs, id)
	}
	h, err := s.svc.CreateHandover(ctx, domain.CreateHandoverRequest{
		ProjectID:    pid,
		ChecklistID:  clID,
		HandedOverBy: req.Msg.GetHandedOverBy(),
		ReceivedBy:   req.Msg.GetReceivedBy(),
		Notes:        req.Msg.GetNotes(),
		ArtifactIDs:  artifactIDs,
	})
	if err != nil {
		return nil, pkgErrors.NewValidation("failed_precondition", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.CreateHandoverResponse{
		Handover: handoverToProto(h),
	}), nil
}

func (s *ConnectCommissioningService) GetHandover(
	ctx context.Context, req *connect.Request[commissioningv1.GetHandoverRequest],
) (*connect.Response[commissioningv1.GetHandoverResponse], error) {
	id, err := uuid.Parse(req.Msg.GetHandoverId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid handover id: %v", err).ToConnectError()
	}
	h, err := s.svc.GetHandover(ctx, id)
	if err != nil {
		return nil, pkgErrors.NotFound("handover", id.String()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.GetHandoverResponse{
		Handover: handoverToProto(h),
	}), nil
}

// ── AsBuilt ───────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) RecordAsBuilt(
	ctx context.Context, req *connect.Request[commissioningv1.RecordAsBuiltRequest],
) (*connect.Response[commissioningv1.RecordAsBuiltResponse], error) {
	pid, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project id: %v", err).ToConnectError()
	}
	a, err := s.svc.RecordAsBuilt(ctx, domain.RecordAsBuiltRequest{
		ProjectID:     pid,
		Name:          req.Msg.GetName(),
		ArtifactType:  domain.AsBuiltArtifactType(req.Msg.GetArtifactType()),
		StorageURL:    req.Msg.GetStorageUrl(),
		UploadedBy:    req.Msg.GetUploadedBy(),
		Description:   req.Msg.GetDescription(),
		FileSizeBytes: req.Msg.GetFileSizeBytes(),
		Revision:      req.Msg.GetRevision(),
	})
	if err != nil {
		return nil, pkgErrors.Internal("record as-built artifact failed", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.RecordAsBuiltResponse{
		Artifact: asBuiltToProto(a),
	}), nil
}

func (s *ConnectCommissioningService) ListAsBuiltArtifacts(
	ctx context.Context, req *connect.Request[commissioningv1.ListAsBuiltArtifactsRequest],
) (*connect.Response[commissioningv1.ListAsBuiltArtifactsResponse], error) {
	pid, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid project id: %v", err).ToConnectError()
	}
	arts, err := s.svc.ListAsBuiltArtifacts(ctx, pid)
	if err != nil {
		return nil, pkgErrors.Internal("list as-built artifacts failed", err.Error()).ToConnectError()
	}

	pagination := req.Msg.GetPagination()
	offset := pagination.GetPageOffset()
	size := pagination.GetPageSize()
	if size <= 0 {
		size = 20
	}
	if size > 100 {
		size = 100
	}

	totalCount := int32(len(arts))
	start := int(offset)
	if start > len(arts) {
		start = len(arts)
	}
	end := start + int(size)
	if end > len(arts) {
		end = len(arts)
	}

	paged := arts[start:end]
	protos := make([]*commissioningv1.AsBuiltArtifact, 0, len(paged))
	for i := range paged {
		protos = append(protos, asBuiltToProto(&paged[i]))
	}
	return connect.NewResponse(&commissioningv1.ListAsBuiltArtifactsResponse{
		Artifacts: protos,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: totalCount,
			PageOffset: int32(start),
			PageSize:   size,
			HasNext:    end < len(arts),
		},
	}), nil
}

// ── Report ─────────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) GenerateCommissioningReport(
	ctx context.Context, req *connect.Request[commissioningv1.GenerateCommissioningReportRequest],
) (*connect.Response[commissioningv1.GenerateCommissioningReportResponse], error) {
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid checklist id: %v", err).ToConnectError()
	}
	report, err := s.svc.GenerateReport(ctx, domain.GenerateReportRequest{ChecklistID: clID})
	if err != nil {
		return nil, pkgErrors.Internal("generate report failed", err.Error()).ToConnectError()
	}
	return connect.NewResponse(&commissioningv1.GenerateCommissioningReportResponse{
		ReportText:  report,
		GeneratedAt: timestamppb.Now(),
	}), nil
}

// ── Mappers ───────────────────────────────────────────────────────────────

func checklistToProto(cl *domain.CommissioningChecklist) *commissioningv1.CommissioningChecklist {
	if cl == nil {
		return nil
	}
	total, completed, failed := cl.DerivedCounts()
	p := &commissioningv1.CommissioningChecklist{
		Id:             cl.ID.String(),
		ProjectId:      cl.ProjectID.String(),
		Name:           cl.Name,
		Status:         commissioningv1.CommissioningStatus(cl.Status),
		CreatedAt:      timestamppb.New(cl.CreatedAt),
		UpdatedAt:      timestamppb.New(cl.UpdatedAt),
		CreatedBy:      cl.CreatedBy,
		TotalItems:     total,
		CompletedItems: completed,
		FailedItems:    failed,
	}
	for i := range cl.Items {
		p.Items = append(p.Items, itemToProto(&cl.Items[i]))
	}
	for i := range cl.Signoffs {
		p.Signoffs = append(p.Signoffs, signoffToProto(&cl.Signoffs[i]))
	}
	return p
}

func itemToProto(item *domain.ChecklistItem) *commissioningv1.ChecklistItem {
	if item == nil {
		return nil
	}
	p := &commissioningv1.ChecklistItem{
		Id:          item.ID.String(),
		ChecklistId: item.ChecklistID.String(),
		Description: item.Description,
		Section:     commissioningv1.ChecklistSection(item.Section),
		Status:      commissioningv1.ChecklistItemStatus(item.Status),
		Required:    item.Required,
		CompletedBy: item.CompletedBy,
		Notes:       item.Notes,
		Sequence:    item.Sequence,
	}
	if item.CompletedAt != nil {
		p.CompletedAt = timestamppb.New(*item.CompletedAt)
	}
	return p
}

func signoffToProto(s *domain.CommissioningSignoff) *commissioningv1.CommissioningSignoff {
	if s == nil {
		return nil
	}
	return &commissioningv1.CommissioningSignoff{
		Id:          s.ID.String(),
		ChecklistId: s.ChecklistID.String(),
		SignedBy:    s.SignedBy,
		Role:        s.Role,
		Comments:    s.Comments,
		SignedAt:    timestamppb.New(s.SignedAt),
	}
}

func handoverToProto(h *domain.HandoverRecord) *commissioningv1.HandoverRecord {
	if h == nil {
		return nil
	}
	p := &commissioningv1.HandoverRecord{
		Id:           h.ID.String(),
		ProjectId:    h.ProjectID.String(),
		ChecklistId:  h.ChecklistID.String(),
		HandedOverBy: h.HandedOverBy,
		ReceivedBy:   h.ReceivedBy,
		Notes:        h.Notes,
		HandoverDate: timestamppb.New(h.HandoverDate),
		CreatedAt:    timestamppb.New(h.CreatedAt),
	}
	for _, id := range h.ArtifactIDs {
		p.ArtifactIds = append(p.ArtifactIds, id.String())
	}
	return p
}

func asBuiltToProto(a *domain.AsBuiltArtifact) *commissioningv1.AsBuiltArtifact {
	if a == nil {
		return nil
	}
	return &commissioningv1.AsBuiltArtifact{
		Id:            a.ID.String(),
		ProjectId:     a.ProjectID.String(),
		Name:          a.Name,
		ArtifactType:  commissioningv1.AsBuiltArtifactType(a.ArtifactType),
		StorageUrl:    a.StorageURL,
		UploadedBy:    a.UploadedBy,
		UploadedAt:    timestamppb.New(a.UploadedAt),
		Description:   a.Description,
		FileSizeBytes: a.FileSizeBytes,
		Revision:      a.Revision,
	}
}

// Ensure time is imported only once.
var _ = time.Now
