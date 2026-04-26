// Solar3D — k6 baseline load test.
//
// Scenarios:
//   baseline        — ramp to 500 VUs, sustain 15 min, ramp down. Mixed read RPCs.
//   write_heavy     — 100 VUs doing project/layout creates (smaller layouts).
//   large_layout    — 20 VUs posting 100k-panel layouts to compute-service.
//   auth_storm      — burst of login attempts (validates rate limiting + lockout).
//
// Usage:
//   k6 run -e API_BASE=https://staging.solar3d.example.com \
//          -e TOKEN=<bearer> \
//          --tag env=staging scripts/loadtest/k6-baseline.js
//
// SLO gates (checks fail → exit 1 → pipeline fails):
//   http_req_failed         < 1%
//   http_req_duration p95   < 800ms (writes) / < 300ms (reads)
//   checks                  > 99%

import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Counter, Trend } from 'k6/metrics';
import exec from 'k6/execution';

const API = __ENV.API_BASE;
const TOKEN = __ENV.TOKEN;
if (!API || !TOKEN) throw new Error('API_BASE and TOKEN env vars required');

const HEADERS = {
  'Content-Type': 'application/json',
  Authorization: `Bearer ${TOKEN}`,
};

const readLatency = new Trend('solar3d_read_latency_ms', true);
const writeLatency = new Trend('solar3d_write_latency_ms', true);
const layoutCreates = new Counter('solar3d_layout_creates_total');

export const options = {
  scenarios: {
    baseline: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '2m', target: 100 },
        { duration: '3m', target: 500 },
        { duration: '15m', target: 500 },
        { duration: '2m', target: 0 },
      ],
      exec: 'baselineMix',
      tags: { scenario: 'baseline' },
    },
    write_heavy: {
      executor: 'constant-vus',
      vus: 100,
      duration: '10m',
      startTime: '5m',
      exec: 'writeHeavy',
      tags: { scenario: 'write_heavy' },
    },
    large_layout: {
      executor: 'constant-vus',
      vus: 20,
      duration: '10m',
      startTime: '10m',
      exec: 'largeLayout',
      tags: { scenario: 'large_layout' },
    },
    auth_storm: {
      executor: 'ramping-arrival-rate',
      startRate: 10,
      timeUnit: '1s',
      preAllocatedVUs: 50,
      maxVUs: 200,
      stages: [
        { duration: '1m', target: 10 },
        { duration: '30s', target: 200 },
        { duration: '1m', target: 200 },
        { duration: '30s', target: 10 },
      ],
      startTime: '20m',
      exec: 'authStorm',
      tags: { scenario: 'auth_storm' },
    },
  },
  thresholds: {
    'http_req_failed{scenario:baseline}': ['rate<0.01'],
    'http_req_duration{scenario:baseline,type:read}': ['p(95)<300'],
    'http_req_duration{scenario:write_heavy}': ['p(95)<800'],
    'http_req_duration{scenario:large_layout}': ['p(95)<300000'],
    'checks': ['rate>0.99'],
    'solar3d_read_latency_ms': ['p(95)<300'],
    'solar3d_write_latency_ms': ['p(95)<800'],
  },
};

function rpc(method, path, body, tags = {}) {
  const res = http.post(`${API}${path}`, JSON.stringify(body), { headers: HEADERS, tags });
  return res;
}

export function baselineMix() {
  group('list projects', () => {
    const r = rpc('ListProjects', '/solar3d.project.v1.ProjectService/ListProjects', { pageSize: 20 }, { type: 'read' });
    check(r, { 'list 200': (x) => x.status === 200 });
    readLatency.add(r.timings.duration);
  });
  sleep(0.5);
  group('get project', () => {
    const r = rpc('GetProject', '/solar3d.project.v1.ProjectService/GetProject', { id: pickTestProjectId() }, { type: 'read' });
    check(r, { 'get 200': (x) => x.status === 200 || x.status === 404 });
    readLatency.add(r.timings.duration);
  });
  sleep(1);
  group('list layouts', () => {
    const r = rpc('ListLayouts', '/solar3d.layout.v1.LayoutService/ListLayouts', { projectId: pickTestProjectId(), pageSize: 20 }, { type: 'read' });
    check(r, { 'list-layouts 200': (x) => x.status === 200 || x.status === 404 });
    readLatency.add(r.timings.duration);
  });
  sleep(1);
}

export function writeHeavy() {
  const projectId = pickTestProjectId();
  const r = rpc('CreateLayout', '/solar3d.layout.v1.LayoutService/CreateLayout', {
    projectId,
    name: `load-${exec.vu.idInTest}-${exec.scenario.iterationInTest}`,
    tiltDeg: 20,
    azimuthDeg: 180,
    rowSpacingM: 4,
    panelModel: 'generic-540W',
    panels: generatePanels(500),
  });
  const ok = check(r, { 'create layout 200': (x) => x.status === 200 });
  writeLatency.add(r.timings.duration);
  if (ok) layoutCreates.add(1);
  sleep(2);
}

export function largeLayout() {
  const projectId = pickTestProjectId();
  const r = rpc('CreateLayout', '/solar3d.layout.v1.LayoutService/CreateLayout', {
    projectId,
    name: `large-${exec.vu.idInTest}-${exec.scenario.iterationInTest}`,
    tiltDeg: 25,
    azimuthDeg: 180,
    rowSpacingM: 5,
    panelModel: 'generic-540W',
    panels: generatePanels(100_000),
  }, { type: 'write', size: 'large' });
  check(r, {
    'large layout 200': (x) => x.status === 200,
    'large layout < 5 min': (x) => x.timings.duration < 300_000,
  });
  writeLatency.add(r.timings.duration);
  sleep(10);
}

export function authStorm() {
  const r = http.post(`${API}/solar3d.auth.v1.AuthService/Login`, JSON.stringify({
    email: `storm-${__VU}@example.com`,
    password: 'wrong-password',
  }), { headers: { 'Content-Type': 'application/json' }, tags: { scenario: 'auth_storm' } });
  check(r, {
    'rate-limited or 401': (x) => x.status === 401 || x.status === 429,
    'not 5xx': (x) => x.status < 500,
  });
}

function pickTestProjectId() {
  const ids = (__ENV.TEST_PROJECT_IDS || '').split(',').filter(Boolean);
  if (ids.length === 0) return '00000000-0000-0000-0000-000000000001';
  return ids[Math.floor(Math.random() * ids.length)];
}

function generatePanels(n) {
  const panels = new Array(n);
  for (let i = 0; i < n; i++) {
    const row = Math.floor(i / 200);
    const col = i % 200;
    panels[i] = {
      id: `p-${i}`,
      x: col * 2.0,
      y: row * 4.0,
      widthM: 1.1,
      heightM: 2.3,
    };
  }
  return panels;
}
