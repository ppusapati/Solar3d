import {
	TerrainLayerType,
	TerrainService,
	type TerrainLayer as ProtoTerrainLayer
} from '$lib/gen/terrain/v1/terrain_pb.js';

import { createApiClient, timestampToIso } from './connect';
import { api } from './client';

export interface TerrainLayer {
	id: string;
	project_id: string;
	name: string;
	layer_type: string;
	source_file: string;
	bounds: {
		min_x: number;
		min_y: number;
		max_x: number;
		max_y: number;
	};
	resolution_m: number;
	crs: string;
	min_elevation: number;
	max_elevation: number;
	created_at: string;
}

export interface ElevationGrid {
	width: number;
	height: number;
	elevations: number[];
	min_elevation: number;
	max_elevation: number;
}

export interface TerrainSummary {
	area_sqm: number;
	min_elevation_m: number;
	max_elevation_m: number;
	avg_elevation_m: number;
	elevation_range_m: number;
	flat_area_sqm: number;
	moderate_slope_area_sqm: number;
	steep_area_sqm: number;
	depression_area_sqm: number;
	estimated_trees: number;
}

export interface EarthworkSummary {
	dem_source_layer_id: string;
	grid_width: number;
	grid_height: number;
	cell_area_sqm: number;
	mean_elevation_m: number;
	target_elevation_m: number;
	cut_volume_m3: number;
	fill_volume_m3: number;
	net_volume_m3: number;
	imbalance_volume_m3: number;
	balanced_volume_ratio: number;
	affected_area_sqm: number;
	average_absolute_delta_m: number;
	maximum_absolute_delta_m: number;
	included_cell_count: number;
	clipped_area_sqm: number;
	haul_distance_m: number;
	haul_effort_m3m: number;
	recommended_target_min_m: number;
	recommended_target_max_m: number;
}

export interface TerrainDiffSummary {
	base_layer_id: string;
	compare_layer_id: string;
	overlap_bounds: {
		min_x: number;
		min_y: number;
		max_x: number;
		max_y: number;
	};
	grid_width: number;
	grid_height: number;
	cell_area_sqm: number;
	delta_elevations: number[];
	mean_delta_m: number;
	rms_delta_m: number;
	max_abs_delta_m: number;
	volume_added_m3: number;
	volume_removed_m3: number;
	net_volume_m3: number;
	valid_cell_count: number;
}

export interface GradingPlanCostBreakdown {
	cut_volume_m3: number;
	fill_volume_m3: number;
	fill_demand_m3: number;
	export_volume_m3: number;
	import_volume_m3: number;
	hauled_volume_m3: number;
	haul_distance_m: number;
	haul_effort_m3m: number;
	cut_cost: number;
	fill_cost: number;
	haul_cost: number;
	import_cost: number;
	export_cost: number;
	total_cost: number;
	currency_code: string;
}

export interface GradingPlan {
	dem_layer_id: string;
	target_elevation_m: number;
	mean_elevation_m: number;
	affected_area_sqm: number;
	balanced_volume_ratio: number;
	compaction_factor: number;
	cut_rate_per_m3: number;
	fill_rate_per_m3: number;
	haul_rate_per_m3m: number;
	import_rate_per_m3: number;
	export_rate_per_m3: number;
	cost: GradingPlanCostBreakdown;
}

export interface DemMetrics {
	project_id?: string;
	pending_jobs: number;
	downloading_jobs: number;
	ingesting_jobs: number;
	completed_jobs: number;
	failed_jobs: number;
	cached_tile_count: number;
	cached_bytes: number;
	expired_tile_count: number;
}

type TerrainUploadHttpRequest = {
	project_id: string;
	name: string;
	layer_type: 'DEM' | 'Slope' | 'Aspect' | 'Hillshade';
	source_file: string;
	bounds: {
		min_x: number;
		min_y: number;
		max_x: number;
		max_y: number;
	};
	resolution_m: number;
	crs: string;
	min_elevation: number;
	max_elevation: number;
};

const client = createApiClient(TerrainService);

function terrainLayerTypeFromProto(layerType: TerrainLayerType): string {
	switch (layerType) {
		case TerrainLayerType.DEM:
			return 'DEM';
		case TerrainLayerType.SLOPE:
			return 'Slope';
		case TerrainLayerType.ASPECT:
			return 'Aspect';
		case TerrainLayerType.HILLSHADE:
			return 'Hillshade';
		default:
			return 'DEM';
	}
}

function mapTerrainLayer(layer?: ProtoTerrainLayer): TerrainLayer {
	if (!layer) {
		throw new Error('Terrain layer response was empty');
	}

	return {
		id: layer.id,
		project_id: layer.projectId,
		name: layer.name,
		layer_type: terrainLayerTypeFromProto(layer.layerType),
		source_file: layer.sourceFile,
		bounds: {
			min_x: layer.bounds?.minX ?? 0,
			min_y: layer.bounds?.minY ?? 0,
			max_x: layer.bounds?.maxX ?? 0,
			max_y: layer.bounds?.maxY ?? 0
		},
		resolution_m: layer.resolutionM,
		crs: layer.crs,
		min_elevation: layer.minElevation,
		max_elevation: layer.maxElevation,
		created_at: timestampToIso(layer.createdAt)
	};
}

export const terrainApi = {
	upload: async (projectId: string, name: string, filePath: string) => {
		const response = await client.uploadTerrain({
			projectId,
			name,
			filePath,
			crs: 'EPSG:4326'
		});

		return { layer: mapTerrainLayer(response.layer) };
	},

	get: async (id: string) => {
		const response = await client.getTerrainLayer({ id });
		return { layer: mapTerrainLayer(response.layer) };
	},

	list: async (projectId: string) => {
		const response = await client.listTerrainLayers({ projectId });
		return { layers: response.layers.map(mapTerrainLayer) };
	},

	ensureCopernicusDemLayer: async (
		projectId: string,
		bounds: { min_x: number; min_y: number; max_x: number; max_y: number },
		resolutionM = 30
	) => {
		const existing = await terrainApi.list(projectId);
		const dem = existing.layers.find((layer) => layer.layer_type.toUpperCase() === 'DEM');
		if (dem) {
			return { layer: dem, created: false };
		}

		const sourceFile = `copernicus://dem/geotiff?bbox=${bounds.min_x},${bounds.min_y},${bounds.max_x},${bounds.max_y}&resolution_m=${resolutionM}`;
		const body: TerrainUploadHttpRequest = {
			project_id: projectId,
			name: 'Copernicus DEM (auto)',
			layer_type: 'DEM',
			source_file: sourceFile,
			bounds,
			resolution_m: resolutionM,
			crs: 'EPSG:4326',
			min_elevation: 0,
			max_elevation: 1200
		};

		const layer = await api.post<TerrainLayer>('/api/v1/terrain/layers', body);
		return { layer, created: true };
	},

	getElevation: async (projectId: string, lon: number, lat: number) => {
		const response = await client.getElevation({
			projectId,
			longitude: lon,
			latitude: lat
		});
		return { elevation: response.elevation };
	},

	getElevationGrid: async (
		projectId: string,
		bounds: { min_x: number; min_y: number; max_x: number; max_y: number },
		resolution: number
	) => {
		const response = await client.getElevationGrid({
			projectId,
			bounds: {
				minX: bounds.min_x,
				minY: bounds.min_y,
				maxX: bounds.max_x,
				maxY: bounds.max_y
			},
			resolutionM: resolution
		});

		return {
			width: response.width,
			height: response.height,
			elevations: response.elevations,
			min_elevation: response.minElevation,
			max_elevation: response.maxElevation
		} satisfies ElevationGrid;
	},

	analyzeEarthwork: async (
		terrainLayerId: string,
		params?: {
			target_elevation_m?: number;
			boundary_geojson?: string;
			min_delta_m?: number;
			haul_factor?: number;
			grid_width?: number;
			grid_height?: number;
		}
	) => {
		const response = await client.analyzeEarthwork({
			terrainLayerId,
			targetElevationM: params?.target_elevation_m,
			boundaryGeojson: params?.boundary_geojson ?? '',
			minDeltaM: params?.min_delta_m ?? 0.05,
			haulFactor: params?.haul_factor ?? 1,
			gridWidth: params?.grid_width ?? 0,
			gridHeight: params?.grid_height ?? 0
		});

		return {
			dem_source_layer_id: response.demSourceLayerId,
			grid_width: response.gridWidth,
			grid_height: response.gridHeight,
			cell_area_sqm: response.cellAreaSqm,
			mean_elevation_m: response.meanElevationM,
			target_elevation_m: response.targetElevationM,
			cut_volume_m3: response.cutVolumeM3,
			fill_volume_m3: response.fillVolumeM3,
			net_volume_m3: response.netVolumeM3,
			imbalance_volume_m3: response.imbalanceVolumeM3,
			balanced_volume_ratio: response.balancedVolumeRatio,
			affected_area_sqm: response.affectedAreaSqm,
			average_absolute_delta_m: response.averageAbsoluteDeltaM,
			maximum_absolute_delta_m: response.maximumAbsoluteDeltaM,
			included_cell_count: response.includedCellCount,
			clipped_area_sqm: response.clippedAreaSqm,
			haul_distance_m: response.haulDistanceM,
			haul_effort_m3m: response.haulEffortM3m,
			recommended_target_min_m: response.recommendedTargetMinM,
			recommended_target_max_m: response.recommendedTargetMaxM
		} satisfies EarthworkSummary;
	},

	computeSlope: async (terrainLayerId: string) => {
		const response = await client.computeSlope({ terrainLayerId });
		return { slope_layer: mapTerrainLayer(response.slopeLayer) };
	},

	computeAspect: async (terrainLayerId: string) => {
		const response = await client.computeAspect({ terrainLayerId });
		return { aspect_layer: mapTerrainLayer(response.aspectLayer) };
	},

	analyzeSite: async (
		projectId: string,
		boundaryGeojson: string,
		vegetationDensityPerHectare: number = 180
	) => {
		return api.post<TerrainSummary>('/api/v1/terrain/analyze-site', {
			project_id: projectId,
			boundary_geojson: boundaryGeojson,
			vegetation_density_per_hectare: vegetationDensityPerHectare
		});
	},

	getDemMetrics: async (projectId?: string) => {
		const query = projectId ? `?project_id=${encodeURIComponent(projectId)}` : '';
		return api.get<DemMetrics>(`/api/v1/terrain/dem/metrics${query}`);
	},

	generateGradingPlan: async (
		terrainLayerId: string,
		params?: {
			target_elevation_m?: number;
			boundary_geojson?: string;
			min_delta_m?: number;
			haul_factor?: number;
			grid_width?: number;
			grid_height?: number;
			cut_rate_per_m3?: number;
			fill_rate_per_m3?: number;
			haul_rate_per_m3m?: number;
			import_rate_per_m3?: number;
			export_rate_per_m3?: number;
			compaction_factor?: number;
			currency_code?: string;
		}
	): Promise<GradingPlan> => {
		const response = await client.generateGradingPlan({
			terrainLayerId,
			targetElevationM: params?.target_elevation_m,
			boundaryGeojson: params?.boundary_geojson ?? '',
			minDeltaM: params?.min_delta_m ?? 0.05,
			haulFactor: params?.haul_factor ?? 1,
			gridWidth: params?.grid_width ?? 0,
			gridHeight: params?.grid_height ?? 0,
			cutRatePerM3: params?.cut_rate_per_m3 ?? 0,
			fillRatePerM3: params?.fill_rate_per_m3 ?? 0,
			haulRatePerM3m: params?.haul_rate_per_m3m ?? 0,
			importRatePerM3: params?.import_rate_per_m3 ?? 0,
			exportRatePerM3: params?.export_rate_per_m3 ?? 0,
			compactionFactor: params?.compaction_factor ?? 1,
			currencyCode: params?.currency_code ?? 'USD'
		});

		const c = response.cost;
		return {
			dem_layer_id: response.demLayerId,
			target_elevation_m: response.targetElevationM,
			mean_elevation_m: response.meanElevationM,
			affected_area_sqm: response.affectedAreaSqm,
			balanced_volume_ratio: response.balancedVolumeRatio,
			compaction_factor: response.compactionFactor,
			cut_rate_per_m3: response.cutRatePerM3,
			fill_rate_per_m3: response.fillRatePerM3,
			haul_rate_per_m3m: response.haulRatePerM3m,
			import_rate_per_m3: response.importRatePerM3,
			export_rate_per_m3: response.exportRatePerM3,
			cost: {
				cut_volume_m3: c?.cutVolumeM3 ?? 0,
				fill_volume_m3: c?.fillVolumeM3 ?? 0,
				fill_demand_m3: c?.fillDemandM3 ?? 0,
				export_volume_m3: c?.exportVolumeM3 ?? 0,
				import_volume_m3: c?.importVolumeM3 ?? 0,
				hauled_volume_m3: c?.hauledVolumeM3 ?? 0,
				haul_distance_m: c?.haulDistanceM ?? 0,
				haul_effort_m3m: c?.haulEffortM3m ?? 0,
				cut_cost: c?.cutCost ?? 0,
				fill_cost: c?.fillCost ?? 0,
				haul_cost: c?.haulCost ?? 0,
				import_cost: c?.importCost ?? 0,
				export_cost: c?.exportCost ?? 0,
				total_cost: c?.totalCost ?? 0,
				currency_code: c?.currencyCode ?? 'USD'
			}
		} satisfies GradingPlan;
	},

	diffTerrainLayers: async (
		baseLayerId: string,
		compareLayerId: string,
		params?: { grid_width?: number; grid_height?: number }
	) => {
		const response = await client.diffTerrainLayers({
			baseLayerId,
			compareLayerId,
			gridWidth: params?.grid_width ?? 0,
			gridHeight: params?.grid_height ?? 0
		});

		return {
			base_layer_id: response.baseLayerId,
			compare_layer_id: response.compareLayerId,
			overlap_bounds: {
				min_x: response.overlapBounds?.minX ?? 0,
				min_y: response.overlapBounds?.minY ?? 0,
				max_x: response.overlapBounds?.maxX ?? 0,
				max_y: response.overlapBounds?.maxY ?? 0
			},
			grid_width: response.gridWidth,
			grid_height: response.gridHeight,
			cell_area_sqm: response.cellAreaSqm,
			delta_elevations: response.deltaElevations,
			mean_delta_m: response.meanDeltaM,
			rms_delta_m: response.rmsDeltaM,
			max_abs_delta_m: response.maxAbsDeltaM,
			volume_added_m3: response.volumeAddedM3,
			volume_removed_m3: response.volumeRemovedM3,
			net_volume_m3: response.netVolumeM3,
			valid_cell_count: response.validCellCount
		} satisfies TerrainDiffSummary;
	},

	delete: async (id: string) => {
		await client.deleteTerrainLayer({ id });
		return {};
	}
};
