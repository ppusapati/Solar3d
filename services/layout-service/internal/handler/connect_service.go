package handler

import (
	"context"
	"encoding/json"
	"errors"
	"strings"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	layoutv1 "github.com/solar3d/solar3d/gen/layout/v1"
	layoutv1connect "github.com/solar3d/solar3d/gen/layout/v1/layoutv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/layout-service/internal/domain"
	"solar3d/layout-service/internal/service"
)

type ConnectLayoutService struct {
	svc *service.Service
}

var _ layoutv1connect.LayoutServiceHandler = (*ConnectLayoutService)(nil)

func NewConnectLayoutService(svc *service.Service) *ConnectLayoutService {
	return &ConnectLayoutService{svc: svc}
}

func (h *ConnectLayoutService) CreateLayout(
	ctx context.Context,
	req *connect.Request[layoutv1.CreateLayoutRequest],
) (*connect.Response[layoutv1.CreateLayoutResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	layout, err := h.svc.CreateLayout(ctx, projectID, strings.TrimSpace(req.Msg.GetName()))
	if err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.CreateLayoutResponse{
		Layout: layoutToProto(layout),
	}), nil
}

func (h *ConnectLayoutService) GetLayout(
	ctx context.Context,
	req *connect.Request[layoutv1.GetLayoutRequest],
) (*connect.Response[layoutv1.GetLayoutResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout id"))
	}

	layout, err := h.svc.GetLayout(ctx, layoutID)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.GetLayoutResponse{
		Layout: layoutToProto(layout),
	}), nil
}

func (h *ConnectLayoutService) ListLayouts(
	ctx context.Context,
	req *connect.Request[layoutv1.ListLayoutsRequest],
) (*connect.Response[layoutv1.ListLayoutsResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	layouts, err := h.svc.ListLayouts(ctx, projectID)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	result := make([]*layoutv1.Layout, 0, len(layouts))
	for _, layout := range layouts {
		result = append(result, layoutToProto(layout))
	}

	return connect.NewResponse(&layoutv1.ListLayoutsResponse{
		Layouts: result,
	}), nil
}

func (h *ConnectLayoutService) DeleteLayout(
	ctx context.Context,
	req *connect.Request[layoutv1.DeleteLayoutRequest],
) (*connect.Response[layoutv1.DeleteLayoutResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout id"))
	}

	if err := h.svc.DeleteLayout(ctx, layoutID); err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.DeleteLayoutResponse{}), nil
}

func (h *ConnectLayoutService) PlaceComponent(
	ctx context.Context,
	req *connect.Request[layoutv1.PlaceComponentRequest],
) (*connect.Response[layoutv1.PlaceComponentResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}
	assetID, err := uuid.Parse(req.Msg.GetAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid asset_id"))
	}

	component := &domain.Component{
		LayoutID:      layoutID,
		AssetID:       assetID,
		ComponentType: protoComponentTypeToDomain(req.Msg.GetComponentType()),
		Position:      protoPositionToDomain(req.Msg.GetPosition()),
		Rotation:      domain.Position{Z: req.Msg.GetRotation()},
		Metadata:      stringToRawJSON(req.Msg.GetMetadataJson()),
	}
	if err := h.svc.PlaceComponent(ctx, component); err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.PlaceComponentResponse{
		Component: componentToProto(component),
	}), nil
}

func (h *ConnectLayoutService) MoveComponent(
	ctx context.Context,
	req *connect.Request[layoutv1.MoveComponentRequest],
) (*connect.Response[layoutv1.MoveComponentResponse], error) {
	componentID, err := uuid.Parse(req.Msg.GetComponentId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid component_id"))
	}

	position := protoPositionToDomain(req.Msg.GetPosition())
	rotation := domain.Position{Z: req.Msg.GetRotation()}

	component, err := h.svc.MoveComponent(ctx, componentID, position, rotation)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.MoveComponentResponse{
		Component: componentToProto(component),
	}), nil
}

func (h *ConnectLayoutService) RemoveComponent(
	ctx context.Context,
	req *connect.Request[layoutv1.RemoveComponentRequest],
) (*connect.Response[layoutv1.RemoveComponentResponse], error) {
	componentID, err := uuid.Parse(req.Msg.GetComponentId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid component_id"))
	}

	if err := h.svc.DeleteComponent(ctx, componentID); err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.RemoveComponentResponse{}), nil
}

func (h *ConnectLayoutService) ListComponents(
	ctx context.Context,
	req *connect.Request[layoutv1.ListComponentsRequest],
) (*connect.Response[layoutv1.ListComponentsResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}

	components, err := h.svc.ListComponents(ctx, layoutID)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	filter := req.Msg.GetTypeFilter()
	result := make([]*layoutv1.Component, 0, len(components))
	for _, component := range components {
		protoComponent := componentToProto(component)
		if filter != layoutv1.ComponentType_COMPONENT_TYPE_UNSPECIFIED && protoComponent.GetComponentType() != filter {
			continue
		}
		result = append(result, protoComponent)
	}

	return connect.NewResponse(&layoutv1.ListComponentsResponse{
		Components: result,
	}), nil
}

func (h *ConnectLayoutService) GeneratePanelArray(
	ctx context.Context,
	req *connect.Request[layoutv1.GeneratePanelArrayRequest],
) (*connect.Response[layoutv1.GeneratePanelArrayResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}
	if req.Msg.GetParams() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("params is required"))
	}

	params, err := protoPanelArrayParamsToDomain(req.Msg.GetParams())
	if err != nil {
		return nil, err
	}

	result, err := h.svc.GeneratePanelArray(ctx, layoutID, params)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	return connect.NewResponse(&layoutv1.GeneratePanelArrayResponse{
		PanelsCreated: int32(result.TotalPanels),
		TilesCreated:  int32(result.TileCount),
		CapacityKw:    result.TotalCapacityKW,
	}), nil
}

func (h *ConnectLayoutService) GetTiles(
	ctx context.Context,
	req *connect.Request[layoutv1.GetTilesRequest],
) (*connect.Response[layoutv1.GetTilesResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}
	if req.Msg.GetViewport() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("viewport is required"))
	}

	lod := int(req.Msg.GetLodLevel())
	query := domain.ViewportQuery{
		MinX: req.Msg.GetViewport().GetMinX(),
		MinY: req.Msg.GetViewport().GetMinY(),
		MaxX: req.Msg.GetViewport().GetMaxX(),
		MaxY: req.Msg.GetViewport().GetMaxY(),
	}
	if lod > 0 {
		query.LODLevel = &lod
	}

	tiles, err := h.svc.GetTiles(ctx, layoutID, query)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	result := make([]*layoutv1.LayoutTile, 0, len(tiles))
	for _, tile := range tiles {
		result = append(result, tileToProto(tile))
	}

	return connect.NewResponse(&layoutv1.GetTilesResponse{
		Tiles: result,
	}), nil
}

func (h *ConnectLayoutService) GetTilePanels(
	ctx context.Context,
	req *connect.Request[layoutv1.GetTilePanelsRequest],
) (*connect.Response[layoutv1.GetTilePanelsResponse], error) {
	tileID, err := uuid.Parse(req.Msg.GetTileId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid tile_id"))
	}

	panels, err := h.svc.GetPanelsByTile(ctx, tileID)
	if err != nil {
		return nil, layoutConnectError(err)
	}

	result := make([]*layoutv1.Panel, 0, len(panels))
	for _, panel := range panels {
		result = append(result, panelToProto(panel))
	}

	return connect.NewResponse(&layoutv1.GetTilePanelsResponse{
		Panels: result,
	}), nil
}

func layoutToProto(layout *domain.Layout) *layoutv1.Layout {
	if layout == nil {
		return nil
	}

	return &layoutv1.Layout{
		Id:              layout.ID.String(),
		ProjectId:       layout.ProjectID.String(),
		Name:            layout.Name,
		TotalPanels:     int32(layout.TotalPanels),
		TotalCapacityKw: layout.TotalCapacityKW,
		TileCount:       int32(layout.TileCount),
		CreatedAt:       timestamppb.New(layout.CreatedAt),
		UpdatedAt:       timestamppb.New(layout.UpdatedAt),
	}
}

func componentToProto(component *domain.Component) *layoutv1.Component {
	if component == nil {
		return nil
	}

	return &layoutv1.Component{
		Id:            component.ID.String(),
		LayoutId:      component.LayoutID.String(),
		AssetId:       component.AssetID.String(),
		ComponentType: domainComponentTypeToProto(component.ComponentType),
		Position:      domainPositionToProto(component.Position),
		Rotation:      component.Rotation.Z,
		MetadataJson:  rawJSONToString(component.Metadata),
		CreatedAt:     timestamppb.New(component.CreatedAt),
	}
}

func tileToProto(tile *domain.LayoutTile) *layoutv1.LayoutTile {
	if tile == nil {
		return nil
	}

	return &layoutv1.LayoutTile{
		Id:           tile.ID.String(),
		LayoutId:     tile.LayoutID.String(),
		Bbox:         bboxToProto(tile.BBox),
		LodLevel:     int32(tile.LODLevel),
		PanelCount:   int32(tile.PanelCount),
		MetadataJson: rawJSONToString(tile.Metadata),
		CreatedAt:    timestamppb.New(tile.CreatedAt),
	}
}

func panelToProto(panel *domain.Panel) *layoutv1.Panel {
	if panel == nil {
		return nil
	}

	return &layoutv1.Panel{
		Id:              panel.ID.String(),
		TileId:          panel.TileID.String(),
		StringId:        panel.StringID,
		GeometryGeojson: rawJSONToString(panel.GeometryGeoJSON),
		Tilt:            panel.Tilt,
		Azimuth:         panel.Azimuth,
		Elevation:       panel.Elevation,
		MetadataJson:    rawJSONToString(panel.Metadata),
	}
}

func bboxToProto(bbox domain.BoundingBox) *layoutv1.BoundingBox {
	return &layoutv1.BoundingBox{
		MinX: bbox.MinX,
		MinY: bbox.MinY,
		MaxX: bbox.MaxX,
		MaxY: bbox.MaxY,
	}
}

func protoPositionToDomain(pos *layoutv1.Position) domain.Position {
	if pos == nil {
		return domain.Position{}
	}
	return domain.Position{
		X: pos.GetLongitude(),
		Y: pos.GetLatitude(),
		Z: pos.GetElevation(),
	}
}

func domainPositionToProto(pos domain.Position) *layoutv1.Position {
	return &layoutv1.Position{
		Longitude: pos.X,
		Latitude:  pos.Y,
		Elevation: pos.Z,
	}
}

func protoPanelArrayParamsToDomain(params *layoutv1.PanelArrayParams) (domain.PanelArrayParams, error) {
	var terrainLayerID *uuid.UUID
	if raw := strings.TrimSpace(params.GetTerrainLayerId()); raw != "" {
		parsed, err := uuid.Parse(raw)
		if err != nil {
			return domain.PanelArrayParams{}, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid terrain_layer_id"))
		}
		terrainLayerID = &parsed
	}

	return domain.PanelArrayParams{
		PanelWidth:      params.GetPanelWidth(),
		PanelHeight:     params.GetPanelHeight(),
		TiltAngle:       params.GetTiltAngle(),
		Azimuth:         params.GetAzimuth(),
		RowSpacing:      params.GetRowSpacing(),
		ColumnSpacing:   params.GetColumnSpacing(),
		FillAreaGeoJSON: stringToRawJSON(params.GetFillAreaGeojson()),
		TerrainLayerID:  terrainLayerID,
	}, nil
}

func protoComponentTypeToDomain(componentType layoutv1.ComponentType) domain.ComponentType {
	switch componentType {
	case layoutv1.ComponentType_COMPONENT_TYPE_PANEL:
		return domain.ComponentTypePanel
	case layoutv1.ComponentType_COMPONENT_TYPE_INVERTER:
		return domain.ComponentTypeInverter
	case layoutv1.ComponentType_COMPONENT_TYPE_TRANSFORMER:
		return domain.ComponentTypeTransformer
	case layoutv1.ComponentType_COMPONENT_TYPE_TRACKER:
		return domain.ComponentTypeTracker
	case layoutv1.ComponentType_COMPONENT_TYPE_SUBSTATION:
		return domain.ComponentTypeSubstation
	case layoutv1.ComponentType_COMPONENT_TYPE_COMBINER_BOX:
		return domain.ComponentTypeCombinerBox
	case layoutv1.ComponentType_COMPONENT_TYPE_JUNCTION_BOX:
		return domain.ComponentTypeCombinerBox
	default:
		return domain.ComponentTypePanel
	}
}

func domainComponentTypeToProto(componentType domain.ComponentType) layoutv1.ComponentType {
	switch componentType {
	case domain.ComponentTypePanel:
		return layoutv1.ComponentType_COMPONENT_TYPE_PANEL
	case domain.ComponentTypeInverter:
		return layoutv1.ComponentType_COMPONENT_TYPE_INVERTER
	case domain.ComponentTypeTransformer:
		return layoutv1.ComponentType_COMPONENT_TYPE_TRANSFORMER
	case domain.ComponentTypeTracker:
		return layoutv1.ComponentType_COMPONENT_TYPE_TRACKER
	case domain.ComponentTypeSubstation:
		return layoutv1.ComponentType_COMPONENT_TYPE_SUBSTATION
	case domain.ComponentTypeCombinerBox:
		return layoutv1.ComponentType_COMPONENT_TYPE_COMBINER_BOX
	default:
		return layoutv1.ComponentType_COMPONENT_TYPE_UNSPECIFIED
	}
}

func stringToRawJSON(value string) json.RawMessage {
	if strings.TrimSpace(value) == "" {
		return nil
	}
	return json.RawMessage(value)
}

func rawJSONToString(value json.RawMessage) string {
	if len(value) == 0 {
		return ""
	}
	return string(value)
}

func layoutConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, domain.ErrPanelArrayTooLarge):
		return connect.NewError(connect.CodeInvalidArgument, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}
