/**
 * Form validation schemas for Solar3D web frontend (using Zod).
 *
 * Each schema returns a `ValidationResult` that components consume to
 * display field-level error messages and gate form submission.
 */
import { z } from 'zod';

// ── Reusable primitives ────────────────────────────────────────────────

const positiveNumber = (field = 'Value') =>
  z.number({ message: `${field} must be a number` }).positive(`${field} must be positive`);

const nonNegativeNumber = (field = 'Value') =>
  z.number({ message: `${field} must be a number` }).nonnegative(`${field} must be non-negative`);

const inRange = (field: string, min: number, max: number) =>
  z.number({ message: `${field} must be a number` })
    .min(min, `${field} must be ≥ ${min}`)
    .max(max, `${field} must be ≤ ${max}`);

const uuidString = (field = 'ID') =>
  z.string().uuid(`${field} must be a valid UUID`);

// ── Domain schemas ─────────────────────────────────────────────────────

export const ProjectCreateSchema = z.object({
  name: z.string().min(1, 'Project name is required').max(255),
  description: z.string().max(2000).optional(),
  capacityMW: positiveNumber('Capacity'),
  latitude: inRange('Latitude', -90, 90),
  longitude: inRange('Longitude', -180, 180),
  clientName: z.string().max(255).optional(),
});

export const LayoutCreateSchema = z.object({
  projectId: uuidString('Project ID'),
  name: z.string().min(1, 'Layout name is required'),
  tiltDeg: inRange('Tilt', 0, 90),
  azimuthDeg: inRange('Azimuth', 0, 360),
  rowSpacingM: positiveNumber('Row spacing'),
  panelModel: z.string().min(1, 'Panel model is required'),
});

export const InverterStringSizingSchema = z.object({
  modulesPerString: z.number().int().positive(),
  stringsParallel: z.number().int().positive(),
  inverterModel: z.string().min(1),
  minTempC: inRange('Min temperature', -50, 50),
  maxTempC: inRange('Max temperature', 0, 100),
});

export const SimulationConfigSchema = z.object({
  projectId: uuidString('Project ID'),
  startDate: z.string().refine((s) => !isNaN(Date.parse(s)), 'Invalid start date'),
  endDate: z.string().refine((s) => !isNaN(Date.parse(s)), 'Invalid end date'),
  weatherSource: z.enum(['pvgis', 'nasa_power', 'nsrdb', 'era5', 'tmy_upload']),
  systemCapacityKW: positiveNumber('System capacity'),
  performanceRatio: inRange('PR', 0.5, 1.0),
});

export const ReportRequestSchema = z.object({
  projectId: uuidString('Project ID'),
  reportType: z.enum(['bom', 'energy', 'financial', 'engineering', 'commissioning']),
  format: z.enum(['pdf', 'csv', 'xlsx', 'json']),
  includeImages: z.boolean().default(true),
});

// ── Validation helper ──────────────────────────────────────────────────

export interface FieldErrors {
  [field: string]: string;
}

export interface ValidationResult<T> {
  success: boolean;
  data?: T;
  errors?: FieldErrors;
}

/**
 * Runs a Zod schema and returns a friendly result with per-field errors.
 */
export function validate<T>(schema: z.ZodSchema<T>, input: unknown): ValidationResult<T> {
  const result = schema.safeParse(input);
  if (result.success) {
    return { success: true, data: result.data };
  }
  const errors: FieldErrors = {};
  for (const issue of result.error.issues) {
    const path = issue.path.join('.');
    if (!errors[path]) errors[path] = issue.message;
  }
  return { success: false, errors };
}
