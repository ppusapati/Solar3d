import {
	StructuralService,
	type FoundationResult as ProtoFoundationResult,
	type StructuralDesign as ProtoStructuralDesign
} from '$lib/gen/structural/v1/structural_pb.js';

import { createApiClient, timestampToIso } from './connect';

export interface FoundationResult {
	pile_count: number;
	design_load_kn: number;
	pile_spacing_m: number;
	foundation_type: number;
	pile_capacity_kn: number;
	load_combination: string;
}

export interface StructuralDesign {
	id: string;
	project_id: string;
	name: string;
	review_state: number;
	reviewed_by: string;
	review_notes: string;
	created_at: string;
	updated_at: string;
	dead_load_kn: number;
	wind_load_kn: number;
	seismic_load_kn: number;
	governing_load_kn: number;
	foundation?: FoundationResult;
}

const client = createApiClient(StructuralService);

function mapFoundation(result?: ProtoFoundationResult): FoundationResult | undefined {
	if (!result) {
		return undefined;
	}
	return {
		pile_count: result.pileCount,
		design_load_kn: result.designLoadKn,
		pile_spacing_m: result.pileSpacingM,
		foundation_type: Number(result.foundationType),
		pile_capacity_kn: result.pileCapacityKn,
		load_combination: result.loadCombination
	};
}

function mapDesign(design?: ProtoStructuralDesign): StructuralDesign {
	if (!design) {
		throw new Error('Structural design response was empty');
	}
	return {
		id: design.id,
		project_id: design.projectId,
		name: design.name,
		review_state: Number(design.reviewState),
		reviewed_by: design.reviewedBy,
		review_notes: design.reviewNotes,
		created_at: timestampToIso(design.createdAt),
		updated_at: timestampToIso(design.updatedAt),
		dead_load_kn: design.deadLoadKn,
		wind_load_kn: design.windLoadKn,
		seismic_load_kn: design.seismicLoadKn,
		governing_load_kn: design.governingLoadKn,
		foundation: mapFoundation(design.foundation)
	};
}

export const structuralApi = {
	createDesign: async (input: { project_id: string; name: string }) => {
		const response = await client.createDesign({ projectId: input.project_id, name: input.name });
		return { design: mapDesign(response.design) };
	},

	getDesign: async (id: string) => {
		const response = await client.getDesign({ id });
		return { design: mapDesign(response.design) };
	},

	listDesigns: async (projectId: string) => {
		const response = await client.listDesigns({ projectId });
		return { designs: response.designs.map(mapDesign) };
	},

	computeDeadLoad: async (designId: string, input: { panel_count: number; panel_mass_kg?: number; mounting_mass_per_panel_kg?: number; cable_mass_kg?: number }) => {
		return client.computeDeadLoad({
			designId,
			panelCount: input.panel_count,
			panelMassKg: input.panel_mass_kg ?? 0,
			mountingMassPerPanelKg: input.mounting_mass_per_panel_kg ?? 0,
			cableMassKg: input.cable_mass_kg ?? 0
		});
	},

	computeWindLoad: async (designId: string, input: { wind_speed_m_s: number; exposure: number; height_m: number; panel_tilt_deg: number; total_panel_area_sqm: number; k_zt?: number; k_d?: number; gust_factor?: number }) => {
		return client.computeWindLoad({
			designId,
			windSpeedMS: input.wind_speed_m_s,
			exposure: input.exposure,
			heightM: input.height_m,
			panelTiltDeg: input.panel_tilt_deg,
			totalPanelAreaSqm: input.total_panel_area_sqm,
			kZt: input.k_zt ?? 0,
			kD: input.k_d ?? 0,
			gustFactor: input.gust_factor ?? 0
		});
	},

	computeSeismicLoad: async (designId: string, input: { sds: number; total_mass_kg: number; r_factor?: number; importance_factor?: number; cs_override?: number }) => {
		return client.computeSeismicLoad({
			designId,
			sds: input.sds,
			totalMassKg: input.total_mass_kg,
			rFactor: input.r_factor ?? 0,
			importanceFactor: input.importance_factor ?? 0,
			csOverride: input.cs_override ?? 0
		});
	},

	computeFoundation: async (designId: string, input: { dead_load_kn: number; wind_load_kn: number; seismic_load_kn: number; foundation_type: number; pile_capacity_kn?: number; total_area_sqm?: number }) => {
		return client.computeFoundationRequirement({
			designId,
			deadLoadKn: input.dead_load_kn,
			windLoadKn: input.wind_load_kn,
			seismicLoadKn: input.seismic_load_kn,
			foundationType: input.foundation_type,
			pileCapacityKn: input.pile_capacity_kn ?? 0,
			totalAreaSqm: input.total_area_sqm ?? 0
		});
	},

	validateDesign: async (designId: string, input: { max_wind_pressure_pa?: number; max_seismic_coefficient?: number }) => {
		return client.validateStructuralDesign({
			designId,
			maxWindPressurePa: input.max_wind_pressure_pa ?? 0,
			maxSeismicCoefficient: input.max_seismic_coefficient ?? 0
		});
	},

	submitForReview: async (designId: string, submittedBy: string, notes = '') => {
		return client.submitForReview({ designId, submittedBy, notes });
	},

	approveDesign: async (designId: string, approvedBy: string, notes = '') => {
		return client.approveDesign({ designId, approvedBy, notes });
	},

	rejectDesign: async (designId: string, rejectedBy: string, reason: string) => {
		return client.rejectDesign({ designId, rejectedBy, reason });
	},

	generateReport: async (designId: string) => {
		return client.generateStructuralReport({ designId });
	}
};
