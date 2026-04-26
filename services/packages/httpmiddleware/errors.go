// Package middleware — standard error handling compatible with Connect RPC
package middleware

import (
	"encoding/json"
	"net/http"
)

// Error represents a structured service error.
type Error struct {
	Code    string `json:"code"`    // Error code (e.g., "INVALID_INPUT", "NOT_FOUND", "INTERNAL")
	Message string `json:"message"` // Human-readable error message
	Details string `json:"details"` // Optional detailed information
}

// HTTPStatus maps error code to HTTP status code.
func (e *Error) HTTPStatus() int {
	switch e.Code {
	case "INVALID_INPUT":
		return http.StatusBadRequest
	case "UNAUTHORIZED":
		return http.StatusUnauthorized
	case "FORBIDDEN":
		return http.StatusForbidden
	case "NOT_FOUND":
		return http.StatusNotFound
	case "CONFLICT":
		return http.StatusConflict
	case "RATE_LIMITED":
		return http.StatusTooManyRequests
	default:
		return http.StatusInternalServerError
	}
}

// WriteStructuredError writes a structured error response.
func WriteStructuredError(w http.ResponseWriter, err *Error) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(err.HTTPStatus())
	json.NewEncoder(w).Encode(err)
}

// Common errors
var (
	ErrInvalidInput = &Error{Code: "INVALID_INPUT", Message: "Invalid input"}
	ErrNotFound     = &Error{Code: "NOT_FOUND", Message: "Resource not found"}
	ErrConflict     = &Error{Code: "CONFLICT", Message: "Resource conflict"}
	ErrInternal     = &Error{Code: "INTERNAL", Message: "Internal server error"}
	ErrUnauthorized = &Error{Code: "UNAUTHORIZED", Message: "Unauthorized"}
	ErrForbidden    = &Error{Code: "FORBIDDEN", Message: "Forbidden"}
	ErrRateLimited  = &Error{Code: "RATE_LIMITED", Message: "Rate limit exceeded"}
)

