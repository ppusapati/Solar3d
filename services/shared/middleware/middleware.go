// Package middleware provides common middleware for service adapters
package middleware

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
)

// ErrorResponse is a standard error response
type ErrorResponse struct {
	Error   string `json:"error"`
	Details string `json:"details,omitempty"`
	Code    int    `json:"code"`
}

// SuccessResponse is a standard success response wrapper
type SuccessResponse struct {
	Data      interface{} `json:"data"`
	Error     string      `json:"error,omitempty"`
	Code      int         `json:"code"`
	Timestamp int64       `json:"timestamp"`
}

// WriteError writes an error response
func WriteError(w http.ResponseWriter, code int, message string, details string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(ErrorResponse{
		Error:   message,
		Details: details,
		Code:    code,
	})
}

// WriteSuccess writes a success response
func WriteSuccess(w http.ResponseWriter, code int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(SuccessResponse{
		Data:      data,
		Code:      code,
		Timestamp: time.Now().Unix(),
	})
}

// TimeoutMiddleware adds request timeout
func TimeoutMiddleware(timeout time.Duration) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			ctx, cancel := context.WithTimeout(r.Context(), timeout)
			defer cancel()
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// ValidationMiddleware validates JSON requests
func ValidationMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" || r.Method == "PUT" {
			if ct := r.Header.Get("Content-Type"); !strings.Contains(ct, "application/json") {
				WriteError(w, http.StatusBadRequest, "Invalid Content-Type", "Expected application/json")
				return
			}
		}
		next.ServeHTTP(w, r)
	})
}

// RateLimitMiddleware implements basic rate limiting
func RateLimitMiddleware(maxRequests int, window time.Duration) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		requestTimes := make(map[string][]time.Time)

		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			ip := getClientIP(r)
			now := time.Now()

			// Cleanup old entries
			if times, exists := requestTimes[ip]; exists {
				filteredTimes := []time.Time{}
				for _, t := range times {
					if now.Sub(t) < window {
						filteredTimes = append(filteredTimes, t)
					}
				}
				requestTimes[ip] = filteredTimes
			} else {
				requestTimes[ip] = []time.Time{}
			}

			// Check limit
			if len(requestTimes[ip]) >= maxRequests {
				WriteError(w, http.StatusTooManyRequests, "Rate limit exceeded", fmt.Sprintf("Max %d requests per %v", maxRequests, window))
				return
			}

			requestTimes[ip] = append(requestTimes[ip], now)
			next.ServeHTTP(w, r)
		})
	}
}

func getClientIP(r *http.Request) string {
	if ip := r.Header.Get("X-Forwarded-For"); ip != "" {
		return strings.Split(ip, ",")[0]
	}
	if ip := r.Header.Get("X-Real-IP"); ip != "" {
		return ip
	}
	return r.RemoteAddr
}


