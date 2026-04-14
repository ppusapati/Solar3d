package mappers

import (
	"time"

	"solar3d/compute-service/internal/models"

	extendedv1 "github.com/solar3d/solar3d/gen/extended/v1"
)

func ProtoToSolarTransposition(req *extendedv1.SolarTranspositionRequest) *models.SolarTranspositionRequest {
	if req == nil {
		return nil
	}
	return &models.SolarTranspositionRequest{
		GHIWM2:         req.GhiWm2,
		DHIWM2:         req.DhiWm2,
		WindSpeedMS:    req.WindSpeedMs,
		TemperatureC:   req.TemperatureC,
		SurfaceTiltDeg: req.SurfaceTiltDeg,
		SurfaceAzimuth: req.SurfaceAzimuth,
		SolarAltitude:  req.SolarAltitude,
		SolarAzimuth:   req.SolarAzimuth,
	}
}

func SolarTranspositionToProto(resp *models.SolarTranspositionResponse) *extendedv1.SolarTranspositionResponse {
	if resp == nil {
		return &extendedv1.SolarTranspositionResponse{}
	}
	return &extendedv1.SolarTranspositionResponse{
		PoaIrradiance:       resp.POAIrradiance,
		Aoi:                 resp.AOI,
		IncidenceModulation: resp.IncidenceModulation,
	}
}

func ProtoToFinancialMetrics(req *extendedv1.FinancialMetricsRequest) *models.FinancialMetricsRequest {
	if req == nil {
		return nil
	}
	return &models.FinancialMetricsRequest{
		AnnualCashflows:   append([]float64(nil), req.AnnualCashflows...),
		InitialInvestment: req.InitialInvestment,
		DiscountRate:      req.DiscountRate,
		PRBaseline:        req.PrBaseline,
		PRActual:          req.PrActual,
	}
}

func FinancialMetricsToProto(resp *models.FinancialMetricsResponse) *extendedv1.FinancialMetricsResponse {
	if resp == nil {
		return &extendedv1.FinancialMetricsResponse{}
	}
	return &extendedv1.FinancialMetricsResponse{
		NpvUsd:      resp.NPVUSD,
		IrrPercent:  resp.IRRPercent,
		PiCoeff:     resp.PICoeff,
		CropPercent: resp.CROPPercent,
	}
}

func ProtoToFinancialScenarioComparison(req *extendedv1.CompareFinancialScenariosRequest) *models.FinancialScenarioComparisonRequest {
	if req == nil {
		return nil
	}
	return &models.FinancialScenarioComparisonRequest{
		AnnualYieldKWh:        req.AnnualYieldKwh,
		AnnualOMUSD:           req.AnnualOmUsd,
		ProjectLifeYears:      int(req.ProjectLifeYears),
		BaseInitialInvestment: req.BaseInitialInvestment,
		PRBaseline:            req.PrBaseline,
		Scenarios:             protoScenariosToDomain(req.Scenarios),
	}
}

func FinancialScenarioComparisonToProto(resp *models.FinancialScenarioComparisonResponse) *extendedv1.CompareFinancialScenariosResponse {
	if resp == nil {
		return &extendedv1.CompareFinancialScenariosResponse{}
	}
	out := make([]*extendedv1.FinancialScenarioResult, 0, len(resp.Scenarios))
	for _, scenario := range resp.Scenarios {
		metrics := scenario.Metrics
		out = append(out, &extendedv1.FinancialScenarioResult{
			Name: scenario.Name,
			Metrics: &extendedv1.FinancialMetricsResponse{
				NpvUsd:      metrics.NPVUSD,
				IrrPercent:  metrics.IRRPercent,
				PiCoeff:     metrics.PICoeff,
				CropPercent: metrics.CROPPercent,
			},
			AnnualRevenueUsd:     scenario.AnnualRevenueUSD,
			NetAnnualCashflowUsd: scenario.NetAnnualCashflowUSD,
			SimplePaybackYears:   scenario.SimplePaybackYears,
			RoiPercent:           scenario.ROIPercent,
		})
	}
	return &extendedv1.CompareFinancialScenariosResponse{Scenarios: out}
}

func ProtoToClimateImpact(req *extendedv1.ClimateImpactRequest) *models.ClimateImpactRequest {
	if req == nil {
		return nil
	}
	return &models.ClimateImpactRequest{
		TempImpact:         req.TempImpact,
		SoilingImpact:      req.SoilingImpact,
		WindImpact:         req.WindImpact,
		AvailabilityImpact: req.AvailabilityImpact,
	}
}

func ClimateImpactToProto(resp *models.ClimateImpactResponse) *extendedv1.ClimateImpactResponse {
	if resp == nil {
		return &extendedv1.ClimateImpactResponse{}
	}
	return &extendedv1.ClimateImpactResponse{
		SoilingFactorChange:       resp.SoilingFactorChange,
		EfficiencyFactorChange:    resp.EfficiencyFactorChange,
		ModuleTemperatureIncrease: resp.ModuleTemperatureIncrease,
		AvailabilityImpactPercent: resp.AvailabilityImpactPercent,
	}
}

func ProtoToSaveFinancialScenarioSet(req *extendedv1.SaveFinancialScenarioSetRequest) *models.SaveFinancialScenarioSetRequest {
	if req == nil {
		return nil
	}
	return &models.SaveFinancialScenarioSetRequest{
		ProjectID: req.ProjectId,
		LayoutID:  req.LayoutId,
		Scenarios: protoScenariosToDomain(req.Scenarios),
	}
}

func ProtoToGetFinancialScenarioSet(req *extendedv1.GetFinancialScenarioSetRequest) *models.GetFinancialScenarioSetRequest {
	if req == nil {
		return nil
	}
	return &models.GetFinancialScenarioSetRequest{
		ProjectID: req.ProjectId,
		LayoutID:  req.LayoutId,
	}
}

func FinancialScenarioSetToSaveProto(resp *models.FinancialScenarioSet) *extendedv1.SaveFinancialScenarioSetResponse {
	if resp == nil {
		return &extendedv1.SaveFinancialScenarioSetResponse{}
	}
	return &extendedv1.SaveFinancialScenarioSetResponse{
		ProjectId:        resp.ProjectID,
		LayoutId:         resp.LayoutID,
		Scenarios:        domainScenariosToProto(resp.Scenarios),
		UpdatedAtRfc3339: resp.UpdatedAt.UTC().Format(time.RFC3339),
	}
}

func FinancialScenarioSetToGetProto(resp *models.FinancialScenarioSet) *extendedv1.GetFinancialScenarioSetResponse {
	if resp == nil {
		return &extendedv1.GetFinancialScenarioSetResponse{}
	}
	return &extendedv1.GetFinancialScenarioSetResponse{
		ProjectId:        resp.ProjectID,
		LayoutId:         resp.LayoutID,
		Scenarios:        domainScenariosToProto(resp.Scenarios),
		UpdatedAtRfc3339: resp.UpdatedAt.UTC().Format(time.RFC3339),
	}
}

func protoScenariosToDomain(scenarios []*extendedv1.FinancialScenario) []models.FinancialScenario {
	out := make([]models.FinancialScenario, 0, len(scenarios))
	for _, scenario := range scenarios {
		if scenario == nil {
			continue
		}
		out = append(out, models.FinancialScenario{
			Name:                  scenario.Name,
			ElectricityPrice:      scenario.ElectricityPrice,
			EscalationRatePercent: scenario.EscalationRatePercent,
			DegradationRate:       scenario.DegradationRatePercent,
			DiscountRatePercent:   scenario.DiscountRatePercent,
			PRActual:              scenario.PrActual,
			CapexMultiplier:       scenario.CapexMultiplier,
		})
	}
	return out
}

func domainScenariosToProto(scenarios []models.FinancialScenario) []*extendedv1.FinancialScenario {
	out := make([]*extendedv1.FinancialScenario, 0, len(scenarios))
	for _, scenario := range scenarios {
		out = append(out, &extendedv1.FinancialScenario{
			Name:                   scenario.Name,
			ElectricityPrice:       scenario.ElectricityPrice,
			EscalationRatePercent:  scenario.EscalationRatePercent,
			DegradationRatePercent: scenario.DegradationRate,
			DiscountRatePercent:    scenario.DiscountRatePercent,
			PrActual:               scenario.PRActual,
			CapexMultiplier:        scenario.CapexMultiplier,
		})
	}
	return out
}

func ProtoToListFinancialScenarioSets(req *extendedv1.ListFinancialScenarioSetsRequest) *models.ListFinancialScenarioSetsRequest {
	if req == nil {
		return nil
	}
	return &models.ListFinancialScenarioSetsRequest{ProjectID: req.ProjectId}
}

func ListFinancialScenarioSetsToProto(summaries []models.FinancialScenarioSetSummary) *extendedv1.ListFinancialScenarioSetsResponse {
	items := make([]*extendedv1.FinancialScenarioSetSummary, 0, len(summaries))
	for _, s := range summaries {
		items = append(items, &extendedv1.FinancialScenarioSetSummary{
			LayoutId:         s.LayoutID,
			ScenarioCount:    int32(s.ScenarioCount),
			UpdatedAtRfc3339: s.UpdatedAt.UTC().Format(time.RFC3339),
		})
	}
	return &extendedv1.ListFinancialScenarioSetsResponse{Items: items}
}

func ProtoToGetFinancialScenarioSetVersions(req *extendedv1.GetFinancialScenarioSetVersionsRequest) *models.GetFinancialScenarioSetVersionsRequest {
	if req == nil {
		return nil
	}
	return &models.GetFinancialScenarioSetVersionsRequest{
		ProjectID: req.ProjectId,
		LayoutID:  req.LayoutId,
	}
}

func GetFinancialScenarioSetVersionsToProto(versions []models.FinancialScenarioSetVersion) *extendedv1.GetFinancialScenarioSetVersionsResponse {
	out := make([]*extendedv1.FinancialScenarioSetVersion, 0, len(versions))
	for _, v := range versions {
		out = append(out, &extendedv1.FinancialScenarioSetVersion{
			Scenarios:      domainScenariosToProto(v.Scenarios),
			SavedAtRfc3339: v.SavedAt.UTC().Format(time.RFC3339),
		})
	}
	return &extendedv1.GetFinancialScenarioSetVersionsResponse{Versions: out}
}

func ProtoToInterRowShading(req *extendedv1.CalculateInterRowShadingRequest) *models.InterRowShadingRequest {
	if req == nil {
		return nil
	}
	return &models.InterRowShadingRequest{
		TiltDeg:      req.TiltDeg,
		GCR:          req.Gcr,
		LatitudeDeg:  req.LatitudeDeg,
		AnalysisDays: int(req.AnalysisDays),
		IsTracker:    req.IsTracker,
	}
}

func InterRowShadingToProto(resp *models.InterRowShadingResponse) *extendedv1.CalculateInterRowShadingResponse {
	if resp == nil {
		return &extendedv1.CalculateInterRowShadingResponse{}
	}
	return &extendedv1.CalculateInterRowShadingResponse{
		AnnualShadingLossPercent: resp.AnnualShadingLossPercent,
		NearShadingLossPercent:   resp.NearShadingLossPercent,
		OptimalGcr:               resp.OptimalGCR,
		Note:                     resp.Note,
	}
}

func ProtoToYieldUncertainty(req *extendedv1.CalculateYieldUncertaintyRequest) *models.YieldUncertaintyRequest {
	if req == nil {
		return nil
	}
	return &models.YieldUncertaintyRequest{
		P50AnnualKWh:              req.P50AnnualKwh,
		InterannualVariabilityPct: req.InterannualVariabilityPct,
		MeasurementUncertaintyPct: req.MeasurementUncertaintyPct,
		ModelUncertaintyPct:       req.ModelUncertaintyPct,
		SoilingUncertaintyPct:     req.SoilingUncertaintyPct,
		DegradationUncertaintyPct: req.DegradationUncertaintyPct,
	}
}

func YieldUncertaintyToProto(resp *models.YieldUncertaintyResponse) *extendedv1.CalculateYieldUncertaintyResponse {
	if resp == nil {
		return &extendedv1.CalculateYieldUncertaintyResponse{}
	}
	return &extendedv1.CalculateYieldUncertaintyResponse{
		P50Kwh:                 resp.P50KWh,
		P90Kwh:                 resp.P90KWh,
		P99Kwh:                 resp.P99KWh,
		CombinedUncertaintyPct: resp.CombinedUncertaintyPct,
	}
}
