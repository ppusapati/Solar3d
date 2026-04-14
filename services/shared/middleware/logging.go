package middleware

import (
	"net/http"
	"time"

	"github.com/rs/zerolog"
)

type statusRecorder struct {
	http.ResponseWriter
	status int
	size   int
}

func (r *statusRecorder) WriteHeader(code int) {
	r.status = code
	r.ResponseWriter.WriteHeader(code)
}

func (r *statusRecorder) Write(b []byte) (int, error) {
	n, err := r.ResponseWriter.Write(b)
	r.size += n
	return n, err
}

// Flush implements http.Flusher for streaming responses (e.g., ConnectRPC server streams)
func (r *statusRecorder) Flush() {
	if flusher, ok := r.ResponseWriter.(http.Flusher); ok {
		flusher.Flush()
	}
}

// Logging is structured HTTP request/response logging middleware.
func Logging(logger zerolog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()

			recorder := &statusRecorder{
				ResponseWriter: w,
				status:         http.StatusOK,
			}

			next.ServeHTTP(recorder, r)

			duration := time.Since(start)
			reqID := GetRequestID(r.Context())

			event := logger.Info()
			if recorder.status >= 500 {
				event = logger.Error()
			} else if recorder.status >= 400 {
				event = logger.Warn()
			}

			event.
				Str("method", r.Method).
				Str("path", r.URL.Path).
				Int("status", recorder.status).
				Int("size", recorder.size).
				Dur("duration", duration).
				Str("remote", r.RemoteAddr).
				Str("request_id", reqID).
				Msg("request")
		})
	}
}

