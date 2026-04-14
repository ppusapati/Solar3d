import { describe, expect, it } from 'vitest';

import { buildInfrastructureAwareGenerationAreas } from './sitePlanning';

function polygonArea(geojson: string): number {
	const parsed = JSON.parse(geojson) as { type: string; coordinates: number[][][] };
	return parsed.coordinates.reduce((total, ring, index) => {
		let sum = 0;
		for (let i = 0; i < ring.length - 1; i++) {
			const [x1, y1] = ring[i];
			const [x2, y2] = ring[i + 1];
			sum += x1 * y2 - x2 * y1;
		}
		const area = Math.abs(sum) / 2;
		return index === 0 ? total + area : total - area;
	}, 0);
}

describe('site planning helpers', () => {
	it('returns the base polygon when no infrastructure masks are present', () => {
		const base = JSON.stringify({
			type: 'Polygon',
			coordinates: [[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]]]
		});

		const result = buildInfrastructureAwareGenerationAreas({ baseAreaGeojson: base });

		expect(result).toHaveLength(1);
		expect(JSON.parse(result[0])).toEqual(JSON.parse(base));
	});

	it('subtracts infrastructure and exclusion zones from the generation envelope', () => {
		const base = JSON.stringify({
			type: 'Polygon',
			coordinates: [[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]]]
		});
		const inverterZone = JSON.stringify({
			type: 'Polygon',
			coordinates: [[[2, 2], [4, 2], [4, 4], [2, 4], [2, 2]]]
		});
		const exclusionZone = JSON.stringify({
			type: 'Polygon',
			coordinates: [[[6, 6], [8, 6], [8, 8], [6, 8], [6, 6]]]
		});

		const result = buildInfrastructureAwareGenerationAreas({
			baseAreaGeojson: base,
			plannedZones: [
				{ zone_type: 'panel', geometry_geojson: base },
				{ zone_type: 'inverter', geometry_geojson: inverterZone }
			],
			exclusionAreaGeojsons: [exclusionZone]
		});

		expect(result.length).toBeGreaterThan(0);
		const totalArea = result.reduce((sum, polygon) => sum + polygonArea(polygon), 0);
		expect(totalArea).toBeCloseTo(92, 6);
	});
});