package executor

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"

	"connectrpc.com/connect"
	commissioningv1 "github.com/solar3d/solar3d/gen/commissioning/v1"
	commissioningv1connect "github.com/solar3d/solar3d/gen/commissioning/v1/commissioningv1connect"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"
	geov1 "github.com/solar3d/solar3d/gen/geo/v1"
	geov1connect "github.com/solar3d/solar3d/gen/geo/v1/geov1connect"
	graphv1 "github.com/solar3d/solar3d/gen/graph/v1"
	graphv1connect "github.com/solar3d/solar3d/gen/graph/v1/graphv1connect"
	mlinferencev1 "github.com/solar3d/solar3d/gen/ml_inference/v1"
	mlinferencev1connect "github.com/solar3d/solar3d/gen/ml_inference/v1/ml_inferencev1connect"
	optimizationv1 "github.com/solar3d/solar3d/gen/optimization/v1"
	optimizationv1connect "github.com/solar3d/solar3d/gen/optimization/v1/optimizationv1connect"
	protectionv1 "github.com/solar3d/solar3d/gen/protection/v1"
	protectionv1connect "github.com/solar3d/solar3d/gen/protection/v1/protectionv1connect"
	simulationv1 "github.com/solar3d/solar3d/gen/simulation/v1"
	simulationv1connect "github.com/solar3d/solar3d/gen/simulation/v1/simulationv1connect"
	structuralv1 "github.com/solar3d/solar3d/gen/structural/v1"
	structuralv1connect "github.com/solar3d/solar3d/gen/structural/v1/structuralv1connect"
	"google.golang.org/protobuf/encoding/protojson"

	"solar3d/compute-orchestration-service/internal/domain"
)

type simulationRunner interface {
	RunSimulation(context.Context, *connect.Request[simulationv1.RunSimulationRequest]) (*connect.Response[simulationv1.RunSimulationResponse], error)
}

type optimizationRunner interface {
	ParticleSwarmOptimization(context.Context, *connect.Request[optimizationv1.PSORequest]) (*connect.Response[optimizationv1.PSOResponse], error)
	GeneticAlgorithm(context.Context, *connect.Request[optimizationv1.GARequest]) (*connect.Response[optimizationv1.GAResponse], error)
	MonteCarloSampling(context.Context, *connect.Request[optimizationv1.MonteCarloRequest]) (*connect.Response[optimizationv1.MonteCarloResponse], error)
}

type geoRunner interface {
	BufferPoint(context.Context, *connect.Request[geov1.BufferPointRequest]) (*connect.Response[geov1.BufferPointResponse], error)
	GenerateContours(context.Context, *connect.Request[geov1.GenerateContoursRequest]) (*connect.Response[geov1.GenerateContoursResponse], error)
}

type graphRunner interface {
	MinimumSpanningTree(context.Context, *connect.Request[graphv1.MinimumSpanningTreeRequest]) (*connect.Response[graphv1.MinimumSpanningTreeResponse], error)
	ApproximateSteinerTree(context.Context, *connect.Request[graphv1.ApproximateSteinerTreeRequest]) (*connect.Response[graphv1.ApproximateSteinerTreeResponse], error)
}

type mlInferenceRunner interface {
	PredictYield(context.Context, *connect.Request[mlinferencev1.YieldPredictionRequest]) (*connect.Response[mlinferencev1.YieldPredictionResponse], error)
}

type plotPublisher interface {
	PublishDrawing(context.Context, *connect.Request[drawingv1.PublishDrawingRequest]) (*connect.Response[drawingv1.PublishDrawingResponse], error)
}

type structuralRunner interface {
	ComputeDeadLoad(context.Context, *connect.Request[structuralv1.ComputeDeadLoadRequest]) (*connect.Response[structuralv1.ComputeDeadLoadResponse], error)
	ComputeWindLoad(context.Context, *connect.Request[structuralv1.ComputeWindLoadRequest]) (*connect.Response[structuralv1.ComputeWindLoadResponse], error)
	ComputeSeismicLoad(context.Context, *connect.Request[structuralv1.ComputeSeismicLoadRequest]) (*connect.Response[structuralv1.ComputeSeismicLoadResponse], error)
	ComputeFoundationRequirement(context.Context, *connect.Request[structuralv1.ComputeFoundationRequirementRequest]) (*connect.Response[structuralv1.ComputeFoundationRequirementResponse], error)
	ValidateStructuralDesign(context.Context, *connect.Request[structuralv1.ValidateStructuralDesignRequest]) (*connect.Response[structuralv1.ValidateStructuralDesignResponse], error)
	GenerateStructuralReport(context.Context, *connect.Request[structuralv1.GenerateStructuralReportRequest]) (*connect.Response[structuralv1.GenerateStructuralReportResponse], error)
}

type protectionRunner interface {
	ComputeShortCircuit(context.Context, *connect.Request[protectionv1.ComputeShortCircuitRequest]) (*connect.Response[protectionv1.ComputeShortCircuitResponse], error)
	ComputeEarthFault(context.Context, *connect.Request[protectionv1.ComputeEarthFaultRequest]) (*connect.Response[protectionv1.ComputeEarthFaultResponse], error)
	SelectRelay(context.Context, *connect.Request[protectionv1.SelectRelayRequest]) (*connect.Response[protectionv1.SelectRelayResponse], error)
	ComputeRelaySettings(context.Context, *connect.Request[protectionv1.ComputeRelaySettingsRequest]) (*connect.Response[protectionv1.ComputeRelaySettingsResponse], error)
	ValidateCoordination(context.Context, *connect.Request[protectionv1.ValidateCoordinationRequest]) (*connect.Response[protectionv1.ValidateCoordinationResponse], error)
	GenerateProtectionReport(context.Context, *connect.Request[protectionv1.GenerateProtectionReportRequest]) (*connect.Response[protectionv1.GenerateProtectionReportResponse], error)
}

type commissioningRunner interface {
	CreateChecklist(context.Context, *connect.Request[commissioningv1.CreateChecklistRequest]) (*connect.Response[commissioningv1.CreateChecklistResponse], error)
	UpdateChecklistItem(context.Context, *connect.Request[commissioningv1.UpdateChecklistItemRequest]) (*connect.Response[commissioningv1.UpdateChecklistItemResponse], error)
	SignOffChecklist(context.Context, *connect.Request[commissioningv1.SignOffChecklistRequest]) (*connect.Response[commissioningv1.SignOffChecklistResponse], error)
	CreateHandover(context.Context, *connect.Request[commissioningv1.CreateHandoverRequest]) (*connect.Response[commissioningv1.CreateHandoverResponse], error)
	RecordAsBuilt(context.Context, *connect.Request[commissioningv1.RecordAsBuiltRequest]) (*connect.Response[commissioningv1.RecordAsBuiltResponse], error)
	GenerateCommissioningReport(context.Context, *connect.Request[commissioningv1.GenerateCommissioningReportRequest]) (*connect.Response[commissioningv1.GenerateCommissioningReportResponse], error)
}

type Endpoints struct {
	ComputeBaseURL      string
	GeoServiceURL       string
	GraphServiceURL     string
	OptimizationURL     string
	SimulationURL       string
	MLInferenceURL      string
	PlotSheetServiceURL string
	StructuralURL       string
	ProtectionURL       string
	CommissioningURL    string // CommissioningURL is the URL of the commissioning service.
}

type ComputeExecutor struct {
	simulationClient    simulationRunner
	optimizationClient  optimizationRunner
	geoClient           geoRunner
	graphClient         graphRunner
	mlClient            mlInferenceRunner
	plotClient          plotPublisher
	structuralClient    structuralRunner
	protectionClient    protectionRunner
	commissioningClient commissioningRunner // commissioningClient is the client for commissioning services.
}

func NewComputeExecutor(endpoints Endpoints, httpClient *http.Client) *ComputeExecutor {
	baseComputeURL := strings.TrimSpace(endpoints.ComputeBaseURL)
	if baseComputeURL == "" {
		baseComputeURL = "http://127.0.0.1:50051"
	}
	if httpClient == nil {
		httpClient = &http.Client{Timeout: 45 * time.Second}
	}

	geoURL := firstNonEmpty(endpoints.GeoServiceURL, baseComputeURL)
	graphURL := firstNonEmpty(endpoints.GraphServiceURL, baseComputeURL)
	optimizationURL := firstNonEmpty(endpoints.OptimizationURL, baseComputeURL)
	simulationURL := firstNonEmpty(endpoints.SimulationURL, baseComputeURL)
	mlURL := firstNonEmpty(endpoints.MLInferenceURL, baseComputeURL)
	plotURL := firstNonEmpty(endpoints.PlotSheetServiceURL, baseComputeURL)
	structuralURL := firstNonEmpty(endpoints.StructuralURL, baseComputeURL)
	protectionURL := firstNonEmpty(endpoints.ProtectionURL, baseComputeURL)
	commissioningURL := firstNonEmpty(endpoints.CommissioningURL, baseComputeURL)

	return &ComputeExecutor{
		simulationClient:    simulationv1connect.NewSimulationServiceClient(httpClient, simulationURL),
		optimizationClient:  optimizationv1connect.NewOptimizationServiceClient(httpClient, optimizationURL),
		geoClient:           geov1connect.NewGeoServiceClient(httpClient, geoURL),
		graphClient:         graphv1connect.NewGraphServiceClient(httpClient, graphURL),
		mlClient:            mlinferencev1connect.NewMLInferenceServiceClient(httpClient, mlURL),
		plotClient:          drawingv1connect.NewPlotSheetServiceClient(httpClient, plotURL),
		structuralClient:    structuralv1connect.NewStructuralServiceClient(httpClient, structuralURL),
		protectionClient:    protectionv1connect.NewProtectionServiceClient(httpClient, protectionURL),
		commissioningClient: commissioningv1connect.NewCommissioningServiceClient(httpClient, commissioningURL),
	}
}

func (e *ComputeExecutor) Execute(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	switch job.Type {
	case domain.JobTypeSimulation:
		return e.executeSimulation(ctx, job)
	case domain.JobTypeOptimization:
		return e.executeOptimization(ctx, job)
	case domain.JobTypePublish:
		return e.executePublish(ctx, job)
	case domain.JobTypeStructural:
		return e.executeStructuralStudy(ctx, job)
	case domain.JobTypeProtection:
		return e.executeProtectionStudy(ctx, job)
	case domain.JobTypeCommissioning:
		return e.executeCommissioningWorkflow(ctx, job)
	case domain.JobTypeCustom:
		return e.executeAdvancedAnalyticsWorkflow(ctx, job)
	default:
		return nil, fmt.Errorf("unsupported job type for compute adapter: %s", job.Type)
	}
}

func (e *ComputeExecutor) executeStructuralStudy(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload structuralWorkflowInput
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid structural payload: %w", err)
	}
	if err := payload.validate(); err != nil {
		return nil, err
	}

	var body []byte
	var err error
	switch payload.Operation {
	case "compute_dead_load":
		resp, rpcErr := e.structuralClient.ComputeDeadLoad(ctx, connect.NewRequest(&structuralv1.ComputeDeadLoadRequest{
			DesignId:               payload.DesignID,
			PanelCount:             payload.PanelCount,
			PanelMassKg:            payload.PanelMassKg,
			MountingMassPerPanelKg: payload.MountingMassPerPanelKg,
			CableMassKg:            payload.CableMassKg,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("structural compute dead load rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "compute_wind_load":
		resp, rpcErr := e.structuralClient.ComputeWindLoad(ctx, connect.NewRequest(&structuralv1.ComputeWindLoadRequest{
			DesignId:          payload.DesignID,
			WindSpeedMS:       payload.WindSpeedMS,
			Exposure:          structuralv1.ExposureCategory(payload.Exposure),
			HeightM:           payload.HeightM,
			PanelTiltDeg:      payload.PanelTiltDeg,
			TotalPanelAreaSqm: payload.TotalPanelAreaSqm,
			KZt:               payload.KZt,
			KD:                payload.KD,
			GustFactor:        payload.GustFactor,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("structural compute wind load rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "compute_seismic_load":
		resp, rpcErr := e.structuralClient.ComputeSeismicLoad(ctx, connect.NewRequest(&structuralv1.ComputeSeismicLoadRequest{
			DesignId:         payload.DesignID,
			Sds:              payload.Sds,
			TotalMassKg:      payload.TotalMassKg,
			RFactor:          payload.RFactor,
			ImportanceFactor: payload.ImportanceFactor,
			CsOverride:       payload.CsOverride,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("structural compute seismic load rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "compute_foundation":
		resp, rpcErr := e.structuralClient.ComputeFoundationRequirement(ctx, connect.NewRequest(&structuralv1.ComputeFoundationRequirementRequest{
			DesignId:       payload.DesignID,
			DeadLoadKn:     payload.DeadLoadKn,
			WindLoadKn:     payload.WindLoadKn,
			SeismicLoadKn:  payload.SeismicLoadKn,
			FoundationType: structuralv1.FoundationType(payload.FoundationType),
			PileCapacityKn: payload.PileCapacityKn,
			TotalAreaSqm:   payload.TotalAreaSqm,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("structural compute foundation rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "validate":
		resp, rpcErr := e.structuralClient.ValidateStructuralDesign(ctx, connect.NewRequest(&structuralv1.ValidateStructuralDesignRequest{
			DesignId:              payload.DesignID,
			MaxWindPressurePa:     payload.MaxWindPressurePa,
			MaxSeismicCoefficient: payload.MaxSeismicCoefficient,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("structural validate rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "generate_report":
		resp, rpcErr := e.structuralClient.GenerateStructuralReport(ctx, connect.NewRequest(&structuralv1.GenerateStructuralReportRequest{DesignId: payload.DesignID}))
		if rpcErr != nil {
			return nil, fmt.Errorf("structural report rpc failed: %w", rpcErr)
		}
		body = []byte(resp.Msg.GetReportText())
	default:
		return nil, fmt.Errorf("unsupported structural operation: %s", payload.Operation)
	}
	if err != nil {
		return nil, fmt.Errorf("marshal structural response failed: %w", err)
	}
	return []domain.Artifact{makeArtifact("structural_"+payload.Operation, fmt.Sprintf("inline://structural/%s/%s", job.ID, payload.Operation), body)}, nil
}

func (e *ComputeExecutor) executeProtectionStudy(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload protectionWorkflowInput
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid protection payload: %w", err)
	}
	if err := payload.validate(); err != nil {
		return nil, err
	}

	var body []byte
	var err error
	switch payload.Operation {
	case "short_circuit":
		resp, rpcErr := e.protectionClient.ComputeShortCircuit(ctx, connect.NewRequest(&protectionv1.ComputeShortCircuitRequest{
			StudyId:                   payload.StudyID,
			VoltageKv:                 payload.VoltageKv,
			SourceImpedanceOhm:        payload.SourceImpedanceOhm,
			CableResistanceOhm:        payload.CableResistanceOhm,
			CableReactanceOhm:         payload.CableReactanceOhm,
			ZeroSeqImpedanceOhm:       payload.ZeroSeqImpedanceOhm,
			IncludeSingleLineToGround: payload.IncludeSingleLineToGround,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("protection short-circuit rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "earth_fault":
		resp, rpcErr := e.protectionClient.ComputeEarthFault(ctx, connect.NewRequest(&protectionv1.ComputeEarthFaultRequest{
			StudyId:            payload.StudyID,
			VoltageKv:          payload.VoltageKv,
			EarthingMethod:     protectionv1.NeutralEarthing(payload.EarthingMethod),
			NgrResistanceOhm:   payload.NgrResistanceOhm,
			CableResistanceOhm: payload.CableResistanceOhm,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("protection earth-fault rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "select_relay":
		resp, rpcErr := e.protectionClient.SelectRelay(ctx, connect.NewRequest(&protectionv1.SelectRelayRequest{
			StudyId:                 payload.StudyID,
			FaultCurrentKa:          payload.FaultCurrentKa,
			LoadCurrentA:            payload.LoadCurrentA,
			PreferredCharacteristic: protectionv1.RelayCharacteristic(payload.PreferredCharacteristic),
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("protection select-relay rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "relay_settings":
		resp, rpcErr := e.protectionClient.ComputeRelaySettings(ctx, connect.NewRequest(&protectionv1.ComputeRelaySettingsRequest{
			StudyId:         payload.StudyID,
			Characteristic:  protectionv1.RelayCharacteristic(payload.Characteristic),
			PickupCurrentA:  payload.PickupCurrentA,
			TimeDialSetting: payload.TimeDialSetting,
			FaultCurrentA:   payload.FaultCurrentA,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("protection relay-settings rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "validate_coordination":
		pairs := make([]*protectionv1.CoordinationPair, 0, len(payload.Pairs))
		for _, pair := range payload.Pairs {
			pairs = append(pairs, &protectionv1.CoordinationPair{
				UpstreamRelayId:   pair.UpstreamRelayID,
				DownstreamRelayId: pair.DownstreamRelayID,
				UpstreamTimeS:     pair.UpstreamTimeS,
				DownstreamTimeS:   pair.DownstreamTimeS,
				MarginS:           pair.MarginS,
			})
		}
		resp, rpcErr := e.protectionClient.ValidateCoordination(ctx, connect.NewRequest(&protectionv1.ValidateCoordinationRequest{
			StudyId:        payload.StudyID,
			Pairs:          pairs,
			MinimumMarginS: payload.MinimumMarginS,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("protection validate-coordination rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "generate_report":
		resp, rpcErr := e.protectionClient.GenerateProtectionReport(ctx, connect.NewRequest(&protectionv1.GenerateProtectionReportRequest{StudyId: payload.StudyID}))
		if rpcErr != nil {
			return nil, fmt.Errorf("protection report rpc failed: %w", rpcErr)
		}
		body = []byte(resp.Msg.GetReportText())
	default:
		return nil, fmt.Errorf("unsupported protection operation: %s", payload.Operation)
	}
	if err != nil {
		return nil, fmt.Errorf("marshal protection response failed: %w", err)
	}
	return []domain.Artifact{makeArtifact("protection_"+payload.Operation, fmt.Sprintf("inline://protection/%s/%s", job.ID, payload.Operation), body)}, nil
}

func (e *ComputeExecutor) executeSimulation(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload struct {
		SimulationID string `json:"simulation_id"`
	}
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid simulation payload: %w", err)
	}
	if strings.TrimSpace(payload.SimulationID) == "" {
		return nil, fmt.Errorf("simulation payload requires simulation_id")
	}

	resp, err := e.simulationClient.RunSimulation(ctx, connect.NewRequest(&simulationv1.RunSimulationRequest{SimulationId: payload.SimulationID}))
	if err != nil {
		return nil, fmt.Errorf("run simulation rpc failed: %w", err)
	}
	resultPath := ""
	if resp.Msg.GetSimulation() != nil && resp.Msg.GetSimulation().GetResult() != nil {
		resultPath = resp.Msg.GetSimulation().GetResult().GetResultFilePath()
	}
	if strings.TrimSpace(resultPath) == "" {
		resultPath = fmt.Sprintf("inline://simulation/%s/result.json", job.ID)
	}
	checksum := sha256.Sum256([]byte(resultPath))
	return []domain.Artifact{{
		Kind:      "simulation_result",
		URI:       resultPath,
		Checksum:  "sha256:" + hex.EncodeToString(checksum[:]),
		SizeBytes: int64(len(resultPath)),
	}}, nil
}

func (e *ComputeExecutor) executeOptimization(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload optimizationWorkflowInput
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid optimization payload: %w", err)
	}
	method, resultJSON, _, err := e.runOptimization(ctx, &payload)
	if err != nil {
		return nil, err
	}
	return []domain.Artifact{makeArtifact("optimization_result", fmt.Sprintf("inline://optimization/%s/%s.json", job.ID, method), resultJSON)}, nil
}

func (e *ComputeExecutor) executePublish(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload publishWorkflowInput
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid publish payload: %w", err)
	}
	if err := payload.validate(); err != nil {
		return nil, err
	}

	publishResp, err := e.plotClient.PublishDrawing(ctx, connect.NewRequest(&drawingv1.PublishDrawingRequest{
		DrawingId:  payload.DrawingID,
		RevisionId: payload.RevisionID,
		SheetIds:   payload.SheetIDs,
		Format:     parsePlotFormat(payload.PublishFormat),
		Options:    payload.PublishOptions,
	}))
	if err != nil {
		return nil, fmt.Errorf("publish drawing rpc failed: %w", err)
	}

	artifacts := make([]domain.Artifact, 0, len(publishResp.Msg.GetArtifacts())+1)
	manifest := []byte(publishResp.Msg.GetManifestJson())
	if len(manifest) > 0 {
		artifacts = append(artifacts, makeArtifact("publish_manifest", fmt.Sprintf("inline://publish/%s/manifest.json", job.ID), manifest))
	}
	for i, a := range publishResp.Msg.GetArtifacts() {
		content := a.GetPayload()
		if len(content) == 0 {
			content = []byte(a.GetFileName())
		}
		artifacts = append(artifacts, makeArtifact("published_sheet", fmt.Sprintf("artifact://publish/%s/%d/%s", job.ID, i, safeSegment(a.GetFileName())), content))
	}
	return artifacts, nil
}

func (e *ComputeExecutor) executeAdvancedAnalyticsWorkflow(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload advancedAnalyticsWorkflowPayload
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid advanced workflow payload: %w", err)
	}
	if err := payload.validate(); err != nil {
		return nil, err
	}

	artifacts := make([]domain.Artifact, 0, len(payload.SheetIDs)+8)

	geoResp, err := e.geoClient.BufferPoint(ctx, connect.NewRequest(&geov1.BufferPointRequest{
		Center:   payload.Geo.Center,
		Radius:   payload.Geo.Radius,
		Segments: payload.Geo.segmentsOrDefault(),
	}))
	if err != nil {
		return nil, fmt.Errorf("geo buffer rpc failed: %w", err)
	}
	geoJSON, err := protojson.Marshal(geoResp.Msg)
	if err != nil {
		return nil, fmt.Errorf("marshal geo response failed: %w", err)
	}
	artifacts = append(artifacts, makeArtifact("geo_buffer", fmt.Sprintf("inline://workflow/%s/geo_buffer.json", job.ID), geoJSON))

	if contour := payload.Geo.Contours; contour != nil {
		contourResp, contourErr := e.geoClient.GenerateContours(ctx, connect.NewRequest(contour))
		if contourErr != nil {
			return nil, fmt.Errorf("geo contour rpc failed: %w", contourErr)
		}
		contourJSON, marshalErr := protojson.Marshal(contourResp.Msg)
		if marshalErr != nil {
			return nil, fmt.Errorf("marshal contour response failed: %w", marshalErr)
		}
		artifacts = append(artifacts, makeArtifact("geo_contours", fmt.Sprintf("inline://workflow/%s/geo_contours.json", job.ID), contourJSON))
	}

	var graphJSON []byte
	if payload.Graph.UseSteiner {
		resp, steinerErr := e.graphClient.ApproximateSteinerTree(ctx, connect.NewRequest(&graphv1.ApproximateSteinerTreeRequest{
			NodeCount: payload.Graph.NodeCount,
			Edges:     payload.Graph.Edges,
			Terminals: payload.Graph.Terminals,
		}))
		if steinerErr != nil {
			return nil, fmt.Errorf("graph steiner rpc failed: %w", steinerErr)
		}
		graphJSON, err = protojson.Marshal(resp.Msg)
	} else {
		resp, mstErr := e.graphClient.MinimumSpanningTree(ctx, connect.NewRequest(&graphv1.MinimumSpanningTreeRequest{
			NodeCount: payload.Graph.NodeCount,
			Edges:     payload.Graph.Edges,
		}))
		if mstErr != nil {
			return nil, fmt.Errorf("graph mst rpc failed: %w", mstErr)
		}
		graphJSON, err = protojson.Marshal(resp.Msg)
	}
	if err != nil {
		return nil, fmt.Errorf("marshal graph response failed: %w", err)
	}
	artifacts = append(artifacts, makeArtifact("graph_topology", fmt.Sprintf("inline://workflow/%s/graph_topology.json", job.ID), graphJSON))

	method, optimizationJSON, optimizationScore, err := e.runOptimization(ctx, payload.Optimization)
	if err != nil {
		return nil, err
	}
	artifacts = append(artifacts, makeArtifact("optimization_result", fmt.Sprintf("inline://workflow/%s/optimization_%s.json", job.ID, method), optimizationJSON))

	simulationResp, err := e.simulationClient.RunSimulation(ctx, connect.NewRequest(&simulationv1.RunSimulationRequest{SimulationId: payload.Simulation.SimulationID}))
	if err != nil {
		return nil, fmt.Errorf("run simulation rpc failed: %w", err)
	}
	simJSON, err := protojson.Marshal(simulationResp.Msg)
	if err != nil {
		return nil, fmt.Errorf("marshal simulation response failed: %w", err)
	}
	artifacts = append(artifacts, makeArtifact("simulation_result", fmt.Sprintf("inline://workflow/%s/simulation_result.json", job.ID), simJSON))

	mlReq := payload.ML.toRequest(simulationResp.Msg.GetSimulation(), optimizationScore)
	mlResp, err := e.mlClient.PredictYield(ctx, connect.NewRequest(mlReq))
	if err != nil {
		return nil, fmt.Errorf("ml predict_yield rpc failed: %w", err)
	}
	mlJSON, err := protojson.Marshal(mlResp.Msg)
	if err != nil {
		return nil, fmt.Errorf("marshal ml response failed: %w", err)
	}
	artifacts = append(artifacts, makeArtifact("ml_yield_prediction", fmt.Sprintf("inline://workflow/%s/ml_yield_prediction.json", job.ID), mlJSON))

	publishReq := &drawingv1.PublishDrawingRequest{
		DrawingId:  payload.DrawingID,
		RevisionId: payload.RevisionID,
		SheetIds:   payload.SheetIDs,
		Format:     parsePlotFormat(payload.PublishFormat),
		Options:    payload.PublishOptions,
	}
	publishResp, err := e.plotClient.PublishDrawing(ctx, connect.NewRequest(publishReq))
	if err != nil {
		return nil, fmt.Errorf("publish drawing rpc failed: %w", err)
	}

	manifest := []byte(publishResp.Msg.GetManifestJson())
	if len(manifest) > 0 {
		artifacts = append(artifacts, makeArtifact("publish_manifest", fmt.Sprintf("inline://workflow/%s/publish_manifest.json", job.ID), manifest))
	}
	for i, published := range publishResp.Msg.GetArtifacts() {
		payloadBytes := published.GetPayload()
		if len(payloadBytes) == 0 {
			payloadBytes = []byte(published.GetFileName())
		}
		artifacts = append(artifacts, makeArtifact("published_sheet", fmt.Sprintf("artifact://workflow/%s/sheet/%d/%s", job.ID, i, safeSegment(published.GetFileName())), payloadBytes))
	}

	summary := map[string]any{
		"workflow":                payload.Workflow,
		"project_id":              payload.ProjectID,
		"job_id":                  job.ID,
		"optimization_method":     method,
		"optimization_best_score": optimizationScore,
		"simulation_id":           payload.Simulation.SimulationID,
		"predicted_yield_kwh":     mlResp.Msg.GetForecast().GetPredictedYieldKwh(),
		"published_sheet_count":   len(publishResp.Msg.GetArtifacts()),
	}
	summaryJSON, err := json.Marshal(summary)
	if err != nil {
		return nil, fmt.Errorf("marshal workflow summary failed: %w", err)
	}
	artifacts = append(artifacts, makeArtifact("workflow_summary", fmt.Sprintf("inline://workflow/%s/summary.json", job.ID), summaryJSON))

	return artifacts, nil
}

func (e *ComputeExecutor) runOptimization(ctx context.Context, payload *optimizationWorkflowInput) (method string, resultJSON []byte, bestScore float64, err error) {
	if payload == nil {
		payload = &optimizationWorkflowInput{}
	}
	method = strings.ToLower(strings.TrimSpace(payload.Method))
	if method == "" {
		method = "pso"
	}

	switch method {
	case "pso", "particle_swarm", "particle_swarm_optimization":
		req := payload.PSO
		if req == nil {
			req = &optimizationv1.PSORequest{NumParticles: 32, Iterations: 50, C1: 1.2, C2: 1.2, W: 0.5, BoundaryMin: 0, BoundaryMax: 1}
		}
		resp, rpcErr := e.optimizationClient.ParticleSwarmOptimization(ctx, connect.NewRequest(req))
		if rpcErr != nil {
			return "", nil, 0, fmt.Errorf("pso rpc failed: %w", rpcErr)
		}
		resultJSON, err = protojson.Marshal(resp.Msg)
		bestScore = resp.Msg.GetBestValue()
	case "ga", "genetic_algorithm":
		req := payload.GA
		if req == nil {
			req = &optimizationv1.GARequest{PopulationSize: 32, Generations: 20, CrossoverRate: 0.7, MutationRate: 0.1, EliteCount: 2}
		}
		resp, rpcErr := e.optimizationClient.GeneticAlgorithm(ctx, connect.NewRequest(req))
		if rpcErr != nil {
			return "", nil, 0, fmt.Errorf("ga rpc failed: %w", rpcErr)
		}
		resultJSON, err = protojson.Marshal(resp.Msg)
		bestScore = resp.Msg.GetBestFitness()
	case "monte_carlo", "mc":
		req := payload.MonteCarlo
		if req == nil {
			req = &optimizationv1.MonteCarloRequest{NumSamples: 100}
		}
		resp, rpcErr := e.optimizationClient.MonteCarloSampling(ctx, connect.NewRequest(req))
		if rpcErr != nil {
			return "", nil, 0, fmt.Errorf("monte_carlo rpc failed: %w", rpcErr)
		}
		resultJSON, err = protojson.Marshal(resp.Msg)
		bestScore = resp.Msg.GetP50()
	default:
		return "", nil, 0, fmt.Errorf("unsupported optimization method: %s", method)
	}
	if err != nil {
		return "", nil, 0, fmt.Errorf("marshal optimization response failed: %w", err)
	}
	return method, resultJSON, bestScore, nil
}

type advancedAnalyticsWorkflowPayload struct {
	Workflow       string                     `json:"workflow"`
	ProjectID      string                     `json:"project_id"`
	DrawingID      string                     `json:"drawing_id"`
	RevisionID     string                     `json:"revision_id"`
	SheetIDs       []string                   `json:"sheet_ids"`
	PublishFormat  string                     `json:"publish_format"`
	PublishOptions *drawingv1.PlotOptions     `json:"publish_options"`
	Geo            *geoWorkflowInput          `json:"geo"`
	Graph          *graphWorkflowInput        `json:"graph"`
	Optimization   *optimizationWorkflowInput `json:"optimization"`
	Simulation     *simulationWorkflowInput   `json:"simulation"`
	ML             *mlWorkflowInput           `json:"ml"`
}

func (p *advancedAnalyticsWorkflowPayload) validate() error {
	workflow := strings.ToLower(strings.TrimSpace(p.Workflow))
	if workflow == "" {
		workflow = "advanced_analytics_v1"
	}
	if workflow != "advanced_analytics_v1" {
		return fmt.Errorf("unsupported custom workflow: %s", p.Workflow)
	}
	if strings.TrimSpace(p.ProjectID) == "" {
		return fmt.Errorf("advanced workflow requires project_id")
	}
	if strings.TrimSpace(p.DrawingID) == "" {
		return fmt.Errorf("advanced workflow requires drawing_id")
	}
	if strings.TrimSpace(p.RevisionID) == "" {
		return fmt.Errorf("advanced workflow requires revision_id")
	}
	if len(p.SheetIDs) == 0 {
		return fmt.Errorf("advanced workflow requires at least one sheet_id")
	}
	for _, id := range p.SheetIDs {
		if strings.TrimSpace(id) == "" {
			return fmt.Errorf("advanced workflow sheet_ids cannot contain empty values")
		}
	}
	if parsePlotFormat(p.PublishFormat) == drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_UNSPECIFIED {
		return fmt.Errorf("advanced workflow publish_format is invalid: %s", p.PublishFormat)
	}
	if p.Geo == nil {
		return fmt.Errorf("advanced workflow requires geo input")
	}
	if err := p.Geo.validate(); err != nil {
		return err
	}
	if p.Graph == nil {
		return fmt.Errorf("advanced workflow requires graph input")
	}
	if err := p.Graph.validate(); err != nil {
		return err
	}
	if p.Optimization == nil {
		return fmt.Errorf("advanced workflow requires optimization input")
	}
	if p.Simulation == nil {
		return fmt.Errorf("advanced workflow requires simulation input")
	}
	if err := p.Simulation.validate(); err != nil {
		return err
	}
	if p.ML == nil {
		return fmt.Errorf("advanced workflow requires ml input")
	}
	return nil
}

type geoWorkflowInput struct {
	Center   *geov1.Point2D                 `json:"center"`
	Radius   float64                        `json:"radius"`
	Segments int32                          `json:"segments"`
	Contours *geov1.GenerateContoursRequest `json:"contours"`
}

func (g *geoWorkflowInput) validate() error {
	if g.Center == nil {
		return fmt.Errorf("advanced workflow geo.center is required")
	}
	if g.Radius <= 0 {
		return fmt.Errorf("advanced workflow geo.radius must be > 0")
	}
	if g.Contours != nil {
		if g.Contours.GetWidth() <= 0 || g.Contours.GetHeight() <= 0 {
			return fmt.Errorf("advanced workflow geo.contours width and height must be > 0 when provided")
		}
		if g.Contours.GetInterval() <= 0 {
			return fmt.Errorf("advanced workflow geo.contours interval must be > 0 when provided")
		}
	}
	return nil
}

func (g *geoWorkflowInput) segmentsOrDefault() int32 {
	if g.Segments < 8 {
		return 32
	}
	return g.Segments
}

type graphWorkflowInput struct {
	NodeCount  int32                `json:"node_count"`
	Edges      []*graphv1.GraphEdge `json:"edges"`
	UseSteiner bool                 `json:"use_steiner"`
	Terminals  []int32              `json:"terminals"`
}

func (g *graphWorkflowInput) validate() error {
	if g.NodeCount < 2 {
		return fmt.Errorf("advanced workflow graph.node_count must be >= 2")
	}
	if len(g.Edges) == 0 {
		return fmt.Errorf("advanced workflow graph.edges is required")
	}
	if g.UseSteiner && len(g.Terminals) == 0 {
		return fmt.Errorf("advanced workflow graph.terminals is required when use_steiner=true")
	}
	return nil
}

type optimizationWorkflowInput struct {
	Method     string                            `json:"method"`
	PSO        *optimizationv1.PSORequest        `json:"pso"`
	GA         *optimizationv1.GARequest         `json:"ga"`
	MonteCarlo *optimizationv1.MonteCarloRequest `json:"monte_carlo"`
}

type simulationWorkflowInput struct {
	SimulationID string `json:"simulation_id"`
}

func (s *simulationWorkflowInput) validate() error {
	if strings.TrimSpace(s.SimulationID) == "" {
		return fmt.Errorf("advanced workflow simulation.simulation_id is required")
	}
	return nil
}

type mlWorkflowInput struct {
	FeatureNames []string  `json:"feature_names"`
	Features     []float64 `json:"features"`
}

func (m *mlWorkflowInput) toRequest(sim *simulationv1.Simulation, optimizationScore float64) *mlinferencev1.YieldPredictionRequest {
	if len(m.Features) > 0 {
		return &mlinferencev1.YieldPredictionRequest{
			Features: &mlinferencev1.FeatureVector{Features: m.Features, FeatureNames: m.FeatureNames},
		}
	}
	yieldKwh := 0.0
	if sim != nil && sim.GetResult() != nil {
		yieldKwh = sim.GetResult().GetAnnualYieldKwh()
	}
	defaultFeatures := []float64{yieldKwh, optimizationScore, 1.0}
	return &mlinferencev1.YieldPredictionRequest{
		Features: &mlinferencev1.FeatureVector{Features: defaultFeatures, FeatureNames: []string{"annual_yield_kwh", "optimization_score", "workflow_bias"}},
	}
}

type publishWorkflowInput struct {
	DrawingID      string                 `json:"drawing_id"`
	RevisionID     string                 `json:"revision_id"`
	SheetIDs       []string               `json:"sheet_ids"`
	PublishFormat  string                 `json:"publish_format"`
	PublishOptions *drawingv1.PlotOptions `json:"publish_options"`
}

type structuralWorkflowInput struct {
	Operation              string  `json:"operation"`
	DesignID               string  `json:"design_id"`
	PanelCount             int32   `json:"panel_count"`
	PanelMassKg            float64 `json:"panel_mass_kg"`
	MountingMassPerPanelKg float64 `json:"mounting_mass_per_panel_kg"`
	CableMassKg            float64 `json:"cable_mass_kg"`
	WindSpeedMS            float64 `json:"wind_speed_m_s"`
	Exposure               int32   `json:"exposure"`
	HeightM                float64 `json:"height_m"`
	PanelTiltDeg           float64 `json:"panel_tilt_deg"`
	TotalPanelAreaSqm      float64 `json:"total_panel_area_sqm"`
	KZt                    float64 `json:"k_zt"`
	KD                     float64 `json:"k_d"`
	GustFactor             float64 `json:"gust_factor"`
	Sds                    float64 `json:"sds"`
	TotalMassKg            float64 `json:"total_mass_kg"`
	RFactor                float64 `json:"r_factor"`
	ImportanceFactor       float64 `json:"importance_factor"`
	CsOverride             float64 `json:"cs_override"`
	DeadLoadKn             float64 `json:"dead_load_kn"`
	WindLoadKn             float64 `json:"wind_load_kn"`
	SeismicLoadKn          float64 `json:"seismic_load_kn"`
	FoundationType         int32   `json:"foundation_type"`
	PileCapacityKn         float64 `json:"pile_capacity_kn"`
	TotalAreaSqm           float64 `json:"total_area_sqm"`
	MaxWindPressurePa      float64 `json:"max_wind_pressure_pa"`
	MaxSeismicCoefficient  float64 `json:"max_seismic_coefficient"`
}

func (p *structuralWorkflowInput) validate() error {
	p.Operation = strings.ToLower(strings.TrimSpace(p.Operation))
	if p.Operation == "" {
		return fmt.Errorf("structural payload requires operation")
	}
	if strings.TrimSpace(p.DesignID) == "" {
		return fmt.Errorf("structural payload requires design_id")
	}
	return nil
}

type protectionWorkflowInput struct {
	Operation                 string                         `json:"operation"`
	StudyID                   string                         `json:"study_id"`
	VoltageKv                 float64                        `json:"voltage_kv"`
	SourceImpedanceOhm        float64                        `json:"source_impedance_ohm"`
	CableResistanceOhm        float64                        `json:"cable_resistance_ohm"`
	CableReactanceOhm         float64                        `json:"cable_reactance_ohm"`
	ZeroSeqImpedanceOhm       float64                        `json:"zero_seq_impedance_ohm"`
	IncludeSingleLineToGround bool                           `json:"include_single_line_to_ground"`
	EarthingMethod            int32                          `json:"earthing_method"`
	NgrResistanceOhm          float64                        `json:"ngr_resistance_ohm"`
	FaultCurrentKa            float64                        `json:"fault_current_ka"`
	LoadCurrentA              float64                        `json:"load_current_a"`
	PreferredCharacteristic   int32                          `json:"preferred_characteristic"`
	Characteristic            int32                          `json:"characteristic"`
	PickupCurrentA            float64                        `json:"pickup_current_a"`
	TimeDialSetting           float64                        `json:"time_dial_setting"`
	FaultCurrentA             float64                        `json:"fault_current_a"`
	Pairs                     []protectionCoordinationPairIn `json:"pairs"`
	MinimumMarginS            float64                        `json:"minimum_margin_s"`
}

type protectionCoordinationPairIn struct {
	UpstreamRelayID   string  `json:"upstream_relay_id"`
	DownstreamRelayID string  `json:"downstream_relay_id"`
	UpstreamTimeS     float64 `json:"upstream_time_s"`
	DownstreamTimeS   float64 `json:"downstream_time_s"`
	MarginS           float64 `json:"margin_s"`
}

func (p *protectionWorkflowInput) validate() error {
	p.Operation = strings.ToLower(strings.TrimSpace(p.Operation))
	if p.Operation == "" {
		return fmt.Errorf("protection payload requires operation")
	}
	if strings.TrimSpace(p.StudyID) == "" {
		return fmt.Errorf("protection payload requires study_id")
	}
	return nil
}

func (p *publishWorkflowInput) validate() error {
	if strings.TrimSpace(p.DrawingID) == "" {
		return fmt.Errorf("publish payload requires drawing_id")
	}
	if strings.TrimSpace(p.RevisionID) == "" {
		return fmt.Errorf("publish payload requires revision_id")
	}
	if len(p.SheetIDs) == 0 {
		return fmt.Errorf("publish payload requires at least one sheet_id")
	}
	for _, id := range p.SheetIDs {
		if strings.TrimSpace(id) == "" {
			return fmt.Errorf("publish payload sheet_ids cannot contain empty values")
		}
	}
	if parsePlotFormat(p.PublishFormat) == drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_UNSPECIFIED {
		return fmt.Errorf("publish payload publish_format is invalid: %s", p.PublishFormat)
	}
	return nil
}

func makeArtifact(kind, uri string, content []byte) domain.Artifact {
	checksum := sha256.Sum256(content)
	return domain.Artifact{
		Kind:      kind,
		URI:       uri,
		Checksum:  "sha256:" + hex.EncodeToString(checksum[:]),
		SizeBytes: int64(len(content)),
	}
}

func parsePlotFormat(raw string) drawingv1.PlotOutputFormat {
	value := strings.ToLower(strings.TrimSpace(raw))
	switch value {
	case "", "svg", "plot_output_format_svg":
		return drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_SVG
	case "pdf", "plot_output_format_pdf":
		return drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_PDF
	default:
		return drawingv1.PlotOutputFormat_PLOT_OUTPUT_FORMAT_UNSPECIFIED
	}
}

func firstNonEmpty(values ...string) string {
	for _, value := range values {
		trimmed := strings.TrimSpace(value)
		if trimmed != "" {
			return trimmed
		}
	}
	return ""
}

func safeSegment(value string) string {
	trimmed := strings.TrimSpace(value)
	if trimmed == "" {
		return "artifact.bin"
	}
	var parts []string
	for _, segment := range strings.FieldsFunc(trimmed, func(r rune) bool {
		return r == '/' || r == '\\' || r == ':' || r == ' ' || r == '\t' || r == '\n' || r == '\r'
	}) {
		if segment != "" {
			parts = append(parts, segment)
		}
	}
	if len(parts) == 0 {
		return "artifact.bin"
	}
	return strings.Join(parts, "_")
}

func (e *ComputeExecutor) executeCommissioningWorkflow(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	var payload commissioningWorkflowInput
	if err := json.Unmarshal([]byte(job.PayloadJSON), &payload); err != nil {
		return nil, fmt.Errorf("invalid commissioning payload: %w", err)
	}
	if err := payload.validate(); err != nil {
		return nil, err
	}

	var (
		body []byte
		err  error
	)
	switch payload.Operation {
	case "create_checklist":
		resp, rpcErr := e.commissioningClient.CreateChecklist(ctx, connect.NewRequest(&commissioningv1.CreateChecklistRequest{
			ProjectId: payload.ProjectID,
			Name:      payload.ChecklistName,
			CreatedBy: payload.CreatedBy,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("commissioning create_checklist rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "update_item":
		resp, rpcErr := e.commissioningClient.UpdateChecklistItem(ctx, connect.NewRequest(&commissioningv1.UpdateChecklistItemRequest{
			ItemId:      payload.ItemID,
			Status:      commissioningv1.ChecklistItemStatus(payload.ItemStatus),
			CompletedBy: payload.CompletedBy,
			Notes:       payload.Notes,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("commissioning update_item rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "signoff":
		resp, rpcErr := e.commissioningClient.SignOffChecklist(ctx, connect.NewRequest(&commissioningv1.SignOffChecklistRequest{
			ChecklistId: payload.ChecklistID,
			SignedBy:    payload.SignedBy,
			Role:        payload.Role,
			Comments:    payload.Comments,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("commissioning signoff rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "create_handover":
		resp, rpcErr := e.commissioningClient.CreateHandover(ctx, connect.NewRequest(&commissioningv1.CreateHandoverRequest{
			ProjectId:    payload.ProjectID,
			ChecklistId:  payload.ChecklistID,
			HandedOverBy: payload.HandedOverBy,
			ReceivedBy:   payload.ReceivedBy,
			Notes:        payload.Notes,
			ArtifactIds:  payload.ArtifactIDs,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("commissioning create_handover rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "record_as_built":
		resp, rpcErr := e.commissioningClient.RecordAsBuilt(ctx, connect.NewRequest(&commissioningv1.RecordAsBuiltRequest{
			ProjectId:     payload.ProjectID,
			Name:          payload.ArtifactName,
			ArtifactType:  commissioningv1.AsBuiltArtifactType(payload.ArtifactType),
			StorageUrl:    payload.StorageURL,
			UploadedBy:    payload.UploadedBy,
			Description:   payload.Description,
			FileSizeBytes: payload.FileSizeBytes,
			Revision:      payload.Revision,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("commissioning record_as_built rpc failed: %w", rpcErr)
		}
		body, err = protojson.Marshal(resp.Msg)
	case "generate_report":
		resp, rpcErr := e.commissioningClient.GenerateCommissioningReport(ctx, connect.NewRequest(&commissioningv1.GenerateCommissioningReportRequest{
			ChecklistId: payload.ChecklistID,
		}))
		if rpcErr != nil {
			return nil, fmt.Errorf("commissioning generate_report rpc failed: %w", rpcErr)
		}
		body = []byte(resp.Msg.GetReportText())
	default:
		return nil, fmt.Errorf("unsupported commissioning operation: %s", payload.Operation)
	}

	if err != nil {
		return nil, fmt.Errorf("marshal commissioning response: %w", err)
	}
	return []domain.Artifact{makeArtifact("commissioning_"+payload.Operation, fmt.Sprintf("inline://commissioning/%s/%s", job.ID, payload.Operation), body)}, nil
}

type commissioningWorkflowInput struct {
	Operation     string   `json:"operation"`
	ProjectID     string   `json:"project_id"`
	ChecklistID   string   `json:"checklist_id"`
	ChecklistName string   `json:"checklist_name"`
	CreatedBy     string   `json:"created_by"`
	ItemID        string   `json:"item_id"`
	ItemStatus    int32    `json:"item_status"`
	CompletedBy   string   `json:"completed_by"`
	Notes         string   `json:"notes"`
	SignedBy      string   `json:"signed_by"`
	Role          string   `json:"role"`
	Comments      string   `json:"comments"`
	HandedOverBy  string   `json:"handed_over_by"`
	ReceivedBy    string   `json:"received_by"`
	ArtifactIDs   []string `json:"artifact_ids"`
	ArtifactName  string   `json:"artifact_name"`
	ArtifactType  int32    `json:"artifact_type"`
	StorageURL    string   `json:"storage_url"`
	UploadedBy    string   `json:"uploaded_by"`
	Description   string   `json:"description"`
	FileSizeBytes int64    `json:"file_size_bytes"`
	Revision      string   `json:"revision"`
}

func (p *commissioningWorkflowInput) validate() error {
	p.Operation = strings.ToLower(strings.TrimSpace(p.Operation))
	if p.Operation == "" {
		return fmt.Errorf("commissioning payload requires operation")
	}
	switch p.Operation {
	case "create_checklist":
		if strings.TrimSpace(p.ProjectID) == "" {
			return fmt.Errorf("commissioning create_checklist requires project_id")
		}
		if strings.TrimSpace(p.ChecklistName) == "" {
			return fmt.Errorf("commissioning create_checklist requires checklist_name")
		}
	case "update_item":
		if strings.TrimSpace(p.ItemID) == "" {
			return fmt.Errorf("commissioning update_item requires item_id")
		}
	case "record_as_built":
		if strings.TrimSpace(p.ProjectID) == "" {
			return fmt.Errorf("commissioning record_as_built requires project_id")
		}
		if strings.TrimSpace(p.ArtifactName) == "" {
			return fmt.Errorf("commissioning record_as_built requires artifact_name")
		}
		if strings.TrimSpace(p.StorageURL) == "" {
			return fmt.Errorf("commissioning record_as_built requires storage_url")
		}
	case "signoff", "create_handover", "generate_report":
		if strings.TrimSpace(p.ChecklistID) == "" {
			return fmt.Errorf("commissioning %s requires checklist_id", p.Operation)
		}
	}
	return nil
}
