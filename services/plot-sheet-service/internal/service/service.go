package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"strconv"
	"strings"
	"time"

	connect "connectrpc.com/connect"
	"github.com/go-pdf/fpdf"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	sharedcad "p9e.in/samavaya/packages/cad"
)

var (
	ErrInvalidInput = errors.New("invalid input")
	ErrNotFound     = errors.New("not found")
	ErrConflict     = errors.New("conflict")
)

const (
	ConflictCodeStaleRevision = "stale_revision"
)

type ConflictError struct {
	Code           string
	OutcomeCode    string
	Message        string
	AttemptID      string
	BaseRevisionID string
	HeadRevisionID string
	HeadVersion    uint32
	RetryAfterMs   int
}

func (e *ConflictError) Error() string {
	if e == nil {
		return ErrConflict.Error()
	}
	if strings.TrimSpace(e.Message) != "" {
		return fmt.Sprintf("%s: %s", ErrConflict.Error(), e.Message)
	}
	return ErrConflict.Error()
}

func (e *ConflictError) Unwrap() error {
	return ErrConflict
}

type Service struct {
	revisions      drawingv1connect.DrawingRevisionServiceClient
	cad            drawingv1connect.CadCoreServiceClient
	logger         zerolog.Logger
	requestTimeout time.Duration
}

type transform struct {
	scale   float64
	offsetX float64
	offsetY float64
	pageH   float64
	margin  float64
}

func New(revisions drawingv1connect.DrawingRevisionServiceClient, cadClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, requestTimeout time.Duration) *Service {
	return &Service{revisions: revisions, cad: cadClient, logger: logger.With().Str("component", "service").Logger(), requestTimeout: requestTimeout}
}

func (s *Service) CreateSheet(ctx context.Context, req *drawingv1.CreateSheetRequest) (*drawingv1.CreateSheetResponse, error) {
	if req == nil || req.GetSheet() == nil {
		return nil, fmt.Errorf("%w: sheet payload is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if req.GetSheet().GetPageWidthMm() <= 0 || req.GetSheet().GetPageHeightMm() <= 0 {
		return nil, fmt.Errorf("%w: page dimensions must be positive", ErrInvalidInput)
	}
	metadata, err := sharedcad.MergeMetadata(req.GetMetadataJson(), map[string]any{"sheet": map[string]any{"managed": true}})
	if err != nil {
		return nil, fmt.Errorf("%w: metadata_json merge failed: %v", ErrInvalidInput, err)
	}
	entity := &drawingv1.DrawingEntity{Header: sharedcad.NewHeader(req.GetDrawingId(), "sheet:"+req.GetSheet().GetSheetId(), drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_SHEET, req.GetLayerId(), req.GetLayerName(), req.GetStyleId(), req.GetStyleName(), metadata, sharedcad.DefaultContract(req.GetContract(), "plot-sheet-service")), Geometry: &drawingv1.DrawingEntity_Sheet{Sheet: req.GetSheet()}}
	commitResponse, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), defaultSummary(req.GetSummary(), req.GetSheet().GetSheetId()), req.GetContract(), []*drawingv1.DrawingMutation{sharedcad.CreateMutation(entity)})
	if err != nil {
		return nil, err
	}
	return &drawingv1.CreateSheetResponse{Drawing: commitResponse.GetDrawing(), Revision: commitResponse.GetRevision(), SheetEntity: entity}, nil
}

func (s *Service) PublishDrawing(ctx context.Context, req *drawingv1.PublishDrawingRequest) (*drawingv1.PublishDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetRevisionId())
	if err != nil {
		return nil, err
	}
	sheets, err := selectSheets(state.GetRevision().GetEntities(), req.GetSheetIds())
	if err != nil {
		return nil, err
	}
	layers := sharedcad.LayerDefinitions(state.GetRevision().GetEntities())
	definitions := sharedcad.BlockDefinitions(state.GetRevision().GetEntities())
	artifacts := make([]*drawingv1.PublishedSheetArtifact, 0, len(sheets))
	manifest := make([]map[string]any, 0, len(sheets))
	format := req.GetFormat()
	if format == drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_UNSPECIFIED {
		format = drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_SVG
	}
	for _, sheetEntity := range sheets {
		sheet := sheetEntity.GetSheet()
		renderables := collectRenderableEntities(state.GetRevision().GetEntities(), sheet.GetViewportEntityIds(), layers)
		if len(renderables) == 0 {
			return nil, fmt.Errorf("%w: sheet %s has no plottable entities", ErrInvalidInput, sheet.GetSheetId())
		}
		payload, contentType, fileName, err := renderSheet(sheet, renderables, definitions, layers, format, req.GetOptions())
		if err != nil {
			return nil, err
		}
		artifacts = append(artifacts, &drawingv1.PublishedSheetArtifact{SheetId: sheet.GetSheetId(), Title: sheet.GetTitle(), Format: format, FileName: fileName, ContentType: contentType, Payload: payload})
		manifest = append(manifest, map[string]any{"sheet_id": sheet.GetSheetId(), "title": sheet.GetTitle(), "file_name": fileName, "content_type": contentType, "size_bytes": len(payload)})
	}
	manifestJSON, _ := json.Marshal(manifest)
	return &drawingv1.PublishDrawingResponse{Artifacts: artifacts, ManifestJson: string(manifestJSON)}, nil
}

func (s *Service) loadState(ctx context.Context, drawingID string, revisionID string) (*drawingv1.GetDrawingStateResponse, error) {
	if _, err := sharedcad.ParseUUID(drawingID, "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.revisions.GetDrawingState(callCtx, connect.NewRequest(&drawingv1.GetDrawingStateRequest{DrawingId: drawingID, RevisionId: revisionID}))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) commit(ctx context.Context, drawingID string, baseRevisionID string, author string, summary string, contract *commonv1.ContractMetadata, mutations []*drawingv1.DrawingMutation) (*drawingv1.CommitDrawingCommandResponse, error) {
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.cad.CommitDrawingCommand(callCtx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{BaseRevisionId: baseRevisionID, Summary: summary, Command: &drawingv1.DrawingCommand{CommandId: uuid.NewString(), DrawingId: drawingID, Actor: author, Mutations: mutations, Contract: sharedcad.DefaultContract(contract, "plot-sheet-service")}}))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func selectSheets(entities []*drawingv1.DrawingEntity, requested []string) ([]*drawingv1.DrawingEntity, error) {
	all := sharedcad.SheetEntities(entities)
	if len(all) == 0 {
		return nil, fmt.Errorf("%w: no sheets defined for drawing", ErrNotFound)
	}
	if len(requested) == 0 {
		return all, nil
	}
	requestedSet := make(map[string]struct{}, len(requested))
	for _, id := range requested {
		requestedSet[id] = struct{}{}
	}
	selected := make([]*drawingv1.DrawingEntity, 0)
	for _, entity := range all {
		if _, ok := requestedSet[entity.GetSheet().GetSheetId()]; ok {
			selected = append(selected, entity)
		}
	}
	if len(selected) == 0 {
		return nil, fmt.Errorf("%w: requested sheets not found", ErrNotFound)
	}
	return selected, nil
}

func collectRenderableEntities(entities []*drawingv1.DrawingEntity, viewportIDs []string, layers map[string]*drawingv1.LayerDefinitionEntity) []*drawingv1.DrawingEntity {
	viewportSet := make(map[string]struct{}, len(viewportIDs))
	for _, id := range viewportIDs {
		viewportSet[id] = struct{}{}
	}
	result := make([]*drawingv1.DrawingEntity, 0)
	for _, entity := range entities {
		if entity == nil || entity.GetHeader() == nil {
			continue
		}
		if entity.GetHeader().GetEntityType() == drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_LAYER_DEFINITION || entity.GetHeader().GetEntityType() == drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_BLOCK_DEFINITION || entity.GetHeader().GetEntityType() == drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_SHEET {
			continue
		}
		if len(viewportSet) > 0 {
			if _, ok := viewportSet[entity.GetHeader().GetEntityId()]; !ok {
				continue
			}
		}
		if layer := layers[entity.GetHeader().GetLayer().GetLayerId()]; layer != nil {
			if !layer.GetPlottable() || !layer.GetVisible() {
				continue
			}
		}
		result = append(result, entity)
	}
	return result
}

func renderSheet(sheet *drawingv1.SheetEntity, entities []*drawingv1.DrawingEntity, definitions map[string]*drawingv1.BlockDefinitionEntity, layers map[string]*drawingv1.LayerDefinitionEntity, format drawingv1.PlotOutputFormat, options *drawingv1.PlotOptions) ([]byte, string, string, error) {
	bounds, ok := drawingBounds(entities, definitions)
	if !ok {
		return nil, "", "", fmt.Errorf("%w: unable to determine drawing bounds", ErrInvalidInput)
	}
	transform := newTransform(sheet, bounds)
	switch format {
	case drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_PDF:
		payload, err := renderPDF(sheet, entities, definitions, layers, transform, options)
		return payload, "application/pdf", sheetFileName(sheet, "pdf"), err
	default:
		payload, err := renderSVG(sheet, entities, definitions, layers, transform, options)
		return payload, "image/svg+xml", sheetFileName(sheet, "svg"), err
	}
}

func drawingBounds(entities []*drawingv1.DrawingEntity, definitions map[string]*drawingv1.BlockDefinitionEntity) (sharedcad.Bounds, bool) {
	hasBounds := false
	var result sharedcad.Bounds
	for _, entity := range expandEntities(entities, definitions) {
		bounds, ok := sharedcad.BoundsOf(entity)
		if !ok {
			continue
		}
		if !hasBounds {
			result = bounds
			hasBounds = true
			continue
		}
		result = sharedcad.UnionBounds(result, bounds)
	}
	return result, hasBounds
}

func expandEntities(entities []*drawingv1.DrawingEntity, definitions map[string]*drawingv1.BlockDefinitionEntity) []*drawingv1.DrawingEntity {
	result := make([]*drawingv1.DrawingEntity, 0)
	for _, entity := range entities {
		if blockRef, ok := entity.GetGeometry().(*drawingv1.DrawingEntity_BlockReference); ok {
			definition := definitions[blockRef.BlockReference.GetBlockDefinitionId()]
			if definition == nil {
				continue
			}
			for _, child := range definition.GetEntities() {
				result = append(result, applyBlockTransform(child, blockRef.BlockReference))
			}
			continue
		}
		result = append(result, entity)
	}
	return result
}

func applyBlockTransform(entity *drawingv1.DrawingEntity, ref *drawingv1.BlockReferenceEntity) *drawingv1.DrawingEntity {
	next := sharedcad.CloneEntity(entity)
	transformPoint := func(point *commonv1.Point2D) *commonv1.Point2D {
		if point == nil {
			return &commonv1.Point2D{}
		}
		x := point.GetX() * ref.GetScaleX()
		y := point.GetY() * ref.GetScaleY()
		radians := ref.GetRotationDeg() * math.Pi / 180
		rotatedX := x*math.Cos(radians) - y*math.Sin(radians)
		rotatedY := x*math.Sin(radians) + y*math.Cos(radians)
		return &commonv1.Point2D{X: ref.GetInsertionPoint().GetX() + rotatedX, Y: ref.GetInsertionPoint().GetY() + rotatedY}
	}
	switch geometry := next.Geometry.(type) {
	case *drawingv1.DrawingEntity_Polyline:
		for index, point := range geometry.Polyline.GetVertices() {
			geometry.Polyline.Vertices[index] = transformPoint(point)
		}
	case *drawingv1.DrawingEntity_Polygon:
		for ringIndex, ring := range geometry.Polygon.GetGeometry().GetRings() {
			for vertexIndex, point := range ring.GetPoints() {
				geometry.Polygon.Geometry.Rings[ringIndex].Points[vertexIndex] = transformPoint(point)
			}
		}
	case *drawingv1.DrawingEntity_Text:
		geometry.Text.Anchor = transformPoint(geometry.Text.GetAnchor())
	case *drawingv1.DrawingEntity_Dimension:
		geometry.Dimension.Start = transformPoint(geometry.Dimension.GetStart())
		geometry.Dimension.End = transformPoint(geometry.Dimension.GetEnd())
		geometry.Dimension.TextAnchor = transformPoint(geometry.Dimension.GetTextAnchor())
	case *drawingv1.DrawingEntity_Leader:
		for index, point := range geometry.Leader.GetVertices() {
			geometry.Leader.Vertices[index] = transformPoint(point)
		}
	}
	return next
}

func newTransform(sheet *drawingv1.SheetEntity, bounds sharedcad.Bounds) transform {
	margin := 10.0
	usableW := sheet.GetPageWidthMm() - 2*margin
	usableH := sheet.GetPageHeightMm() - 2*margin
	boundsW := math.Max(bounds.MaxX-bounds.MinX, 1)
	boundsH := math.Max(bounds.MaxY-bounds.MinY, 1)
	scale := math.Min(usableW/boundsW, usableH/boundsH)
	if sheet.GetViewScale() > 0 {
		scale = sheet.GetViewScale()
	}
	return transform{scale: scale, offsetX: margin - bounds.MinX*scale, offsetY: margin - bounds.MinY*scale, pageH: sheet.GetPageHeightMm(), margin: margin}
}

func renderSVG(sheet *drawingv1.SheetEntity, entities []*drawingv1.DrawingEntity, definitions map[string]*drawingv1.BlockDefinitionEntity, layers map[string]*drawingv1.LayerDefinitionEntity, tx transform, options *drawingv1.PlotOptions) ([]byte, error) {
	buffer := bytes.NewBufferString(fmt.Sprintf("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"%fmm\" height=\"%fmm\" viewBox=\"0 0 %f %f\">", sheet.GetPageWidthMm(), sheet.GetPageHeightMm(), sheet.GetPageWidthMm(), sheet.GetPageHeightMm()))
	buffer.WriteString("<rect x=\"0\" y=\"0\" width=\"100%\" height=\"100%\" fill=\"white\" stroke=\"#111827\" stroke-width=\"0.2\"/>")
	for _, entity := range expandEntities(entities, definitions) {
		color := layerColor(layers, entity.GetHeader().GetLayer().GetLayerId(), options)
		strokeWidth := strokeWidth(options)
		switch geometry := entity.Geometry.(type) {
		case *drawingv1.DrawingEntity_Polyline:
			points := make([]string, 0, len(geometry.Polyline.GetVertices()))
			for _, point := range geometry.Polyline.GetVertices() {
				points = append(points, svgPoint(point, tx))
			}
			tag := "polyline"
			if geometry.Polyline.GetClosed() {
				tag = "polygon"
			}
			buffer.WriteString(fmt.Sprintf("<%s points=\"%s\" fill=\"none\" stroke=\"%s\" stroke-width=\"%f\"/>", tag, strings.Join(points, " "), color, strokeWidth))
		case *drawingv1.DrawingEntity_Polygon:
			for _, ring := range geometry.Polygon.GetGeometry().GetRings() {
				points := make([]string, 0, len(ring.GetPoints()))
				for _, point := range ring.GetPoints() {
					points = append(points, svgPoint(point, tx))
				}
				buffer.WriteString(fmt.Sprintf("<polygon points=\"%s\" fill=\"none\" stroke=\"%s\" stroke-width=\"%f\"/>", strings.Join(points, " "), color, strokeWidth))
			}
		case *drawingv1.DrawingEntity_Text:
			p := mapPoint(geometry.Text.GetAnchor(), tx)
			buffer.WriteString(fmt.Sprintf("<text x=\"%f\" y=\"%f\" font-size=\"%f\" fill=\"%s\">%s</text>", p.X, p.Y, math.Max(geometry.Text.GetHeight()*tx.scale, 2), color, escapeXML(geometry.Text.GetText())))
		case *drawingv1.DrawingEntity_Dimension:
			start := mapPoint(geometry.Dimension.GetStart(), tx)
			end := mapPoint(geometry.Dimension.GetEnd(), tx)
			text := mapPoint(geometry.Dimension.GetTextAnchor(), tx)
			buffer.WriteString(fmt.Sprintf("<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" stroke=\"%s\" stroke-width=\"%f\"/>", start.X, start.Y, end.X, end.Y, color, strokeWidth))
			buffer.WriteString(fmt.Sprintf("<text x=\"%f\" y=\"%f\" font-size=\"3\" fill=\"%s\">%.*f %s</text>", text.X, text.Y, color, int(geometry.Dimension.GetPrecision()), distance(geometry.Dimension.GetStart(), geometry.Dimension.GetEnd()), geometry.Dimension.GetUnit()))
		case *drawingv1.DrawingEntity_Leader:
			points := make([]string, 0, len(geometry.Leader.GetVertices()))
			for _, point := range geometry.Leader.GetVertices() {
				points = append(points, svgPoint(point, tx))
			}
			buffer.WriteString(fmt.Sprintf("<polyline points=\"%s\" fill=\"none\" stroke=\"%s\" stroke-width=\"%f\"/>", strings.Join(points, " "), color, strokeWidth))
		}
	}
	buffer.WriteString(fmt.Sprintf("<text x=\"%f\" y=\"%f\" font-size=\"4\" fill=\"#111827\">%s</text>", tx.margin, sheet.GetPageHeightMm()-tx.margin/2, escapeXML(sheet.GetTitle())))
	buffer.WriteString("</svg>")
	return buffer.Bytes(), nil
}

func renderPDF(sheet *drawingv1.SheetEntity, entities []*drawingv1.DrawingEntity, definitions map[string]*drawingv1.BlockDefinitionEntity, layers map[string]*drawingv1.LayerDefinitionEntity, tx transform, options *drawingv1.PlotOptions) ([]byte, error) {
	pdf := fpdf.NewCustom(&fpdf.InitType{UnitStr: "mm", Size: fpdf.SizeType{Wd: sheet.GetPageWidthMm(), Ht: sheet.GetPageHeightMm()}})
	pdf.AddPage()
	pdf.SetLineWidth(strokeWidth(options))
	pdf.SetDrawColor(17, 24, 39)
	pdf.Rect(0, 0, sheet.GetPageWidthMm(), sheet.GetPageHeightMm(), "D")
	for _, entity := range expandEntities(entities, definitions) {
		setPDFColor(pdf, layerColor(layers, entity.GetHeader().GetLayer().GetLayerId(), options))
		switch geometry := entity.Geometry.(type) {
		case *drawingv1.DrawingEntity_Polyline:
			drawPolylinePDF(pdf, geometry.Polyline.GetVertices(), tx, geometry.Polyline.GetClosed())
		case *drawingv1.DrawingEntity_Polygon:
			for _, ring := range geometry.Polygon.GetGeometry().GetRings() {
				drawPolylinePDF(pdf, ring.GetPoints(), tx, true)
			}
		case *drawingv1.DrawingEntity_Text:
			p := mapPoint(geometry.Text.GetAnchor(), tx)
			pdf.SetXY(p.X, p.Y)
			pdf.SetFont("Arial", "", math.Max(geometry.Text.GetHeight()*tx.scale, 2))
			pdf.CellFormat(0, 4, geometry.Text.GetText(), "", 0, "", false, 0, "")
		case *drawingv1.DrawingEntity_Dimension:
			start := mapPoint(geometry.Dimension.GetStart(), tx)
			end := mapPoint(geometry.Dimension.GetEnd(), tx)
			pdf.Line(start.X, start.Y, end.X, end.Y)
			text := mapPoint(geometry.Dimension.GetTextAnchor(), tx)
			pdf.SetXY(text.X, text.Y)
			pdf.SetFont("Arial", "", 2.5)
			pdf.CellFormat(0, 4, fmt.Sprintf("%.*f %s", int(geometry.Dimension.GetPrecision()), distance(geometry.Dimension.GetStart(), geometry.Dimension.GetEnd()), geometry.Dimension.GetUnit()), "", 0, "", false, 0, "")
		case *drawingv1.DrawingEntity_Leader:
			drawPolylinePDF(pdf, geometry.Leader.GetVertices(), tx, false)
		}
	}
	pdf.SetXY(tx.margin, sheet.GetPageHeightMm()-tx.margin)
	pdf.SetFont("Arial", "B", 4)
	pdf.CellFormat(0, 4, sheet.GetTitle(), "", 0, "", false, 0, "")
	buffer := &bytes.Buffer{}
	if err := pdf.Output(buffer); err != nil {
		return nil, err
	}
	return buffer.Bytes(), nil
}

func drawPolylinePDF(pdf *fpdf.Fpdf, points []*commonv1.Point2D, tx transform, closed bool) {
	if len(points) < 2 {
		return
	}
	for index := 0; index < len(points)-1; index++ {
		start := mapPoint(points[index], tx)
		end := mapPoint(points[index+1], tx)
		pdf.Line(start.X, start.Y, end.X, end.Y)
	}
	if closed {
		start := mapPoint(points[len(points)-1], tx)
		end := mapPoint(points[0], tx)
		pdf.Line(start.X, start.Y, end.X, end.Y)
	}
}

func mapPoint(point *commonv1.Point2D, tx transform) commonv1.Point2D {
	return commonv1.Point2D{X: tx.offsetX + point.GetX()*tx.scale, Y: tx.pageH - (tx.offsetY + point.GetY()*tx.scale)}
}

func svgPoint(point *commonv1.Point2D, tx transform) string {
	mapped := mapPoint(point, tx)
	return fmt.Sprintf("%f,%f", mapped.X, mapped.Y)
}

func strokeWidth(options *drawingv1.PlotOptions) float64 {
	if options == nil || options.GetStrokeWidthMm() <= 0 {
		return 0.35
	}
	return options.GetStrokeWidthMm()
}

func layerColor(layers map[string]*drawingv1.LayerDefinitionEntity, layerID string, options *drawingv1.PlotOptions) string {
	if options != nil && options.GetMonochrome() {
		return "#111827"
	}
	if layer := layers[layerID]; layer != nil {
		return sharedcad.NormalizeColorHex(layer.GetColorHex())
	}
	return "#111827"
}

func setPDFColor(pdf *fpdf.Fpdf, hex string) {
	var red, green, blue int
	if _, err := fmt.Sscanf(strings.TrimPrefix(hex, "#"), "%02x%02x%02x", &red, &green, &blue); err != nil {
		red, green, blue = 17, 24, 39
	}
	pdf.SetDrawColor(red, green, blue)
	pdf.SetTextColor(red, green, blue)
}

func sheetFileName(sheet *drawingv1.SheetEntity, extension string) string {
	base := strings.ToLower(strings.ReplaceAll(strings.TrimSpace(sheet.GetTitle()), " ", "-"))
	if base == "" {
		base = sheet.GetSheetId()
	}
	return fmt.Sprintf("%s.%s", base, extension)
}

func distance(start *commonv1.Point2D, end *commonv1.Point2D) float64 {
	deltaX := end.GetX() - start.GetX()
	deltaY := end.GetY() - start.GetY()
	return math.Sqrt(deltaX*deltaX + deltaY*deltaY)
}

func escapeXML(value string) string {
	replacer := strings.NewReplacer("&", "&amp;", "<", "&lt;", ">", "&gt;", `"`, "&quot;", "'", "&apos;")
	return replacer.Replace(value)
}

func defaultSummary(summary string, sheetID string) string {
	trimmed := strings.TrimSpace(summary)
	if trimmed != "" {
		return trimmed
	}
	return fmt.Sprintf("Create sheet %s", sheetID)
}

func translateConnectError(err error) error {
	var connectErr *connect.Error
	if !errors.As(err, &connectErr) {
		return err
	}
	switch connectErr.Code() {
	case connect.CodeInvalidArgument:
		return fmt.Errorf("%w: %v", ErrInvalidInput, connectErr.Message())
	case connect.CodeNotFound:
		return fmt.Errorf("%w: %v", ErrNotFound, connectErr.Message())
	case connect.CodeAlreadyExists, connect.CodeAborted, connect.CodeFailedPrecondition:
		if conflictErr := conflictFromConnectError(connectErr); conflictErr != nil {
			return conflictErr
		}
		return fmt.Errorf("%w: %v", ErrConflict, connectErr.Message())
	default:
		return err
	}
}

func conflictFromConnectError(connectErr *connect.Error) *ConflictError {
	if connectErr == nil {
		return nil
	}
	code := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-error-code"))
	outcomeCode := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-outcome-code"))
	attemptID := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-attempt-id"))
	baseRevisionID := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-base-revision-id"))
	headRevisionID := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-head-revision-id"))
	headVersion := parseHeaderUint32(connectErr.Meta().Get("x-solar3d-head-version"))
	retryAfterMs := parseRetryAfterMs(connectErr.Meta().Get("retry-after"))

	if code == "" && strings.Contains(strings.ToLower(connectErr.Message()), "stale") {
		code = ConflictCodeStaleRevision
	}
	if code == "" && outcomeCode == "" && attemptID == "" && baseRevisionID == "" && headRevisionID == "" && headVersion == 0 && retryAfterMs == 0 {
		return nil
	}

	return &ConflictError{
		Code:           code,
		OutcomeCode:    outcomeCode,
		Message:        connectErr.Message(),
		AttemptID:      attemptID,
		BaseRevisionID: baseRevisionID,
		HeadRevisionID: headRevisionID,
		HeadVersion:    headVersion,
		RetryAfterMs:   retryAfterMs,
	}
}

func parseRetryAfterMs(value string) int {
	seconds, err := strconv.ParseFloat(strings.TrimSpace(value), 64)
	if err != nil || seconds <= 0 {
		return 0
	}
	return int(seconds * 1000)
}

func parseHeaderUint32(value string) uint32 {
	parsed, err := strconv.ParseUint(strings.TrimSpace(value), 10, 32)
	if err != nil {
		return 0
	}
	return uint32(parsed)
}

