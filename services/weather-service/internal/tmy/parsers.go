// Package tmy implements parsers for common Typical Meteorological Year file
// formats: EPW (EnergyPlus Weather), TMY2 (NREL), TMY3 (NREL), and generic
// CSV. Each parser implements handler.TMYParser.
package tmy

import (
	"bufio"
	"bytes"
	"encoding/csv"
	"fmt"
	"io"
	"strconv"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

// ========================================================================
// EPW parser — EnergyPlus Weather format
// ========================================================================
// EPW is the most common TMY format in building + solar simulation. Lines
// 1-8 are header; data starts at line 9. Columns are comma-separated, with
// year/month/day/hour/minute in columns 0-4 and irradiance in columns 6-8
// (GHI=col6, DNI=col7, DHI=col8), temperature in col6(DryBulb), wind in
// col21, RH in col8.
//
// Spec: https://bigladdersoftware.com/epx/docs/8-3/auxiliary-programs/energyplus-weather-file-epw-data-dictionary.html

type EPWParser struct{}

func NewEPWParser() *EPWParser { return &EPWParser{} }
func (p *EPWParser) Source() domain.WeatherSource { return domain.SourceEPW }

func (p *EPWParser) Parse(data []byte) ([]domain.HourlyRecord, error) {
	scanner := bufio.NewScanner(bytes.NewReader(data))
	// Skip 8 header lines
	for i := 0; i < 8; i++ {
		if !scanner.Scan() {
			return nil, fmt.Errorf("epw: unexpected EOF in header (line %d)", i+1)
		}
	}

	var records []domain.HourlyRecord
	lineNum := 8
	for scanner.Scan() {
		lineNum++
		line := scanner.Text()
		if strings.TrimSpace(line) == "" {
			continue
		}
		fields := strings.Split(line, ",")
		if len(fields) < 35 {
			continue // skip malformed lines
		}

		year := atoi(fields[0])
		month := atoi(fields[1])
		day := atoi(fields[2])
		hour := atoi(fields[3]) - 1 // EPW hours are 1-24; convert to 0-23
		if hour < 0 {
			hour = 0
		}

		ts := time.Date(year, time.Month(month), day, hour, 0, 0, 0, time.UTC)
		records = append(records, domain.HourlyRecord{
			Timestamp:          ts,
			GHI:                atof(fields[13]), // Global Horizontal Radiation (Wh/m²)
			DNI:                atof(fields[14]), // Direct Normal Radiation
			DHI:                atof(fields[15]), // Diffuse Horizontal Radiation
			AmbientTempC:       atof(fields[6]),  // Dry Bulb Temperature
			WindSpeedMS:        atof(fields[21]), // Wind Speed
			RelativeHumidityPct: atof(fields[8]),  // Relative Humidity
		})
	}
	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("epw: scan error: %w", err)
	}
	if len(records) == 0 {
		return nil, fmt.Errorf("epw: no data records found")
	}
	return records, nil
}

// ========================================================================
// TMY2 parser — NREL TMY2 format (fixed-width text, 1961-1990 data)
// ========================================================================
// TMY2 uses fixed-width columns with a 1-line header per file.
// Each data line starts with the year (2-digit), month, day, hour.
// GHI is at columns 18-21, DNI at 24-27, DHI not explicitly present (derived).
// Temperature at columns 68-71 (tenths of °C).
//
// TMY2 files are becoming rare but some older datasets still use this format.

type TM2Parser struct{}

func NewTM2Parser() *TM2Parser { return &TM2Parser{} }
func (p *TM2Parser) Source() domain.WeatherSource { return domain.SourceTM2 }

func (p *TM2Parser) Parse(data []byte) ([]domain.HourlyRecord, error) {
	scanner := bufio.NewScanner(bytes.NewReader(data))
	// Skip header line
	if !scanner.Scan() {
		return nil, fmt.Errorf("tm2: empty file")
	}

	var records []domain.HourlyRecord
	for scanner.Scan() {
		line := scanner.Text()
		if len(line) < 75 {
			continue
		}

		year := 1900 + atoi(line[0:2])
		if year < 1950 {
			year += 100 // handle Y2K for 2-digit years
		}
		month := atoi(line[2:4])
		day := atoi(line[4:6])
		hour := atoi(line[6:8]) - 1
		if hour < 0 {
			hour = 0
		}

		ts := time.Date(year, time.Month(month), day, hour, 0, 0, 0, time.UTC)
		ghi := atof(line[17:21])   // Wh/m²
		dni := atof(line[23:27])   // Wh/m²
		temp := atof(line[67:71]) / 10.0 // tenths of °C

		records = append(records, domain.HourlyRecord{
			Timestamp:    ts,
			GHI:          ghi,
			DNI:          dni,
			DHI:          ghi - dni, // approximate
			AmbientTempC: temp,
		})
	}
	if len(records) == 0 {
		return nil, fmt.Errorf("tm2: no data records found")
	}
	return records, nil
}

// ========================================================================
// TMY3 parser — NREL TMY3 format (CSV, 1991-2005 or 1976-2005 data)
// ========================================================================
// TMY3 is CSV with 2 header lines. Data columns:
// Date (MM/DD/YYYY), Time (HH:MM), GHI, DNI, DHI, DryBulb, WindSpeed, RH

type TM3Parser struct{}

func NewTM3Parser() *TM3Parser { return &TM3Parser{} }
func (p *TM3Parser) Source() domain.WeatherSource { return domain.SourceTM3 }

func (p *TM3Parser) Parse(data []byte) ([]domain.HourlyRecord, error) {
	reader := csv.NewReader(bytes.NewReader(data))
	reader.FieldsPerRecord = -1

	// Skip 2 header lines
	for i := 0; i < 2; i++ {
		if _, err := reader.Read(); err != nil {
			return nil, fmt.Errorf("tm3: header line %d: %w", i+1, err)
		}
	}

	var records []domain.HourlyRecord
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("tm3: read row: %w", err)
		}
		if len(row) < 10 {
			continue
		}

		dateStr := strings.TrimSpace(row[0])
		timeStr := strings.TrimSpace(row[1])
		ts, err := time.Parse("01/02/2006 15:04", dateStr+" "+timeStr)
		if err != nil {
			// Try alternative format
			ts, err = time.Parse("1/2/2006 15:04", dateStr+" "+timeStr)
			if err != nil {
				continue
			}
		}

		records = append(records, domain.HourlyRecord{
			Timestamp:          ts,
			GHI:                atof(row[4]),  // GHI (Wh/m²)
			DNI:                atof(row[7]),  // DNI
			DHI:                atof(row[10]), // DHI
			AmbientTempC:       atof(row[31]), // Dry-bulb
			WindSpeedMS:        atof(row[46]), // Wind speed
			RelativeHumidityPct: atof(row[37]), // RH
		})
	}
	if len(records) == 0 {
		return nil, fmt.Errorf("tm3: no data records found")
	}
	return records, nil
}

// ========================================================================
// Generic CSV parser
// ========================================================================
// Expects a header row with any of: timestamp/datetime, ghi, dni, dhi,
// temperature/temp, wind_speed/wind, humidity/rh. Case-insensitive matching.

type CSVParser struct{}

func NewCSVParser() *CSVParser { return &CSVParser{} }
func (p *CSVParser) Source() domain.WeatherSource { return domain.SourceCSV }

func (p *CSVParser) Parse(data []byte) ([]domain.HourlyRecord, error) {
	reader := csv.NewReader(bytes.NewReader(data))
	reader.FieldsPerRecord = -1

	header, err := reader.Read()
	if err != nil {
		return nil, fmt.Errorf("csv: read header: %w", err)
	}

	colIdx := map[string]int{}
	for i, h := range header {
		colIdx[strings.ToLower(strings.TrimSpace(h))] = i
	}

	tsIdx := findCol(colIdx, "timestamp", "datetime", "date_time", "time")
	ghiIdx := findCol(colIdx, "ghi", "global_horizontal_irradiance", "g(h)")
	dniIdx := findCol(colIdx, "dni", "direct_normal_irradiance", "gb(n)")
	dhiIdx := findCol(colIdx, "dhi", "diffuse_horizontal_irradiance", "gd(h)")
	tempIdx := findCol(colIdx, "temperature", "temp", "air_temperature", "t2m", "dry_bulb")
	windIdx := findCol(colIdx, "wind_speed", "wind", "ws10m", "ws")
	rhIdx := findCol(colIdx, "humidity", "rh", "relative_humidity", "rh2m")

	if tsIdx < 0 || ghiIdx < 0 {
		return nil, fmt.Errorf("csv: header must contain at minimum 'timestamp' and 'ghi' columns; got: %v", header)
	}

	layouts := []string{
		time.RFC3339,
		"2006-01-02T15:04:05",
		"2006-01-02 15:04:05",
		"2006-01-02 15:04",
		"01/02/2006 15:04",
		"1/2/2006 15:04",
		"20060102:1504",
	}

	var records []domain.HourlyRecord
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("csv: read row: %w", err)
		}

		tsStr := colAt(row, tsIdx)
		ts, err := tryParseTime(tsStr, layouts)
		if err != nil {
			continue
		}

		rec := domain.HourlyRecord{
			Timestamp:          ts,
			GHI:                floatAt(row, ghiIdx),
			DNI:                floatAt(row, dniIdx),
			DHI:                floatAt(row, dhiIdx),
			AmbientTempC:       floatAt(row, tempIdx),
			WindSpeedMS:        floatAt(row, windIdx),
			RelativeHumidityPct: floatAt(row, rhIdx),
		}
		records = append(records, rec)
	}
	if len(records) == 0 {
		return nil, fmt.Errorf("csv: no data records parsed")
	}
	return records, nil
}

func findCol(idx map[string]int, candidates ...string) int {
	for _, c := range candidates {
		if i, ok := idx[c]; ok {
			return i
		}
	}
	return -1
}

func colAt(row []string, idx int) string {
	if idx < 0 || idx >= len(row) {
		return ""
	}
	return strings.TrimSpace(row[idx])
}

func floatAt(row []string, idx int) float64 {
	s := colAt(row, idx)
	v, _ := strconv.ParseFloat(s, 64)
	return v
}

func tryParseTime(s string, layouts []string) (time.Time, error) {
	for _, l := range layouts {
		t, err := time.Parse(l, s)
		if err == nil {
			return t, nil
		}
	}
	return time.Time{}, fmt.Errorf("cannot parse time %q", s)
}

func atoi(s string) int {
	v, _ := strconv.Atoi(strings.TrimSpace(s))
	return v
}

func atof(s string) float64 {
	v, _ := strconv.ParseFloat(strings.TrimSpace(s), 64)
	return v
}
