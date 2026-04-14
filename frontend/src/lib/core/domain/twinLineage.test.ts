import { describe, expect, it } from 'vitest';

import { buildTwinLineageTrail } from './twinLineage';

describe('twin lineage trail', () => {
	it('builds operational-to-design lineage trail when identity and artifact exist', () => {
		const trail = buildTwinLineageTrail({
			telemetry: {
				sensor_id: 'INV-1',
				asset_identity_id: 'identity-1',
				metric: 'AC_POWER_W',
				value: 1200,
				unit: 'W',
				recorded_at: '2026-04-07T10:00:00Z'
			},
			identities: [
				{
					id: 'identity-1',
					twin_id: 'twin-1',
					design_asset_id: 'artifact-1',
					design_asset_type: 'INVERTER',
					physical_serial_number: 'SER-001',
					commissioning_ref: 'IEC-62446-REF',
					created_at: '2026-04-01T09:00:00Z',
					updated_at: '2026-04-02T09:00:00Z'
				}
			],
			artifacts: [
				{
					id: 'artifact-1',
					project_id: 'project-1',
					name: 'As-Built SLD',
					artifact_type: 1,
					storage_url: 'https://example/sld.pdf',
					uploaded_by: 'qa@solar3d.local',
					uploaded_at: '2026-04-02T08:00:00Z',
					description: 'SLD',
					file_size_bytes: 1200n,
					revision: 'REV-A'
				}
			],
			workflowTransitions: [
				{
					id: 'wf-1',
					project_id: 'project-1',
					from_phase: 'APPROVED',
					to_phase: 'COMMISSIONING_READY',
					occurred_at: '2026-04-03T10:00:00Z',
					actor_id: 'qa-lead',
					reason: '',
					is_rollback: false,
					rollback_reason: ''
				}
			]
		});

		expect(trail.map((hop) => hop.stage)).toEqual([
			'Workflow',
			'Operational Event',
			'Asset Identity',
			'Design Revision'
		]);
	});

	it('returns workflow-only trail when telemetry is unavailable', () => {
		const trail = buildTwinLineageTrail({
			telemetry: null,
			identities: [],
			artifacts: [],
			workflowTransitions: [
				{
					id: 'wf-1',
					project_id: 'project-1',
					from_phase: 'TRANSMISSION_READY',
					to_phase: 'APPROVED',
					occurred_at: '2026-04-03T10:00:00Z',
					actor_id: 'reviewer',
					reason: '',
					is_rollback: false,
					rollback_reason: ''
				}
			]
		});
		expect(trail).toHaveLength(1);
		expect(trail[0].stage).toBe('Workflow');
	});
});
