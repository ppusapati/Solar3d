package gis

import (
	"bytes"
	"errors"
	"fmt"
	"path/filepath"
	"strings"
)

type FileFormat string

const (
	FileFormatUnknown FileFormat = "unknown"
	FileFormatKML     FileFormat = "kml"
	FileFormatKMZ     FileFormat = "kmz"
	FileFormatDXF     FileFormat = "dxf"
	FileFormatDWG     FileFormat = "dwg"
)

var ErrDWGNotSupported = errors.New("dwg is not supported yet")

type DWGUploadError struct {
	FileName        string
	Version         string
	Reason          string
	SuggestedAction string
}

func (e *DWGUploadError) Error() string {
	name := strings.TrimSpace(e.FileName)
	if name == "" {
		name = "uploaded file"
	}
	version := strings.TrimSpace(e.Version)
	if version == "" {
		version = "unknown"
	}
	reason := strings.TrimSpace(e.Reason)
	if reason == "" {
		reason = "DWG is a binary AutoCAD format and this ingestion path only accepts KML, KMZ, or ASCII DXF."
	}
	action := strings.TrimSpace(e.SuggestedAction)
	if action == "" {
		action = "Open the file in AutoCAD and export it as DXF, then upload the DXF file."
	}
	return fmt.Sprintf("%s rejected: DWG version %s detected. %s %s", name, version, reason, action)
}

func DetectFormat(sourceName string, payload []byte) FileFormat {
	trimmed := bytes.TrimSpace(payload)
	ext := strings.ToLower(filepath.Ext(sourceName))

	if ext == ".dwg" {
		return FileFormatDWG
	}
	if ext == ".kmz" {
		return FileFormatKMZ
	}
	if ext == ".kml" {
		return FileFormatKML
	}
	if ext == ".dxf" {
		return FileFormatDXF
	}

	if len(trimmed) >= 6 && string(trimmed[:6]) == "AC10" {
		return FileFormatDWG
	}

	if len(trimmed) >= 4 && trimmed[0] == 0x50 && trimmed[1] == 0x4B && trimmed[2] == 0x03 && trimmed[3] == 0x04 {
		return FileFormatKMZ
	}

	if bytes.Contains(bytes.ToLower(trimmed), []byte("<kml")) {
		return FileFormatKML
	}

	if bytes.Contains(trimmed, []byte("SECTION")) && bytes.Contains(trimmed, []byte("ENTITIES")) {
		return FileFormatDXF
	}

	return FileFormatUnknown
}

func DWGVersionString(payload []byte) string {
	trimmed := bytes.TrimSpace(payload)
	if len(trimmed) < 6 {
		return "unknown"
	}
	version := string(trimmed[:6])
	if !strings.HasPrefix(version, "AC10") {
		return "unknown"
	}
	return version
}

func DWGGuidanceError(sourceName string) error {
	return fmt.Errorf("%w: %s", ErrDWGNotSupported, (&DWGUploadError{
		FileName:        sourceName,
		Reason:          "DWG is a binary AutoCAD drawing format and is not parsed by the current pure-Go CAD ingestion pipeline.",
		SuggestedAction: "Open in AutoCAD, use Save As -> AutoCAD DXF (*.dxf), and upload the exported DXF file.",
	}).Error())
}

func NewDWGUploadError(sourceName string, payload []byte) *DWGUploadError {
	return &DWGUploadError{
		FileName:        sourceName,
		Version:         DWGVersionString(payload),
		Reason:          "DWG is a binary AutoCAD drawing format and is not parsed by the current pure-Go CAD ingestion pipeline.",
		SuggestedAction: "Open in AutoCAD, use Save As -> AutoCAD DXF (*.dxf), and upload the exported DXF file.",
	}
}
