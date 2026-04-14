/**
 * Sprint 8: Electrical Deepening - Topology & Grouping Semantics
 *
 * Defines electrical grouping hierarchy:
 * - DC String: Collection of panels in series configuration
 * - MPPT Group: Collection of DC strings fed by same MPPT controller
 * - Inverter Route: Collection of MPPT groups feeding same inverter
 * - Transformer Route: Collection of inverter routes feeding same transformer
 *
 * Relationship hierarchy enforces data integrity:
 * - FEEDS_MPPT: DC_STRING → MPPT_GROUP
 * - FEEDS_INVERTER: MPPT_GROUP → INVERTER_ROUTE
 * - FEEDS_TRANSFORMER: INVERTER_ROUTE → TRANSFORMER_ROUTE
 * - CONTAINS: Higher-level routes contain lower-level components
 */

import { BIM_OBJECT_TYPE, BIM_RELATIONSHIP_TYPE, type BimObjectType, type BimRelationshipType } from './bimTaxonomy';

export const ELECTRICAL_GROUPING_TYPE = {
	DC_STRING: 'dc_string',
	MPPT_GROUP: 'mppt_group',
	INVERTER_ROUTE: 'inverter_route',
	TRANSFORMER_ROUTE: 'transformer_route'
} as const;

export type ElectricalGroupingType = (typeof ELECTRICAL_GROUPING_TYPE)[keyof typeof ELECTRICAL_GROUPING_TYPE];

export const ELECTRICAL_TOPOLOGY_RELATIONSHIP = {
	FEEDS_MPPT: 'feeds_mppt',
	FEEDS_INVERTER: 'feeds_inverter',
	FEEDS_TRANSFORMER: 'feeds_transformer',
	CONTAINED_IN: 'contained_in'
} as const;

export type ElectricalTopologyRelationship = (typeof ELECTRICAL_TOPOLOGY_RELATIONSHIP)[keyof typeof ELECTRICAL_TOPOLOGY_RELATIONSHIP];

/**
 * Electrical topology grouping rule: validates parent-child legality
 */
export interface ElectricalGroupingRule {
	fromType: ElectricalGroupingType;
	toType: ElectricalGroupingType;
	relation: ElectricalTopologyRelationship;
	description: string;
}

/**
 * Canonical grouping rules enforcing string → MPPT → inverter → transformer hierarchy
 */
export const ELECTRICAL_GROUPING_RULES: ElectricalGroupingRule[] = [
	{
		fromType: ELECTRICAL_GROUPING_TYPE.DC_STRING,
		toType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
		relation: ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_MPPT,
		description: 'DC strings feed into MPPT groups'
	},
	{
		fromType: ELECTRICAL_GROUPING_TYPE.MPPT_GROUP,
		toType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
		relation: ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_INVERTER,
		description: 'MPPT groups feed into inverter routes'
	},
	{
		fromType: ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE,
		toType: ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE,
		relation: ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_TRANSFORMER,
		description: 'Inverter routes feed into transformer routes'
	}
];

/**
 * Electrical topology node: represents a grouping construct in the hierarchy
 */
export interface ElectricalGroupingNode {
	groupingId: string;
	groupingType: ElectricalGroupingType;
	ownershipLabel?: string; // e.g., "controller_123", "inverter_456"
	voltage?: number; // Optional voltage context
	capacity?: number; // Optional capacity (W or VA)
	childNodes: ElectricalGroupingNode[];
	childSegmentIds?: string[]; // Direct segment references (DC_STRING_SEGMENT, AC_FEEDER_SEGMENT)
	provenance?: {
		sourceService?: string;
		computeStage?: string;
		computeRunId?: string;
	};
}

/**
 * Electrical network graph: top-level container for all groupings
 */
export interface ElectricalNetworkGraph {
	networkId: string;
	networkName?: string;
	rootGroups: ElectricalGroupingNode[]; // Typically transformer routes at top level
	allNodes: Map<string, ElectricalGroupingNode>; // For fast lookup
}

export interface ElectricalTopologyQualityConstraints {
	maxDcStringImbalance: number;
	requireSegmentCoverage: boolean;
	enforceVoltageConsistency: boolean;
}

const DEFAULT_QUALITY_CONSTRAINTS: ElectricalTopologyQualityConstraints = {
	maxDcStringImbalance: 1,
	requireSegmentCoverage: true,
	enforceVoltageConsistency: true
};

/**
 * Validates that a relationship matches an allowed grouping rule
 */
export function isAllowedElectricalGroupingRelationship(
	fromType: ElectricalGroupingType,
	toType: ElectricalGroupingType,
	relation: ElectricalTopologyRelationship
): boolean {
	return ELECTRICAL_GROUPING_RULES.some(
		(rule) => rule.fromType === fromType && rule.toType === toType && rule.relation === relation
	);
}

/**
 * Validates topology parity: ensures each parent has at least one child of expected type
 */
export function validateElectricalTopologyParity(graph: ElectricalNetworkGraph): {
	isValid: boolean;
	violations: string[];
} {
	const violations: string[] = [];

	// Traverse all nodes depth-first
	const traverse = (node: ElectricalGroupingNode, level: number) => {
		const padding = '  '.repeat(level);

		// Check unorphaned nodes: each non-root transformer_route should have parent reference
		if (node.groupingType === ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE && level === 0) {
			// Root level is OK
		}

		// Check leaf nodes contain segment references or are properly terminated
		if (node.childNodes.length === 0 && (!node.childSegmentIds || node.childSegmentIds.length === 0)) {
			if (node.groupingType !== ELECTRICAL_GROUPING_TYPE.DC_STRING) {
				violations.push(
					`${padding}${node.groupingType}:${node.groupingId} has no children and no segment references`
				);
			}
		}

		// For non-leaf nodes, validate child types match expected hierarchy level
		if (node.childNodes.length > 0) {
			const expectedChildType = getExpectedChildType(node.groupingType);
			if (expectedChildType) {
				const invalidChildren = node.childNodes.filter((child) => child.groupingType !== expectedChildType);
				if (invalidChildren.length > 0) {
					violations.push(
						`${padding}${node.groupingType}:${node.groupingId} contains non-${expectedChildType} children: ${invalidChildren.map((c) => c.groupingType).join(', ')}`
					);
				}
			}
		}

		// Recurse
		for (const child of node.childNodes) {
			traverse(child, level + 1);
		}
	};

	// Start from root groups
	for (const root of graph.rootGroups) {
		traverse(root, 0);
	}

	return {
		isValid: violations.length === 0,
		violations
	};
}

/**
 * Sprint 9: Deep quality checks for electrical topology integrity.
 *
 * Verifies:
 * 1. DC string balancing inside each MPPT group
 * 2. Segment coverage parity between topology and materialized segments
 * 3. Optional voltage consistency between parent/child groupings
 */
export function validateElectricalTopologyQuality(
	graph: ElectricalNetworkGraph,
	segmentIds: string[],
	constraints: Partial<ElectricalTopologyQualityConstraints> = {}
): { isValid: boolean; violations: string[] } {
	const cfg: ElectricalTopologyQualityConstraints = { ...DEFAULT_QUALITY_CONSTRAINTS, ...constraints };
	const violations: string[] = [];
	const topologySegmentIds = new Set<string>();

	const walk = (node: ElectricalGroupingNode) => {
		if (node.groupingType === ELECTRICAL_GROUPING_TYPE.MPPT_GROUP) {
			const dcStrings = node.childNodes.filter((child) => child.groupingType === ELECTRICAL_GROUPING_TYPE.DC_STRING);
			if (dcStrings.length >= 2) {
				const segmentCounts = dcStrings.map((dcString) => dcString.childSegmentIds?.length ?? 0);
				const minSegments = Math.min(...segmentCounts);
				const maxSegments = Math.max(...segmentCounts);
				if (maxSegments - minSegments > cfg.maxDcStringImbalance) {
					violations.push(
						`mppt_group:${node.groupingId} has unbalanced dc strings (min=${minSegments}, max=${maxSegments})`
					);
				}
			}
		}

		if (cfg.enforceVoltageConsistency && node.voltage !== undefined) {
			const mismatchedChildren = node.childNodes.filter(
				(child) => child.voltage !== undefined && child.voltage !== node.voltage
			);
			if (mismatchedChildren.length > 0) {
				violations.push(
					`${node.groupingType}:${node.groupingId} has voltage-mismatched children: ${mismatchedChildren
						.map((child) => `${child.groupingType}:${child.groupingId}:${child.voltage}`)
						.join(', ')}`
				);
			}
		}

		for (const segmentId of node.childSegmentIds ?? []) {
			topologySegmentIds.add(segmentId);
		}

		for (const child of node.childNodes) {
			walk(child);
		}
	};

	for (const root of graph.rootGroups) {
		walk(root);
	}

	if (cfg.requireSegmentCoverage) {
		const expectedSegments = new Set(segmentIds);
		for (const expected of expectedSegments) {
			if (!topologySegmentIds.has(expected)) {
				violations.push(`segment:${expected} is missing from topology references`);
			}
		}
		for (const referenced of topologySegmentIds) {
			if (!expectedSegments.has(referenced)) {
				violations.push(`segment:${referenced} referenced by topology but not present in materialized segments`);
			}
		}
	}

	return {
		isValid: violations.length === 0,
		violations
	};
}

/**
 * Returns expected child grouping type for a given parent type
 */
function getExpectedChildType(parentType: ElectricalGroupingType): ElectricalGroupingType | null {
	switch (parentType) {
		case ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE:
			return ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE;
		case ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE:
			return ELECTRICAL_GROUPING_TYPE.MPPT_GROUP;
		case ELECTRICAL_GROUPING_TYPE.MPPT_GROUP:
			return ELECTRICAL_GROUPING_TYPE.DC_STRING;
		case ELECTRICAL_GROUPING_TYPE.DC_STRING:
			return null; // Leaf node type
		default:
			return null;
	}
}

/**
 * Builds electrical network graph from structured input
 */
export function buildElectricalNetworkGraph(
	networkId: string,
	networkName: string | undefined,
	rootNodes: ElectricalGroupingNode[]
): ElectricalNetworkGraph {
	const allNodes = new Map<string, ElectricalGroupingNode>();

	const indexNodes = (node: ElectricalGroupingNode) => {
		allNodes.set(node.groupingId, node);
		for (const child of node.childNodes) {
			indexNodes(child);
		}
	};

	for (const root of rootNodes) {
		indexNodes(root);
	}

	return {
		networkId,
		networkName,
		rootGroups: rootNodes,
		allNodes
	};
}

/**
 * Flattens hierarchy to emit individual BIM relationships for envelope building
 */
export function flattenElectricalTopologyToRelationships(
	graph: ElectricalNetworkGraph
): Array<{ fromId: string; fromType: ElectricalGroupingType; toId: string; toType: ElectricalGroupingType; relation: ElectricalTopologyRelationship }> {
	const relationships: Array<{
		fromId: string;
		fromType: ElectricalGroupingType;
		toId: string;
		toType: ElectricalGroupingType;
		relation: ElectricalTopologyRelationship;
	}> = [];

	const traverse = (node: ElectricalGroupingNode) => {
		for (const child of node.childNodes) {
			// Infer relationship type from parent → child types
			const relation = inferElectricalTopologyRelation(node.groupingType, child.groupingType);
			if (relation) {
				relationships.push({
					fromId: node.groupingId,
					fromType: node.groupingType,
					toId: child.groupingId,
					toType: child.groupingType,
					relation
				});
			}
			traverse(child);
		}
	};

	for (const root of graph.rootGroups) {
		traverse(root);
	}

	return relationships;
}

/**
 * Infers relationship type based on parent/child grouping types
 */
function inferElectricalTopologyRelation(
	parentType: ElectricalGroupingType,
	childType: ElectricalGroupingType
): ElectricalTopologyRelationship | null {
	if (parentType === ELECTRICAL_GROUPING_TYPE.TRANSFORMER_ROUTE && childType === ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE) {
		return ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_TRANSFORMER;
	} else if (parentType === ELECTRICAL_GROUPING_TYPE.INVERTER_ROUTE && childType === ELECTRICAL_GROUPING_TYPE.MPPT_GROUP) {
		return ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_INVERTER;
	} else if (parentType === ELECTRICAL_GROUPING_TYPE.MPPT_GROUP && childType === ELECTRICAL_GROUPING_TYPE.DC_STRING) {
		return ELECTRICAL_TOPOLOGY_RELATIONSHIP.FEEDS_MPPT;
	}
	return null;
}

/**
 * Calculates tree depth for structural analysis
 */
export function getElectricalGroupingTreeDepth(node: ElectricalGroupingNode): number {
	if (node.childNodes.length === 0) {
		return 1;
	}
	return 1 + Math.max(...node.childNodes.map((child) => getElectricalGroupingTreeDepth(child)));
}

/**
 * Counts total nodes (groupings + segments) in hierarchy
 */
export function countElectricalGroupingNodes(node: ElectricalGroupingNode): number {
	let count = 1;
	for (const child of node.childNodes) {
		count += countElectricalGroupingNodes(child);
	}
	if (node.childSegmentIds) {
		count += node.childSegmentIds.length;
	}
	return count;
}
