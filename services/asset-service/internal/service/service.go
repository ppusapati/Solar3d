package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"github.com/solar3d/solar3d/services/asset-service/internal/domain"
	"github.com/solar3d/solar3d/services/asset-service/internal/repository"
)

type Service struct {
	repo *repository.Repository
}

func New(repo *repository.Repository) *Service {
	return &Service{repo: repo}
}

func (s *Service) CreateAsset(ctx context.Context, asset *domain.Asset) error {
	if asset.Name == "" {
		return fmt.Errorf("asset name is required")
	}
	if asset.Category == "" {
		return fmt.Errorf("asset category is required")
	}
	return s.repo.CreateAsset(ctx, asset)
}

func (s *Service) GetAsset(ctx context.Context, id uuid.UUID) (*domain.Asset, error) {
	return s.repo.GetAsset(ctx, id)
}

func (s *Service) ListAssets(ctx context.Context, category string, pageSize int, pageToken string) ([]domain.Asset, int, error) {
	if pageSize <= 0 || pageSize > 100 {
		pageSize = 20
	}
	offset := 0
	if pageToken != "" {
		// Parse page token as offset
		fmt.Sscanf(pageToken, "%d", &offset)
	}
	return s.repo.ListAssets(ctx, category, pageSize, offset)
}

func (s *Service) UpdateAsset(ctx context.Context, asset *domain.Asset) error {
	if asset.Name == "" {
		return fmt.Errorf("asset name is required")
	}
	return s.repo.UpdateAsset(ctx, asset)
}

func (s *Service) DeleteAsset(ctx context.Context, id uuid.UUID) error {
	return s.repo.DeleteAsset(ctx, id)
}
