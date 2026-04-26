/**
 * Centralised error handling for Solar3D frontend.
 *
 * Replaces silent `catch {}` blocks throughout the codebase with structured
 * logging + user-facing toast notifications. Mirrors the typed exception
 * hierarchy from the mobile app.
 */

export type ErrorCode =
  | 'INVALID_INPUT'
  | 'NOT_FOUND'
  | 'UNAUTHENTICATED'
  | 'PERMISSION_DENIED'
  | 'FAILED_PRECONDITION'
  | 'NETWORK_ERROR'
  | 'SERVER_ERROR'
  | 'TIMEOUT'
  | 'UNKNOWN';

export class Solar3DError extends Error {
  readonly code: ErrorCode;
  readonly details?: Record<string, unknown>;
  readonly cause?: unknown;

  constructor(code: ErrorCode, message: string, details?: Record<string, unknown>, cause?: unknown) {
    super(message);
    this.name = 'Solar3DError';
    this.code = code;
    this.details = details;
    this.cause = cause;
  }
}

/**
 * Maps a ConnectRPC error code string to a typed Solar3DError.
 */
export function fromConnectError(connectCode: string, message: string, details?: Record<string, unknown>): Solar3DError {
  const codeMap: Record<string, ErrorCode> = {
    invalid_argument: 'INVALID_INPUT',
    not_found: 'NOT_FOUND',
    unauthenticated: 'UNAUTHENTICATED',
    permission_denied: 'PERMISSION_DENIED',
    failed_precondition: 'FAILED_PRECONDITION',
    unavailable: 'NETWORK_ERROR',
    deadline_exceeded: 'TIMEOUT',
  };
  const code = codeMap[connectCode] ?? 'SERVER_ERROR';
  return new Solar3DError(code, message, details);
}

/**
 * Wraps a fetch / RPC call with structured error handling. Logs failures
 * with context and returns a typed Solar3DError instead of opaque rejections.
 */
export async function safeCall<T>(
  fn: () => Promise<T>,
  context: { operation: string; entity?: string }
): Promise<{ ok: true; data: T } | { ok: false; error: Solar3DError }> {
  try {
    const data = await fn();
    return { ok: true, data };
  } catch (e) {
    const err = normaliseError(e, context);
    structuredLog('error', context.operation, err);
    return { ok: false, error: err };
  }
}

function normaliseError(e: unknown, context: { operation: string; entity?: string }): Solar3DError {
  if (e instanceof Solar3DError) return e;
  if (e instanceof Error) {
    // Network errors typically come through as TypeError with message containing "fetch"
    if (e.name === 'TypeError' && /fetch|network/i.test(e.message)) {
      return new Solar3DError('NETWORK_ERROR', 'Network error — check your connection', { context }, e);
    }
    if (e.name === 'AbortError') {
      return new Solar3DError('TIMEOUT', 'Request was cancelled', { context }, e);
    }
    return new Solar3DError('UNKNOWN', e.message, { context }, e);
  }
  return new Solar3DError('UNKNOWN', 'An unexpected error occurred', { context, raw: String(e) });
}

/**
 * Structured logger. In production, ship to Datadog/Sentry/Honeycomb.
 * For now, console.* with consistent shape so logs are grep-able.
 */
export function structuredLog(level: 'info' | 'warn' | 'error', operation: string, payload: unknown): void {
  const entry = {
    ts: new Date().toISOString(),
    level,
    operation,
    payload: payload instanceof Solar3DError
      ? { code: payload.code, message: payload.message, details: payload.details }
      : payload,
  };
  // eslint-disable-next-line no-console
  (console[level] ?? console.log)('[solar3d]', JSON.stringify(entry));
}

/**
 * User-friendly error message for toast notifications.
 */
export function userMessage(err: Solar3DError): string {
  switch (err.code) {
    case 'INVALID_INPUT': return err.message;
    case 'NOT_FOUND': return err.message;
    case 'UNAUTHENTICATED': return 'Please sign in to continue';
    case 'PERMISSION_DENIED': return 'You don\'t have access to this feature';
    case 'FAILED_PRECONDITION': return err.message;
    case 'NETWORK_ERROR': return 'Unable to connect — check your internet';
    case 'SERVER_ERROR': return 'Something went wrong — please try again';
    case 'TIMEOUT': return 'Request timed out — please try again';
    default: return 'An unexpected error occurred';
  }
}
