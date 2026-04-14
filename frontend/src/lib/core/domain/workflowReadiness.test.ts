import { describe, expect, it } from 'vitest';

import { computeLayoutCompleteness, computeLod400Checklist } from './workflowReadiness';

describe('workflow readiness helpers', () => {
	it('reports complete classes with identity samples and coverage', () => {
		const summary = computeLayoutCompleteness({
			layout_id: 'layout-1',
			total_panels: 120,
			total_capacity_kw: 72,
			fill_area_count: 1,
			drawn_road_count: 1,
			components: [
				{
					id: 'inv-1',
					component_type: 'inverter',
					position: { longitude: 77.1, latitude: 12.9, elevation: 840 }
				},
				{
					id: 'tr-1',
					component_type: 'transformer',
					position: { longitude: 77.2, latitude: 12.8, elevation: 838 }
				},
				{
					id: 'cb-1',
					component_type: 'combiner_box',
					position: { longitude: 77.18, latitude: 12.87, elevation: 839 }
				},
				{
					id: 'ss-1',
					component_type: 'substation',
					position: { longitude: 77.16, latitude: 12.85, elevation: 839 }
				}
			],
			entities: [
				{ id: 'route-road-1', type: 'component', properties: { type: 'route', route_type: 'road' } },
				{ id: 'route-cable-1', type: 'component', properties: { type: 'route', route_type: 'cable' } },
				{ id: 'fault-1', type: 'measurement', properties: { fault_identifier: 'F-101' } }
			]
		});

		expect(summary.coverage_percent).toBeGreaterThan(70);
		expect(summary.classes.find((item) => item.key === 'panels')?.status).toBe('complete');
		expect(summary.classes.find((item) => item.key === 'inverters')?.identity_samples[0]).toBe('inv-1');
		expect(summary.classes.find((item) => item.key === 'cabling')?.count).toBe(1);
	});

	it('returns lod blockers when mandatory classes are missing', () => {
		const summary = computeLayoutCompleteness({
			layout_id: 'layout-2',
			total_panels: 0,
			total_capacity_kw: 0,
			fill_area_count: 0,
			drawn_road_count: 0,
			components: [],
			entities: []
		});

		const checklist = computeLod400Checklist(summary, ['layout review pending']);
		expect(checklist.pass).toBe(false);
		expect(checklist.blocker_reasons.some((reason) => reason.includes('Workflow blocker'))).toBe(true);
		expect(checklist.blocker_reasons.some((reason) => reason.includes('Panels evidence is missing'))).toBe(true);
	});
});
