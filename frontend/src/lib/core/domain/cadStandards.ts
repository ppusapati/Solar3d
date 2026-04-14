export type CadStandardLayer = {
	id: string;
	name: string;
};

export const CAD_STANDARD_LAYERS = {
	BOUNDARY: { id: 'boundary', name: 'Boundary' },
	TERRAIN: { id: 'terrain', name: 'Terrain' },
	ROADS: { id: 'roads', name: 'Roads' },
	PANELS: { id: 'panels', name: 'Panels' },
	ELECTRICAL_DC: { id: 'electrical_dc', name: 'Electrical DC' },
	ELECTRICAL_AC: { id: 'electrical_ac', name: 'Electrical AC' },
	BLOCKS: { id: 'blocks', name: 'Blocks' },
	DIMENSIONS: { id: 'dimensions', name: 'Dimensions' },
	SHEETS: { id: 'sheets', name: 'Sheets' },
	TRANSMISSION: { id: 'transmission', name: 'Transmission' }
} as const satisfies Record<string, CadStandardLayer>;

export const CAD_LENGTH_UNIT = {
	METERS: 'm',
	CENTIMETERS: 'cm',
	MILLIMETERS: 'mm'
} as const;

export const BIM_IFC_CLASS = {
	SITE: 'IfcSite',
	SPACE: 'IfcSpace',
	SLAB: 'IfcSlab',
	ROAD: 'IfcRoad',
	CABLE_CARRIER_SEGMENT: 'IfcCableCarrierSegment',
	FLOW_SEGMENT: 'IfcFlowSegment',
	FLOW_CONVERTER: 'IfcFlowConverter',
	ELECTRIC_DISTRIBUTION_BOARD: 'IfcElectricDistributionBoard',
	ANNOTATION: 'IfcAnnotation',
	BUILDING_ELEMENT_PROXY: 'IfcBuildingElementProxy'
} as const;

export type BimIfcClass = (typeof BIM_IFC_CLASS)[keyof typeof BIM_IFC_CLASS];

export const CAD_DEFAULT_DIMENSION_UNIT = CAD_LENGTH_UNIT.METERS;
export const CAD_DEFAULT_DIMENSION_PRECISION = 2;

export const CAD_CONVERSION = {
	MM_PER_METER: 1000,
	CM_PER_METER: 100
} as const;

export function metersToMillimeters(valueMeters: number): number {
	return valueMeters * CAD_CONVERSION.MM_PER_METER;
}

export function metersToCentimeters(valueMeters: number): number {
	return valueMeters * CAD_CONVERSION.CM_PER_METER;
}

export function millimetersToMeters(valueMillimeters: number): number {
	return valueMillimeters / CAD_CONVERSION.MM_PER_METER;
}

export function centimetersToMeters(valueCentimeters: number): number {
	return valueCentimeters / CAD_CONVERSION.CM_PER_METER;
}

export function buildCadTraceMetadata(operation: string, details: Record<string, unknown> = {}): string {
	return JSON.stringify({
		source: 'frontend-cad-workspace',
		domain: 'cad',
		operation,
		linearBaseUnit: CAD_LENGTH_UNIT.METERS,
		draftingUnit: CAD_LENGTH_UNIT.MILLIMETERS,
		...details
	});
}

export function buildCadBimMetadata(
	operation: string,
	bimClass: BimIfcClass,
	details: Record<string, unknown> = {}
): string {
	const discipline = typeof details.discipline === 'string' ? details.discipline : 'documentation';
	const objectType = typeof details.bimObjectType === 'string' ? details.bimObjectType : 'annotation';
	const objectId = typeof details.bimObjectId === 'string' ? details.bimObjectId : `${objectType}:generated`;
	const relationships = Array.isArray(details.bimRelationships)
		? details.bimRelationships.filter((item) => item && typeof item === 'object')
		: [];

	return buildCadTraceMetadata(operation, {
		bimContractVersion: '1.0',
		bimEnvelope: {
			objectType,
			objectId,
			ifcClass: bimClass,
			discipline,
			relationships,
			provenance: {
				source: 'frontend-cad-workspace',
				domain: 'cad',
				operation
			}
		},
		bimLevel: 'foundation',
		ifcClass: bimClass,
		...details
	});
}
