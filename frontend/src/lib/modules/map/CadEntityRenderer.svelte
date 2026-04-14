<script lang="ts">
	import { onDestroy } from 'svelte';
	import { cadWorkspace } from '$lib/core/stores/cad';

	export let viewer: any;
	export let visible = true;

	let Cesium: any;
	let renderedEntities: any[] = [];
	let unsubscribe: (() => void) | null = null;

	async function ensureCesium() {
		if (!Cesium) {
			Cesium = await import('cesium');
		}
	}

	function clearRendered() {
		if (!viewer) return;
		for (const entity of renderedEntities) {
			if (viewer.entities.contains(entity)) {
				viewer.entities.remove(entity);
			}
		}
		renderedEntities = [];
	}

	function distanceMeters(a: { x: number; y: number }, b: { x: number; y: number }): number {
		const meanLat = (a.y + b.y) / 2;
		const metersPerDegLat = 111320;
		const metersPerDegLon = 111320 * Math.cos((meanLat * Math.PI) / 180);
		const dx = (b.x - a.x) * metersPerDegLon;
		const dy = (b.y - a.y) * metersPerDegLat;
		return Math.hypot(dx, dy);
	}

	type BlockGlyphStyle = {
		icon: string;
		fill: string;
		border: string;
		text: string;
	};

	function resolveGlyphStyle(blockName: string): BlockGlyphStyle {
		const key = blockName.toLowerCase();

		if (key.includes('north') || key.includes('arrow')) {
			return { icon: 'N', fill: '#0f172a', border: '#38bdf8', text: '#e0f2fe' };
		}
		if (key.includes('substation') || key.includes('xfmr') || key.includes('transformer')) {
			return { icon: 'SS', fill: '#3f1d2e', border: '#f43f5e', text: '#ffe4e6' };
		}
		if (key.includes('inverter')) {
			return { icon: 'INV', fill: '#1e293b', border: '#22c55e', text: '#dcfce7' };
		}
		if (key.includes('meter')) {
			return { icon: 'M', fill: '#082f49', border: '#0ea5e9', text: '#e0f2fe' };
		}
		if (key.includes('junction') || key.includes('combiner')) {
			return { icon: 'JB', fill: '#451a03', border: '#f59e0b', text: '#fef3c7' };
		}

		return { icon: 'BLK', fill: '#312e81', border: '#818cf8', text: '#e0e7ff' };
	}

	function blockGlyphDataUri(label: string, style: BlockGlyphStyle): string {
		const safeLabel = label.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
		const svg =
			`<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40">` +
			`<circle cx="20" cy="20" r="16" fill="${style.fill}" stroke="${style.border}" stroke-width="2" />` +
			`<text x="20" y="22" font-family="Arial,sans-serif" font-size="9" font-weight="700" text-anchor="middle" fill="${style.text}">${safeLabel}</text>` +
			`</svg>`;
		return `data:image/svg+xml;utf8,${encodeURIComponent(svg)}`;
	}

	function parseMetadata(metadataJson: string | undefined): Record<string, unknown> {
		if (!metadataJson) return {};
		try {
			const parsed = JSON.parse(metadataJson) as Record<string, unknown>;
			return parsed && typeof parsed === 'object' ? parsed : {};
		} catch {
			return {};
		}
	}

	function topologyColor(groupingType: string): string {
		if (groupingType === 'dc_string') return '#22c55e';
		if (groupingType === 'mppt_group') return '#eab308';
		if (groupingType === 'inverter_route') return '#06b6d4';
		if (groupingType === 'transformer_route') return '#f97316';
		return '#c084fc';
	}

	async function renderCadEntities() {
		if (!viewer || !visible) {
			clearRendered();
			return;
		}

		await ensureCesium();
		clearRendered();

		const state = $cadWorkspace;
		const revision = state.revision;
		if (!revision?.entities?.length) return;

		const blockDefs = new Map<string, string>();
		for (const entity of revision.entities) {
			if (entity?.geometry?.case === 'blockDefinition') {
				const def = entity.geometry.value;
				if (def?.blockDefinitionId) {
					blockDefs.set(def.blockDefinitionId, def.name || 'Block');
				}
			}
		}

		for (const entity of revision.entities) {
			const geom = entity?.geometry;
			if (!geom) continue;
			const metadata = parseMetadata(entity.header?.metadataJson);

			if (geom.case === 'polyline') {
				const polyline = geom.value;
				const vertices = polyline?.vertices ?? [];
				if (vertices.length < 2) continue;

				const isTransmission = metadata.discipline === 'transmission';
				const isElectrical = metadata.discipline === 'electrical';
				const isLayout = metadata.discipline === 'layout';
				const isDc = metadata.segmentKind === 'dc';
				const lineColor = isTransmission
					? '#f59e0b'
					: isElectrical
						? (isDc ? '#22c55e' : '#06b6d4')
						: isLayout
							? '#84cc16'
							: '#60a5fa';
				const polylineEntity = viewer.entities.add({
					polyline: {
						positions: vertices.map((vertex) => Cesium.Cartesian3.fromDegrees(vertex.x, vertex.y)),
						width: isTransmission ? 4 : 2,
						material: Cesium.Color.fromCssColorString(lineColor),
						clampToGround: true,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					},
					properties: {
						type: isTransmission ? 'cad-transmission-route' : 'cad-polyline',
						entityId: entity.header?.entityId ?? ''
					}
				});
				renderedEntities.push(polylineEntity);

				if (isTransmission) {
					const mid = vertices[Math.floor(vertices.length / 2)];
					const routeName = typeof metadata.transmissionRouteName === 'string' && metadata.transmissionRouteName.trim().length > 0
						? metadata.transmissionRouteName
						: 'Transmission Route';
					const routeLabel = viewer.entities.add({
						position: Cesium.Cartesian3.fromDegrees(mid.x, mid.y),
						label: {
							text: routeName,
							font: '12px sans-serif',
							fillColor: Cesium.Color.fromCssColorString('#fef3c7'),
							outlineColor: Cesium.Color.BLACK,
							outlineWidth: 2,
							style: Cesium.LabelStyle.FILL_AND_OUTLINE,
							verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
							pixelOffset: new Cesium.Cartesian2(0, -10),
							disableDepthTestDistance: Number.POSITIVE_INFINITY
						}
					});
					renderedEntities.push(routeLabel);
				}
				continue;
			}

			if (geom.case === 'polygon') {
				const polygon = geom.value;
				const outerRing = polygon?.geometry?.rings?.[0]?.points ?? [];
				if (outerRing.length < 3) continue;

				const isLayoutTable = metadata.discipline === 'layout' || metadata.bimObjectType === 'panel_table';
				const zoneType = typeof metadata.terrainZoneType === 'string' ? metadata.terrainZoneType : '';
				const colorByZoneType: Record<string, string> = {
					grading: '#f59e0b',
					cut: '#ef4444',
					fill: '#22c55e',
					slope: '#60a5fa'
				};
				const fillColor = isLayoutTable ? '#a3e635' : colorByZoneType[zoneType] ?? '#94a3b8';
				const polygonEntity = viewer.entities.add({
					polygon: {
						hierarchy: new Cesium.PolygonHierarchy(
							outerRing.map((point) => Cesium.Cartesian3.fromDegrees(point.x, point.y))
						),
						material: Cesium.Color.fromCssColorString(fillColor).withAlpha(0.28),
						outline: true,
						outlineColor: Cesium.Color.fromCssColorString(fillColor),
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						classificationType: Cesium.ClassificationType.TERRAIN
					},
					properties: {
						type: isLayoutTable ? 'cad-layout-table' : 'cad-terrain-zone',
						terrainZoneType: zoneType,
						entityId: entity.header?.entityId ?? ''
					}
				});
				renderedEntities.push(polygonEntity);
				continue;
			}

			if (geom.case === 'blockReference') {
				const ref = geom.value;
				const point = ref?.insertionPoint;
				if (!point) continue;

				const label = blockDefs.get(ref.blockDefinitionId) || 'Block';
				const style = resolveGlyphStyle(label);
				const iconText = style.icon.length > 3 ? style.icon.slice(0, 3) : style.icon;
				const marker = viewer.entities.add({
					position: Cesium.Cartesian3.fromDegrees(point.x, point.y),
					billboard: {
						image: blockGlyphDataUri(iconText, style),
						width: 30,
						height: 30,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY,
						verticalOrigin: Cesium.VerticalOrigin.CENTER
					},
					label: {
						text: label,
						font: '12px sans-serif',
						fillColor: Cesium.Color.fromCssColorString(style.text),
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
						pixelOffset: new Cesium.Cartesian2(0, -18),
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					},
					properties: {
						type: 'cad-block-reference',
						blockDefinitionId: ref.blockDefinitionId,
						entityId: entity.header?.entityId ?? ''
					}
				});
				renderedEntities.push(marker);
				continue;
			}

			if (geom.case === 'text') {
				const text = geom.value;
				const anchor = text?.anchor;
				if (!anchor) continue;

				const isTopologyOverlay = metadata.topologyOverlay === true || metadata.electricalGroupingType !== undefined;
				const groupingType = typeof metadata.electricalGroupingType === 'string' ? metadata.electricalGroupingType : '';
				const labelColor = isTopologyOverlay ? topologyColor(groupingType) : '#e5e7eb';
				const renderedText = viewer.entities.add({
					position: Cesium.Cartesian3.fromDegrees(anchor.x, anchor.y),
					label: {
						text: text.text || 'Annotation',
						font: isTopologyOverlay ? 'bold 12px sans-serif' : '11px sans-serif',
						fillColor: Cesium.Color.fromCssColorString(labelColor),
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
						pixelOffset: new Cesium.Cartesian2(0, -8),
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					},
					point: isTopologyOverlay
						? {
							pixelSize: 6,
							color: Cesium.Color.fromCssColorString(labelColor),
							outlineColor: Cesium.Color.BLACK,
							outlineWidth: 1,
							heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
							disableDepthTestDistance: Number.POSITIVE_INFINITY
						}
						: undefined,
					properties: {
						type: isTopologyOverlay ? 'cad-electrical-topology-overlay' : 'cad-text',
						electricalGroupingType: groupingType,
						entityId: entity.header?.entityId ?? ''
					}
				});
				renderedEntities.push(renderedText);
				continue;
			}

			if (geom.case === 'dimension') {
				const dim = geom.value;
				if (!dim?.start || !dim?.end) continue;

				const start = dim.start;
				const end = dim.end;
				const dimLine = viewer.entities.add({
					polyline: {
						positions: [
							Cesium.Cartesian3.fromDegrees(start.x, start.y),
							Cesium.Cartesian3.fromDegrees(end.x, end.y)
						],
						width: 2,
						material: Cesium.Color.fromCssColorString('#38bdf8'),
						clampToGround: true,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					}
				});
				renderedEntities.push(dimLine);

				const meters = distanceMeters(start, end);
				const labelText = meters >= 1000 ? `${(meters / 1000).toFixed(2)} km` : `${meters.toFixed(1)} m`;
				const anchor = dim.textAnchor ?? { x: (start.x + end.x) / 2, y: (start.y + end.y) / 2 };
				const dimLabel = viewer.entities.add({
					position: Cesium.Cartesian3.fromDegrees(anchor.x, anchor.y),
					label: {
						text: labelText,
						font: '11px sans-serif',
						fillColor: Cesium.Color.fromCssColorString('#e0f2fe'),
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
						pixelOffset: new Cesium.Cartesian2(0, -12),
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					}
				});
				renderedEntities.push(dimLabel);
			}
		}
	}

	$: void renderCadEntities();

	if (!unsubscribe) {
		unsubscribe = cadWorkspace.subscribe(() => {
			void renderCadEntities();
		});
	}

	onDestroy(() => {
		if (unsubscribe) unsubscribe();
		clearRendered();
	});
</script>
