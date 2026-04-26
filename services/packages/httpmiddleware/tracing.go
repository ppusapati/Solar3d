// Package middleware — trace ID propagation and distributed tracing support
package middleware

import (
	"context"
	"net/http"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

// contextKey is used for storing trace context values.
type contextKey string

const (
	TraceIDKey contextKey = "trace_id"
	RequestID  contextKey = "request_id"
)

// TraceIDMiddleware extracts or generates trace ID from request headers.
// Propagates trace ID to response headers and context.
func TraceIDMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		traceID := r.Header.Get("X-Trace-ID")
		if traceID == "" {
			traceID = uuid.New().String()
		}

		requestID := r.Header.Get("X-Request-ID")
		if requestID == "" {
			requestID = uuid.New().String()
		}

		// Store in context
		ctx := context.WithValue(r.Context(), TraceIDKey, traceID)
		ctx = context.WithValue(ctx, RequestID, requestID)

		// Add response headers for trace
		w.Header().Set("X-Trace-ID", traceID)
		w.Header().Set("X-Request-ID", requestID)

		// Log with trace context
		log.Ctx(ctx).Debug().
			Str("trace_id", traceID).
			Str("request_id", requestID).
			Str("method", r.Method).
			Str("path", r.URL.Path).
			Msg("incoming request")

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// GetTraceID retrieves the trace ID from context.
func GetTraceID(ctx context.Context) string {
	if id, ok := ctx.Value(TraceIDKey).(string); ok {
		return id
	}
	return ""
}

// GetRequestID retrieves the request ID from context.
func GetRequestID(ctx context.Context) string {
	if id, ok := ctx.Value(RequestID).(string); ok {
		return id
	}
	return ""
}

// WithTraceID adds trace ID to context (for operations that need to pass context explicitly).
func WithTraceID(ctx context.Context, traceID string) context.Context {
	return context.WithValue(ctx, TraceIDKey, traceID)
}

