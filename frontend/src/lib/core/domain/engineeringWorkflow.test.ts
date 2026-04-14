import { describe, expect, it } from 'vitest';
import { JobStatus, JobType, type Job } from '$lib/gen/orchestration/v1/orchestration_pb.js';
import {
	buildProtectionSubmitJobRequest,
	buildProtectionOrchestrationPayload,
	buildStructuralSubmitJobRequest,
	buildStructuralOrchestrationPayload,
	orchestrationStatusLabel,
	summarizeEngineeringSnapshot
} from './engineeringWorkflow';

describe('engineering workflow helpers', () => {
	it('builds structural orchestration payload with required fields', () => {
		const payload = buildStructuralOrchestrationPayload({
			operation: 'dead_load',
			design_id: 'design-1',
			panel_count: 100,
			panel_mass_kg: 25,
			mounting_mass_per_panel_kg: 15,
			cable_mass_kg: 300,
			wind_speed_m_s: 40,
			total_panel_area_sqm: 500,
			sds: 0.6,
			total_mass_kg: 10000,
			pile_capacity_kn: 50
		});
		const parsed = JSON.parse(payload);
		expect(parsed.operation).toBe('dead_load');
		expect(parsed.design_id).toBe('design-1');
		expect(parsed.panel_count).toBe(100);
	});

	it('clamps protection fault current before serializing payload', () => {
		const payload = buildProtectionOrchestrationPayload({
			operation: 'relay_settings',
			study_id: 'study-1',
			voltage_kv: 33,
			source_impedance_ohm: 1.2,
			cable_resistance_ohm: 0.3,
			cable_reactance_ohm: 0.4,
			zero_seq_impedance_ohm: 0.6,
			fault_current_ka: 8.5,
			load_current_a: 400,
			characteristic: 1,
			pickup_current_a: 480,
			time_dial_setting: 0.1,
			fault_current_a: 0
		});
		const parsed = JSON.parse(payload);
		expect(parsed.fault_current_a).toBe(1);
	});

	it('builds structural submit request envelope for orchestration client', () => {
		const request = buildStructuralSubmitJobRequest('project-1', {
			operation: 'wind_load',
			design_id: 'design-1',
			panel_count: 100,
			panel_mass_kg: 25,
			mounting_mass_per_panel_kg: 15,
			cable_mass_kg: 300,
			wind_speed_m_s: 40,
			total_panel_area_sqm: 500,
			sds: 0.6,
			total_mass_kg: 10000,
			pile_capacity_kn: 50
		});
		expect(request.projectId).toBe('project-1');
		expect(request.type).toBe(JobType.STRUCTURAL_LOAD_ANALYSIS);
		expect(request.priority).toBe(60);
		expect(request.maxAttempts).toBe(3);
		expect(JSON.parse(request.payloadJson).operation).toBe('wind_load');
	});

	it('builds protection submit request envelope for orchestration client', () => {
		const request = buildProtectionSubmitJobRequest('project-2', {
			operation: 'relay_settings',
			study_id: 'study-1',
			voltage_kv: 33,
			source_impedance_ohm: 1.2,
			cable_resistance_ohm: 0.3,
			cable_reactance_ohm: 0.4,
			zero_seq_impedance_ohm: 0.6,
			fault_current_ka: 8.5,
			load_current_a: 400,
			characteristic: 1,
			pickup_current_a: 480,
			time_dial_setting: 0.1,
			fault_current_a: 0
		});
		expect(request.projectId).toBe('project-2');
		expect(request.type).toBe(JobType.PROTECTION_STUDY);
		expect(request.priority).toBe(60);
		expect(request.maxAttempts).toBe(3);
		expect(JSON.parse(request.payloadJson).fault_current_a).toBe(1);
	});

	it('maps orchestration status labels', () => {
		expect(orchestrationStatusLabel(JobStatus.QUEUED)).toBe('Queued');
		expect(orchestrationStatusLabel(JobStatus.RUNNING)).toBe('Running');
		expect(orchestrationStatusLabel(JobStatus.SUCCEEDED)).toBe('Succeeded');
		expect(orchestrationStatusLabel(JobStatus.UNSPECIFIED)).toBe('Unknown');
	});

	it('summarizes engineering snapshot counts for reporting panel', () => {
		const jobs = [
			{ type: JobType.STRUCTURAL_LOAD_ANALYSIS },
			{ type: JobType.STRUCTURAL_LOAD_ANALYSIS },
			{ type: JobType.PROTECTION_STUDY },
			{ type: JobType.CUSTOM }
		] as Job[];
		const summary = summarizeEngineeringSnapshot(
			[{ review_state: 2 }, { review_state: 3 }, { review_state: 3 }],
			[{ id: 'p1' }, { id: 'p2' }],
			jobs
		);
		expect(summary.structural_designs).toBe(3);
		expect(summary.protection_studies).toBe(2);
		expect(summary.structural_jobs).toBe(2);
		expect(summary.protection_jobs).toBe(1);
		expect(summary.structural_approved).toBe(2);
		expect(summary.structural_in_review).toBe(1);
	});
});
