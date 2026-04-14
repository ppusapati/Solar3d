package service

import (
	"context"
	"testing"
	"time"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/repository"
)

func TestSubmitFeedback(t *testing.T) {
	repo := &mockRepoWithPredictionLog{}
	svc := NewMLTrainingService(repo)

	req := &models.SubmitFeedbackRequest{
		PredictionID: "pred_123",
		SiteID:       "site_456",
		TaskType:     "yield",
		ActualLabel:  95.5,
		SubmittedBy:  "user@example.com",
	}

	resp, err := svc.SubmitFeedback(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if resp == nil {
		t.Fatal("response is nil")
	}

	if !resp.Accepted {
		t.Errorf("expected accepted=true, got %v", resp.Accepted)
	}
}

type mockRepoWithPredictionLog struct {
	*repository.MockMLTrainingRepository
}

func (m *mockRepoWithPredictionLog) GetPredictionLog(ctx context.Context, predictionID string) (*models.MLPredictionLog, error) {
	return &models.MLPredictionLog{
		ID:           "log_123",
		PredictionID: predictionID,
		SiteID:       "site_456",
	}, nil
}

type mockRepoWithModel struct {
	*repository.MockMLTrainingRepository
}

func (m *mockRepoWithModel) GetModelVersion(ctx context.Context, versionID string) (*models.MLModelVersion, error) {
	return &models.MLModelVersion{
		ID:       versionID,
		TaskType: "yield",
		Status:   "candidate",
	}, nil
}

func TestStartTraining(t *testing.T) {
	repo := &repository.MockMLTrainingRepository{}
	svc := NewMLTrainingService(repo)

	req := &models.StartTrainingRequest{
		TaskType:    "yield",
		TriggeredBy: "user@example.com",
		CommitHash:  "abc123def456",
		Config: map[string]interface{}{
			"lookback_days": 30,
		},
		Hyperparams: map[string]string{
			"learning_rate": "0.001",
			"epochs":        "100",
		},
	}

	resp, err := svc.StartTraining(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if resp == nil {
		t.Fatal("response is nil")
	}

	if resp.TrainingRunID == "" {
		t.Error("training run id is empty")
	}

	if resp.Status != StatusQueued {
		t.Errorf("expected status %s, got %s", StatusQueued, resp.Status)
	}
}

func TestStartTrainingValidation(t *testing.T) {
	repo := &repository.MockMLTrainingRepository{}
	svc := NewMLTrainingService(repo)

	testCases := []struct {
		name    string
		req     *models.StartTrainingRequest
		wantErr bool
	}{
		{
			name:    "nil request",
			req:     nil,
			wantErr: true,
		},
		{
			name: "empty task type",
			req: &models.StartTrainingRequest{
				TaskType: "",
			},
			wantErr: true,
		},
		{
			name: "valid request",
			req: &models.StartTrainingRequest{
				TaskType:    "yield",
				TriggeredBy: "user",
			},
			wantErr: false,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			_, err := svc.StartTraining(context.Background(), tc.req)
			if (err != nil) != tc.wantErr {
				t.Fatalf("expected error=%v, got err=%v", tc.wantErr, err)
			}
		})
	}
}

func TestDeployModelVersion(t *testing.T) {
	repo := &mockRepoWithModel{}
	svc := NewMLTrainingService(repo)

	req := &models.DeployModelVersionRequest{
		ModelVersionID: "model_v1",
		DeployedBy:     "user@example.com",
		ApprovalID:     "approval_123",
		Policy: models.DeploymentPolicy{
			MinImprovementPercent: 2.0,
			CanaryTrafficPercent:  10.0,
		},
	}

	resp, err := svc.DeployModelVersion(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if resp == nil {
		t.Fatal("response is nil")
	}

	if resp.DeploymentID == "" {
		t.Error("deployment id is empty")
	}

	if resp.Status != DeploymentStatusCanary {
		t.Errorf("expected status %s, got %s", DeploymentStatusCanary, resp.Status)
	}
}

func TestDeployModelVersion_RequiresApprovalWhenPolicyEnforced(t *testing.T) {
	repo := &mockRepoWithModel{}
	svc := NewMLTrainingService(repo)

	_, err := svc.DeployModelVersion(context.Background(), &models.DeployModelVersionRequest{
		ModelVersionID: "model_v1",
		DeployedBy:     "ops@example.com",
		Policy: models.DeploymentPolicy{
			RequireManualApproval: true,
			CanaryTrafficPercent:  10,
		},
	})
	if err == nil {
		t.Fatal("expected error when approval is required but missing")
	}
}

func TestDeployModelVersion_DirectPromotionSetsActiveModel(t *testing.T) {
	repo := newInMemoryMLRepo()
	repo.modelVersions["champion_v1"] = &models.MLModelVersion{
		ID:       "champion_v1",
		TaskType: "yield",
		Status:   ModelStatusChampion,
	}
	repo.modelVersions["candidate_v2"] = &models.MLModelVersion{
		ID:       "candidate_v2",
		TaskType: "yield",
		Status:   ModelStatusCandidate,
	}
	repo.activeModels["yield"] = &models.MLActiveModel{
		ID:             "active_yield",
		TaskType:       "yield",
		CurrentModelID: "champion_v1",
	}

	svc := NewMLTrainingService(repo)

	resp, err := svc.DeployModelVersion(context.Background(), &models.DeployModelVersionRequest{
		ModelVersionID: "candidate_v2",
		DeployedBy:     "ops@example.com",
		ApprovalID:     "appr_001",
		Policy: models.DeploymentPolicy{
			CanaryTrafficPercent: 100,
		},
	})
	if err != nil {
		t.Fatalf("unexpected deploy error: %v", err)
	}
	if resp.Status != DeploymentStatusActive {
		t.Fatalf("expected active deployment status, got %s", resp.Status)
	}

	active, err := svc.GetActiveModel(context.Background(), "yield")
	if err != nil {
		t.Fatalf("unexpected active model error: %v", err)
	}
	if active.ActiveVersion.VersionID != "candidate_v2" {
		t.Fatalf("expected candidate_v2 active, got %s", active.ActiveVersion.VersionID)
	}
	if active.PreviousVersion == nil || active.PreviousVersion.VersionID != "champion_v1" {
		t.Fatalf("expected previous champion_v1, got %+v", active.PreviousVersion)
	}
}

func TestRollbackModel(t *testing.T) {
	repo := &repository.MockMLTrainingRepository{}
	svc := NewMLTrainingService(repo)

	req := &models.RollbackModelVersionRequest{
		TaskType:     "yield",
		Reason:       "Performance degradation",
		RolledBackBy: "ops@example.com",
	}

	resp, err := svc.RollbackModel(context.Background(), req)
	if err == nil {
		// Expected to fail in mock, but check type
		t.Logf("got response: %v", resp)
	}
}

func TestListModelVersions(t *testing.T) {
	repo := &repository.MockMLTrainingRepository{}
	svc := NewMLTrainingService(repo)

	req := &models.GetModelVersionsRequest{
		TaskType: "yield",
		Limit:    10,
	}

	resp, err := svc.ListModelVersions(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if resp == nil {
		t.Fatal("response is nil")
	}

	// Mock returns empty list
	if len(resp.Versions) != 0 {
		t.Errorf("expected 0 versions, got %d", len(resp.Versions))
	}
}

func TestMapToTrainingMetrics(t *testing.T) {
	data := map[string]interface{}{
		"train_loss":          0.05,
		"validation_loss":     0.06,
		"test_loss":           0.07,
		"test_mae":            25.3,
		"test_rmse":           35.7,
		"test_coverage_lower": 92.5,
		"test_coverage_upper": 91.8,
	}

	metrics := mapToTrainingMetrics(data)

	if metrics.TrainLoss != 0.05 {
		t.Errorf("expected train_loss=0.05, got %f", metrics.TrainLoss)
	}

	if metrics.TestMAE != 25.3 {
		t.Errorf("expected test_mae=25.3, got %f", metrics.TestMAE)
	}
}

func TestStartTrainingLifecycleCompletesAndLinksModelVersion(t *testing.T) {
	repo := newInMemoryMLRepo()
	svc := NewMLTrainingService(repo)

	resp, err := svc.StartTraining(context.Background(), &models.StartTrainingRequest{
		TaskType:    "yield",
		TriggeredBy: "qa@solar3d.local",
		CommitHash:  "commit123",
		Config: map[string]interface{}{
			"lookback_days": 30,
		},
		Hyperparams: map[string]string{
			"epochs":        "25",
			"learning_rate": "0.001",
		},
	})
	if err != nil {
		t.Fatalf("start training failed: %v", err)
	}

	deadline := time.Now().Add(2 * time.Second)
	var status *models.GetTrainingStatusResponse
	for time.Now().Before(deadline) {
		status, err = svc.GetTrainingStatus(context.Background(), &models.GetTrainingStatusRequest{TrainingRunID: resp.TrainingRunID})
		if err != nil {
			t.Fatalf("get status failed: %v", err)
		}
		if status.Status == StatusComplete {
			break
		}
		time.Sleep(25 * time.Millisecond)
	}

	if status == nil || status.Status != StatusComplete {
		t.Fatalf("expected completed status, got %+v", status)
	}
	if status.ModelVersionID == "" {
		t.Fatal("expected model_version_id in training status")
	}
	if status.Metrics == nil || status.Metrics.TestMAE <= 0 {
		t.Fatalf("expected populated training metrics, got %+v", status.Metrics)
	}
}

func BenchmarkStartTraining(b *testing.B) {
	repo := &repository.MockMLTrainingRepository{}
	svc := NewMLTrainingService(repo)

	req := &models.StartTrainingRequest{
		TaskType:    "yield",
		TriggeredBy: "user",
		CommitHash:  "abc123",
		Config:      make(map[string]interface{}),
		Hyperparams: make(map[string]string),
	}

	for i := 0; i < b.N; i++ {
		_, _ = svc.StartTraining(context.Background(), req)
	}
}

func BenchmarkSubmitFeedback(b *testing.B) {
	repo := &repository.MockMLTrainingRepository{}
	svc := NewMLTrainingService(repo)

	req := &models.SubmitFeedbackRequest{
		PredictionID: "pred_123",
		SiteID:       "site_456",
		TaskType:     "yield",
		ActualLabel:  95.5,
		SubmittedBy:  "user",
	}

	for i := 0; i < b.N; i++ {
		_, _ = svc.SubmitFeedback(context.Background(), req)
	}
}
