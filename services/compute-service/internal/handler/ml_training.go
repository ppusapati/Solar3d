package handler

import (
	"context"
	"errors"

	"p9e.in/samavaya/solar3d/compute-service/internal/mappers"
	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	ml_inferencev1 "p9e.in/samavaya/solar3d/gen/ml_inference/v1"
	ml_inferencev1connect "p9e.in/samavaya/solar3d/gen/ml_inference/v1/ml_inferencev1connect"
)

// MLTrainingServiceHandler implements connectRPC ML training service
type MLTrainingServiceHandler struct {
	trainingSvc  *service.MLTrainingService
	inferenceSvc *service.MLInferenceService
}

// Verify handler implements interface
var _ ml_inferencev1connect.MLInferenceServiceHandler = (*MLTrainingServiceHandler)(nil)

// NewMLTrainingServiceHandler creates a new handler
func NewMLTrainingServiceHandler(trainingSvc *service.MLTrainingService, inferenceSvc *service.MLInferenceService) *MLTrainingServiceHandler {
	return &MLTrainingServiceHandler{
		trainingSvc:  trainingSvc,
		inferenceSvc: inferenceSvc,
	}
}

// SubmitFeedback handles feedback submission RPC
func (h *MLTrainingServiceHandler) SubmitFeedback(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.SubmitFeedbackRequest],
) (*connect.Response[ml_inferencev1.SubmitFeedbackResponse], error) {
	domainReq := mappers.ProtoToSubmitFeedback(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid feedback request"))
	}

	domainResp, err := h.trainingSvc.SubmitFeedback(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.SubmitFeedbackToProto(domainResp)), nil
}

// StartTraining handles training start RPC
func (h *MLTrainingServiceHandler) StartTraining(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.StartTrainingRequest],
) (*connect.Response[ml_inferencev1.StartTrainingResponse], error) {
	domainReq := mappers.ProtoToStartTraining(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid training request"))
	}

	domainResp, err := h.trainingSvc.StartTraining(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.StartTrainingToProto(domainResp)), nil
}

// GetTrainingStatus handles status query RPC
func (h *MLTrainingServiceHandler) GetTrainingStatus(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.GetTrainingStatusRequest],
) (*connect.Response[ml_inferencev1.GetTrainingStatusResponse], error) {
	domainReq := &models.GetTrainingStatusRequest{
		TrainingRunID: req.Msg.TrainingRunId,
	}

	domainResp, err := h.trainingSvc.GetTrainingStatus(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.GetTrainingStatusToProto(domainResp)), nil
}

// EvaluateModel handles model evaluation RPC
func (h *MLTrainingServiceHandler) EvaluateModel(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.EvaluateModelRequest],
) (*connect.Response[ml_inferencev1.EvaluateModelResponse], error) {
	domainReq := mappers.ProtoToEvaluateModel(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid evaluation request"))
	}

	domainResp, err := h.trainingSvc.EvaluateModel(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.EvaluateModelToProto(domainResp)), nil
}

// GetModelVersions handles model listing RPC
func (h *MLTrainingServiceHandler) GetModelVersions(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.GetModelVersionsRequest],
) (*connect.Response[ml_inferencev1.GetModelVersionsResponse], error) {
	domainReq := mappers.ProtoToGetModelVersions(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid request"))
	}

	domainResp, err := h.trainingSvc.ListModelVersions(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.GetModelVersionsToProto(domainResp)), nil
}

// DeployModelVersion handles deployment RPC
func (h *MLTrainingServiceHandler) DeployModelVersion(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.DeployModelVersionRequest],
) (*connect.Response[ml_inferencev1.DeployModelVersionResponse], error) {
	domainReq := mappers.ProtoToDeployModel(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid deployment request"))
	}

	domainResp, err := h.trainingSvc.DeployModelVersion(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.DeployModelToProto(domainResp)), nil
}

// GetActiveModelVersion handles active model query RPC
func (h *MLTrainingServiceHandler) GetActiveModelVersion(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.GetActiveModelVersionRequest],
) (*connect.Response[ml_inferencev1.GetActiveModelVersionResponse], error) {
	domainResp, err := h.trainingSvc.GetActiveModel(ctx, req.Msg.TaskType)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.GetActiveModelToProto(domainResp)), nil
}

// RollbackModelVersion handles rollback RPC
func (h *MLTrainingServiceHandler) RollbackModelVersion(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.RollbackModelVersionRequest],
) (*connect.Response[ml_inferencev1.RollbackModelVersionResponse], error) {
	domainReq := mappers.ProtoToRollback(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid rollback request"))
	}

	domainResp, err := h.trainingSvc.RollbackModel(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.RollbackToProto(domainResp)), nil
}

// DetectAnomaly delegates inference RPCs to the inference service.
func (h *MLTrainingServiceHandler) DetectAnomaly(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.AnomalyDetectionRequest],
) (*connect.Response[ml_inferencev1.AnomalyDetectionResponse], error) {
	domainReq := mappers.ProtoToAnomalyDetection(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid anomaly detection request"))
	}

	domainResp, err := h.inferenceSvc.DetectAnomaly(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.AnomalyDetectionToProto(domainResp)), nil
}

func (h *MLTrainingServiceHandler) PredictYield(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.YieldPredictionRequest],
) (*connect.Response[ml_inferencev1.YieldPredictionResponse], error) {
	domainReq := mappers.ProtoToYieldPrediction(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid yield prediction request"))
	}

	domainResp, err := h.inferenceSvc.PredictYield(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.YieldPredictionToProto(domainResp)), nil
}

func (h *MLTrainingServiceHandler) ForecastDegradation(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.DegradationRequest],
) (*connect.Response[ml_inferencev1.DegradationResponse], error) {
	domainReq := mappers.ProtoToDegradation(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid degradation request"))
	}

	domainResp, err := h.inferenceSvc.ForecastDegradation(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.DegradationToProto(domainResp)), nil
}

func (h *MLTrainingServiceHandler) ExtractFeatures(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.FeatureExtractionRequest],
) (*connect.Response[ml_inferencev1.FeatureExtractionResponse], error) {
	domainReq := mappers.ProtoToFeatureExtraction(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid feature extraction request"))
	}

	domainResp, err := h.inferenceSvc.ExtractFeatures(ctx, domainReq)
	if err != nil {
		code := connect.CodeInternal
		if domainResp != nil && domainResp.ErrorMessage != "" {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(code, err)
	}

	return connect.NewResponse(mappers.FeatureVectorToProto(domainResp)), nil
}

