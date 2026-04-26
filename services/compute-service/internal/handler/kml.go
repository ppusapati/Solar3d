package handler

import (
	"context"
	"fmt"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	kmlv1 "p9e.in/samavaya/solar3d/gen/kml/v1"
	kmlv1connect "p9e.in/samavaya/solar3d/gen/kml/v1/kmlv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// KMLIngestionServiceHandler implements the KML ingestion gRPC service.
type KMLIngestionServiceHandler struct {
	svc *service.KMLService
}

// Compile-time check that handler implements the service
var _ kmlv1connect.KMLIngestionServiceHandler = (*KMLIngestionServiceHandler)(nil)

// NewKMLIngestionServiceHandler creates a new KML handler.
func NewKMLIngestionServiceHandler(svc *service.KMLService) *KMLIngestionServiceHandler {
	return &KMLIngestionServiceHandler{svc: svc}
}

// UploadKML handles KML/KMZ file uploads and initiates async processing.
func (h *KMLIngestionServiceHandler) UploadKML(
	ctx context.Context,
	req *connect.Request[kmlv1.UploadKMLRequest],
) (*connect.Response[kmlv1.UploadKMLResponse], error) {
	if req == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("request is nil"))
	}

	if req.Msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("request message is nil"))
	}

	if len(req.Msg.FileData) == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("file data is empty"))
	}

	if req.Msg.FileName == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("file name is required"))
	}

	// Convert CRS enum to int (0 = UNKNOWN, use default 4326)
	sourceCRS := 4326
	if req.Msg.SourceCrs != kmlv1.CRSCode_CRS_UNKNOWN {
		sourceCRS = int(req.Msg.SourceCrs)
	}

	// Call service
	uploadJobID, err := h.svc.UploadKML(ctx, req.Msg.FileData, req.Msg.FileName, sourceCRS, req.Msg.ProjectId, req.Msg.Tags)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Build response
	resp := &kmlv1.UploadKMLResponse{
		UploadJobId: uploadJobID,
		Status:      kmlv1.UploadStatus_STATUS_PENDING,
	}

	return connect.NewResponse(resp), nil
}

// GetUploadStatus retrieves the status of a KML upload job.
func (h *KMLIngestionServiceHandler) GetUploadStatus(
	ctx context.Context,
	req *connect.Request[kmlv1.GetUploadStatusRequest],
) (*connect.Response[kmlv1.GetUploadStatusResponse], error) {
	if req == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("request is nil"))
	}

	if req.Msg.UploadJobId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("upload job ID is required"))
	}

	// Call service
	job, err := h.svc.GetUploadStatus(ctx, req.Msg.UploadJobId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	if job == nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("upload job not found"))
	}

	// Convert status string to enum
	statusEnum := statusStringToEnum(job.Status)
	crsCRS := kmlv1.CRSCode(job.SourceCRSEPSG)

	resp := &kmlv1.GetUploadStatusResponse{
		UploadJobId:       job.UploadJobID,
		Status:            statusEnum,
		FeaturesProcessed: int32(job.FeaturesProcessed),
		TotalFeatures:     int32(job.FeaturesTotal),
		ErrorMessage:      job.ErrorMessage,
		DetectedCrs:       crsCRS,
		StartedAt:         timestampFromPtr(job.StartedAt),
		CompletedAt:       timestampFromPtr(job.CompletedAt),
	}

	return connect.NewResponse(resp), nil
}

// ListImportedGeometries retrieves geometries from a completed upload.
func (h *KMLIngestionServiceHandler) ListImportedGeometries(
	ctx context.Context,
	req *connect.Request[kmlv1.ListImportedGeometriesRequest],
) (*connect.Response[kmlv1.ListImportedGeometriesResponse], error) {
	if req == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("request is nil"))
	}

	if req.Msg.UploadJobId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("upload job ID is required"))
	}

	limit := int(req.Msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(req.Msg.Offset)
	if offset < 0 {
		offset = 0
	}

	// Call service
	geometries, totalCount, err := h.svc.ListImportedGeometries(ctx, req.Msg.UploadJobId, req.Msg.GeometryType.String(), limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Convert geometries to proto stubs
	stubs := make([]*kmlv1.ImportedGeometryStub, 0, len(geometries))
	for _, geom := range geometries {
		stub := &kmlv1.ImportedGeometryStub{
			GeometryId: geom.GeometryID,
			Name:       geom.FeatureName,
			Type:       geometryTypeStringToEnum(geom.GeometryType),
			BoundingBox: &commonv1.BoundingBox2D{
				MinX: geom.BBoxMinX,
				MinY: geom.BBoxMinY,
				MaxX: geom.BBoxMaxX,
				MaxY: geom.BBoxMaxY,
			},
		}
		stubs = append(stubs, stub)
	}

	resp := &kmlv1.ListImportedGeometriesResponse{
		Geometries: stubs,
		TotalCount: int32(totalCount),
	}

	return connect.NewResponse(resp), nil
}

// GetImportedGeometry retrieves full details of a single geometry.
func (h *KMLIngestionServiceHandler) GetImportedGeometry(
	ctx context.Context,
	req *connect.Request[kmlv1.GetImportedGeometryRequest],
) (*connect.Response[kmlv1.GetImportedGeometryResponse], error) {
	if req == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("request is nil"))
	}

	if req.Msg.UploadJobId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("upload job ID is required"))
	}

	if req.Msg.GeometryId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("geometry ID is required"))
	}

	// Call service
	geom, err := h.svc.GetImportedGeometry(ctx, req.Msg.GeometryId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	if geom == nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("geometry not found"))
	}

	// Verify it belongs to the requested upload job
	if geom.UploadJobID != req.Msg.UploadJobId {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("geometry does not belong to this upload job"))
	}

	// Build response
	resp := &kmlv1.GetImportedGeometryResponse{
		GeometryId:   geom.GeometryID,
		Name:         geom.FeatureName,
		Description:  geom.FeatureDescription,
		Properties:   geom.FeatureProperties,
		Type:         geometryTypeStringToEnum(geom.GeometryType),
		SourceCrs:    kmlv1.CRSCode(geom.GeometrySourceCRS),
		GeometryHash: geom.GeometryHash,
		BoundingBox: &commonv1.BoundingBox2D{
			MinX: geom.BBoxMinX,
			MinY: geom.BBoxMinY,
			MaxX: geom.BBoxMaxX,
			MaxY: geom.BBoxMaxY,
		},
		ImportedAt: timestampFromTime(geom.ImportedAt),
	}

	return connect.NewResponse(resp), nil
}

// DeleteUpload removes an upload job and associated geometries.
func (h *KMLIngestionServiceHandler) DeleteUpload(
	ctx context.Context,
	req *connect.Request[kmlv1.DeleteUploadRequest],
) (*connect.Response[kmlv1.DeleteUploadResponse], error) {
	if req == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("request is nil"))
	}

	if req.Msg.UploadJobId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("upload job ID is required"))
	}

	// Call service
	count, err := h.svc.DeleteUpload(ctx, req.Msg.UploadJobId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &kmlv1.DeleteUploadResponse{
		UploadJobId:       req.Msg.UploadJobId,
		Deleted:           true,
		GeometriesDeleted: int32(count),
	}

	return connect.NewResponse(resp), nil
}

// --- Helper functions ---

func statusStringToEnum(status string) kmlv1.UploadStatus {
	switch status {
	case "PENDING":
		return kmlv1.UploadStatus_STATUS_PENDING
	case "PROCESSING":
		return kmlv1.UploadStatus_STATUS_PROCESSING
	case "COMPLETED":
		return kmlv1.UploadStatus_STATUS_COMPLETED
	case "FAILED":
		return kmlv1.UploadStatus_STATUS_FAILED
	default:
		return kmlv1.UploadStatus_STATUS_UNKNOWN
	}
}

func geometryTypeStringToEnum(geomType string) kmlv1.GeometryType {
	switch geomType {
	case "Point":
		return kmlv1.GeometryType_TYPE_POINT
	case "LineString":
		return kmlv1.GeometryType_TYPE_LINESTRING
	case "Polygon":
		return kmlv1.GeometryType_TYPE_POLYGON
	case "MultiPolygon":
		return kmlv1.GeometryType_TYPE_MULTIPOLYGON
	default:
		return kmlv1.GeometryType_TYPE_UNKNOWN
	}
}

func timestampFromPtr(t *time.Time) *timestamppb.Timestamp {
	if t == nil {
		return nil
	}
	return timestamppb.New(*t)
}

func timestampFromTime(t time.Time) *timestamppb.Timestamp {
	return timestamppb.New(t)
}
