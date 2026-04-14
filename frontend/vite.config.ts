import fs from 'node:fs';
import path from 'node:path';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vitest/config';
import { loadEnv } from 'vite';
import type { Plugin } from 'vite';

function copyCesiumAssets(): Plugin {
	const sourceRoot = path.resolve('node_modules/cesium/Build/Cesium');
	const targetRoot = path.resolve('static/cesium');
	const assetDirs = ['Assets', 'ThirdParty', 'Workers', 'Widgets'];

	const syncAssets = () => {
		if (!fs.existsSync(sourceRoot)) return;

		fs.mkdirSync(targetRoot, { recursive: true });
		for (const dir of assetDirs) {
			fs.cpSync(path.join(sourceRoot, dir), path.join(targetRoot, dir), {
				force: true,
				recursive: true
			});
		}
	};

	return {
		name: 'copy-cesium-assets',
		configureServer() {
			syncAssets();
		},
		buildStart() {
			syncAssets();
		}
	};
}

export default defineConfig(({ mode }) => {
	// Load .env so PORT_* vars are available for proxy targets even without OS env
	// Also load root .env (one level up) so PORT_MONOLITH is shared with the monolith binary
	const env = {
		...loadEnv(mode, path.resolve('..'), ''),   // root .env (PORT_MONOLITH lives here)
		...loadEnv(mode, process.cwd(), '')          // frontend/.env (overrides root)
	};
	const port = (key: string, fallback: number) => Number(env[key] || process.env[key] || fallback);

	return {
	plugins: [copyCesiumAssets(), sveltekit()],
	server: {
		proxy: {
			// All ConnectRPC service paths route to the monolith on a single port
			// Use PORT_MONOLITH or fall back to 9191
			'^/.*\\.v1\\.': { target: `http://127.0.0.1:${port('PORT_MONOLITH', 9191)}`, changeOrigin: true },
			'/api/v1':      { target: `http://127.0.0.1:${port('PORT_MONOLITH', 9191)}`, changeOrigin: true },
			'/healthz':     { target: `http://127.0.0.1:${port('PORT_MONOLITH', 9191)}`, changeOrigin: true },
		}
	},
	build: {
		chunkSizeWarningLimit: 6000,
		rollupOptions: {
			output: {
				manualChunks(id) {
					if (!id.includes('node_modules') && !id.includes('/src/lib/gen/')) {
						return undefined;
					}

					if (id.includes('node_modules/cesium')) {
						return 'vendor-cesium';
					}

					if (id.includes('node_modules/@bufbuild') || id.includes('node_modules/protobufjs') || id.includes('/src/lib/gen/')) {
						return 'vendor-contracts';
					}

					if (id.includes('node_modules/@connectrpc')) {
						return 'vendor-connect';
					}

					if (id.includes('node_modules/svelte') || id.includes('node_modules/@sveltejs')) {
						return 'vendor-svelte';
					}

					return 'vendor-misc';
				}
			}
		}
	},
	define: {
		CESIUM_BASE_URL: JSON.stringify('/cesium')
	},
	test: {
		environment: 'node',
		include: ['src/**/*.test.ts']
	}
	};
});
