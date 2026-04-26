package handler

import (
	"context"
	"encoding/json"
	"errors"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	assetv1 "p9e.in/samavaya/solar3d/gen/asset/v1"
	assetv1connect "p9e.in/samavaya/solar3d/gen/asset/v1/assetv1connect"
	paginationv1 "p9e.in/samavaya/packages/api/v1/pagination"
	pkgErrors "p9e.in/samavaya/packages/errors"

	"p9e.in/samavaya/solar3d/asset-service/internal/domain"
	"p9e.in/samavaya/solar3d/asset-service/internal/service"
)

type ConnectAssetService struct {
	svc *service.AssetService
}

var _ assetv1connect.AssetServiceHandler = (*ConnectAssetService)(nil)

func NewConnectAssetService(svc *service.AssetService) *ConnectAssetService {
	return &ConnectAssetService{svc: svc}
}

func (h *ConnectAssetService) CreateAsset(ctx context.Context, req *connect.Request[assetv1.CreateAssetRequest]) (*connect.Response[assetv1.CreateAssetResponse], error) {
	var model3dPath *string
	if v := req.Msg.GetModel_3DPath(); v != "" {
		model3dPath = &v
	}

	asset, err := h.svc.Create(ctx, domain.CreateAssetRequest{
		Name:             req.Msg.GetName(),
		Manufacturer:     req.Msg.GetManufacturer(),
		Model:            req.Msg.GetModel(),
		Category:         assetCategoryFromProto(req.Msg.GetCategory()),
		Dimensions:       dimensionsFromProto(req.Msg.GetDimensions()),
		ElectricalParams: electricalFromProto(req.Msg.GetElectrical()),
		Model3DPath:      model3dPath,
		Metadata:         json.RawMessage(req.Msg.GetMetadataJson()),
	})
	if err != nil {
		return nil, assetConnectError(err)
	}
	return connect.NewResponse(&assetv1.CreateAssetResponse{Asset: assetToProto(asset)}), nil
}

func (h *ConnectAssetService) GetAsset(ctx context.Context, req *connect.Request[assetv1.GetAssetRequest]) (*connect.Response[assetv1.GetAssetResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid asset id: %v", err).ToConnectError()
	}
	asset, err := h.svc.GetByID(ctx, id)
	if err != nil {
		return nil, assetConnectError(err)
	}
	return connect.NewResponse(&assetv1.GetAssetResponse{Asset: assetToProto(asset)}), nil
}

func (h *ConnectAssetService) ListAssets(ctx context.Context, req *connect.Request[assetv1.ListAssetsRequest]) (*connect.Response[assetv1.ListAssetsResponse], error) {
	pagination := req.Msg.GetPagination()
	offset := pagination.GetPageOffset()
	size := pagination.GetPageSize()
	if size == 0 {
		size = 10
	}
	if size > 100 {
		size = 100
	}

	filter := domain.AssetFilter{}
	if c := req.Msg.GetCategoryFilter(); c != assetv1.AssetCategory_ASSET_CATEGORY_UNSPECIFIED {
		cat := assetCategoryFromProto(c)
		filter.Category = &cat
	}
	if m := req.Msg.GetManufacturerFilter(); m != "" {
		filter.Manufacturer = &m
	}

	var (
		assets []domain.Asset
		err    error
	)
	if filter.Category != nil || filter.Manufacturer != nil {
		assets, err = h.svc.Search(ctx, filter)
	} else {
		assets, err = h.svc.List(ctx)
	}
	if err != nil {
		return nil, assetConnectError(err)
	}

	// Apply pagination
	totalCount := int32(len(assets))
	endIdx := int(offset) + int(size)
	if endIdx > len(assets) {
		endIdx = len(assets)
	}
	if int(offset) > len(assets) {
		endIdx = int(offset)
	}

	var paginatedAssets []domain.Asset
	if int(offset) < len(assets) {
		paginatedAssets = assets[int(offset):endIdx]
	}

	out := make([]*assetv1.Asset, 0, len(paginatedAssets))
	for i := range paginatedAssets {
		a := paginatedAssets[i]
		out = append(out, assetToProto(&a))
	}

	hasNext := int(offset)+int(size) < int(totalCount)

	return connect.NewResponse(&assetv1.ListAssetsResponse{
		Assets: out,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: totalCount,
			PageOffset: offset,
			PageSize:   size,
			HasNext:    hasNext,
		},
	}), nil
}

func (h *ConnectAssetService) UpdateAsset(ctx context.Context, req *connect.Request[assetv1.UpdateAssetRequest]) (*connect.Response[assetv1.UpdateAssetResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid asset id: %v", err).ToConnectError()
	}

	update := domain.UpdateAssetRequest{}
	if v := req.Msg.GetName(); v != "" {
		update.Name = &v
	}
	if v := req.Msg.GetManufacturer(); v != "" {
		update.Manufacturer = &v
	}
	if v := req.Msg.GetModel(); v != "" {
		update.Model = &v
	}
	if req.Msg.GetDimensions() != nil {
		d := dimensionsFromProto(req.Msg.GetDimensions())
		update.Dimensions = &d
	}
	if req.Msg.GetElectrical() != nil {
		e := electricalFromProto(req.Msg.GetElectrical())
		update.ElectricalParams = &e
	}
	if v := req.Msg.GetModel_3DPath(); v != "" {
		update.Model3DPath = &v
	}
	if v := req.Msg.GetMetadataJson(); v != "" {
		update.Metadata = json.RawMessage(v)
	}

	asset, err := h.svc.Update(ctx, id, update)
	if err != nil {
		return nil, assetConnectError(err)
	}
	return connect.NewResponse(&assetv1.UpdateAssetResponse{Asset: assetToProto(asset)}), nil
}

func (h *ConnectAssetService) DeleteAsset(ctx context.Context, req *connect.Request[assetv1.DeleteAssetRequest]) (*connect.Response[assetv1.DeleteAssetResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid asset id: %v", err).ToConnectError()
	}
	if err := h.svc.Delete(ctx, id); err != nil {
		return nil, assetConnectError(err)
	}
	return connect.NewResponse(&assetv1.DeleteAssetResponse{}), nil
}

func assetToProto(a *domain.Asset) *assetv1.Asset {
	if a == nil {
		return nil
	}
	return &assetv1.Asset{
		Id:           a.ID.String(),
		Name:         a.Name,
		Manufacturer: a.Manufacturer,
		Model:        a.Model,
		Category:     assetCategoryToProto(a.Category),
		Dimensions: &assetv1.Dimensions{
			WidthMm:  a.Dimensions.WidthMM,
			HeightMm: a.Dimensions.HeightMM,
			DepthMm:  a.Dimensions.DepthMM,
			WeightKg: a.Dimensions.WeightKG,
		},
		Electrical: &assetv1.ElectricalParameters{
			RatedPowerW:       a.ElectricalParams.RatedPowerW,
			Voc:               a.ElectricalParams.VocV,
			Isc:               a.ElectricalParams.IscA,
			Vmp:               a.ElectricalParams.VmpV,
			Imp:               a.ElectricalParams.ImpA,
			Efficiency:        a.ElectricalParams.EfficiencyPercent,
			MaxDcInputW:       a.ElectricalParams.MaxDCInputKW,
			MaxAcOutputW:      a.ElectricalParams.MaxACOutputKW,
			MpptCount:         int32(a.ElectricalParams.MPPTCount),
			MaxInputVoltage:   a.ElectricalParams.MaxInputVoltage,
			MinInputVoltage:   a.ElectricalParams.MPPTRangeMinV,
			MaxStringsPerMppt: int32(a.ElectricalParams.MaxStringsPerMPPT),
			KvaRating:         a.ElectricalParams.RatedKVA,
			PrimaryVoltage:    a.ElectricalParams.PrimaryVoltage,
			SecondaryVoltage:  a.ElectricalParams.SecondaryVoltage,
		},
		Model_3DPath: func() string {
			if a.Model3DPath == nil {
				return ""
			}
			return *a.Model3DPath
		}(),
		DatasheetPath: func() string {
			if a.DatasheetPath == nil {
				return ""
			}
			return *a.DatasheetPath
		}(),
		MetadataJson: string(a.Metadata),
	}
}

func dimensionsFromProto(d *assetv1.Dimensions) domain.Dimensions {
	if d == nil {
		return domain.Dimensions{}
	}
	return domain.Dimensions{
		WidthMM:  d.GetWidthMm(),
		HeightMM: d.GetHeightMm(),
		DepthMM:  d.GetDepthMm(),
		WeightKG: d.GetWeightKg(),
	}
}

func electricalFromProto(e *assetv1.ElectricalParameters) domain.ElectricalParameters {
	if e == nil {
		return domain.ElectricalParameters{}
	}
	return domain.ElectricalParameters{
		RatedPowerW:       e.GetRatedPowerW(),
		VocV:              e.GetVoc(),
		IscA:              e.GetIsc(),
		VmpV:              e.GetVmp(),
		ImpA:              e.GetImp(),
		EfficiencyPercent: e.GetEfficiency(),
		MaxDCInputKW:      e.GetMaxDcInputW(),
		MaxACOutputKW:     e.GetMaxAcOutputW(),
		MPPTCount:         int(e.GetMpptCount()),
		MaxInputVoltage:   e.GetMaxInputVoltage(),
		MPPTRangeMinV:     e.GetMinInputVoltage(),
		MaxStringsPerMPPT: int(e.GetMaxStringsPerMppt()),
		RatedKVA:          e.GetKvaRating(),
		PrimaryVoltage:    e.GetPrimaryVoltage(),
		SecondaryVoltage:  e.GetSecondaryVoltage(),
	}
}

func assetCategoryFromProto(c assetv1.AssetCategory) domain.AssetCategory {
	switch c {
	case assetv1.AssetCategory_ASSET_CATEGORY_SOLAR_PANEL:
		return domain.AssetCategoryPanel
	case assetv1.AssetCategory_ASSET_CATEGORY_TRACKER:
		return domain.AssetCategoryTracker
	case assetv1.AssetCategory_ASSET_CATEGORY_STRING_INVERTER, assetv1.AssetCategory_ASSET_CATEGORY_CENTRAL_INVERTER:
		return domain.AssetCategoryInverter
	case assetv1.AssetCategory_ASSET_CATEGORY_TRANSFORMER:
		return domain.AssetCategoryTransformer
	case assetv1.AssetCategory_ASSET_CATEGORY_CABLE:
		return domain.AssetCategoryCable
	case assetv1.AssetCategory_ASSET_CATEGORY_MOUNTING_STRUCTURE:
		return domain.AssetCategoryMounting
	default:
		return domain.AssetCategoryOther
	}
}

func assetCategoryToProto(c domain.AssetCategory) assetv1.AssetCategory {
	switch c {
	case domain.AssetCategoryPanel:
		return assetv1.AssetCategory_ASSET_CATEGORY_SOLAR_PANEL
	case domain.AssetCategoryTracker:
		return assetv1.AssetCategory_ASSET_CATEGORY_TRACKER
	case domain.AssetCategoryInverter:
		return assetv1.AssetCategory_ASSET_CATEGORY_STRING_INVERTER
	case domain.AssetCategoryTransformer:
		return assetv1.AssetCategory_ASSET_CATEGORY_TRANSFORMER
	case domain.AssetCategoryCable:
		return assetv1.AssetCategory_ASSET_CATEGORY_CABLE
	case domain.AssetCategoryMounting:
		return assetv1.AssetCategory_ASSET_CATEGORY_MOUNTING_STRUCTURE
	default:
		return assetv1.AssetCategory_ASSET_CATEGORY_UNSPECIFIED
	}
}

func assetConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return pkgErrors.NotFound("asset", "").ToConnectError()
	default:
		if pkgErr, ok := err.(*pkgErrors.Error); ok {
			return pkgErr.ToConnectError()
		}
		return pkgErrors.Internal("asset operation failed: %s", err.Error()).ToConnectError()
	}
}
