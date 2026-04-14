# Frontend Known Limitations

1. Constraint Zone Manager has pre-existing Svelte accessibility/style warnings that do not block build/test.
2. Twin identity and telemetry event cache in commissioning UX currently persists in browser local storage for trace exploration convenience.
3. Lineage explorer currently correlates design revision using selected/linked as-built artifact IDs; deeper CAD lineage graph traversal is out of current scope.
4. Role selection is UI-side guarding for operational workflow hardening and is not an authorization boundary.
5. Twin latest telemetry retrieval endpoint is not yet exposed in frontend because backend endpoint is marked not implemented.
