<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { activeTool } from '$lib/core/stores';

	export let viewer: any;

	const dispatch = createEventDispatcher<{
		drop: {
			type: string;
			name: string;
			id: string;
			model3dPath: string;
			dimensions: { widthMm: number; heightMm: number; depthMm: number };
			longitude: number;
			latitude: number;
		};
	}>();

	let Cesium: any;
	let isDragOver = false;
	let previewEntity: any = null;

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	function handleDragOver(e: DragEvent) {
		e.preventDefault();
		if (e.dataTransfer) e.dataTransfer.dropEffect = 'copy';
		isDragOver = true;

		// Show preview at cursor position
		if (viewer && Cesium) {
			const pos = pickPosition(e);
			if (pos) {
				if (previewEntity) {
					previewEntity.position = pos;
				} else {
					previewEntity = viewer.entities.add({
						position: pos,
						point: {
							pixelSize: 16,
							color: Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.6),
							outlineColor: Cesium.Color.WHITE,
							outlineWidth: 3,
							heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
							disableDepthTestDistance: Number.POSITIVE_INFINITY
						}
					});
				}
			}
		}
	}

	function handleDragLeave() {
		isDragOver = false;
		removePreview();
	}

	function handleDrop(e: DragEvent) {
		e.preventDefault();
		isDragOver = false;
		removePreview();

		const data = e.dataTransfer?.getData('text/plain');
		if (!data) return;

		try {
			const asset = JSON.parse(data);
			const position = pickPosition(e);
			if (!position || !Cesium) return;

			const carto = Cesium.Cartographic.fromCartesian(position);
			dispatch('drop', {
				type: asset.type,
				name: asset.name,
				id: asset.id ?? '',
				model3dPath: asset.model3dPath ?? '',
				dimensions: {
					widthMm: Number(asset.dimensions?.widthMm ?? 0),
					heightMm: Number(asset.dimensions?.heightMm ?? 0),
					depthMm: Number(asset.dimensions?.depthMm ?? 0)
				},
				longitude: Cesium.Math.toDegrees(carto.longitude),
				latitude: Cesium.Math.toDegrees(carto.latitude)
			});

			// Auto-switch to select tool after drop
			activeTool.set('select');
		} catch {
			// invalid data
		}
	}

	function pickPosition(e: DragEvent | MouseEvent): any | null {
		if (!viewer || !Cesium) return null;

		const canvas = viewer.scene.canvas;
		const rect = canvas.getBoundingClientRect();
		const x = e.clientX - rect.left;
		const y = e.clientY - rect.top;

		const screenPos = new Cesium.Cartesian2(x, y);
		const ray = viewer.camera.getPickRay(screenPos);
		if (!ray) return null;
		return viewer.scene.globe.pick(ray, viewer.scene);
	}

	function removePreview() {
		if (previewEntity && viewer?.entities?.contains(previewEntity)) {
			viewer.entities.remove(previewEntity);
		}
		previewEntity = null;
	}
</script>

<div
	class="drop-zone"
	class:drag-over={isDragOver}
	role="region"
	aria-label="Map asset drop zone"
	on:dragover={handleDragOver}
	on:dragleave={handleDragLeave}
	on:drop={handleDrop}
>
	<slot />
</div>

<style>
	.drop-zone {
		width: 100%;
		height: 100%;
		position: relative;
	}

	.drop-zone.drag-over::after {
		content: 'Drop to place component';
		position: absolute;
		inset: 0;
		display: flex;
		align-items: center;
		justify-content: center;
		background: rgba(245, 158, 11, 0.08);
		border: 2px dashed rgba(245, 158, 11, 0.4);
		border-radius: 0;
		pointer-events: none;
		z-index: 55;
		font-size: 16px;
		font-weight: 600;
		color: #f59e0b;
	}
</style>
