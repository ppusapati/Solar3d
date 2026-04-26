package mappers

import (
	"encoding/json"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"

	ml_inferencev1 "p9e.in/samavaya/solar3d/gen/ml_inference/v1"
)

// ============================================================
// Feedback Mappers
// ============================================================

func ProtoToSubmitFeedback(proto *ml_inferencev1.SubmitFeedbackRequest) *models.SubmitFeedbackRequest {
	if proto == nil {
		return nil
	}
	return &models.SubmitFeedbackRequest{
		PredictionID: proto.PredictionId,
		SiteID:       proto.SiteId,
		TaskType:     proto.TaskType,
		ActualLabel:  proto.ActualLabel,
		Notes:        proto.Notes,
		SubmittedBy:  proto.SubmittedBy,
	}
}

func SubmitFeedbackToProto(domain *models.SubmitFeedbackResponse) *ml_inferencev1.SubmitFeedbackResponse {
	if domain == nil {
		return nil
	}
	return &ml_inferencev1.SubmitFeedbackResponse{
		FeedbackId: domain.FeedbackID,
		Accepted:   domain.Accepted,
		Message:    domain.Message,
	}
}

// ============================================================
// Training Mappers
// ============================================================

func ProtoToStartTraining(proto *ml_inferencev1.StartTrainingRequest) *models.StartTrainingRequest {
	if proto == nil {
		return nil
	}

	hyperparams := make(map[string]string)
	for k, v := range proto.Hyperparams {
		hyperparams[k] = v
	}

	config := make(map[string]interface{})
	if proto.Config != nil {
		configJSON, _ := json.Marshal(proto.Config)
		_ = json.Unmarshal(configJSON, &config)
	}

	return &models.StartTrainingRequest{
		TaskType:    proto.TaskType,
		Config:      config,
		Hyperparams: hyperparams,
		TriggeredBy: proto.TriggeredBy,
		CommitHash:  proto.CommitHash,
	}
}

func StartTrainingToProto(domain *models.StartTrainingResponse) *ml_inferencev1.StartTrainingResponse {
	if domain == nil {
		return nil
	}
	return &ml_inferencev1.StartTrainingResponse{
		TrainingRunId: domain.TrainingRunID,
		Status:        domain.Status,
		QueuedAtMs:    domain.QueuedAtMs,
	}
}

func GetTrainingStatusToProto(domain *models.GetTrainingStatusResponse) *ml_inferencev1.GetTrainingStatusResponse {
	if domain == nil {
		return nil
	}

	resp := &ml_inferencev1.GetTrainingStatusResponse{
		TrainingRunId:      domain.TrainingRunID,
		Status:             domain.Status,
		ErrorMessage:       domain.ErrorMessage,
		ModelVersionId:     domain.ModelVersionID,
		StartedAtMs:        domain.StartedAtMs,
		CompletedAtMs:      domain.CompletedAtMs,
		CompletionProgress: domain.CompletionProgress,
	}

	if domain.Metrics != nil {
		resp.Metrics = trainingMetricsToProto(domain.Metrics)
	}

	return resp
}

func trainingMetricsToProto(domain *models.TrainingMetrics) *ml_inferencev1.TrainingMetrics {
	proto := &ml_inferencev1.TrainingMetrics{
		TrainLoss:         domain.TrainLoss,
		ValidationLoss:    domain.ValidationLoss,
		TestLoss:          domain.TestLoss,
		TestMae:           domain.TestMAE,
		TestRmse:          domain.TestRMSE,
		TestCoverageLower: domain.TestCoverageLower,
		TestCoverageUpper: domain.TestCoverageUpper,
		CustomMetrics:     make(map[string]float64),
	}
	if domain.CustomMetrics != nil {
		proto.CustomMetrics = domain.CustomMetrics
	}
	return proto
}

// ============================================================
// Evaluation Mappers
// ============================================================

func ProtoToEvaluateModel(proto *ml_inferencev1.EvaluateModelRequest) *models.EvaluateModelRequest {
	if proto == nil {
		return nil
	}
	return &models.EvaluateModelRequest{
		ModelVersionID: proto.ModelVersionId,
		Dataset:        proto.Dataset,
		VersusModelID:  proto.VersusModelId,
	}
}

func EvaluateModelToProto(domain *models.EvaluateModelResponse) *ml_inferencev1.EvaluateModelResponse {
	if domain == nil {
		return nil
	}

	evals := make([]*ml_inferencev1.ModelEvaluation, len(domain.Evaluations))
	for i, e := range domain.Evaluations {
		evals[i] = &ml_inferencev1.ModelEvaluation{
			ModelVersionId:     e.ModelVersionID,
			VersusModelId:      e.VersusModelID,
			MetricName:         e.MetricName,
			BaselineValue:      e.BaselineValue,
			CandidateValue:     e.CandidateValue,
			ImprovementPercent: e.ImprovementPct,
			MeetsThreshold:     e.MeetsThreshold,
		}
	}

	return &ml_inferencev1.EvaluateModelResponse{
		Evaluations:    evals,
		CandidateWins:  domain.CandidateWins,
		Recommendation: domain.Recommendation,
	}
}

// ============================================================
// Model Versions Mappers
// ============================================================

func ProtoToGetModelVersions(proto *ml_inferencev1.GetModelVersionsRequest) *models.GetModelVersionsRequest {
	if proto == nil {
		return nil
	}

	limit := int(proto.Limit)
	if limit == 0 {
		limit = 10
	}

	return &models.GetModelVersionsRequest{
		TaskType:     proto.TaskType,
		Limit:        limit,
		StatusFilter: proto.StatusFilter,
	}
}

func GetModelVersionsToProto(domain *models.GetModelVersionsResponse) *ml_inferencev1.GetModelVersionsResponse {
	if domain == nil {
		return nil
	}

	versions := make([]*ml_inferencev1.ModelVersionInfo, len(domain.Versions))
	for i, v := range domain.Versions {
		versions[i] = modelVersionInfoToProto(v)
	}

	return &ml_inferencev1.GetModelVersionsResponse{
		Versions: versions,
	}
}

func modelVersionInfoToProto(domain models.ModelVersionInfo) *ml_inferencev1.ModelVersionInfo {
	info := &ml_inferencev1.ModelVersionInfo{
		VersionId:     domain.VersionID,
		TaskType:      domain.TaskType,
		Status:        domain.Status,
		CreatedAtMs:   domain.CreatedAtMs,
		DeployedAtMs:  domain.DeployedAtMs,
		ArtifactPath:  domain.ArtifactPath,
		ArtifactHash:  domain.ArtifactHash,
		SchemaHash:    domain.SchemaHash,
		TrainingRunId: domain.TrainingRunID,
		CommitHash:    domain.CommitHash,
		Metadata:      domain.Metadata,
	}
	if domain.Metrics != nil {
		info.Metrics = trainingMetricsToProto(domain.Metrics)
	}
	return info
}

// ============================================================
// Deployment Mappers
// ============================================================

func ProtoToDeployModel(proto *ml_inferencev1.DeployModelVersionRequest) *models.DeployModelVersionRequest {
	if proto == nil {
		return nil
	}

	policy := models.DeploymentPolicy{
		MinImprovementPercent: proto.Policy.MinImprovementPercent,
		RequireManualApproval: proto.Policy.RequireManualApproval,
		CanaryTrafficPercent:  proto.Policy.CanaryTrafficPercent,
		RollbackThresholdMins: int(proto.Policy.RollbackThresholdMinutes),
		AlertThresholds:       proto.Policy.AlertThresholds,
	}

	return &models.DeployModelVersionRequest{
		ModelVersionID: proto.ModelVersionId,
		Policy:         policy,
		DeployedBy:     proto.DeployedBy,
		ApprovalID:     proto.ApprovalId,
		Notes:          proto.Notes,
	}
}

func DeployModelToProto(domain *models.DeployModelVersionResponse) *ml_inferencev1.DeployModelVersionResponse {
	if domain == nil {
		return nil
	}
	return &ml_inferencev1.DeployModelVersionResponse{
		DeploymentId: domain.DeploymentID,
		Status:       domain.Status,
		DeployedAtMs: domain.DeployedAtMs,
		Message:      domain.Message,
	}
}

// ============================================================
// Active Model Mappers
// ============================================================

func GetActiveModelToProto(domain *models.GetActiveModelVersionResponse) *ml_inferencev1.GetActiveModelVersionResponse {
	if domain == nil {
		return nil
	}

	resp := &ml_inferencev1.GetActiveModelVersionResponse{
		ActiveVersion: modelVersionInfoToProto(domain.ActiveVersion),
	}

	if domain.PreviousVersion != nil {
		resp.PreviousVersion = modelVersionInfoToProto(*domain.PreviousVersion)
	}

	return resp
}

// ============================================================
// Rollback Mappers
// ============================================================

func ProtoToRollback(proto *ml_inferencev1.RollbackModelVersionRequest) *models.RollbackModelVersionRequest {
	if proto == nil {
		return nil
	}
	return &models.RollbackModelVersionRequest{
		TaskType:     proto.TaskType,
		Reason:       proto.Reason,
		RolledBackBy: proto.RolledBackBy,
	}
}

func RollbackToProto(domain *models.RollbackModelVersionResponse) *ml_inferencev1.RollbackModelVersionResponse {
	if domain == nil {
		return nil
	}
	return &ml_inferencev1.RollbackModelVersionResponse{
		ActiveVersionId: domain.ActiveVersionID,
		RolledBackAtMs:  domain.RolledBackAtMs,
		Message:         domain.Message,
	}
}

