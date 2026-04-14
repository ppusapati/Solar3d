export type BimContractVersion = 'legacy' | '1.0';

export interface BimEnvelopeV1 {
	objectType: string;
	objectId: string;
	ifcClass: string;
	discipline: string;
	relationships: Array<Record<string, unknown>>;
	provenance: {
		source?: string;
		domain?: string;
		operation?: string;
	};
}

export interface ParsedBimContract {
	version: BimContractVersion;
	metadata: Record<string, unknown>;
	envelope?: BimEnvelopeV1;
}

function parseJsonObject(raw: string | undefined): Record<string, unknown> {
	if (!raw) return {};
	try {
		const parsed = JSON.parse(raw) as Record<string, unknown>;
		return parsed && typeof parsed === 'object' ? parsed : {};
	} catch {
		return {};
	}
}

function toStringOrDefault(value: unknown, fallback = ''): string {
	return typeof value === 'string' ? value : fallback;
}

function toRelationships(value: unknown): Array<Record<string, unknown>> {
	if (!Array.isArray(value)) return [];
	return value.filter((item): item is Record<string, unknown> => Boolean(item && typeof item === 'object'));
}

function coerceLegacyEnvelope(metadata: Record<string, unknown>): BimEnvelopeV1 | undefined {
	const objectType = toStringOrDefault(metadata.bimObjectType, 'annotation');
	const objectId = toStringOrDefault(metadata.bimObjectId, 'annotation:legacy');
	const ifcClass = toStringOrDefault(metadata.ifcClass, 'IfcAnnotation');
	const discipline = toStringOrDefault(metadata.discipline, 'documentation');
	const relationships = toRelationships(metadata.bimRelationships);

	const hasLegacyHints =
		typeof metadata.bimObjectType === 'string' ||
		typeof metadata.bimObjectId === 'string' ||
		typeof metadata.ifcClass === 'string' ||
		typeof metadata.discipline === 'string';

	if (!hasLegacyHints) {
		return undefined;
	}

	return {
		objectType,
		objectId,
		ifcClass,
		discipline,
		relationships,
		provenance: {
			source: toStringOrDefault(metadata.source),
			domain: toStringOrDefault(metadata.domain),
			operation: toStringOrDefault(metadata.operation)
		}
	};
}

export function parseBimContract(metadataJson: string | undefined): ParsedBimContract {
	const metadata = parseJsonObject(metadataJson);
	const version = toStringOrDefault(metadata.bimContractVersion) === '1.0' ? '1.0' : 'legacy';

	if (version === '1.0' && metadata.bimEnvelope && typeof metadata.bimEnvelope === 'object') {
		const envelopeRaw = metadata.bimEnvelope as Record<string, unknown>;
		return {
			version,
			metadata,
			envelope: {
				objectType: toStringOrDefault(envelopeRaw.objectType, 'annotation'),
				objectId: toStringOrDefault(envelopeRaw.objectId, 'annotation:generated'),
				ifcClass: toStringOrDefault(envelopeRaw.ifcClass, 'IfcAnnotation'),
				discipline: toStringOrDefault(envelopeRaw.discipline, 'documentation'),
				relationships: toRelationships(envelopeRaw.relationships),
				provenance: {
					source: toStringOrDefault((envelopeRaw.provenance as Record<string, unknown> | undefined)?.source),
					domain: toStringOrDefault((envelopeRaw.provenance as Record<string, unknown> | undefined)?.domain),
					operation: toStringOrDefault((envelopeRaw.provenance as Record<string, unknown> | undefined)?.operation)
				}
			}
		};
	}

	return {
		version: 'legacy',
		metadata,
		envelope: coerceLegacyEnvelope(metadata)
	};
}

export function normalizeBimContractMetadata(metadataJson: string | undefined): string {
	const parsed = parseBimContract(metadataJson);
	if (parsed.version === '1.0') {
		return JSON.stringify(parsed.metadata);
	}
	if (!parsed.envelope) {
		return JSON.stringify(parsed.metadata);
	}
	return JSON.stringify({
		...parsed.metadata,
		bimContractVersion: '1.0',
		bimEnvelope: parsed.envelope
	});
}
