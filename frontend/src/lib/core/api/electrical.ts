import { api } from './client';

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
	name: string;
	panel_count: number;
	voltage_v: number;
	current_a: number;
	power_w: number;
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

export const electricalApi = {
	createNetwork: (data: {
		project_id: string;
		layout_id: string;
		name: string;
	}) => api.post<{ network: ElectricalNetwork }>('/api/v1/electrical/networks', data),

	getNetwork: (id: string) =>
		api.get<{ network: ElectricalNetwork }>(`/api/v1/electrical/networks/${id}`),

	listNetworks: (projectId: string) =>
		api.get<{ networks: ElectricalNetwork[] }>(
			`/api/v1/electrical/networks?project_id=${projectId}`
		),

	autoGenerateStrings: (networkId: string, data: {
		total_panels: number;
		panels_per_string: number;
		strings_per_inverter: number;
		panel_vmp: number;
		panel_imp: number;
	}) => api.post<{ network: ElectricalNetwork }>(
		`/api/v1/electrical/networks/${networkId}/auto-generate`,
		data
	),

	calculateLosses: (networkId: string) =>
		api.get<{ losses: LossBreakdown }>(
			`/api/v1/electrical/networks/${networkId}/losses`
		),

	delete: (id: string) => api.delete(`/api/v1/electrical/networks/${id}`)
};
