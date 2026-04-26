package domain

import (
	"time"

	"github.com/google/uuid"
)

// WeatherSource identifies the upstream provider or file format.
type WeatherSource string

const (
	SourcePVGIS    WeatherSource = "pvgis"
	SourceNASA     WeatherSource = "nasa_power"
	SourceNSRDB    WeatherSource = "nsrdb"
	SourceERA5     WeatherSource = "era5"
	SourceEPW      WeatherSource = "epw"
	SourceTM2      WeatherSource = "tm2"
	SourceTM3      WeatherSource = "tm3"
	SourceCSV      WeatherSource = "csv"
)

// HourlyRecord is one hour of irradiance + meteorological data. All
// irradiance values in W/m², temperature in °C, wind in m/s.
type HourlyRecord struct {
	Timestamp          time.Time `json:"timestamp"`
	GHI                float64   `json:"ghi"`                   // W/m²
	DNI                float64   `json:"dni"`                   // W/m²
	DHI                float64   `json:"dhi"`                   // W/m²
	AmbientTempC       float64   `json:"ambient_temp_c"`
	WindSpeedMS        float64   `json:"wind_speed_ms"`
	RelativeHumidityPct float64  `json:"relative_humidity_pct"` // 0-100
	Albedo             float64   `json:"albedo"`                // 0-1
}

// SiteWeather is the stored envelope for a weather dataset.
type SiteWeather struct {
	ID              uuid.UUID     `json:"id"`
	ProjectID       uuid.UUID     `json:"project_id"`
	Latitude        float64       `json:"latitude"`
	Longitude       float64       `json:"longitude"`
	Source          WeatherSource `json:"source"`
	Records         []HourlyRecord `json:"records,omitempty"`
	RecordCount     int           `json:"record_count"`
	AnnualGHIKWhM2  float64       `json:"annual_ghi_kwh_m2"`
	FetchedAt       time.Time     `json:"fetched_at"`
}

// YieldExceedance is a single percentile result.
type YieldExceedance struct {
	Percentile     int     `json:"percentile"`       // 50, 75, 90, 95, 99
	AnnualGHIKWhM2 float64 `json:"annual_ghi_kwh_m2"`
}

// ComputeAnnualGHI sums the hourly GHI records into annual kWh/m².
// GHI is in W/m² per hour → Wh/m² → /1000 → kWh/m².
func ComputeAnnualGHI(records []HourlyRecord) float64 {
	var sumWh float64
	for _, r := range records {
		sumWh += r.GHI // each record is 1 hour → W/m² × 1h = Wh/m²
	}
	return sumWh / 1000.0
}
