package handler

import (
	"context"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	structuralv1 "github.com/solar3d/solar3d/gen/structural/v1"
	structuralv1connect "github.com/solar3d/solar3d/gen/structural/v1/structuralv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/structural-service/internal/domain"
	"solar3d/structural-service/internal/service"
)

type ConnectStructuralService struct {
	svc *service.Service
}

var _ structuralv1connect.StructuralServiceHandler = (*ConnectStructuralService)(nil)

func NewConnectStructuralService(svc *service.Service) *ConnectStructuralService {
	return &ConnectStructuralService{svc: svc}
}

func (h *ConnectStructuralService) CreateDesign(
	ctx context.Context,
	req *connect.Request[structuralv1.CreateDesignRequest],
) (*connect.Response[structuralv1.CreateDesignResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	design, err := h.svc.CreateDesign(ctx, domain.CreateDesignRequest{ProjectID: projectID, Name: req.Msg.GetName()})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.CreateDesignResponse{Design: structuralDesignToProto(design)}), nil
}

func (h *ConnectStructuralService) GetDesign(
	ctx context.Context,
	req *connect.Request[structuralv1.GetDesignRequest],
) (*connect.Response[structuralv1.GetDesignResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design id"))
	}
	design, err := h.svc.GetDesign(ctx, designID)
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.GetDesignResponse{Design: structuralDesignToProto(design)}), nil
}

func (h *ConnectStructuralService) ListDesigns(
	ctx context.Context,
	req *connect.Request[structuralv1.ListDesignsRequest],
) (*connect.Response[structuralv1.ListDesignsResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	designs, err := h.svc.ListDesigns(ctx, projectID)
	if err != nil {
		return nil, structuralConnectError(err)
	}
	out := make([]*structuralv1.StructuralDesign, 0, len(designs))
	for i := range designs {
		d := designs[i]
		out = append(out, structuralDesignToProto(&d))
	}
	return connect.NewResponse(&structuralv1.ListDesignsResponse{Designs: out}), nil
}

func (h *ConnectStructuralService) DeleteDesign(
	ctx context.Context,
	req *connect.Request[structuralv1.DeleteDesignRequest],
) (*connect.Response[structuralv1.DeleteDesignResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design id"))
	}
	if err := h.svc.DeleteDesign(ctx, designID); err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.DeleteDesignResponse{}), nil
}

func (h *ConnectStructuralService) ComputeDeadLoad(
	ctx context.Context,
	req *connect.Request[structuralv1.ComputeDeadLoadRequest],
) (*connect.Response[structuralv1.ComputeDeadLoadResponse], error) {
	designID, err := parseOptionalUUID(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	resp, err := h.svc.ComputeDeadLoad(ctx, domain.ComputeDeadLoadRequest{
		DesignID:             designID,
		PanelCount:           int(req.Msg.GetPanelCount()),
		PanelMassKg:          req.Msg.GetPanelMassKg(),
		MountingMassPerPanel: req.Msg.GetMountingMassPerPanelKg(),
		CableMassKg:          req.Msg.GetCableMassKg(),
	})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.ComputeDeadLoadResponse{
		DesignId:            resp.DesignID.String(),
		PanelMassTotalKg:    resp.PanelMassTotalKg,
		MountingMassTotalKg: resp.MountingMassTotalKg,
		CableMassKg:         resp.CableMassKg,
		TotalMassKg:         resp.TotalMassKg,
		DeadLoadKn:          resp.DeadLoadKN,
		Equation:            resp.Equation,
	}), nil
}

func (h *ConnectStructuralService) ComputeWindLoad(
	ctx context.Context,
	req *connect.Request[structuralv1.ComputeWindLoadRequest],
) (*connect.Response[structuralv1.ComputeWindLoadResponse], error) {
	designID, err := parseOptionalUUID(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	resp, err := h.svc.ComputeWindLoad(ctx, domain.ComputeWindLoadRequest{
		DesignID:          designID,
		WindSpeedMS:       req.Msg.GetWindSpeedMS(),
		Exposure:          domain.ExposureCategory(req.Msg.GetExposure()),
		HeightM:           req.Msg.GetHeightM(),
		PanelTiltDeg:      req.Msg.GetPanelTiltDeg(),
		TotalPanelAreaSqm: req.Msg.GetTotalPanelAreaSqm(),
		Kzt:               req.Msg.GetKZt(),
		Kd:                req.Msg.GetKD(),
		GustFactor:        req.Msg.GetGustFactor(),
	})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.ComputeWindLoadResponse{
		DesignId:         resp.DesignID.String(),
		KZ:               resp.Kz,
		QZPa:             resp.QzPa,
		CP:               resp.Cp,
		PressurePa:       resp.PressurePa,
		TotalWindForceKn: resp.TotalWindForceKN,
		WindUpliftKn:     resp.WindUpliftKN,
		Equation:         resp.Equation,
	}), nil
}

func (h *ConnectStructuralService) ComputeSeismicLoad(
	ctx context.Context,
	req *connect.Request[structuralv1.ComputeSeismicLoadRequest],
) (*connect.Response[structuralv1.ComputeSeismicLoadResponse], error) {
	designID, err := parseOptionalUUID(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	resp, err := h.svc.ComputeSeismicLoad(ctx, domain.ComputeSeismicLoadRequest{
		DesignID:         designID,
		Sds:              req.Msg.GetSds(),
		TotalMassKg:      req.Msg.GetTotalMassKg(),
		RFactor:          req.Msg.GetRFactor(),
		ImportanceFactor: req.Msg.GetImportanceFactor(),
		CsOverride:       req.Msg.GetCsOverride(),
	})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.ComputeSeismicLoadResponse{
		DesignId:        resp.DesignID.String(),
		Cs:              resp.Cs,
		SeismicWeightKn: resp.SeismicWeightKN,
		BaseShearKn:     resp.BaseShearKN,
		Equation:        0,
		EquationStr:     resp.Equation,
	}), nil
}

func (h *ConnectStructuralService) ComputeFoundationRequirement(
	ctx context.Context,
	req *connect.Request[structuralv1.ComputeFoundationRequirementRequest],
) (*connect.Response[structuralv1.ComputeFoundationRequirementResponse], error) {
	designID, err := parseOptionalUUID(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	resp, err := h.svc.ComputeFoundationRequirement(ctx, domain.ComputeFoundationRequirementRequest{
		DesignID:       designID,
		DeadLoadKN:     req.Msg.GetDeadLoadKn(),
		WindLoadKN:     req.Msg.GetWindLoadKn(),
		SeismicLoadKN:  req.Msg.GetSeismicLoadKn(),
		FoundationType: domain.FoundationType(req.Msg.GetFoundationType()),
		PileCapacityKN: req.Msg.GetPileCapacityKn(),
		TotalAreaSqm:   req.Msg.GetTotalAreaSqm(),
	})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.ComputeFoundationRequirementResponse{
		DesignId: resp.DesignID.String(),
		Result: &structuralv1.FoundationResult{
			PileCount:       int32(resp.Result.PileCount),
			DesignLoadKn:    resp.Result.DesignLoadKN,
			PileSpacingM:    resp.Result.PileSpacingM,
			FoundationType:  structuralv1.FoundationType(resp.Result.FoundationType),
			PileCapacityKn:  resp.Result.PileCapacityKN,
			LoadCombination: resp.Result.LoadCombination,
		},
		Equation: resp.Equation,
	}), nil
}

func (h *ConnectStructuralService) ValidateStructuralDesign(
	ctx context.Context,
	req *connect.Request[structuralv1.ValidateStructuralDesignRequest],
) (*connect.Response[structuralv1.ValidateStructuralDesignResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	resp, err := h.svc.ValidateStructuralDesign(ctx, domain.ValidateStructuralDesignRequest{
		DesignID:              designID,
		MaxWindPressurePa:     req.Msg.GetMaxWindPressurePa(),
		MaxSeismicCoefficient: req.Msg.GetMaxSeismicCoefficient(),
	})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	violations := make([]*structuralv1.StructuralViolation, 0, len(resp.Violations))
	for i := range resp.Violations {
		v := resp.Violations[i]
		violations = append(violations, &structuralv1.StructuralViolation{
			Code:    v.Code,
			Message: v.Message,
			Limit:   v.Limit,
			Actual:  v.Actual,
		})
	}
	return connect.NewResponse(&structuralv1.ValidateStructuralDesignResponse{
		Valid:            resp.Valid,
		Violations:       violations,
		UtilizationRatio: resp.UtilizationRatio,
	}), nil
}

func (h *ConnectStructuralService) SubmitForReview(
	ctx context.Context,
	req *connect.Request[structuralv1.SubmitForReviewRequest],
) (*connect.Response[structuralv1.SubmitForReviewResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	design, err := h.svc.SubmitForReview(ctx, domain.ReviewRequest{DesignID: designID, Actor: req.Msg.GetSubmittedBy(), Notes: req.Msg.GetNotes()})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.SubmitForReviewResponse{Design: structuralDesignToProto(design)}), nil
}

func (h *ConnectStructuralService) ApproveDesign(
	ctx context.Context,
	req *connect.Request[structuralv1.ApproveDesignRequest],
) (*connect.Response[structuralv1.ApproveDesignResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	design, err := h.svc.ApproveDesign(ctx, domain.ReviewRequest{DesignID: designID, Actor: req.Msg.GetApprovedBy(), Notes: req.Msg.GetNotes()})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.ApproveDesignResponse{Design: structuralDesignToProto(design)}), nil
}

func (h *ConnectStructuralService) RejectDesign(
	ctx context.Context,
	req *connect.Request[structuralv1.RejectDesignRequest],
) (*connect.Response[structuralv1.RejectDesignResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	design, err := h.svc.RejectDesign(ctx, domain.ReviewRequest{DesignID: designID, Actor: req.Msg.GetRejectedBy(), Notes: req.Msg.GetReason()})
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.RejectDesignResponse{Design: structuralDesignToProto(design)}), nil
}

func (h *ConnectStructuralService) GenerateStructuralReport(
	ctx context.Context,
	req *connect.Request[structuralv1.GenerateStructuralReportRequest],
) (*connect.Response[structuralv1.GenerateStructuralReportResponse], error) {
	designID, err := uuid.Parse(req.Msg.GetDesignId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid design_id"))
	}
	report, err := h.svc.GenerateStructuralReport(ctx, designID)
	if err != nil {
		return nil, structuralConnectError(err)
	}
	design, err := h.svc.GetDesign(ctx, designID)
	if err != nil {
		return nil, structuralConnectError(err)
	}
	return connect.NewResponse(&structuralv1.GenerateStructuralReportResponse{
		DesignId:    designID.String(),
		ReportText:  report,
		ReviewState: structuralv1.ReviewState(design.ReviewState),
	}), nil
}

func structuralDesignToProto(d *domain.StructuralDesign) *structuralv1.StructuralDesign {
	var foundation *structuralv1.FoundationResult
	if d.Foundation != nil {
		foundation = &structuralv1.FoundationResult{
			PileCount:       int32(d.Foundation.PileCount),
			DesignLoadKn:    d.Foundation.DesignLoadKN,
			PileSpacingM:    d.Foundation.PileSpacingM,
			FoundationType:  structuralv1.FoundationType(d.Foundation.FoundationType),
			PileCapacityKn:  d.Foundation.PileCapacityKN,
			LoadCombination: d.Foundation.LoadCombination,
		}
	}
	return &structuralv1.StructuralDesign{
		Id:              d.ID.String(),
		ProjectId:       d.ProjectID.String(),
		Name:            d.Name,
		ReviewState:     structuralv1.ReviewState(d.ReviewState),
		ReviewedBy:      d.ReviewedBy,
		ReviewNotes:     d.ReviewNotes,
		CreatedAt:       timestamppb.New(d.CreatedAt),
		UpdatedAt:       timestamppb.New(d.UpdatedAt),
		DeadLoadKn:      d.DeadLoadKN,
		WindLoadKn:      d.WindLoadKN,
		SeismicLoadKn:   d.SeismicLoadKN,
		GoverningLoadKn: d.GoverningLoadKN,
		Foundation:      foundation,
	}
}

func parseOptionalUUID(raw string) (uuid.UUID, error) {
	if raw == "" {
		return uuid.Nil, nil
	}
	return uuid.Parse(raw)
}

func structuralConnectError(err error) error {
	return connect.NewError(connect.CodeInvalidArgument, err)
}
