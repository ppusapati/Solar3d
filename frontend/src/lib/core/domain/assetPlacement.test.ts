import { describe, expect, it } from 'vitest';
import { AssetCategory } from '$lib/gen/asset/v1/asset_pb.js';
import { assetTypeFromCategory, isCableType, isPanelType, normalizeAssetType } from './assetPlacement';

describe('asset placement normalization', () => {
	it('maps asset categories to normalized placement types', () => {
		expect(assetTypeFromCategory(AssetCategory.SOLAR_PANEL)).toBe('panel');
		expect(assetTypeFromCategory(AssetCategory.STRING_INVERTER)).toBe('inverter');
		expect(assetTypeFromCategory(AssetCategory.CENTRAL_INVERTER)).toBe('inverter');
		expect(assetTypeFromCategory(AssetCategory.JUNCTION_BOX)).toBe('combiner_box');
		expect(assetTypeFromCategory(AssetCategory.CABLE)).toBe('cable');
	});

	it('normalizes payload aliases from drag/drop and legacy values', () => {
		expect(normalizeAssetType(' solar_panel ')).toBe('panel');
		expect(normalizeAssetType('PV_PANEL')).toBe('panel');
		expect(normalizeAssetType('string_inverter')).toBe('inverter');
		expect(normalizeAssetType('junction_box')).toBe('combiner_box');
		expect(normalizeAssetType('mounting_structure')).toBe('mounting');
		expect(normalizeAssetType('unknown_type')).toBe('component');
	});

	it('detects panel and cable types consistently', () => {
		expect(isPanelType('panel')).toBe(true);
		expect(isPanelType('solar_panel')).toBe(true);
		expect(isPanelType('transformer')).toBe(false);
		expect(isCableType('cable')).toBe(true);
		expect(isCableType('CABLE')).toBe(true);
		expect(isCableType('panel')).toBe(false);
	});
});
