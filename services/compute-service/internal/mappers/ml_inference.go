package mappers

import (
	"p9e.in/samavaya/solar3d/compute-service/internal/models"

	ml_inferencev1 "p9e.in/samavaya/solar3d/gen/ml_inference/v1"
)

// ProtoToFeatureExtraction converts protobuf FeatureExtractionRequest to domain model
func ProtoToFeatureExtraction(protoReq *ml_inferencev1.FeatureExtractionRequest) *models.ExtractFeaturesRequest {
	if protoReq == nil {
		return nil
	}
	if protoReq.Weather == nil || protoReq.Solar == nil || protoReq.Time == nil {
		return nil
	}

	return &models.ExtractFeaturesRequest{
		Weather: models.WeatherFeaturesModel{
			TemperatureCelsius: protoReq.Weather.TemperatureC,
			IrradianceWM2:      protoReq.Weather.IrradianceWM2,
			HumidityPercent:    protoReq.Weather.HumidityPercent,
			PressureMb:         protoReq.Weather.PressureMb,
			WindSpeedMS:        protoReq.Weather.WindSpeedMS,
		},
		Solar: models.SolarFeaturesModel{
			SolarAltitudeDeg: protoReq.Solar.SolarAltitudeDeg,
			SolarAzimuthDeg:  protoReq.Solar.SolarAzimuthDeg,
			AirMass:          protoReq.Solar.AirMass,
			ClearnessIndex:   protoReq.Solar.ClearnessIndex,
		},
		Time: models.TimeFeaturesModel{
			HourOfDay: protoReq.Time.HourOfDay,
			DayOfYear: protoReq.Time.DayOfYear,
			Month:     protoReq.Time.Month,
			IsWeekend: protoReq.Time.IsWeekend,
		},
	}
}

// FeatureVectorToProto converts domain feature vector to protobuf response
func FeatureVectorToProto(domainResp *models.ExtractFeaturesResponse) *ml_inferencev1.FeatureExtractionResponse {
	if domainResp == nil {
		return &ml_inferencev1.FeatureExtractionResponse{
			Features:     &ml_inferencev1.FeatureVector{},
			FeatureCount: 0,
		}
	}

	return &ml_inferencev1.FeatureExtractionResponse{
		Features: &ml_inferencev1.FeatureVector{
			Features:     domainResp.Features.Features,
			FeatureNames: domainResp.Features.FeatureNames,
		},
		FeatureCount: domainResp.Features.FeatureCount,
	}
}

func ProtoToYieldPrediction(protoReq *ml_inferencev1.YieldPredictionRequest) *models.YieldPredictionRequest {
	if protoReq == nil {
		return nil
	}

	features := make([]float64, 0)
	if protoReq.Features != nil {
		features = append(features, protoReq.Features.Features...)
	}

	return &models.YieldPredictionRequest{
		Features:            features,
		ModelOutput:         protoReq.ModelOutput,
		UncertaintyEstimate: protoReq.UncertaintyEstimate,
	}
}

func YieldPredictionToProto(domainResp *models.YieldPredictionResponse) *ml_inferencev1.YieldPredictionResponse {
	if domainResp == nil {
		return &ml_inferencev1.YieldPredictionResponse{}
	}

	ensemble := make([]*ml_inferencev1.YieldForecast, 0, len(domainResp.EnsembleForecasts))
	for _, fc := range domainResp.EnsembleForecasts {
		ensemble = append(ensemble, yieldForecastToProto(fc))
	}

	return &ml_inferencev1.YieldPredictionResponse{
		Forecast:          yieldForecastToProto(domainResp.Forecast),
		EnsembleForecasts: ensemble,
	}
}

func ProtoToAnomalyDetection(protoReq *ml_inferencev1.AnomalyDetectionRequest) *models.AnomalyDetectionRequest {
	if protoReq == nil {
		return nil
	}

	return &models.AnomalyDetectionRequest{
		ExpectedYield:   protoReq.ExpectedYield,
		ActualYield:     protoReq.ActualYield,
		ModelPrediction: protoReq.ModelPrediction,
		SensorVariance:  protoReq.SensorVariance,
	}
}

func AnomalyDetectionToProto(domainResp *models.AnomalyDetectionResponse) *ml_inferencev1.AnomalyDetectionResponse {
	if domainResp == nil {
		return &ml_inferencev1.AnomalyDetectionResponse{}
	}

	return &ml_inferencev1.AnomalyDetectionResponse{
		Score: &ml_inferencev1.AnomalyScore{
			Score:       domainResp.Score.Score,
			AnomalyType: toProtoAnomalyType(domainResp.Score.AnomalyType),
			Confidence:  domainResp.Score.Confidence,
		},
		IsAnomalous:    domainResp.IsAnomalous,
		Recommendation: domainResp.Recommendation,
	}
}

func ProtoToDegradation(protoReq *ml_inferencev1.DegradationRequest) *models.DegradationRequest {
	if protoReq == nil {
		return nil
	}

	return &models.DegradationRequest{
		CurrentDegradation: protoReq.CurrentDegradation,
		AnnualRate:         protoReq.AnnualRate,
		Years:              protoReq.Years,
		EndOfLifeThreshold: 80.0,
	}
}

func DegradationToProto(domainResp *models.DegradationResponse) *ml_inferencev1.DegradationResponse {
	if domainResp == nil {
		return &ml_inferencev1.DegradationResponse{}
	}

	return &ml_inferencev1.DegradationResponse{
		Forecast: &ml_inferencev1.DegradationForecast{
			CurrentDegradationPercent: domainResp.Forecast.CurrentDegradationPercent,
			AnnualDegradationRate:     domainResp.Forecast.AnnualDegradationRate,
			ProjectedDegradation_5Yr:  domainResp.Forecast.ProjectedDegradation5Yr,
			ProjectedDegradation_10Yr: domainResp.Forecast.ProjectedDegradation10Yr,
			ConfidenceInterval:        domainResp.Forecast.ConfidenceInterval,
		},
		RemainingUsefulLifeYears: domainResp.RemainingUsefulLifeYears,
	}
}

func yieldForecastToProto(fc models.YieldForecastModel) *ml_inferencev1.YieldForecast {
	return &ml_inferencev1.YieldForecast{
		PredictedYieldKwh: fc.PredictedYieldKwh,
		ConfidenceLower:   fc.ConfidenceLower,
		ConfidenceUpper:   fc.ConfidenceUpper,
		ExpectedValue:     fc.ExpectedValue,
		Variance:          fc.Variance,
	}
}

func toProtoAnomalyType(value string) ml_inferencev1.AnomalyType {
	switch value {
	case "SENSOR_FAULT":
		return ml_inferencev1.AnomalyType_SENSOR_FAULT
	case "PERFORMANCE_DEGRADATION":
		return ml_inferencev1.AnomalyType_PERFORMANCE_DEGRADATION
	case "INVERTER_ISSUE":
		return ml_inferencev1.AnomalyType_INVERTER_ISSUE
	case "STRING_MALFUNCTION":
		return ml_inferencev1.AnomalyType_STRING_MALFUNCTION
	case "WEATHER_EVENT":
		return ml_inferencev1.AnomalyType_WEATHER_EVENT
	default:
		return ml_inferencev1.AnomalyType_NORMAL
	}
}

