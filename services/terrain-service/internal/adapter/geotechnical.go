package adapter

import (
	"encoding/csv"
	"fmt"
	"io"
	"strconv"
	"strings"
)

// GeotechnicalSample represents a single borehole or test pit result with
// soil properties relevant to foundation design.
type GeotechnicalSample struct {
	ID              string  `json:"id"`
	Easting         float64 `json:"easting"`
	Northing        float64 `json:"northing"`
	DepthM          float64 `json:"depth_m"`
	SoilType        string  `json:"soil_type"`       // USCS classification (e.g., "SM", "CL", "GP")
	BearingCapKPa   float64 `json:"bearing_cap_kpa"` // allowable bearing capacity
	SPTBlowCount    int     `json:"spt_blow_count"`  // Standard Penetration Test N-value
	WaterTableDepthM float64 `json:"water_table_depth_m"`
	Notes           string  `json:"notes,omitempty"`
}

// ParseGeotechnicalCSV reads a CSV file of geotechnical borehole data.
// Expected columns (case-insensitive, order-independent):
// id, easting, northing, depth_m, soil_type, bearing_cap_kpa, spt_n, water_table_m, notes
func ParseGeotechnicalCSV(r io.Reader) ([]GeotechnicalSample, error) {
	reader := csv.NewReader(r)
	reader.FieldsPerRecord = -1

	header, err := reader.Read()
	if err != nil {
		return nil, fmt.Errorf("geotech: read header: %w", err)
	}

	colIdx := map[string]int{}
	for i, h := range header {
		colIdx[strings.ToLower(strings.TrimSpace(h))] = i
	}

	required := []string{"easting", "northing"}
	for _, col := range required {
		if _, ok := colIdx[col]; !ok {
			return nil, fmt.Errorf("geotech: missing required column %q", col)
		}
	}

	var samples []GeotechnicalSample
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("geotech: read row: %w", err)
		}

		s := GeotechnicalSample{
			ID:              csvStr(row, colIdx, "id"),
			Easting:         csvFloat(row, colIdx, "easting"),
			Northing:        csvFloat(row, colIdx, "northing"),
			DepthM:          csvFloat(row, colIdx, "depth_m"),
			SoilType:        csvStr(row, colIdx, "soil_type"),
			BearingCapKPa:   csvFloat(row, colIdx, "bearing_cap_kpa"),
			SPTBlowCount:    csvInt(row, colIdx, "spt_n"),
			WaterTableDepthM: csvFloat(row, colIdx, "water_table_m"),
			Notes:           csvStr(row, colIdx, "notes"),
		}
		samples = append(samples, s)
	}

	if len(samples) == 0 {
		return nil, fmt.Errorf("geotech: no data rows")
	}
	return samples, nil
}

func csvStr(row []string, idx map[string]int, col string) string {
	if i, ok := idx[col]; ok && i < len(row) {
		return strings.TrimSpace(row[i])
	}
	return ""
}

func csvFloat(row []string, idx map[string]int, col string) float64 {
	s := csvStr(row, idx, col)
	if s == "" {
		return 0
	}
	v, _ := strconv.ParseFloat(s, 64)
	return v
}

func csvInt(row []string, idx map[string]int, col string) int {
	s := csvStr(row, idx, col)
	if s == "" {
		return 0
	}
	v, _ := strconv.Atoi(s)
	return v
}
