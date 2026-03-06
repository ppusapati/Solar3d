<script lang="ts">
	import { camera, activeLayout, viewport, boundaryEntities } from '$lib/core/stores';
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher<{
		navigate: { longitude: number; latitude: number };
	}>();

	export let width = 160;
	export let height = 120;

	let canvas: HTMLCanvasElement;
	let ctx: CanvasRenderingContext2D | null = null;

	// Derive map bounds from boundary entities or fall back to camera-centered region
	$: mapBounds = deriveMapBounds($boundaryEntities, $camera);

	function deriveMapBounds(
		boundaries: { geojson: string }[],
		cam: { longitude: number; latitude: number }
	) {
		if (boundaries.length > 0) {
			try {
				const geojson = JSON.parse(boundaries[0].geojson);
				const coords = geojson.coordinates?.[0] || [];
				if (coords.length > 2) {
					let west = Infinity, east = -Infinity, south = Infinity, north = -Infinity;
					for (const c of coords) {
						if (c[0] < west) west = c[0];
						if (c[0] > east) east = c[0];
						if (c[1] < south) south = c[1];
						if (c[1] > north) north = c[1];
					}
					const padLon = (east - west) * 0.15 || 0.005;
					const padLat = (north - south) * 0.15 || 0.005;
					return { west: west - padLon, east: east + padLon, south: south - padLat, north: north + padLat };
				}
			} catch { /* fall through */ }
		}
		return {
			west: cam.longitude - 0.5, east: cam.longitude + 0.5,
			south: cam.latitude - 0.5, north: cam.latitude + 0.5
		};
	}

	$: if (canvas && !ctx) {
		ctx = canvas.getContext('2d');
	}

	$: if (ctx) {
		drawMinimap($camera, $viewport, $activeLayout);
	}

	function drawMinimap(cam: any, vp: any, layout: any) {
		if (!ctx) return;

		const w = width;
		const h = height;

		// Clear
		ctx.fillStyle = '#0f172a';
		ctx.fillRect(0, 0, w, h);

		// Grid lines
		ctx.strokeStyle = 'rgba(255,255,255,0.06)';
		ctx.lineWidth = 0.5;
		for (let i = 1; i < 4; i++) {
			ctx.beginPath();
			ctx.moveTo((w / 4) * i, 0);
			ctx.lineTo((w / 4) * i, h);
			ctx.stroke();
			ctx.beginPath();
			ctx.moveTo(0, (h / 4) * i);
			ctx.lineTo(w, (h / 4) * i);
			ctx.stroke();
		}

		// Panel coverage indicator (simplified)
		if (layout) {
			ctx.fillStyle = 'rgba(37, 99, 235, 0.3)';
			const cx = w / 2;
			const cy = h / 2;
			const panelRadius = Math.min(w, h) * 0.3;
			ctx.beginPath();
			ctx.arc(cx, cy, panelRadius, 0, Math.PI * 2);
			ctx.fill();
		}

		// Viewport rectangle
		const lonRange = mapBounds.east - mapBounds.west;
		const latRange = mapBounds.north - mapBounds.south;

		const vpX = ((vp.west - mapBounds.west) / lonRange) * w;
		const vpY = ((mapBounds.north - vp.north) / latRange) * h;
		const vpW = ((vp.east - vp.west) / lonRange) * w;
		const vpH = ((vp.north - vp.south) / latRange) * h;

		ctx.strokeStyle = '#f59e0b';
		ctx.lineWidth = 1.5;
		ctx.strokeRect(
			Math.max(0, Math.min(vpX, w)),
			Math.max(0, Math.min(vpY, h)),
			Math.max(4, Math.min(vpW, w)),
			Math.max(4, Math.min(vpH, h))
		);

		// Camera position dot
		const camX = ((cam.longitude - mapBounds.west) / lonRange) * w;
		const camY = ((mapBounds.north - cam.latitude) / latRange) * h;

		ctx.fillStyle = '#f59e0b';
		ctx.beginPath();
		ctx.arc(
			Math.max(3, Math.min(camX, w - 3)),
			Math.max(3, Math.min(camY, h - 3)),
			3, 0, Math.PI * 2
		);
		ctx.fill();

		// Heading indicator
		const headingRad = (cam.heading * Math.PI) / 180;
		const arrowLen = 10;
		ctx.strokeStyle = '#f59e0b';
		ctx.lineWidth = 1.5;
		ctx.beginPath();
		ctx.moveTo(camX, camY);
		ctx.lineTo(
			camX + Math.sin(headingRad) * arrowLen,
			camY - Math.cos(headingRad) * arrowLen
		);
		ctx.stroke();

		// Border
		ctx.strokeStyle = 'rgba(255,255,255,0.15)';
		ctx.lineWidth = 1;
		ctx.strokeRect(0, 0, w, h);
	}

	function handleClick(e: MouseEvent) {
		const rect = canvas.getBoundingClientRect();
		const x = e.clientX - rect.left;
		const y = e.clientY - rect.top;

		const lonRange = mapBounds.east - mapBounds.west;
		const latRange = mapBounds.north - mapBounds.south;

		const lon = mapBounds.west + (x / width) * lonRange;
		const lat = mapBounds.north - (y / height) * latRange;

		dispatch('navigate', { longitude: lon, latitude: lat });
	}
</script>

<div class="minimap-container">
	<canvas
		bind:this={canvas}
		{width}
		{height}
		on:click={handleClick}
		class="minimap-canvas"
	/>
	<span class="minimap-label">Overview</span>
</div>

<style>
	.minimap-container {
		position: relative;
		border-radius: 6px;
		overflow: hidden;
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
	}

	.minimap-canvas {
		display: block;
		cursor: crosshair;
	}

	.minimap-label {
		position: absolute;
		top: 4px;
		left: 6px;
		font-size: 9px;
		color: rgba(255, 255, 255, 0.4);
		font-weight: 500;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		pointer-events: none;
	}
</style>
