<script lang="ts">
	import { onDestroy } from 'svelte';
	import { components, activeTool } from '$lib/core/stores';
	import { layoutApi } from '$lib/core/api';
	import type { Component } from '$lib/core/api';

	export let viewer: any;
	export let visible: boolean = true;

	let Cesium: any;
	let componentEntities: any[] = [];
	let handler: any = null;
	let draggingEntity: any = null;

	import('cesium').then((mod) => {
		Cesium = mod;
		setupInteractionHandler();
	});

	$: if (Cesium && viewer) {
		renderComponents($components);
	}

	$: componentEntities.forEach((e) => {
		e.show = visible;
	});

	$: if (Cesium && viewer && !handler) {
		setupInteractionHandler();
	}

	function renderComponents(comps: Component[]) {
		clearAll();

		for (const comp of comps || []) {
			const pos = Cesium.Cartesian3.fromDegrees(
				comp.position.longitude,
				comp.position.latitude,
				comp.position.elevation || 0
			);

			const config = getComponentConfig(comp.component_type);
			const footprint = parseFootprintDimensions(comp);
			const hasFootprint = footprint.widthMeters > 0 && footprint.depthMeters > 0;

			if (hasFootprint) {
				const footprintEntity = viewer.entities.add({
					position: pos,
					ellipse: {
						semiMajorAxis: Math.max(0.3, footprint.widthMeters / 2),
						semiMinorAxis: Math.max(0.3, footprint.depthMeters / 2),
						height: 0,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						material: Cesium.Color.fromCssColorString(config.color).withAlpha(0.18),
						outline: true,
						outlineColor: Cesium.Color.fromCssColorString(config.color).withAlpha(0.65),
						zIndex: 8
					},
					properties: {
						type: 'component-footprint',
						componentId: comp.id
					}
				});
				componentEntities.push(footprintEntity);
			}

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

	function parseFootprintDimensions(comp: Component): { widthMeters: number; depthMeters: number } {
		let widthMm = 0;
		let depthMm = 0;

		try {
			if (comp.metadata_json?.trim()) {
				const parsed = JSON.parse(comp.metadata_json);
				const dimensionsMm = parsed?.dimensionsMm;
				widthMm = Number(dimensionsMm?.width ?? 0);
				depthMm = Number(dimensionsMm?.depth ?? 0);
			}
		} catch {
			// Metadata is optional and may contain user-authored JSON.
		}

		return {
			widthMeters: Number.isFinite(widthMm) && widthMm > 0 ? widthMm / 1000 : 0,
			depthMeters: Number.isFinite(depthMm) && depthMm > 0 ? depthMm / 1000 : 0
		};
	}

	function getComponentConfig(type: string): { color: string; label: string } {
		switch (type) {
			case 'panel':
			case 'solar_panel':
				return { color: '#22c55e', label: 'PAN' };
			case 'inverter':
			case 'string_inverter':
			case 'central_inverter':
				return { color: '#ef4444', label: 'INV' };
			case 'transformer':
				return { color: '#8b5cf6', label: 'XFMR' };
			case 'combiner_box':
				return { color: '#f97316', label: 'CB' };
			case 'meter':
				return { color: '#06b6d4', label: 'MTR' };
			case 'tracker':
				return { color: '#84cc16', label: 'TRK' };
			case 'mounting':
			case 'mounting_structure':
				return { color: '#64748b', label: 'MNT' };
			case 'cable':
				return { color: '#0ea5e9', label: 'CBL' };
			case 'substation':
				return { color: '#a855f7', label: 'SUB' };
			default:
				return { color: '#6b7280', label: type.substring(0, 3).toUpperCase() };
		}
	}

	function setupInteractionHandler() {
		if (!Cesium || !viewer || handler) return;
		handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);

		handler.setInputAction((click: any) => {
			if ($activeTool !== 'select') return;
			const picked = viewer.scene.pick(click.position);
			if (!Cesium.defined(picked) || !picked.id?.properties?.componentId) return;
			draggingEntity = picked.id;
			viewer.scene.screenSpaceCameraController.enableRotate = false;
		}, Cesium.ScreenSpaceEventType.LEFT_DOWN);

		handler.setInputAction((movement: any) => {
			if (!draggingEntity || $activeTool !== 'select') return;
			const ray = viewer.camera.getPickRay(movement.endPosition);
			if (!ray) return;
			const pickedPos = viewer.scene.globe.pick(ray, viewer.scene);
			if (!pickedPos) return;
			draggingEntity.position = pickedPos;
		}, Cesium.ScreenSpaceEventType.MOUSE_MOVE);

		handler.setInputAction(() => {
			if (!draggingEntity) return;
			try {
				const cartesian = draggingEntity.position?.getValue
					? draggingEntity.position.getValue(Cesium.JulianDate.now())
					: draggingEntity.position;
				if (cartesian) {
					const carto = Cesium.Cartographic.fromCartesian(cartesian);
					const lon = Cesium.Math.toDegrees(carto.longitude);
					const lat = Cesium.Math.toDegrees(carto.latitude);
					const id = draggingEntity.properties.componentId.getValue();
					const moved = { longitude: lon, latitude: lat, elevation: 0 };
					components.update((items) =>
						items.map((c) =>
							c.id === id
								? { ...c, position: moved }
								: c
						)
					);
					void layoutApi.moveComponent(id, moved, 0).catch((err) => {
						console.error('Failed to persist moved component:', err);
					});
				}
			} finally {
				draggingEntity = null;
				viewer.scene.screenSpaceCameraController.enableRotate = true;
			}
		}, Cesium.ScreenSpaceEventType.LEFT_UP);
	}

	function createComponentIcon(color: string, label: string): string {
		const canvas = document.createElement('canvas');
		canvas.width = 32;
		canvas.height = 32;
		const ctx = canvas.getContext('2d');
		if (!ctx) return '';

		ctx.beginPath();
		ctx.arc(16, 16, 14, 0, Math.PI * 2);
		ctx.fillStyle = color;
		ctx.fill();
		ctx.strokeStyle = '#ffffff';
		ctx.lineWidth = 2;
		ctx.stroke();

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
		if (handler) {
			handler.destroy();
			handler = null;
		}
		if (viewer?.scene?.screenSpaceCameraController) {
			viewer.scene.screenSpaceCameraController.enableRotate = true;
		}
		clearAll();
	});
</script>
