<script lang="ts">
	import { onDestroy } from 'svelte';

	import { activeTransmissionRouteId, transmissionRoutes } from '$lib/core/stores/transmission';
	import type { VoltageClassValue } from '$lib/core/api/transmission';

	export let viewer: any;
	export let visible: boolean = false;

	let Cesium: any;
	let routeEntities: any[] = [];

	interface ParsedPoint {
		longitude: number;
		latitude: number;
		elevation: number;
	}

	interface TowerPoint {
		longitude: number;
		latitude: number;
		elevation: number;
		height_m: number;
	}

	const ROUTE_HEIGHT_OFFSET_M = 35;

	type RouteStyle = {
		color: string;
		width: number;
		dashed: boolean;
		label: string;
	};

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: routeEntities.forEach((entity) => {
		entity.show = visible;
	});

	$: if (Cesium && viewer) {
		renderRoutes($transmissionRoutes);
	}

	$: if (Cesium && viewer && $activeTransmissionRouteId) {
		flyToRoute($activeTransmissionRouteId, $transmissionRoutes);
	}

	function parsePath(pathGeojson: string): ParsedPoint[] {
		try {
			const parsed = JSON.parse(pathGeojson) as { type?: string; coordinates?: number[][] };
			if (parsed.type !== 'LineString' || !Array.isArray(parsed.coordinates)) {
				return [];
			}
			return parsed.coordinates.map((coordinate) => ({
				longitude: coordinate[0] ?? 0,
				latitude: coordinate[1] ?? 0,
				elevation: coordinate[2] ?? 0
			}));
		} catch {
			return [];
		}
	}

	function renderRoutes(routes: typeof $transmissionRoutes) {
		clearAll();
		if (!Cesium || !viewer) return;

		for (const route of routes) {
			const style = routeStyle(route.name);
			const points = parsePath(route.path_geojson);
			const positions = points.map((point) =>
				Cesium.Cartesian3.fromDegrees(point.longitude, point.latitude)
			);

			if (positions.length >= 2) {
				const line = viewer.entities.add({
					polyline: {
						positions,
						width: style.width,
						material: style.dashed
							? new Cesium.PolylineDashMaterialProperty({
									color: Cesium.Color.fromCssColorString(style.color).withAlpha(0.9),
									dashLength: 12
							  })
							: Cesium.Color.fromCssColorString(style.color).withAlpha(0.85),
						clampToGround: true
					},
					properties: {
						type: 'transmission-route',
						routeId: route.id
					},
					show: visible
				});
				routeEntities.push(line);

				const startMarker = viewer.entities.add({
					position: positions[0],
					point: {
						pixelSize: 8,
						color: Cesium.Color.fromCssColorString(style.color),
						outlineColor: Cesium.Color.WHITE,
						outlineWidth: 2,
						heightReference: Cesium.HeightReference.RELATIVE_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					},
					show: visible
				});
				routeEntities.push(startMarker);

				const endMarker = viewer.entities.add({
					position: positions[positions.length - 1],
					point: {
						pixelSize: 8,
						color: Cesium.Color.fromCssColorString(style.color),
						outlineColor: Cesium.Color.WHITE,
						outlineWidth: 2,
						heightReference: Cesium.HeightReference.RELATIVE_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					},
					show: visible
				});
				routeEntities.push(endMarker);

				const mid = positions[Math.floor(positions.length / 2)];
				const label = viewer.entities.add({
					position: mid,
					label: {
						text: `${style.label} | INR ${route.cost_breakdown.total_cost.toFixed(0)}`,
						font: '11px sans-serif',
						fillColor: Cesium.Color.fromCssColorString(style.color),
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
						pixelOffset: new Cesium.Cartesian2(0, -10),
						heightReference: Cesium.HeightReference.RELATIVE_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY,
						scale: 0.8
					},
					show: visible
				});
				routeEntities.push(label);
			}

			renderOverheadCable(route.tower_positions);

			const modelUri = TOWER_MODEL_URIS[route.voltage_class] ?? null;
			for (const tower of route.tower_positions) {
				// Place tower base at exact lat/lon, clamped to terrain surface.
				const towerPos = Cesium.Cartesian3.fromDegrees(
					tower.longitude,
					tower.latitude
				);
				const towerEntity = modelUri
					? viewer.entities.add({
							position: towerPos,
							show: visible,
							model: {
								uri: modelUri,
								minimumPixelSize: 42,
								maximumScale: 20000,
								heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
								clampAnimations: true,
								silhouetteColor: Cesium.Color.WHITE,
								silhouetteSize: 1
							}
					  })
					: viewer.entities.add({
							position: towerPos,
							show: visible,
							point: {
								pixelSize: 8,
								color: Cesium.Color.fromCssColorString('#f59e0b'),
								outlineColor: Cesium.Color.BLACK,
								outlineWidth: 2,
								heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
								disableDepthTestDistance: Number.POSITIVE_INFINITY
							}
					  });
				routeEntities.push(towerEntity);

				// Always draw a clamped base marker so tower grounding is visually explicit
				// even when a model's pivot is not perfectly aligned to its feet.
				const towerBase = viewer.entities.add({
					position: towerPos,
					show: visible,
					point: {
						pixelSize: 5,
						color: Cesium.Color.fromCssColorString('#111827'),
						outlineColor: Cesium.Color.fromCssColorString('#fbbf24'),
						outlineWidth: 1,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					}
				});
				routeEntities.push(towerBase);
			}
		}
	}

	function renderOverheadCable(towers: TowerPoint[]) {
		if (!Cesium || !viewer || towers.length < 2) return;

		// Draw cables at tower-top height above terrain.
		// Use absolute positioning: elevation (ASL) + pole_height + phase offset.
		const phaseOffsets = [1.6, 2.8, 4.0];
		for (const phaseOffset of phaseOffsets) {
			const cablePositions = towers.map((tower) =>
				Cesium.Cartesian3.fromDegrees(
					tower.longitude,
					tower.latitude,
					Math.max(tower.elevation, 0) + Math.max(10, tower.height_m) + phaseOffset
				)
			);
			const cable = viewer.entities.add({
				polyline: {
					positions: cablePositions,
					width: 1.6,
					material: Cesium.Color.fromCssColorString('#111827').withAlpha(0.95),
					clampToGround: false
				},
				show: visible
			});
			routeEntities.push(cable);
		}
	}

	const TOWER_MODEL_URIS: Partial<Record<VoltageClassValue, string>> = {
		'11kv': '/models/towers/11kv_tower.glb',
		'33kv': '/models/towers/33kv_tower.glb',
		'66kv': '/models/towers/66kv_tower.glb',
		'132kv': '/models/towers/132kv_tower.glb',
		'220kv': '/models/towers/220kv_tower.glb',
		'400kv': '/models/towers/400kv_tower.glb'
	};

	function routeStyle(name: string): RouteStyle {
		if (name.includes('Option A')) {
			return { color: '#22d3ee', width: 5, dashed: false, label: 'Option A (Shortest)' };
		}
		if (name.includes('Option B')) {
			return { color: '#facc15', width: 5, dashed: true, label: 'Option B (Balanced)' };
		}
		if (name.includes('Option C')) {
			return { color: '#f472b6', width: 5, dashed: false, label: 'Option C (Low Cost)' };
		}
		return { color: '#f59e0b', width: 5, dashed: false, label: 'Transmission Route' };
	}

	function flyToRoute(routeID: string, routes: typeof $transmissionRoutes) {
		const route = routes.find((entry) => entry.id === routeID);
		if (!route) return;

		const points = parsePath(route.path_geojson);
		if (!points.length) return;

		const positions = points.map((point) =>
			Cesium.Cartesian3.fromDegrees(
				point.longitude,
				point.latitude,
				Math.max(point.elevation, 0) + ROUTE_HEIGHT_OFFSET_M
			)
		);
		if (!positions.length) return;

		const sphere = Cesium.BoundingSphere.fromPoints(positions);
		viewer.camera.flyToBoundingSphere(sphere, {
			duration: 1.2,
			offset: new Cesium.HeadingPitchRange(0, -0.8, sphere.radius * 2.2)
		});
	}

	export function clearAll() {
		routeEntities.forEach((entity) => {
			if (viewer?.entities?.contains(entity)) viewer.entities.remove(entity);
		});
		routeEntities = [];
	}

	onDestroy(() => {
		clearAll();
	});
</script>
