<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { collabUsers, localUserId, sendCursorUpdate } from '$lib/core/collaboration/websocket';

	export let viewer: any;

	let Cesium: any;
	let cursorEntities = new Map<string, any>();
	let moveHandler: any = null;
	let throttleTimer: ReturnType<typeof setTimeout> | null = null;

	import('cesium').then((mod) => { Cesium = mod; });

	$: if (Cesium && viewer) {
		setupCursorTracking();
	}

	// Update remote cursor positions
	$: if (Cesium && viewer) {
		updateRemoteCursors($collabUsers);
	}

	function setupCursorTracking() {
		if (moveHandler) return;

		moveHandler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
		moveHandler.setInputAction((movement: any) => {
			if (throttleTimer) return;

			throttleTimer = setTimeout(() => {
				throttleTimer = null;
			}, 100); // 10 updates/sec max

			const ray = viewer.camera.getPickRay(movement.endPosition);
			if (!ray) return;
			const position = viewer.scene.globe.pick(ray, viewer.scene);
			if (!position) return;

			const carto = Cesium.Cartographic.fromCartesian(position);
			sendCursorUpdate(
				Cesium.Math.toDegrees(carto.longitude),
				Cesium.Math.toDegrees(carto.latitude)
			);
		}, Cesium.ScreenSpaceEventType.MOUSE_MOVE);
	}

	function updateRemoteCursors(users: Map<string, any>) {
		if (!Cesium || !viewer) return;

		const myId = $localUserId;

		// Remove stale cursors
		for (const [userId, entity] of cursorEntities) {
			if (!users.has(userId) || userId === myId) {
				if (viewer.entities.contains(entity.point)) viewer.entities.remove(entity.point);
				if (viewer.entities.contains(entity.label)) viewer.entities.remove(entity.label);
				cursorEntities.delete(userId);
			}
		}

		// Update/create remote cursors
		for (const [userId, user] of users) {
			if (userId === myId || !user.cursor) continue;

			const pos = Cesium.Cartesian3.fromDegrees(user.cursor.longitude, user.cursor.latitude);

			if (cursorEntities.has(userId)) {
				const existing = cursorEntities.get(userId);
				existing.point.position = pos;
				existing.label.position = pos;
			} else {
				const point = viewer.entities.add({
					position: pos,
					point: {
						pixelSize: 12,
						color: Cesium.Color.fromCssColorString(user.color).withAlpha(0.8),
						outlineColor: Cesium.Color.WHITE,
						outlineWidth: 2,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					}
				});
				const label = viewer.entities.add({
					position: pos,
					label: {
						text: user.name,
						font: '11px sans-serif',
						fillColor: Cesium.Color.fromCssColorString(user.color),
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
						pixelOffset: new Cesium.Cartesian2(0, -12),
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY,
						scale: 0.8
					}
				});
				cursorEntities.set(userId, { point, label });
			}
		}
	}

	onDestroy(() => {
		if (moveHandler) {
			moveHandler.destroy();
			moveHandler = null;
		}
		for (const [, entity] of cursorEntities) {
			if (viewer?.entities?.contains(entity.point)) viewer.entities.remove(entity.point);
			if (viewer?.entities?.contains(entity.label)) viewer.entities.remove(entity.label);
		}
		cursorEntities.clear();
	});
</script>
