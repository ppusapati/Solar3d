export type BimRole =
	| 'product_owner'
	| 'bim_architect'
	| 'cad_backend_lead'
	| 'compute_lead'
	| 'frontend_lead'
	| 'qa_lead'
	| 'devops_lead';

export interface SprintGate {
	id: string;
	name: string;
	required: boolean;
	description: string;
}

export interface AcceptanceMetric {
	id: string;
	name: string;
	target: string;
	measurement: string;
}

export interface RaciEntry {
	itemId: string;
	responsible: BimRole[];
	accountable: BimRole;
	consulted: BimRole[];
	informed: BimRole[];
}

export interface PrecisionTolerance {
	id: string;
	label: string;
	unit: 'm' | 'cm' | 'mm' | 'deg';
	tolerance: number;
}

export interface Sprint1Evidence {
	gateEvidence: Record<string, boolean>;
	approvedBy: Partial<Record<BimRole, boolean>>;
}

export interface Sprint1ReadinessReport {
	ready: boolean;
	missingGates: string[];
	missingApprovers: BimRole[];
}

export const SPRINT_1_ACCEPTANCE_MATRIX: AcceptanceMetric[] = [
	{
		id: 'bim-001',
		name: 'BIM object identity policy defined',
		target: '100% domain objects use canonical ID strategy',
		measurement: 'schema review + contract lint'
	},
	{
		id: 'bim-002',
		name: 'Revision traceability baseline',
		target: 'All CAD write paths carry provenance metadata',
		measurement: 'api/store unit tests'
	},
	{
		id: 'bim-003',
		name: 'Precision baseline approved',
		target: 'Defined tolerances for geo, distance, and angle',
		measurement: 'baseline config validation'
	},
	{
		id: 'bim-004',
		name: 'Sprint gating in place',
		target: 'All mandatory Sprint 1 gates evaluable',
		measurement: 'readiness evaluator'
	}
];

export const SPRINT_1_EXIT_GATES: SprintGate[] = [
	{
		id: 'gate_acceptance_matrix',
		name: 'Acceptance Matrix Locked',
		required: true,
		description: 'Acceptance metrics are frozen and versioned.'
	},
	{
		id: 'gate_precision_baseline',
		name: 'Precision Baseline Approved',
		required: true,
		description: 'Measurement units and tolerances approved by engineering.'
	},
	{
		id: 'gate_raci_approved',
		name: 'Governance RACI Approved',
		required: true,
		description: 'Role ownership and approval chain are approved.'
	},
	{
		id: 'gate_traceability_wired',
		name: 'Traceability Metadata Wired',
		required: true,
		description: 'CAD write paths include stable provenance metadata.'
	}
];

export const SPRINT_1_PRECISION_BASELINE: PrecisionTolerance[] = [
	{ id: 'tol_geo_xy', label: 'Geo XY placement', unit: 'm', tolerance: 0.1 },
	{ id: 'tol_linear_detail', label: 'Detailed engineering linear', unit: 'mm', tolerance: 5 },
	{ id: 'tol_angle', label: 'Angular tolerance', unit: 'deg', tolerance: 0.5 },
	{ id: 'tol_route_length', label: 'Route length parity', unit: 'cm', tolerance: 10 }
];

export const SPRINT_1_GOVERNANCE_RACI: RaciEntry[] = [
	{
		itemId: 'gate_acceptance_matrix',
		responsible: ['product_owner', 'bim_architect'],
		accountable: 'product_owner',
		consulted: ['qa_lead', 'frontend_lead'],
		informed: ['compute_lead', 'cad_backend_lead', 'devops_lead']
	},
	{
		itemId: 'gate_precision_baseline',
		responsible: ['bim_architect', 'compute_lead'],
		accountable: 'bim_architect',
		consulted: ['cad_backend_lead', 'frontend_lead'],
		informed: ['product_owner', 'qa_lead', 'devops_lead']
	},
	{
		itemId: 'gate_raci_approved',
		responsible: ['product_owner'],
		accountable: 'product_owner',
		consulted: ['bim_architect', 'cad_backend_lead', 'compute_lead', 'frontend_lead'],
		informed: ['qa_lead', 'devops_lead']
	},
	{
		itemId: 'gate_traceability_wired',
		responsible: ['cad_backend_lead', 'frontend_lead'],
		accountable: 'cad_backend_lead',
		consulted: ['bim_architect', 'compute_lead'],
		informed: ['product_owner', 'qa_lead', 'devops_lead']
	}
];

const REQUIRED_APPROVERS: BimRole[] = ['product_owner', 'bim_architect', 'cad_backend_lead', 'compute_lead'];

export function evaluateSprint1Readiness(evidence: Sprint1Evidence): Sprint1ReadinessReport {
	const missingGates = SPRINT_1_EXIT_GATES
		.filter((gate) => gate.required)
		.filter((gate) => !evidence.gateEvidence[gate.id])
		.map((gate) => gate.id);

	const missingApprovers = REQUIRED_APPROVERS.filter((role) => !evidence.approvedBy[role]);

	return {
		ready: missingGates.length === 0 && missingApprovers.length === 0,
		missingGates,
		missingApprovers
	};
}
