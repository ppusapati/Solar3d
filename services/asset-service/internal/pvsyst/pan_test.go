package pvsyst

import (
	"strings"
	"testing"

	"p9e.in/samavaya/solar3d/asset-service/internal/domain"
)

// Trina Vertex+ TSM-NEG19RC.20 — real datasheet values for a 605 W TOPCon
// module. Fixture is shaped like a PVsyst 7 export (indentation, nested
// commercial block, scalar keys). Temp coefficients are provided in PVsyst's
// native units (mV/°C, mA/°C) so the normalisation path is exercised.
const trinaVertexPlusPAN = `PVObject_=pvModule
  Version=7.4.2
  Flags=$00900143
  PVObject_Commercial=pvCommercial
    Comment=Bifacial TOPCon N-type module, 144 half-cells
    Manufacturer=Trina Solar
    Model=TSM-NEG19RC.20
    DataSource=Manufacturer 2024
  End of PVObject pvCommercial
  NCelS=144
  NCelP=1
  PNom=605.0
  Isc=18.35
  Voc=41.7
  Imp=17.23
  Vmp=35.1
  muPmpReq=-0.300
  muVocSpec=-105.2
  muISC=8.8
  NOCT=43
  NCellType=mtTOPCon
  Width=2384
  Height=1134
  Depth=33
  Weight=32.6
  VMaxIEC=1500
  MaxFuse=25
  TolPos=3
  BifacialityFactor=0.80
End of PVObject pvModule
`

func TestParsePAN_TrinaVertexPlus(t *testing.T) {
	mod, err := ParsePAN(strings.NewReader(trinaVertexPlusPAN))
	if err != nil {
		t.Fatalf("ParsePAN: %v", err)
	}

	if mod.Manufacturer != "Trina Solar" {
		t.Errorf("Manufacturer: got %q", mod.Manufacturer)
	}
	if mod.Model != "TSM-NEG19RC.20" {
		t.Errorf("Model: got %q", mod.Model)
	}
	if mod.PNomW != 605.0 {
		t.Errorf("PNomW: got %v", mod.PNomW)
	}
	if mod.VocV != 41.7 || mod.IscA != 18.35 || mod.VmpV != 35.1 || mod.ImpA != 17.23 {
		t.Errorf("STC params: %+v", mod)
	}
	if mod.NCellS != 144 || mod.NCellP != 1 {
		t.Errorf("Cell geometry: NCelS=%d NCelP=%d", mod.NCellS, mod.NCellP)
	}

	// muPmpReq is already %/°C: should pass through.
	if !floatEqual(mod.MuPmaxPctPerC, -0.300, 1e-6) {
		t.Errorf("MuPmaxPctPerC: got %v, want -0.300", mod.MuPmaxPctPerC)
	}
	// muVocSpec: -105.2 mV/°C at Voc=41.7 V → -105.2/1000 / 41.7 * 100 = -0.2523 %/°C
	wantMuVoc := -105.2 / 1000.0 / 41.7 * 100.0
	if !floatEqual(mod.MuVocPctPerC, wantMuVoc, 1e-6) {
		t.Errorf("MuVocPctPerC: got %v, want %v", mod.MuVocPctPerC, wantMuVoc)
	}
	// muISC: 8.8 mA/°C at Isc=18.35 A → 8.8/1000 / 18.35 * 100 = 0.04796 %/°C
	wantMuIsc := 8.8 / 1000.0 / 18.35 * 100.0
	if !floatEqual(mod.MuIscPctPerC, wantMuIsc, 1e-6) {
		t.Errorf("MuIscPctPerC: got %v, want %v", mod.MuIscPctPerC, wantMuIsc)
	}

	if mod.NOCTCelsius != 43 {
		t.Errorf("NOCT: got %v", mod.NOCTCelsius)
	}
	if mod.CellTech != domain.CellTechnologyTOPCon {
		t.Errorf("CellTech: got %q, want topcon", mod.CellTech)
	}
	if mod.WidthMM != 2384 || mod.HeightMM != 1134 || mod.WeightKG != 32.6 {
		t.Errorf("Dimensions: %+v", mod)
	}
	if mod.MaxSystemVoltageV != 1500 || mod.SeriesFuseRatingA != 25 || mod.TolerancePct != 3 {
		t.Errorf("System limits: %+v", mod)
	}
	if mod.BifacialFactor != 0.80 {
		t.Errorf("BifacialFactor: got %v", mod.BifacialFactor)
	}
}

func TestParsePAN_ToDomain_DerivesEfficiency(t *testing.T) {
	mod, err := ParsePAN(strings.NewReader(trinaVertexPlusPAN))
	if err != nil {
		t.Fatalf("ParsePAN: %v", err)
	}
	asset := mod.ToDomain()
	// Area: 2.384 m * 1.134 m = 2.703 m² → 605/2703 = 22.38% efficiency
	expected := 605.0 / (2.384 * 1.134 * 1000.0) * 100.0
	if !floatEqual(asset.ElectricalParams.EfficiencyPercent, expected, 1e-3) {
		t.Errorf("Efficiency derived: got %v, want %v",
			asset.ElectricalParams.EfficiencyPercent, expected)
	}
	if asset.Category != domain.AssetCategoryPanel {
		t.Errorf("Category: got %v", asset.Category)
	}
	if asset.Name != "Trina Solar TSM-NEG19RC.20" {
		t.Errorf("Name: got %q", asset.Name)
	}
	if asset.Dimensions.CellCount != 144 {
		t.Errorf("CellCount: got %v", asset.Dimensions.CellCount)
	}
}

func TestParsePAN_CellTechMapping(t *testing.T) {
	cases := []struct {
		token string
		want  domain.CellTechnology
	}{
		{"mtSiMono", domain.CellTechnologyMonoPERC},
		{"mtSiPoly", domain.CellTechnologyPoly},
		{"mtTOPCon", domain.CellTechnologyTOPCon},
		{"mtHJT", domain.CellTechnologyHJT},
		{"mtIBC", domain.CellTechnologyIBC},
		{"mtCIS", domain.CellTechnologyThinFilm},
		{"mystery", domain.CellTechnologyUnspecified},
	}
	for _, tc := range cases {
		got := mapCellTech(tc.token)
		if got != tc.want {
			t.Errorf("mapCellTech(%q): got %q, want %q", tc.token, got, tc.want)
		}
	}
}

func TestParsePAN_RejectsMissingOuterObject(t *testing.T) {
	// Commercial block without the outer pvModule wrapper should fail.
	input := `PVObject_Commercial=pvCommercial
    Manufacturer=Acme
  End of PVObject pvCommercial
`
	if _, err := ParsePAN(strings.NewReader(input)); err == nil {
		t.Fatal("expected error, got nil")
	}
}

func TestParsePAN_RejectsUnbalancedEnd(t *testing.T) {
	input := `PVObject_=pvModule
  PNom=400
End of PVObject pvModule
End of PVObject pvModule
`
	if _, err := ParsePAN(strings.NewReader(input)); err == nil {
		t.Fatal("expected error for extra End of PVObject, got nil")
	}
}

func TestParsePAN_TolerateCommaDecimal(t *testing.T) {
	input := `PVObject_=pvModule
  PVObject_Commercial=pvCommercial
    Manufacturer=EU Vendor
    Model=EV-500
  End of PVObject pvCommercial
  PNom=500,0
  Isc=15,25
  Voc=45,1
End of PVObject pvModule
`
	mod, err := ParsePAN(strings.NewReader(input))
	if err != nil {
		t.Fatalf("ParsePAN: %v", err)
	}
	if mod.PNomW != 500.0 || mod.IscA != 15.25 || mod.VocV != 45.1 {
		t.Errorf("Comma-decimal values not parsed: %+v", mod)
	}
}

func TestParsePAN_PreservesUnknownKeys(t *testing.T) {
	input := `PVObject_=pvModule
  PNom=400
  NewExperimentalKey=42.7
End of PVObject pvModule
`
	mod, err := ParsePAN(strings.NewReader(input))
	if err != nil {
		t.Fatalf("ParsePAN: %v", err)
	}
	if mod.UnknownKeys["NewExperimentalKey"] != "42.7" {
		t.Errorf("UnknownKeys: got %v", mod.UnknownKeys)
	}
}

func floatEqual(a, b, tol float64) bool {
	d := a - b
	if d < 0 {
		d = -d
	}
	return d <= tol
}
