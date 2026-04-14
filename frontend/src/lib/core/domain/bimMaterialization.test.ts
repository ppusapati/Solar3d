import { describe, expect, it } from 'vitest';
import { buildMaterializationMetadata, buildMaterializationRunId } from './bimMaterialization';

describe('bim materialization contract sprint 4', () => {
	it('builds deterministic run id when explicit run id is supplied', () => {
		const runId = buildMaterializationRunId({
			sourceService: 'transmission-routing-service',
			serviceVersion: 'v1.2.0',
			stage: 'route-materialization',
			runId: 'run-123'
		});
		expect(runId).toBe('run-123');
	});

	it('builds metadata payload with compute provenance', () => {
		const metadata = buildMaterializationMetadata(
			{
				sourceService: 'electrical-service',
				serviceVersion: 'v0.9.1',
				stage: 'network-materialization',
				runId: 'elec-run-1',
				inputFingerprint: 'abc123'
			},
			{
				discipline: 'electrical',
				bimObjectType: 'dc_string_segment',
				bimObjectId: 'dc_string_segment:seg-5',
				bimRelationships: [],
				materializationKind: 'electrical-segment',
				nativeId: 'seg-5'
			},
			{ networkId: 'network-42' }
		);

		expect(metadata.discipline).toBe('electrical');
		expect(metadata.materializationKind).toBe('electrical-segment');
		expect(metadata.compute).toEqual({
			sourceService: 'electrical-service',
			serviceVersion: 'v0.9.1',
			stage: 'network-materialization',
			runId: 'elec-run-1',
			inputFingerprint: 'abc123'
		});
		expect(metadata.networkId).toBe('network-42');
	});
});
