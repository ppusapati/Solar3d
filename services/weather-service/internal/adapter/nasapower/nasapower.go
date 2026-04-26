// Package nasapower fetches daily solar radiation data from NASA's Prediction
// of Worldwide Energy Resources (POWER) API v2.
//
// API docs: https://power.larc.nasa.gov/docs/services/api/
// Coverage: global, daily resolution, 1981–present.
// No API key required.
//
// POWER provides daily GHI, DNI, DHI, and ambient temperature. We generate
// synthetic hourly records by distributing daily totals using a cosine solar
// profile. This is less accurate than true hourly TMY but covers locations
// where PVGIS has no data (e.g., parts of the Americas, Oceania).
package nasapower

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"math"
	"net/http"
	"time"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

const (
	baseURL    = "https://power.larc.nasa.gov/api/temporal/daily/point"
	maxTimeout = 90 * time.Second
)

type Adapter struct {
	client *http.Client
}

func New() *Adapter {
	return &Adapter{client: &http.Client{Timeout: maxTimeout}}
}

func (a *Adapter) Source() domain.WeatherSource { return domain.SourceNASA }

func (a *Adapter) Fetch(ctx context.Context, lat, lon float64, _ string) ([]domain.HourlyRecord, error) {
	// Fetch one full year of daily data (most recent complete year).
	endYear := time.Now().Year() - 1
	startDate := fmt.Sprintf("%d0101", endYear)
	endDate := fmt.Sprintf("%d1231", endYear)

	url := fmt.Sprintf(
		"%s?parameters=ALLSKY_SFC_SW_DWN,ALLSKY_SFC_SW_DIFF,ALLSKY_SFC_SW_DNI,T2M,WS10M,RH2M"+
			"&community=RE&longitude=%.4f&latitude=%.4f"+
			"&start=%s&end=%s&format=JSON",
		baseURL, lon, lat, startDate, endDate,
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("nasa_power: build request: %w", err)
	}

	resp, err := a.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("nasa_power: http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("nasa_power: HTTP %d: %s", resp.StatusCode, string(body))
	}

	var payload nasaPowerResponse
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil, fmt.Errorf("nasa_power: decode JSON: %w", err)
	}

	records, err := dailyToHourly(payload, lat, endYear)
	if err != nil {
		return nil, err
	}
	if len(records) == 0 {
		return nil, fmt.Errorf("nasa_power: no records generated")
	}
	return records, nil
}

// ---- NASA POWER JSON response ----

type nasaPowerResponse struct {
	Properties struct {
		Parameter map[string]map[string]float64 `json:"parameter"`
	} `json:"properties"`
}

// dailyToHourly distributes daily GHI totals into synthetic hourly records
// using a cosine-weighted solar profile centred on solar noon. This is a
// standard approach for feasibility-stage estimates when only daily data is
// available (see PVsyst User Manual §4.5.2).
func dailyToHourly(data nasaPowerResponse, lat float64, year int) ([]domain.HourlyRecord, error) {
	ghiDaily := data.Properties.Parameter["ALLSKY_SFC_SW_DWN"]
	dniDaily := data.Properties.Parameter["ALLSKY_SFC_SW_DNI"]
	dhiDaily := data.Properties.Parameter["ALLSKY_SFC_SW_DIFF"]
	t2mDaily := data.Properties.Parameter["T2M"]
	wsDaily := data.Properties.Parameter["WS10M"]
	rhDaily := data.Properties.Parameter["RH2M"]

	if len(ghiDaily) == 0 {
		return nil, fmt.Errorf("nasa_power: no GHI data in response")
	}

	var records []domain.HourlyRecord

	for dateStr, dailyGHI := range ghiDaily {
		if dailyGHI < 0 {
			continue // missing data sentinel
		}
		date, err := time.Parse("20060102", dateStr)
		if err != nil {
			continue
		}

		dailyDNI := getParam(dniDaily, dateStr)
		dailyDHI := getParam(dhiDaily, dateStr)
		dailyTemp := getParam(t2mDaily, dateStr)
		dailyWS := getParam(wsDaily, dateStr)
		dailyRH := getParam(rhDaily, dateStr)

		// Distribute daily kWh/m²/day across daylight hours using cosine profile.
		// Daily GHI from POWER is in kWh/m²/day; convert to Wh/m²/day for hourly W/m².
		dailyGHIWh := dailyGHI * 1000.0
		dailyDNIWh := dailyDNI * 1000.0
		dailyDHIWh := dailyDHI * 1000.0

		for hour := 0; hour < 24; hour++ {
			ts := date.Add(time.Duration(hour) * time.Hour)
			weight := solarWeight(hour, lat, date.YearDay())
			records = append(records, domain.HourlyRecord{
				Timestamp:          ts,
				GHI:                dailyGHIWh * weight,
				DNI:                dailyDNIWh * weight,
				DHI:                dailyDHIWh * weight,
				AmbientTempC:       dailyTemp + tempDiurnalOffset(hour),
				WindSpeedMS:        dailyWS,
				RelativeHumidityPct: dailyRH,
			})
		}
	}
	return records, nil
}

func getParam(m map[string]float64, key string) float64 {
	if v, ok := m[key]; ok && v >= 0 {
		return v
	}
	return 0
}

// solarWeight returns a normalised weight for distributing daily irradiance
// into hourly values using a simplified cosine solar zenith model.
// Sum of weights across 24 hours ≈ 1.0.
func solarWeight(hour int, latDeg float64, dayOfYear int) float64 {
	// Solar declination (Spencer, 1971)
	B := 2 * math.Pi * float64(dayOfYear-1) / 365.0
	declRad := 0.006918 - 0.399912*math.Cos(B) + 0.070257*math.Sin(B) -
		0.006758*math.Cos(2*B) + 0.000907*math.Sin(2*B)

	latRad := latDeg * math.Pi / 180.0
	hourAngle := (float64(hour) - 12.0) * 15.0 * math.Pi / 180.0

	cosZ := math.Sin(latRad)*math.Sin(declRad) +
		math.Cos(latRad)*math.Cos(declRad)*math.Cos(hourAngle)

	if cosZ <= 0 {
		return 0 // nighttime
	}

	// Normalise so that the sum of positive cosZ values across 24h ≈ 1.
	// We use a fixed normalisation factor per day to keep the distribution
	// energy-conserving.
	var sumCosZ float64
	for h := 0; h < 24; h++ {
		ha := (float64(h) - 12.0) * 15.0 * math.Pi / 180.0
		cz := math.Sin(latRad)*math.Sin(declRad) +
			math.Cos(latRad)*math.Cos(declRad)*math.Cos(ha)
		if cz > 0 {
			sumCosZ += cz
		}
	}
	if sumCosZ == 0 {
		return 0
	}
	return cosZ / sumCosZ
}

// tempDiurnalOffset applies a simplified diurnal temperature cycle: coolest at
// 05:00, warmest at 14:00. Amplitude ±4°C.
func tempDiurnalOffset(hour int) float64 {
	return 4.0 * math.Cos(2*math.Pi*float64(hour-14)/24.0)
}
