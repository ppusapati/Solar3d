package service

import (
	"context"
	"fmt"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/repository"
)

type GeoService struct {
	repo repository.GeoRepository
}

func NewGeoService(repo repository.GeoRepository) *GeoService {
	return &GeoService{repo: repo}
}

func (s *GeoService) BufferPoint(ctx context.Context, req *models.BufferPointRequest) (*models.BufferPointResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("buffer point request is nil")
	}
	resp, err := s.repo.BufferPoint(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("buffer point failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("buffer point response is nil")
	}
	return resp, nil
}

func (s *GeoService) NearestPoint(ctx context.Context, req *models.NearestPointRequest) (*models.NearestPointResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("nearest point request is nil")
	}
	resp, err := s.repo.NearestPoint(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("nearest point failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("nearest point response is nil")
	}
	return resp, nil
}

func (s *GeoService) GenerateContours(ctx context.Context, req *models.GenerateContoursRequest) (*models.GenerateContoursResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("generate contours request is nil")
	}
	resp, err := s.repo.GenerateContours(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("generate contours failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("generate contours response is nil")
	}
	return resp, nil
}

