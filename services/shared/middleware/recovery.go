package middleware

import (
	"encoding/json"
	"fmt"
	"net/http"
	"runtime/debug"

	"github.com/rs/zerolog"
)

// Recovery catches panics and returns a 500 error instead of crashing.
func Recovery(logger zerolog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			defer func() {
				if err := recover(); err != nil {
					reqID := GetRequestID(r.Context())
					stack := string(debug.Stack())

					logger.Error().
						Str("request_id", reqID).
						Str("method", r.Method).
						Str("path", r.URL.Path).
						Str("panic", fmt.Sprint(err)).
						Str("stack", stack).
						Msg("panic recovered")

					w.Header().Set("Content-Type", "application/json")
					w.WriteHeader(http.StatusInternalServerError)
					json.NewEncoder(w).Encode(map[string]string{
						"code":    "internal",
						"message": "Internal server error",
					})
				}
			}()
			next.ServeHTTP(w, r)
		})
	}
}

