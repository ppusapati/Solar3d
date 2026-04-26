package handler

import (
	"context"
	"errors"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	reportv1 "p9e.in/samavaya/solar3d/gen/report/v1"
	reportv1connect "p9e.in/samavaya/solar3d/gen/report/v1/reportv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"p9e.in/samavaya/solar3d/report-service/internal/domain"
	"p9e.in/samavaya/solar3d/report-service/internal/service"
)

type ConnectReportService struct {
	svc *service.ReportService
}

var _ reportv1connect.ReportServiceHandler = (*ConnectReportService)(nil)

func NewConnectReportService(svc *service.ReportService) *ConnectReportService {
	return &ConnectReportService{svc: svc}
}

func (h *ConnectReportService) GenerateReport(ctx context.Context, req *connect.Request[reportv1.GenerateReportRequest]) (*connect.Response[reportv1.GenerateReportResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	report, err := h.svc.GenerateReport(ctx, domain.GenerateReportRequest{
		ProjectID:         projectID,
		Name:              req.Msg.GetName(),
		ReportType:        reportTypeFromProto(req.Msg.GetReportType()),
		Format:            reportFormatFromProto(req.Msg.GetFormat()),
		ApprovalStatus:    req.Msg.GetApprovalStatus(),
		ApprovedBy:        req.Msg.GetApprovedBy(),
		ApprovedAtRFC3339: req.Msg.GetApprovedAtRfc3339(),
	})
	if err != nil {
		return nil, reportConnectError(err)
	}

	return connect.NewResponse(&reportv1.GenerateReportResponse{Report: reportToProto(report)}), nil
}

func (h *ConnectReportService) GetReport(ctx context.Context, req *connect.Request[reportv1.GetReportRequest]) (*connect.Response[reportv1.GetReportResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid report id"))
	}

	report, err := h.svc.GetReport(ctx, id)
	if err != nil {
		return nil, reportConnectError(err)
	}

	return connect.NewResponse(&reportv1.GetReportResponse{Report: reportToProto(report)}), nil
}

func (h *ConnectReportService) ListReports(ctx context.Context, req *connect.Request[reportv1.ListReportsRequest]) (*connect.Response[reportv1.ListReportsResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	reports, err := h.svc.ListReports(ctx, projectID)
	if err != nil {
		return nil, reportConnectError(err)
	}

	out := make([]*reportv1.Report, 0, len(reports))
	for i := range reports {
		r := reports[i]
		out = append(out, reportToProto(&r))
	}

	return connect.NewResponse(&reportv1.ListReportsResponse{Reports: out}), nil
}

func (h *ConnectReportService) DeleteReport(ctx context.Context, req *connect.Request[reportv1.DeleteReportRequest]) (*connect.Response[reportv1.DeleteReportResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid report id"))
	}
	if err := h.svc.DeleteReport(ctx, id); err != nil {
		return nil, reportConnectError(err)
	}
	return connect.NewResponse(&reportv1.DeleteReportResponse{}), nil
}

func (h *ConnectReportService) GenerateBOM(ctx context.Context, req *connect.Request[reportv1.GenerateBOMRequest]) (*connect.Response[reportv1.GenerateBOMResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	bom, err := h.svc.GenerateBOM(ctx, domain.GenerateBOMRequest{ProjectID: projectID})
	if err != nil {
		return nil, reportConnectError(err)
	}
	return connect.NewResponse(&reportv1.GenerateBOMResponse{Bom: bomToProto(bom)}), nil
}

func (h *ConnectReportService) ExportLayout(ctx context.Context, req *connect.Request[reportv1.ExportLayoutRequest]) (*connect.Response[reportv1.ExportLayoutResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	report, err := h.svc.ExportLayout(ctx, domain.ExportLayoutRequest{
		ProjectID:         projectID,
		Format:            reportFormatFromProto(req.Msg.GetFormat()),
		ApprovalStatus:    req.Msg.GetApprovalStatus(),
		ApprovedBy:        req.Msg.GetApprovedBy(),
		ApprovedAtRFC3339: req.Msg.GetApprovedAtRfc3339(),
	})
	if err != nil {
		return nil, reportConnectError(err)
	}
	return connect.NewResponse(&reportv1.ExportLayoutResponse{FilePath: report.FilePath}), nil
}

func reportToProto(r *domain.Report) *reportv1.Report {
	if r == nil {
		return nil
	}
	out := &reportv1.Report{
		Id:         r.ID.String(),
		ProjectId:  r.ProjectID.String(),
		Name:       r.Name,
		ReportType: reportTypeToProto(r.ReportType),
		Format:     reportFormatToProto(r.Format),
		FilePath:   r.FilePath,
		Status:     reportStatusToProto(r.Status),
		CreatedAt:  timestamppb.New(r.CreatedAt),
	}
	if r.CompletedAt != nil {
		out.CompletedAt = timestamppb.New(*r.CompletedAt)
	}
	return out
}

func bomToProto(b *domain.BillOfMaterials) *reportv1.BillOfMaterials {
	if b == nil {
		return nil
	}
	items := make([]*reportv1.BOMItem, 0, len(b.Items))
	for i := range b.Items {
		it := b.Items[i]
		items = append(items, &reportv1.BOMItem{
			Category:      it.Category,
			Name:          it.Name,
			Specification: it.Spec,
			Quantity:      int32(it.Quantity),
			Unit:          it.Unit,
			UnitCost:      it.UnitCost,
			TotalCost:     it.TotalCost,
		})
	}
	return &reportv1.BillOfMaterials{
		Items:             items,
		TotalCost:         b.TotalCost,
		TotalPanels:       int32(b.TotalPanels),
		TotalInverters:    int32(b.TotalInverters),
		TotalTransformers: int32(b.TotalTransformers),
		TotalCableLengthM: b.TotalCableLengthM,
	}
}

func reportTypeFromProto(t reportv1.ReportType) domain.ReportType {
	switch t {
	case reportv1.ReportType_REPORT_TYPE_BILL_OF_MATERIALS:
		return domain.ReportTypeBOM
	case reportv1.ReportType_REPORT_TYPE_PANEL_LAYOUT, reportv1.ReportType_REPORT_TYPE_SITE_LAYOUT:
		return domain.ReportTypeLayout
	case reportv1.ReportType_REPORT_TYPE_ELECTRICAL_DIAGRAM:
		return domain.ReportTypeElectrical
	case reportv1.ReportType_REPORT_TYPE_ENERGY_ESTIMATE:
		return domain.ReportTypeSimulation
	case reportv1.ReportType_REPORT_TYPE_FULL_ENGINEERING:
		return domain.ReportTypeFull
	default:
		return domain.ReportTypeFull
	}
}

func reportTypeToProto(t domain.ReportType) reportv1.ReportType {
	switch t {
	case domain.ReportTypeBOM:
		return reportv1.ReportType_REPORT_TYPE_BILL_OF_MATERIALS
	case domain.ReportTypeLayout:
		return reportv1.ReportType_REPORT_TYPE_PANEL_LAYOUT
	case domain.ReportTypeElectrical:
		return reportv1.ReportType_REPORT_TYPE_ELECTRICAL_DIAGRAM
	case domain.ReportTypeSimulation:
		return reportv1.ReportType_REPORT_TYPE_ENERGY_ESTIMATE
	case domain.ReportTypeFull:
		return reportv1.ReportType_REPORT_TYPE_FULL_ENGINEERING
	default:
		return reportv1.ReportType_REPORT_TYPE_UNSPECIFIED
	}
}

func reportFormatFromProto(f reportv1.ReportFormat) domain.ReportFormat {
	switch f {
	case reportv1.ReportFormat_REPORT_FORMAT_PDF:
		return domain.ReportFormatPDF
	case reportv1.ReportFormat_REPORT_FORMAT_CSV:
		return domain.ReportFormatCSV
	case reportv1.ReportFormat_REPORT_FORMAT_JSON:
		return domain.ReportFormatJSON
	default:
		return domain.ReportFormatPDF
	}
}

func reportFormatToProto(f domain.ReportFormat) reportv1.ReportFormat {
	switch f {
	case domain.ReportFormatPDF:
		return reportv1.ReportFormat_REPORT_FORMAT_PDF
	case domain.ReportFormatCSV:
		return reportv1.ReportFormat_REPORT_FORMAT_CSV
	case domain.ReportFormatJSON:
		return reportv1.ReportFormat_REPORT_FORMAT_JSON
	default:
		return reportv1.ReportFormat_REPORT_FORMAT_UNSPECIFIED
	}
}

func reportStatusToProto(s domain.ReportStatus) reportv1.ReportStatus {
	switch s {
	case domain.ReportStatusPending:
		return reportv1.ReportStatus_REPORT_STATUS_PENDING
	case domain.ReportStatusRunning:
		return reportv1.ReportStatus_REPORT_STATUS_GENERATING
	case domain.ReportStatusCompleted:
		return reportv1.ReportStatus_REPORT_STATUS_COMPLETED
	case domain.ReportStatusFailed:
		return reportv1.ReportStatus_REPORT_STATUS_FAILED
	default:
		return reportv1.ReportStatus_REPORT_STATUS_UNSPECIFIED
	}
}

func reportConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, service.ErrApprovalRequired):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

