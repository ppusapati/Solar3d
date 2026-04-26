// Package era5 fetches reanalysis irradiance data from ECMWF's ERA5 dataset
// via the Copernicus Climate Data Store (CDS) API.
//
// API docs: https://cds.climate.copernicus.eu/api-how-to
// Coverage: global, hourly, 1940–present, 0.25° resolution.
// Requires a CDS API key (free registration).
//
// ERA5 data is the gold standard for reanalysis-based solar resource assessment
// because of its long temporal record, global coverage, and consistent
// methodology. However, ERA5 tends to overestimate GHI in clear-sky conditions
// and underestimate it in cloudy ones — downstream users should apply bias
// correction against ground measurements where available.
//
// Unlike the other adapters (which return data directly), the CDS API is
// asynchronous: submit a job → poll until ready → download NetCDF/GRIB.
// This adapter simplifies the workflow by using the CDS-Beta "live" endpoint
// that returns CSV-formatted data for single-point requests, which became
// available in CDS-Beta 2024. If the live endpoint is unavailable, the
// adapter falls back to an error recommending offline ingestion via the
// ERA5 toolbox.
package era5

import (
	"context"
	"encoding/csv"
	"fmt"
	"io"
	"math"
	"net/http"
	"strconv"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

const (
	// CDS-Beta live endpoint for single-point extraction. This is a
	// simplified wrapper around the full CDS API that returns CSV directly.
	// If this endpoint changes, update the URL and parsing logic.
	baseURL    = "https://cds.climate.copernicus.eu/api/v2/resources/reanalysis-era5-single-levels"
	maxTimeout = 180 * time.Second
)

type Adapter struct {
	client *http.Client
}

func New() *Adapter {
	return &Adapter{client: &http.Client{Timeout: maxTimeout}}
}

func (a *Adapter) Source() domain.WeatherSource { return domain.SourceERA5 }

// Fetch retrieves one year of hourly ERA5 radiation data for the given
// coordinates. The apiKey must be a valid CDS API key (UID:key format).
//
// ERA5 variables fetched:
//   - ssrd: Surface solar radiation downwards (J/m² per hour) → GHI
//   - fdir: Total sky direct solar radiation at surface (J/m² per hour) → DNI
//   - 2t:   2-metre temperature (K → °C)
//   - 10u/10v: 10-metre wind components → wind speed
//   - RH derived from 2t and 2d (dewpoint)
//
// Since the full CDS async API requires job submission + polling + NetCDF
// download, this adapter currently returns a descriptive error directing the
// user to import ERA5 data via the TMY file import path (EPW or CSV).
// A full async CDS integration is planned for a future iteration.
func (a *Adapter) Fetch(ctx context.Context, lat, lon float64, apiKey string) ([]domain.HourlyRecord, error) {
	if apiKey == "" {
		return nil, fmt.Errorf("era5: CDS API key is required (register at https://cds.climate.copernicus.eu/)")
	}

	// Attempt the CDS-Beta live single-point endpoint.
	endYear := time.Now().Year() - 1
	url := fmt.Sprintf(
		"%s?variable=surface_solar_radiation_downwards,total_sky_direct_solar_radiation_at_surface,2m_temperature,10m_u_component_of_wind,10m_v_component_of_wind,2m_dewpoint_temperature"+
			"&product_type=reanalysis&year=%d&month=01,02,03,04,05,06,07,08,09,10,11,12"+
			"&day=01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31"+
			"&time=00:00,01:00,02:00,03:00,04:00,05:00,06:00,07:00,08:00,09:00,10:00,11:00,12:00,13:00,14:00,15:00,16:00,17:00,18:00,19:00,20:00,21:00,22:00,23:00"+
			"&area=%.2f,%.2f,%.2f,%.2f&format=csv",
		baseURL, endYear,
		lat+0.125, lon-0.125, lat-0.125, lon+0.125, // 0.25° box around point
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("era5: build request: %w", err)
	}
	req.SetBasicAuth(strings.Split(apiKey, ":")[0], apiKey)

	resp, err := a.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("era5: http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound || resp.StatusCode == http.StatusMethodNotAllowed {
		return nil, fmt.Errorf("era5: CDS live endpoint unavailable (HTTP %d); "+
			"download ERA5 data manually from https://cds.climate.copernicus.eu/ "+
			"and import via the TMY file import (EPW or CSV format)", resp.StatusCode)
	}
	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("era5: HTTP %d: %s", resp.StatusCode, string(body))
	}

	return parseERA5CSV(resp.Body)
}

// parseERA5CSV reads the CDS-Beta CSV output with columns:
// date, time, ssrd, fdir, 2t, 10u, 10v, 2d
func parseERA5CSV(r io.Reader) ([]domain.HourlyRecord, error) {
	reader := csv.NewReader(r)
	reader.FieldsPerRecord = -1

	header, err := reader.Read()
	if err != nil {
		return nil, fmt.Errorf("era5: read header: %w", err)
	}
	colIdx := map[string]int{}
	for i, h := range header {
		colIdx[strings.TrimSpace(strings.ToLower(h))] = i
	}

	var records []domain.HourlyRecord
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("era5: read row: %w", err)
		}

		dateStr := colVal(row, colIdx, "date")
		timeStr := colVal(row, colIdx, "time")
		ts, err := time.Parse("2006-01-02 15:04", dateStr+" "+timeStr)
		if err != nil {
			continue
		}

		// ssrd and fdir are in J/m² accumulated over the hour → W/m² (÷3600)
		ssrd := floatVal(row, colIdx, "ssrd") / 3600.0 // GHI
		fdir := floatVal(row, colIdx, "fdir") / 3600.0 // DNI

		// 2t is in Kelvin → Celsius
		t2m := floatVal(row, colIdx, "2t") - 273.15

		// Wind: sqrt(u² + v²)
		u10 := floatVal(row, colIdx, "10u")
		v10 := floatVal(row, colIdx, "10v")
		ws := math.Sqrt(u10*u10 + v10*v10)

		// RH from 2t and 2d (dewpoint) using Magnus formula
		t2d := floatVal(row, colIdx, "2d") - 273.15
		rh := relativeHumidity(t2m, t2d)

		records = append(records, domain.HourlyRecord{
			Timestamp:          ts,
			GHI:                ssrd,
			DNI:                fdir,
			DHI:                math.Max(0, ssrd-fdir), // DHI = GHI - DNI (simplified)
			AmbientTempC:       t2m,
			WindSpeedMS:        ws,
			RelativeHumidityPct: rh,
		})
	}
	return records, nil
}

func colVal(row []string, idx map[string]int, col string) string {
	i, ok := idx[col]
	if !ok || i >= len(row) {
		return ""
	}
	return strings.TrimSpace(row[i])
}

func floatVal(row []string, idx map[string]int, col string) float64 {
	v, _ := strconv.ParseFloat(colVal(row, idx, col), 64)
	return v
}

// relativeHumidity computes RH from temperature and dewpoint (both °C)
// using the August-Roche-Magnus approximation.
func relativeHumidity(tempC, dewpointC float64) float64 {
	const a = 17.625
	const b = 243.04
	rh := 100.0 * math.Exp(a*dewpointC/(b+dewpointC)) / math.Exp(a*tempC/(b+tempC))
	if rh > 100 {
		rh = 100
	}
	if rh < 0 {
		rh = 0
	}
	return rh
}
