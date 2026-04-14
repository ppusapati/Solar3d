import {
	ElectricalService,
	type ElectricalNetwork as ProtoElectricalNetwork,
	type InverterGroup as ProtoInverterGroup,
	type PanelString as ProtoPanelString
} from '$lib/gen/electrical/v1/electrical_pb.js';

import { createApiClient, timestampToIso } from './connect';

export interface ElectricalNetwork {
	id: string;
	project_id: string;
	layout_id: string;
	name: string;
	total_dc_capacity_kw: number;
	total_ac_capacity_kw: number;
	dc_ac_ratio: number;
	total_strings: number;
	total_inverters: number;
	created_at: string;
}

export interface PanelString {
	id: string;
	network_id: string;
	inverter_group_id: string;
	panel_ids: string[];
	panel_count: number;
	voltage_v: number;
	current_a: number;
	power_w: number;
}

export interface InverterGroup {
	id: string;
	network_id: string;
	inverter_asset_id: string;
	string_ids: string[];
	dc_input_kw: number;
	ac_output_kw: number;
	dc_ac_ratio: number;
	position_geojson: string;
}

export interface LossBreakdown {
	soiling_percent: number;
	shading_percent: number;
	mismatch_percent: number;
	wiring_percent: number;
	inverter_percent: number;
	transformer_percent: number;
	total_loss_percent: number;
}

export interface ValidateSizingInput {
	network_id: string;
	panel_voc_v: number;
	panel_vmp_v: number;
	panel_isc_a: number;
	panel_imp_a: number;
	panels_per_string: number;
	inverter_vdc_max_v: number;
	inverter_vmppt_min_v: number;
	inverter_vmppt_max_v: number;
	inverter_idc_max_a: number;
	inverter_ac_kw: number;
	dc_ac_ratio_min: number;
	dc_ac_ratio_max: number;
	temp_coeff_voc_pct_per_c: number;
	lowest_expected_temp_c: number;
	highest_expected_temp_c: number;
}

export interface SizingViolation {
	code: string;
	message: string;
	limit: number;
	actual: number;
}

export interface ValidateSizingResult {
	valid: boolean;
	violations: SizingViolation[];
	string_voc_cold_v: number;
	string_vmp_hot_v: number;
	dc_string_power_kw: number;
	dc_ac_ratio: number;
	max_panels_per_string: number;
	min_panels_per_string: number;
}

export interface NetworkTopologyIssue {
	code: string;
	message: string;
	entity_id: string;
}

export interface ValidateNetworkResult {
	valid: boolean;
	issues: NetworkTopologyIssue[];
	total_strings: number;
	assigned_strings: number;
	unassigned_strings: number;
	total_panels: number;
	duplicate_panel_refs: number;
	total_dc_kw: number;
	total_ac_kw: number;
	dc_ac_ratio: number;
}

export interface NetworkBOMItem {
	category: string;
	name: string;
	quantity: number;
	unit: string;
	unit_cost: number;
	total_cost: number;
}

export interface NetworkBOMResult {
	network_id: string;
	panel_count: number;
	string_count: number;
	inverter_group_count: number;
	total_dc_kw: number;
	total_ac_kw: number;
	items: NetworkBOMItem[];
	total_cost: number;
	currency_code: string;
}

const client = createApiClient(ElectricalService);

function mapNetwork(network?: ProtoElectricalNetwork): ElectricalNetwork {
	if (!network) {
		throw new Error('Electrical network response was empty');
	}

	return {
		id: network.id,
		project_id: network.projectId,
		layout_id: network.layoutId,
		name: network.name,
		total_dc_capacity_kw: network.totalDcCapacityKw,
		total_ac_capacity_kw: network.totalAcCapacityKw,
		dc_ac_ratio: network.dcAcRatio,
		total_strings: network.stringCount,
		total_inverters: network.inverterCount,
		created_at: timestampToIso(network.createdAt)
	};
}

function mapPanelString(panelString?: ProtoPanelString): PanelString {
	if (!panelString) {
		throw new Error('Panel string response was empty');
	}

	return {
		id: panelString.id,
		network_id: panelString.networkId,
		inverter_group_id: panelString.inverterGroupId,
		panel_ids: panelString.panelIds,
		panel_count: panelString.panelCount,
		voltage_v: panelString.stringVoltage,
		current_a: panelString.stringCurrent,
		power_w: panelString.stringPowerW
	};
}

function mapInverterGroup(group?: ProtoInverterGroup): InverterGroup {
	if (!group) {
		throw new Error('Inverter group response was empty');
	}

	return {
		id: group.id,
		network_id: group.networkId,
		inverter_asset_id: group.inverterAssetId,
		string_ids: group.stringIds,
		dc_input_kw: group.dcInputKw,
		ac_output_kw: group.acOutputKw,
		dc_ac_ratio: group.dcAcRatio,
		position_geojson: group.positionGeojson
	};
}

export const electricalApi = {
	createNetwork: async (data: {
		project_id: string;
		layout_id: string;
		name: string;
	}) => {
		const response = await client.createNetwork({
			projectId: data.project_id,
			layoutId: data.layout_id,
			name: data.name
		});

		return { network: mapNetwork(response.network) };
	},

	getNetwork: async (id: string) => {
		const response = await client.getNetwork({ id });
		return { network: mapNetwork(response.network) };
	},

	listNetworks: async (projectId: string) => {
		const response = await client.listNetworks({ projectId });
		return { networks: response.networks.map(mapNetwork) };
	},

	autoGenerateStrings: async (
		networkId: string,
		data: {
			layout_id?: string;
			total_panels: number;
			panels_per_string: number;
			strings_per_inverter: number;
			panel_vmp: number;
			panel_imp: number;
			inverter_asset_id?: string;
		}
	) => {
		const response = await client.autoGenerateStrings({
			networkId,
			layoutId: data.layout_id ?? '',
			panelsPerString: data.panels_per_string,
			inverterAssetId: data.inverter_asset_id ?? '',
			stringsPerInverter: data.strings_per_inverter,
			totalPanels: data.total_panels,
			panelVoltage: data.panel_vmp,
			panelCurrent: data.panel_imp,
			panelPowerW: data.panel_vmp * data.panel_imp,
			inverterAcKw: data.panel_vmp * data.panel_imp * data.panels_per_string * data.strings_per_inverter / 1000
		});

		return { network: mapNetwork(response.network) };
	},

	createString: async (
		networkId: string,
		data: {
			panel_ids: string[];
			inverter_group_id?: string;
			panel_voltage: number;
			panel_current: number;
		}
	) => {
		const response = await client.createString({
			networkId,
			panelIds: data.panel_ids,
			inverterGroupId: data.inverter_group_id ?? '',
			panelVoltage: data.panel_voltage,
			panelCurrent: data.panel_current
		});

		return { panel_string: mapPanelString(response.panelString) };
	},

	listStrings: async (networkId: string) => {
		const response = await client.listStrings({ networkId });
		return { strings: response.strings.map(mapPanelString) };
	},

	assignInverter: async (
		networkId: string,
		data: {
			inverter_asset_id: string;
			string_ids: string[];
			position_geojson?: string;
		}
	) => {
		const response = await client.assignInverter({
			networkId,
			inverterAssetId: data.inverter_asset_id,
			stringIds: data.string_ids,
			positionGeojson: data.position_geojson ?? ''
		});

		return { inverter_group: mapInverterGroup(response.inverterGroup) };
	},

	listInverterGroups: async (networkId: string) => {
		const response = await client.listInverterGroups({ networkId });
		return { inverter_groups: response.inverterGroups.map(mapInverterGroup) };
	},

	calculateDCCapacity: async (networkId: string) => {
		const response = await client.calculateDCCapacity({ networkId });
		return {
			total_dc_kw: response.totalDcKw,
			total_panels: response.totalPanels,
			total_strings: response.totalStrings
		};
	},

	calculateACCapacity: async (networkId: string) => {
		const response = await client.calculateACCapacity({ networkId });
		return {
			total_ac_kw: response.totalAcKw,
			dc_ac_ratio: response.dcAcRatio,
			total_inverters: response.totalInverters
		};
		},

	calculateLosses: async (networkId: string) => {
		const response = await client.calculateLosses({ networkId });
		return {
			losses: {
				soiling_percent: 0,
				shading_percent: 0,
				mismatch_percent: 0,
				wiring_percent: response.dcCableLossPercent + response.acCableLossPercent,
				inverter_percent: response.inverterLossPercent,
				transformer_percent: response.transformerLossPercent,
				total_loss_percent: response.totalLossPercent
			} satisfies LossBreakdown
		};
	},

	validateSizing: async (input: ValidateSizingInput): Promise<ValidateSizingResult> => {
		const response = await client.validateSizing({
			networkId: input.network_id,
			panelVocV: input.panel_voc_v,
			panelVmpV: input.panel_vmp_v,
			panelIscA: input.panel_isc_a,
			panelImpA: input.panel_imp_a,
			panelsPerString: input.panels_per_string,
			inverterVdcMaxV: input.inverter_vdc_max_v,
			inverterVmpptMinV: input.inverter_vmppt_min_v,
			inverterVmpptMaxV: input.inverter_vmppt_max_v,
			inverterIdcMaxA: input.inverter_idc_max_a,
			inverterAcKw: input.inverter_ac_kw,
			dcAcRatioMin: input.dc_ac_ratio_min,
			dcAcRatioMax: input.dc_ac_ratio_max,
			tempCoeffVocPctPerC: input.temp_coeff_voc_pct_per_c,
			lowestExpectedTempC: input.lowest_expected_temp_c,
			highestExpectedTempC: input.highest_expected_temp_c
		});

		return {
			valid: response.valid,
			violations: response.violations.map((violation) => ({
				code: violation.code,
				message: violation.message,
				limit: violation.limit,
				actual: violation.actual
			})),
			string_voc_cold_v: response.stringVocColdV,
			string_vmp_hot_v: response.stringVmpHotV,
			dc_string_power_kw: response.dcStringPowerKw,
			dc_ac_ratio: response.dcAcRatio,
			max_panels_per_string: response.maxPanelsPerString,
			min_panels_per_string: response.minPanelsPerString
		};
	},

	validateNetwork: async (input: {
		network_id: string;
		inverter_mppt_count?: number;
		max_strings_per_mppt?: number;
	}): Promise<ValidateNetworkResult> => {
		const response = await client.validateNetwork({
			networkId: input.network_id,
			inverterMpptCount: input.inverter_mppt_count ?? 0,
			maxStringsPerMppt: input.max_strings_per_mppt ?? 0
		});

		return {
			valid: response.valid,
			issues: response.issues.map((issue) => ({
				code: issue.code,
				message: issue.message,
				entity_id: issue.entityId
			})),
			total_strings: response.totalStrings,
			assigned_strings: response.assignedStrings,
			unassigned_strings: response.unassignedStrings,
			total_panels: response.totalPanels,
			duplicate_panel_refs: response.duplicatePanelRefs,
			total_dc_kw: response.totalDcKw,
			total_ac_kw: response.totalAcKw,
			dc_ac_ratio: response.dcAcRatio
		};
	},

	generateNetworkBOM: async (input: {
		network_id: string;
		panel_unit_cost?: number;
		inverter_unit_cost?: number;
		cable_cost_per_m?: number;
		mounting_cost_per_panel?: number;
		currency_code?: string;
	}): Promise<NetworkBOMResult> => {
		const response = await client.generateNetworkBOM({
			networkId: input.network_id,
			panelUnitCost: input.panel_unit_cost ?? 0,
			inverterUnitCost: input.inverter_unit_cost ?? 0,
			cableCostPerM: input.cable_cost_per_m ?? 0,
			mountingCostPerPanel: input.mounting_cost_per_panel ?? 0,
			currencyCode: input.currency_code ?? ''
		});

		return {
			network_id: response.networkId,
			panel_count: response.panelCount,
			string_count: response.stringCount,
			inverter_group_count: response.inverterGroupCount,
			total_dc_kw: response.totalDcKw,
			total_ac_kw: response.totalAcKw,
			items: response.items.map((item) => ({
				category: item.category,
				name: item.name,
				quantity: item.quantity,
				unit: item.unit,
				unit_cost: item.unitCost,
				total_cost: item.totalCost
			})),
			total_cost: response.totalCost,
			currency_code: response.currencyCode
		};
	},

	delete: async (id: string) => {
		await client.deleteNetwork({ id });
		return {};
	}
};
