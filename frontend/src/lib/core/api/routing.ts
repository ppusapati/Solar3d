import {
	RouteType,
	RoutingService,
	type Route as ProtoRoute,
	type Waypoint as ProtoWaypoint
} from '$lib/gen/routing/v1/routing_pb.js';

import { createApiClient, timestampToIso } from './connect';

export interface Route {
	id: string;
	project_id: string;
	layout_id: string;
	name: string;
	route_type: string;
	waypoints: Waypoint[];
	distance_m: number;
	cost_estimate: number;
	geojson: string;
	created_at: string;
}

export interface Waypoint {
	longitude: number;
	latitude: number;
	elevation: number;
}

export interface RouteConstraints {
	max_slope_percent: number;
	avoid_water: boolean;
	avoidance_zones_geojson: string[];
	slope_penalty: number;
}

const client = createApiClient(RoutingService);

function routeTypeFromProto(routeType: RouteType): string {
	switch (routeType) {
		case RouteType.ACCESS_ROAD:
		case RouteType.SERVICE_ROAD:
			return 'road';
		case RouteType.FENCE:
			return 'fence';
		case RouteType.DC_CABLE:
		case RouteType.AC_CABLE:
		case RouteType.COMMUNICATION:
			return 'cable';
		default:
			return 'cable';
	}
}

function routeTypeToProto(routeType: string): RouteType {
	switch (routeType) {
		case 'road':
			return RouteType.ACCESS_ROAD;
		case 'fence':
			return RouteType.FENCE;
		case 'cable':
		default:
			return RouteType.DC_CABLE;
	}
}

function mapWaypoint(waypoint: ProtoWaypoint): Waypoint {
	return {
		longitude: waypoint.longitude,
		latitude: waypoint.latitude,
		elevation: waypoint.elevation
	};
}

function parseWaypoints(geojson: string): Waypoint[] {
		try {
			const parsed = JSON.parse(geojson) as { coordinates?: number[][] };
			return (parsed.coordinates ?? []).map((coordinate) => ({
				longitude: coordinate[0] ?? 0,
				latitude: coordinate[1] ?? 0,
				elevation: coordinate[2] ?? 0
			}));
		} catch {
			return [];
		}
}

function buildGeoJson(waypoints: Waypoint[]): string {
	return JSON.stringify({
		type: 'LineString',
		coordinates: waypoints.map((waypoint) => [
			waypoint.longitude,
			waypoint.latitude,
			waypoint.elevation
		])
	});
}

function mapRoute(route?: ProtoRoute): Route {
	if (!route) {
		throw new Error('Route response was empty');
	}

	return {
		id: route.id,
		project_id: route.projectId,
		layout_id: '',
		name: route.name,
		route_type: routeTypeFromProto(route.routeType),
		waypoints: parseWaypoints(route.geometryGeojson),
		distance_m: route.distanceM,
		cost_estimate: route.costEstimate,
		geojson: route.geometryGeojson,
		created_at: timestampToIso(route.createdAt)
	};
}

function constraintsToProto(constraints?: RouteConstraints) {
	return {
		maxSlopePercent: constraints?.max_slope_percent ?? 0,
		avoidWater: constraints?.avoid_water ?? false,
		avoidZoneGeojsons: constraints?.avoidance_zones_geojson ?? [],
		terrainSlopePenalty: constraints?.slope_penalty ?? 0
	};
}

export const routingApi = {
	create: async (data: {
		project_id: string;
		layout_id: string;
		name: string;
		route_type: string;
		start: Waypoint;
		end: Waypoint;
		constraints?: RouteConstraints;
	}) => {
		if (data.route_type === 'road') {
			const response = await client.createRoadRoute({
				projectId: data.project_id,
				name: data.name,
				source: data.start,
				destination: data.end,
				roadWidthM: 0,
				constraints: constraintsToProto(data.constraints),
				terrainLayerId: ''
			});
			return { route: mapRoute(response.route) };
		}

		if (data.route_type === 'cable') {
			const response = await client.createCableRoute({
				projectId: data.project_id,
				name: data.name,
				source: data.start,
				destination: data.end,
				cableType: '',
				cableSizeMm2: 0,
				constraints: constraintsToProto(data.constraints),
				terrainLayerId: ''
			});
			return { route: mapRoute(response.route) };
		}

		const calculated = await client.calculateRoute({
			projectId: data.project_id,
			source: data.start,
			destination: data.end,
			routeType: routeTypeToProto(data.route_type),
			constraints: constraintsToProto(data.constraints),
			terrainLayerId: ''
		});
		const waypoints = calculated.waypoints.map(mapWaypoint);
		const created = await client.createRoute({
			projectId: data.project_id,
			name: data.name,
			routeType: routeTypeToProto(data.route_type),
			geometryGeojson: buildGeoJson(waypoints),
			distanceM: calculated.distanceM,
			costEstimate: calculated.costEstimate
		});

		return { route: mapRoute(created.route) };
	},

	get: async (id: string) => {
		const response = await client.getRoute({ id });
		return { route: mapRoute(response.route) };
	},

	list: async (projectId: string) => {
		const response = await client.listRoutes({ projectId });
		return { routes: response.routes.map(mapRoute) };
	},

	optimize: async (projectId: string) => {
		const response = await client.optimizeRoutes({
			projectId,
			routeType: RouteType.UNSPECIFIED
		});
		return { routes: response.optimizedRoutes.map(mapRoute) };
	},

	delete: async (id: string) => {
		await client.deleteRoute({ id });
		return {};
	}
};
