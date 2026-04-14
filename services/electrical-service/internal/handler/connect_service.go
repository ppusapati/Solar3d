package handler

import (
	"context"
	"encoding/json"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	electricalv1 "github.com/solar3d/solar3d/gen/electrical/v1"
	electricalv1connect "github.com/solar3d/solar3d/gen/electrical/v1/electricalv1connect"

	"solar3d/electrical-service/internal/domain"
	"solar3d/electrical-service/internal/service"
)

type ConnectElectricalService struct {
	svc *service.ElectricalService
}

var _ electricalv1connect.ElectricalServiceHandler = (*ConnectElectricalService)(nil)

func NewConnectElectricalService(svc *service.ElectricalService) *ConnectElectricalService {
	return &ConnectElectricalService{svc: svc}
}

func (h *ConnectElectricalService) CreateNetwork(
	ctx context.Context,
	req *connect.Request[electricalv1.CreateNetworkRequest],
) (*connect.Response[electricalv1.CreateNetworkResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}

	network, err := h.svc.CreateNetwork(ctx, domain.CreateNetworkRequest{
		ProjectID: projectID,
		LayoutID:  layoutID,
		Name:      req.Msg.GetName(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.CreateNetworkResponse{
		Network: electricalNetworkToProto(network),
	}), nil
}

func (h *ConnectElectricalService) GetNetwork(
	ctx context.Context,
	req *connect.Request[electricalv1.GetNetworkRequest],
) (*connect.Response[electricalv1.GetNetworkResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network id"))
	}

	network, err := h.svc.GetNetwork(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.GetNetworkResponse{
		Network: electricalNetworkToProto(network),
	}), nil
}

func (h *ConnectElectricalService) ListNetworks(
	ctx context.Context,
	req *connect.Request[electricalv1.ListNetworksRequest],
) (*connect.Response[electricalv1.ListNetworksResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	networks, err := h.svc.ListNetworks(ctx, projectID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	result := make([]*electricalv1.ElectricalNetwork, 0, len(networks))
	for i := range networks {
		network := networks[i]
		result = append(result, electricalNetworkToProto(&network))
	}

	return connect.NewResponse(&electricalv1.ListNetworksResponse{
		Networks: result,
	}), nil
}

func (h *ConnectElectricalService) DeleteNetwork(
	ctx context.Context,
	req *connect.Request[electricalv1.DeleteNetworkRequest],
) (*connect.Response[electricalv1.DeleteNetworkResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network id"))
	}

	if err := h.svc.DeleteNetwork(ctx, networkID); err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.DeleteNetworkResponse{}), nil
}

func (h *ConnectElectricalService) CreateString(
	ctx context.Context,
	req *connect.Request[electricalv1.CreateStringRequest],
) (*connect.Response[electricalv1.CreateStringResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}
	inverterGroupID := uuid.Nil
	if raw := req.Msg.GetInverterGroupId(); raw != "" {
		inverterGroupID, err = uuid.Parse(raw)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid inverter_group_id"))
		}
	}

	panelIDs := make([]uuid.UUID, 0, len(req.Msg.GetPanelIds()))
	for _, raw := range req.Msg.GetPanelIds() {
		panelID, err := uuid.Parse(raw)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid panel id"))
		}
		panelIDs = append(panelIDs, panelID)
	}

	panelString, err := h.svc.CreateString(ctx, domain.CreateStringRequest{
		NetworkID:       networkID,
		InverterGroupID: inverterGroupID,
		PanelIDs:        panelIDs,
		Voltage:         req.Msg.GetPanelVoltage(),
		Current:         req.Msg.GetPanelCurrent(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.CreateStringResponse{
		PanelString: panelStringToProto(panelString),
	}), nil
}

func (h *ConnectElectricalService) AutoGenerateStrings(
	ctx context.Context,
	req *connect.Request[electricalv1.AutoGenerateStringsRequest],
) (*connect.Response[electricalv1.AutoGenerateStringsResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}
	inverterAssetID, err := uuid.Parse(req.Msg.GetInverterAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid inverter_asset_id"))
	}

	network, err := h.svc.AutoGenerateStrings(ctx, domain.AutoGenerateRequest{
		NetworkID:          networkID,
		PanelsPerString:    int(req.Msg.GetPanelsPerString()),
		StringsPerInverter: int(req.Msg.GetStringsPerInverter()),
		PanelVoltage:       req.Msg.GetPanelVoltage(),
		PanelCurrent:       req.Msg.GetPanelCurrent(),
		PanelPowerW:        req.Msg.GetPanelPowerW(),
		InverterAssetID:    inverterAssetID,
		InverterACKW:       req.Msg.GetInverterAcKw(),
		TotalPanels:        int(req.Msg.GetTotalPanels()),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.AutoGenerateStringsResponse{
		StringsCreated:        int32(network.StringCount),
		InverterGroupsCreated: int32(network.InverterCount),
		TotalDcKw:             network.TotalDCCapacityKW,
		TotalAcKw:             network.TotalACCapacityKW,
		Network:               electricalNetworkToProto(network),
	}), nil
}

func (h *ConnectElectricalService) ListStrings(
	ctx context.Context,
	req *connect.Request[electricalv1.ListStringsRequest],
) (*connect.Response[electricalv1.ListStringsResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	panelStrings, err := h.svc.ListStrings(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	result := make([]*electricalv1.PanelString, 0, len(panelStrings))
	for i := range panelStrings {
		panelString := panelStrings[i]
		result = append(result, panelStringToProto(&panelString))
	}

	return connect.NewResponse(&electricalv1.ListStringsResponse{
		Strings: result,
	}), nil
}

func (h *ConnectElectricalService) AssignInverter(
	ctx context.Context,
	req *connect.Request[electricalv1.AssignInverterRequest],
) (*connect.Response[electricalv1.AssignInverterResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}
	inverterAssetID, err := uuid.Parse(req.Msg.GetInverterAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid inverter_asset_id"))
	}
	stringIDs := make([]uuid.UUID, 0, len(req.Msg.GetStringIds()))
	for _, raw := range req.Msg.GetStringIds() {
		stringID, err := uuid.Parse(raw)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid string_id"))
		}
		stringIDs = append(stringIDs, stringID)
	}
	position, err := parsePositionGeoJSON(req.Msg.GetPositionGeojson())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	inverterGroup, err := h.svc.AssignInverter(ctx, domain.AssignInverterRequest{
		NetworkID:       networkID,
		InverterAssetID: inverterAssetID,
		StringIDs:       stringIDs,
		Position:        position,
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.AssignInverterResponse{
		InverterGroup: inverterGroupToProto(inverterGroup),
	}), nil
}

func (h *ConnectElectricalService) ListInverterGroups(
	ctx context.Context,
	req *connect.Request[electricalv1.ListInverterGroupsRequest],
) (*connect.Response[electricalv1.ListInverterGroupsResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	inverterGroups, err := h.svc.ListInverterGroups(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	result := make([]*electricalv1.InverterGroup, 0, len(inverterGroups))
	for i := range inverterGroups {
		inverterGroup := inverterGroups[i]
		result = append(result, inverterGroupToProto(&inverterGroup))
	}

	return connect.NewResponse(&electricalv1.ListInverterGroupsResponse{
		InverterGroups: result,
	}), nil
}

func (h *ConnectElectricalService) CalculateDCCapacity(
	ctx context.Context,
	req *connect.Request[electricalv1.CalculateDCCapacityRequest],
) (*connect.Response[electricalv1.CalculateDCCapacityResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	totalDC, err := h.svc.CalculateDCCapacity(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}
	panelStrings, err := h.svc.ListStrings(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	totalPanels := 0
	for _, panelString := range panelStrings {
		totalPanels += panelString.PanelCount
	}

	return connect.NewResponse(&electricalv1.CalculateDCCapacityResponse{
		TotalDcKw:    totalDC,
		TotalPanels:  int32(totalPanels),
		TotalStrings: int32(len(panelStrings)),
	}), nil
}

func (h *ConnectElectricalService) CalculateACCapacity(
	ctx context.Context,
	req *connect.Request[electricalv1.CalculateACCapacityRequest],
) (*connect.Response[electricalv1.CalculateACCapacityResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	totalAC, err := h.svc.CalculateACCapacity(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}
	inverterGroups, err := h.svc.ListInverterGroups(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	dcACRatio := 0.0
	if totalAC > 0 {
		totalDC, err := h.svc.CalculateDCCapacity(ctx, networkID)
		if err != nil {
			return nil, electricalConnectError(err)
		}
		dcACRatio = totalDC / totalAC
	}

	return connect.NewResponse(&electricalv1.CalculateACCapacityResponse{
		TotalAcKw:      totalAC,
		DcAcRatio:      dcACRatio,
		TotalInverters: int32(len(inverterGroups)),
	}), nil
}

func (h *ConnectElectricalService) CalculateLosses(
	ctx context.Context,
	req *connect.Request[electricalv1.CalculateLossesRequest],
) (*connect.Response[electricalv1.CalculateLossesResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	losses, err := h.svc.CalculateLosses(ctx, networkID)
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.CalculateLossesResponse{
		DcCableLossPercent:     losses.WiringLossDC,
		AcCableLossPercent:     losses.WiringLossAC,
		InverterLossPercent:    losses.InverterLoss,
		TransformerLossPercent: losses.TransformerLoss,
		TotalLossPercent:       losses.TotalLossPercent,
	}), nil
}

func electricalNetworkToProto(network *domain.ElectricalNetwork) *electricalv1.ElectricalNetwork {
	if network == nil {
		return nil
	}
	return &electricalv1.ElectricalNetwork{
		Id:                network.ID.String(),
		ProjectId:         network.ProjectID.String(),
		LayoutId:          network.LayoutID.String(),
		Name:              network.Name,
		TotalDcCapacityKw: network.TotalDCCapacityKW,
		TotalAcCapacityKw: network.TotalACCapacityKW,
		DcAcRatio:         network.DCACRatio,
		StringCount:       int32(network.StringCount),
		InverterCount:     int32(network.InverterCount),
	}
}

func panelStringToProto(panelString *domain.PanelString) *electricalv1.PanelString {
	if panelString == nil {
		return nil
	}

	panelIDs := make([]string, 0, len(panelString.PanelIDs))
	for _, panelID := range panelString.PanelIDs {
		panelIDs = append(panelIDs, panelID.String())
	}

	return &electricalv1.PanelString{
		Id:              panelString.ID.String(),
		NetworkId:       panelString.NetworkID.String(),
		InverterGroupId: panelString.InverterGroupID.String(),
		PanelIds:        panelIDs,
		PanelCount:      int32(panelString.PanelCount),
		StringVoltage:   panelString.Voltage,
		StringCurrent:   panelString.Current,
		StringPowerW:    panelString.PowerW,
	}
}

func inverterGroupToProto(inverterGroup *domain.InverterGroup) *electricalv1.InverterGroup {
	if inverterGroup == nil {
		return nil
	}

	stringIDs := make([]string, 0, len(inverterGroup.StringIDs))
	for _, stringID := range inverterGroup.StringIDs {
		stringIDs = append(stringIDs, stringID.String())
	}

	return &electricalv1.InverterGroup{
		Id:              inverterGroup.ID.String(),
		NetworkId:       inverterGroup.NetworkID.String(),
		InverterAssetId: inverterGroup.InverterAssetID.String(),
		StringIds:       stringIDs,
		DcInputKw:       inverterGroup.DCInputKW,
		AcOutputKw:      inverterGroup.ACOutputKW,
		DcAcRatio:       inverterGroup.DCACRatio,
		PositionGeojson: inverterPositionToGeoJSON(inverterGroup.Position),
	}
}

func inverterPositionToGeoJSON(position [2]float64) string {
	if position == [2]float64{} {
		return ""
	}
	data, err := json.Marshal(map[string]any{
		"type":        "Point",
		"coordinates": []float64{position[0], position[1]},
	})
	if err != nil {
		return ""
	}
	return string(data)
}

func parsePositionGeoJSON(raw string) ([2]float64, error) {
	if raw == "" {
		return [2]float64{}, nil
	}

	var payload struct {
		Type        string    `json:"type"`
		Coordinates []float64 `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(raw), &payload); err != nil {
		return [2]float64{}, errors.New("invalid position_geojson")
	}
	if payload.Type != "Point" || len(payload.Coordinates) < 2 {
		return [2]float64{}, errors.New("position_geojson must be a GeoJSON Point")
	}
	return [2]float64{payload.Coordinates[0], payload.Coordinates[1]}, nil
}

func electricalConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return connect.NewError(connect.CodeNotFound, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

func (h *ConnectElectricalService) ValidateSizing(
	ctx context.Context,
	req *connect.Request[electricalv1.ValidateSizingRequest],
) (*connect.Response[electricalv1.ValidateSizingResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	result, err := h.svc.ValidateSizing(ctx, domain.ValidateSizingRequest{
		NetworkID:            networkID,
		PanelVocV:            req.Msg.GetPanelVocV(),
		PanelVmpV:            req.Msg.GetPanelVmpV(),
		PanelIscA:            req.Msg.GetPanelIscA(),
		PanelImpA:            req.Msg.GetPanelImpA(),
		PanelsPerString:      int(req.Msg.GetPanelsPerString()),
		InverterVdcMaxV:      req.Msg.GetInverterVdcMaxV(),
		InverterVmpptMinV:    req.Msg.GetInverterVmpptMinV(),
		InverterVmpptMaxV:    req.Msg.GetInverterVmpptMaxV(),
		InverterIdcMaxA:      req.Msg.GetInverterIdcMaxA(),
		InverterACKW:         req.Msg.GetInverterAcKw(),
		DCACRatioMin:         req.Msg.GetDcAcRatioMin(),
		DCACRatioMax:         req.Msg.GetDcAcRatioMax(),
		TempCoeffVocPctPerC:  req.Msg.GetTempCoeffVocPctPerC(),
		LowestExpectedTempC:  req.Msg.GetLowestExpectedTempC(),
		HighestExpectedTempC: req.Msg.GetHighestExpectedTempC(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	violations := make([]*electricalv1.SizingViolation, 0, len(result.Violations))
	for _, v := range result.Violations {
		violations = append(violations, &electricalv1.SizingViolation{
			Code:    v.Code,
			Message: v.Message,
			Limit:   v.Limit,
			Actual:  v.Actual,
		})
	}

	return connect.NewResponse(&electricalv1.ValidateSizingResponse{
		Valid:              result.Valid,
		Violations:         violations,
		StringVocColdV:     result.StringVocColdV,
		StringVmpHotV:      result.StringVmpHotV,
		DcStringPowerKw:    result.DCStringPowerKW,
		DcAcRatio:          result.DCACRatio,
		MaxPanelsPerString: int32(result.MaxPanelsPerString),
		MinPanelsPerString: int32(result.MinPanelsPerString),
	}), nil
}

func (h *ConnectElectricalService) ValidateNetwork(
	ctx context.Context,
	req *connect.Request[electricalv1.ValidateNetworkRequest],
) (*connect.Response[electricalv1.ValidateNetworkResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	result, err := h.svc.ValidateNetwork(ctx, domain.ValidateNetworkRequest{
		NetworkID:         networkID,
		InverterMPPTCount: int(req.Msg.GetInverterMpptCount()),
		MaxStringsPerMPPT: int(req.Msg.GetMaxStringsPerMppt()),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	protoIssues := make([]*electricalv1.NetworkTopologyIssue, 0, len(result.Issues))
	for _, iss := range result.Issues {
		protoIssues = append(protoIssues, &electricalv1.NetworkTopologyIssue{
			Code:     iss.Code,
			Message:  iss.Message,
			EntityId: iss.EntityID,
		})
	}

	return connect.NewResponse(&electricalv1.ValidateNetworkResponse{
		Valid:              result.Valid,
		Issues:             protoIssues,
		TotalStrings:       int32(result.TotalStrings),
		AssignedStrings:    int32(result.AssignedStrings),
		UnassignedStrings:  int32(result.UnassignedStrings),
		TotalPanels:        int32(result.TotalPanels),
		DuplicatePanelRefs: int32(result.DuplicatePanelRefs),
		TotalDcKw:          result.TotalDCKW,
		TotalAcKw:          result.TotalACKW,
		DcAcRatio:          result.DCACRatio,
	}), nil
}

func (h *ConnectElectricalService) GenerateNetworkBOM(
	ctx context.Context,
	req *connect.Request[electricalv1.GenerateNetworkBOMRequest],
) (*connect.Response[electricalv1.GenerateNetworkBOMResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid network_id"))
	}

	bom, err := h.svc.GenerateNetworkBOM(ctx, domain.GenerateNetworkBOMRequest{
		NetworkID:            networkID,
		PanelUnitCost:        req.Msg.GetPanelUnitCost(),
		InverterUnitCost:     req.Msg.GetInverterUnitCost(),
		CableCostPerM:        req.Msg.GetCableCostPerM(),
		MountingCostPerPanel: req.Msg.GetMountingCostPerPanel(),
		CurrencyCode:         req.Msg.GetCurrencyCode(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	protoItems := make([]*electricalv1.NetworkBOMItem, 0, len(bom.Items))
	for _, item := range bom.Items {
		protoItems = append(protoItems, &electricalv1.NetworkBOMItem{
			Category:  item.Category,
			Name:      item.Name,
			Quantity:  int32(item.Quantity),
			Unit:      item.Unit,
			UnitCost:  item.UnitCost,
			TotalCost: item.TotalCost,
		})
	}

	return connect.NewResponse(&electricalv1.GenerateNetworkBOMResponse{
		NetworkId:          bom.NetworkID.String(),
		PanelCount:         int32(bom.PanelCount),
		StringCount:        int32(bom.StringCount),
		InverterGroupCount: int32(bom.InverterGroupCount),
		TotalDcKw:          bom.TotalDCKW,
		TotalAcKw:          bom.TotalACKW,
		Items:              protoItems,
		TotalCost:          bom.TotalCost,
		CurrencyCode:       bom.CurrencyCode,
	}), nil
}
