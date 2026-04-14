<script lang="ts">
	import { onMount } from 'svelte';
	import { createEventDispatcher } from 'svelte';
	import { activeLayout, components } from '$lib/core/stores';
	import { backendClients, layoutApi } from '$lib/core/api';
	import { AssetCategory } from '$lib/gen/asset/v1/asset_pb.js';
	import type { Asset } from '$lib/gen/asset/v1/asset_pb.js';
	import { assetTypeFromCategory } from '$lib/core/domain/assetPlacement';
	import Asset3DPreview from '$lib/components/Asset3DPreview.svelte';

	type CatalogRegion = 'global' | 'india';

	type AssetTemplate = {
		name: string;
		manufacturer: string;
		model: string;
		category: AssetCategory;
		dimensions: {
			widthMm: number;
			heightMm: number;
			depthMm: number;
			weightKg: number;
		};
		electrical: {
			ratedPowerW?: number;
			voc?: number;
			isc?: number;
			vmp?: number;
			imp?: number;
			efficiency?: number;
			maxDcInputW?: number;
			maxAcOutputW?: number;
			mpptCount?: number;
			maxInputVoltage?: number;
			minInputVoltage?: number;
			maxStringsPerMppt?: number;
			kvaRating?: number;
			primaryVoltage?: number;
			secondaryVoltage?: number;
		};
		model3dPath: string;
		metadataJson: string;
	};

	type AssetDraft = {
		name: string;
		manufacturer: string;
		model: string;
		metadata_json: string;
		model_3d_path: string;
		width_mm: number;
		height_mm: number;
		depth_mm: number;
		weight_kg: number;
		rated_power_w: number;
		vmp: number;
		imp: number;
		efficiency_percent: number;
	};

	const dispatch = createEventDispatcher<{
		selectAsset: {
			type: string;
			name: string;
			id: string;
			model3dPath: string;
			dimensions: { widthMm: number; heightMm: number; depthMm: number };
		};
	}>();

	const categoryTabs: { label: string; filter: AssetCategory }[] = [
		{ label: 'Solar Panels', filter: AssetCategory.SOLAR_PANEL },
		{ label: 'Inverters', filter: AssetCategory.STRING_INVERTER },
		{ label: 'Central Inv.', filter: AssetCategory.CENTRAL_INVERTER },
		{ label: 'Mounting', filter: AssetCategory.MOUNTING_STRUCTURE },
		{ label: 'Trackers', filter: AssetCategory.TRACKER },
		{ label: 'Transformers', filter: AssetCategory.TRANSFORMER },
		{ label: 'Junction Boxes', filter: AssetCategory.JUNCTION_BOX },
		{ label: 'Combiners', filter: AssetCategory.COMBINER_BOX },
		{ label: 'Cable', filter: AssetCategory.CABLE },
		{ label: 'Substations', filter: AssetCategory.SUBSTATION }
	];

	const metadataPlaceholder = '{"tier": "enterprise"}';
	const catalogRegionOptions: { value: CatalogRegion; label: string }[] = [
		{ value: 'global', label: 'Global' },
		{ value: 'india', label: 'India Market' }
	];

	const starterCatalog: Record<AssetCategory, AssetTemplate[]> = {
		[AssetCategory.SOLAR_PANEL]: [
			{
				name: 'Tiger Neo 78HC-BDV',
				manufacturer: 'JinkoSolar',
				model: 'JKM625-650N-78HL4-BDV',
				category: AssetCategory.SOLAR_PANEL,
				dimensions: { widthMm: 1303, heightMm: 2384, depthMm: 35, weightKg: 38.5 },
				electrical: { ratedPowerW: 650, voc: 45.2, isc: 18.2, vmp: 37.8, imp: 17.2, efficiency: 0.233 },
				model3dPath: '/models/panels/jinkosolar-tiger-neo-78hc-bdv.glb',
				metadataJson: JSON.stringify({ cellType: 'TOPCon', bifacial: true, series: 'Tiger Neo', iconKey: 'panel' })
			},
			{
				name: 'Vertex N',
				manufacturer: 'Trina Solar',
				model: 'TSM-NEG21C.20',
				category: AssetCategory.SOLAR_PANEL,
				dimensions: { widthMm: 1303, heightMm: 2384, depthMm: 33, weightKg: 38.3 },
				electrical: { ratedPowerW: 695, voc: 47.8, isc: 18.4, vmp: 39.8, imp: 17.5, efficiency: 0.224 },
				model3dPath: '/models/panels/trinasolar-vertex-n.glb',
				metadataJson: JSON.stringify({ cellType: 'n-type i-TOPCon', bifacial: true, series: 'Vertex N', iconKey: 'panel' })
			}
		],
		[AssetCategory.STRING_INVERTER]: [
			{
				name: 'SG250HX',
				manufacturer: 'Sungrow',
				model: 'SG250HX',
				category: AssetCategory.STRING_INVERTER,
				dimensions: { widthMm: 1035, heightMm: 700, depthMm: 365, weightKg: 92 },
				electrical: { maxDcInputW: 375000, maxAcOutputW: 250000, mpptCount: 12, maxInputVoltage: 1500, minInputVoltage: 550, maxStringsPerMppt: 3 },
				model3dPath: '/models/inverters/sungrow-sg250hx.glb',
				metadataJson: JSON.stringify({ cooling: 'smart-air', manufacturerSeries: 'HX', iconKey: 'string-inverter' })
			},
			{
				name: 'Sunny Highpower PEAK3',
				manufacturer: 'SMA',
				model: 'SHP 150-20',
				category: AssetCategory.STRING_INVERTER,
				dimensions: { widthMm: 777, heightMm: 1045, depthMm: 363, weightKg: 84 },
				electrical: { maxDcInputW: 225000, maxAcOutputW: 150000, mpptCount: 12, maxInputVoltage: 1500, minInputVoltage: 500, maxStringsPerMppt: 2 },
				model3dPath: '/models/inverters/sma-shp150-20.glb',
				metadataJson: JSON.stringify({ cooling: 'forced-air', manufacturerSeries: 'Sunny Highpower', iconKey: 'string-inverter' })
			}
		],
		[AssetCategory.CENTRAL_INVERTER]: [
			{
				name: 'MV Grid-connected PV Inverter',
				manufacturer: 'Sungrow',
				model: 'SG3125HV-MV-30',
				category: AssetCategory.CENTRAL_INVERTER,
				dimensions: { widthMm: 6058, heightMm: 2896, depthMm: 2438, weightKg: 8600 },
				electrical: { maxDcInputW: 4687000, maxAcOutputW: 3125000, mpptCount: 1, maxInputVoltage: 1500, minInputVoltage: 875, maxStringsPerMppt: 0 },
				model3dPath: '/models/inverters/sungrow-sg3125hv-mv-30.glb',
				metadataJson: JSON.stringify({ containerized: true, manufacturerSeries: 'HV-MV-30', iconKey: 'central-inverter' })
			},
			{
				name: 'MV Grid-connected PV Inverter',
				manufacturer: 'Sungrow',
				model: 'SG6250HV-MV',
				category: AssetCategory.CENTRAL_INVERTER,
				dimensions: { widthMm: 12192, heightMm: 2896, depthMm: 2438, weightKg: 16200 },
				electrical: { maxDcInputW: 9375000, maxAcOutputW: 6250000, mpptCount: 1, maxInputVoltage: 1500, minInputVoltage: 900, maxStringsPerMppt: 0 },
				model3dPath: '/models/inverters/sungrow-sg6250hv-mv.glb',
				metadataJson: JSON.stringify({ containerized: true, manufacturerSeries: 'HV-MV', iconKey: 'central-inverter' })
			}
		],
		[AssetCategory.MOUNTING_STRUCTURE]: [
			{
				name: 'GROUND FIXED TILT',
				manufacturer: 'Unirac',
				model: 'GROUND FIXED TILT',
				category: AssetCategory.MOUNTING_STRUCTURE,
				dimensions: { widthMm: 5200, heightMm: 1800, depthMm: 2400, weightKg: 180 },
				electrical: {},
				model3dPath: '/models/mounting/unirac-ground-fixed-tilt.glb',
				metadataJson: JSON.stringify({ tiltOptionsDeg: [20, 30], foundation: 'single-post', iconKey: 'mounting' })
			},
			{
				name: 'MaxSpan Fixed Tilt',
				manufacturer: 'GameChange Solar',
				model: 'MaxSpan',
				category: AssetCategory.MOUNTING_STRUCTURE,
				dimensions: { widthMm: 6400, heightMm: 2100, depthMm: 3100, weightKg: 265 },
				electrical: {},
				model3dPath: '/models/mounting/gamechange-maxspan.glb',
				metadataJson: JSON.stringify({ systemType: 'fixed-tilt', terrainAdaptive: true, iconKey: 'mounting' })
			}
		],
		[AssetCategory.TRACKER]: [
			{
				name: 'NX Horizon',
				manufacturer: 'Nextracker',
				model: 'NX Horizon',
				category: AssetCategory.TRACKER,
				dimensions: { widthMm: 90000, heightMm: 3200, depthMm: 4200, weightKg: 4200 },
				electrical: {},
				model3dPath: '/models/trackers/nextracker-nx-horizon.glb',
				metadataJson: JSON.stringify({ trackerType: 'single-axis', architecture: '1P/2P adaptable', iconKey: 'tracker' })
			},
			{
				name: 'Vanguard 1P',
				manufacturer: 'TrinaTracker',
				model: 'Vanguard 1P',
				category: AssetCategory.TRACKER,
				dimensions: { widthMm: 120000, heightMm: 3400, depthMm: 4600, weightKg: 5100 },
				electrical: {},
				model3dPath: '/models/trackers/trinatracker-vanguard-1p.glb',
				metadataJson: JSON.stringify({ trackerType: 'single-axis', architecture: '1P', iconKey: 'tracker' })
			}
		],
		[AssetCategory.TRANSFORMER]: [
			{
				name: 'Solar Duty Pad-Mounted Transformer',
				manufacturer: 'Prolec GE',
				model: 'Solar Duty Pad-Mounted',
				category: AssetCategory.TRANSFORMER,
				dimensions: { widthMm: 3400, heightMm: 2750, depthMm: 2150, weightKg: 5400 },
				electrical: { kvaRating: 3150, primaryVoltage: 33000, secondaryVoltage: 800 },
				model3dPath: '/models/transformers/prolecge-solar-duty-padmount.glb',
				metadataJson: JSON.stringify({ cooling: 'ONAN', application: 'solar-collector-substation', iconKey: 'transformer' })
			},
			{
				name: 'Solar Duty Padmount Transformer',
				manufacturer: 'MGM Transformer Company',
				model: 'Solar Duty Padmount',
				category: AssetCategory.TRANSFORMER,
				dimensions: { widthMm: 4800, heightMm: 3150, depthMm: 2550, weightKg: 8900 },
				electrical: { kvaRating: 6300, primaryVoltage: 33000, secondaryVoltage: 1100 },
				model3dPath: '/models/transformers/mgm-solar-duty-padmount.glb',
				metadataJson: JSON.stringify({ cooling: 'ONAF', application: 'utility-solar', iconKey: 'transformer' })
			}
		],
		[AssetCategory.JUNCTION_BOX]: [
			{
				name: 'PV Next Generator Junction Box',
				manufacturer: 'Weidmuller',
				model: 'PV Next GJB',
				category: AssetCategory.JUNCTION_BOX,
				dimensions: { widthMm: 420, heightMm: 520, depthMm: 180, weightKg: 16 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/weidmuller-pv-next-gjb.glb',
				metadataJson: JSON.stringify({ voltageClass: '1500VDC', platform: 'PV Next', iconKey: 'junction-box' })
			},
			{
				name: 'SUNCLIX PV Junction Box',
				manufacturer: 'Phoenix Contact',
				model: 'SUNCLIX',
				category: AssetCategory.JUNCTION_BOX,
				dimensions: { widthMm: 500, heightMm: 600, depthMm: 220, weightKg: 19 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/phoenixcontact-sunclix-jb.glb',
				metadataJson: JSON.stringify({ enclosure: 'IP66', connectorFamily: 'SUNCLIX', iconKey: 'junction-box' })
			}
		],
		[AssetCategory.COMBINER_BOX]: [
			{
				name: 'PV Next String Combiner',
				manufacturer: 'Weidmuller',
				model: 'PV Next',
				category: AssetCategory.COMBINER_BOX,
				dimensions: { widthMm: 680, heightMm: 820, depthMm: 260, weightKg: 28 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/weidmuller-pv-next-combiner.glb',
				metadataJson: JSON.stringify({ inputs: 16, surgeProtection: true, voltageClass: '1500VDC', iconKey: 'combiner-box' })
			},
			{
				name: 'BLA Combine-As-You-Go',
				manufacturer: 'Shoals',
				model: 'BLA',
				category: AssetCategory.COMBINER_BOX,
				dimensions: { widthMm: 760, heightMm: 930, depthMm: 300, weightKg: 34 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/shoals-bla.glb',
				metadataJson: JSON.stringify({ architecture: 'combine-as-you-go', monitoring: 'optional', iconKey: 'combiner-box' })
			}
		],
		[AssetCategory.CABLE]: [
			{
				name: 'SOLARFLEX-X H1Z2Z2-K 1x6',
				manufacturer: 'HELUKABEL',
				model: 'SOLARFLEX-X H1Z2Z2-K',
				category: AssetCategory.CABLE,
				dimensions: { widthMm: 6, heightMm: 6, depthMm: 1000, weightKg: 0.08 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/cables/helukabel-solarflex-x-1x6.glb',
				metadataJson: JSON.stringify({ conductor: 'tinned-copper', insulation: 'XLPO', standard: 'H1Z2Z2-K', iconKey: 'cable' })
			},
			{
				name: 'PRYSOLAR H1Z2Z2-K 1x10',
				manufacturer: 'Prysmian',
				model: 'PRYSOLAR H1Z2Z2-K',
				category: AssetCategory.CABLE,
				dimensions: { widthMm: 8, heightMm: 8, depthMm: 1000, weightKg: 0.12 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/cables/prysmian-prysolar-1x10.glb',
				metadataJson: JSON.stringify({ conductor: 'tinned-copper', standard: 'H1Z2Z2-K', iconKey: 'cable' })
			}
		],
		[AssetCategory.SUBSTATION]: [
			{
				name: 'eHouse',
				manufacturer: 'Hitachi Energy',
				model: 'eHouse',
				category: AssetCategory.SUBSTATION,
				dimensions: { widthMm: 12000, heightMm: 4200, depthMm: 18000, weightKg: 16500 },
				electrical: { primaryVoltage: 33000, secondaryVoltage: 132000 },
				model3dPath: '/models/substations/hitachienergy-ehouse.glb',
				metadataJson: JSON.stringify({ bays: 4, packageType: 'electrical-house', iconKey: 'substation' })
			},
			{
				name: 'E-House',
				manufacturer: 'Siemens Energy',
				model: 'E-House',
				category: AssetCategory.SUBSTATION,
				dimensions: { widthMm: 9600, heightMm: 3600, depthMm: 14800, weightKg: 12200 },
				electrical: { primaryVoltage: 33000, secondaryVoltage: 33000 },
				model3dPath: '/models/substations/siemens-energy-ehouse.glb',
				metadataJson: JSON.stringify({ bays: 2, packageType: 'compact-substation', iconKey: 'substation' })
			}
		],
		[AssetCategory.UNSPECIFIED]: []
	};

	const indiaStarterCatalog: Record<AssetCategory, AssetTemplate[]> = {
		[AssetCategory.SOLAR_PANEL]: [
			{
				name: 'N-Type TOPCon Bifacial Module',
				manufacturer: 'Waaree',
				model: 'Bifacial TOPCon 590-605Wp',
				category: AssetCategory.SOLAR_PANEL,
				dimensions: { widthMm: 1134, heightMm: 2382, depthMm: 30, weightKg: 32.5 },
				electrical: { ratedPowerW: 605, voc: 52.1, isc: 14.6, vmp: 44.1, imp: 13.72, efficiency: 0.234 },
				model3dPath: '/models/panels/waaree-topcon-bifacial.glb',
				metadataJson: JSON.stringify({ market: 'india', cellType: 'TOPCon', origin: 'India', iconKey: 'panel' })
			},
			{
				name: 'Hypersol N-Type Glass-To-Glass',
				manufacturer: 'Vikram Solar',
				model: 'Hypersol 580-605Wp',
				category: AssetCategory.SOLAR_PANEL,
				dimensions: { widthMm: 1134, heightMm: 2278, depthMm: 30, weightKg: 31.5 },
				electrical: { ratedPowerW: 600, voc: 52, isc: 14.4, vmp: 43.6, imp: 13.75, efficiency: 0.231 },
				model3dPath: '/models/panels/vikram-hypersol.glb',
				metadataJson: JSON.stringify({ market: 'india', cellType: 'n-type', origin: 'India', iconKey: 'panel' })
			}
		],
		[AssetCategory.STRING_INVERTER]: [
			{
				name: 'SG250HX',
				manufacturer: 'Sungrow',
				model: 'SG250HX',
				category: AssetCategory.STRING_INVERTER,
				dimensions: { widthMm: 1035, heightMm: 700, depthMm: 365, weightKg: 92 },
				electrical: { maxDcInputW: 375000, maxAcOutputW: 250000, mpptCount: 12, maxInputVoltage: 1500, minInputVoltage: 550, maxStringsPerMppt: 3 },
				model3dPath: '/models/inverters/sungrow-sg250hx.glb',
				metadataJson: JSON.stringify({ market: 'india', segment: 'utility-c&i', iconKey: 'string-inverter' })
			},
			{
				name: 'HT Series',
				manufacturer: 'GoodWe',
				model: 'HT 110-250kW',
				category: AssetCategory.STRING_INVERTER,
				dimensions: { widthMm: 995, heightMm: 682, depthMm: 362, weightKg: 93 },
				electrical: { maxDcInputW: 375000, maxAcOutputW: 250000, mpptCount: 12, maxInputVoltage: 1500, minInputVoltage: 550, maxStringsPerMppt: 2 },
				model3dPath: '/models/inverters/goodwe-ht-250.glb',
				metadataJson: JSON.stringify({ market: 'india', segment: 'c&i', iconKey: 'string-inverter' })
			}
		],
		[AssetCategory.CENTRAL_INVERTER]: [
			{
				name: 'MV Grid-connected PV Inverter',
				manufacturer: 'Sungrow',
				model: 'SG3125HV-MV-30',
				category: AssetCategory.CENTRAL_INVERTER,
				dimensions: { widthMm: 6058, heightMm: 2896, depthMm: 2438, weightKg: 8600 },
				electrical: { maxDcInputW: 4687000, maxAcOutputW: 3125000, mpptCount: 1, maxInputVoltage: 1500, minInputVoltage: 875, maxStringsPerMppt: 0 },
				model3dPath: '/models/inverters/sungrow-sg3125hv-mv-30.glb',
				metadataJson: JSON.stringify({ market: 'india', containerized: true, iconKey: 'central-inverter' })
			},
			{
				name: 'PVS980 Central Inverter',
				manufacturer: 'FIMER',
				model: 'PVS980-58',
				category: AssetCategory.CENTRAL_INVERTER,
				dimensions: { widthMm: 6050, heightMm: 2900, depthMm: 2438, weightKg: 8300 },
				electrical: { maxDcInputW: 5000000, maxAcOutputW: 4600000, mpptCount: 1, maxInputVoltage: 1500, minInputVoltage: 850, maxStringsPerMppt: 0 },
				model3dPath: '/models/inverters/fimer-pvs980-58.glb',
				metadataJson: JSON.stringify({ market: 'india', utilityScale: true, iconKey: 'central-inverter' })
			}
		],
		[AssetCategory.MOUNTING_STRUCTURE]: [
			{
				name: 'Solar MMS Fixed Tilt',
				manufacturer: 'Pennar Industries',
				model: 'Solar MMS',
				category: AssetCategory.MOUNTING_STRUCTURE,
				dimensions: { widthMm: 5200, heightMm: 1800, depthMm: 2400, weightKg: 185 },
				electrical: {},
				model3dPath: '/models/mounting/pennar-solar-mms.glb',
				metadataJson: JSON.stringify({ market: 'india', structureType: 'fixed-tilt', iconKey: 'mounting' })
			},
			{
				name: 'Ground Mount Structure',
				manufacturer: 'Strolar',
				model: 'Ground Mount MMS',
				category: AssetCategory.MOUNTING_STRUCTURE,
				dimensions: { widthMm: 6100, heightMm: 2100, depthMm: 3100, weightKg: 240 },
				electrical: {},
				model3dPath: '/models/mounting/strolar-ground-mount.glb',
				metadataJson: JSON.stringify({ market: 'india', structureType: 'ground-mount', iconKey: 'mounting' })
			}
		],
		[AssetCategory.TRACKER]: [
			{
				name: 'SkyLine II',
				manufacturer: 'Arctech',
				model: 'SkyLine II',
				category: AssetCategory.TRACKER,
				dimensions: { widthMm: 90000, heightMm: 3200, depthMm: 4200, weightKg: 4200 },
				electrical: {},
				model3dPath: '/models/trackers/arctech-skyline-ii.glb',
				metadataJson: JSON.stringify({ market: 'india', trackerType: 'single-axis', iconKey: 'tracker' })
			},
			{
				name: 'Genius Tracker',
				manufacturer: 'GameChange Solar',
				model: 'Genius Tracker',
				category: AssetCategory.TRACKER,
				dimensions: { widthMm: 120000, heightMm: 3400, depthMm: 4600, weightKg: 5100 },
				electrical: {},
				model3dPath: '/models/trackers/gamechange-genius.glb',
				metadataJson: JSON.stringify({ market: 'india', trackerType: 'single-axis', iconKey: 'tracker' })
			}
		],
		[AssetCategory.TRANSFORMER]: [
			{
				name: 'Solar Inverter Duty Transformer',
				manufacturer: 'Voltamp',
				model: 'Inverter Duty Transformer',
				category: AssetCategory.TRANSFORMER,
				dimensions: { widthMm: 3400, heightMm: 2750, depthMm: 2150, weightKg: 5400 },
				electrical: { kvaRating: 3150, primaryVoltage: 33000, secondaryVoltage: 800 },
				model3dPath: '/models/transformers/voltamp-inverter-duty.glb',
				metadataJson: JSON.stringify({ market: 'india', application: 'solar-inverter-duty', iconKey: 'transformer' })
			},
			{
				name: 'Solar Duty Transformer',
				manufacturer: 'CG Power',
				model: 'Solar Duty Transformer',
				category: AssetCategory.TRANSFORMER,
				dimensions: { widthMm: 4800, heightMm: 3150, depthMm: 2550, weightKg: 8900 },
				electrical: { kvaRating: 6300, primaryVoltage: 33000, secondaryVoltage: 1100 },
				model3dPath: '/models/transformers/cgpower-solar-duty.glb',
				metadataJson: JSON.stringify({ market: 'india', application: 'utility-solar', iconKey: 'transformer' })
			}
		],
		[AssetCategory.JUNCTION_BOX]: [
			{
				name: 'Solar DC Junction Box',
				manufacturer: 'Statcon Energiaa',
				model: 'DC Junction Box',
				category: AssetCategory.JUNCTION_BOX,
				dimensions: { widthMm: 420, heightMm: 520, depthMm: 180, weightKg: 16 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/statcon-dc-junction-box.glb',
				metadataJson: JSON.stringify({ market: 'india', voltageClass: '1500VDC', iconKey: 'junction-box' })
			},
			{
				name: 'Solar Array Junction Box',
				manufacturer: 'MTEKPOWER',
				model: 'Array Junction Box',
				category: AssetCategory.JUNCTION_BOX,
				dimensions: { widthMm: 500, heightMm: 600, depthMm: 220, weightKg: 19 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/mtekpower-array-jb.glb',
				metadataJson: JSON.stringify({ market: 'india', enclosure: 'IP65', iconKey: 'junction-box' })
			}
		],
		[AssetCategory.COMBINER_BOX]: [
			{
				name: 'DC Combiner Box',
				manufacturer: 'L&T Electrical & Automation',
				model: 'DC Combiner Box',
				category: AssetCategory.COMBINER_BOX,
				dimensions: { widthMm: 680, heightMm: 820, depthMm: 260, weightKg: 28 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/lt-dc-combiner-box.glb',
				metadataJson: JSON.stringify({ market: 'india', inputs: 16, iconKey: 'combiner-box' })
			},
			{
				name: 'String Combiner Box',
				manufacturer: 'Statcon Energiaa',
				model: 'String Combiner Box',
				category: AssetCategory.COMBINER_BOX,
				dimensions: { widthMm: 760, heightMm: 930, depthMm: 300, weightKg: 34 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/electrical/statcon-string-combiner.glb',
				metadataJson: JSON.stringify({ market: 'india', inputs: 24, iconKey: 'combiner-box' })
			}
		],
		[AssetCategory.CABLE]: [
			{
				name: 'Solar Cable',
				manufacturer: 'KEI Industries',
				model: 'Solar Cable 1x6 sqmm',
				category: AssetCategory.CABLE,
				dimensions: { widthMm: 6, heightMm: 6, depthMm: 1000, weightKg: 0.08 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/cables/kei-solar-cable-1x6.glb',
				metadataJson: JSON.stringify({ market: 'india', conductor: 'copper', standard: 'solar-cable', iconKey: 'cable' })
			},
			{
				name: 'Solar DC Cable',
				manufacturer: 'Polycab',
				model: 'Solar DC Cable 1x10 sqmm',
				category: AssetCategory.CABLE,
				dimensions: { widthMm: 8, heightMm: 8, depthMm: 1000, weightKg: 0.12 },
				electrical: { maxInputVoltage: 1500 },
				model3dPath: '/models/cables/polycab-solar-dc-1x10.glb',
				metadataJson: JSON.stringify({ market: 'india', conductor: 'tinned-copper', standard: 'solar-dc', iconKey: 'cable' })
			}
		],
		[AssetCategory.SUBSTATION]: [
			{
				name: 'E-House',
				manufacturer: 'Siemens Energy India',
				model: 'E-House',
				category: AssetCategory.SUBSTATION,
				dimensions: { widthMm: 12000, heightMm: 4200, depthMm: 18000, weightKg: 16500 },
				electrical: { primaryVoltage: 33000, secondaryVoltage: 132000 },
				model3dPath: '/models/substations/siemens-energy-india-ehouse.glb',
				metadataJson: JSON.stringify({ market: 'india', packageType: 'electrical-house', iconKey: 'substation' })
			},
			{
				name: 'eHouse',
				manufacturer: 'Hitachi Energy India',
				model: 'eHouse',
				category: AssetCategory.SUBSTATION,
				dimensions: { widthMm: 9600, heightMm: 3600, depthMm: 14800, weightKg: 12200 },
				electrical: { primaryVoltage: 33000, secondaryVoltage: 33000 },
				model3dPath: '/models/substations/hitachienergy-india-ehouse.glb',
				metadataJson: JSON.stringify({ market: 'india', packageType: 'compact-substation', iconKey: 'substation' })
			}
		],
		[AssetCategory.UNSPECIFIED]: []
	};

	function createEmptyDraft(): AssetDraft {
		return {
			name: '',
			manufacturer: '',
			model: '',
			metadata_json: '',
			model_3d_path: '',
			width_mm: 0,
			height_mm: 0,
			depth_mm: 0,
			weight_kg: 0,
			rated_power_w: 0,
			vmp: 0,
			imp: 0,
			efficiency_percent: 0
		};
	}

	let activeTab = categoryTabs[0];
	let assets: Asset[] = [];
	let isLoading = false;
	let error = '';
	let selectedAssetId = '';
	let selectedAsset: Asset | null = null;
	let assetDraft = createEmptyDraft();
	let loadingDetails = false;
	let savingAsset = false;
	let deletingAsset = false;
	let removingComponentId = '';
	let seedingCatalog = false;
	let selectedCatalogRegion: CatalogRegion = 'india';

	$: placedComponents = $components.filter((component) => component.layout_id === $activeLayout?.id);

	function readAssetMetadata(asset: Asset): Record<string, unknown> {
		if (!asset.metadataJson?.trim()) {
			return {};
		}
		try {
			const parsed = JSON.parse(asset.metadataJson);
			return parsed && typeof parsed === 'object' ? parsed : {};
		} catch {
			return {};
		}
	}

	function assetIcon(category: AssetCategory): string {
		const iconConfig: Record<number, { accent: string; bg: string; symbol: string; ring?: boolean }> = {
			[AssetCategory.SOLAR_PANEL]: { accent: '#22c55e', bg: '#0f2f20', symbol: 'panel' },
			[AssetCategory.STRING_INVERTER]: { accent: '#ef4444', bg: '#331617', symbol: 'string-inverter' },
			[AssetCategory.CENTRAL_INVERTER]: { accent: '#f97316', bg: '#3c1d10', symbol: 'central-inverter' },
			[AssetCategory.TRACKER]: { accent: '#84cc16', bg: '#23340b', symbol: 'tracker' },
			[AssetCategory.MOUNTING_STRUCTURE]: { accent: '#94a3b8', bg: '#1f2937', symbol: 'mounting' },
			[AssetCategory.TRANSFORMER]: { accent: '#8b5cf6', bg: '#25193c', symbol: 'transformer' },
			[AssetCategory.JUNCTION_BOX]: { accent: '#f59e0b', bg: '#3f2608', symbol: 'junction-box' },
			[AssetCategory.COMBINER_BOX]: { accent: '#fb7185', bg: '#3b1721', symbol: 'combiner-box' },
			[AssetCategory.CABLE]: { accent: '#06b6d4', bg: '#0d2f36', symbol: 'cable' },
			[AssetCategory.SUBSTATION]: { accent: '#38bdf8', bg: '#102a3a', symbol: 'substation' }
		};

		const { accent, bg, symbol } = iconConfig[category] ?? { accent: '#64748b', bg: '#1f2937', symbol: 'default' };
		const svg = `
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
				<defs>
					<linearGradient id="g" x1="0" x2="1" y1="0" y2="1">
						<stop offset="0%" stop-color="${bg}"/>
						<stop offset="100%" stop-color="#0f172a"/>
					</linearGradient>
				</defs>
				<rect x="2" y="2" width="44" height="44" rx="12" fill="url(#g)" stroke="${accent}" stroke-width="2"/>
				${buildAssetIconShape(symbol, accent)}
			</svg>
		`;
		return `data:image/svg+xml;utf8,${encodeURIComponent(svg)}`;
	}

	function buildAssetIconShape(symbol: string, accent: string): string {
		switch (symbol) {
			case 'panel':
				return `<rect x="10" y="12" width="28" height="18" rx="2" fill="none" stroke="${accent}" stroke-width="2"/><path d="M10 18h28M19 12v18M29 12v18M14 34h20" stroke="${accent}" stroke-width="2" stroke-linecap="round"/>`;
			case 'string-inverter':
				return `<rect x="13" y="9" width="22" height="28" rx="4" fill="none" stroke="${accent}" stroke-width="2"/><path d="M24 14l-4 9h5l-3 10 7-11h-5l4-8" fill="${accent}"/><circle cx="19" cy="32" r="1.5" fill="${accent}"/><circle cx="29" cy="32" r="1.5" fill="${accent}"/>`;
			case 'central-inverter':
				return `<rect x="8" y="14" width="32" height="18" rx="4" fill="none" stroke="${accent}" stroke-width="2"/><path d="M24 16l-4 8h5l-3 8 7-9h-5l4-7" fill="${accent}"/><path d="M13 36h22" stroke="${accent}" stroke-width="2" stroke-linecap="round"/>`;
			case 'tracker':
				return `<path d="M10 27l14-10 14 10" fill="none" stroke="${accent}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M16 24l16-6" stroke="${accent}" stroke-width="2" stroke-linecap="round"/><path d="M24 18v18" stroke="${accent}" stroke-width="2" stroke-linecap="round"/><circle cx="24" cy="36" r="2.5" fill="${accent}"/>`;
			case 'mounting':
				return `<path d="M12 32h24M16 32l6-16M32 32l-6-16M20 22h8" fill="none" stroke="${accent}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>`;
			case 'transformer':
				return `<rect x="12" y="12" width="24" height="20" rx="3" fill="none" stroke="${accent}" stroke-width="2"/><path d="M18 18c3 0 3 8 6 8s3-8 6-8" fill="none" stroke="${accent}" stroke-width="2" stroke-linecap="round"/><path d="M16 36h16" stroke="${accent}" stroke-width="2" stroke-linecap="round"/>`;
			case 'junction-box':
				return `<rect x="12" y="11" width="24" height="24" rx="4" fill="none" stroke="${accent}" stroke-width="2"/><path d="M18 18h12M18 24h12M18 30h8" stroke="${accent}" stroke-width="2" stroke-linecap="round"/>`;
			case 'combiner-box':
				return `<rect x="11" y="11" width="26" height="24" rx="4" fill="none" stroke="${accent}" stroke-width="2"/><path d="M18 18v10M24 16v12M30 18v10M15 30h18" stroke="${accent}" stroke-width="2" stroke-linecap="round"/>`;
			case 'cable':
				return `<path d="M9 29c7-12 23-12 30 0" fill="none" stroke="${accent}" stroke-width="3" stroke-linecap="round"/><path d="M13 33c5-8 17-8 22 0" fill="none" stroke="${accent}" stroke-width="2" stroke-linecap="round"/><circle cx="11" cy="29" r="2" fill="${accent}"/><circle cx="37" cy="29" r="2" fill="${accent}"/>`;
			case 'substation':
				return `<path d="M10 34h28M14 34V16h20v18M19 16V10h10v6M18 23h3M27 23h3M18 29h12" fill="none" stroke="${accent}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>`;
			default:
				return `<circle cx="24" cy="24" r="9" fill="none" stroke="${accent}" stroke-width="2"/><path d="M24 18v12M18 24h12" stroke="${accent}" stroke-width="2" stroke-linecap="round"/>`;
		}
	}

	function assetSpecs(asset: Asset): string {
		const parts: string[] = [];
		if (asset.dimensions) {
			parts.push(`${Math.round(asset.dimensions.widthMm)}×${Math.round(asset.dimensions.heightMm)}mm`);
		}
		if (asset.electrical?.ratedPowerW) {
			parts.push(`${asset.electrical.ratedPowerW}W`);
		}
		if (asset.electrical?.maxAcOutputW) {
			parts.push(`${Math.round(asset.electrical.maxAcOutputW / 1000)}kW AC`);
		}
		if (asset.electrical?.kvaRating) {
			parts.push(`${asset.electrical.kvaRating}kVA`);
		}
		if (asset.category === AssetCategory.CABLE) {
			const cableGauge = readAssetMetadata(asset).conductor;
			if (cableGauge) {
				parts.push(String(cableGauge));
			}
		}
		if (asset.electrical?.efficiency) {
			parts.push(`${(asset.electrical.efficiency * 100).toFixed(1)}%`);
		}
		return parts.join(', ');
	}

	function categorySummary(category: AssetCategory): string {
		const marketPrefix = selectedCatalogRegion === 'india' ? 'India-market ' : '';
		switch (category) {
			case AssetCategory.SOLAR_PANEL:
				return `${marketPrefix}modules and bifacial panel variants`;
			case AssetCategory.STRING_INVERTER:
				return `${marketPrefix}distributed conversion equipment`;
			case AssetCategory.CENTRAL_INVERTER:
				return `${marketPrefix}utility-scale PCS skids`;
			case AssetCategory.MOUNTING_STRUCTURE:
				return `${marketPrefix}fixed-tilt structural systems`;
			case AssetCategory.TRACKER:
				return `${marketPrefix}single-axis tracker assemblies`;
			case AssetCategory.TRANSFORMER:
				return `${marketPrefix}MV step-up transformers`;
			case AssetCategory.JUNCTION_BOX:
				return `${marketPrefix}field junction and protection boxes`;
			case AssetCategory.COMBINER_BOX:
				return `${marketPrefix}string combining hardware`;
			case AssetCategory.CABLE:
				return `${marketPrefix}DC and AC cable runs`;
			case AssetCategory.SUBSTATION:
				return `${marketPrefix}pooling and interconnect stations`;
			default:
				return `${marketPrefix}project asset catalog`;
		}
	}

	async function seedStarterAssets() {
		seedingCatalog = true;
		error = '';
		try {
			const sourceCatalog = selectedCatalogRegion === 'india' ? indiaStarterCatalog : starterCatalog;
			const templates = sourceCatalog[activeTab.filter] ?? [];
			const existingKeys = new Set(
				assets.map((asset) => `${asset.name}::${asset.manufacturer}::${asset.model}`.toLowerCase())
			);

			for (const template of templates) {
				const key = `${template.name}::${template.manufacturer}::${template.model}`.toLowerCase();
				if (existingKeys.has(key)) {
					continue;
				}
				await backendClients.asset.createAsset({
					name: template.name,
					manufacturer: template.manufacturer,
					model: template.model,
					category: template.category,
					dimensions: template.dimensions,
					electrical: template.electrical,
					model3dPath: template.model3dPath,
					metadataJson: template.metadataJson
				});
			}

			await loadAssets(activeTab);
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to add starter assets';
		} finally {
			seedingCatalog = false;
		}
	}

	function setDraftFromAsset(asset: Asset) {
		assetDraft = {
			name: asset.name,
			manufacturer: asset.manufacturer,
			model: asset.model,
			metadata_json: asset.metadataJson,
			model_3d_path: asset.model3dPath,
			width_mm: asset.dimensions?.widthMm ?? 0,
			height_mm: asset.dimensions?.heightMm ?? 0,
			depth_mm: asset.dimensions?.depthMm ?? 0,
			weight_kg: asset.dimensions?.weightKg ?? 0,
			rated_power_w: asset.electrical?.ratedPowerW ?? 0,
			vmp: asset.electrical?.vmp ?? 0,
			imp: asset.electrical?.imp ?? 0,
			efficiency_percent: (asset.electrical?.efficiency ?? 0) * 100
		};
	}

	async function loadAssets(tab: typeof categoryTabs[0]) {
		isLoading = true;
		error = '';
		try {
			const res = await backendClients.asset.listAssets({
				categoryFilter: tab.filter,
				pageSize: 50
			});
			assets = res.assets;
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to load assets';
			assets = [];
		} finally {
			isLoading = false;
		}
	}

	async function loadAssetDetails(id: string) {
		loadingDetails = true;
		error = '';
		try {
			const response = await backendClients.asset.getAsset({ id });
			selectedAsset = response.asset ?? null;
			selectedAssetId = response.asset?.id ?? id;
			if (response.asset) {
				setDraftFromAsset(response.asset);
			}
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to load asset details';
		} finally {
			loadingDetails = false;
		}
	}

	function selectTab(tab: typeof categoryTabs[0]) {
		activeTab = tab;
		selectedAssetId = '';
		selectedAsset = null;
		assetDraft = createEmptyDraft();
		void loadAssets(tab);
	}

	function handleDragStart(event: DragEvent, asset: Asset) {
		event.dataTransfer?.setData(
			'text/plain',
			JSON.stringify({
				type: assetTypeFromCategory(asset.category),
				name: asset.name,
				id: asset.id,
				model3dPath: asset.model3dPath,
				dimensions: {
					widthMm: asset.dimensions?.widthMm ?? 0,
					heightMm: asset.dimensions?.heightMm ?? 0,
					depthMm: asset.dimensions?.depthMm ?? 0
				}
			})
		);
		if (event.dataTransfer) event.dataTransfer.effectAllowed = 'copy';
	}

	async function handleClick(asset: Asset) {
		dispatch('selectAsset', {
			type: assetTypeFromCategory(asset.category),
			name: asset.name,
			id: asset.id,
			model3dPath: asset.model3dPath,
			dimensions: {
				widthMm: asset.dimensions?.widthMm ?? 0,
				heightMm: asset.dimensions?.heightMm ?? 0,
				depthMm: asset.dimensions?.depthMm ?? 0
			}
		});
		await loadAssetDetails(asset.id);
	}

	function beginCreateAsset() {
		selectedAssetId = '';
		selectedAsset = null;
		assetDraft = createEmptyDraft();
		error = '';
	}

	async function saveAsset() {
		savingAsset = true;
		error = '';
		try {
			const payload = {
				name: assetDraft.name,
				manufacturer: assetDraft.manufacturer,
				model: assetDraft.model,
				dimensions: {
					widthMm: assetDraft.width_mm,
					heightMm: assetDraft.height_mm,
					depthMm: assetDraft.depth_mm,
					weightKg: assetDraft.weight_kg
				},
				electrical: {
					ratedPowerW: assetDraft.rated_power_w,
					vmp: assetDraft.vmp,
					imp: assetDraft.imp,
					efficiency: assetDraft.efficiency_percent > 0 ? assetDraft.efficiency_percent / 100 : 0
				},
				model3dPath: assetDraft.model_3d_path,
				metadataJson: assetDraft.metadata_json
			};

			const response = selectedAssetId
				? await backendClients.asset.updateAsset({ id: selectedAssetId, ...payload })
				: await backendClients.asset.createAsset({ ...payload, category: activeTab.filter });

			await loadAssets(activeTab);
			if (response.asset?.id) {
				await loadAssetDetails(response.asset.id);
			}
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to save asset';
		} finally {
			savingAsset = false;
		}
	}

	async function deleteAsset() {
		if (!selectedAssetId) return;
		deletingAsset = true;
		error = '';
		try {
			await backendClients.asset.deleteAsset({ id: selectedAssetId });
			beginCreateAsset();
			await loadAssets(activeTab);
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to delete asset';
		} finally {
			deletingAsset = false;
		}
	}

	async function removePlacedComponent(componentId: string) {
		removingComponentId = componentId;
		error = '';
		try {
			await layoutApi.removeComponent(componentId);
			components.update((items) => items.filter((item) => item.id !== componentId));
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to remove placed component';
		} finally {
			removingComponentId = '';
		}
	}

	onMount(() => {
		void loadAssets(activeTab);
	});
</script>

<div class="asset-library">
	<div class="library-header">
		<h4>Asset Library</h4>
		<div class="header-actions">
			<button class="header-btn" on:click={seedStarterAssets} disabled={seedingCatalog}>
				{seedingCatalog ? 'Loading Defaults…' : `Load ${selectedCatalogRegion === 'india' ? 'India Market' : 'Global'} Assets`}
			</button>
			<button class="header-btn" on:click={beginCreateAsset}>New Asset</button>
		</div>
	</div>
	<div class="category-summary">Drag an asset onto the map to place it, or click an asset then click the map.</div>

	<div class="region-toggle">
		{#each catalogRegionOptions as region}
			<button class="region-btn" class:active={selectedCatalogRegion === region.value} on:click={() => (selectedCatalogRegion = region.value)}>
				{region.label}
			</button>
		{/each}
	</div>

	<div class="category-summary">{categorySummary(activeTab.filter)}</div>

	<div class="tab-bar">
		{#each categoryTabs as tab}
			<button
				class="tab-btn"
				class:active={activeTab.label === tab.label}
				on:click={() => selectTab(tab)}
			>
				{tab.label}
			</button>
		{/each}
	</div>

	{#if error}
		<div class="error">{error}</div>
	{:else if isLoading}
		<div class="empty">Loading…</div>
	{:else if assets.length === 0}
		<div class="empty">No assets in this category</div>
	{:else}
		<div class="asset-list">
			{#each assets as asset (asset.id)}
				<button
					class="asset-item"
					class:selected={selectedAssetId === asset.id}
					draggable="true"
					on:dragstart={(e) => handleDragStart(e, asset)}
					on:click={() => void handleClick(asset)}
				>
					<img class="asset-icon" src={assetIcon(asset.category)} alt={asset.name} />
					<div class="asset-info">
						<div class="asset-name-row">
							<span class="asset-name">{asset.name}</span>
							<span class="asset-category-badge">{activeTab.label}</span>
						</div>
						<span class="asset-specs">
							{asset.manufacturer}{asset.model ? ' ' + asset.model : ''}{assetSpecs(asset) ? ' · ' + assetSpecs(asset) : ''}
						</span>
					</div>
				</button>
			{/each}
		</div>
	{/if}

	<div class="divider"></div>

	<div class="editor-card">
		<h5>{selectedAssetId ? 'Asset Details' : 'Create Asset'}</h5>
		{#if selectedAsset}
			<Asset3DPreview
				modelPath={selectedAsset.model3dPath}
				category={selectedAsset.category}
				widthMm={selectedAsset.dimensions?.widthMm ?? 0}
				heightMm={selectedAsset.dimensions?.heightMm ?? 0}
				depthMm={selectedAsset.dimensions?.depthMm ?? 0}
			/>
		{/if}
		{#if loadingDetails}
			<div class="empty">Loading asset details…</div>
		{:else}
			<div class="form-grid">
				<label>
					<span>Name</span>
					<input bind:value={assetDraft.name} placeholder="Asset name" />
				</label>
				<label>
					<span>Manufacturer</span>
					<input bind:value={assetDraft.manufacturer} placeholder="Manufacturer" />
				</label>
				<label>
					<span>Model</span>
					<input bind:value={assetDraft.model} placeholder="Model" />
				</label>
				<label>
					<span>Model 3D Path</span>
					<input bind:value={assetDraft.model_3d_path} placeholder="/models/asset.glb" />
				</label>
				<label>
					<span>Width (mm)</span>
					<input type="number" min="0" bind:value={assetDraft.width_mm} />
				</label>
				<label>
					<span>Height (mm)</span>
					<input type="number" min="0" bind:value={assetDraft.height_mm} />
				</label>
				<label>
					<span>Depth (mm)</span>
					<input type="number" min="0" bind:value={assetDraft.depth_mm} />
				</label>
				<label>
					<span>Weight (kg)</span>
					<input type="number" min="0" step="0.1" bind:value={assetDraft.weight_kg} />
				</label>
				<label>
					<span>Rated Power (W)</span>
					<input type="number" min="0" bind:value={assetDraft.rated_power_w} />
				</label>
				<label>
					<span>Vmp</span>
					<input type="number" min="0" step="0.1" bind:value={assetDraft.vmp} />
				</label>
				<label>
					<span>Imp</span>
					<input type="number" min="0" step="0.1" bind:value={assetDraft.imp} />
				</label>
				<label>
					<span>Efficiency (%)</span>
					<input type="number" min="0" max="100" step="0.1" bind:value={assetDraft.efficiency_percent} />
				</label>
				<label class="full-width">
					<span>Metadata JSON</span>
					<textarea bind:value={assetDraft.metadata_json} rows="3" placeholder={metadataPlaceholder}></textarea>
				</label>
			</div>
			<div class="editor-actions">
				<button class="primary-btn" on:click={saveAsset} disabled={savingAsset || !assetDraft.name.trim()}>
					{savingAsset ? 'Saving…' : selectedAssetId ? 'Update Asset' : 'Create Asset'}
				</button>
				{#if selectedAssetId}
					<button class="secondary-btn" on:click={beginCreateAsset}>Reset</button>
					<button class="danger-btn" on:click={deleteAsset} disabled={deletingAsset}>
						{deletingAsset ? 'Deleting…' : 'Delete Asset'}
					</button>
				{/if}
			</div>
		{/if}
	</div>

	{#if $activeLayout}
		<div class="divider"></div>
		<div class="editor-card">
			<h5>Placed Components</h5>
			{#if placedComponents.length === 0}
				<div class="empty">No placed components in the active layout.</div>
			{:else}
				<div class="component-list">
					{#each placedComponents as component (component.id)}
						<div class="component-row">
							<div class="component-copy">
								<span class="component-name">{component.component_type}</span>
								<span class="component-meta">{component.asset_id || 'Unlinked asset'} · {component.id.slice(0, 8)}</span>
							</div>
							<button
								class="danger-btn compact"
								on:click={() => void removePlacedComponent(component.id)}
								disabled={removingComponentId === component.id}
							>
								{removingComponentId === component.id ? 'Removing…' : 'Remove'}
							</button>
						</div>
					{/each}
				</div>
			{/if}
		</div>
	{/if}
</div>

<style>
	.asset-library {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.library-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.library-header h4,
	h5 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.header-actions {
		display: flex;
		gap: 6px;
		flex-wrap: wrap;
	}

	.category-summary {
		font-size: 11px;
		color: #64748b;
		margin-top: -2px;

	}

	.region-toggle {
		display: flex;
		gap: 6px;
		flex-wrap: wrap;
	}

	.region-btn {
		padding: 4px 8px;
		border-radius: 999px;
		border: 1px solid rgba(255, 255, 255, 0.12);
		background: rgba(255, 255, 255, 0.03);
		color: #94a3b8;
		font-size: 10px;
		cursor: pointer;
	}

	.region-btn.active {
		background: rgba(245, 158, 11, 0.15);
		border-color: rgba(245, 158, 11, 0.35);
		color: #fbbf24;
	}

	.header-btn,
	.primary-btn,
	.secondary-btn,
	.danger-btn {
		padding: 6px 8px;
		border-radius: 6px;
		font-size: 11px;
		cursor: pointer;
	}

	.header-btn,
	.secondary-btn {
		border: 1px solid rgba(255, 255, 255, 0.14);
		background: rgba(255, 255, 255, 0.04);
		color: #cbd5e1;
	}

	.primary-btn {
		border: none;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #111827;
		font-weight: 700;
	}

	.danger-btn {
		border: 1px solid rgba(239, 68, 68, 0.3);
		background: rgba(239, 68, 68, 0.08);
		color: #fca5a5;
	}

	.danger-btn.compact {
		padding: 4px 8px;
	}

	.tab-bar {
		display: flex;
		flex-wrap: wrap;
		gap: 4px;
		margin-bottom: 6px;
	}

	.tab-btn {
		padding: 3px 7px;
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 4px;
		background: transparent;
		color: #94a3b8;
		font-size: 10px;
		cursor: pointer;
		white-space: nowrap;
	}

	.tab-btn:hover {
		background: rgba(255, 255, 255, 0.06);
		color: #e2e8f0;
	}

	.tab-btn.active {
		background: rgba(245, 158, 11, 0.15);
		border-color: rgba(245, 158, 11, 0.4);
		color: #f59e0b;
	}

	.error {
		padding: 6px 8px;
		border-radius: 4px;
		background: rgba(239, 68, 68, 0.15);
		border: 1px solid rgba(239, 68, 68, 0.3);
		color: #fca5a5;
		font-size: 11px;
	}

	.empty {
		padding: 12px;
		text-align: center;
		color: #64748b;
		font-size: 12px;
	}

	.asset-list {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.asset-item {
		display: flex;
		align-items: flex-start;
		gap: 8px;
		padding: 10px;
		border: 1px solid rgba(255, 255, 255, 0.06);
		border-radius: 10px;
		background:
			linear-gradient(180deg, rgba(255, 255, 255, 0.04), rgba(255, 255, 255, 0.02)),
			rgba(15, 23, 42, 0.45);
		color: #e2e8f0;
		cursor: grab;
		text-align: left;
		transition: all 0.15s;
		width: 100%;
	}

	.asset-item:hover {
		background:
			linear-gradient(180deg, rgba(245, 158, 11, 0.08), rgba(255, 255, 255, 0.02)),
			rgba(15, 23, 42, 0.55);
		border-color: rgba(245, 158, 11, 0.3);
		transform: translateY(-1px);
	}

	.asset-item.selected {
		background:
			linear-gradient(180deg, rgba(245, 158, 11, 0.12), rgba(255, 255, 255, 0.03)),
			rgba(15, 23, 42, 0.62);
		border-color: rgba(245, 158, 11, 0.4);
		box-shadow: inset 0 0 0 1px rgba(245, 158, 11, 0.15);
	}

	.asset-item:active {
		cursor: grabbing;
	}

	.asset-icon {
		width: 40px;
		height: 40px;
		flex-shrink: 0;
		border-radius: 10px;
		object-fit: contain;
		background: rgba(2, 6, 23, 0.45);
	}

	.asset-info {
		display: flex;
		flex-direction: column;
		min-width: 0;
		gap: 3px;
		flex: 1;
	}

	.asset-name-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 8px;
	}

	.asset-name {
		font-size: 12px;
		font-weight: 600;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.asset-category-badge {
		padding: 2px 6px;
		border-radius: 999px;
		background: rgba(148, 163, 184, 0.12);
		border: 1px solid rgba(148, 163, 184, 0.18);
		font-size: 9px;
		text-transform: uppercase;
		letter-spacing: 0.04em;
		color: #cbd5e1;
		flex-shrink: 0;
	}

	.asset-specs {
		font-size: 10px;
		color: #64748b;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.08);
	}

	.editor-card {
		display: flex;
		flex-direction: column;
		gap: 8px;
		padding: 10px;
		border-radius: 8px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.form-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.form-grid label {
		display: flex;
		flex-direction: column;
		gap: 4px;
		font-size: 10px;
		color: #94a3b8;
	}

	.form-grid input,
	.form-grid textarea {
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.14);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	.form-grid textarea {
		resize: vertical;
	}

	.full-width {
		grid-column: 1 / -1;
	}

	.editor-actions {
		display: flex;
		gap: 8px;
		flex-wrap: wrap;
	}

	.component-list {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.component-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 8px;
		padding: 8px;
		border-radius: 6px;
		background: rgba(0, 0, 0, 0.2);
	}

	.component-copy {
		display: flex;
		flex-direction: column;
		gap: 2px;
		min-width: 0;
	}

	.component-name {
		font-size: 12px;
		color: #e2e8f0;
		font-weight: 600;
	}

	.component-meta {
		font-size: 10px;
		color: #64748b;
	}
</style>
