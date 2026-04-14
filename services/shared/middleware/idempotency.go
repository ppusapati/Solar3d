// Package middleware — idempotency key extraction and validation
package middleware

import (
	"context"
	"net/http"
)

// IdempotencyKey is the context key for storing idempotency key.
type IdempotencyKeyType contextKey

const IdempotencyKeyContext IdempotencyKeyType = "idempotency_key"

// IdempotencyMiddleware extracts the Idempotency-Key header from requests.
// The header is optional but, when present, enables deduplication.
func IdempotencyMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		idempotencyKey := r.Header.Get("Idempotency-Key")
		if idempotencyKey != "" {
			ctx := context.WithValue(r.Context(), IdempotencyKeyContext, idempotencyKey)
			r = r.WithContext(ctx)
		}
		next.ServeHTTP(w, r)
	})
}

// GetIdempotencyKey retrieves the idempotency key from context.
func GetIdempotencyKey(ctx context.Context) string {
	if key, ok := ctx.Value(IdempotencyKeyContext).(string); ok {
		return key
	}
	return ""
}

