import {
	SimulationService,
	SimulationStatus,
	SimulationType,
	type ShadowPolygon as ProtoShadowPolygon,
	type Simulation as ProtoSimulation,
	type SunPosition as ProtoSunPosition
} from '$lib/gen/simulation/v1/simulation_pb.js';

import { createApiClient, isoToTimestamp, timestampToIso } from './connect';

export interface Simulation {
	id: string;
	project_id: string;
	layout_id: string;
	name: string;
	simulation_type: string;
	status: string;
	params: SimulationParams;
	result: SimulationResult | null;
	created_at: string;
	completed_at: string | null;
}

export interface SimulationParams {
	start_time: string;
	end_time: string;
	time_step_minutes: number;
	latitude: number;
	longitude: number;
	include_terrain_shading: boolean;
	include_panel_shading: boolean;
}

export interface SimulationResult {
	total_irradiance_kwh_m2: number;
	annual_yield_kwh: number;
	performance_ratio: number;
	shading_loss_percent: number;
	result_file_path: string;
}

export interface SunPosition {
	azimuth: number;
	elevation: number;
	zenith: number;
	hour_angle: number;
}

export interface ShadowPolygon {
	source_panel_id: string;
	shadow_geojson: string;
	shadow_intensity: number;
}

const client = createApiClient(SimulationService);

function simulationTypeFromProto(simulationType: SimulationType): string {
	switch (simulationType) {
		case SimulationType.SHADOW:
			return 'shadow';
		case SimulationType.IRRADIANCE:
			return 'irradiance';
		case SimulationType.ANNUAL_YIELD:
			return 'yield';
		default:
			return 'irradiance';
	}
}

function simulationTypeToProto(simulationType: string): SimulationType {
	switch (simulationType) {
		case 'shadow':
			return SimulationType.SHADOW;
		case 'yield':
			return SimulationType.ANNUAL_YIELD;
		case 'irradiance':
		default:
			return SimulationType.IRRADIANCE;
	}
}

function simulationStatusFromProto(status: SimulationStatus): string {
	switch (status) {
		case SimulationStatus.PENDING:
			return 'pending';
		case SimulationStatus.RUNNING:
			return 'running';
		case SimulationStatus.COMPLETED:
			return 'completed';
		case SimulationStatus.FAILED:
			return 'failed';
		default:
			return 'pending';
	}
}

function mapSimulation(simulation?: ProtoSimulation): Simulation {
	if (!simulation) {
		throw new Error('Simulation response was empty');
	}

	return {
		id: simulation.id,
		project_id: simulation.projectId,
		layout_id: simulation.layoutId,
		name: simulation.name,
		simulation_type: simulationTypeFromProto(simulation.simulationType),
		status: simulationStatusFromProto(simulation.status),
		params: {
			start_time: timestampToIso(simulation.params?.startTime),
			end_time: timestampToIso(simulation.params?.endTime),
			time_step_minutes: simulation.params?.timeStepMinutes ?? 0,
			latitude: simulation.params?.latitude ?? 0,
			longitude: simulation.params?.longitude ?? 0,
			include_terrain_shading: simulation.params?.includeTerrainShading ?? false,
			include_panel_shading: simulation.params?.includePanelShading ?? false
		},
		result: simulation.result
			? {
					total_irradiance_kwh_m2: simulation.result.totalIrradianceKwhM2,
					annual_yield_kwh: simulation.result.annualYieldKwh,
					performance_ratio: simulation.result.performanceRatio,
					shading_loss_percent: simulation.result.shadingLossPercent,
					result_file_path: simulation.result.resultFilePath
				}
			: null,
		created_at: timestampToIso(simulation.createdAt),
		completed_at: simulation.completedAt ? timestampToIso(simulation.completedAt) : null
	};
}

function mapSunPosition(position?: ProtoSunPosition): SunPosition {
	if (!position) {
		throw new Error('Sun position response was empty');
	}

	return {
		azimuth: position.azimuth,
		elevation: position.elevation,
		zenith: position.zenith,
		hour_angle: position.hourAngle
	};
}

function mapShadow(shadow: ProtoShadowPolygon): ShadowPolygon {
	return {
		source_panel_id: shadow.sourcePanelId,
		shadow_geojson: shadow.shadowGeojson,
		shadow_intensity: shadow.shadowIntensity
	};
}

export const simulationApi = {
	create: async (data: {
		project_id: string;
		layout_id: string;
		name: string;
		simulation_type: string;
		params: SimulationParams;
	}) => {
		const response = await client.createSimulation({
			projectId: data.project_id,
			layoutId: data.layout_id,
			name: data.name,
			simulationType: simulationTypeToProto(data.simulation_type),
			params: {
				startTime: isoToTimestamp(data.params.start_time),
				endTime: isoToTimestamp(data.params.end_time),
				timeStepMinutes: data.params.time_step_minutes,
				latitude: data.params.latitude,
				longitude: data.params.longitude,
				includeTerrainShading: data.params.include_terrain_shading,
				includePanelShading: data.params.include_panel_shading
			}
		});

		return { simulation: mapSimulation(response.simulation) };
	},

	get: async (id: string) => {
		const response = await client.getSimulation({ id });
		return { simulation: mapSimulation(response.simulation) };
	},

	list: async (projectId: string) => {
		const response = await client.listSimulations({ projectId });
		return { simulations: response.simulations.map(mapSimulation) };
	},

	run: async (id: string) => {
		const response = await client.runSimulation({ simulationId: id });
		return { simulation: mapSimulation(response.simulation) };
	},

	getSunPosition: async (lat: number, lon: number, timestamp: string) => {
		const response = await client.getSunPosition({
			latitude: lat,
			longitude: lon,
			timestamp: isoToTimestamp(timestamp)
		});

		return { position: mapSunPosition(response.position) };
	},

	getShadowMap: async (layoutId: string, timestamp: string, lat: number, lon: number) => {
		const response = await client.getShadowMap({
			layoutId,
			timestamp: isoToTimestamp(timestamp),
			latitude: lat,
			longitude: lon
		});

		return {
			shadows: response.shadows.map(mapShadow),
			sun_position: response.sunPosition ? mapSunPosition(response.sunPosition) : null
		};
	},

	delete: async (id: string) => {
		await client.deleteSimulation({ id });
		return {};
	}
};
