package workflow

import (
	"context"
	"testing"
	"time"
)

func TestDatasetPrepStep(t *testing.T) {
	step := &DatasetPrepStep{
		lookbackDays:      30,
		minSamplesPerSite: 100,
		trainRatio:        0.6,
		validationRatio:   0.2,
		testRatio:         0.2,
		timeAwareSplit:    true,
	}

	stepName, output, err := step.Execute(context.Background())
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if stepName != "dataset_created" {
		t.Errorf("expected step name 'dataset_created', got %s", stepName)
	}

	if output["dataset_id"] == nil {
		t.Error("dataset_id not in output")
	}

	if output["total_samples"] != int64(1000) {
		t.Errorf("expected 1000 total samples, got %v", output["total_samples"])
	}
}

func TestTrainingStep(t *testing.T) {
	step := &TrainingStep{
		datasetID:   "dataset_123",
		algorithm:   "gradient_boosting",
		epochs:      100,
		batchSize:   32,
		hyperparams: map[string]interface{}{},
		timeout:     15 * time.Minute,
	}

	stepName, output, err := step.Execute(context.Background())
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if stepName != "training_completed" {
		t.Errorf("expected step name 'training_completed', got %s", stepName)
	}

	if output["model_version_id"] == nil {
		t.Error("model_version_id not in output")
	}

	if mae, ok := output["test_mae"].(float64); !ok || mae == 0 {
		t.Errorf("expected test_mae as float64, got %v", output["test_mae"])
	}
}

func TestSafetyCheckStep(t *testing.T) {
	step := &SafetyCheckStep{
		modelVersionID: "model_v1",
		policies:       map[string]interface{}{},
	}

	stepName, output, err := step.Execute(context.Background())
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if stepName != "safety_checks_passed" {
		t.Errorf("expected step name 'safety_checks_passed', got %s", stepName)
	}

	if safeToDeploy, ok := output["safe_to_deploy"].(bool); !ok || !safeToDeploy {
		t.Errorf("expected safe_to_deploy=true, got %v", output["safe_to_deploy"])
	}
}

func TestOrchestratorExecute(t *testing.T) {
	orch := &Orchestrator{
		steps: []WorkflowStep{},
	}

	orch.AddStep(&DatasetPrepStep{
		lookbackDays:      30,
		minSamplesPerSite: 100,
		trainRatio:        0.6,
		validationRatio:   0.2,
		testRatio:         0.2,
		timeAwareSplit:    true,
	})

	orch.AddStep(&TrainingStep{
		algorithm:   "gradient_boosting",
		epochs:      100,
		batchSize:   32,
		hyperparams: map[string]interface{}{},
		timeout:     15 * time.Minute,
	})

	stepName, output, err := orch.Execute(context.Background())
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if stepName != "workflow_completed" {
		t.Errorf("expected final step name 'workflow_completed', got %s", stepName)
	}

	if output == nil {
		t.Error("output is nil")
	}

	if len(orch.state) != 2 {
		t.Errorf("expected 2 executed steps, got %d", len(orch.state))
	}

	for _, state := range orch.state {
		if state.Status != "completed" {
			t.Errorf("expected step status 'completed', got %s", state.Status)
		}
	}
}

func TestOrchestratorRetry(t *testing.T) {
	orch := &Orchestrator{
		steps: []WorkflowStep{},
	}

	// Add a step that would fail
	orch.AddStep(&AlwaysFailStep{})

	stepName, _, err := orch.Execute(context.Background())
	if err == nil {
		t.Fatal("expected error from failing step")
	}

	if stepName != "workflow_failed" {
		t.Errorf("expected final step name 'workflow_failed', got %s", stepName)
	}

	if len(orch.state) != 1 {
		t.Errorf("expected 1 executed step, got %d", len(orch.state))
	}

	if orch.state[0].Status != "failed" {
		t.Errorf("expected step status 'failed', got %s", orch.state[0].Status)
	}
}

func TestWorkflowBuilder(t *testing.T) {
	builder := NewMLTrainingWorkflow("yield").
		WithConfig("lookback_days", 30).
		WithHyperparams(map[string]interface{}{
			"learning_rate": 0.001,
			"epochs":        100,
		})

	orch := builder.Build()

	if len(orch.steps) != 7 {
		t.Errorf("expected 7 steps in workflow, got %d", len(orch.steps))
	}
}

func TestWorkflowStatus(t *testing.T) {
	orch := &Orchestrator{
		steps: []WorkflowStep{},
	}

	orch.AddStep(&DatasetPrepStep{})
	orch.AddStep(&TrainingStep{algorithm: "gb", epochs: 100, batchSize: 32, hyperparams: map[string]interface{}{}, timeout: 15 * time.Minute})

	_, _, _ = orch.Execute(context.Background())

	status := orch.GetWorkflowStatus()

	if status["total_steps"] != 2 {
		t.Errorf("expected 2 total steps, got %v", status["total_steps"])
	}

	if status["completed_steps"] != 2 {
		t.Errorf("expected 2 completed steps, got %v", status["completed_steps"])
	}

	if status["failed_steps"] != 0 {
		t.Errorf("expected 0 failed steps, got %v", status["failed_steps"])
	}
}

// Test utility: step that always fails
type AlwaysFailStep struct{}

func (s *AlwaysFailStep) Execute(ctx context.Context) (string, map[string]interface{}, error) {
	return "", nil, context.DeadlineExceeded
}

func BenchmarkWorkflowExecution(b *testing.B) {
	orch := NewMLTrainingWorkflow("yield").Build()

	for i := 0; i < b.N; i++ {
		_, _, _ = orch.Execute(context.Background())
	}
}

