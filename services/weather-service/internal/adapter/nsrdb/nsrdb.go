// Package nsrdb fetches hourly TMY data from NREL's National Solar Radiation
// Database (NSRDB) Physical Solar Model (PSM) v3.
//
// API docs: https://developer.nrel.gov/docs/solar/nsrdb/
// Coverage: US + Americas + parts of Asia (1998–present, 4km resolution).
// Requires a free API key from https://developer.nrel.gov/signup/.
package nsrdb

import (
	"context"
	"encoding/csv"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

const (
	baseURL    = "https://developer.nrel.gov/api/nsrdb/v2/solar/psm3-tmy-download.csv"
	maxTimeout = 120 * time.Second
)

type Adapter struct {
	client *http.Client
}

func New() *Adapter {
	return &Adapter{client: &http.Client{Timeout: maxTimeout}}
}

func (a *Adapter) Source() domain.WeatherSource { return domain.SourceNSRDB }

func (a *Adapter) Fetch(ctx context.Context, lat, lon float64, apiKey string) ([]domain.HourlyRecord, error) {
	if apiKey == "" {
		return nil, fmt.Errorf("nsrdb: api_key is required (register at https://developer.nrel.gov/signup/)")
	}

	url := fmt.Sprintf(
		"%s?api_key=%s&lat=%.4f&lon=%.4f&names=tmy-2021&leap_day=false&utc=true"+
			"&attributes=ghi,dni,dhi,air_temperature,wind_speed,relative_humidity"+
			"&interval=60&email=solar3d@example.com",
		baseURL, apiKey, lat, lon,
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("nsrdb: build request: %w", err)
	}

	resp, err := a.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("nsrdb: http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("nsrdb: HTTP %d: %s", resp.StatusCode, string(body))
	}

	return parseNSRDBCSV(resp.Body)
}

// parseNSRDBCSV reads the NSRDB PSM3 TMY CSV format:
// Line 1: metadata (Source, Location ID, …)
// Line 2: column headers (Year, Month, Day, Hour, Minute, GHI, DNI, DHI, …)
// Lines 3+: data rows.
func parseNSRDBCSV(r io.Reader) ([]domain.HourlyRecord, error) {
	reader := csv.NewReader(r)
	reader.FieldsPerRecord = -1 // variable columns

	// Skip metadata line
	if _, err := reader.Read(); err != nil {
		return nil, fmt.Errorf("nsrdb: read metadata line: %w", err)
	}
	// Read header
	header, err := reader.Read()
	if err != nil {
		return nil, fmt.Errorf("nsrdb: read header line: %w", err)
	}

	colIdx := map[string]int{}
	for i, h := range header {
		colIdx[strings.TrimSpace(h)] = i
	}

	required := []string{"Year", "Month", "Day", "Hour", "GHI", "DNI", "DHI", "Temperature", "Wind Speed"}
	for _, col := range required {
		if _, ok := colIdx[col]; !ok {
			return nil, fmt.Errorf("nsrdb: missing column %q in header", col)
		}
	}

	var records []domain.HourlyRecord
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("nsrdb: read row: %w", err)
		}

		year := intCol(row, colIdx, "Year")
		month := intCol(row, colIdx, "Month")
		day := intCol(row, colIdx, "Day")
		hour := intCol(row, colIdx, "Hour")
		minute := intCol(row, colIdx, "Minute")

		ts := time.Date(year, time.Month(month), day, hour, minute, 0, 0, time.UTC)

		rec := domain.HourlyRecord{
			Timestamp:    ts,
			GHI:          floatCol(row, colIdx, "GHI"),
			DNI:          floatCol(row, colIdx, "DNI"),
			DHI:          floatCol(row, colIdx, "DHI"),
			AmbientTempC: floatCol(row, colIdx, "Temperature"),
			WindSpeedMS:  floatCol(row, colIdx, "Wind Speed"),
		}
		if idx, ok := colIdx["Relative Humidity"]; ok && idx < len(row) {
			rec.RelativeHumidityPct, _ = strconv.ParseFloat(strings.TrimSpace(row[idx]), 64)
		}
		records = append(records, rec)
	}
	return records, nil
}

func intCol(row []string, idx map[string]int, col string) int {
	i, ok := idx[col]
	if !ok || i >= len(row) {
		return 0
	}
	v, _ := strconv.Atoi(strings.TrimSpace(row[i]))
	return v
}

func floatCol(row []string, idx map[string]int, col string) float64 {
	i, ok := idx[col]
	if !ok || i >= len(row) {
		return 0
	}
	v, _ := strconv.ParseFloat(strings.TrimSpace(row[i]), 64)
	return v
}
