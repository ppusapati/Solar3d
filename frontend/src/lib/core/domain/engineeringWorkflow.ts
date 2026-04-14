import { JobStatus, JobType, type Job } from '$lib/gen/orchestration/v1/orchestration_pb.js';

export type StructuralOrchestrationInput = {
	operation: string;
	design_id: string;
	panel_count: number;
	panel_mass_kg: number;
	mounting_mass_per_panel_kg: number;
	cable_mass_kg: number;
	wind_speed_m_s: number;
	total_panel_area_sqm: number;
	sds: number;
	total_mass_kg: number;
	pile_capacity_kn: number;
};

export type ProtectionOrchestrationInput = {
	operation: string;
	study_id: string;
	voltage_kv: number;
	source_impedance_ohm: number;
	cable_resistance_ohm: number;
	cable_reactance_ohm: number;
	zero_seq_impedance_ohm: number;
	fault_current_ka: number;
	load_current_a: number;
	characteristic: number;
	pickup_current_a: number;
	time_dial_setting: number;
	fault_current_a: number;
};

export type OrchestrationSubmitRequest = {
	projectId: string;
	type: JobType;
	priority: number;
	maxAttempts: number;
	payloadJson: string;
};

export function buildStructuralOrchestrationPayload(input: StructuralOrchestrationInput): string {
	return JSON.stringify(input);
}

export function buildProtectionOrchestrationPayload(input: ProtectionOrchestrationInput): string {
	return JSON.stringify({
		...input,
		fault_current_a: Math.max(1, input.fault_current_a)
	});
}

export function buildStructuralSubmitJobRequest(
	projectId: string,
	input: StructuralOrchestrationInput,
	priority = 60,
	maxAttempts = 3
): OrchestrationSubmitRequest {
	return {
		projectId,
		type: JobType.STRUCTURAL_LOAD_ANALYSIS,
		priority,
		maxAttempts,
		payloadJson: buildStructuralOrchestrationPayload(input)
	};
}

export function buildProtectionSubmitJobRequest(
	projectId: string,
	input: ProtectionOrchestrationInput,
	priority = 60,
	maxAttempts = 3
): OrchestrationSubmitRequest {
	return {
		projectId,
		type: JobType.PROTECTION_STUDY,
		priority,
		maxAttempts,
		payloadJson: buildProtectionOrchestrationPayload(input)
	};
}

export function orchestrationStatusLabel(status: JobStatus): string {
	switch (status) {
		case JobStatus.QUEUED:
			return 'Queued';
		case JobStatus.RUNNING:
			return 'Running';
		case JobStatus.SUCCEEDED:
			return 'Succeeded';
		case JobStatus.FAILED:
			return 'Failed';
		case JobStatus.CANCELED:
			return 'Canceled';
		case JobStatus.RETRY_PENDING:
			return 'Retry Pending';
		default:
			return 'Unknown';
	}
}

export function summarizeEngineeringSnapshot(
	structuralDesigns: Array<{ review_state: number }>,
	protectionStudies: Array<{ id: string }>,
	jobs: Job[]
): {
	structural_designs: number;
	protection_studies: number;
	structural_jobs: number;
	protection_jobs: number;
	structural_approved: number;
	structural_in_review: number;
} {
	return {
		structural_designs: structuralDesigns.length,
		protection_studies: protectionStudies.length,
		structural_jobs: jobs.filter((job) => job.type === JobType.STRUCTURAL_LOAD_ANALYSIS).length,
		protection_jobs: jobs.filter((job) => job.type === JobType.PROTECTION_STUDY).length,
		structural_approved: structuralDesigns.filter((d) => d.review_state === 3).length,
		structural_in_review: structuralDesigns.filter((d) => d.review_state === 2).length
	};
}
