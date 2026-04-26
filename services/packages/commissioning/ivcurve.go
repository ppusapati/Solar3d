// Package commissioning provides commissioning-phase data models and parsers
// for IV-curve traces, thermal imagery, insulation resistance tests,
// performance ratio validation, and turnover documentation.
package commissioning

import (
	"bufio"
	"fmt"
	"io"
	"math"
	"strconv"
	"strings"
	"time"
)

// ========================================================================
// IV-Curve File Importers
// ========================================================================

// IVPoint is a single (voltage, current) measurement on an IV curve.
type IVPoint struct {
	VoltageV float64 `json:"voltage_v"`
	CurrentA float64 `json:"current_a"`
}

// IVCurveTrace is a complete IV-curve measurement for one module or string.
type IVCurveTrace struct {
	ID              string    `json:"id"`
	ProjectID       string    `json:"project_id"`
	ModuleSerial    string    `json:"module_serial,omitempty"`
	StringID        string    `json:"string_id,omitempty"`
	MeasuredAt      time.Time `json:"measured_at"`
	IrradianceWm2   float64   `json:"irradiance_wm2"`
	CellTempC       float64   `json:"cell_temp_c"`
	Points          []IVPoint `json:"points"`
	// Extracted parameters
	VocMeasured     float64   `json:"voc_measured"`
	IscMeasured     float64   `json:"isc_measured"`
	VmpMeasured     float64   `json:"vmp_measured"`
	ImpMeasured     float64   `json:"imp_measured"`
	PmaxMeasured    float64   `json:"pmax_measured"`
	FillFactor      float64   `json:"fill_factor"`
	// STC-translated values
	VocSTC          float64   `json:"voc_stc"`
	IscSTC          float64   `json:"isc_stc"`
	PmaxSTC         float64   `json:"pmax_stc"`
	// Comparison to datasheet
	PmaxRatio       float64   `json:"pmax_ratio"`  // measured/datasheet
	PassFail        string    `json:"pass_fail"`    // "pass" if ratio ≥ 0.97
}

// ExtractIVParams computes Voc, Isc, Vmp, Imp, Pmax, FF from the measured points.
func (t *IVCurveTrace) ExtractIVParams() {
	if len(t.Points) < 3 {
		return
	}
	t.VocMeasured = 0
	t.IscMeasured = 0
	t.PmaxMeasured = 0

	for _, p := range t.Points {
		power := p.VoltageV * p.CurrentA
		if power > t.PmaxMeasured {
			t.PmaxMeasured = power
			t.VmpMeasured = p.VoltageV
			t.ImpMeasured = p.CurrentA
		}
		if p.CurrentA < 0.01 && p.VoltageV > t.VocMeasured {
			t.VocMeasured = p.VoltageV
		}
		if p.VoltageV < 0.01 && p.CurrentA > t.IscMeasured {
			t.IscMeasured = p.CurrentA
		}
	}

	// If Voc/Isc not found at exact zero, use endpoints
	if t.VocMeasured == 0 && len(t.Points) > 0 {
		t.VocMeasured = t.Points[len(t.Points)-1].VoltageV
	}
	if t.IscMeasured == 0 && len(t.Points) > 0 {
		t.IscMeasured = t.Points[0].CurrentA
	}

	if t.VocMeasured > 0 && t.IscMeasured > 0 {
		t.FillFactor = t.PmaxMeasured / (t.VocMeasured * t.IscMeasured)
	}
}

// TranslateToSTC translates measured IV parameters to STC conditions using
// IEC 60891 procedure 1 (simplified linear translation).
//
// tempCoeffVocPctPerC: β (%/°C) — typically negative.
// tempCoeffIscPctPerC: α (%/°C) — typically small positive.
func (t *IVCurveTrace) TranslateToSTC(tempCoeffVocPctPerC, tempCoeffIscPctPerC float64) {
	stcIrr := 1000.0
	stcTemp := 25.0

	irrRatio := stcIrr / math.Max(t.IrradianceWm2, 1.0)
	dT := stcTemp - t.CellTempC

	t.IscSTC = t.IscMeasured * irrRatio * (1.0 + tempCoeffIscPctPerC/100.0*dT)
	t.VocSTC = t.VocMeasured * (1.0 + tempCoeffVocPctPerC/100.0*dT)
	t.PmaxSTC = t.PmaxMeasured * irrRatio * (1.0 + (tempCoeffVocPctPerC+tempCoeffIscPctPerC)/100.0*dT)
}

// EvaluateAgainstDatasheet checks if the STC-translated Pmax meets the
// datasheet specification within tolerance.
func (t *IVCurveTrace) EvaluateAgainstDatasheet(datasheetPmaxW, tolerancePct float64) {
	if datasheetPmaxW > 0 {
		t.PmaxRatio = t.PmaxSTC / datasheetPmaxW
	}
	threshold := 1.0 - tolerancePct/100.0
	if t.PmaxRatio >= threshold {
		t.PassFail = "pass"
	} else {
		t.PassFail = "fail"
	}
}

// ParseDaystarCSV parses IV-curve data from Daystar DS-100C / DS-200 CSV format.
// Format: header row + V,I data pairs.
func ParseDaystarCSV(r io.Reader) ([]IVPoint, error) {
	scanner := bufio.NewScanner(r)
	var points []IVPoint
	headerSkipped := false

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		if !headerSkipped {
			if strings.Contains(strings.ToLower(line), "voltage") || strings.Contains(line, "V,") {
				headerSkipped = true
				continue
			}
			// If first line is numeric, no header
		}
		parts := strings.Split(line, ",")
		if len(parts) < 2 {
			continue
		}
		v, errV := strconv.ParseFloat(strings.TrimSpace(parts[0]), 64)
		i, errI := strconv.ParseFloat(strings.TrimSpace(parts[1]), 64)
		if errV != nil || errI != nil {
			if !headerSkipped {
				headerSkipped = true
				continue
			}
			continue
		}
		headerSkipped = true
		points = append(points, IVPoint{VoltageV: v, CurrentA: i})
	}
	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("daystar: read: %w", err)
	}
	if len(points) == 0 {
		return nil, fmt.Errorf("daystar: no IV data points found")
	}
	return points, nil
}

// ParseSolmetricCSV parses IV-curve data from Solmetric PVA-1500 CSV exports.
// Solmetric files have metadata lines followed by "BEGIN IV DATA" marker.
func ParseSolmetricCSV(r io.Reader) ([]IVPoint, error) {
	scanner := bufio.NewScanner(r)
	inData := false
	var points []IVPoint

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.Contains(strings.ToUpper(line), "BEGIN IV DATA") || strings.Contains(strings.ToUpper(line), "BEGIN_IV_DATA") {
			inData = true
			continue
		}
		if strings.Contains(strings.ToUpper(line), "END IV DATA") || strings.Contains(strings.ToUpper(line), "END_IV_DATA") {
			break
		}
		if !inData {
			continue
		}
		if line == "" {
			continue
		}
		parts := strings.Split(line, ",")
		if len(parts) < 2 {
			parts = strings.Fields(line) // try whitespace-separated
		}
		if len(parts) < 2 {
			continue
		}
		v, errV := strconv.ParseFloat(strings.TrimSpace(parts[0]), 64)
		i, errI := strconv.ParseFloat(strings.TrimSpace(parts[1]), 64)
		if errV != nil || errI != nil {
			continue
		}
		points = append(points, IVPoint{VoltageV: v, CurrentA: i})
	}
	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("solmetric: read: %w", err)
	}
	if len(points) == 0 {
		return nil, fmt.Errorf("solmetric: no IV data points found")
	}
	return points, nil
}
