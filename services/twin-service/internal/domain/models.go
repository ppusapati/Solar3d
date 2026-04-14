package domain

import (
	"time"

	"github.com/google/uuid"
)

// TwinStatus represents the lifecycle state of a digital twin.
type TwinStatus string

const (
	TwinStatusProvisioning   TwinStatus = "PROVISIONING"
	TwinStatusActive         TwinStatus = "ACTIVE"
	TwinStatusSuspended      TwinStatus = "SUSPENDED"
	TwinStatusDecommissioned TwinStatus = "DECOMMISSIONED"
)

// TelemetryMetric identifies the physical quantity being measured.
// Values are aligned with IEC 61724-1 solar performance monitoring.
type TelemetryMetric string

const (
	MetricDCPowerW           TelemetryMetric = "DC_POWER_W"
	MetricACPowerW           TelemetryMetric = "AC_POWER_W"
	MetricEnergyWh           TelemetryMetric = "ENERGY_WH"
	MetricIrradianceWm2      TelemetryMetric = "IRRADIANCE_WM2"
	MetricTemperatureC       TelemetryMetric = "TEMPERATURE_C"
	MetricModuleTempC        TelemetryMetric = "MODULE_TEMP_C"
	MetricWindSpeedMs        TelemetryMetric = "WIND_SPEED_MS"
	MetricACVoltageV         TelemetryMetric = "AC_VOLTAGE_V"
	MetricDCVoltageV         TelemetryMetric = "DC_VOLTAGE_V"
	MetricACCurrentA         TelemetryMetric = "AC_CURRENT_A"
	MetricDCCurrentA         TelemetryMetric = "DC_CURRENT_A"
	MetricPerformanceRatioPc TelemetryMetric = "PERFORMANCE_RATIO_PC"
)

// ReadingQuality indicates signal reliability per IEC 61724-1 §5.
type ReadingQuality string

const (
	ReadingQualityGood    ReadingQuality = "GOOD"
	ReadingQualitySuspect ReadingQuality = "SUSPECT"
	ReadingQualityBad     ReadingQuality = "BAD"
)

// OperationalState carries the real-time operational snapshot of a twin.
type OperationalState struct {
	PowerOutputKW    float64 `json:"power_output_kw"`
	AvailabilityPct  float64 `json:"availability_pct"`
	ActiveFaultCount int     `json:"active_fault_count"`
	HealthScore      float64 `json:"health_score"`
}

// DigitalTwin is the core aggregate for a provisioned digital twin.
type DigitalTwin struct {
	ID                  uuid.UUID        `json:"id"`
	ProjectID           uuid.UUID        `json:"project_id"`
	LayoutID            *uuid.UUID       `json:"layout_id,omitempty"`
	ElectricalNetworkID *uuid.UUID       `json:"electrical_network_id,omitempty"`
	TransmissionRouteID *uuid.UUID       `json:"transmission_route_id,omitempty"`
	Status              TwinStatus       `json:"status"`
	Operational         OperationalState `json:"operational"`
	CreatedAt           time.Time        `json:"created_at"`
	UpdatedAt           time.Time        `json:"updated_at"`
}

// DesignAssetType classifies the design artifact a physical asset is linked to.
type DesignAssetType string

const (
	DesignAssetTypePanel       DesignAssetType = "PANEL"
	DesignAssetTypeInverter    DesignAssetType = "INVERTER"
	DesignAssetTypeTransformer DesignAssetType = "TRANSFORMER"
	DesignAssetTypeCable       DesignAssetType = "CABLE"
	DesignAssetTypeMount       DesignAssetType = "MOUNT"
	DesignAssetTypeMeter       DesignAssetType = "METER"
	DesignAssetTypeSensor      DesignAssetType = "SENSOR"
	DesignAssetTypeProtection  DesignAssetType = "PROTECTION"
	DesignAssetTypeTracker     DesignAssetType = "TRACKER"
)

// AssetIdentity links a design artifact to a commissioned physical asset.
// Commissioning reference follows IEC 62446-1 §7.
type AssetIdentity struct {
	ID                   uuid.UUID       `json:"id"`
	TwinID               uuid.UUID       `json:"twin_id"`
	DesignAssetID        uuid.UUID       `json:"design_asset_id"`
	DesignAssetType      DesignAssetType `json:"design_asset_type"`
	PhysicalSerialNumber string          `json:"physical_serial_number"`
	CommissioningRef     string          `json:"commissioning_ref"`
	CreatedAt            time.Time       `json:"created_at"`
	UpdatedAt            time.Time       `json:"updated_at"`
}

// SensorReading is a single time-series data point from a commissioned asset.
type SensorReading struct {
	ID              uuid.UUID       `json:"id"`
	TwinID          uuid.UUID       `json:"twin_id"`
	SensorID        string          `json:"sensor_id"`
	AssetIdentityID *uuid.UUID      `json:"asset_identity_id,omitempty"`
	Metric          TelemetryMetric `json:"metric"`
	Value           float64         `json:"value"`
	Unit            string          `json:"unit"`
	Quality         ReadingQuality  `json:"quality"`
	RecordedAt      time.Time       `json:"recorded_at"`
	IngestedAt      time.Time       `json:"ingested_at"`
}
