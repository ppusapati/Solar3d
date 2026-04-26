// Package pvgis fetches hourly TMY irradiance data from the EU JRC
// Photovoltaic Geographical Information System (PVGIS 5.2+).
//
// API docs: https://re.jrc.ec.europa.eu/pvg_tools/en/
// Endpoint: https://re.jrc.ec.europa.eu/api/v5_2/tmy
//
// PVGIS is free, requires no API key, and covers Europe, Africa, most of Asia,
// and the Americas between ±60° latitude. Response is JSON with hourly records
// for a Typical Meteorological Year.
package pvgis

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

const (
	baseURL    = "https://re.jrc.ec.europa.eu/api/v5_2/tmy"
	maxTimeout = 60 * time.Second
)

// Adapter implements handler.Adapter for PVGIS.
type Adapter struct {
	client *http.Client
}

func New() *Adapter {
	return &Adapter{client: &http.Client{Timeout: maxTimeout}}
}

func (a *Adapter) Source() domain.WeatherSource { return domain.SourcePVGIS }

func (a *Adapter) Fetch(ctx context.Context, lat, lon float64, _ string) ([]domain.HourlyRecord, error) {
	url := fmt.Sprintf("%s?lat=%.4f&lon=%.4f&outputformat=json", baseURL, lat, lon)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("pvgis: build request: %w", err)
	}
	req.Header.Set("Accept", "application/json")

	resp, err := a.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("pvgis: http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("pvgis: HTTP %d: %s", resp.StatusCode, string(body))
	}

	var payload pvgisResponse
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil, fmt.Errorf("pvgis: decode JSON: %w", err)
	}

	records := make([]domain.HourlyRecord, 0, len(payload.Outputs.TMYHourly))
	for _, h := range payload.Outputs.TMYHourly {
		ts, err := parsePVGISTime(h.Time)
		if err != nil {
			continue // skip malformed timestamps
		}
		records = append(records, domain.HourlyRecord{
			Timestamp:          ts,
			GHI:                h.Gb + h.Gd, // PVGIS: Gb(n) beam horizontal + Gd diffuse = GHI
			DNI:                h.Gb,
			DHI:                h.Gd,
			AmbientTempC:       h.T2m,
			WindSpeedMS:        h.WS10m,
			RelativeHumidityPct: h.RH,
		})
	}
	if len(records) == 0 {
		return nil, fmt.Errorf("pvgis: no hourly records in response")
	}
	return records, nil
}

// ---- PVGIS JSON response structures ----

type pvgisResponse struct {
	Outputs struct {
		TMYHourly []pvgisHourly `json:"tmy_hourly"`
	} `json:"outputs"`
}

type pvgisHourly struct {
	Time  string  `json:"time(UTC)"`
	Gb    float64 `json:"G(h)"`     // beam horizontal irradiance
	Gd    float64 `json:"Gd(h)"`    // diffuse horizontal irradiance
	T2m   float64 `json:"T2m"`      // 2-m air temperature
	WS10m float64 `json:"WS10m"`    // 10-m wind speed
	RH    float64 `json:"RH"`       // relative humidity %
}

// parsePVGISTime parses PVGIS timestamps which are "20050101:0010" format
// (YYYYMMdd:HHmm).
func parsePVGISTime(s string) (time.Time, error) {
	return time.Parse("20060102:1504", s)
}
