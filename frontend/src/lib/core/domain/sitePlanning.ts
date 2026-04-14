import * as polygonClipping from 'polygon-clipping';
import type { MultiPolygon } from 'polygon-clipping';

type PolygonGeometry = {
	type: 'Polygon';
	coordinates: number[][][];
};

type MultiPolygonGeometry = {
	type: 'MultiPolygon';
	coordinates: number[][][][];
};

type PolygonLikeGeometry = PolygonGeometry | MultiPolygonGeometry;

type GeometryFeature = {
	type: 'Feature';
	geometry: PolygonLikeGeometry;
	properties?: Record<string, unknown> | null;
};

type ZoneGeometry = {
	zone_type: string;
	geometry_geojson: string;
};

type MultiPolygonCoordinates = MultiPolygon;

function isLinearRing(value: unknown): value is number[][] {
	return Array.isArray(value) && value.length >= 4 && value.every((point) =>
		Array.isArray(point) && point.length >= 2 && Number.isFinite(point[0]) && Number.isFinite(point[1])
	);
}

function isPolygonGeometry(value: unknown): value is PolygonGeometry {
	return Boolean(
		value &&
		typeof value === 'object' &&
		(value as { type?: string }).type === 'Polygon' &&
		Array.isArray((value as { coordinates?: unknown }).coordinates) &&
		(value as { coordinates: unknown[] }).coordinates.every(isLinearRing)
	);
}

function isMultiPolygonGeometry(value: unknown): value is MultiPolygonGeometry {
	return Boolean(
		value &&
		typeof value === 'object' &&
		(value as { type?: string }).type === 'MultiPolygon' &&
		Array.isArray((value as { coordinates?: unknown }).coordinates) &&
		(value as { coordinates: unknown[] }).coordinates.every(
			(polygon) => Array.isArray(polygon) && polygon.every(isLinearRing)
		)
	);
}

function parsePolygonLikeGeojson(geojson: string): PolygonLikeGeometry | null {
	try {
		const parsed = JSON.parse(geojson) as unknown;
		if (isPolygonGeometry(parsed) || isMultiPolygonGeometry(parsed)) {
			return parsed;
		}
		if (
			parsed &&
			typeof parsed === 'object' &&
			(parsed as GeometryFeature).type === 'Feature' &&
			((parsed as GeometryFeature).geometry?.type === 'Polygon' || (parsed as GeometryFeature).geometry?.type === 'MultiPolygon')
		) {
			const geometry = (parsed as GeometryFeature).geometry;
			if (isPolygonGeometry(geometry) || isMultiPolygonGeometry(geometry)) {
				return geometry;
			}
		}
		return null;
	} catch {
		return null;
	}
}

function toMultiPolygonCoordinates(geometry: PolygonLikeGeometry): MultiPolygonCoordinates {
	return (geometry.type === 'Polygon' ? [geometry.coordinates] : geometry.coordinates) as MultiPolygonCoordinates;
}

function toPolygonGeojsonStrings(geometry: MultiPolygonCoordinates): string[] {
	return geometry
		.filter((polygon) => Array.isArray(polygon) && polygon.length > 0)
		.map((polygon) => JSON.stringify({ type: 'Polygon', coordinates: polygon }));
}

export function buildInfrastructureAwareGenerationAreas(input: {
	baseAreaGeojson: string;
	plannedZones?: ZoneGeometry[];
	exclusionAreaGeojsons?: string[];
}): string[] {
	const baseGeometry = parsePolygonLikeGeojson(input.baseAreaGeojson);
	if (!baseGeometry) {
		return [input.baseAreaGeojson];
	}

	const masks: MultiPolygonCoordinates[] = [];
	for (const zone of input.plannedZones ?? []) {
		if (zone.zone_type === 'panel') {
			continue;
		}

		const geometry = parsePolygonLikeGeojson(zone.geometry_geojson);
		if (geometry) {
			masks.push(toMultiPolygonCoordinates(geometry));
		}
	}

	for (const geojson of input.exclusionAreaGeojsons ?? []) {
		const geometry = parsePolygonLikeGeojson(geojson);
		if (geometry) {
			masks.push(toMultiPolygonCoordinates(geometry));
		}
	}

	if (masks.length === 0) {
		return toPolygonGeojsonStrings(toMultiPolygonCoordinates(baseGeometry));
	}

	const clipped = polygonClipping.difference(toMultiPolygonCoordinates(baseGeometry), ...masks);
	if (!Array.isArray(clipped) || clipped.length === 0) {
		return toPolygonGeojsonStrings(toMultiPolygonCoordinates(baseGeometry));
	}

	const polygons = toPolygonGeojsonStrings(clipped as MultiPolygonCoordinates);
	return polygons.length > 0 ? polygons : toPolygonGeojsonStrings(toMultiPolygonCoordinates(baseGeometry));
}