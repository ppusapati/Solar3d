package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strconv"
	"strings"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"

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

type jsonEnvelope struct {
	Drawing  json.RawMessage `json:"drawing"`
	Revision json.RawMessage `json:"revision"`
	Entities json.RawMessage `json:"entities"`
	Lineage  json.RawMessage `json:"lineage,omitempty"`
}

type exportLineage struct {
	DrawingID      string `json:"drawing_id"`
	ProjectID      string `json:"project_id,omitempty"`
	DrawingName    string `json:"drawing_name,omitempty"`
	RevisionID     string `json:"revision_id"`
	ExportedAt     string `json:"exported_at"`
	Producer       string `json:"producer"`
	SchemaID       string `json:"schema_id,omitempty"`
	SchemaVersion  string `json:"schema_version,omitempty"`
	CorrelationID  string `json:"correlation_id,omitempty"`
	CurrentHeadRef string `json:"current_head_revision_id,omitempty"`
}

func New(revisions drawingv1connect.DrawingRevisionServiceClient, cadClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, requestTimeout time.Duration) *Service {
	return &Service{revisions: revisions, cad: cadClient, logger: logger.With().Str("component", "service").Logger(), requestTimeout: requestTimeout}
}

func (s *Service) ExportDrawing(ctx context.Context, req *drawingv1.ExportDrawingRequest) (*drawingv1.ExportDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	if err := requirePinnedRevision(req.GetRevisionId(), "revision_id"); err != nil {
		return nil, err
	}
	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetRevisionId())
	if err != nil {
		return nil, err
	}
	format := req.GetFormat()
	if format == drawingv1.FileFormat_FILE_FORMAT_UNSPECIFIED {
		format = drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON
	}
	payload, contentType, fileName, warnings, err := exportPayload(format, state.GetDrawing(), state.GetRevision())
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	return &drawingv1.ExportDrawingResponse{
		Drawing:     state.GetDrawing(),
		Revision:    state.GetRevision(),
		Format:      format,
		FileName:    fileName,
		ContentType: contentType,
		Payload:     payload,
		Report:      &drawingv1.FidelityReport{SourceEntityCount: uint32(len(state.GetRevision().GetEntities())), OutputEntityCount: uint32(len(state.GetRevision().GetEntities())), MatchedEntityCount: uint32(len(state.GetRevision().GetEntities())), Warnings: warnings},
	}, nil
}

func (s *Service) ImportDrawing(ctx context.Context, req *drawingv1.ImportDrawingRequest) (*drawingv1.ImportDrawingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if len(req.GetPayload()) == 0 {
		return nil, fmt.Errorf("%w: payload is required", ErrInvalidInput)
	}
	currentState, err := s.loadState(ctx, req.GetDrawingId(), req.GetBaseRevisionId())
	if err != nil {
		return nil, err
	}
	imported, warnings, err := importPayload(req.GetFormat(), req.GetPayload(), req.GetDrawingId())
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	mutations := buildImportMutations(currentState.GetRevision().GetEntities(), imported, req.GetMergeStrategy())
	if len(mutations) == 0 {
		return &drawingv1.ImportDrawingResponse{Drawing: currentState.GetDrawing(), Revision: currentState.GetRevision(), Report: &drawingv1.FidelityReport{SourceEntityCount: uint32(len(imported)), OutputEntityCount: uint32(len(imported)), MatchedEntityCount: uint32(matchCount(currentState.GetRevision().GetEntities(), imported)), Warnings: append(warnings, "no state changes were required")}}, nil
	}
	commitResponse, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), importSummary(req.GetSummary(), req.GetFormat()), req.GetContract(), mutations)
	if err != nil {
		return nil, err
	}
	return &drawingv1.ImportDrawingResponse{Drawing: commitResponse.GetDrawing(), Revision: commitResponse.GetRevision(), Report: &drawingv1.FidelityReport{SourceEntityCount: uint32(len(imported)), OutputEntityCount: uint32(len(imported)), MatchedEntityCount: uint32(matchCount(currentState.GetRevision().GetEntities(), imported)), Warnings: warnings}}, nil
}

func (s *Service) ValidateDrawingRoundTrip(ctx context.Context, req *drawingv1.ValidateDrawingRoundTripRequest) (*drawingv1.ValidateDrawingRoundTripResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	if err := requirePinnedRevision(req.GetRevisionId(), "revision_id"); err != nil {
		return nil, err
	}
	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetRevisionId())
	if err != nil {
		return nil, err
	}
	format := req.GetFormat()
	if format == drawingv1.FileFormat_FILE_FORMAT_UNSPECIFIED {
		format = drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON
	}
	payload, _, _, warnings, err := exportPayload(format, state.GetDrawing(), state.GetRevision())
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	imported, importWarnings, err := importPayload(format, payload, state.GetDrawing().GetDrawingId())
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	warnings = append(warnings, importWarnings...)
	matched := matchCount(state.GetRevision().GetEntities(), imported)
	if matched != len(state.GetRevision().GetEntities()) || matched != len(imported) {
		warnings = append(warnings, fmt.Sprintf("round-trip mismatch: matched %d of %d source entities", matched, len(state.GetRevision().GetEntities())))
	}
	return &drawingv1.ValidateDrawingRoundTripResponse{Report: &drawingv1.FidelityReport{SourceEntityCount: uint32(len(state.GetRevision().GetEntities())), OutputEntityCount: uint32(len(imported)), MatchedEntityCount: uint32(matched), Warnings: warnings}}, nil
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
	response, err := s.cad.CommitDrawingCommand(callCtx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{BaseRevisionId: baseRevisionID, Summary: summary, Command: &drawingv1.DrawingCommand{CommandId: uuid.NewString(), DrawingId: drawingID, Actor: author, Mutations: mutations, Contract: sharedcad.DefaultContract(contract, "interop-service")}}))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func exportPayload(format drawingv1.FileFormat, drawing *drawingv1.Drawing, revision *drawingv1.DrawingRevision) ([]byte, string, string, []string, error) {
	lineageJSON, err := buildExportLineageJSON(drawing, revision)
	if err != nil {
		return nil, "", "", nil, err
	}
	switch format {
	case drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON:
		drawingJSON, err := protojson.MarshalOptions{EmitUnpopulated: true}.Marshal(drawing)
		if err != nil {
			return nil, "", "", nil, err
		}
		revisionJSON, err := protojson.MarshalOptions{EmitUnpopulated: true}.Marshal(revision)
		if err != nil {
			return nil, "", "", nil, err
		}
		entitiesJSON, err := protojson.MarshalOptions{EmitUnpopulated: true}.Marshal(&drawingv1.DrawingRevision{Entities: revision.GetEntities()})
		if err != nil {
			return nil, "", "", nil, err
		}
		payload, err := json.MarshalIndent(jsonEnvelope{Drawing: drawingJSON, Revision: revisionJSON, Entities: entitiesJSON, Lineage: lineageJSON}, "", "  ")
		if err != nil {
			return nil, "", "", nil, err
		}
		warnings := []string{"export contains immutable lineage metadata for downstream traceability"}
		return payload, "application/json", exportFileName(drawing.GetName(), revision.GetPointer().GetRevisionId(), "json"), warnings, nil
	case drawingv1.FileFormat_FILE_FORMAT_DXF_ASCII:
		payload, warnings, err := exportDXF(revision.GetEntities(), mustBuildExportLineage(drawing, revision))
		if err != nil {
			return nil, "", "", nil, err
		}
		warnings = append(warnings, "DXF export includes SOLAR3D_LINEAGE comments for downstream traceability")
		return payload, "application/dxf", exportFileName(drawing.GetName(), revision.GetPointer().GetRevisionId(), "dxf"), warnings, nil
	default:
		return nil, "", "", nil, fmt.Errorf("unsupported file format %s", format.String())
	}
}

func buildExportLineageJSON(drawing *drawingv1.Drawing, revision *drawingv1.DrawingRevision) (json.RawMessage, error) {
	lineage := mustBuildExportLineage(drawing, revision)
	payload, err := json.Marshal(lineage)
	if err != nil {
		return nil, fmt.Errorf("marshal export lineage: %w", err)
	}
	return payload, nil
}

func mustBuildExportLineage(drawing *drawingv1.Drawing, revision *drawingv1.DrawingRevision) exportLineage {
	lineage := exportLineage{
		DrawingID:   drawing.GetDrawingId(),
		ProjectID:   drawing.GetProjectId(),
		DrawingName: drawing.GetName(),
		RevisionID:  revision.GetPointer().GetRevisionId(),
		ExportedAt:  time.Now().UTC().Format(time.RFC3339),
		Producer:    "interop-service",
	}
	if contract := drawing.GetContract(); contract != nil {
		lineage.SchemaID = contract.GetSchemaId()
		lineage.CorrelationID = contract.GetCorrelationId()
		if version := contract.GetSchemaVersion(); version != nil {
			lineage.SchemaVersion = fmt.Sprintf("%d.%d.%d", version.GetMajor(), version.GetMinor(), version.GetPatch())
		}
	}
	if headRevisionID := drawing.GetCurrentRevisionId(); headRevisionID != "" {
		lineage.CurrentHeadRef = headRevisionID
	}
	return lineage
}

func importPayload(format drawingv1.FileFormat, payload []byte, drawingID string) ([]*drawingv1.DrawingEntity, []string, error) {
	switch format {
	case drawingv1.FileFormat_FILE_FORMAT_SOLAR3D_JSON:
		return importJSON(payload, drawingID)
	case drawingv1.FileFormat_FILE_FORMAT_DXF_ASCII:
		return importDXF(payload, drawingID)
	default:
		return nil, nil, fmt.Errorf("unsupported file format %s", format.String())
	}
}

func importJSON(payload []byte, drawingID string) ([]*drawingv1.DrawingEntity, []string, error) {
	var envelope jsonEnvelope
	if err := json.Unmarshal(payload, &envelope); err != nil {
		return nil, nil, err
	}
	revision := &drawingv1.DrawingRevision{}
	if len(envelope.Revision) > 0 {
		if err := protojson.Unmarshal(envelope.Revision, revision); err != nil {
			return nil, nil, err
		}
	}
	entities := sharedcad.CloneEntities(revision.GetEntities())
	for _, entity := range entities {
		if entity.GetHeader() != nil {
			entity.Header.DrawingId = drawingID
		}
	}
	return entities, nil, nil
}

func buildImportMutations(current []*drawingv1.DrawingEntity, imported []*drawingv1.DrawingEntity, strategy drawingv1.InteropMergeStrategy) []*drawingv1.DrawingMutation {
	currentByID := sharedcad.EntityIndex(current)
	importedByID := sharedcad.EntityIndex(imported)
	mutations := make([]*drawingv1.DrawingMutation, 0)
	switch strategy {
	case drawingv1.InteropMergeStrategy_INTEROP_MERGE_STRATEGY_APPEND:
		for _, entity := range imported {
			next := sharedcad.CloneEntity(entity)
			if _, exists := currentByID[next.GetHeader().GetEntityId()]; exists {
				next.Header.EntityId = uuid.NewString()
			}
			mutations = append(mutations, sharedcad.CreateMutation(next))
		}
	case drawingv1.InteropMergeStrategy_INTEROP_MERGE_STRATEGY_UPSERT:
		for _, entity := range imported {
			if existing, exists := currentByID[entity.GetHeader().GetEntityId()]; exists {
				if !proto.Equal(existing, entity) {
					mutations = append(mutations, sharedcad.UpdateMutation(existing, entity))
				}
				continue
			}
			mutations = append(mutations, sharedcad.CreateMutation(entity))
		}
	default:
		for _, entity := range current {
			if _, keep := importedByID[entity.GetHeader().GetEntityId()]; !keep {
				mutations = append(mutations, sharedcad.DeleteMutation(entity))
			}
		}
		for _, entity := range imported {
			if existing, exists := currentByID[entity.GetHeader().GetEntityId()]; exists {
				if !proto.Equal(existing, entity) {
					mutations = append(mutations, sharedcad.UpdateMutation(existing, entity))
				}
				continue
			}
			mutations = append(mutations, sharedcad.CreateMutation(entity))
		}
	}
	return mutations
}

func matchCount(source []*drawingv1.DrawingEntity, output []*drawingv1.DrawingEntity) int {
	signatures := make(map[string]int, len(source))
	for _, entity := range source {
		signatures[sharedcad.Signature(entity)]++
	}
	matched := 0
	for _, entity := range output {
		sig := sharedcad.Signature(entity)
		if signatures[sig] > 0 {
			matched++
			signatures[sig]--
		}
	}
	return matched
}

func exportFileName(drawingName string, revisionID string, extension string) string {
	base := strings.ToLower(strings.TrimSpace(drawingName))
	base = strings.ReplaceAll(base, " ", "-")
	if base == "" {
		base = "drawing"
	}
	return fmt.Sprintf("%s-%s.%s", base, revisionID[:8], extension)
}

func requirePinnedRevision(revisionID string, field string) error {
	if strings.TrimSpace(revisionID) == "" {
		return fmt.Errorf("%w: %s is required for immutable export and validation", ErrInvalidInput, field)
	}
	return nil
}

func importSummary(summary string, format drawingv1.FileFormat) string {
	trimmed := strings.TrimSpace(summary)
	if trimmed != "" {
		return trimmed
	}
	return fmt.Sprintf("Import drawing from %s", strings.TrimPrefix(format.String(), "FILE_FORMAT_"))
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

func exportDXF(entities []*drawingv1.DrawingEntity, lineage exportLineage) ([]byte, []string, error) {
	buffer := bytes.NewBufferString("999\nSOLAR3D_LINEAGE drawing_id=" + lineage.DrawingID + " revision_id=" + lineage.RevisionID + " exported_at=" + lineage.ExportedAt + " producer=" + lineage.Producer + "\n0\nSECTION\n2\nENTITIES\n")
	warnings := make([]string, 0)
	for _, entity := range entities {
		if entity == nil || entity.GetHeader() == nil {
			continue
		}
		writeDXFPrimitive(buffer, entity)
		jsonPayload, err := protojson.MarshalOptions{EmitUnpopulated: true}.Marshal(entity)
		if err != nil {
			return nil, nil, err
		}
		buffer.WriteString("999\nSOLAR3D_ENTITY ")
		buffer.Write(jsonPayload)
		buffer.WriteString("\n")
	}
	buffer.WriteString("0\nENDSEC\n0\nEOF\n")
	return buffer.Bytes(), warnings, nil
}

func writeDXFPrimitive(buffer *bytes.Buffer, entity *drawingv1.DrawingEntity) {
	layerName := entity.GetHeader().GetLayer().GetLayerName()
	if layerName == "" {
		layerName = entity.GetHeader().GetLayer().GetLayerId()
	}
	switch geometry := entity.Geometry.(type) {
	case *drawingv1.DrawingEntity_Polyline:
		buffer.WriteString("0\nLWPOLYLINE\n8\n" + layerName + "\n90\n")
		buffer.WriteString(fmt.Sprintf("%d\n70\n%d\n", len(geometry.Polyline.GetVertices()), boolFlag(geometry.Polyline.GetClosed())))
		for _, vertex := range geometry.Polyline.GetVertices() {
			buffer.WriteString(fmt.Sprintf("10\n%f\n20\n%f\n", vertex.GetX(), vertex.GetY()))
		}
	case *drawingv1.DrawingEntity_Text:
		buffer.WriteString(fmt.Sprintf("0\nTEXT\n8\n%s\n10\n%f\n20\n%f\n40\n%f\n50\n%f\n1\n%s\n", layerName, geometry.Text.GetAnchor().GetX(), geometry.Text.GetAnchor().GetY(), geometry.Text.GetHeight(), geometry.Text.GetRotationDeg(), strings.ReplaceAll(geometry.Text.GetText(), "\n", " ")))
	case *drawingv1.DrawingEntity_BlockReference:
		buffer.WriteString(fmt.Sprintf("0\nINSERT\n8\n%s\n2\n%s\n10\n%f\n20\n%f\n41\n%f\n42\n%f\n50\n%f\n", layerName, geometry.BlockReference.GetBlockDefinitionId(), geometry.BlockReference.GetInsertionPoint().GetX(), geometry.BlockReference.GetInsertionPoint().GetY(), geometry.BlockReference.GetScaleX(), geometry.BlockReference.GetScaleY(), geometry.BlockReference.GetRotationDeg()))
	case *drawingv1.DrawingEntity_Leader:
		buffer.WriteString(fmt.Sprintf("0\nLWPOLYLINE\n8\n%s\n90\n%d\n70\n0\n", layerName, len(geometry.Leader.GetVertices())))
		for _, vertex := range geometry.Leader.GetVertices() {
			buffer.WriteString(fmt.Sprintf("10\n%f\n20\n%f\n", vertex.GetX(), vertex.GetY()))
		}
	}
}

func importDXF(payload []byte, drawingID string) ([]*drawingv1.DrawingEntity, []string, error) {
	lines := strings.Split(string(payload), "\n")
	entities := make([]*drawingv1.DrawingEntity, 0)
	warnings := make([]string, 0)
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if !strings.HasPrefix(trimmed, "SOLAR3D_ENTITY ") {
			continue
		}
		entity := &drawingv1.DrawingEntity{}
		if err := protojson.Unmarshal([]byte(strings.TrimPrefix(trimmed, "SOLAR3D_ENTITY ")), entity); err != nil {
			warnings = append(warnings, "failed to parse one DXF entity payload")
			continue
		}
		if entity.GetHeader() != nil {
			entity.Header.DrawingId = drawingID
		}
		entities = append(entities, entity)
	}
	if len(entities) == 0 {
		return nil, warnings, fmt.Errorf("no SOLAR3D entity payloads found in DXF")
	}
	sort.Slice(entities, func(i, j int) bool {
		return entities[i].GetHeader().GetEntityId() < entities[j].GetHeader().GetEntityId()
	})
	return entities, warnings, nil
}

func boolFlag(value bool) int {
	if value {
		return 1
	}
	return 0
}

