<script lang="ts">
	import { onDestroy } from 'svelte';
	import { components } from '$lib/core/stores';
	import type { Component } from '$lib/core/api';

	export let viewer: any;
	export let visible: boolean = true;

	let Cesium: any;
	let componentEntities: any[] = [];

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: if (Cesium && viewer && $components.length > 0) {
		renderComponents($components);
	}

	$: componentEntities.forEach((e) => {
		e.show = visible;
	});

	function renderComponents(comps: Component[]) {
		clearAll();

		for (const comp of comps) {
			const pos = Cesium.Cartesian3.fromDegrees(
				comp.position.longitude,
				comp.position.latitude,
				comp.position.elevation || 0
			);

			const config = getComponentConfig(comp.component_type);

			const entity = viewer.entities.add({
				position: pos,
				billboard: {
					image: createComponentIcon(config.color, config.label),
					width: 32,
					height: 32,
					verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
					heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				},
				label: {
					text: config.label,
					font: '11px sans-serif',
					fillColor: Cesium.Color.WHITE,
					outlineColor: Cesium.Color.BLACK,
					outlineWidth: 2,
					style: Cesium.LabelStyle.FILL_AND_OUTLINE,
					verticalOrigin: Cesium.VerticalOrigin.TOP,
					pixelOffset: new Cesium.Cartesian2(0, 4),
					heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				},
				properties: {
					type: 'component',
					componentId: comp.id,
					componentType: comp.component_type,
					assetId: comp.asset_id
				}
			});

			componentEntities.push(entity);
		}
	}

	function getComponentConfig(type: string): { color: string; label: string } {
		switch (type) {
			case 'inverter':
				return { color: '#ef4444', label: 'INV' };
			case 'transformer':
				return { color: '#8b5cf6', label: 'XFMR' };
			case 'combiner_box':
				return { color: '#f97316', label: 'CB' };
			case 'meter':
				return { color: '#06b6d4', label: 'MTR' };
			case 'tracker':
				return { color: '#84cc16', label: 'TRK' };
			default:
				return { color: '#6b7280', label: type.substring(0, 3).toUpperCase() };
		}
	}

	function createComponentIcon(color: string, label: string): string {
		const canvas = document.createElement('canvas');
		canvas.width = 32;
		canvas.height = 32;
		const ctx = canvas.getContext('2d');
		if (!ctx) return '';

		// Circle background
		ctx.beginPath();
		ctx.arc(16, 16, 14, 0, Math.PI * 2);
		ctx.fillStyle = color;
		ctx.fill();
		ctx.strokeStyle = '#ffffff';
		ctx.lineWidth = 2;
		ctx.stroke();

		// Text
		ctx.fillStyle = '#ffffff';
		ctx.font = 'bold 9px sans-serif';
		ctx.textAlign = 'center';
		ctx.textBaseline = 'middle';
		ctx.fillText(label, 16, 16);

		return canvas.toDataURL();
	}

	export function clearAll() {
		componentEntities.forEach((e) => {
			if (viewer?.entities?.contains(e)) viewer.entities.remove(e);
		});
		componentEntities = [];
	}

	onDestroy(() => {
		clearAll();
	});
</script>
