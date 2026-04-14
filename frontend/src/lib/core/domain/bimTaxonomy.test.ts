import { describe, expect, it } from 'vitest';
import {
	BIM_DISCIPLINE,
	BIM_OBJECT_SEMANTICS,
	BIM_OBJECT_TYPE,
	BIM_RELATIONSHIP_TYPE,
	buildBimEnvelope,
	isAllowedRelationship
} from './bimTaxonomy';

describe('bim taxonomy sprint 2', () => {
	it('defines canonical semantics for required transmission and electrical objects', () => {
		expect(BIM_OBJECT_SEMANTICS[BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR].discipline).toBe(BIM_DISCIPLINE.TRANSMISSION);
		expect(BIM_OBJECT_SEMANTICS[BIM_OBJECT_TYPE.TRANSMISSION_TOWER].discipline).toBe(BIM_DISCIPLINE.TRANSMISSION);
		expect(BIM_OBJECT_SEMANTICS[BIM_OBJECT_TYPE.DC_STRING_SEGMENT].discipline).toBe(BIM_DISCIPLINE.ELECTRICAL);
	});

	it('enforces relationship rules', () => {
		expect(isAllowedRelationship(
			BIM_OBJECT_TYPE.TRANSFORMER_PAD,
			BIM_RELATIONSHIP_TYPE.CONNECTED_TO,
			BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR
		)).toBe(true);

		expect(isAllowedRelationship(
			BIM_OBJECT_TYPE.TRANSMISSION_TOWER,
			BIM_RELATIONSHIP_TYPE.FEEDS,
			BIM_OBJECT_TYPE.PANEL_TABLE
		)).toBe(false);
	});

	it('builds envelope and drops invalid relationships', () => {
		const envelope = buildBimEnvelope({
			objectType: BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR,
			nativeId: 'route-1',
			relationships: [
				{
					relation: BIM_RELATIONSHIP_TYPE.SUPPORTED_BY,
					targetType: BIM_OBJECT_TYPE.TRANSMISSION_TOWER,
					targetId: 'tower-11'
				},
				{
					relation: BIM_RELATIONSHIP_TYPE.FEEDS,
					targetType: BIM_OBJECT_TYPE.PANEL_ROW,
					targetId: 'row-4'
				}
			]
		});

		expect(envelope.objectId).toBe('transmission_corridor:route-1');
		expect(envelope.relationships).toHaveLength(1);
		expect(envelope.relationships[0].targetType).toBe(BIM_OBJECT_TYPE.TRANSMISSION_TOWER);
	});
});
