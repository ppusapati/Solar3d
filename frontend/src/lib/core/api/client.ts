// In dev the Vite server proxy routes each /package.v1.* path to the correct backend port.
// Set VITE_API_BASE_URL only when pointing directly at a remote API (production/staging).
export const API_BASE = import.meta.env.VITE_API_BASE_URL ?? '';

interface RequestOptions {
	method?: string;
	body?: unknown;
	headers?: Record<string, string>;
}

class ApiError extends Error {
	constructor(
		public status: number,
		message: string
	) {
		super(message);
		this.name = 'ApiError';
	}
}

async function request<T>(path: string, options: RequestOptions = {}): Promise<T> {
	const { method = 'GET', body, headers = {} } = options;

	const config: RequestInit = {
		method,
		headers: {
			'Content-Type': 'application/json',
			...headers
		}
	};

	if (body) {
		config.body = JSON.stringify(body);
	}

	const response = await fetch(`${API_BASE}${path}`, config);

	if (!response.ok) {
		const errorBody = await response.text();
		throw new ApiError(response.status, errorBody || response.statusText);
	}

	if (response.status === 204) {
		return {} as T;
	}

	return response.json();
}

export const api = {
	get: <T>(path: string) => request<T>(path),
	post: <T>(path: string, body: unknown) => request<T>(path, { method: 'POST', body }),
	put: <T>(path: string, body: unknown) => request<T>(path, { method: 'PUT', body }),
	delete: <T>(path: string) => request<T>(path, { method: 'DELETE' })
};

export { ApiError };
