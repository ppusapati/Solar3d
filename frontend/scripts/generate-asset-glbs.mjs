import fs from 'node:fs/promises';
import path from 'node:path';
import * as THREE from 'three';
import { GLTFExporter } from 'three/examples/jsm/exporters/GLTFExporter.js';

if (typeof globalThis.FileReader === 'undefined') {
	globalThis.FileReader = class FileReader {
		constructor() {
			this.result = null;
			this.error = null;
			this.onload = null;
			this.onloadend = null;
			this.onerror = null;
		}

		_emitSuccess() {
			this.onload?.({ target: this });
			this.onloadend?.({ target: this });
		}

		_emitError(error) {
			this.error = error;
			this.onerror?.(error);
			this.onloadend?.({ target: this });
		}

		readAsArrayBuffer(blob) {
			blob.arrayBuffer().then((buffer) => {
				this.result = buffer;
				this._emitSuccess();
			}).catch((error) => this._emitError(error));
		}

		readAsDataURL(blob) {
			blob.arrayBuffer().then((buffer) => {
				const base64 = Buffer.from(buffer).toString('base64');
				this.result = `data:${blob.type || 'application/octet-stream'};base64,${base64}`;
				this._emitSuccess();
			}).catch((error) => this._emitError(error));
		}
	};
}

const MODEL_PATHS = [
	'/models/panels/jinkosolar-tiger-neo-78hc-bdv.glb',
	'/models/panels/trinasolar-vertex-n.glb',
	'/models/panels/waaree-topcon-bifacial.glb',
	'/models/panels/vikram-hypersol.glb',
	'/models/inverters/sungrow-sg250hx.glb',
	'/models/inverters/sma-shp150-20.glb',
	'/models/inverters/sungrow-sg3125hv-mv-30.glb',
	'/models/inverters/sungrow-sg6250hv-mv.glb',
	'/models/inverters/goodwe-ht-250.glb',
	'/models/inverters/fimer-pvs980-58.glb',
	'/models/mounting/unirac-ground-fixed-tilt.glb',
	'/models/mounting/gamechange-maxspan.glb',
	'/models/mounting/pennar-solar-mms.glb',
	'/models/mounting/strolar-ground-mount.glb',
	'/models/trackers/nextracker-nx-horizon.glb',
	'/models/trackers/trinatracker-vanguard-1p.glb',
	'/models/trackers/arctech-skyline-ii.glb',
	'/models/trackers/gamechange-genius.glb',
	'/models/transformers/prolecge-solar-duty-padmount.glb',
	'/models/transformers/mgm-solar-duty-padmount.glb',
	'/models/transformers/voltamp-inverter-duty.glb',
	'/models/transformers/cgpower-solar-duty.glb',
	'/models/electrical/weidmuller-pv-next-gjb.glb',
	'/models/electrical/phoenixcontact-sunclix-jb.glb',
	'/models/electrical/weidmuller-pv-next-combiner.glb',
	'/models/electrical/shoals-bla.glb',
	'/models/electrical/statcon-dc-junction-box.glb',
	'/models/electrical/mtekpower-array-jb.glb',
	'/models/electrical/lt-dc-combiner-box.glb',
	'/models/electrical/statcon-string-combiner.glb',
	'/models/cables/helukabel-solarflex-x-1x6.glb',
	'/models/cables/prysmian-prysolar-1x10.glb',
	'/models/cables/kei-solar-cable-1x6.glb',
	'/models/cables/polycab-solar-dc-1x10.glb',
	'/models/substations/hitachienergy-ehouse.glb',
	'/models/substations/siemens-energy-ehouse.glb',
	'/models/substations/siemens-energy-india-ehouse.glb',
	'/models/substations/hitachienergy-india-ehouse.glb'
];

const rootDir = path.resolve('static');
const exporter = new GLTFExporter();

function createMaterials() {
	return {
		steel: new THREE.MeshStandardMaterial({ color: 0x8d9fae, metalness: 0.9, roughness: 0.22 }),
		panelBody: new THREE.MeshStandardMaterial({ color: 0x0b1420, metalness: 0.18, roughness: 0.7 }),
		cell: new THREE.MeshStandardMaterial({ color: 0x214b92, metalness: 0.08, roughness: 0.35 }),
		glass: new THREE.MeshStandardMaterial({ color: 0xc7deec, metalness: 0.05, roughness: 0.08, transparent: true, opacity: 0.22 }),
		box: new THREE.MeshStandardMaterial({ color: 0x1f2937, metalness: 0.2, roughness: 0.55 }),
		accent: new THREE.MeshStandardMaterial({ color: 0xf59e0b, metalness: 0.15, roughness: 0.45 }),
		cable: new THREE.MeshStandardMaterial({ color: 0x111827, metalness: 0.04, roughness: 0.8 }),
		ground: new THREE.MeshStandardMaterial({ color: 0x334155, metalness: 0.05, roughness: 0.9 })
	};
}

function addMesh(parent, geometry, material, position = [0, 0, 0], rotation = [0, 0, 0]) {
	const mesh = new THREE.Mesh(geometry, material);
	mesh.position.set(...position);
	mesh.rotation.set(...rotation);
	parent.add(mesh);
	return mesh;
}

function createSolarPanelSinglePost() {
	const mats = createMaterials();
	const group = new THREE.Group();
	const W = 1.32;
	const H = 2.42;
	const D = 0.05;
	const frame = 0.03;
	const mastHeight = 1.55;
	const beamHeight = 1.28;

	const panelAssembly = new THREE.Group();
	addMesh(panelAssembly, new THREE.BoxGeometry(W, D, H), mats.panelBody);
	addMesh(panelAssembly, new THREE.BoxGeometry(frame, D + 0.008, H + frame * 1.2), mats.steel, [-(W / 2) + frame / 2, 0, 0]);
	addMesh(panelAssembly, new THREE.BoxGeometry(frame, D + 0.008, H + frame * 1.2), mats.steel, [(W / 2) - frame / 2, 0, 0]);
	addMesh(panelAssembly, new THREE.BoxGeometry(W - frame * 2, D + 0.008, frame), mats.steel, [0, 0, -(H / 2) + frame / 2]);
	addMesh(panelAssembly, new THREE.BoxGeometry(W - frame * 2, D + 0.008, frame), mats.steel, [0, 0, (H / 2) - frame / 2]);
	addMesh(panelAssembly, new THREE.PlaneGeometry(W - frame * 2, H - frame * 2), mats.cell, [0, D / 2 + 0.002, 0], [-Math.PI / 2, 0, 0]);
	addMesh(panelAssembly, new THREE.PlaneGeometry(W - frame * 2, H - frame * 2), mats.glass, [0, D / 2 + 0.006, 0], [-Math.PI / 2, 0, 0]);
	addMesh(panelAssembly, new THREE.BoxGeometry(0.22, 0.05, 0.09), mats.box, [0.12, -(D / 2) - 0.03, 0.18]);
	addMesh(panelAssembly, new THREE.BoxGeometry(W * 0.82, 0.04, 0.04), mats.steel, [0, -(D / 2) - 0.025, H * 0.28]);
	addMesh(panelAssembly, new THREE.BoxGeometry(W * 0.82, 0.04, 0.04), mats.steel, [0, -(D / 2) - 0.025, -H * 0.28]);
	panelAssembly.rotation.x = -0.48;
	panelAssembly.position.set(0, beamHeight, 0);
	group.add(panelAssembly);

	addMesh(group, new THREE.CylinderGeometry(0.07, 0.09, mastHeight, 18), mats.steel, [0, mastHeight / 2, 0]);
	addMesh(group, new THREE.CylinderGeometry(0.12, 0.14, 0.12, 18), mats.ground, [0, 0.06, 0]);
	addMesh(group, new THREE.BoxGeometry(0.22, 0.08, 0.34), mats.steel, [0, beamHeight - 0.02, 0]);
	addMesh(group, new THREE.BoxGeometry(W * 0.34, 0.05, 0.08), mats.steel, [0, beamHeight + 0.03, 0]);

	const leftBrace = new THREE.Mesh(new THREE.CylinderGeometry(0.025, 0.025, 0.98, 10), mats.steel);
	leftBrace.position.set(-0.26, 0.95, 0.18);
	leftBrace.rotation.z = 0.48;
	leftBrace.rotation.x = -0.22;
	group.add(leftBrace);
	const rightBrace = leftBrace.clone();
	rightBrace.position.x = 0.26;
	rightBrace.rotation.z = -0.48;
	group.add(rightBrace);

	return group;
}

function createInverter(large = false) {
	const mats = createMaterials();
	const group = new THREE.Group();
	const width = large ? 2.6 : 1.15;
	const height = large ? 2.1 : 1.5;
	const depth = large ? 1.15 : 0.45;
	addMesh(group, new THREE.BoxGeometry(width, height, depth), mats.box, [0, height / 2, 0]);
	addMesh(group, new THREE.BoxGeometry(width * 0.9, height * 0.08, depth * 0.06), mats.accent, [0, height * 0.68, depth / 2 + 0.03]);
	addMesh(group, new THREE.BoxGeometry(width * 0.15, height * 0.18, depth * 0.06), mats.glass, [width * 0.22, height * 0.58, depth / 2 + 0.03]);
	return group;
}

function createMounting(kind = 'fixed') {
	const mats = createMaterials();
	const group = new THREE.Group();
	const span = kind === 'wide' ? 3.8 : 2.8;
	addMesh(group, new THREE.CylinderGeometry(0.08, 0.1, 1.5, 16), mats.steel, [0, 0.75, 0]);
	addMesh(group, new THREE.BoxGeometry(span * 0.45, 0.07, 0.12), mats.steel, [0, 1.18, 0]);
	addMesh(group, new THREE.BoxGeometry(span, 0.05, 0.08), mats.steel, [0, 1.28, 0.38]);
	addMesh(group, new THREE.BoxGeometry(span, 0.05, 0.08), mats.steel, [0, 1.28, -0.38]);
	const braceA = new THREE.Mesh(new THREE.CylinderGeometry(0.025, 0.025, 1.3, 10), mats.steel);
	braceA.position.set(-0.45, 0.83, 0.25);
	braceA.rotation.z = 0.58;
	group.add(braceA);
	const braceB = braceA.clone();
	braceB.position.x = 0.45;
	braceB.rotation.z = -0.58;
	group.add(braceB);
	addMesh(group, new THREE.BoxGeometry(1.45, 0.04, 0.92), mats.cell, [0, 1.45, 0], [-0.34, 0, 0]);
	return group;
}

function createTracker() {
	const mats = createMaterials();
	const group = new THREE.Group();
	addMesh(group, new THREE.CylinderGeometry(0.08, 0.08, 2.4, 14), mats.steel, [0, 1.2, 0]);
	addMesh(group, new THREE.BoxGeometry(4.6, 0.08, 0.08), mats.steel, [0, 2.15, 0]);
	for (const x of [-1.6, -0.55, 0.55, 1.6]) {
		addMesh(group, new THREE.BoxGeometry(0.9, 0.04, 1.85), mats.cell, [x, 2.28, 0], [-0.12, 0, 0]);
	}
	return group;
}

function createBoxAsset(width, height, depth, topAccent = true) {
	const mats = createMaterials();
	const group = new THREE.Group();
	addMesh(group, new THREE.BoxGeometry(width, height, depth), mats.box, [0, height / 2, 0]);
	if (topAccent) {
		addMesh(group, new THREE.BoxGeometry(width * 0.85, height * 0.08, depth * 0.08), mats.accent, [0, height * 0.78, depth / 2 + 0.02]);
	}
	return group;
}

function createCable() {
	const mats = createMaterials();
	const group = new THREE.Group();
	const curve = new THREE.CatmullRomCurve3([
		new THREE.Vector3(-1.2, 0.4, -0.35),
		new THREE.Vector3(-0.3, 0.78, 0.15),
		new THREE.Vector3(0.45, 0.24, -0.12),
		new THREE.Vector3(1.2, 0.58, 0.25)
	]);
	addMesh(group, new THREE.TubeGeometry(curve, 48, 0.06, 12, false), mats.cable);
	return group;
}

function createSubstation() {
	const mats = createMaterials();
	const group = new THREE.Group();
	addMesh(group, new THREE.BoxGeometry(3.6, 1.9, 1.6), mats.box, [0, 0.95, 0]);
	addMesh(group, new THREE.BoxGeometry(3.8, 0.12, 1.8), mats.steel, [0, 1.95, 0]);
	for (const x of [-1.2, 0, 1.2]) {
		addMesh(group, new THREE.BoxGeometry(0.42, 1.2, 0.06), mats.glass, [x, 1.0, 0.83]);
	}
	return group;
}

function sceneForModel(relPath) {
	const scene = new THREE.Scene();
	let root;

	if (relPath.includes('/panels/')) {
		root = createSolarPanelSinglePost();
	} else if (relPath.includes('/mounting/')) {
		root = createMounting(relPath.includes('maxspan') || relPath.includes('mms') ? 'wide' : 'fixed');
	} else if (relPath.includes('/trackers/')) {
		root = createTracker();
	} else if (relPath.includes('/inverters/')) {
		root = createInverter(relPath.includes('3125') || relPath.includes('6250') || relPath.includes('pvs980'));
	} else if (relPath.includes('/transformers/')) {
		root = createBoxAsset(2.6, 2.0, 1.8);
	} else if (relPath.includes('/electrical/')) {
		root = createBoxAsset(relPath.includes('combiner') ? 1.0 : 0.75, relPath.includes('combiner') ? 1.25 : 0.92, 0.42);
	} else if (relPath.includes('/cables/')) {
		root = createCable();
	} else if (relPath.includes('/substations/')) {
		root = createSubstation();
	} else {
		root = createBoxAsset(1.0, 1.0, 1.0);
	}

	const box = new THREE.Box3().setFromObject(root);
	const center = box.getCenter(new THREE.Vector3());
	root.position.sub(center);
	root.position.y += box.getSize(new THREE.Vector3()).y / 2;
	scene.add(root);
	return scene;
}

async function exportBinary(scene) {
	const result = await exporter.parseAsync(scene, { binary: true, onlyVisible: true, trs: false });
	return Buffer.from(result);
}

async function main() {
	for (const relPath of MODEL_PATHS) {
		const outputPath = path.join(rootDir, relPath.replace(/^\//, ''));
		await fs.mkdir(path.dirname(outputPath), { recursive: true });
		const scene = sceneForModel(relPath);
		const bytes = await exportBinary(scene);
		await fs.writeFile(outputPath, bytes);
		console.log(`generated ${relPath}`);
	}
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});