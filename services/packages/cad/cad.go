package cad

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"sort"
	"strings"
	"time"

	"github.com/google/uuid"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Bounds struct {
	MinX float64
	MinY float64
	MaxX float64
	MaxY float64
}

const (
	ConflictCodeStaleRevision   = "stale_revision"
	HeaderErrorCode             = "x-solar3d-error-code"
	HeaderOutcomeCode           = "x-solar3d-outcome-code"
	HeaderAttemptID             = "x-solar3d-attempt-id"
	HeaderHeadVersion           = "x-solar3d-head-version"
	HeaderBaseRevisionID        = "x-solar3d-base-revision-id"
	HeaderHeadRevisionID        = "x-solar3d-head-revision-id"
	HeaderRequestedHeadVersion  = "x-solar3d-requested-head-version"
	HeaderRetryAfter            = "retry-after"
	DefaultConflictRetryAfterMs = 300
	OutcomeCommitted            = "committed"
	OutcomeStaleBase            = "stale_base"
	OutcomeLockTimeout          = "lock_timeout"
	OutcomeIdempotentDuplicate  = "idempotent_duplicate"
)

func ParseUUID(value string, field string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(strings.TrimSpace(value))
	if err != nil {
		return uuid.Nil, fmt.Errorf("%s must be a UUID", field)
	}
	return parsed, nil
}

func ValidateJSON(value string, field string) error {
	if strings.TrimSpace(value) == "" {
		return nil
	}
	var payload any
	if err := json.Unmarshal([]byte(value), &payload); err != nil {
		return fmt.Errorf("%s must be valid JSON", field)
	}
	return nil
}

func NormalizeJSON(value string) string {
	if strings.TrimSpace(value) == "" {
		return "{}"
	}
	return value
}

func MergeMetadata(base string, patches ...map[string]any) (string, error) {
	var merged map[string]any
	if strings.TrimSpace(base) == "" {
		merged = make(map[string]any)
	} else {
		if err := json.Unmarshal([]byte(base), &merged); err != nil {
			return "", err
		}
	}
	for _, patch := range patches {
		mergeMap(merged, patch)
	}
	encoded, err := json.Marshal(merged)
	if err != nil {
		return "", err
	}
	return string(encoded), nil
}

func DefaultContract(existing *commonv1.ContractMetadata, producer string) *commonv1.ContractMetadata {
	if existing != nil {
		return existing
	}
	now := time.Now().UTC()
	return &commonv1.ContractMetadata{
		SchemaVersion: &commonv1.ApiVersion{Major: 1, Minor: 0, Patch: 0},
		SchemaId:      "drawing.v1",
		Producer:      producer,
		CreatedAt:     timestamppb.New(now),
	}
}

func CloneEntity(entity *drawingv1.DrawingEntity) *drawingv1.DrawingEntity {
	if entity == nil {
		return nil
	}
	return proto.Clone(entity).(*drawingv1.DrawingEntity)
}

func CloneEntities(entities []*drawingv1.DrawingEntity) []*drawingv1.DrawingEntity {
	cloned := make([]*drawingv1.DrawingEntity, 0, len(entities))
	for _, entity := range entities {
		cloned = append(cloned, CloneEntity(entity))
	}
	return cloned
}

func NewHeader(drawingID string, entityID string, entityType drawingv1.DrawingEntityType, layerID string, layerName string, styleID string, styleName string, metadataJSON string, contract *commonv1.ContractMetadata) *drawingv1.EntityHeader {
	now := timestamppb.New(time.Now().UTC())
	return &drawingv1.EntityHeader{
		EntityId:   entityID,
		DrawingId:  drawingID,
		EntityType: entityType,
		Layer: &drawingv1.LayerRef{
			LayerId:   strings.TrimSpace(layerID),
			LayerName: strings.TrimSpace(layerName),
		},
		Style: &drawingv1.StyleRef{
			StyleId:   strings.TrimSpace(styleID),
			StyleName: strings.TrimSpace(styleName),
		},
		MetadataJson: NormalizeJSON(metadataJSON),
		CreatedAt:    now,
		UpdatedAt:    now,
		Contract:     contract,
	}
}

func EntityIndex(entities []*drawingv1.DrawingEntity) map[string]*drawingv1.DrawingEntity {
	indexed := make(map[string]*drawingv1.DrawingEntity, len(entities))
	for _, entity := range entities {
		if entity == nil || entity.GetHeader() == nil {
			continue
		}
		indexed[entity.GetHeader().GetEntityId()] = entity
	}
	return indexed
}

func CreateMutation(entity *drawingv1.DrawingEntity) *drawingv1.DrawingMutation {
	return &drawingv1.DrawingMutation{
		EntityId: safeEntityID(entity),
		Action:   drawingv1.RevisionAction_REVISION_ACTION_CREATE,
		After:    CloneEntity(entity),
	}
}

func UpdateMutation(before *drawingv1.DrawingEntity, after *drawingv1.DrawingEntity) *drawingv1.DrawingMutation {
	entityID := safeEntityID(after)
	if entityID == "" {
		entityID = safeEntityID(before)
	}
	return &drawingv1.DrawingMutation{
		EntityId: entityID,
		Action:   drawingv1.RevisionAction_REVISION_ACTION_UPDATE,
		Before:   CloneEntity(before),
		After:    CloneEntity(after),
	}
}

func DeleteMutation(entity *drawingv1.DrawingEntity) *drawingv1.DrawingMutation {
	return &drawingv1.DrawingMutation{
		EntityId: safeEntityID(entity),
		Action:   drawingv1.RevisionAction_REVISION_ACTION_DELETE,
		Before:   CloneEntity(entity),
	}
}

func BoundsOf(entity *drawingv1.DrawingEntity) (Bounds, bool) {
	if entity == nil {
		return Bounds{}, false
	}
	switch geometry := entity.Geometry.(type) {
	case *drawingv1.DrawingEntity_Polyline:
		return boundsOfPoints(geometry.Polyline.GetVertices())
	case *drawingv1.DrawingEntity_Polygon:
		points := make([]*commonv1.Point2D, 0)
		for _, ring := range geometry.Polygon.GetGeometry().GetRings() {
			points = append(points, ring.GetPoints()...)
		}
		return boundsOfPoints(points)
	case *drawingv1.DrawingEntity_Text:
		anchor := geometry.Text.GetAnchor()
		return Bounds{MinX: anchor.GetX(), MinY: anchor.GetY(), MaxX: anchor.GetX(), MaxY: anchor.GetY()}, true
	case *drawingv1.DrawingEntity_Dimension:
		points := []*commonv1.Point2D{geometry.Dimension.GetStart(), geometry.Dimension.GetEnd(), geometry.Dimension.GetTextAnchor()}
		return boundsOfPoints(points)
	case *drawingv1.DrawingEntity_BlockReference:
		point := geometry.BlockReference.GetInsertionPoint()
		return Bounds{MinX: point.GetX(), MinY: point.GetY(), MaxX: point.GetX(), MaxY: point.GetY()}, true
	case *drawingv1.DrawingEntity_Leader:
		return boundsOfPoints(geometry.Leader.GetVertices())
	case *drawingv1.DrawingEntity_BlockDefinition:
		combined := Bounds{}
		hasBounds := false
		for _, child := range geometry.BlockDefinition.GetEntities() {
			childBounds, ok := BoundsOf(child)
			if !ok {
				continue
			}
			if !hasBounds {
				combined = childBounds
				hasBounds = true
				continue
			}
			combined = UnionBounds(combined, childBounds)
		}
		return combined, hasBounds
	case *drawingv1.DrawingEntity_Sheet:
		return Bounds{MinX: 0, MinY: 0, MaxX: geometry.Sheet.GetPageWidthMm(), MaxY: geometry.Sheet.GetPageHeightMm()}, true
	default:
		return Bounds{}, false
	}
}

func EntityReferencePoints(entity *drawingv1.DrawingEntity) ([]*commonv1.Point2D, bool) {
	if entity == nil {
		return nil, false
	}
	switch geometry := entity.Geometry.(type) {
	case *drawingv1.DrawingEntity_Polyline:
		if len(geometry.Polyline.GetVertices()) < 2 {
			return nil, false
		}
		vertices := geometry.Polyline.GetVertices()
		return []*commonv1.Point2D{clonePoint(vertices[0]), clonePoint(vertices[len(vertices)-1])}, true
	case *drawingv1.DrawingEntity_Polygon:
		bounds, ok := BoundsOf(entity)
		if !ok {
			return nil, false
		}
		center := &commonv1.Point2D{X: (bounds.MinX + bounds.MaxX) / 2, Y: (bounds.MinY + bounds.MaxY) / 2}
		return []*commonv1.Point2D{center, center}, true
	case *drawingv1.DrawingEntity_Text:
		anchor := clonePoint(geometry.Text.GetAnchor())
		return []*commonv1.Point2D{anchor, anchor}, true
	case *drawingv1.DrawingEntity_Dimension:
		return []*commonv1.Point2D{clonePoint(geometry.Dimension.GetStart()), clonePoint(geometry.Dimension.GetEnd())}, true
	case *drawingv1.DrawingEntity_BlockReference:
		point := clonePoint(geometry.BlockReference.GetInsertionPoint())
		return []*commonv1.Point2D{point, point}, true
	case *drawingv1.DrawingEntity_Leader:
		vertices := geometry.Leader.GetVertices()
		if len(vertices) == 0 {
			return nil, false
		}
		return []*commonv1.Point2D{clonePoint(vertices[0]), clonePoint(vertices[len(vertices)-1])}, true
	default:
		return nil, false
	}
}

func UnionBounds(left Bounds, right Bounds) Bounds {
	return Bounds{
		MinX: math.Min(left.MinX, right.MinX),
		MinY: math.Min(left.MinY, right.MinY),
		MaxX: math.Max(left.MaxX, right.MaxX),
		MaxY: math.Max(left.MaxY, right.MaxY),
	}
}

func LayerDefinitions(entities []*drawingv1.DrawingEntity) map[string]*drawingv1.LayerDefinitionEntity {
	layers := make(map[string]*drawingv1.LayerDefinitionEntity)
	for _, entity := range entities {
		if entity == nil {
			continue
		}
		layer, ok := entity.GetGeometry().(*drawingv1.DrawingEntity_LayerDefinition)
		if !ok || layer.LayerDefinition == nil {
			continue
		}
		layers[layer.LayerDefinition.GetLayerId()] = proto.Clone(layer.LayerDefinition).(*drawingv1.LayerDefinitionEntity)
	}
	return layers
}

func BlockDefinitions(entities []*drawingv1.DrawingEntity) map[string]*drawingv1.BlockDefinitionEntity {
	definitions := make(map[string]*drawingv1.BlockDefinitionEntity)
	for _, entity := range entities {
		if entity == nil {
			continue
		}
		block, ok := entity.GetGeometry().(*drawingv1.DrawingEntity_BlockDefinition)
		if !ok || block.BlockDefinition == nil {
			continue
		}
		definitions[block.BlockDefinition.GetBlockDefinitionId()] = proto.Clone(block.BlockDefinition).(*drawingv1.BlockDefinitionEntity)
	}
	return definitions
}

func SheetEntities(entities []*drawingv1.DrawingEntity) []*drawingv1.DrawingEntity {
	result := make([]*drawingv1.DrawingEntity, 0)
	for _, entity := range entities {
		if entity == nil || entity.GetHeader() == nil {
			continue
		}
		if _, ok := entity.GetGeometry().(*drawingv1.DrawingEntity_Sheet); ok {
			result = append(result, entity)
		}
	}
	sort.Slice(result, func(i, j int) bool {
		return safeEntityID(result[i]) < safeEntityID(result[j])
	})
	return result
}

func Signature(entity *drawingv1.DrawingEntity) string {
	if entity == nil {
		return ""
	}
	payload, err := protojson.MarshalOptions{EmitUnpopulated: true}.Marshal(entity)
	if err != nil {
		return safeEntityID(entity)
	}
	hash := sha256.Sum256(payload)
	return hex.EncodeToString(hash[:])
}

func safeEntityID(entity *drawingv1.DrawingEntity) string {
	if entity == nil || entity.GetHeader() == nil {
		return ""
	}
	return entity.GetHeader().GetEntityId()
}

func NormalizeColorHex(color string) string {
	trimmed := strings.ToUpper(strings.TrimSpace(color))
	if trimmed == "" {
		return "#000000"
	}
	if !strings.HasPrefix(trimmed, "#") {
		trimmed = "#" + trimmed
	}
	if len(trimmed) == 4 {
		return fmt.Sprintf("#%c%c%c%c%c%c", trimmed[1], trimmed[1], trimmed[2], trimmed[2], trimmed[3], trimmed[3])
	}
	if len(trimmed) != 7 {
		return "#000000"
	}
	return trimmed
}

func RequireLayerWritable(layers map[string]*drawingv1.LayerDefinitionEntity, layerID string) error {
	if strings.TrimSpace(layerID) == "" {
		return nil
	}
	layer, ok := layers[layerID]
	if !ok {
		return nil
	}
	if layer.GetLocked() {
		return errors.New("target layer is locked")
	}
	if !layer.GetVisible() {
		return errors.New("target layer is hidden")
	}
	return nil
}

func boundsOfPoints(points []*commonv1.Point2D) (Bounds, bool) {
	filtered := make([]*commonv1.Point2D, 0, len(points))
	for _, point := range points {
		if point != nil {
			filtered = append(filtered, point)
		}
	}
	if len(filtered) == 0 {
		return Bounds{}, false
	}
	result := Bounds{MinX: filtered[0].GetX(), MinY: filtered[0].GetY(), MaxX: filtered[0].GetX(), MaxY: filtered[0].GetY()}
	for _, point := range filtered[1:] {
		result.MinX = math.Min(result.MinX, point.GetX())
		result.MinY = math.Min(result.MinY, point.GetY())
		result.MaxX = math.Max(result.MaxX, point.GetX())
		result.MaxY = math.Max(result.MaxY, point.GetY())
	}
	return result, true
}

func clonePoint(point *commonv1.Point2D) *commonv1.Point2D {
	if point == nil {
		return &commonv1.Point2D{}
	}
	return &commonv1.Point2D{X: point.GetX(), Y: point.GetY()}
}

func mergeMap(target map[string]any, patch map[string]any) {
	for key, value := range patch {
		switch typed := value.(type) {
		case map[string]any:
			existing, ok := target[key].(map[string]any)
			if !ok {
				existing = make(map[string]any)
			}
			mergeMap(existing, typed)
			target[key] = existing
		default:
			target[key] = typed
		}
	}
}

