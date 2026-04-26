package export

import (
	"encoding/csv"
	"fmt"
	"io"
	"time"
)

// ========================================================================
// IEC 61724 Performance Data Export
// ========================================================================
// IEC 61724-1:2017 defines the standard reporting format for PV system
// performance monitoring data. This exporter produces the standard CSV
// format for data exchange between monitoring platforms.

// IEC61724Record is one measurement interval (typically 15-min or hourly).
type IEC61724Record struct {
	Timestamp          time.Time `json:"timestamp"`
	IntervalMinutes    int       `json:"interval_minutes"`    // 15 or 60
	GHIWm2             float64   `json:"ghi_wm2"`             // plane-of-array or horizontal
	POAWm2             float64   `json:"poa_wm2"`             // plane-of-array irradiance
	AmbientTempC       float64   `json:"ambient_temp_c"`
	ModuleTempC        float64   `json:"module_temp_c"`
	WindSpeedMS        float64   `json:"wind_speed_ms"`
	DCPowerKW          float64   `json:"dc_power_kw"`
	ACPowerKW          float64   `json:"ac_power_kw"`
	ACEnergyKWh        float64   `json:"ac_energy_kwh"`
	GridExportKWh      float64   `json:"grid_export_kwh"`
	Availability       float64   `json:"availability"`        // 0-1
	PR                 float64   `json:"pr"`                  // performance ratio 0-1
}

// IEC61724Summary holds the aggregated reporting period data.
type IEC61724Summary struct {
	ProjectName        string    `json:"project_name"`
	SystemCapacityKWp  float64   `json:"system_capacity_kwp"`
	ReportingPeriod    string    `json:"reporting_period"`     // "2025-Q1", "2025-01", etc.
	StartDate          time.Time `json:"start_date"`
	EndDate            time.Time `json:"end_date"`
	TotalPOAKWhM2      float64   `json:"total_poa_kwh_m2"`
	TotalACEnergyMWh   float64   `json:"total_ac_energy_mwh"`
	AvgPR              float64   `json:"avg_pr"`
	AvgAvailability    float64   `json:"avg_availability"`
	SpecificYieldKWhKWp float64  `json:"specific_yield_kwh_kwp"`
	CapacityFactor     float64   `json:"capacity_factor"`
}

// WriteIEC61724CSV exports performance data in IEC 61724 standard CSV format.
func WriteIEC61724CSV(w io.Writer, summary *IEC61724Summary, records []IEC61724Record) error {
	cw := csv.NewWriter(w)
	defer cw.Flush()

	// Metadata header
	if err := cw.Write([]string{"# IEC 61724-1:2017 Performance Data Export"}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Project", summary.ProjectName}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# System Capacity (kWp)", fmt.Sprintf("%.1f", summary.SystemCapacityKWp)}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Reporting Period", summary.ReportingPeriod}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Start Date", summary.StartDate.Format("2006-01-02")}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# End Date", summary.EndDate.Format("2006-01-02")}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Total AC Energy (MWh)", fmt.Sprintf("%.2f", summary.TotalACEnergyMWh)}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Average PR", fmt.Sprintf("%.3f", summary.AvgPR)}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Specific Yield (kWh/kWp)", fmt.Sprintf("%.1f", summary.SpecificYieldKWhKWp)}); err != nil {
		return err
	}
	if err := cw.Write([]string{"# Capacity Factor", fmt.Sprintf("%.3f", summary.CapacityFactor)}); err != nil {
		return err
	}

	// Column headers per IEC 61724-1 Table 1
	if err := cw.Write([]string{
		"Timestamp",
		"Interval (min)",
		"GHI (W/m²)",
		"POA Irradiance (W/m²)",
		"Ambient Temp (°C)",
		"Module Temp (°C)",
		"Wind Speed (m/s)",
		"DC Power (kW)",
		"AC Power (kW)",
		"AC Energy (kWh)",
		"Grid Export (kWh)",
		"Availability",
		"PR",
	}); err != nil {
		return err
	}

	for _, r := range records {
		if err := cw.Write([]string{
			r.Timestamp.Format("2006-01-02T15:04:05Z"),
			fmt.Sprintf("%d", r.IntervalMinutes),
			fmt.Sprintf("%.1f", r.GHIWm2),
			fmt.Sprintf("%.1f", r.POAWm2),
			fmt.Sprintf("%.1f", r.AmbientTempC),
			fmt.Sprintf("%.1f", r.ModuleTempC),
			fmt.Sprintf("%.1f", r.WindSpeedMS),
			fmt.Sprintf("%.2f", r.DCPowerKW),
			fmt.Sprintf("%.2f", r.ACPowerKW),
			fmt.Sprintf("%.3f", r.ACEnergyKWh),
			fmt.Sprintf("%.3f", r.GridExportKWh),
			fmt.Sprintf("%.3f", r.Availability),
			fmt.Sprintf("%.3f", r.PR),
		}); err != nil {
			return err
		}
	}

	return nil
}

// ComputeIEC61724Summary aggregates interval records into a reporting period summary.
func ComputeIEC61724Summary(
	projectName string,
	capacityKWp float64,
	period string,
	records []IEC61724Record,
) *IEC61724Summary {
	s := &IEC61724Summary{
		ProjectName:       projectName,
		SystemCapacityKWp: capacityKWp,
		ReportingPeriod:   period,
	}

	if len(records) == 0 {
		return s
	}

	s.StartDate = records[0].Timestamp
	s.EndDate = records[len(records)-1].Timestamp

	// Units: totalPOAWhPerM2 accumulates Wh/m² (irradiance W/m² × hours);
	//        totalACWh accumulates Wh (input is kWh, ×1000).
	var totalPOAWhPerM2, totalACWh, totalAvail, prSum float64
	prCount := 0

	for _, r := range records {
		intervalHrs := float64(r.IntervalMinutes) / 60.0
		totalPOAWhPerM2 += r.POAWm2 * intervalHrs
		totalACWh += r.ACEnergyKWh * 1000.0
		totalAvail += r.Availability
		if r.PR > 0 && r.POAWm2 > 50 { // only count PR when irradiance > 50 W/m²
			prSum += r.PR
			prCount++
		}
	}

	s.TotalPOAKWhM2 = totalPOAWhPerM2 / 1000.0
	s.TotalACEnergyMWh = totalACWh / 1_000_000.0
	if prCount > 0 {
		s.AvgPR = prSum / float64(prCount)
	}
	if len(records) > 0 {
		s.AvgAvailability = totalAvail / float64(len(records))
	}
	if capacityKWp > 0 {
		s.SpecificYieldKWhKWp = (totalACWh / 1000.0) / capacityKWp
	}

	// Capacity factor = actual energy / theoretical max
	hoursInPeriod := s.EndDate.Sub(s.StartDate).Hours()
	if hoursInPeriod > 0 && capacityKWp > 0 {
		s.CapacityFactor = (totalACWh / 1000.0) / (capacityKWp * hoursInPeriod)
	}

	return s
}
