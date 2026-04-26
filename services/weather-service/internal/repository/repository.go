package repository

import (
	"context"
	"errors"
	"sync"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

var ErrNotFound = errors.New("weather: site weather not found")

// Repository stores and retrieves SiteWeather datasets. The initial
// implementation is in-memory; production can swap to Postgres if durability
// beyond process lifetime is required.
type Repository struct {
	mu    sync.RWMutex
	store map[uuid.UUID]*domain.SiteWeather
}

func New() *Repository {
	return &Repository{store: make(map[uuid.UUID]*domain.SiteWeather)}
}

func (r *Repository) Save(_ context.Context, sw *domain.SiteWeather) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	if sw.ID == uuid.Nil {
		sw.ID = uuid.New()
	}
	r.store[sw.ID] = sw
	return nil
}

func (r *Repository) GetByID(_ context.Context, id uuid.UUID) (*domain.SiteWeather, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	sw, ok := r.store[id]
	if !ok {
		return nil, ErrNotFound
	}
	return sw, nil
}

func (r *Repository) ListByProject(_ context.Context, projectID uuid.UUID) ([]*domain.SiteWeather, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var out []*domain.SiteWeather
	for _, sw := range r.store {
		if sw.ProjectID == projectID {
			out = append(out, sw)
		}
	}
	return out, nil
}

func (r *Repository) Delete(_ context.Context, id uuid.UUID) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	if _, ok := r.store[id]; !ok {
		return ErrNotFound
	}
	delete(r.store, id)
	return nil
}
