package handler

import (
	"context"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/timestamppb"

	weatherv1 "p9e.in/samavaya/solar3d/gen/weather/v1"
	weatherv1connect "p9e.in/samavaya/solar3d/gen/weather/v1/weatherv1connect"
	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
	"p9e.in/samavaya/solar3d/weather-service/internal/repository"
)

// ConnectWeatherService implements weatherv1connect.WeatherServiceHandler.
type ConnectWeatherService struct {
	svc *WeatherService
}

var _ weatherv1connect.WeatherServiceHandler = (*ConnectWeatherService)(nil)

func NewConnectWeatherService(svc *WeatherService) *ConnectWeatherService {
	return &ConnectWeatherService{svc: svc}
}

func (h *ConnectWeatherService) FetchIrradiance(ctx context.Context, req *connect.Request[weatherv1.FetchIrradianceRequest]) (*connect.Response[weatherv1.FetchIrradianceResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	source := protoSourceToDomain(req.Msg.GetSource())
	sw, err := h.svc.FetchIrradiance(ctx, projectID, req.Msg.GetLatitude(), req.Msg.GetLongitude(), source, req.Msg.GetApiKey())
	if err != nil {
		return nil, weatherConnectError(err)
	}
	return connect.NewResponse(&weatherv1.FetchIrradianceResponse{
		Summary: summaryToProto(sw),
		Records: recordsToProto(sw.Records),
	}), nil
}

func (h *ConnectWeatherService) ImportTMY(ctx context.Context, req *connect.Request[weatherv1.ImportTMYRequest]) (*connect.Response[weatherv1.ImportTMYResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	source := protoSourceToDomain(req.Msg.GetFormat())
	sw, err := h.svc.ImportTMY(ctx, projectID, req.Msg.GetLatitude(), req.Msg.GetLongitude(), source, req.Msg.GetFileContent())
	if err != nil {
		return nil, weatherConnectError(err)
	}
	return connect.NewResponse(&weatherv1.ImportTMYResponse{
		Summary:         summaryToProto(sw),
		RecordsImported: int32(sw.RecordCount),
	}), nil
}

func (h *ConnectWeatherService) GetHourlyTimeseries(ctx context.Context, req *connect.Request[weatherv1.GetHourlyTimeseriesRequest]) (*connect.Response[weatherv1.GetHourlyTimeseriesResponse], error) {
	id, err := uuid.Parse(req.Msg.GetSiteWeatherId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid site_weather_id"))
	}
	sw, err := h.svc.GetHourlyTimeseries(ctx, id)
	if err != nil {
		return nil, weatherConnectError(err)
	}
	return connect.NewResponse(&weatherv1.GetHourlyTimeseriesResponse{
		Summary: summaryToProto(sw),
		Records: recordsToProto(sw.Records),
	}), nil
}

func (h *ConnectWeatherService) ListSiteWeather(ctx context.Context, req *connect.Request[weatherv1.ListSiteWeatherRequest]) (*connect.Response[weatherv1.ListSiteWeatherResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	list, err := h.svc.ListSiteWeather(ctx, projectID)
	if err != nil {
		return nil, weatherConnectError(err)
	}
	summaries := make([]*weatherv1.SiteWeatherSummary, 0, len(list))
	for _, sw := range list {
		summaries = append(summaries, summaryToProto(sw))
	}
	return connect.NewResponse(&weatherv1.ListSiteWeatherResponse{Summaries: summaries}), nil
}

func (h *ConnectWeatherService) CalculateYieldExceedance(ctx context.Context, req *connect.Request[weatherv1.CalculateYieldExceedanceRequest]) (*connect.Response[weatherv1.CalculateYieldExceedanceResponse], error) {
	id, err := uuid.Parse(req.Msg.GetSiteWeatherId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid site_weather_id"))
	}
	exceedances, err := h.svc.CalculateYieldExceedance(ctx, id, req.Msg.GetSystemCapacityKw())
	if err != nil {
		return nil, weatherConnectError(err)
	}
	protoExc := make([]*weatherv1.YieldExceedance, 0, len(exceedances))
	for _, e := range exceedances {
		protoExc = append(protoExc, &weatherv1.YieldExceedance{
			Percentile:     int32(e.Percentile),
			AnnualGhiKwhM2: e.AnnualGHIKWhM2,
		})
	}
	return connect.NewResponse(&weatherv1.CalculateYieldExceedanceResponse{
		SiteWeatherId: id.String(),
		Exceedances:   protoExc,
	}), nil
}

func (h *ConnectWeatherService) DeleteSiteWeather(ctx context.Context, req *connect.Request[weatherv1.DeleteSiteWeatherRequest]) (*connect.Response[weatherv1.DeleteSiteWeatherResponse], error) {
	id, err := uuid.Parse(req.Msg.GetSiteWeatherId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid site_weather_id"))
	}
	if err := h.svc.DeleteSiteWeather(ctx, id); err != nil {
		return nil, weatherConnectError(err)
	}
	return connect.NewResponse(&weatherv1.DeleteSiteWeatherResponse{}), nil
}

// ---- Proto ↔ Domain helpers ----

func protoSourceToDomain(s weatherv1.WeatherSource) domain.WeatherSource {
	switch s {
	case weatherv1.WeatherSource_WEATHER_SOURCE_PVGIS:
		return domain.SourcePVGIS
	case weatherv1.WeatherSource_WEATHER_SOURCE_NASA_POWER:
		return domain.SourceNASA
	case weatherv1.WeatherSource_WEATHER_SOURCE_NSRDB:
		return domain.SourceNSRDB
	case weatherv1.WeatherSource_WEATHER_SOURCE_ERA5:
		return domain.SourceERA5
	case weatherv1.WeatherSource_WEATHER_SOURCE_EPW:
		return domain.SourceEPW
	case weatherv1.WeatherSource_WEATHER_SOURCE_TM2:
		return domain.SourceTM2
	case weatherv1.WeatherSource_WEATHER_SOURCE_TM3:
		return domain.SourceTM3
	case weatherv1.WeatherSource_WEATHER_SOURCE_CSV:
		return domain.SourceCSV
	default:
		return ""
	}
}

func domainSourceToProto(s domain.WeatherSource) weatherv1.WeatherSource {
	switch s {
	case domain.SourcePVGIS:
		return weatherv1.WeatherSource_WEATHER_SOURCE_PVGIS
	case domain.SourceNASA:
		return weatherv1.WeatherSource_WEATHER_SOURCE_NASA_POWER
	case domain.SourceNSRDB:
		return weatherv1.WeatherSource_WEATHER_SOURCE_NSRDB
	case domain.SourceERA5:
		return weatherv1.WeatherSource_WEATHER_SOURCE_ERA5
	case domain.SourceEPW:
		return weatherv1.WeatherSource_WEATHER_SOURCE_EPW
	case domain.SourceTM2:
		return weatherv1.WeatherSource_WEATHER_SOURCE_TM2
	case domain.SourceTM3:
		return weatherv1.WeatherSource_WEATHER_SOURCE_TM3
	case domain.SourceCSV:
		return weatherv1.WeatherSource_WEATHER_SOURCE_CSV
	default:
		return weatherv1.WeatherSource_WEATHER_SOURCE_UNSPECIFIED
	}
}

func summaryToProto(sw *domain.SiteWeather) *weatherv1.SiteWeatherSummary {
	return &weatherv1.SiteWeatherSummary{
		Id:              sw.ID.String(),
		ProjectId:       sw.ProjectID.String(),
		Latitude:        sw.Latitude,
		Longitude:       sw.Longitude,
		Source:          domainSourceToProto(sw.Source),
		RecordCount:     int32(sw.RecordCount),
		AnnualGhiKwhM2:  sw.AnnualGHIKWhM2,
		FetchedAt:       timestamppb.New(sw.FetchedAt),
	}
}

func recordsToProto(records []domain.HourlyRecord) []*weatherv1.HourlyRecord {
	out := make([]*weatherv1.HourlyRecord, 0, len(records))
	for _, r := range records {
		out = append(out, &weatherv1.HourlyRecord{
			Timestamp:          timestamppb.New(r.Timestamp),
			Ghi:                r.GHI,
			Dni:                r.DNI,
			Dhi:                r.DHI,
			AmbientTempC:       r.AmbientTempC,
			WindSpeedMs:        r.WindSpeedMS,
			RelativeHumidityPct: r.RelativeHumidityPct,
			Albedo:             r.Albedo,
		})
	}
	return out
}

func weatherConnectError(err error) error {
	if errors.Is(err, repository.ErrNotFound) {
		return connect.NewError(connect.CodeNotFound, err)
	}
	return connect.NewError(connect.CodeInternal, err)
}
