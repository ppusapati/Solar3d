package pvsyst

import (
	"strings"
	"testing"

	"p9e.in/samavaya/solar3d/asset-service/internal/domain"
)

// Sungrow SG250HX — real 250 kW utility string inverter. Representative of
// the OND shape for modern transformerless 3-phase units with 12 MPPTs.
// Efficiencies are expressed as percentages (PVsyst convention) so the
// normalisation to fractions is exercised.
const sungrowSG250HXOND = `PVObject_=pvGInverter
  Version=7.4.2
  PVObject_Commercial=pvCommercial
    Comment=12-MPPT utility string inverter, 1500 V DC, IP66
    Manufacturer=Sungrow
    Model=SG250HX
    DataSource=Manufacturer 2024
  End of PVObject pvCommercial
  PNomDC=275000
  IMaxDC=600
  VMppMin=500
  VMppMax=1500
  VAbsMax=1500
  VStart=540
  NbMPPT=12
  MaxStringsPerMPPT=2
  PNomConv=250.0
  PMaxOUT=275.0
  INomAC=300
  VNomAC=800
  NbPhase=3
  Freq=50
  EffMax=99.0
  EffEuro=98.5
  EffCEC=98.8
  PNight=1.5
  TPMin=-30
  TPMax=60
  ModeOper=Without transformer
  GridType=grid-tied
End of PVObject pvGInverter
`

func TestParseOND_SungrowSG250HX(t *testing.T) {
	inv, err := ParseOND(strings.NewReader(sungrowSG250HXOND))
	if err != nil {
		t.Fatalf("ParseOND: %v", err)
	}

	if inv.Manufacturer != "Sungrow" || inv.Model != "SG250HX" {
		t.Errorf("Commercial block: %+v", inv)
	}
	if inv.MaxDCInputW != 275000 {
		t.Errorf("MaxDCInputW: got %v, want 275000", inv.MaxDCInputW)
	}
	if inv.MaxDCInputCurrentA != 600 || inv.MPPTMinV != 500 || inv.MPPTMaxV != 1500 {
		t.Errorf("DC side: %+v", inv)
	}
	if inv.NbMPPT != 12 || inv.MaxStringsPerMPPT != 2 {
		t.Errorf("MPPT count/strings: %+v", inv)
	}
	if inv.StartupVoltageV != 540 {
		t.Errorf("StartupVoltage: got %v", inv.StartupVoltageV)
	}

	// AC: PNomConv=250 kW → 250000 W; PMaxOUT=275 kW → 275000 W
	if inv.RatedACOutputW != 250000 {
		t.Errorf("RatedACOutputW: got %v, want 250000", inv.RatedACOutputW)
	}
	if inv.MaxACOutputW != 275000 {
		t.Errorf("MaxACOutputW: got %v, want 275000", inv.MaxACOutputW)
	}
	if inv.ACPhaseCount != 3 || inv.ACFrequencyHz != 50 || inv.NominalACVoltageV != 800 {
		t.Errorf("AC side: %+v", inv)
	}

	// Efficiencies: 99.0 → 0.99
	if !floatEqual(inv.MaxEfficiency, 0.99, 1e-6) {
		t.Errorf("MaxEfficiency: got %v", inv.MaxEfficiency)
	}
	if !floatEqual(inv.EuroEfficiency, 0.985, 1e-6) {
		t.Errorf("EuroEfficiency: got %v", inv.EuroEfficiency)
	}
	if !floatEqual(inv.CECEfficiency, 0.988, 1e-6) {
		t.Errorf("CECEfficiency: got %v", inv.CECEfficiency)
	}

	if inv.NightConsumptionW != 1.5 || inv.OperatingTempMinC != -30 || inv.OperatingTempMaxC != 60 {
		t.Errorf("Environmental: %+v", inv)
	}
	if inv.Topology != domain.InverterTopologyTransformerless {
		t.Errorf("Topology: got %q", inv.Topology)
	}
	if inv.GridType != domain.InverterGridTypeGridTied {
		t.Errorf("GridType: got %q", inv.GridType)
	}
}

func TestParseOND_ToDomain(t *testing.T) {
	inv, err := ParseOND(strings.NewReader(sungrowSG250HXOND))
	if err != nil {
		t.Fatalf("ParseOND: %v", err)
	}
	asset := inv.ToDomain()

	if asset.Name != "Sungrow SG250HX" {
		t.Errorf("Name: got %q", asset.Name)
	}
	if asset.Manufacturer != "Sungrow" || asset.Model != "SG250HX" {
		t.Errorf("Manufacturer/Model: %+v", asset)
	}
	// kW conversions
	if asset.ElectricalParams.MaxDCInputKW != 275 {
		t.Errorf("MaxDCInputKW: got %v", asset.ElectricalParams.MaxDCInputKW)
	}
	if asset.ElectricalParams.RatedACOutputKW != 250 {
		t.Errorf("RatedACOutputKW: got %v", asset.ElectricalParams.RatedACOutputKW)
	}
	if asset.ElectricalParams.MaxACOutputKW != 275 {
		t.Errorf("MaxACOutputKW: got %v", asset.ElectricalParams.MaxACOutputKW)
	}
	if asset.ElectricalParams.MPPTCount != 12 {
		t.Errorf("MPPTCount: got %v", asset.ElectricalParams.MPPTCount)
	}
	if !floatEqual(asset.ElectricalParams.EuroEfficiency, 0.985, 1e-6) {
		t.Errorf("EuroEfficiency: got %v", asset.ElectricalParams.EuroEfficiency)
	}
}

func TestParseOND_MonoTriInfersPhaseCount(t *testing.T) {
	input := `PVObject_=pvGInverter
  PVObject_Commercial=pvCommercial
    Manufacturer=SMA
    Model=Sunny Boy 7.7-US
  End of PVObject pvCommercial
  PNomConv=7.7
  MonoTri=Mono
End of PVObject pvGInverter
`
	inv, err := ParseOND(strings.NewReader(input))
	if err != nil {
		t.Fatalf("ParseOND: %v", err)
	}
	if inv.ACPhaseCount != 1 {
		t.Errorf("MonoTri=Mono → phase count: got %d, want 1", inv.ACPhaseCount)
	}
}

func TestParseOND_RejectsMissingOuterObject(t *testing.T) {
	input := `PVObject_Commercial=pvCommercial
    Manufacturer=Acme
  End of PVObject pvCommercial
`
	if _, err := ParseOND(strings.NewReader(input)); err == nil {
		t.Fatal("expected error for missing outer block, got nil")
	}
}

func TestParseOND_TopologyMapping(t *testing.T) {
	cases := []struct {
		token string
		want  domain.InverterTopology
	}{
		{"Without transformer", domain.InverterTopologyTransformerless},
		{"transformerless", domain.InverterTopologyTransformerless},
		{"HF transformer", domain.InverterTopologyHFTransformer},
		{"LF transformer", domain.InverterTopologyLFTransformer},
		{"mystery", domain.InverterTopologyUnspecified},
	}
	for _, tc := range cases {
		got := mapTopology(tc.token)
		if got != tc.want {
			t.Errorf("mapTopology(%q): got %q, want %q", tc.token, got, tc.want)
		}
	}
}
