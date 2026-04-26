// Package audit — audit event logging for governance and compliance
package audit

import (
	"context"
	"encoding/json"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

// EventType defines the type of audit event
type EventType string

const (
	EventCreated    EventType = "CREATED"
	EventUpdated    EventType = "UPDATED"
	EventDeleted    EventType = "DELETED"
	EventDeployed   EventType = "DEPLOYED"
	EventRolledback EventType = "ROLLED_BACK"
	EventAccessed   EventType = "ACCESSED"
	EventVersioned  EventType = "VERSIONED"
)

// AuditEvent represents a single audit log entry
type AuditEvent struct {
	ID           string                 `json:"id"`
	Timestamp    time.Time              `json:"timestamp"`
	EventType    EventType              `json:"event_type"`
	ResourceType string                 `json:"resource_type"` // e.g., "project", "asset", "report"
	ResourceID   string                 `json:"resource_id"`
	ActorID      string                 `json:"actor_id"` // User/service that triggered the event
	Changes      map[string]interface{} `json:"changes"`  // What changed (before/after)
	Metadata     map[string]interface{} `json:"metadata"` // Contextual info (project ID, etc.)
	TraceID      string                 `json:"trace_id"`
}

// Logger handles audit event persistence and retrieval
type Logger interface {
	LogEvent(ctx context.Context, event *AuditEvent) error
	GetEventsByResource(ctx context.Context, resourceType, resourceID string) ([]*AuditEvent, error)
	GetEventsByActor(ctx context.Context, actorID string, limit int) ([]*AuditEvent, error)
	GetEventsSince(ctx context.Context, since time.Time) ([]*AuditEvent, error)
}

// NewAuditEvent creates a new audit event
func NewAuditEvent(eventType EventType, resourceType, resourceID, actorID string) *AuditEvent {
	return &AuditEvent{
		ID:           uuid.New().String(),
		Timestamp:    time.Now().UTC(),
		EventType:    eventType,
		ResourceType: resourceType,
		ResourceID:   resourceID,
		ActorID:      actorID,
		Changes:      make(map[string]interface{}),
		Metadata:     make(map[string]interface{}),
	}
}

// RecordChange adds a before/after change to the audit event
func (ae *AuditEvent) RecordChange(field string, before, after interface{}) {
	ae.Changes[field] = map[string]interface{}{
		"before": before,
		"after":  after,
	}
}

// RecordMetadata adds contextual metadata
func (ae *AuditEvent) RecordMetadata(key string, value interface{}) {
	ae.Metadata[key] = value
}

// LogToContext logs an audit event and extracts trace ID from context
func LogToContext(ctx context.Context, event *AuditEvent) {
	// Extract trace ID if available
	if traceID, ok := ctx.Value("trace_id").(string); ok {
		event.TraceID = traceID
	}

	// Serialize to JSON
	data, err := json.Marshal(event)
	if err != nil {
		log.Error().Err(err).Msg("failed to marshal audit event")
		return
	}

	// Log as structured event
	log.Info().
		Str("event_type", string(event.EventType)).
		Str("resource_type", event.ResourceType).
		Str("resource_id", event.ResourceID).
		Str("actor_id", event.ActorID).
		RawJSON("event_data", data).
		Msg("audit event")
}

// ExampleProjectAudit shows how to use audit logging in a project service
func ExampleProjectAudit(ctx context.Context, projectID string, actorID string) {
	// Create project: generate CREATED event
	event := NewAuditEvent(EventCreated, "project", projectID, actorID)
	event.RecordChange("status", nil, "draft")
	event.RecordMetadata("project_name", "Solar Farm A")
	event.RecordMetadata("location", "California, USA")
	LogToContext(ctx, event)

	// Update project: generate UPDATED event
	updateEvent := NewAuditEvent(EventUpdated, "project", projectID, actorID)
	updateEvent.RecordChange("status", "draft", "in_progress")
	updateEvent.RecordChange("target_capacity_mw", 50.0, 75.0)
	LogToContext(ctx, updateEvent)
}

// ExampleAssetVersioning shows how to use audit logging for asset versioning
func ExampleAssetVersioning(ctx context.Context, assetID string, version int32, actorID string) {
	event := NewAuditEvent(EventVersioned, "asset", assetID, actorID)
	event.RecordMetadata("version", version)
	event.RecordMetadata("asset_type", "panel_spec")
	LogToContext(ctx, event)
}

// ExampleReportGeneration shows how to use audit logging for report generation
func ExampleReportGeneration(ctx context.Context, reportID string, actorID string, format string) {
	event := NewAuditEvent(EventCreated, "report", reportID, actorID)
	event.RecordMetadata("format", format)
	event.RecordMetadata("template", "solar_yield_analysis")
	LogToContext(ctx, event)
}

