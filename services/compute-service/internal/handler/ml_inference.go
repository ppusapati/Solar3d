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

// MLInferenceServiceHandler implements the connectRPC ML inference service
type MLInferenceServiceHandler struct {
	inferenceSvc *service.MLInferenceService
	trainingSvc  *service.MLTrainingService
}

// Verify that MLInferenceServiceHandler implements the interface
var _ ml_inferencev1connect.MLInferenceServiceHandler = (*MLInferenceServiceHandler)(nil)

// NewMLInferenceServiceHandler creates a new handler with injected service
func NewMLInferenceServiceHandler(inferenceSvc *service.MLInferenceService, trainingSvc *service.MLTrainingService) *MLInferenceServiceHandler {
	return &MLInferenceServiceHandler{
		inferenceSvc: inferenceSvc,
		trainingSvc:  trainingSvc,
	}
}

// ExtractFeatures handles the ExtractFeatures RPC
// connectRPC handler -> service layer -> repository layer (Rust) -> response
func (h *MLInferenceServiceHandler) ExtractFeatures(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.FeatureExtractionRequest],
) (*connect.Response[ml_inferencev1.FeatureExtractionResponse], error) {
	// Map proto request to domain model
	domainReq := mappers.ProtoToFeatureExtraction(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument,
			errors.New("invalid feature extraction request"))
	}

	// Call service layer
	domainResp, err := h.inferenceSvc.ExtractFeatures(ctx, domainReq)
	if err != nil {
		// Map domain errors to connectRPC error codes
		code := connect.CodeInternal
		if domainResp != nil && domainResp.ErrorMessage != "" {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(code, err)
	}

	// Map domain response back to proto
	protoResp := mappers.FeatureVectorToProto(domainResp)

	return connect.NewResponse(protoResp), nil
}

// PredictYield handles the PredictYield RPC
func (h *MLInferenceServiceHandler) PredictYield(
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

// DetectAnomaly handles the DetectAnomaly RPC
func (h *MLInferenceServiceHandler) DetectAnomaly(
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

// ForecastDegradation handles the ForecastDegradation RPC
func (h *MLInferenceServiceHandler) ForecastDegradation(
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

// SubmitFeedback delegates training and management RPCs to the training service.
func (h *MLInferenceServiceHandler) SubmitFeedback(
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

func (h *MLInferenceServiceHandler) StartTraining(
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

func (h *MLInferenceServiceHandler) GetTrainingStatus(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.GetTrainingStatusRequest],
) (*connect.Response[ml_inferencev1.GetTrainingStatusResponse], error) {
	domainResp, err := h.trainingSvc.GetTrainingStatus(ctx, &models.GetTrainingStatusRequest{TrainingRunID: req.Msg.TrainingRunId})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.GetTrainingStatusToProto(domainResp)), nil
}

func (h *MLInferenceServiceHandler) EvaluateModel(
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

func (h *MLInferenceServiceHandler) GetModelVersions(
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

func (h *MLInferenceServiceHandler) DeployModelVersion(
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

func (h *MLInferenceServiceHandler) GetActiveModelVersion(
	ctx context.Context,
	req *connect.Request[ml_inferencev1.GetActiveModelVersionRequest],
) (*connect.Response[ml_inferencev1.GetActiveModelVersionResponse], error) {
	domainResp, err := h.trainingSvc.GetActiveModel(ctx, req.Msg.TaskType)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.GetActiveModelToProto(domainResp)), nil
}

func (h *MLInferenceServiceHandler) RollbackModelVersion(
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

