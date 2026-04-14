import {
	ApprovalStatus,
	InstallationMode,
	TransmissionRoutingService,
	VoltageClass,
	type CostBreakdown as ProtoCostBreakdown,
	type CostBookEntry as ProtoCostBookEntry,
	type GovernanceEvent as ProtoGovernanceEvent,
	type RouteScore as ProtoRouteScore,
	type SegmentExplanation as ProtoSegmentExplanation,
	type TowerScheduleEntry as ProtoTowerScheduleEntry,
	type TraceabilityBundle as ProtoTraceabilityBundle,
	type TowerPosition as ProtoTowerPosition,
	type TransmissionRouteExportPack as ProtoTransmissionRouteExportPack,
	type TransmissionRoute as ProtoTransmissionRoute,
	type UndergroundChainageEntry as ProtoUndergroundChainageEntry,
	type Waypoint as ProtoWaypoint
} from '$lib/gen/transmission/v1/transmission_pb.js';

import { createApiClient, timestampToIso } from './connect';

export type VoltageClassValue = '11kv' | '33kv' | '66kv' | '132kv' | '220kv' | '400kv';
export type ApprovalStatusValue = 'draft' | 'engineering_review' | 'approved';

export interface TransmissionWaypoint {
	longitude: number;
	latitude: number;
	elevation: number;
}

export interface TransmissionConstraints {
	min_span_m: number;
	max_span_m: number;
	row_width_m: number;
	max_slope_deg: number;
	max_deflection_deg: number;
	slope_penalty_factor: number;
	turn_penalty_factor: number;
	water_crossing_cost_mult: number;
	road_parallel_discount: number;
	off_road_penalty: number;
	road_buffer_m: number;
}

export interface TransmissionVectorFeature {
	feature_type: string;
	geometry_geojson: string;
	cost_multiplier?: number;
}

export interface TransmissionTowerPosition {
	longitude: number;
	latitude: number;
	elevation: number;
	span_to_next_m: number;
	height_m: number;
}

export interface TransmissionSegmentExplanation {
	from_index: number;
	slope_deg: number;
	land_type: string;
	cost_multiplier: number;
	decision_reason: string;
	installation_mode: 'overhead' | 'underground';
}

export interface TransmissionCostBreakdown {
	conductor_cost: number;
	tower_cost: number;
	row_acquisition_cost: number;
	crossing_premium: number;
	total_cost: number;
	cost_per_km: number;
}

export interface TransmissionRouteScore {
	cost_score: number;
	risk_score: number;
	constructability_score: number;
	schedule_score: number;
	composite_score: number;
	pareto_frontier: boolean;
	recommendation_reason: string;
	dimension_reasons: Record<string, string>;
}

export interface TransmissionGovernanceEvent {
	event_type: string;
	actor: string;
	note: string;
	from_status: ApprovalStatusValue;
	to_status: ApprovalStatusValue;
	occurred_at: string;
}

export interface TransmissionTraceabilityBundle {
	algorithm_version: string;
	input_fingerprint: string;
	route_fingerprint: string;
	regression_signature: string;
	request_snapshot_json: string;
	data_snapshot_id: string;
	approved_at: string;
	approved_by: string;
}

export interface TransmissionTowerScheduleEntry {
	sequence: number;
	longitude: number;
	latitude: number;
	elevation: number;
	span_to_next_m: number;
	height_m: number;
	structure_type: string;
}

export interface TransmissionUndergroundChainageEntry {
	segment_index: number;
	start_chainage_m: number;
	end_chainage_m: number;
	length_m: number;
	reason: string;
}

export interface TransmissionCostBookEntry {
	category: string;
	subcategory: string;
	amount: number;
	basis: string;
}

export interface TransmissionRouteExportPack {
	route: TransmissionRoute;
	tower_schedule: TransmissionTowerScheduleEntry[];
	underground_chainage: TransmissionUndergroundChainageEntry[];
	cost_book: TransmissionCostBookEntry[];
	traceability: TransmissionTraceabilityBundle;
	generated_at: string;
	generated_by: string;
}

export interface TransmissionRoute {
	id: string;
	project_id: string;
	name: string;
	voltage_class: VoltageClassValue;
	path_geojson: string;
	farm_output_point: TransmissionWaypoint;
	grid_injection_point: TransmissionWaypoint;
	tower_positions: TransmissionTowerPosition[];
	distance_m: number;
	cost_breakdown: TransmissionCostBreakdown;
	route_score?: TransmissionRouteScore;
	approval_status: ApprovalStatusValue;
	engineering_reviewed_at: string;
	engineering_reviewed_by: string;
	approved_at: string;
	approved_by: string;
	governance_events: TransmissionGovernanceEvent[];
	segment_explanations: TransmissionSegmentExplanation[];
	route_summary: string;
	created_at: string;
}

export interface TransmissionProgressUpdate {
	phase: string;
	percent_complete: number;
	message: string;
}

export interface CalculateTransmissionInput {
	project_id: string;
	name: string;
	voltage_class: VoltageClassValue;
	farm_output_point: TransmissionWaypoint;
	grid_injection_point: TransmissionWaypoint;
	constraints?: Partial<TransmissionConstraints>;
	vector_features?: TransmissionVectorFeature[];
}

const client = createApiClient(TransmissionRoutingService);

function mapVoltageClass(voltageClass: VoltageClass): VoltageClassValue {
	switch (voltageClass) {
		case VoltageClass.VOLTAGE_CLASS_11KV:
			return '11kv';
		case VoltageClass.VOLTAGE_CLASS_33KV:
			return '33kv';
		case VoltageClass.VOLTAGE_CLASS_HT_66KV:
			return '66kv';
		case VoltageClass.VOLTAGE_CLASS_HT_132KV:
			return '132kv';
		case VoltageClass.VOLTAGE_CLASS_HT_220KV:
			return '220kv';
		case VoltageClass.VOLTAGE_CLASS_HT_400KV:
			return '400kv';
		default:
			return '132kv';
	}
}

function mapApprovalStatus(status: ApprovalStatus): ApprovalStatusValue {
	switch (status) {
		case ApprovalStatus.ENGINEERING_REVIEW:
			return 'engineering_review';
		case ApprovalStatus.APPROVED:
			return 'approved';
		case ApprovalStatus.DRAFT:
		default:
			return 'draft';
	}
}

function voltageClassToProto(voltageClass: VoltageClassValue): VoltageClass {
	switch (voltageClass) {
		case '11kv':
			return VoltageClass.VOLTAGE_CLASS_11KV;
		case '33kv':
			return VoltageClass.VOLTAGE_CLASS_33KV;
		case '66kv':
			return VoltageClass.VOLTAGE_CLASS_HT_66KV;
		case '132kv':
			return VoltageClass.VOLTAGE_CLASS_HT_132KV;
		case '220kv':
			return VoltageClass.VOLTAGE_CLASS_HT_220KV;
		case '400kv':
			return VoltageClass.VOLTAGE_CLASS_HT_400KV;
		default:
			return VoltageClass.VOLTAGE_CLASS_UNSPECIFIED;
	}
}

function mapWaypoint(waypoint?: ProtoWaypoint): TransmissionWaypoint {
	return {
		longitude: waypoint?.longitude ?? 0,
		latitude: waypoint?.latitude ?? 0,
		elevation: waypoint?.elevation ?? 0
	};
}

function mapTowerPosition(position: ProtoTowerPosition): TransmissionTowerPosition {
	return {
		longitude: position.longitude,
		latitude: position.latitude,
		elevation: position.elevation,
		span_to_next_m: position.spanToNextM,
		height_m: position.heightM
	};
}

function mapSegmentExplanation(explanation: ProtoSegmentExplanation): TransmissionSegmentExplanation {
	return {
		from_index: explanation.fromIndex,
		slope_deg: explanation.slopeDeg,
		land_type: explanation.landType,
		cost_multiplier: explanation.costMultiplier,
		decision_reason: explanation.decisionReason,
		installation_mode:
			explanation.installationMode === InstallationMode.UNDERGROUND ? 'underground' : 'overhead'
	};
}

function mapCostBreakdown(cost?: ProtoCostBreakdown): TransmissionCostBreakdown {
	return {
		conductor_cost: cost?.conductorCost ?? 0,
		tower_cost: cost?.towerCost ?? 0,
		row_acquisition_cost: cost?.rowAcquisitionCost ?? 0,
		crossing_premium: cost?.crossingPremium ?? 0,
		total_cost: cost?.totalCost ?? 0,
		cost_per_km: cost?.costPerKm ?? 0
	};
}

function mapRouteScore(score?: ProtoRouteScore): TransmissionRouteScore | undefined {
	if (!score) {
		return undefined;
	}
	return {
		cost_score: score.costScore,
		risk_score: score.riskScore,
		constructability_score: score.constructabilityScore,
		schedule_score: score.scheduleScore,
		composite_score: score.compositeScore,
		pareto_frontier: score.paretoFrontier,
		recommendation_reason: score.recommendationReason,
		dimension_reasons: { ...(score.dimensionReasons ?? {}) }
	};
}

function mapGovernanceEvent(event: ProtoGovernanceEvent): TransmissionGovernanceEvent {
	return {
		event_type: event.eventType,
		actor: event.actor,
		note: event.note,
		from_status: mapApprovalStatus(event.fromStatus),
		to_status: mapApprovalStatus(event.toStatus),
		occurred_at: timestampToIso(event.occurredAt)
	};
}

function mapTraceability(traceability?: ProtoTraceabilityBundle): TransmissionTraceabilityBundle {
	return {
		algorithm_version: traceability?.algorithmVersion ?? '',
		input_fingerprint: traceability?.inputFingerprint ?? '',
		route_fingerprint: traceability?.routeFingerprint ?? '',
		regression_signature: traceability?.regressionSignature ?? '',
		request_snapshot_json: traceability?.requestSnapshotJson ?? '',
		data_snapshot_id: traceability?.dataSnapshotId ?? '',
		approved_at: timestampToIso(traceability?.approvedAt),
		approved_by: traceability?.approvedBy ?? ''
	};
}

function mapTowerScheduleEntry(entry: ProtoTowerScheduleEntry): TransmissionTowerScheduleEntry {
	return {
		sequence: entry.sequence,
		longitude: entry.longitude,
		latitude: entry.latitude,
		elevation: entry.elevation,
		span_to_next_m: entry.spanToNextM,
		height_m: entry.heightM,
		structure_type: entry.structureType
	};
}

function mapUndergroundChainageEntry(entry: ProtoUndergroundChainageEntry): TransmissionUndergroundChainageEntry {
	return {
		segment_index: entry.segmentIndex,
		start_chainage_m: entry.startChainageM,
		end_chainage_m: entry.endChainageM,
		length_m: entry.lengthM,
		reason: entry.reason
	};
}

function mapCostBookEntry(entry: ProtoCostBookEntry): TransmissionCostBookEntry {
	return {
		category: entry.category,
		subcategory: entry.subcategory,
		amount: entry.amount,
		basis: entry.basis
	};
}

function mapExportPack(pack?: ProtoTransmissionRouteExportPack): TransmissionRouteExportPack {
	if (!pack?.route) {
		throw new Error('Transmission route export pack response was empty');
	}
	return {
		route: mapRoute(pack.route),
		tower_schedule: pack.towerSchedule.map(mapTowerScheduleEntry),
		underground_chainage: pack.undergroundChainage.map(mapUndergroundChainageEntry),
		cost_book: pack.costBook.map(mapCostBookEntry),
		traceability: mapTraceability(pack.traceability),
		generated_at: timestampToIso(pack.generatedAt),
		generated_by: pack.generatedBy
	};
}

function mapRoute(route?: ProtoTransmissionRoute): TransmissionRoute {
	if (!route) {
		throw new Error('Transmission route response was empty');
	}

	return {
		id: route.id,
		project_id: route.projectId,
		name: route.name,
		voltage_class: mapVoltageClass(route.voltageClass),
		path_geojson: route.pathGeojson,
		farm_output_point: mapWaypoint(route.farmOutputPoint),
		grid_injection_point: mapWaypoint(route.gridInjectionPoint),
		tower_positions: route.towerPositions.map(mapTowerPosition),
		distance_m: route.distanceM,
		cost_breakdown: mapCostBreakdown(route.costBreakdown),
		route_score: mapRouteScore(route.routeScore),
		approval_status: mapApprovalStatus(route.approvalStatus),
		engineering_reviewed_at: timestampToIso(route.engineeringReviewedAt),
		engineering_reviewed_by: route.engineeringReviewedBy,
		approved_at: timestampToIso(route.approvedAt),
		approved_by: route.approvedBy,
		governance_events: route.governanceEvents.map(mapGovernanceEvent),
		segment_explanations: route.segmentExplanations.map(mapSegmentExplanation),
		route_summary: route.routeSummary,
		created_at: timestampToIso(route.createdAt)
	};
}

function constraintsToProto(constraints?: Partial<TransmissionConstraints>) {
	if (!constraints) {
		return undefined;
	}
	return {
		minSpanM: constraints.min_span_m ?? 0,
		maxSpanM: constraints.max_span_m ?? 0,
		rowWidthM: constraints.row_width_m ?? 0,
		maxSlopeDeg: constraints.max_slope_deg ?? 0,
		maxDeflectionDeg: constraints.max_deflection_deg ?? 0,
		slopePenaltyFactor: constraints.slope_penalty_factor ?? 0,
		turnPenaltyFactor: constraints.turn_penalty_factor ?? 0,
		waterCrossingCostMult: constraints.water_crossing_cost_mult ?? 0,
		roadParallelDiscount: constraints.road_parallel_discount ?? 0,
		offRoadPenalty: constraints.off_road_penalty ?? 0,
		roadBufferM: constraints.road_buffer_m ?? 0
	};
}

function toProtoRequest(input: CalculateTransmissionInput) {
	return {
		projectId: input.project_id,
		name: input.name,
		voltageClass: voltageClassToProto(input.voltage_class),
		farmOutputPoint: {
			longitude: input.farm_output_point.longitude,
			latitude: input.farm_output_point.latitude,
			elevation: input.farm_output_point.elevation
		} as any,
		gridInjectionPoint: {
			longitude: input.grid_injection_point.longitude,
			latitude: input.grid_injection_point.latitude,
			elevation: input.grid_injection_point.elevation
		} as any,
		constraints: constraintsToProto(input.constraints),
		vectorFeatures: (input.vector_features ?? []).map((feature) => ({
			featureType: feature.feature_type,
			geometryGeojson: feature.geometry_geojson,
			costMultiplier: feature.cost_multiplier ?? 0
		}))
	} as any;
}

export const transmissionApi = {
	calculate: async (input: CalculateTransmissionInput) => {
		const response = await client.calculateTransmissionRoute(toProtoRequest(input));
		return { route: mapRoute(response.route) };
	},

	stream: async (
		input: CalculateTransmissionInput,
		onProgress?: (update: TransmissionProgressUpdate) => void
	): Promise<TransmissionRoute> => {
		let finalRoute: TransmissionRoute | null = null;
		for await (const update of client.streamTransmissionRoute({ request: toProtoRequest(input) })) {
			onProgress?.({
				phase: update.phase,
				percent_complete: update.percentComplete,
				message: update.message
			});
			if (update.route) {
				finalRoute = mapRoute(update.route);
			}
		}

		if (!finalRoute) {
			throw new Error('Transmission route stream completed without a route');
		}
		return finalRoute;
	},

	get: async (id: string) => {
		const response = await client.getTransmissionRoute({ id });
		return { route: mapRoute(response.route) };
	},

	list: async (projectId: string) => {
		const response = await client.listTransmissionRoutes({ projectId });
		return { routes: response.routes.map(mapRoute) };
	},

	submitForReview: async (id: string, actor: string, note = '') => {
		const response = await client.submitTransmissionRouteForReview({ id, actor, note });
		return { route: mapRoute(response.route) };
	},

	approve: async (id: string, actor: string, note = '') => {
		const response = await client.approveTransmissionRoute({ id, actor, note });
		return { route: mapRoute(response.route) };
	},

	exportPack: async (id: string, generatedBy: string) => {
		const response = await client.exportTransmissionRoutePack({ id, generatedBy });
		return { pack: mapExportPack(response.pack) };
	},

	delete: async (id: string) => {
		await client.deleteTransmissionRoute({ id });
		return {};
	}
};
