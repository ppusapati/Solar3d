package domain

import "errors"

var (
	// Layout errors.
	ErrLayoutNotFound = errors.New("layout not found")
	ErrLayoutExists   = errors.New("layout already exists")

	// Component errors.
	ErrComponentNotFound = errors.New("component not found")

	// Tile errors.
	ErrTileNotFound = errors.New("tile not found")

	// Panel errors.
	ErrPanelNotFound = errors.New("panel not found")

	// Validation errors.
	ErrInvalidPanelDimensions = errors.New("panel dimensions must be between 0 and 10 meters")
	ErrInvalidTiltAngle       = errors.New("tilt angle must be between 0 and 90 degrees")
	ErrInvalidAzimuth         = errors.New("azimuth must be between 0 and 360 degrees")
	ErrInvalidSpacing         = errors.New("spacing must be non-negative")
	ErrMissingFillArea        = errors.New("fill area GeoJSON is required")
	ErrInvalidFillArea        = errors.New("fill area GeoJSON is invalid or not a polygon")
	ErrInvalidPanelCapacity   = errors.New("panel capacity must be positive")
	ErrEmptyFillArea          = errors.New("fill area polygon has zero or negative area")

	// General errors.
	ErrInvalidID = errors.New("invalid UUID")
)
