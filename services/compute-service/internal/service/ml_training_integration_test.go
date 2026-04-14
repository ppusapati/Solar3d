package service

import (
	"context"
	"testing"
	"time"

	"solar3d/compute-service/internal/models"
)

func TestMLLifecycleIntegration_EndToEnd(t *testing.T) {
	repo := newInMemoryMLRepo()
	repo.seedPredictionLogs("yield", 1)
	repo.modelVersions["champion_v1"] = &models.MLModelVersion{
		ID:        "champion_v1",
		TaskType:  "yield",
		Status:    ModelStatusChampion,
		CreatedAt: time.Now().Add(-24 * time.Hour),
	}
	repo.modelVersions["candidate_v2"] = &models.MLModelVersion{
		ID:        "candidate_v2",
		TaskType:  "yield",
		Status:    ModelStatusCandidate,
		CreatedAt: time.Now(),
	}
	repo.activeModels["yield"] = &models.MLActiveModel{
		ID:              "active_yield",
		TaskType:        "yield",
		CurrentModelID:  "candidate_v2",
		PreviousModelID: nullableString("champion_v1"),
		PromotedAt:      time.Now(),
	}

	svc := NewMLTrainingService(repo)
	ctx := context.Background()

	feedbackResp, err := svc.SubmitFeedback(ctx, &models.SubmitFeedbackRequest{
		PredictionID: "pred_0",
		SiteID:       "site_a",
		TaskType:     "yield",
		ActualLabel:  98.2,
		SubmittedBy:  "qa@solar3d.local",
	})
	if err != nil {
		t.Fatalf("submit feedback failed: %v", err)
	}
	if !feedbackResp.Accepted || feedbackResp.FeedbackID == "" {
		t.Fatalf("invalid feedback response: %+v", feedbackResp)
	}

	trainResp, err := svc.StartTraining(ctx, &models.StartTrainingRequest{
		TaskType:    "yield",
		TriggeredBy: "qa@solar3d.local",
		CommitHash:  "abc123",
		Config: map[string]interface{}{
			"lookback_days": 30,
		},
		Hyperparams: map[string]string{"epochs": "20"},
	})
	if err != nil {
		t.Fatalf("start training failed: %v", err)
	}
	if trainResp.TrainingRunID == "" {
		t.Fatal("training run id should not be empty")
	}

	statusResp, err := svc.GetTrainingStatus(ctx, &models.GetTrainingStatusRequest{TrainingRunID: trainResp.TrainingRunID})
	if err != nil {
		t.Fatalf("get training status failed: %v", err)
	}
	if statusResp.Status != StatusQueued {
		t.Fatalf("expected queued status, got %s", statusResp.Status)
	}

	evalResp, err := svc.EvaluateModel(ctx, &models.EvaluateModelRequest{
		ModelVersionID: "candidate_v2",
		Dataset:        "validation",
	})
	if err != nil {
		t.Fatalf("evaluate model failed: %v", err)
	}
	if evalResp.Recommendation == "" {
		t.Fatal("evaluation recommendation should not be empty")
	}

	deployResp, err := svc.DeployModelVersion(ctx, &models.DeployModelVersionRequest{
		ModelVersionID: "candidate_v2",
		DeployedBy:     "ops@solar3d.local",
		ApprovalID:     "appr_001",
		Policy: models.DeploymentPolicy{
			CanaryTrafficPercent: 10,
		},
	})
	if err != nil {
		t.Fatalf("deploy model failed: %v", err)
	}
	if deployResp.Status != DeploymentStatusCanary {
		t.Fatalf("expected canary deployment, got %s", deployResp.Status)
	}

	activeResp, err := svc.GetActiveModel(ctx, "yield")
	if err != nil {
		t.Fatalf("get active model failed: %v", err)
	}
	if activeResp.ActiveVersion.VersionID != "candidate_v2" {
		t.Fatalf("unexpected active model: %s", activeResp.ActiveVersion.VersionID)
	}

	rollbackResp, err := svc.RollbackModel(ctx, &models.RollbackModelVersionRequest{
		TaskType:     "yield",
		Reason:       "canary degraded",
		RolledBackBy: "ops@solar3d.local",
	})
	if err != nil {
		t.Fatalf("rollback failed: %v", err)
	}
	if rollbackResp.ActiveVersionID != "champion_v1" {
		t.Fatalf("expected rollback to champion_v1, got %s", rollbackResp.ActiveVersionID)
	}

	if len(repo.auditEvents) < 5 {
		t.Fatalf("expected audit events to be recorded, got %d", len(repo.auditEvents))
	}
}

