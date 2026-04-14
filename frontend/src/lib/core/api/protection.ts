import {
	ProtectionService,
	type ProtectionStudy as ProtoProtectionStudy
} from '$lib/gen/protection/v1/protection_pb.js';

import { createApiClient, timestampToIso } from './connect';

export interface ProtectionStudy {
	id: string;
	project_id: string;
	name: string;
	system_voltage_kv: number;
	source_impedance_pu: number;
	mva_base: number;
	created_at: string;
}

const client = createApiClient(ProtectionService);

function mapStudy(study?: ProtoProtectionStudy): ProtectionStudy {
	if (!study) {
		throw new Error('Protection study response was empty');
	}
	return {
		id: study.id,
		project_id: study.projectId,
		name: study.name,
		system_voltage_kv: study.systemVoltageKv,
		source_impedance_pu: study.sourceImpedancePu,
		mva_base: study.mvaBase,
		created_at: timestampToIso(study.createdAt)
	};
}

export const protectionApi = {
	createStudy: async (input: {
		project_id: string;
		name: string;
		system_voltage_kv: number;
		source_impedance_pu: number;
		mva_base: number;
	}) => {
		const response = await client.createStudy({
			projectId: input.project_id,
			name: input.name,
			systemVoltageKv: input.system_voltage_kv,
			sourceImpedancePu: input.source_impedance_pu,
			mvaBase: input.mva_base
		});
		return { study: mapStudy(response.study) };
	},

	getStudy: async (id: string) => {
		const response = await client.getStudy({ id });
		return { study: mapStudy(response.study) };
	},

	listStudies: async (projectId: string) => {
		const response = await client.listStudies({ projectId });
		return { studies: response.studies.map(mapStudy) };
	},

	computeShortCircuit: async (studyId: string, input: {
		voltage_kv: number;
		source_impedance_ohm: number;
		cable_resistance_ohm: number;
		cable_reactance_ohm: number;
		zero_seq_impedance_ohm?: number;
		include_single_line_to_ground?: boolean;
	}) => {
		return client.computeShortCircuit({
			studyId,
			voltageKv: input.voltage_kv,
			sourceImpedanceOhm: input.source_impedance_ohm,
			cableResistanceOhm: input.cable_resistance_ohm,
			cableReactanceOhm: input.cable_reactance_ohm,
			zeroSeqImpedanceOhm: input.zero_seq_impedance_ohm ?? 0,
			includeSingleLineToGround: input.include_single_line_to_ground ?? false
		});
	},

	computeEarthFault: async (studyId: string, input: {
		voltage_kv: number;
		earthing_method: number;
		ngr_resistance_ohm?: number;
		cable_resistance_ohm: number;
	}) => {
		return client.computeEarthFault({
			studyId,
			voltageKv: input.voltage_kv,
			earthingMethod: input.earthing_method,
			ngrResistanceOhm: input.ngr_resistance_ohm ?? 0,
			cableResistanceOhm: input.cable_resistance_ohm
		});
	},

	selectRelay: async (studyId: string, input: {
		fault_current_ka: number;
		load_current_a: number;
		preferred_characteristic?: number;
	}) => {
		return client.selectRelay({
			studyId,
			faultCurrentKa: input.fault_current_ka,
			loadCurrentA: input.load_current_a,
			preferredCharacteristic: input.preferred_characteristic ?? 0
		});
	},

	computeRelaySettings: async (studyId: string, input: {
		characteristic: number;
		pickup_current_a: number;
		time_dial_setting: number;
		fault_current_a: number;
	}) => {
		return client.computeRelaySettings({
			studyId,
			characteristic: input.characteristic,
			pickupCurrentA: input.pickup_current_a,
			timeDialSetting: input.time_dial_setting,
			faultCurrentA: input.fault_current_a
		});
	},

	validateCoordination: async (studyId: string, pairs: Array<{
		upstream_relay_id: string;
		downstream_relay_id: string;
		upstream_time_s: number;
		downstream_time_s: number;
		margin_s: number;
	}>, minimum_margin_s = 0.3) => {
		return client.validateCoordination({
			studyId,
			pairs: pairs.map((p) => ({
				upstreamRelayId: p.upstream_relay_id,
				downstreamRelayId: p.downstream_relay_id,
				upstreamTimeS: p.upstream_time_s,
				downstreamTimeS: p.downstream_time_s,
				marginS: p.margin_s
			})),
			minimumMarginS: minimum_margin_s
		});
	},

	generateReport: async (studyId: string) => {
		return client.generateProtectionReport({ studyId });
	}
};
