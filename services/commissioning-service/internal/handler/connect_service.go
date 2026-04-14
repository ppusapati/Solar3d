package handler

import (
	"context"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	commissioningv1 "github.com/solar3d/solar3d/gen/commissioning/v1"
	commissioningv1connect "github.com/solar3d/solar3d/gen/commissioning/v1/commissioningv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/commissioning-service/internal/domain"
	"solar3d/commissioning-service/internal/service"
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	cl, err := s.svc.CreateChecklist(ctx, domain.CreateChecklistRequest{
		ProjectID: pid,
		Name:      req.Msg.GetName(),
		CreatedBy: req.Msg.GetCreatedBy(),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	cl, err := s.svc.GetChecklist(ctx, id)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	cls, err := s.svc.ListChecklists(ctx, pid)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	var protos []*commissioningv1.CommissioningChecklist
	for i := range cls {
		protos = append(protos, checklistToProto(&cls[i]))
	}
	return connect.NewResponse(&commissioningv1.ListChecklistsResponse{
		Checklists: protos,
	}), nil
}

// ── ChecklistItem ─────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) AddChecklistItem(
	ctx context.Context, req *connect.Request[commissioningv1.AddChecklistItemRequest],
) (*connect.Response[commissioningv1.AddChecklistItemResponse], error) {
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	item, err := s.svc.AddChecklistItem(ctx, domain.AddChecklistItemRequest{
		ChecklistID: clID,
		Description: req.Msg.GetDescription(),
		Section:     domain.ChecklistSection(req.Msg.GetSection()),
		Required:    req.Msg.GetRequired(),
		Sequence:    req.Msg.GetSequence(),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	item, err := s.svc.UpdateChecklistItem(ctx, domain.UpdateChecklistItemRequest{
		ItemID:      itemID,
		Status:      domain.ChecklistItemStatus(req.Msg.GetStatus()),
		CompletedBy: req.Msg.GetCompletedBy(),
		Notes:       req.Msg.GetNotes(),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	signoff, updated, err := s.svc.SignOffChecklist(ctx, domain.SignOffChecklistRequest{
		ChecklistID: clID,
		SignedBy:    req.Msg.GetSignedBy(),
		Role:        req.Msg.GetRole(),
		Comments:    req.Msg.GetComments(),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	signoffs, err := s.svc.ListSignoffs(ctx, clID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	var protos []*commissioningv1.CommissioningSignoff
	for i := range signoffs {
		protos = append(protos, signoffToProto(&signoffs[i]))
	}
	return connect.NewResponse(&commissioningv1.ListSignoffsResponse{
		Signoffs: protos,
	}), nil
}

// ── Handover ──────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) CreateHandover(
	ctx context.Context, req *connect.Request[commissioningv1.CreateHandoverRequest],
) (*connect.Response[commissioningv1.CreateHandoverResponse], error) {
	pid, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	var artifactIDs []uuid.UUID
	for _, idStr := range req.Msg.GetArtifactIds() {
		id, err := uuid.Parse(idStr)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
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
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	h, err := s.svc.GetHandover(ctx, id)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
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
		return nil, connect.NewError(connect.CodeInternal, err)
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
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	arts, err := s.svc.ListAsBuiltArtifacts(ctx, pid)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	var protos []*commissioningv1.AsBuiltArtifact
	for i := range arts {
		protos = append(protos, asBuiltToProto(&arts[i]))
	}
	return connect.NewResponse(&commissioningv1.ListAsBuiltArtifactsResponse{
		Artifacts: protos,
	}), nil
}

// ── Report ─────────────────────────────────────────────────────────────────

func (s *ConnectCommissioningService) GenerateCommissioningReport(
	ctx context.Context, req *connect.Request[commissioningv1.GenerateCommissioningReportRequest],
) (*connect.Response[commissioningv1.GenerateCommissioningReportResponse], error) {
	clID, err := uuid.Parse(req.Msg.GetChecklistId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	report, err := s.svc.GenerateReport(ctx, domain.GenerateReportRequest{ChecklistID: clID})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
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
