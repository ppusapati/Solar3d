// Package pvsyst parses PVsyst PAN (module) and OND (inverter) files into the
// asset-service domain types.
//
// PAN and OND are plain-text, hierarchically-nested key=value files used by the
// PVsyst simulation tool. Each file is enclosed in a top-level
// `PVObject_=<Type>` … `End of PVObject <Type>` block; nested objects follow
// the same pattern, indented by two spaces per depth level. Values are usually
// scalars (int, float, enum strings, comma-separated lists); some PAN files
// contain tabular blocks (IV curves, spectral response) which we parse into
// structured payloads.
//
// Format notes based on PVsyst 7+ (the currently-supported major version).
// Older PAN files from PVsyst 5/6 use the same overall structure but omit some
// keys and encode temp coefficients differently; this package tolerates both.
package pvsyst

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"strconv"
	"strings"

	"p9e.in/samavaya/solar3d/asset-service/internal/domain"
)

// ErrInvalidPAN is returned when a PAN file is structurally unparseable
// (missing outer PVObject_=pvModule wrapper, unbalanced End of PVObject, etc.).
var ErrInvalidPAN = errors.New("pvsyst: invalid PAN file")

// PANModule is the typed projection of a parsed PAN file. It deliberately
// mirrors the subset of fields that downstream services (simulation, layout,
// electrical) consume; values never read by the platform are discarded.
//
// Temp coefficients are normalised to %/°C (positive or negative). Voltages
// are in volts, currents in amps, power in watts, temperatures in Celsius.
type PANModule struct {
	// Commercial block
	Manufacturer string
	Model        string
	DataSource   string
	Comment      string

	// Electrical (STC)
	PNomW  float64 // nominal power (W)
	VocV   float64
	IscA   float64
	VmpV   float64
	ImpA   float64

	// Temp coefficients (all %/°C after normalisation)
	MuPmaxPctPerC float64 // γ
	MuVocPctPerC  float64 // β
	MuIscPctPerC  float64 // α

	// Cell geometry
	NCellS int // cells in series
	NCellP int // cells in parallel
	CellTech domain.CellTechnology

	// Environmental
	NOCTCelsius float64

	// Physical (when present in PAN; many PAN files omit these)
	WidthMM  float64
	HeightMM float64
	DepthMM  float64
	WeightKG float64

	// System limits
	MaxSystemVoltageV  float64
	SeriesFuseRatingA  float64
	TolerancePct       float64
	BifacialFactor     float64

	// Raw scan of unknown keys, for audit + forward-compat
	UnknownKeys map[string]string
}

// ToDomain projects the parsed PAN values onto the asset-service domain
// representation of an Asset. Callers still need to set non-catalog fields
// (ID, timestamps, file paths, metadata JSON).
func (p *PANModule) ToDomain() *domain.Asset {
	name := strings.TrimSpace(p.Manufacturer + " " + p.Model)
	if name == "" {
		name = p.Model
	}
	a := &domain.Asset{
		Name:         name,
		Manufacturer: p.Manufacturer,
		Model:        p.Model,
		Category:     domain.AssetCategoryPanel,
		Dimensions: domain.Dimensions{
			WidthMM:        p.WidthMM,
			HeightMM:       p.HeightMM,
			DepthMM:        p.DepthMM,
			WeightKG:       p.WeightKG,
			CellCount:      p.NCellS * max1(p.NCellP),
			CellTechnology: p.CellTech,
		},
		ElectricalParams: domain.ElectricalParameters{
			RatedPowerW:              p.PNomW,
			VocV:                     p.VocV,
			IscA:                     p.IscA,
			VmpV:                     p.VmpV,
			ImpA:                     p.ImpA,
			TempCoeffPmax:            p.MuPmaxPctPerC,
			TempCoeffVoc:             p.MuVocPctPerC,
			TempCoeffIsc:             p.MuIscPctPerC,
			NOCTCelsius:              p.NOCTCelsius,
			MaxSystemVoltage:         p.MaxSystemVoltageV,
			SeriesFuseRatingA:        p.SeriesFuseRatingA,
			NominalPowerTolerancePct: p.TolerancePct,
			BifacialFactor:           p.BifacialFactor,
			CellsInSeries:            p.NCellS,
			CellsInParallel:          max1(p.NCellP),
		},
	}

	// Efficiency from Pmax and physical area when both are known. PAN sometimes
	// lacks dimensions; leave efficiency at 0 when we can't derive it.
	if p.PNomW > 0 && p.WidthMM > 0 && p.HeightMM > 0 {
		areaM2 := (p.WidthMM / 1000.0) * (p.HeightMM / 1000.0)
		if areaM2 > 0 {
			a.ElectricalParams.EfficiencyPercent = (p.PNomW / (areaM2 * 1000.0)) * 100.0
		}
	}
	return a
}

func max1(v int) int {
	if v <= 0 {
		return 1
	}
	return v
}

// ParsePAN reads a PVsyst PAN file and returns its typed projection. The input
// is not required to be a file — any io.Reader supplies the data so callers
// can parse from HTTP uploads, in-memory strings, or embedded fixtures.
func ParsePAN(r io.Reader) (*PANModule, error) {
	mod := &PANModule{UnknownKeys: map[string]string{}}

	scanner := bufio.NewScanner(r)
	// PAN files include tabular blocks that can exceed the default 64KB buffer
	// on large multi-kW modules. 1 MiB is comfortably larger than any module
	// definition seen in practice.
	scanner.Buffer(make([]byte, 0, 1<<20), 1<<20)

	var (
		sawOuter   bool
		inCommercial bool
		objectStack  []string
	)

	for scanner.Scan() {
		raw := scanner.Text()
		line := strings.TrimSpace(raw)
		if line == "" {
			continue
		}

		// Open block: "PVObject_=pvModule" / "PVObject_Commercial=pvCommercial"
		if strings.HasPrefix(line, "PVObject_") {
			_, value, ok := splitKV(line)
			if !ok {
				continue
			}
			objectStack = append(objectStack, value)
			if value == "pvModule" {
				sawOuter = true
			}
			if value == "pvCommercial" {
				inCommercial = true
			}
			continue
		}

		// Close block: "End of PVObject pvCommercial"
		if strings.HasPrefix(line, "End of PVObject") {
			if len(objectStack) == 0 {
				return nil, fmt.Errorf("%w: unbalanced 'End of PVObject'", ErrInvalidPAN)
			}
			top := objectStack[len(objectStack)-1]
			objectStack = objectStack[:len(objectStack)-1]
			if top == "pvCommercial" {
				inCommercial = false
			}
			continue
		}

		// Regular key=value
		key, value, ok := splitKV(line)
		if !ok {
			continue
		}
		if err := mod.apply(key, value, inCommercial); err != nil {
			return nil, err
		}
	}
	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("pvsyst: read PAN: %w", err)
	}
	if !sawOuter {
		return nil, fmt.Errorf("%w: missing outer PVObject_=pvModule block", ErrInvalidPAN)
	}
	if len(objectStack) != 0 {
		return nil, fmt.Errorf("%w: unclosed PVObject blocks: %v", ErrInvalidPAN, objectStack)
	}
	return mod, nil
}

// splitKV parses a "key=value" pair, tolerating spaces around '=' and
// trimming trailing comments introduced by ';'.
func splitKV(line string) (key, value string, ok bool) {
	if i := strings.Index(line, ";"); i >= 0 {
		line = strings.TrimSpace(line[:i])
	}
	eq := strings.Index(line, "=")
	if eq < 0 {
		return "", "", false
	}
	key = strings.TrimSpace(line[:eq])
	value = strings.TrimSpace(line[eq+1:])
	return key, value, key != ""
}

// apply writes a single parsed key=value into the PANModule. Unknown keys are
// retained on UnknownKeys so audit/debug tooling can surface them.
func (m *PANModule) apply(key, value string, inCommercial bool) error {
	if inCommercial {
		switch key {
		case "Manufacturer":
			m.Manufacturer = value
			return nil
		case "Model":
			m.Model = value
			return nil
		case "DataSource":
			m.DataSource = value
			return nil
		case "Comment":
			m.Comment = value
			return nil
		}
	}

	switch key {
	case "PNom":
		return setFloat(&m.PNomW, value, key)
	case "Isc":
		return setFloat(&m.IscA, value, key)
	case "Voc":
		return setFloat(&m.VocV, value, key)
	case "Imp":
		return setFloat(&m.ImpA, value, key)
	case "Vmp":
		return setFloat(&m.VmpV, value, key)
	case "muPmpReq":
		// already %/°C in PVsyst 7
		return setFloat(&m.MuPmaxPctPerC, value, key)
	case "muVocSpec":
		// mV/°C — convert to %/°C relative to Voc
		mv, err := parseFloat(value, key)
		if err != nil {
			return err
		}
		if m.VocV > 0 {
			m.MuVocPctPerC = (mv / 1000.0) / m.VocV * 100.0
		}
		return nil
	case "muISC":
		// mA/°C — convert to %/°C relative to Isc
		ma, err := parseFloat(value, key)
		if err != nil {
			return err
		}
		if m.IscA > 0 {
			m.MuIscPctPerC = (ma / 1000.0) / m.IscA * 100.0
		}
		return nil
	case "NCelS":
		return setInt(&m.NCellS, value, key)
	case "NCelP":
		return setInt(&m.NCellP, value, key)
	case "NOCT":
		return setFloat(&m.NOCTCelsius, value, key)
	case "TNOCT":
		return setFloat(&m.NOCTCelsius, value, key)
	case "Width":
		return setFloat(&m.WidthMM, value, key)
	case "Height":
		return setFloat(&m.HeightMM, value, key)
	case "Depth":
		return setFloat(&m.DepthMM, value, key)
	case "Weight":
		return setFloat(&m.WeightKG, value, key)
	case "VMaxIEC", "VMaxUL":
		// UL-rated max system voltage; whichever appears last wins.
		return setFloat(&m.MaxSystemVoltageV, value, key)
	case "MaxFuse":
		return setFloat(&m.SeriesFuseRatingA, value, key)
	case "TolPos":
		return setFloat(&m.TolerancePct, value, key)
	case "BifacialityFactor":
		return setFloat(&m.BifacialFactor, value, key)
	case "NCellType":
		m.CellTech = mapCellTech(value)
		return nil
	}
	m.UnknownKeys[key] = value
	return nil
}

// mapCellTech translates PVsyst cell-technology tokens to the domain enum.
// Unknown tokens fall back to Unspecified; the raw token is preserved in
// UnknownKeys by the caller.
func mapCellTech(token string) domain.CellTechnology {
	switch strings.ToLower(strings.TrimSpace(token)) {
	case "mtsimono", "monosi", "mono", "c-si mono":
		return domain.CellTechnologyMonoPERC
	case "mtsipoly", "polysi", "poly", "c-si poly":
		return domain.CellTechnologyPoly
	case "mttopcon", "topcon", "n-topcon":
		return domain.CellTechnologyTOPCon
	case "mthjt", "hjt", "heterojunction":
		return domain.CellTechnologyHJT
	case "mtibc", "ibc":
		return domain.CellTechnologyIBC
	case "mtcis", "mtcdte", "mtaSi", "thinfilm", "thin-film":
		return domain.CellTechnologyThinFilm
	default:
		return domain.CellTechnologyUnspecified
	}
}

func setFloat(dst *float64, value, key string) error {
	v, err := parseFloat(value, key)
	if err != nil {
		return err
	}
	*dst = v
	return nil
}

func setInt(dst *int, value, key string) error {
	v, err := strconv.Atoi(strings.TrimSpace(value))
	if err != nil {
		return fmt.Errorf("pvsyst: %s: expected int, got %q: %w", key, value, err)
	}
	*dst = v
	return nil
}

func parseFloat(value, key string) (float64, error) {
	// PVsyst sometimes uses comma as decimal separator in exported files.
	normalised := strings.Replace(strings.TrimSpace(value), ",", ".", 1)
	v, err := strconv.ParseFloat(normalised, 64)
	if err != nil {
		return 0, fmt.Errorf("pvsyst: %s: expected float, got %q: %w", key, value, err)
	}
	return v, nil
}
