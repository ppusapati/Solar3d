import { describe, expect, it } from 'vitest';
import { buildCadBimMetadata } from './cadStandards';
import { normalizeBimContractMetadata, parseBimContract } from './bimContract';

describe('bim contract sprint 3', () => {
	it('buildCadBimMetadata emits versioned bim envelope contract', () => {
		const metadataJson = buildCadBimMetadata('materialize-route', 'IfcFlowSegment', {
			discipline: 'transmission',
			bimObjectType: 'transmission_corridor',
			bimObjectId: 'transmission_corridor:route-1',
			bimRelationships: [{ relation: 'supported_by', targetType: 'transmission_tower', targetId: 'tower-1' }]
		});
		const parsed = parseBimContract(metadataJson);

		expect(parsed.version).toBe('1.0');
		expect(parsed.envelope?.objectType).toBe('transmission_corridor');
		expect(parsed.envelope?.objectId).toBe('transmission_corridor:route-1');
		expect(parsed.envelope?.discipline).toBe('transmission');
		expect(parsed.envelope?.relationships).toHaveLength(1);
	});

	it('upgrades legacy metadata to v1 contract envelope', () => {
		const legacy = JSON.stringify({
			source: 'frontend-cad-workspace',
			domain: 'cad',
			operation: 'legacy-materialization',
			discipline: 'transmission',
			ifcClass: 'IfcFlowSegment',
			bimObjectType: 'transmission_corridor',
			bimObjectId: 'transmission_corridor:route-legacy'
		});

		const normalized = normalizeBimContractMetadata(legacy);
		const parsed = parseBimContract(normalized);

		expect(parsed.version).toBe('1.0');
		expect(parsed.envelope?.objectType).toBe('transmission_corridor');
		expect(parsed.envelope?.ifcClass).toBe('IfcFlowSegment');
		expect(parsed.envelope?.provenance.operation).toBe('legacy-materialization');
	});

	it('keeps metadata parse-safe even for invalid json input', () => {
		const normalized = normalizeBimContractMetadata('{invalid json');
		const parsed = parseBimContract(normalized);

		expect(parsed.metadata).toEqual({});
		expect(parsed.envelope).toBeUndefined();
	});
});
