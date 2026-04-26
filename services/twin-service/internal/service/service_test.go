package service_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/twin-service/internal/domain"
	"p9e.in/samavaya/solar3d/twin-service/internal/repository"
	"p9e.in/samavaya/solar3d/twin-service/internal/service"
)

// ── Mock repository ─────────────────────────────────────────────────────────

type mockRepo struct {
	twins      map[uuid.UUID]*domain.DigitalTwin
	identities map[uuid.UUID]*domain.AssetIdentity
	readings   []*domain.SensorReading

	createTwinErr          error
	getTwinErr             error
	insertReadingsErr      error
	createAssetIdentityErr error
}

func newMockRepo() *mockRepo {
	return &mockRepo{
		twins:      make(map[uuid.UUID]*domain.DigitalTwin),
		identities: make(map[uuid.UUID]*domain.AssetIdentity),
	}
}

func (m *mockRepo) CreateTwin(_ context.Context, t *domain.DigitalTwin) error {
	if m.createTwinErr != nil {
		return m.createTwinErr
	}
	if t.ID == uuid.Nil {
		t.ID = uuid.New()
	}
	now := time.Now().UTC()
	t.CreatedAt = now
	t.UpdatedAt = now
	m.twins[t.ID] = t
	return nil
}

func (m *mockRepo) GetTwinByID(_ context.Context, id uuid.UUID) (*domain.DigitalTwin, error) {
	if m.getTwinErr != nil {
		return nil, m.getTwinErr
	}
	t, ok := m.twins[id]
	if !ok {
		return nil, repository.ErrNotFound
	}
	return t, nil
}

func (m *mockRepo) ListTwinsByProject(_ context.Context, projectID uuid.UUID) ([]*domain.DigitalTwin, error) {
	var out []*domain.DigitalTwin
	for _, t := range m.twins {
		if t.ProjectID == projectID {
			out = append(out, t)
		}
	}
	return out, nil
}

func (m *mockRepo) UpdateTwin(_ context.Context, t *domain.DigitalTwin) error {
	if _, ok := m.twins[t.ID]; !ok {
		return repository.ErrNotFound
	}
	m.twins[t.ID] = t
	return nil
}

func (m *mockRepo) CreateAssetIdentity(_ context.Context, a *domain.AssetIdentity) error {
	if m.createAssetIdentityErr != nil {
		return m.createAssetIdentityErr
	}
	if a.ID == uuid.Nil {
		a.ID = uuid.New()
	}
	now := time.Now().UTC()
	a.CreatedAt = now
	a.UpdatedAt = now
	m.identities[a.ID] = a
	return nil
}

func (m *mockRepo) GetAssetIdentityByID(_ context.Context, id uuid.UUID) (*domain.AssetIdentity, error) {
	a, ok := m.identities[id]
	if !ok {
		return nil, repository.ErrNotFound
	}
	return a, nil
}

func (m *mockRepo) ListAssetIdentitiesByTwin(_ context.Context, twinID uuid.UUID) ([]*domain.AssetIdentity, error) {
	var out []*domain.AssetIdentity
	for _, a := range m.identities {
		if a.TwinID == twinID {
			out = append(out, a)
		}
	}
	return out, nil
}

func (m *mockRepo) InsertReadingsBatch(_ context.Context, readings []*domain.SensorReading) error {
	if m.insertReadingsErr != nil {
		return m.insertReadingsErr
	}
	m.readings = append(m.readings, readings...)
	return nil
}

func (m *mockRepo) GetLatestReadingsByTwin(_ context.Context, twinID uuid.UUID, limit int) ([]*domain.SensorReading, error) {
	var out []*domain.SensorReading
	for _, r := range m.readings {
		if r.TwinID == twinID {
			out = append(out, r)
		}
	}
	if len(out) > limit {
		out = out[:limit]
	}
	return out, nil
}

// ── Test helpers ─────────────────────────────────────────────────────────────

func newSvc(repo repository.TwinRepository) *service.TwinService {
	return service.New(repo, zerolog.Nop())
}

// ── ProvisionTwin ────────────────────────────────────────────────────────────

func TestProvisionTwin_Success(t *testing.T) {
	repo := newMockRepo()
	svc := newSvc(repo)

	projectID := uuid.New()
	twin, err := svc.ProvisionTwin(context.Background(), service.ProvisionTwinInput{
		ProjectID: projectID,
	})

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if twin.ID == uuid.Nil {
		t.Error("expected non-nil twin ID")
	}
	if twin.ProjectID != projectID {
		t.Errorf("expected project_id %v, got %v", projectID, twin.ProjectID)
	}
	if twin.Status != domain.TwinStatusProvisioning {
		t.Errorf("expected status PROVISIONING, got %q", twin.Status)
	}
}

func TestProvisionTwin_MissingProjectID(t *testing.T) {
	svc := newSvc(newMockRepo())
	_, err := svc.ProvisionTwin(context.Background(), service.ProvisionTwinInput{})
	if err == nil {
		t.Fatal("expected error for missing project_id, got nil")
	}
}

func TestProvisionTwin_RepoError(t *testing.T) {
	repo := newMockRepo()
	repo.createTwinErr = errors.New("db failure")
	svc := newSvc(repo)

	_, err := svc.ProvisionTwin(context.Background(), service.ProvisionTwinInput{ProjectID: uuid.New()})
	if err == nil {
		t.Fatal("expected error from repo, got nil")
	}
}

// ── GetTwinState ─────────────────────────────────────────────────────────────

func TestGetTwinState_Success(t *testing.T) {
	repo := newMockRepo()
	svc := newSvc(repo)

	// Provision first so we have a twin.
	created, _ := svc.ProvisionTwin(context.Background(), service.ProvisionTwinInput{
		ProjectID: uuid.New(),
	})

	twin, err := svc.GetTwinState(context.Background(), created.ID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if twin.ID != created.ID {
		t.Errorf("expected id %v, got %v", created.ID, twin.ID)
	}
}

func TestGetTwinState_NotFound(t *testing.T) {
	svc := newSvc(newMockRepo())
	_, err := svc.GetTwinState(context.Background(), uuid.New())
	if !errors.Is(err, repository.ErrNotFound) {
		t.Fatalf("expected ErrNotFound, got %v", err)
	}
}

func TestGetTwinState_NilID(t *testing.T) {
	svc := newSvc(newMockRepo())
	_, err := svc.GetTwinState(context.Background(), uuid.Nil)
	if err == nil {
		t.Fatal("expected error for nil twin_id")
	}
}

// ── IngestReadings ───────────────────────────────────────────────────────────

func TestIngestReadings_Success(t *testing.T) {
	repo := newMockRepo()
	svc := newSvc(repo)

	twinID := uuid.New()
	readings := []*domain.SensorReading{
		{SensorID: "inv-001", Metric: domain.MetricACPowerW, Value: 5000, Unit: "W", RecordedAt: time.Now().UTC()},
		{SensorID: "inv-001", Metric: domain.MetricDCVoltageV, Value: 720, Unit: "V", RecordedAt: time.Now().UTC()},
	}

	count, err := svc.IngestReadings(context.Background(), service.IngestReadingsInput{
		TwinID:   twinID,
		Readings: readings,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if count != 2 {
		t.Errorf("expected 2 ingested, got %d", count)
	}
	if len(repo.readings) != 2 {
		t.Errorf("expected 2 readings stored, got %d", len(repo.readings))
	}
	// Verify twin ID was stamped on all readings.
	for _, r := range repo.readings {
		if r.TwinID != twinID {
			t.Errorf("expected twin_id %v on reading, got %v", twinID, r.TwinID)
		}
	}
}

func TestIngestReadings_DefaultsQualityGood(t *testing.T) {
	repo := newMockRepo()
	svc := newSvc(repo)

	_, err := svc.IngestReadings(context.Background(), service.IngestReadingsInput{
		TwinID: uuid.New(),
		Readings: []*domain.SensorReading{
			{SensorID: "s1", Metric: domain.MetricACPowerW, Value: 1, RecordedAt: time.Now().UTC()},
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if repo.readings[0].Quality != domain.ReadingQualityGood {
		t.Errorf("expected GOOD quality default, got %q", repo.readings[0].Quality)
	}
}

func TestIngestReadings_EmptyBatch(t *testing.T) {
	svc := newSvc(newMockRepo())
	count, err := svc.IngestReadings(context.Background(), service.IngestReadingsInput{TwinID: uuid.New()})
	if err != nil {
		t.Fatalf("empty batch should not error, got %v", err)
	}
	if count != 0 {
		t.Errorf("expected 0 ingested, got %d", count)
	}
}

func TestIngestReadings_ExceedsMaxBatch(t *testing.T) {
	svc := newSvc(newMockRepo())
	readings := make([]*domain.SensorReading, 5001)
	for i := range readings {
		readings[i] = &domain.SensorReading{SensorID: "s1", Metric: domain.MetricACPowerW}
	}
	_, err := svc.IngestReadings(context.Background(), service.IngestReadingsInput{
		TwinID:   uuid.New(),
		Readings: readings,
	})
	if err == nil {
		t.Fatal("expected error for batch > 5000, got nil")
	}
}

func TestIngestReadings_MissingTwinID(t *testing.T) {
	svc := newSvc(newMockRepo())
	_, err := svc.IngestReadings(context.Background(), service.IngestReadingsInput{
		TwinID:   uuid.Nil,
		Readings: []*domain.SensorReading{{SensorID: "s"}},
	})
	if err == nil {
		t.Fatal("expected error for nil twin_id")
	}
}

// ── LinkAssetIdentity ────────────────────────────────────────────────────────

func TestLinkAssetIdentity_Success(t *testing.T) {
	repo := newMockRepo()
	svc := newSvc(repo)

	twin, _ := svc.ProvisionTwin(context.Background(), service.ProvisionTwinInput{ProjectID: uuid.New()})

	identity, err := svc.LinkAssetIdentity(context.Background(), service.LinkAssetIdentityInput{
		TwinID:               twin.ID,
		DesignAssetID:        uuid.New(),
		DesignAssetType:      domain.DesignAssetTypeInverter,
		PhysicalSerialNumber: "INV-2024-001",
		CommissioningRef:     "IEC62446-CM-001",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if identity.ID == uuid.Nil {
		t.Error("expected non-nil identity ID")
	}
	if identity.TwinID != twin.ID {
		t.Errorf("expected twin_id %v, got %v", twin.ID, identity.TwinID)
	}
}

func TestLinkAssetIdentity_TwinNotFound(t *testing.T) {
	svc := newSvc(newMockRepo())
	_, err := svc.LinkAssetIdentity(context.Background(), service.LinkAssetIdentityInput{
		TwinID:               uuid.New(),
		DesignAssetID:        uuid.New(),
		DesignAssetType:      domain.DesignAssetTypePanel,
		PhysicalSerialNumber: "SN-001",
	})
	if !errors.Is(err, repository.ErrNotFound) {
		t.Fatalf("expected ErrNotFound, got %v", err)
	}
}

func TestLinkAssetIdentity_MissingSerialNumber(t *testing.T) {
	repo := newMockRepo()
	svc := newSvc(repo)
	twin, _ := svc.ProvisionTwin(context.Background(), service.ProvisionTwinInput{ProjectID: uuid.New()})

	_, err := svc.LinkAssetIdentity(context.Background(), service.LinkAssetIdentityInput{
		TwinID:          twin.ID,
		DesignAssetID:   uuid.New(),
		DesignAssetType: domain.DesignAssetTypePanel,
		// PhysicalSerialNumber intentionally empty
	})
	if err == nil {
		t.Fatal("expected error for missing physical_serial_number")
	}
}
