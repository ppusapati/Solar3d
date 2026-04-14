import { BIM_IFC_CLASS, CAD_STANDARD_LAYERS, type BimIfcClass } from './cadStandards';

export const BIM_DISCIPLINE = {
	CIVIL: 'civil',
	LAYOUT: 'layout',
	ELECTRICAL: 'electrical',
	TRANSMISSION: 'transmission',
	DOCUMENTATION: 'documentation'
} as const;

export type BimDiscipline = (typeof BIM_DISCIPLINE)[keyof typeof BIM_DISCIPLINE];

export const BIM_OBJECT_TYPE = {
	SITE_BOUNDARY: 'site_boundary',
	GRADING_ZONE: 'grading_zone',
	PANEL_TABLE: 'panel_table',
	PANEL_ROW: 'panel_row',
	INVERTER_PAD: 'inverter_pad',
	TRANSFORMER_PAD: 'transformer_pad',
	DC_STRING_SEGMENT: 'dc_string_segment',
	DC_STRING_GROUP: 'dc_string_group',
	MPPT_GROUP: 'mppt_group',
	INVERTER_ROUTE: 'inverter_route',
	TRANSFORMER_ROUTE: 'transformer_route',
	AC_FEEDER_SEGMENT: 'ac_feeder_segment',
	INTERNAL_ROAD_SEGMENT: 'internal_road_segment',
	TRANSMISSION_CORRIDOR: 'transmission_corridor',
	TRANSMISSION_TOWER: 'transmission_tower',
	TRANSMISSION_SPAN: 'transmission_span',
	ANNOTATION: 'annotation'
} as const;

export type BimObjectType = (typeof BIM_OBJECT_TYPE)[keyof typeof BIM_OBJECT_TYPE];

export const BIM_RELATIONSHIP_TYPE = {
	CONTAINS: 'contains',
	CONNECTED_TO: 'connected_to',
	SUPPORTED_BY: 'supported_by',
	FEEDS: 'feeds',
	ANNOTATES: 'annotates'
} as const;

export type BimRelationshipType = (typeof BIM_RELATIONSHIP_TYPE)[keyof typeof BIM_RELATIONSHIP_TYPE];

export interface BimRelationshipRule {
	from: BimObjectType;
	to: BimObjectType;
	relation: BimRelationshipType;
}

export const BIM_OBJECT_SEMANTICS: Record<
	BimObjectType,
	{ discipline: BimDiscipline; ifcClass: BimIfcClass; layerId: string; layerName: string }
> = {
	[BIM_OBJECT_TYPE.SITE_BOUNDARY]: {
		discipline: BIM_DISCIPLINE.CIVIL,
		ifcClass: BIM_IFC_CLASS.SITE,
		layerId: CAD_STANDARD_LAYERS.BOUNDARY.id,
		layerName: CAD_STANDARD_LAYERS.BOUNDARY.name
	},
	[BIM_OBJECT_TYPE.GRADING_ZONE]: {
		discipline: BIM_DISCIPLINE.CIVIL,
		ifcClass: BIM_IFC_CLASS.SLAB,
		layerId: CAD_STANDARD_LAYERS.TERRAIN.id,
		layerName: CAD_STANDARD_LAYERS.TERRAIN.name
	},
	[BIM_OBJECT_TYPE.PANEL_TABLE]: {
		discipline: BIM_DISCIPLINE.LAYOUT,
		ifcClass: BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY,
		layerId: CAD_STANDARD_LAYERS.PANELS.id,
		layerName: CAD_STANDARD_LAYERS.PANELS.name
	},
	[BIM_OBJECT_TYPE.PANEL_ROW]: {
		discipline: BIM_DISCIPLINE.LAYOUT,
		ifcClass: BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY,
		layerId: CAD_STANDARD_LAYERS.PANELS.id,
		layerName: CAD_STANDARD_LAYERS.PANELS.name
	},
	[BIM_OBJECT_TYPE.INVERTER_PAD]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.FLOW_CONVERTER,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_AC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_AC.name
	},
	[BIM_OBJECT_TYPE.TRANSFORMER_PAD]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.ELECTRIC_DISTRIBUTION_BOARD,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_AC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_AC.name
	},
	[BIM_OBJECT_TYPE.DC_STRING_SEGMENT]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.CABLE_CARRIER_SEGMENT,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_DC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_DC.name
	},
	[BIM_OBJECT_TYPE.DC_STRING_GROUP]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.CABLE_CARRIER_SEGMENT,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_DC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_DC.name
	},
	[BIM_OBJECT_TYPE.MPPT_GROUP]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.FLOW_CONVERTER,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_DC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_DC.name
	},
	[BIM_OBJECT_TYPE.INVERTER_ROUTE]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.FLOW_CONVERTER,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_AC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_AC.name
	},
	[BIM_OBJECT_TYPE.TRANSFORMER_ROUTE]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.ELECTRIC_DISTRIBUTION_BOARD,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_AC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_AC.name
	},
	[BIM_OBJECT_TYPE.AC_FEEDER_SEGMENT]: {
		discipline: BIM_DISCIPLINE.ELECTRICAL,
		ifcClass: BIM_IFC_CLASS.CABLE_CARRIER_SEGMENT,
		layerId: CAD_STANDARD_LAYERS.ELECTRICAL_AC.id,
		layerName: CAD_STANDARD_LAYERS.ELECTRICAL_AC.name
	},
	[BIM_OBJECT_TYPE.INTERNAL_ROAD_SEGMENT]: {
		discipline: BIM_DISCIPLINE.CIVIL,
		ifcClass: BIM_IFC_CLASS.ROAD,
		layerId: CAD_STANDARD_LAYERS.ROADS.id,
		layerName: CAD_STANDARD_LAYERS.ROADS.name
	},
	[BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR]: {
		discipline: BIM_DISCIPLINE.TRANSMISSION,
		ifcClass: BIM_IFC_CLASS.FLOW_SEGMENT,
		layerId: CAD_STANDARD_LAYERS.TRANSMISSION.id,
		layerName: CAD_STANDARD_LAYERS.TRANSMISSION.name
	},
	[BIM_OBJECT_TYPE.TRANSMISSION_TOWER]: {
		discipline: BIM_DISCIPLINE.TRANSMISSION,
		ifcClass: BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY,
		layerId: CAD_STANDARD_LAYERS.TRANSMISSION.id,
		layerName: CAD_STANDARD_LAYERS.TRANSMISSION.name
	},
	[BIM_OBJECT_TYPE.TRANSMISSION_SPAN]: {
		discipline: BIM_DISCIPLINE.TRANSMISSION,
		ifcClass: BIM_IFC_CLASS.FLOW_SEGMENT,
		layerId: CAD_STANDARD_LAYERS.TRANSMISSION.id,
		layerName: CAD_STANDARD_LAYERS.TRANSMISSION.name
	},
	[BIM_OBJECT_TYPE.ANNOTATION]: {
		discipline: BIM_DISCIPLINE.DOCUMENTATION,
		ifcClass: BIM_IFC_CLASS.ANNOTATION,
		layerId: CAD_STANDARD_LAYERS.DIMENSIONS.id,
		layerName: CAD_STANDARD_LAYERS.DIMENSIONS.name
	}
};

export const BIM_RELATIONSHIP_RULES: BimRelationshipRule[] = [
	// Spatial hierarchy
	{ from: BIM_OBJECT_TYPE.SITE_BOUNDARY, to: BIM_OBJECT_TYPE.GRADING_ZONE, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	{ from: BIM_OBJECT_TYPE.GRADING_ZONE, to: BIM_OBJECT_TYPE.PANEL_TABLE, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	{ from: BIM_OBJECT_TYPE.PANEL_TABLE, to: BIM_OBJECT_TYPE.PANEL_ROW, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	// Basic electrical power flow (legacy)
	{ from: BIM_OBJECT_TYPE.PANEL_ROW, to: BIM_OBJECT_TYPE.DC_STRING_SEGMENT, relation: BIM_RELATIONSHIP_TYPE.FEEDS },
	{ from: BIM_OBJECT_TYPE.DC_STRING_SEGMENT, to: BIM_OBJECT_TYPE.INVERTER_PAD, relation: BIM_RELATIONSHIP_TYPE.FEEDS },
	{ from: BIM_OBJECT_TYPE.INVERTER_PAD, to: BIM_OBJECT_TYPE.AC_FEEDER_SEGMENT, relation: BIM_RELATIONSHIP_TYPE.FEEDS },
	{ from: BIM_OBJECT_TYPE.AC_FEEDER_SEGMENT, to: BIM_OBJECT_TYPE.TRANSFORMER_PAD, relation: BIM_RELATIONSHIP_TYPE.FEEDS },
	// Electrical grouping hierarchy (Sprint 8)
	{ from: BIM_OBJECT_TYPE.DC_STRING_GROUP, to: BIM_OBJECT_TYPE.DC_STRING_SEGMENT, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	{ from: BIM_OBJECT_TYPE.MPPT_GROUP, to: BIM_OBJECT_TYPE.DC_STRING_GROUP, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	{ from: BIM_OBJECT_TYPE.INVERTER_ROUTE, to: BIM_OBJECT_TYPE.MPPT_GROUP, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	{ from: BIM_OBJECT_TYPE.TRANSFORMER_ROUTE, to: BIM_OBJECT_TYPE.INVERTER_ROUTE, relation: BIM_RELATIONSHIP_TYPE.CONTAINS },
	// Transformer integration
	{ from: BIM_OBJECT_TYPE.TRANSFORMER_PAD, to: BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR, relation: BIM_RELATIONSHIP_TYPE.CONNECTED_TO },
	{ from: BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR, to: BIM_OBJECT_TYPE.TRANSMISSION_TOWER, relation: BIM_RELATIONSHIP_TYPE.SUPPORTED_BY },
	{ from: BIM_OBJECT_TYPE.TRANSMISSION_SPAN, to: BIM_OBJECT_TYPE.TRANSMISSION_TOWER, relation: BIM_RELATIONSHIP_TYPE.SUPPORTED_BY },
	// Annotations
	{ from: BIM_OBJECT_TYPE.ANNOTATION, to: BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR, relation: BIM_RELATIONSHIP_TYPE.ANNOTATES },
	{ from: BIM_OBJECT_TYPE.ANNOTATION, to: BIM_OBJECT_TYPE.DC_STRING_SEGMENT, relation: BIM_RELATIONSHIP_TYPE.ANNOTATES }
];

export interface BimRelationship {
	relation: BimRelationshipType;
	targetType: BimObjectType;
	targetId: string;
}

export interface BimObjectEnvelope {
	objectType: BimObjectType;
	objectId: string;
	nativeId?: string;
	discipline: BimDiscipline;
	ifcClass: BimIfcClass;
	relationships: BimRelationship[];
}

export function defaultSemanticsForObject(objectType: BimObjectType) {
	return BIM_OBJECT_SEMANTICS[objectType];
}

export function isAllowedRelationship(from: BimObjectType, relation: BimRelationshipType, to: BimObjectType): boolean {
	return BIM_RELATIONSHIP_RULES.some((rule) => rule.from === from && rule.relation === relation && rule.to === to);
}

export function buildBimObjectId(objectType: BimObjectType, nativeId: string): string {
	return `${objectType}:${nativeId.trim()}`;
}

export function buildBimEnvelope(input: {
	objectType: BimObjectType;
	nativeId?: string;
	relationships?: BimRelationship[];
}): BimObjectEnvelope {
	const semantics = defaultSemanticsForObject(input.objectType);
	const normalizedNativeId = (input.nativeId ?? '').trim();
	const objectId = buildBimObjectId(input.objectType, normalizedNativeId || 'generated');
	const relationships = (input.relationships ?? []).filter((item) =>
		isAllowedRelationship(input.objectType, item.relation, item.targetType)
	);
	return {
		objectType: input.objectType,
		objectId,
		nativeId: normalizedNativeId,
		discipline: semantics.discipline,
		ifcClass: semantics.ifcClass,
		relationships
	};
}
