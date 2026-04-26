package middleware

import (
	"context"
	"fmt"
	"reflect"
	"regexp"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// ValidationMiddleware validates incoming requests
type ValidationMiddleware struct {
	validators map[string]RequestValidator
}

// RequestValidator validates a request
type RequestValidator interface {
	Validate(req interface{}) error
}

// NewValidationMiddleware creates a new validation middleware
func NewValidationMiddleware() *ValidationMiddleware {
	return &ValidationMiddleware{
		validators: make(map[string]RequestValidator),
	}
}

// RegisterValidator registers a validator for a method
func (v *ValidationMiddleware) RegisterValidator(method string, validator RequestValidator) {
	v.validators[method] = validator
}

// UnaryInterceptor returns a unary RPC interceptor for validation
func (v *ValidationMiddleware) UnaryInterceptor() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler) (interface{}, error) {

		// Run validation if registered
		if validator, exists := v.validators[info.FullMethod]; exists {
			if err := validator.Validate(req); err != nil {
				return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation error: %v", err))
			}
		}

		return handler(ctx, req)
	}
}

// CustomValidator implements validation logic
type CustomValidator struct {
	rules map[string]ValidationRule
}

// ValidationRule defines a validation rule
type ValidationRule struct {
	Name    string
	Checker func(interface{}) bool
	Message string
}

// Validate checks all rules
func (c *CustomValidator) Validate(req interface{}) error {
	for _, rule := range c.rules {
		if !rule.Checker(req) {
			return fmt.Errorf(rule.Message)
		}
	}
	return nil
}

// surveyNumberPattern matches Indian land survey numbers in the form
// "123", "123/4", "123/4A", "123-4/5B" (digits, optional slash/dash sub-parts,
// optional trailing letter). Tightened by regional cadastral authorities;
// over-permissive validation here lets the spatial verifier catch the rest.
var surveyNumberPattern = regexp.MustCompile(`^[0-9]+([/-][0-9A-Za-z]+)*$`)

// fieldFloat reads a float-typed field by name from a struct, returning
// (value, ok). Used by validators that operate on heterogeneous proto
// requests without requiring per-message type assertions.
func fieldFloat(req interface{}, names ...string) (float64, bool) {
	v := reflect.ValueOf(req)
	for v.Kind() == reflect.Ptr || v.Kind() == reflect.Interface {
		if v.IsNil() {
			return 0, false
		}
		v = v.Elem()
	}
	if v.Kind() != reflect.Struct {
		return 0, false
	}
	for _, name := range names {
		f := v.FieldByName(name)
		if !f.IsValid() {
			continue
		}
		switch f.Kind() {
		case reflect.Float32, reflect.Float64:
			return f.Float(), true
		case reflect.Int, reflect.Int32, reflect.Int64:
			return float64(f.Int()), true
		}
	}
	return 0, false
}

// fieldString reads a string-typed field by any of the given names.
func fieldString(req interface{}, names ...string) (string, bool) {
	v := reflect.ValueOf(req)
	for v.Kind() == reflect.Ptr || v.Kind() == reflect.Interface {
		if v.IsNil() {
			return "", false
		}
		v = v.Elem()
	}
	if v.Kind() != reflect.Struct {
		return "", false
	}
	for _, name := range names {
		f := v.FieldByName(name)
		if f.IsValid() && f.Kind() == reflect.String {
			return f.String(), true
		}
	}
	return "", false
}

// NewParcelValidator creates a validator for parcel creation. Field names are
// matched against the proto message via reflection; missing fields cause the
// rule to pass (the proto layer is responsible for required-field checks).
func NewParcelValidator() RequestValidator {
	return &CustomValidator{
		rules: map[string]ValidationRule{
			"survey_number": {
				Name: "survey_number",
				Checker: func(req interface{}) bool {
					sn, ok := fieldString(req, "SurveyNumber", "SurveyNo", "Survey")
					if !ok || sn == "" {
						return true
					}
					return surveyNumberPattern.MatchString(sn)
				},
				Message: "Invalid survey number format (expected digits with optional /N or -N sub-parts, e.g. 123/4A)",
			},
			"area": {
				Name: "area",
				Checker: func(req interface{}) bool {
					area, ok := fieldFloat(req, "AreaHa", "AreaSqm", "AreaAcres", "Area")
					if !ok {
						return true
					}
					return area > 0
				},
				Message: "Area must be greater than zero",
			},
			"coordinates": {
				Name: "coordinates",
				Checker: func(req interface{}) bool {
					lat, latOK := fieldFloat(req, "Latitude", "Lat", "CentroidLat")
					lng, lngOK := fieldFloat(req, "Longitude", "Lng", "Lon", "CentroidLng", "CentroidLon")
					if !latOK || !lngOK {
						return true
					}
					return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180
				},
				Message: "Invalid coordinates (latitude must be in [-90,90], longitude in [-180,180])",
			},
		},
	}
}
