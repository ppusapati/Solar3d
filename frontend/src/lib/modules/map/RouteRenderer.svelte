<script lang="ts">
	import { onDestroy } from 'svelte';

	export let viewer: any;
	export let visible: boolean = false;

	let Cesium: any;
	let routeEntities: any[] = [];

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: routeEntities.forEach((e) => {
		e.show = visible;
	});

	interface RouteData {
		id: string;
		route_type: string;
		waypoints: { longitude: number; latitude: number; elevation: number }[];
		distance_m: number;
		cost_estimate: number;
	}

	export function renderRoutes(routes: RouteData[]) {
		clearAll();
		if (!Cesium || !viewer) return;

		for (const route of routes) {
			const positions = route.waypoints.map((wp) =>
				Cesium.Cartesian3.fromDegrees(wp.longitude, wp.latitude, wp.elevation || 0)
			);

			const config = getRouteConfig(route.route_type);

			// Main line
			const lineEntity = viewer.entities.add({
				polyline: {
					positions,
					width: config.width,
					material: config.dashed
						? new Cesium.PolylineDashMaterialProperty({
								color: Cesium.Color.fromCssColorString(config.color),
								dashLength: 12
						  })
						: new Cesium.ColorMaterialProperty(
								Cesium.Color.fromCssColorString(config.color).withAlpha(0.8)
						  ),
					clampToGround: true
				},
				properties: {
					type: 'route',
					routeId: route.id,
					routeType: route.route_type
				}
			});
			routeEntities.push(lineEntity);

			// Start/end markers
			if (positions.length >= 2) {
				const startMarker = viewer.entities.add({
					position: positions[0],
					point: {
						pixelSize: 8,
						color: Cesium.Color.fromCssColorString(config.color),
						outlineColor: Cesium.Color.WHITE,
						outlineWidth: 2,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					}
				});
				routeEntities.push(startMarker);

				const endMarker = viewer.entities.add({
					position: positions[positions.length - 1],
					point: {
						pixelSize: 8,
						color: Cesium.Color.fromCssColorString(config.color),
						outlineColor: Cesium.Color.WHITE,
						outlineWidth: 2,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					}
				});
				routeEntities.push(endMarker);
			}

			// Distance label at midpoint
			if (positions.length >= 2) {
				const mid = positions[Math.floor(positions.length / 2)];
				const distLabel = viewer.entities.add({
					position: mid,
					label: {
						text: `${config.label} ${route.distance_m.toFixed(0)}m ($${route.cost_estimate.toFixed(0)})`,
						font: '11px sans-serif',
						fillColor: Cesium.Color.WHITE,
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
						pixelOffset: new Cesium.Cartesian2(0, -10),
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY,
						scale: 0.9
					}
				});
				routeEntities.push(distLabel);
			}
		}
	}

	function getRouteConfig(type: string): { color: string; width: number; dashed: boolean; label: string } {
		switch (type) {
			case 'cable':
				return { color: '#ef4444', width: 3, dashed: false, label: 'Cable' };
			case 'road':
				return { color: '#a3a3a3', width: 5, dashed: true, label: 'Road' };
			case 'fence':
				return { color: '#84cc16', width: 2, dashed: true, label: 'Fence' };
			default:
				return { color: '#6b7280', width: 2, dashed: false, label: type };
		}
	}

	export function clearAll() {
		routeEntities.forEach((e) => {
			if (viewer?.entities?.contains(e)) viewer.entities.remove(e);
		});
		routeEntities = [];
	}

	onDestroy(() => {
		clearAll();
	});
</script>
