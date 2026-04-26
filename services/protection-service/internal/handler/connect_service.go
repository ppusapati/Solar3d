package handler

import (
	"context"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	protectionv1 "p9e.in/samavaya/solar3d/gen/protection/v1"
	protectionv1connect "p9e.in/samavaya/solar3d/gen/protection/v1/protectionv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"p9e.in/samavaya/solar3d/protection-service/internal/domain"
	"p9e.in/samavaya/solar3d/protection-service/internal/service"
)

type ConnectProtectionService struct {
	svc *service.Service
}

var _ protectionv1connect.ProtectionServiceHandler = (*ConnectProtectionService)(nil)

func NewConnectProtectionService(svc *service.Service) *ConnectProtectionService {
	return &ConnectProtectionService{svc: svc}
}

func (h *ConnectProtectionService) CreateStudy(
	ctx context.Context,
	req *connect.Request[protectionv1.CreateStudyRequest],
) (*connect.Response[protectionv1.CreateStudyResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	study, err := h.svc.CreateStudy(ctx, domain.CreateStudyRequest{
		ProjectID:         projectID,
		Name:              req.Msg.GetName(),
		SystemVoltageKV:   req.Msg.GetSystemVoltageKv(),
		SourceImpedancePU: req.Msg.GetSourceImpedancePu(),
		MVABase:           req.Msg.GetMvaBase(),
	})
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.CreateStudyResponse{Study: protectionStudyToProto(study)}), nil
}

func (h *ConnectProtectionService) GetStudy(
	ctx context.Context,
	req *connect.Request[protectionv1.GetStudyRequest],
) (*connect.Response[protectionv1.GetStudyResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid id"))
	}
	study, err := h.svc.GetStudy(ctx, studyID)
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.GetStudyResponse{Study: protectionStudyToProto(study)}), nil
}

func (h *ConnectProtectionService) ListStudies(
	ctx context.Context,
	req *connect.Request[protectionv1.ListStudiesRequest],
) (*connect.Response[protectionv1.ListStudiesResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	studies, err := h.svc.ListStudies(ctx, projectID)
	if err != nil {
		return nil, protectionConnectError(err)
	}
	out := make([]*protectionv1.ProtectionStudy, 0, len(studies))
	for i := range studies {
		s := studies[i]
		out = append(out, protectionStudyToProto(&s))
	}
	return connect.NewResponse(&protectionv1.ListStudiesResponse{Studies: out}), nil
}

func (h *ConnectProtectionService) DeleteStudy(
	ctx context.Context,
	req *connect.Request[protectionv1.DeleteStudyRequest],
) (*connect.Response[protectionv1.DeleteStudyResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid id"))
	}
	if err := h.svc.DeleteStudy(ctx, studyID); err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.DeleteStudyResponse{}), nil
}

func (h *ConnectProtectionService) ComputeShortCircuit(
	ctx context.Context,
	req *connect.Request[protectionv1.ComputeShortCircuitRequest],
) (*connect.Response[protectionv1.ComputeShortCircuitResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetStudyId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid study_id"))
	}
	resp, err := h.svc.ComputeShortCircuit(ctx, domain.ComputeShortCircuitRequest{
		StudyID:                   studyID,
		VoltageKV:                 req.Msg.GetVoltageKv(),
		SourceImpedanceOhm:        req.Msg.GetSourceImpedanceOhm(),
		CableResistanceOhm:        req.Msg.GetCableResistanceOhm(),
		CableReactanceOhm:         req.Msg.GetCableReactanceOhm(),
		ZeroSeqImpedanceOhm:       req.Msg.GetZeroSeqImpedanceOhm(),
		IncludeSingleLineToGround: req.Msg.GetIncludeSingleLineToGround(),
	})
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.ComputeShortCircuitResponse{
		StudyId:          resp.StudyID.String(),
		VLnKv:            resp.VLN_KV,
		ZTotalPosSeqOhm:  resp.ZTotalPosSeq,
		IFault_3PhKa:     resp.IFault3Ph_KA,
		SlgComputed:      resp.SLGComputed,
		ZTotalZeroSeqOhm: resp.ZTotalZeroSeq,
		IFaultSlgKa:      resp.IFaultSLG_KA,
		GoverningFaultKa: resp.GoverningFault,
		Equation:         resp.Equation,
	}), nil
}

func (h *ConnectProtectionService) ComputeEarthFault(
	ctx context.Context,
	req *connect.Request[protectionv1.ComputeEarthFaultRequest],
) (*connect.Response[protectionv1.ComputeEarthFaultResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetStudyId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid study_id"))
	}
	resp, err := h.svc.ComputeEarthFault(ctx, domain.ComputeEarthFaultRequest{
		StudyID:          studyID,
		VoltageKV:        req.Msg.GetVoltageKv(),
		EarthingMethod:   domain.NeutralEarthing(req.Msg.GetEarthingMethod()),
		NGRResistanceOhm: req.Msg.GetNgrResistanceOhm(),
		CableResistance:  req.Msg.GetCableResistanceOhm(),
	})
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.ComputeEarthFaultResponse{
		StudyId:             resp.StudyID.String(),
		EarthingMethod:      protectionv1.NeutralEarthing(resp.EarthingMethod),
		EarthFaultCurrentKa: resp.EarthFaultCurrentKA,
		TouchVoltageV:       resp.TouchVoltageV,
		Equation:            resp.Equation,
	}), nil
}

func (h *ConnectProtectionService) SelectRelay(
	ctx context.Context,
	req *connect.Request[protectionv1.SelectRelayRequest],
) (*connect.Response[protectionv1.SelectRelayResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetStudyId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid study_id"))
	}
	resp, err := h.svc.SelectRelay(ctx, domain.SelectRelayRequest{
		StudyID:                 studyID,
		FaultCurrentKA:          req.Msg.GetFaultCurrentKa(),
		LoadCurrentA:            req.Msg.GetLoadCurrentA(),
		PreferredCharacteristic: domain.RelayCharacteristic(req.Msg.GetPreferredCharacteristic()),
	})
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.SelectRelayResponse{
		StudyId: resp.StudyID.String(),
		Relay: &protectionv1.RelaySelection{
			RelayId:         resp.Relay.RelayID,
			MakeModel:       resp.Relay.MakeModel,
			Characteristic:  protectionv1.RelayCharacteristic(resp.Relay.Characteristic),
			PickupCurrentA:  resp.Relay.PickupCurrentA,
			TimeDialSetting: resp.Relay.TimeDial,
			Rationale:       resp.Relay.Rationale,
		},
	}), nil
}

func (h *ConnectProtectionService) ComputeRelaySettings(
	ctx context.Context,
	req *connect.Request[protectionv1.ComputeRelaySettingsRequest],
) (*connect.Response[protectionv1.ComputeRelaySettingsResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetStudyId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid study_id"))
	}
	resp, err := h.svc.ComputeRelaySettings(ctx, domain.ComputeRelaySettingsRequest{
		StudyID:        studyID,
		Characteristic: domain.RelayCharacteristic(req.Msg.GetCharacteristic()),
		PickupCurrentA: req.Msg.GetPickupCurrentA(),
		TimeDial:       req.Msg.GetTimeDialSetting(),
		FaultCurrentA:  req.Msg.GetFaultCurrentA(),
	})
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.ComputeRelaySettingsResponse{
		StudyId:        resp.StudyID.String(),
		Multiplier:     resp.Multiplier,
		OperatingTimeS: resp.OperatingTime,
		Characteristic: protectionv1.RelayCharacteristic(resp.Characteristic),
		Equation:       resp.Equation,
	}), nil
}

func (h *ConnectProtectionService) ValidateCoordination(
	ctx context.Context,
	req *connect.Request[protectionv1.ValidateCoordinationRequest],
) (*connect.Response[protectionv1.ValidateCoordinationResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetStudyId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid study_id"))
	}
	pairs := make([]domain.CoordinationPair, 0, len(req.Msg.GetPairs()))
	for _, p := range req.Msg.GetPairs() {
		pairs = append(pairs, domain.CoordinationPair{
			UpstreamRelayID:   p.GetUpstreamRelayId(),
			DownstreamRelayID: p.GetDownstreamRelayId(),
			UpstreamTimeS:     p.GetUpstreamTimeS(),
			DownstreamTimeS:   p.GetDownstreamTimeS(),
			MarginS:           p.GetMarginS(),
		})
	}
	resp, err := h.svc.ValidateCoordination(ctx, domain.ValidateCoordinationRequest{
		StudyID:        studyID,
		Pairs:          pairs,
		MinimumMarginS: req.Msg.GetMinimumMarginS(),
	})
	if err != nil {
		return nil, protectionConnectError(err)
	}
	violations := make([]*protectionv1.CoordinationViolation, 0, len(resp.Violations))
	for i := range resp.Violations {
		v := resp.Violations[i]
		violations = append(violations, &protectionv1.CoordinationViolation{
			UpstreamRelayId:   v.UpstreamRelayID,
			DownstreamRelayId: v.DownstreamRelayID,
			MarginS:           v.MarginS,
			MinimumRequiredS:  v.MinimumRequiredS,
		})
	}
	return connect.NewResponse(&protectionv1.ValidateCoordinationResponse{
		Valid:      resp.Valid,
		Violations: violations,
	}), nil
}

func (h *ConnectProtectionService) GenerateProtectionReport(
	ctx context.Context,
	req *connect.Request[protectionv1.GenerateProtectionReportRequest],
) (*connect.Response[protectionv1.GenerateProtectionReportResponse], error) {
	studyID, err := uuid.Parse(req.Msg.GetStudyId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid study_id"))
	}
	report, err := h.svc.GenerateProtectionReport(ctx, studyID)
	if err != nil {
		return nil, protectionConnectError(err)
	}
	return connect.NewResponse(&protectionv1.GenerateProtectionReportResponse{
		StudyId:    studyID.String(),
		ReportText: report,
	}), nil
}

func protectionStudyToProto(s *domain.ProtectionStudy) *protectionv1.ProtectionStudy {
	return &protectionv1.ProtectionStudy{
		Id:                s.ID.String(),
		ProjectId:         s.ProjectID.String(),
		Name:              s.Name,
		SystemVoltageKv:   s.SystemVoltageKV,
		SourceImpedancePu: s.SourceImpedancePU,
		MvaBase:           s.MVABase,
		CreatedAt:         timestamppb.New(s.CreatedAt),
	}
}

func protectionConnectError(err error) error {
	return connect.NewError(connect.CodeInvalidArgument, err)
}
