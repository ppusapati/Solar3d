package service

import (
	"context"
	"sync/atomic"
	"testing"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

func TestChaos_DeployFailsWhenArtifactRegistryUnavailable(t *testing.T) {
	repo := newFlakyRepo(42)
	repo.base.modelVersions["candidate_v2"] = &models.MLModelVersion{
		ID:        "candidate_v2",
		TaskType:  "yield",
		Status:    ModelStatusCandidate,
		CreatedAt: time.Now(),
	}
	repo.setFailureRate("GetModelVersion", 1.0)

	svc := NewMLTrainingService(repo)
	_, err := svc.DeployModelVersion(context.Background(), &models.DeployModelVersionRequest{
		ModelVersionID: "candidate_v2",
		DeployedBy:     "ops@test",
	})
	if err == nil {
		t.Fatal("expected deployment failure when artifact/model lookup is unavailable")
	}
}

func TestChaos_RollbackStillWorksAfterDeploymentWriteFailure(t *testing.T) {
	repo := newFlakyRepo(99)
	repo.base.modelVersions["champion_v1"] = &models.MLModelVersion{ID: "champion_v1", TaskType: "yield", Status: ModelStatusChampion, CreatedAt: time.Now().Add(-time.Hour)}
	repo.base.modelVersions["candidate_v2"] = &models.MLModelVersion{ID: "candidate_v2", TaskType: "yield", Status: ModelStatusCandidate, CreatedAt: time.Now()}
	repo.base.activeModels["yield"] = &models.MLActiveModel{
		ID:              "active_yield",
		TaskType:        "yield",
		CurrentModelID:  "candidate_v2",
		PreviousModelID: nullableString("champion_v1"),
		PromotedAt:      time.Now(),
	}
	repo.setFailureRate("CreateDeployment", 1.0)

	svc := NewMLTrainingService(repo)
	_, err := svc.DeployModelVersion(context.Background(), &models.DeployModelVersionRequest{ModelVersionID: "candidate_v2", DeployedBy: "ops@test"})
	if err == nil {
		t.Fatal("expected deployment failure due to simulated write outage")
	}

	rollbackResp, err := svc.RollbackModel(context.Background(), &models.RollbackModelVersionRequest{
		TaskType:     "yield",
		Reason:       "deployment write outage",
		RolledBackBy: "ops@test",
	})
	if err != nil {
		t.Fatalf("rollback should succeed even after deployment outage: %v", err)
	}
	if rollbackResp.ActiveVersionID != "champion_v1" {
		t.Fatalf("expected rollback to champion_v1, got %s", rollbackResp.ActiveVersionID)
	}
}

func TestChaos_IntermittentFeedbackOutageRecovery(t *testing.T) {
	repo := newFlakyRepo(7)
	repo.base.seedPredictionLogs("yield", 200)
	repo.setFailureRate("SubmitFeedback", 0.5)

	svc := NewMLTrainingService(repo)
	var successes int64
	for i := 0; i < 100; i++ {
		for attempt := 0; attempt < 3; attempt++ {
			_, err := svc.SubmitFeedback(context.Background(), &models.SubmitFeedbackRequest{
				PredictionID: "pred_" + itoa(i),
				SiteID:       "site_a",
				TaskType:     "yield",
				ActualLabel:  99.0,
				SubmittedBy:  "chaos@test",
			})
			if err == nil {
				atomic.AddInt64(&successes, 1)
				break
			}
		}
	}

	if successes < 80 {
		t.Fatalf("expected recovery success count >= 80, got %d", successes)
	}
}

