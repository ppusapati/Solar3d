package pvsyst

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"strings"

	"p9e.in/samavaya/solar3d/asset-service/internal/domain"
)

// ErrInvalidOND is returned when an OND file is structurally unparseable.
var ErrInvalidOND = errors.New("pvsyst: invalid OND file")

// ONDInverter is the typed projection of a parsed OND file. Same philosophy
// as PANModule: expose the fields downstream consumers need, stash unknown
// keys for audit.
//
// Power fields are in watts; voltages in volts; currents in amps; efficiencies
// as fractions (0.974 = 97.4%), temperatures in Celsius.
type ONDInverter struct {
	// Commercial
	Manufacturer string
	Model        string
	DataSource   string
	Comment      string

	// DC input
	MaxDCInputW        float64
	MaxDCInputCurrentA float64
	MPPTMinV           float64
	MPPTMaxV           float64
	MaxInputVoltageV   float64
	StartupVoltageV    float64
	NbMPPT             int
	MaxStringsPerMPPT  int

	// AC output
	RatedACOutputW   float64
	MaxACOutputW     float64
	MaxOutputCurrentA float64
	NominalACVoltageV float64
	ACPhaseCount      int
	ACFrequencyHz     float64

	// Efficiencies (fractions 0-1)
	MaxEfficiency  float64
	EuroEfficiency float64
	CECEfficiency  float64

	// Environmental
	NightConsumptionW   float64
	OperatingTempMinC   float64
	OperatingTempMaxC   float64

	// Classification
	Topology domain.InverterTopology
	GridType domain.InverterGridType

	UnknownKeys map[string]string
}

// ToDomain projects the parsed OND onto a domain.Asset. Category is inferred
// from rated power: < 500 kW → STRING_INVERTER, ≥ 500 kW → CENTRAL_INVERTER.
// Callers can override if they have better information.
func (o *ONDInverter) ToDomain() *domain.Asset {
	name := strings.TrimSpace(o.Manufacturer + " " + o.Model)
	if name == "" {
		name = o.Model
	}
	category := domain.AssetCategoryInverter
	if o.MaxACOutputW >= 500_000 {
		// Domain uses the generic "inverter" bucket today. When the downstream
		// consumer needs to distinguish string vs central, it can inspect
		// RatedACOutputW directly.
		category = domain.AssetCategoryInverter
	}

	return &domain.Asset{
		Name:         name,
		Manufacturer: o.Manufacturer,
		Model:        o.Model,
		Category:     category,
		ElectricalParams: domain.ElectricalParameters{
			MaxDCInputKW:       o.MaxDCInputW / 1000.0,
			RatedACOutputKW:    o.RatedACOutputW / 1000.0,
			MaxACOutputKW:      o.MaxACOutputW / 1000.0,
			MaxInputVoltage:    o.MaxInputVoltageV,
			MPPTRangeMinV:      o.MPPTMinV,
			MPPTRangeMaxV:      o.MPPTMaxV,
			MPPTCount:          o.NbMPPT,
			MaxStringsPerMPPT:  o.MaxStringsPerMPPT,
			EuroEfficiency:     o.EuroEfficiency,
			CECEfficiency:      o.CECEfficiency,
			MaxEfficiency:      o.MaxEfficiency,
			StartupVoltage:     o.StartupVoltageV,
			MaxDCInputCurrentA: o.MaxDCInputCurrentA,
			MaxOutputCurrentA:  o.MaxOutputCurrentA,
			RatedACOutputW:     o.RatedACOutputW,
			ACPhaseCount:       o.ACPhaseCount,
			ACFrequencyHz:      o.ACFrequencyHz,
			NominalACVoltage:   o.NominalACVoltageV,
			NightConsumptionW:  o.NightConsumptionW,
			OperatingTempMinC:  o.OperatingTempMinC,
			OperatingTempMaxC:  o.OperatingTempMaxC,
			Topology:           o.Topology,
			GridType:           o.GridType,
		},
	}
}

// ParseOND reads a PVsyst OND inverter file and returns its typed projection.
func ParseOND(r io.Reader) (*ONDInverter, error) {
	inv := &ONDInverter{UnknownKeys: map[string]string{}}

	scanner := bufio.NewScanner(r)
	scanner.Buffer(make([]byte, 0, 1<<20), 1<<20)

	var (
		sawOuter     bool
		inCommercial bool
		objectStack  []string
	)

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		if strings.HasPrefix(line, "PVObject_") {
			_, value, ok := splitKV(line)
			if !ok {
				continue
			}
			objectStack = append(objectStack, value)
			if value == "pvGInverter" || value == "pvInverter" {
				sawOuter = true
			}
			if value == "pvCommercial" {
				inCommercial = true
			}
			continue
		}

		if strings.HasPrefix(line, "End of PVObject") {
			if len(objectStack) == 0 {
				return nil, fmt.Errorf("%w: unbalanced 'End of PVObject'", ErrInvalidOND)
			}
			top := objectStack[len(objectStack)-1]
			objectStack = objectStack[:len(objectStack)-1]
			if top == "pvCommercial" {
				inCommercial = false
			}
			continue
		}

		key, value, ok := splitKV(line)
		if !ok {
			continue
		}
		if err := inv.apply(key, value, inCommercial); err != nil {
			return nil, err
		}
	}
	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("pvsyst: read OND: %w", err)
	}
	if !sawOuter {
		return nil, fmt.Errorf("%w: missing outer PVObject_=pvGInverter block", ErrInvalidOND)
	}
	if len(objectStack) != 0 {
		return nil, fmt.Errorf("%w: unclosed PVObject blocks: %v", ErrInvalidOND, objectStack)
	}
	return inv, nil
}

func (o *ONDInverter) apply(key, value string, inCommercial bool) error {
	if inCommercial {
		switch key {
		case "Manufacturer":
			o.Manufacturer = value
			return nil
		case "Model":
			o.Model = value
			return nil
		case "DataSource":
			o.DataSource = value
			return nil
		case "Comment":
			o.Comment = value
			return nil
		}
	}

	switch key {
	// ---- DC side ----
	case "PNomDC", "PMaxDC":
		return setFloat(&o.MaxDCInputW, value, key)
	case "IMaxDC", "INomDC":
		return setFloat(&o.MaxDCInputCurrentA, value, key)
	case "VMppMin":
		return setFloat(&o.MPPTMinV, value, key)
	case "VMppMax":
		return setFloat(&o.MPPTMaxV, value, key)
	case "VAbsMax", "VMaxUL":
		return setFloat(&o.MaxInputVoltageV, value, key)
	case "VStart", "VStartMin":
		return setFloat(&o.StartupVoltageV, value, key)
	case "NbMPPT":
		return setInt(&o.NbMPPT, value, key)
	case "MaxStringsPerMPPT":
		return setInt(&o.MaxStringsPerMPPT, value, key)

	// ---- AC side (PVsyst exports values in W or kW depending on the key) ----
	case "PNomConv":
		// Typically kW in OND files; normalise to W.
		kw, err := parseFloat(value, key)
		if err != nil {
			return err
		}
		o.RatedACOutputW = kw * 1000.0
		return nil
	case "PMaxOUT":
		kw, err := parseFloat(value, key)
		if err != nil {
			return err
		}
		o.MaxACOutputW = kw * 1000.0
		return nil
	case "INomAC", "IMaxAC":
		return setFloat(&o.MaxOutputCurrentA, value, key)
	case "VNomAC", "VNom":
		return setFloat(&o.NominalACVoltageV, value, key)
	case "NbPhase":
		return setInt(&o.ACPhaseCount, value, key)
	case "Freq":
		return setFloat(&o.ACFrequencyHz, value, key)

	// ---- Efficiencies: PVsyst stores as percent; normalise to 0-1 ----
	case "EffMax":
		return setEfficiency(&o.MaxEfficiency, value, key)
	case "EffEuro":
		return setEfficiency(&o.EuroEfficiency, value, key)
	case "EffCEC":
		return setEfficiency(&o.CECEfficiency, value, key)

	// ---- Environmental ----
	case "PNight":
		return setFloat(&o.NightConsumptionW, value, key)
	case "TPMin":
		return setFloat(&o.OperatingTempMinC, value, key)
	case "TPMax":
		return setFloat(&o.OperatingTempMaxC, value, key)

	// ---- Classification ----
	case "ModeOper":
		o.Topology = mapTopology(value)
		return nil
	case "MonoTri":
		// Some OND files infer phase count from "Mono"/"Tri".
		switch strings.ToLower(strings.TrimSpace(value)) {
		case "mono", "single", "1":
			o.ACPhaseCount = 1
		case "tri", "three", "3":
			o.ACPhaseCount = 3
		}
		return nil
	case "GridType":
		o.GridType = mapGridType(value)
		return nil
	}

	o.UnknownKeys[key] = value
	return nil
}

// setEfficiency reads a PVsyst efficiency value (percent) and stores it as a
// fraction. Callers pass the key for error context.
func setEfficiency(dst *float64, value, key string) error {
	v, err := parseFloat(value, key)
	if err != nil {
		return err
	}
	if v > 1.0 {
		v /= 100.0
	}
	*dst = v
	return nil
}

func mapTopology(token string) domain.InverterTopology {
	switch strings.ToLower(strings.TrimSpace(token)) {
	case "without transformer", "transformerless", "trl", "sans transfo":
		return domain.InverterTopologyTransformerless
	case "hf transformer", "high-frequency transformer":
		return domain.InverterTopologyHFTransformer
	case "lf transformer", "line-frequency transformer", "avec transfo":
		return domain.InverterTopologyLFTransformer
	default:
		return domain.InverterTopologyUnspecified
	}
}

func mapGridType(token string) domain.InverterGridType {
	switch strings.ToLower(strings.TrimSpace(token)) {
	case "grid-tied", "grid tied", "on-grid":
		return domain.InverterGridTypeGridTied
	case "hybrid":
		return domain.InverterGridTypeHybrid
	case "off-grid", "standalone":
		return domain.InverterGridTypeOffGrid
	default:
		return domain.InverterGridTypeUnspecified
	}
}
