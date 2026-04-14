package middleware

import (
	"context"
	"net/http"

	"github.com/google/uuid"
)

// IDempotencyKeyMiddleware injects a unique request ID into the request context and response
// headers. If the incoming request already has an X-Request-ID header, that
// value is reused. This middleware is separate from TraceIDMiddleware and can
// be composed together with it for request tracking.
func IDempotencyKeyMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		id := r.Header.Get("X-Request-ID")
		if id == "" {
			id = uuid.New().String()
		}

		ctx := context.WithValue(r.Context(), RequestID, id)
		w.Header().Set("X-Request-ID", id)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// Deprecated: Use GetRequestID from tracing.go instead.
// Kept for backwards compatibility.
func GetIDFromContext(ctx context.Context) string {
	if id, ok := ctx.Value(RequestID).(string); ok {
		return id
	}
	return ""
}

