// Package export provides format converters for exporting Solar3D project data
// to external tools: PVsyst (.PRJ), IFC (BIM), and IEC 61724 performance data.
package export

import (
	"fmt"
	"io"
	"strings"
	"time"
)

// ========================================================================
// PVsyst Project Export (.PRJ)
// ========================================================================

// PVsystProject holds the data needed to generate a PVsyst-importable .PRJ file.
type PVsystProject struct {
	ProjectName      string
	Latitude         float64
	Longitude        float64
	Altitude         float64
	TimeZone         float64 // UTC offset in hours

	// System
	ModuleName       string
	ModulePnomW      float64
	ModuleVocV       float64
	ModuleIscA       float64
	ModuleVmpV       float64
	ModuleImpA       float64
	ModulesPerString int
	StringsPerInv    int
	NumInverters     int

	InverterName     string
	InverterPnomKW   float64
	InverterVmppMinV float64
	InverterVmppMaxV float64

	// Array
	TiltDeg          float64
	AzimuthDeg       float64
	GCR              float64

	// Losses
	SoilingPct       float64
	MismatchPct      float64
	CableLossPct     float64
	AvailabilityPct  float64
}

// WritePRJ generates a PVsyst 7 compatible .PRJ text file.
// PVsyst .PRJ is a plain-text key=value format with nested sections.
func (p *PVsystProject) WritePRJ(w io.Writer) error {
	var sb strings.Builder

	sb.WriteString("PVObject_=pvProject\n")
	sb.WriteString(fmt.Sprintf("  Version=7.4\n"))
	sb.WriteString(fmt.Sprintf("  ProjectName=%s\n", p.ProjectName))
	sb.WriteString(fmt.Sprintf("  CreatedBy=Solar3D Export\n"))
	sb.WriteString(fmt.Sprintf("  CreatedDate=%s\n", time.Now().Format("2006-01-02")))

	// Site
	sb.WriteString("  PVObject_Site=pvSite\n")
	sb.WriteString(fmt.Sprintf("    Latitude=%.4f\n", p.Latitude))
	sb.WriteString(fmt.Sprintf("    Longitude=%.4f\n", p.Longitude))
	sb.WriteString(fmt.Sprintf("    Altitude=%.0f\n", p.Altitude))
	sb.WriteString(fmt.Sprintf("    TimeZone=%.1f\n", p.TimeZone))
	sb.WriteString("  End of PVObject pvSite\n")

	// System
	sb.WriteString("  PVObject_System=pvSystem\n")
	sb.WriteString(fmt.Sprintf("    NbInverters=%d\n", p.NumInverters))
	sb.WriteString(fmt.Sprintf("    NbStrings=%d\n", p.StringsPerInv))
	sb.WriteString(fmt.Sprintf("    NbModSerie=%d\n", p.ModulesPerString))

	totalModules := p.ModulesPerString * p.StringsPerInv * p.NumInverters
	totalDCkWp := float64(totalModules) * p.ModulePnomW / 1000.0
	sb.WriteString(fmt.Sprintf("    PnomDC=%.1f\n", totalDCkWp))
	sb.WriteString(fmt.Sprintf("    PnomAC=%.1f\n", float64(p.NumInverters)*p.InverterPnomKW))

	// Orientation
	sb.WriteString(fmt.Sprintf("    Tilt=%.1f\n", p.TiltDeg))
	sb.WriteString(fmt.Sprintf("    Azimuth=%.1f\n", p.AzimuthDeg))
	sb.WriteString(fmt.Sprintf("    GCR=%.3f\n", p.GCR))

	// Module reference
	sb.WriteString("    PVObject_Module=pvModule\n")
	sb.WriteString(fmt.Sprintf("      PVObject_Commercial=pvCommercial\n"))
	sb.WriteString(fmt.Sprintf("        Model=%s\n", p.ModuleName))
	sb.WriteString(fmt.Sprintf("      End of PVObject pvCommercial\n"))
	sb.WriteString(fmt.Sprintf("      PNom=%.1f\n", p.ModulePnomW))
	sb.WriteString(fmt.Sprintf("      Voc=%.2f\n", p.ModuleVocV))
	sb.WriteString(fmt.Sprintf("      Isc=%.2f\n", p.ModuleIscA))
	sb.WriteString(fmt.Sprintf("      Vmp=%.2f\n", p.ModuleVmpV))
	sb.WriteString(fmt.Sprintf("      Imp=%.2f\n", p.ModuleImpA))
	sb.WriteString("    End of PVObject pvModule\n")

	// Inverter reference
	sb.WriteString("    PVObject_Inverter=pvInverter\n")
	sb.WriteString(fmt.Sprintf("      PVObject_Commercial=pvCommercial\n"))
	sb.WriteString(fmt.Sprintf("        Model=%s\n", p.InverterName))
	sb.WriteString(fmt.Sprintf("      End of PVObject pvCommercial\n"))
	sb.WriteString(fmt.Sprintf("      PNomConv=%.1f\n", p.InverterPnomKW))
	sb.WriteString(fmt.Sprintf("      VMppMin=%.0f\n", p.InverterVmppMinV))
	sb.WriteString(fmt.Sprintf("      VMppMax=%.0f\n", p.InverterVmppMaxV))
	sb.WriteString("    End of PVObject pvInverter\n")

	// Losses
	sb.WriteString("    PVObject_Losses=pvLosses\n")
	sb.WriteString(fmt.Sprintf("      Soiling=%.1f\n", p.SoilingPct))
	sb.WriteString(fmt.Sprintf("      Mismatch=%.1f\n", p.MismatchPct))
	sb.WriteString(fmt.Sprintf("      OhmicLoss=%.1f\n", p.CableLossPct))
	sb.WriteString(fmt.Sprintf("      Availability=%.1f\n", p.AvailabilityPct))
	sb.WriteString("    End of PVObject pvLosses\n")

	sb.WriteString("  End of PVObject pvSystem\n")
	sb.WriteString("End of PVObject pvProject\n")

	_, err := io.WriteString(w, sb.String())
	return err
}
