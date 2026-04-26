package tmy

import (
	"testing"
)

func TestCSVParser_BasicParse(t *testing.T) {
	data := []byte(`timestamp,ghi,dni,dhi,temperature,wind_speed,humidity
2024-01-01 00:00,0,0,0,-2.5,3.1,85
2024-01-01 01:00,0,0,0,-2.8,2.9,86
2024-01-01 12:00,450,320,130,5.2,4.5,55
2024-01-01 13:00,520,380,140,6.1,4.2,50
`)
	parser := NewCSVParser()
	records, err := parser.Parse(data)
	if err != nil {
		t.Fatalf("Parse: %v", err)
	}
	if len(records) != 4 {
		t.Fatalf("got %d records, want 4", len(records))
	}
	if records[2].GHI != 450 || records[2].DNI != 320 || records[2].DHI != 130 {
		t.Errorf("record[2] irradiance: %+v", records[2])
	}
	if records[2].AmbientTempC != 5.2 {
		t.Errorf("record[2] temp: got %v", records[2].AmbientTempC)
	}
	if records[0].Timestamp.Hour() != 0 || records[2].Timestamp.Hour() != 12 {
		t.Errorf("timestamps: %v / %v", records[0].Timestamp, records[2].Timestamp)
	}
}

func TestCSVParser_AlternativeColumnNames(t *testing.T) {
	data := []byte(`datetime,g(h),gb(n),gd(h),t2m,ws10m,rh2m
2024-06-15 10:00,650,500,150,28.3,2.0,40
`)
	parser := NewCSVParser()
	records, err := parser.Parse(data)
	if err != nil {
		t.Fatalf("Parse: %v", err)
	}
	if len(records) != 1 {
		t.Fatalf("got %d records, want 1", len(records))
	}
	if records[0].GHI != 650 {
		t.Errorf("GHI: got %v", records[0].GHI)
	}
}

func TestCSVParser_RejectsNoHeader(t *testing.T) {
	data := []byte(``)
	parser := NewCSVParser()
	if _, err := parser.Parse(data); err == nil {
		t.Fatal("expected error for empty input")
	}
}

func TestCSVParser_RejectsMissingGHI(t *testing.T) {
	data := []byte(`timestamp,temperature
2024-01-01 00:00,5.0
`)
	parser := NewCSVParser()
	if _, err := parser.Parse(data); err == nil {
		t.Fatal("expected error for missing GHI column")
	}
}

func TestEPWParser_RejectsShortFile(t *testing.T) {
	// Only 5 header lines instead of 8
	data := []byte("h1\nh2\nh3\nh4\nh5\n")
	parser := NewEPWParser()
	if _, err := parser.Parse(data); err == nil {
		t.Fatal("expected error for truncated header")
	}
}
