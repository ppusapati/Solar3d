import { AssetService } from '$lib/gen/asset/v1/asset_pb.js';
import {
	CadAnnotationService,
	CadCoreService,
	CadLayerBlockService,
	DrawingRevisionService,
	InteropService,
	PlotSheetService
} from '$lib/gen/drawing/v1/drawing_pb.js';
import { ElectricalService } from '$lib/gen/electrical/v1/electrical_pb.js';
import { ExtendedService } from '$lib/gen/extended/v1/extended_pb.js';
import { GeoService } from '$lib/gen/geo/v1/geo_pb.js';
import { GraphService } from '$lib/gen/graph/v1/graph_pb.js';
import { LayoutService } from '$lib/gen/layout/v1/layout_pb.js';
import { MLInferenceService } from '$lib/gen/ml_inference/v1/ml_inference_pb.js';
import { OptimizationService } from '$lib/gen/optimization/v1/optimization_pb.js';
import { ComputeOrchestrationService } from '$lib/gen/orchestration/v1/orchestration_pb.js';
import { ProtectionService } from '$lib/gen/protection/v1/protection_pb.js';
import { CommissioningService } from '$lib/gen/commissioning/v1/commissioning_pb.js';
import { ProjectService } from '$lib/gen/project/v1/project_pb.js';
import { ReportService } from '$lib/gen/report/v1/report_pb.js';
import { RoutingService } from '$lib/gen/routing/v1/routing_pb.js';
import { SimulationService } from '$lib/gen/simulation/v1/simulation_pb.js';
import { SolarService } from '$lib/gen/solar/v1/solar_pb.js';
import { StructuralService } from '$lib/gen/structural/v1/structural_pb.js';
import { TerrainService } from '$lib/gen/terrain/v1/terrain_pb.js';
import { TransmissionRoutingService } from '$lib/gen/transmission/v1/transmission_pb.js';

import { createApiClient } from './connect';

// Centralized client registry so all backend capabilities are reachable from the frontend.
export const backendClients = {
	project: createApiClient(ProjectService),
	asset: createApiClient(AssetService),
	report: createApiClient(ReportService),
	layout: createApiClient(LayoutService),
	routing: createApiClient(RoutingService),
	transmission: createApiClient(TransmissionRoutingService),
	electrical: createApiClient(ElectricalService),
	simulation: createApiClient(SimulationService),
	terrain: createApiClient(TerrainService),
	orchestration: createApiClient(ComputeOrchestrationService),
	structural: createApiClient(StructuralService),
	protection: createApiClient(ProtectionService),
		commissioning: createApiClient(CommissioningService),
	mlInference: createApiClient(MLInferenceService),
	optimization: createApiClient(OptimizationService),
	solar: createApiClient(SolarService),
	extended: createApiClient(ExtendedService),
	graph: createApiClient(GraphService),
	geo: createApiClient(GeoService),
	drawingRevision: createApiClient(DrawingRevisionService),
	cadCore: createApiClient(CadCoreService),
	cadAnnotation: createApiClient(CadAnnotationService),
	cadLayerBlock: createApiClient(CadLayerBlockService),
	interop: createApiClient(InteropService),
	plotSheet: createApiClient(PlotSheetService)
};
