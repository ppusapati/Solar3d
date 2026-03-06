<script lang="ts">
	import { onDestroy } from 'svelte';
	import { terrainApi, type ElevationGrid } from '$lib/core/api';

	export let viewer: any;
	export let visible: boolean = false;
	export let projectId: string = '';
	export let mode: 'elevation' | 'slope' | 'aspect' = 'elevation';

	let Cesium: any;
	let heatmapEntity: any = null;
	let loading = false;

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: if (visible && projectId && Cesium && viewer) {
		loadHeatmap();
	}

	$: if (!visible) {
		clearHeatmap();
	}

	async function loadHeatmap() {
		if (loading || !projectId) return;
		loading = true;

		clearHeatmap();

		try {
			// Get current viewport bounds
			const rect = viewer.camera.computeViewRectangle();
			if (!rect) return;

			const bounds = {
				min_x: Cesium.Math.toDegrees(rect.west),
				min_y: Cesium.Math.toDegrees(rect.south),
				max_x: Cesium.Math.toDegrees(rect.east),
				max_y: Cesium.Math.toDegrees(rect.north)
			};

			const resolution = Math.max(
				(bounds.max_x - bounds.min_x) / 50,
				(bounds.max_y - bounds.min_y) / 50
			);

			const grid = await terrainApi.getElevationGrid(projectId, bounds, resolution);
			renderHeatmap(grid, bounds);
		} catch (err) {
			console.error('Terrain heatmap failed:', err);
		} finally {
			loading = false;
		}
	}

	function renderHeatmap(grid: ElevationGrid, bounds: { min_x: number; min_y: number; max_x: number; max_y: number }) {
		if (!Cesium || !viewer) return;

		// Create a canvas-based heatmap image
		const canvas = document.createElement('canvas');
		canvas.width = grid.width;
		canvas.height = grid.height;
		const ctx = canvas.getContext('2d');
		if (!ctx) return;

		const imgData = ctx.createImageData(grid.width, grid.height);
		const range = grid.max_elevation - grid.min_elevation || 1;

		for (let y = 0; y < grid.height; y++) {
			for (let x = 0; x < grid.width; x++) {
				const idx = y * grid.width + x;
				const elev = grid.elevations[idx] || 0;
				const t = (elev - grid.min_elevation) / range;

				let r: number, g: number, b: number;

				if (mode === 'elevation') {
					// Green-yellow-red gradient
					if (t < 0.5) {
						r = Math.round(t * 2 * 255);
						g = 200;
						b = 50;
					} else {
						r = 255;
						g = Math.round((1 - (t - 0.5) * 2) * 200);
						b = 50;
					}
				} else if (mode === 'slope') {
					// Compute slope from neighbors
					const slope = computeLocalSlope(grid, x, y);
					const st = Math.min(slope / 30, 1); // 30% = max
					r = Math.round(st * 255);
					g = Math.round((1 - st) * 200);
					b = 50;
				} else {
					// Aspect: compass direction coloring
					const aspect = computeLocalAspect(grid, x, y);
					const hue = (aspect / 360) * 360;
					const rgb = hslToRgb(hue / 360, 0.7, 0.5);
					r = rgb[0]; g = rgb[1]; b = rgb[2];
				}

				const pIdx = (y * grid.width + x) * 4;
				imgData.data[pIdx] = r;
				imgData.data[pIdx + 1] = g;
				imgData.data[pIdx + 2] = b;
				imgData.data[pIdx + 3] = 150; // semi-transparent
			}
		}

		ctx.putImageData(imgData, 0, 0);

		heatmapEntity = viewer.entities.add({
			rectangle: {
				coordinates: Cesium.Rectangle.fromDegrees(bounds.min_x, bounds.min_y, bounds.max_x, bounds.max_y),
				material: new Cesium.ImageMaterialProperty({
					image: canvas,
					transparent: true
				}),
				classificationType: Cesium.ClassificationType.TERRAIN
			}
		});
	}

	function computeLocalSlope(grid: ElevationGrid, x: number, y: number): number {
		if (x <= 0 || x >= grid.width - 1 || y <= 0 || y >= grid.height - 1) return 0;
		const dx = (grid.elevations[y * grid.width + (x + 1)] - grid.elevations[y * grid.width + (x - 1)]) / 2;
		const dy = (grid.elevations[(y + 1) * grid.width + x] - grid.elevations[(y - 1) * grid.width + x]) / 2;
		return Math.sqrt(dx * dx + dy * dy) * 100; // percent
	}

	function computeLocalAspect(grid: ElevationGrid, x: number, y: number): number {
		if (x <= 0 || x >= grid.width - 1 || y <= 0 || y >= grid.height - 1) return 0;
		const dx = grid.elevations[y * grid.width + (x + 1)] - grid.elevations[y * grid.width + (x - 1)];
		const dy = grid.elevations[(y + 1) * grid.width + x] - grid.elevations[(y - 1) * grid.width + x];
		let angle = Math.atan2(-dy, dx) * (180 / Math.PI);
		if (angle < 0) angle += 360;
		return angle;
	}

	function hslToRgb(h: number, s: number, l: number): [number, number, number] {
		let r: number, g: number, b: number;
		if (s === 0) {
			r = g = b = l;
		} else {
			const hue2rgb = (p: number, q: number, t: number) => {
				if (t < 0) t += 1;
				if (t > 1) t -= 1;
				if (t < 1/6) return p + (q - p) * 6 * t;
				if (t < 1/2) return q;
				if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
				return p;
			};
			const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
			const p = 2 * l - q;
			r = hue2rgb(p, q, h + 1/3);
			g = hue2rgb(p, q, h);
			b = hue2rgb(p, q, h - 1/3);
		}
		return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
	}

	function clearHeatmap() {
		if (heatmapEntity && viewer?.entities?.contains(heatmapEntity)) {
			viewer.entities.remove(heatmapEntity);
		}
		heatmapEntity = null;
	}

	onDestroy(() => clearHeatmap());
</script>
