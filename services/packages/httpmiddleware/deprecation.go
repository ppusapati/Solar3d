package middleware

import (
	"net/http"
	"strings"

	"github.com/rs/zerolog"
)

// RESTAliasSunset is the HTTP-date at which /api/v1/* aliases will be removed.
// Update this constant to extend or shorten the deprecation window.
const RESTAliasSunset = "Thu, 15 Oct 2026 00:00:00 GMT"

// DeprecateRESTAliases marks /api/v1/* responses as deprecated in favor of the
// ConnectRPC-style routes. Emits RFC 8594 / draft-ietf-httpapi-deprecation-header
// compliant Deprecation, Sunset, and Link headers plus a structured warn log.
func DeprecateRESTAliases(logger zerolog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if strings.HasPrefix(r.URL.Path, "/api/v1/") {
				w.Header().Set("Deprecation", "true")
				w.Header().Set("Sunset", RESTAliasSunset)
				w.Header().Set("Link", `</docs/migration/connectrpc>; rel="deprecation"; type="text/html"`)

				logger.Warn().
					Str("path", r.URL.Path).
					Str("method", r.Method).
					Str("user_agent", r.UserAgent()).
					Msg("deprecated /api/v1/* route called — migrate to ConnectRPC path")
			}
			next.ServeHTTP(w, r)
		})
	}
}
