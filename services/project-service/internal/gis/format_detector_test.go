package gis

import (
	"errors"
	"testing"
)

func TestDetectFormatByNameAndContent(t *testing.T) {
	cases := []struct {
		name     string
		fileName string
		payload  []byte
		want     FileFormat
	}{
		{name: "kml", fileName: "site.kml", payload: []byte("<kml></kml>"), want: FileFormatKML},
		{name: "kmz", fileName: "site.kmz", payload: []byte{0x50, 0x4B, 0x03, 0x04}, want: FileFormatKMZ},
		{name: "dxf", fileName: "site.dxf", payload: []byte("0\nSECTION\n2\nENTITIES\n0\nENDSEC\n0\nEOF\n"), want: FileFormatDXF},
		{name: "dwg", fileName: "site.dwg", payload: []byte("AC1021"), want: FileFormatDWG},
		{name: "unknown", fileName: "site.bin", payload: []byte("abcdef"), want: FileFormatUnknown},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := DetectFormat(tc.fileName, tc.payload); got != tc.want {
				t.Fatalf("DetectFormat() = %q, want %q", got, tc.want)
			}
		})
	}
}

func TestDWGGuidanceError(t *testing.T) {
	err := DWGGuidanceError("client.dwg")
	if !errors.Is(err, ErrDWGNotSupported) {
		t.Fatalf("expected ErrDWGNotSupported, got %v", err)
	}
}

func TestDWGVersionString(t *testing.T) {
	if got := DWGVersionString([]byte("AC1021rest")); got != "AC1021" {
		t.Fatalf("DWGVersionString() = %q, want AC1021", got)
	}
	if got := DWGVersionString([]byte("abc")); got != "unknown" {
		t.Fatalf("DWGVersionString() short payload = %q, want unknown", got)
	}
}

func TestNewDWGUploadError(t *testing.T) {
	err := NewDWGUploadError("client.dwg", []byte("AC1024"))
	if err.Version != "AC1024" {
		t.Fatalf("expected version AC1024, got %q", err.Version)
	}
	if err.FileName != "client.dwg" {
		t.Fatalf("expected filename client.dwg, got %q", err.FileName)
	}
	if err.Error() == "" {
		t.Fatal("expected non-empty error string")
	}
}
