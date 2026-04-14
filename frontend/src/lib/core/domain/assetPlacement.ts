import { AssetCategory } from '$lib/gen/asset/v1/asset_pb.js';

export type NormalizedAssetType =
	| 'panel'
	| 'inverter'
	| 'transformer'
	| 'combiner_box'
	| 'tracker'
	| 'cable'
	| 'mounting'
	| 'substation'
	| 'component';

const aliasMap: Record<string, NormalizedAssetType> = {
	panel: 'panel',
	solar_panel: 'panel',
	solarpanel: 'panel',
	pv_panel: 'panel',
	pvpanel: 'panel',
	inverter: 'inverter',
	string_inverter: 'inverter',
	central_inverter: 'inverter',
	transformer: 'transformer',
	combiner_box: 'combiner_box',
	combiner: 'combiner_box',
	junction_box: 'combiner_box',
	tracker: 'tracker',
	cable: 'cable',
	mounting: 'mounting',
	mounting_structure: 'mounting',
	substation: 'substation',
	component: 'component'
};

export function normalizeAssetType(rawType: string | null | undefined): NormalizedAssetType {
	const key = (rawType ?? '').toString().trim().toLowerCase();
	if (!key) {
		return 'component';
	}
	return aliasMap[key] ?? 'component';
}

export function assetTypeFromCategory(category: AssetCategory): NormalizedAssetType {
	switch (category) {
		case AssetCategory.SOLAR_PANEL:
			return 'panel';
		case AssetCategory.STRING_INVERTER:
		case AssetCategory.CENTRAL_INVERTER:
			return 'inverter';
		case AssetCategory.TRANSFORMER:
			return 'transformer';
		case AssetCategory.COMBINER_BOX:
		case AssetCategory.JUNCTION_BOX:
			return 'combiner_box';
		case AssetCategory.TRACKER:
			return 'tracker';
		case AssetCategory.CABLE:
			return 'cable';
		case AssetCategory.MOUNTING_STRUCTURE:
			return 'mounting';
		case AssetCategory.SUBSTATION:
			return 'substation';
		default:
			return 'component';
	}
}

export function isPanelType(type: string | null | undefined): boolean {
	return normalizeAssetType(type) === 'panel';
}

export function isCableType(type: string | null | undefined): boolean {
	return normalizeAssetType(type) === 'cable';
}