package utils

import (
	"encoding/json"
	"net/http"
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

