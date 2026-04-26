package handler

import (
	"context"
	"errors"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	simulationv1 "p9e.in/samavaya/solar3d/gen/simulation/v1"
	simulationv1connect "p9e.in/samavaya/solar3d/gen/simulation/v1/simulationv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"p9e.in/samavaya/solar3d/simulation-service/internal/domain"
	"p9e.in/samavaya/solar3d/simulation-service/internal/service"
)

type ConnectSimulationService struct {
	svc *service.SimulationService
}

var _ simulationv1connect.SimulationServiceHandler = (*ConnectSimulationService)(nil)

func NewConnectSimulationService(svc *service.SimulationService) *ConnectSimulationService {
	return &ConnectSimulationService{svc: svc}
}

func (h *ConnectSimulationService) CreateSimulation(
	ctx context.Context,
	req *connect.Request[simulationv1.CreateSimulationRequest],
) (*connect.Response[simulationv1.CreateSimulationResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}
	if req.Msg.GetParams() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("params is required"))
	}

	sim, err := h.svc.Create(ctx, domain.CreateSimulationRequest{
		ProjectID:      projectID,
		LayoutID:       layoutID,
		Name:           req.Msg.GetName(),
		SimulationType: protoSimulationTypeToDomain(req.Msg.GetSimulationType()),
		Params:         protoSimulationParamsToDomain(req.Msg.GetParams()),
	})
	if err != nil {
		return nil, simulationConnectError(err)
	}

	return connect.NewResponse(&simulationv1.CreateSimulationResponse{
		Simulation: simulationToProto(sim),
	}), nil
}

func (h *ConnectSimulationService) GetSimulation(
	ctx context.Context,
	req *connect.Request[simulationv1.GetSimulationRequest],
) (*connect.Response[simulationv1.GetSimulationResponse], error) {
	simulationID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid simulation id"))
	}

	sim, err := h.svc.GetByID(ctx, simulationID)
	if err != nil {
		return nil, simulationConnectError(err)
	}

	return connect.NewResponse(&simulationv1.GetSimulationResponse{
		Simulation: simulationToProto(sim),
	}), nil
}

func (h *ConnectSimulationService) ListSimulations(
	ctx context.Context,
	req *connect.Request[simulationv1.ListSimulationsRequest],
) (*connect.Response[simulationv1.ListSimulationsResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	simulations, err := h.svc.ListByProject(ctx, projectID)
	if err != nil {
		return nil, simulationConnectError(err)
	}

	result := make([]*simulationv1.Simulation, 0, len(simulations))
	for i := range simulations {
		sim := simulations[i]
		result = append(result, simulationToProto(&sim))
	}

	return connect.NewResponse(&simulationv1.ListSimulationsResponse{
		Simulations: result,
	}), nil
}

func (h *ConnectSimulationService) RunSimulation(
	ctx context.Context,
	req *connect.Request[simulationv1.RunSimulationRequest],
) (*connect.Response[simulationv1.RunSimulationResponse], error) {
	simulationID, err := uuid.Parse(req.Msg.GetSimulationId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid simulation_id"))
	}

	sim, err := h.svc.RunSimulation(ctx, simulationID)
	if err != nil {
		return nil, simulationConnectError(err)
	}

	return connect.NewResponse(&simulationv1.RunSimulationResponse{
		Simulation: simulationToProto(sim),
	}), nil
}

func (h *ConnectSimulationService) GetSunPosition(
	_ context.Context,
	req *connect.Request[simulationv1.GetSunPositionRequest],
) (*connect.Response[simulationv1.GetSunPositionResponse], error) {
	timestamp := time.Now().UTC()
	if ts := req.Msg.GetTimestamp(); ts != nil {
		timestamp = ts.AsTime()
	}

	position := h.svc.GetSunPosition(req.Msg.GetLatitude(), req.Msg.GetLongitude(), timestamp)

	return connect.NewResponse(&simulationv1.GetSunPositionResponse{
		Position: sunPositionToProto(position),
	}), nil
}

func (h *ConnectSimulationService) GetShadowMap(
	ctx context.Context,
	req *connect.Request[simulationv1.GetShadowMapRequest],
) (*connect.Response[simulationv1.GetShadowMapResponse], error) {
	timestamp := time.Now().UTC()
	if ts := req.Msg.GetTimestamp(); ts != nil {
		timestamp = ts.AsTime()
	}

	_, err := h.svc.GetShadowMap(ctx, req.Msg.GetLatitude(), req.Msg.GetLongitude(), timestamp)
	if err != nil {
		return nil, simulationConnectError(err)
	}

	// The current service computes solar positions but not panel geometry shadows yet.
	return connect.NewResponse(&simulationv1.GetShadowMapResponse{
		Shadows:     []*simulationv1.ShadowPolygon{},
		SunPosition: sunPositionToProto(h.svc.GetSunPosition(req.Msg.GetLatitude(), req.Msg.GetLongitude(), timestamp)),
	}), nil
}

func (h *ConnectSimulationService) DeleteSimulation(
	ctx context.Context,
	req *connect.Request[simulationv1.DeleteSimulationRequest],
) (*connect.Response[simulationv1.DeleteSimulationResponse], error) {
	simulationID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid simulation id"))
	}

	if err := h.svc.Delete(ctx, simulationID); err != nil {
		return nil, simulationConnectError(err)
	}

	return connect.NewResponse(&simulationv1.DeleteSimulationResponse{}), nil
}

func simulationToProto(sim *domain.Simulation) *simulationv1.Simulation {
	if sim == nil {
		return nil
	}

	protoSim := &simulationv1.Simulation{
		Id:             sim.ID.String(),
		ProjectId:      sim.ProjectID.String(),
		LayoutId:       sim.LayoutID.String(),
		Name:           sim.Name,
		SimulationType: domainSimulationTypeToProto(sim.SimulationType),
		Status:         domainSimulationStatusToProto(sim.Status),
		Params:         domainSimulationParamsToProto(sim.Params),
		Result:         simulationResultToProto(sim.Result),
		CreatedAt:      timestamppb.New(sim.CreatedAt),
	}
	if sim.CompletedAt != nil {
		protoSim.CompletedAt = timestamppb.New(*sim.CompletedAt)
	}
	return protoSim
}

func protoSimulationParamsToDomain(params *simulationv1.SimulationParams) domain.SimulationParams {
	startTime := time.Time{}
	endTime := time.Time{}
	if params.GetStartTime() != nil {
		startTime = params.GetStartTime().AsTime()
	}
	if params.GetEndTime() != nil {
		endTime = params.GetEndTime().AsTime()
	}
	return domain.SimulationParams{
		StartTime:             startTime,
		EndTime:               endTime,
		TimeStepMinutes:       int(params.GetTimeStepMinutes()),
		Lat:                   params.GetLatitude(),
		Lon:                   params.GetLongitude(),
		IncludeTerrainShading: params.GetIncludeTerrainShading(),
		IncludePanelShading:   params.GetIncludePanelShading(),
	}
}

func domainSimulationParamsToProto(params domain.SimulationParams) *simulationv1.SimulationParams {
	protoParams := &simulationv1.SimulationParams{
		TimeStepMinutes:       int32(params.TimeStepMinutes),
		Latitude:              params.Lat,
		Longitude:             params.Lon,
		IncludeTerrainShading: params.IncludeTerrainShading,
		IncludePanelShading:   params.IncludePanelShading,
	}
	if !params.StartTime.IsZero() {
		protoParams.StartTime = timestamppb.New(params.StartTime)
	}
	if !params.EndTime.IsZero() {
		protoParams.EndTime = timestamppb.New(params.EndTime)
	}
	return protoParams
}

func simulationResultToProto(result *domain.SimulationResult) *simulationv1.SimulationResult {
	if result == nil {
		return nil
	}
	return &simulationv1.SimulationResult{
		TotalIrradianceKwhM2: result.TotalIrradiance,
		AnnualYieldKwh:       result.AnnualYield,
		PerformanceRatio:     result.PerformanceRatio,
		ShadingLossPercent:   result.ShadingLoss,
		ResultFilePath:       result.ResultFilePath,
	}
}

func sunPositionToProto(position *domain.SunPosition) *simulationv1.SunPosition {
	if position == nil {
		return nil
	}
	return &simulationv1.SunPosition{
		Azimuth:   position.Azimuth,
		Elevation: position.Elevation,
		Zenith:    position.Zenith,
		HourAngle: position.HourAngle,
		Timestamp: timestamppb.New(position.Timestamp),
	}
}

func protoSimulationTypeToDomain(simulationType simulationv1.SimulationType) domain.SimulationType {
	switch simulationType {
	case simulationv1.SimulationType_SIMULATION_TYPE_SHADOW:
		return domain.SimulationTypeShadow
	case simulationv1.SimulationType_SIMULATION_TYPE_IRRADIANCE:
		return domain.SimulationTypeIrradiance
	case simulationv1.SimulationType_SIMULATION_TYPE_ANNUAL_YIELD:
		return domain.SimulationTypeYield
	default:
		return domain.SimulationTypeIrradiance
	}
}

func domainSimulationTypeToProto(simulationType domain.SimulationType) simulationv1.SimulationType {
	switch simulationType {
	case domain.SimulationTypeShadow:
		return simulationv1.SimulationType_SIMULATION_TYPE_SHADOW
	case domain.SimulationTypeIrradiance:
		return simulationv1.SimulationType_SIMULATION_TYPE_IRRADIANCE
	case domain.SimulationTypeYield:
		return simulationv1.SimulationType_SIMULATION_TYPE_ANNUAL_YIELD
	default:
		return simulationv1.SimulationType_SIMULATION_TYPE_UNSPECIFIED
	}
}

func domainSimulationStatusToProto(status domain.SimulationStatus) simulationv1.SimulationStatus {
	switch status {
	case domain.SimulationStatusPending:
		return simulationv1.SimulationStatus_SIMULATION_STATUS_PENDING
	case domain.SimulationStatusRunning:
		return simulationv1.SimulationStatus_SIMULATION_STATUS_RUNNING
	case domain.SimulationStatusCompleted:
		return simulationv1.SimulationStatus_SIMULATION_STATUS_COMPLETED
	case domain.SimulationStatusFailed:
		return simulationv1.SimulationStatus_SIMULATION_STATUS_FAILED
	default:
		return simulationv1.SimulationStatus_SIMULATION_STATUS_UNSPECIFIED
	}
}

func simulationConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return connect.NewError(connect.CodeNotFound, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

