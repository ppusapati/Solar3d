import { describe, expect, it } from 'vitest';
import {
	SPRINT_1_ACCEPTANCE_MATRIX,
	SPRINT_1_EXIT_GATES,
	SPRINT_1_GOVERNANCE_RACI,
	SPRINT_1_PRECISION_BASELINE,
	evaluateSprint1Readiness
} from './bimProgram';

describe('bim program sprint 1 artifacts', () => {
	it('defines all required sprint 1 baseline artifacts', () => {
		expect(SPRINT_1_ACCEPTANCE_MATRIX.length).toBeGreaterThan(0);
		expect(SPRINT_1_EXIT_GATES.filter((gate) => gate.required).length).toBeGreaterThan(0);
		expect(SPRINT_1_GOVERNANCE_RACI.length).toBeGreaterThan(0);
		expect(SPRINT_1_PRECISION_BASELINE.length).toBeGreaterThan(0);
	});

	it('reports missing gates and approvers when evidence is incomplete', () => {
		const report = evaluateSprint1Readiness({
			gateEvidence: {
				gate_acceptance_matrix: true,
				gate_precision_baseline: false,
				gate_raci_approved: false,
				gate_traceability_wired: true
			},
			approvedBy: {
				product_owner: true,
				bim_architect: false,
				cad_backend_lead: true,
				compute_lead: false
			}
		});

		expect(report.ready).toBe(false);
		expect(report.missingGates).toEqual(['gate_precision_baseline', 'gate_raci_approved']);
		expect(report.missingApprovers).toEqual(['bim_architect', 'compute_lead']);
	});

	it('marks sprint 1 ready when all mandatory evidence is present', () => {
		const report = evaluateSprint1Readiness({
			gateEvidence: {
				gate_acceptance_matrix: true,
				gate_precision_baseline: true,
				gate_raci_approved: true,
				gate_traceability_wired: true
			},
			approvedBy: {
				product_owner: true,
				bim_architect: true,
				cad_backend_lead: true,
				compute_lead: true
			}
		});

		expect(report.ready).toBe(true);
		expect(report.missingGates).toEqual([]);
		expect(report.missingApprovers).toEqual([]);
	});
});
