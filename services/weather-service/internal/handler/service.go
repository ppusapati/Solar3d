package handler

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
	"p9e.in/samavaya/solar3d/weather-service/internal/repository"
)

// Adapter is the interface each upstream weather source implements.
type Adapter interface {
	// Source returns the WeatherSource this adapter serves.
	Source() domain.WeatherSource
	// Fetch retrieves hourly irradiance for the given coordinates.
	// apiKey may be empty for public sources; adapters that require it
	// should return an error.
	Fetch(ctx context.Context, lat, lon float64, apiKey string) ([]domain.HourlyRecord, error)
}

// TMYParser parses a TMY file (EPW/TM2/TM3/CSV) into hourly records.
type TMYParser interface {
	Parse(data []byte) ([]domain.HourlyRecord, error)
	Source() domain.WeatherSource
}

// WeatherService orchestrates fetch, import, storage, and yield calculations.
type WeatherService struct {
	repo     *repository.Repository
	adapters map[domain.WeatherSource]Adapter
	parsers  map[domain.WeatherSource]TMYParser
	logger   zerolog.Logger
}

func NewWeatherService(
	repo *repository.Repository,
	adapters []Adapter,
	parsers []TMYParser,
	logger zerolog.Logger,
) *WeatherService {
	am := make(map[domain.WeatherSource]Adapter, len(adapters))
	for _, a := range adapters {
		am[a.Source()] = a
	}
	pm := make(map[domain.WeatherSource]TMYParser, len(parsers))
	for _, p := range parsers {
		pm[p.Source()] = p
	}
	return &WeatherService{
		repo:     repo,
		adapters: am,
		parsers:  pm,
		logger:   logger.With().Str("component", "weather-service").Logger(),
	}
}

func (s *WeatherService) FetchIrradiance(ctx context.Context, projectID uuid.UUID, lat, lon float64, source domain.WeatherSource, apiKey string) (*domain.SiteWeather, error) {
	adapter, ok := s.adapters[source]
	if !ok {
		return nil, fmt.Errorf("unsupported weather source: %s", source)
	}

	records, err := adapter.Fetch(ctx, lat, lon, apiKey)
	if err != nil {
		return nil, fmt.Errorf("fetch irradiance (%s): %w", source, err)
	}

	sw := &domain.SiteWeather{
		ProjectID:      projectID,
		Latitude:       lat,
		Longitude:      lon,
		Source:         source,
		Records:        records,
		RecordCount:    len(records),
		AnnualGHIKWhM2: domain.ComputeAnnualGHI(records),
		FetchedAt:      time.Now().UTC(),
	}
	if err := s.repo.Save(ctx, sw); err != nil {
		return nil, fmt.Errorf("save weather data: %w", err)
	}
	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("source", string(source)).
		Int("records", len(records)).
		Float64("annual_ghi_kwh_m2", sw.AnnualGHIKWhM2).
		Msg("irradiance fetched")
	return sw, nil
}

func (s *WeatherService) ImportTMY(ctx context.Context, projectID uuid.UUID, lat, lon float64, source domain.WeatherSource, data []byte) (*domain.SiteWeather, error) {
	parser, ok := s.parsers[source]
	if !ok {
		return nil, fmt.Errorf("unsupported TMY format: %s", source)
	}
	records, err := parser.Parse(data)
	if err != nil {
		return nil, fmt.Errorf("parse TMY (%s): %w", source, err)
	}

	sw := &domain.SiteWeather{
		ProjectID:      projectID,
		Latitude:       lat,
		Longitude:      lon,
		Source:         source,
		Records:        records,
		RecordCount:    len(records),
		AnnualGHIKWhM2: domain.ComputeAnnualGHI(records),
		FetchedAt:      time.Now().UTC(),
	}
	if err := s.repo.Save(ctx, sw); err != nil {
		return nil, fmt.Errorf("save imported TMY: %w", err)
	}
	return sw, nil
}

func (s *WeatherService) GetHourlyTimeseries(ctx context.Context, id uuid.UUID) (*domain.SiteWeather, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *WeatherService) ListSiteWeather(ctx context.Context, projectID uuid.UUID) ([]*domain.SiteWeather, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *WeatherService) DeleteSiteWeather(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
}

func (s *WeatherService) CalculateYieldExceedance(ctx context.Context, id uuid.UUID, systemCapacityKW float64) ([]domain.YieldExceedance, error) {
	sw, err := s.repo.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, fmt.Errorf("site weather not found: %w", err)
		}
		return nil, err
	}
	return computeExceedance(sw.Records, systemCapacityKW), nil
}
