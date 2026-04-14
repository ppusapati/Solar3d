import { describe, it, expect } from 'vitest';
import {
	ELECTRICAL_GROUPING_TYPE,
	ELECTRICAL_TOPOLOGY_RELATIONSHIP,
	isAllowedElectricalGroupingRelationship,
	validateElectricalTopologyParity,
	validateElectricalTopologyQuality,
	buildElectricalNetworkGraph,
	flattenElectricalTopologyToRelationships,
	getElectricalGroupingTreeDepth,
	countElectricalGroupingNodes,
	type ElectricalGroupingNode
} from './bimElectricalTopology';

describe('Electrical Topology & Grouping Semantics', () => {
	describe('Relationship Validation', () => {
		it('should allow valid DC_STRING → MPPT_GROUP feeds_mppt relationship', () => {
			const isValid = isAllowedElectricalGroupingRelationship(
				ELECTRICAL_GROUPING_TYPE.DC_STRING,
				ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_MPPT
			);
			expect(isValid).toBe(true);
		});

		it('should allow valid MPPT_GROUP → INVERTER_ROUTE feeds_inverter relationship', () => {
			const isValid = isAllowedElectricalGroupingRelationship(
				ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
				ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_INVERTER
			);
			expect(isValid).toBe(true);
		});

		it('should allow valid INVERTER_ROUTE → TRANSFORMER_ROUTE feeds_transformer relationship', () => {
			const isValid = isAllowedElectricalGroupingRelationship(
				ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
				ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE,
				ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_TRANSFORMER
			);
			expect(isValid).toBe(true);
		});

		it('should reject invalid DC_STRING → INVERTER_ROUTE relationship', () => {
			const isValid = isAllowedElectricalGroupingRelationship(
				ELECTRICAL_GROUPING_TYPE.DC_STRING,
				ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
				ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_INVERTER
			);
			expect(isValid).toBe(false);
		});

		it('should reject reverse relationships (INVERTER_ROUTE → MPPT_GROUP)', () => {
			const isValid = isAllowedElectricalGroupingRelationship(
				ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
				ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_INVERTER
			);
			expect(isValid).toBe(false);
		});
	});

	describe('Topology Parity Validation', () => {
		it('should validate complete 4-level hierarchy (transformer → inverter → mppt → string)', () => {
			const strings: ElectricalGroupingNode[] = [
				{ groupingId: 'string_1', groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING, childNodes: [], childSegmentIds: ['seg_1'] },
				{ groupingId: 'string_2', groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING, childNodes: [], childSegmentIds: ['seg_2'] }
			];

			const mpptGroups: ElectricalGroupingNode[] = [
				{ groupingId: 'mppt_1', groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP, ownershipLabel: 'controller_1', childNodes: strings }
			];

			const inverterRoutes: ElectricalGroupingNode[] = [
				{ groupingId: 'inv_1', groupingType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE, ownershipLabel: 'inverter_1', childNodes: mpptGroups }
			];

			const transformerRoutes: ElectricalGroupingNode[] = [
				{ groupingId: 'xfmr_1', groupingType: ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE, ownershipLabel: 'transformer_1', childNodes: inverterRoutes }
			];

			const graph = buildElectricalNetworkGraph('net_1', 'Test Network', transformerRoutes);
			const result = validateElectricalTopologyParity(graph);

			expect(result.isValid).toBe(true);
			expect(result.violations).toHaveLength(0);
		});

		it('should reject non-leaf nodes with no children and no segment references', () => {
			const orphanedMppt: ElectricalGroupingNode = {
				groupingId: 'mppt_orphan',
				groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				childNodes: [],
				childSegmentIds: undefined
			};

			const graph = buildElectricalNetworkGraph('net_2', 'Test Network', [orphanedMppt]);
			const result = validateElectricalTopologyParity(graph);

			expect(result.isValid).toBe(false);
			expect(result.violations.length).toBeGreaterThan(0);
			expect(result.violations[0]).toContain('has no children and no segment references');
		});

		it('should reject inverter route containing wrong-type children (e.g., DC_STRING instead of INVERTER_ROUTE)', () => {
			const wrongChild: ElectricalGroupingNode = {
				groupingId: 'string_wrong',
				groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
				childNodes: [],
				childSegmentIds: ['seg_x']
			};

			const inverterWithWrongChild: ElectricalGroupingNode = {
				groupingId: 'inv_bad',
				groupingType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
				childNodes: [wrongChild]
			};

			const graph = buildElectricalNetworkGraph('net_3', 'Test Network', [inverterWithWrongChild]);
			const result = validateElectricalTopologyParity(graph);

			expect(result.isValid).toBe(false);
			expect(result.violations.length).toBeGreaterThan(0);
		});

		it('should allow DC_STRING as leaf node without segment references if child count is zero', () => {
			const dcString: ElectricalGroupingNode = {
				groupingId: 'dc_leaf',
				groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
				childNodes: []
			};

			const graph = buildElectricalNetworkGraph('net_4', 'Test Network', [dcString]);
			const result = validateElectricalTopologyParity(graph);

			// DC_STRING is allowed as leaf even without segment refs (it IS a segment reference container itself)
			expect(result.isValid).toBe(true);
		});
	});

	describe('Network Graph Building & Flattening', () => {
		it('should build network graph and index all nodes for fast lookup', () => {
			const strings: ElectricalGroupingNode[] = [
				{ groupingId: 'str_a', groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING, childNodes: [], childSegmentIds: [] }
			];
			const mppt: ElectricalGroupingNode = {
				groupingId: 'mppt_a',
				groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				childNodes: strings
			};

			const graph = buildElectricalNetworkGraph('net_test', 'Test', [mppt]);

			expect(graph.networkId).toBe('net_test');
			expect(graph.rootGroups).toHaveLength(1);
			expect(graph.allNodes.size).toBe(2); // mppt + string
			expect(graph.allNodes.has('mppt_a')).toBe(true);
			expect(graph.allNodes.has('str_a')).toBe(true);
		});

		it('should flatten hierarchy to emit parent→child relationships', () => {
			const strings: ElectricalGroupingNode[] = [
				{ groupingId: 'str_1', groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING, childNodes: [] },
				{ groupingId: 'str_2', groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING, childNodes: [] }
			];

			const mppts: ElectricalGroupingNode[] = [
				{ groupingId: 'mppt_1', groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP, childNodes: strings }
			];

			const inverters: ElectricalGroupingNode[] = [
				{ groupingId: 'inv_1', groupingType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE, childNodes: mppts }
			];

			const graph = buildElectricalNetworkGraph('net_flat', 'Test', inverters);
			const relationships = flattenElectricalTopologyToRelationships(graph);

			// Should emit: inv_1 → mppt_1, mppt_1 → str_1, mppt_1 → str_2
			expect(relationships).toHaveLength(3);
			expect(relationships[0]).toEqual({
				fromId: 'inv_1',
				fromType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
				toId: 'mppt_1',
				toType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				relation: ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_INVERTER
			});
			expect(relationships[1]).toEqual({
				fromId: 'mppt_1',
				fromType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				toId: 'str_1',
				toType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
				relation: ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_MPPT
			});
		});
	});

	describe('Tree Metrics', () => {
		it('should calculate correct tree depth for 4-level hierarchy', () => {
			const str: ElectricalGroupingNode = { groupingId: 'str', groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING, childNodes: [] };
			const mppt: ElectricalGroupingNode = { groupingId: 'mppt', groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP, childNodes: [str] };
			const inv: ElectricalGroupingNode = { groupingId: 'inv', groupingType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE, childNodes: [mppt] };
			const xfmr: ElectricalGroupingNode = { groupingId: 'xfmr', groupingType: ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE, childNodes: [inv] };

			const depth = getElectricalGroupingTreeDepth(xfmr);
			expect(depth).toBe(4);
		});

		it('should count all nodes including segment references', () => {
			const str1: ElectricalGroupingNode = {
				groupingId: 'str1',
				groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
				childNodes: [],
				childSegmentIds: ['seg_1', 'seg_2']
			};
			const str2: ElectricalGroupingNode = {
				groupingId: 'str2',
				groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
				childNodes: [],
				childSegmentIds: ['seg_3']
			};

			const mppt: ElectricalGroupingNode = {
				groupingId: 'mppt',
				groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
				childNodes: [str1, str2]
			};

			// Count: mppt (1) + str1 (1) + str1's segments (2) + str2 (1) + str2's segments (1) = 6
			const count = countElectricalGroupingNodes(mppt);
			expect(count).toBe(6);
		});

		it('should count single node with no children correctly', () => {
			const alone: ElectricalGroupingNode = {
				groupingId: 'alone',
				groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
				childNodes: []
			};

			const count = countElectricalGroupingNodes(alone);
			expect(count).toBe(1);
		});
	});

	describe('Topology Quality Validation (Sprint 9)', () => {
		it('should pass balanced topology with complete segment coverage', () => {
			const graph = buildElectricalNetworkGraph('net-q1', 'Quality', [
				{
					groupingId: 'inv-1',
					groupingType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
					voltage: 1500,
					childNodes: [
						{
							groupingId: 'mppt-1',
							groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
							voltage: 1500,
							childNodes: [
								{
									groupingId: 'str-1',
									groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
									childNodes: [],
									childSegmentIds: ['seg-1', 'seg-2']
								},
								{
									groupingId: 'str-2',
									groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
									childNodes: [],
									childSegmentIds: ['seg-3', 'seg-4']
								}
							]
						}
					]
				}
			]);

			const result = validateElectricalTopologyQuality(graph, ['seg-1', 'seg-2', 'seg-3', 'seg-4']);
			expect(result.isValid).toBe(true);
			expect(result.violations).toHaveLength(0);
		});

		it('should fail when MPPT dc string segment counts are imbalanced', () => {
			const graph = buildElectricalNetworkGraph('net-q2', 'Quality', [
				{
					groupingId: 'mppt-imbalance',
					groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
					childNodes: [
						{
							groupingId: 'str-a',
							groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
							childNodes: [],
							childSegmentIds: ['seg-a1', 'seg-a2', 'seg-a3']
						},
						{
							groupingId: 'str-b',
							groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
							childNodes: [],
							childSegmentIds: ['seg-b1']
						}
					]
				}
			]);

			const result = validateElectricalTopologyQuality(graph, ['seg-a1', 'seg-a2', 'seg-a3', 'seg-b1']);
			expect(result.isValid).toBe(false);
			expect(result.violations.join(' | ')).toContain('unbalanced dc strings');
		});

		it('should fail when topology misses segment references from materialization payload', () => {
			const graph = buildElectricalNetworkGraph('net-q3', 'Quality', [
				{
					groupingId: 'str-only',
					groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
					childNodes: [],
					childSegmentIds: ['seg-1']
				}
			]);

			const result = validateElectricalTopologyQuality(graph, ['seg-1', 'seg-2']);
			expect(result.isValid).toBe(false);
			expect(result.violations.join(' | ')).toContain('segment:seg-2 is missing from topology references');
		});

		it('should fail when child voltage mismatches parent voltage', () => {
			const graph = buildElectricalNetworkGraph('net-q4', 'Quality', [
				{
					groupingId: 'inv-1',
					groupingType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
					voltage: 1500,
					childNodes: [
						{
							groupingId: 'mppt-1',
							groupingType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
							voltage: 1000,
							childNodes: [
								{
									groupingId: 'str-1',
									groupingType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
									childNodes: [],
									childSegmentIds: ['seg-1']
								}
							]
						}
					]
				}
			]);

			const result = validateElectricalTopologyQuality(graph, ['seg-1']);
			expect(result.isValid).toBe(false);
			expect(result.violations.join(' | ')).toContain('voltage-mismatched children');
		});
	});
});
