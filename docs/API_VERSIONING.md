# API and Event Versioning Policy

This document defines compatibility rules for all protobuf RPC and event contracts under proto/.

## Goals

- Keep backward compatibility for existing clients and workers.
- Allow additive growth without breaking generated SDKs.
- Provide deterministic rules for schema evolution and rollback.

## Versioning Model

- Package versions use path-based versioning: <domain>/v1.
- Breaking changes require a new package version (for example v2).
- Non-breaking changes stay within the same package version.

## RPC Compatibility Rules

1. Never renumber or reuse existing field numbers.
2. Never change existing field wire types.
3. Add new fields only with new field numbers.
4. Never remove a field without reserving both its number and name.
5. Add enum values only at the end; never repurpose existing numeric values.
6. Do not change request or response message names for existing methods.
7. Prefer adding optional semantic fields instead of changing behavior of existing fields.
8. Keep default behavior stable when a newly added field is omitted.

## Event Compatibility Rules

1. Every emitted event must include an event envelope version.
2. Event payload must be immutable once published.
3. New event fields must be additive and optional for existing consumers.
4. Event ordering is represented by stream_id + sequence in envelope/batch records.
5. Correlation and causation identifiers are required for traceability.

## Contract Metadata Requirements

- Contracts that cross service boundaries should carry:
  - schema version
  - schema hash
  - correlation identifier
  - producer name

## Tooling Enforcement

- Buf lint uses STANDARD rules.
- Legacy naming exceptions are scoped only to:
  - ml_inference/v1/ml_inference.proto
  - optimization/v1/optimization.proto
- New contract files must satisfy STANDARD naming rules without exceptions.
- Buf breaking checks use FILE and WIRE_JSON modes.
- CI must run:
  - buf lint
  - buf breaking

## Rollout Procedure for Contract Changes

1. Additive changes first in producers and consumers.
2. Deploy consumers that tolerate new fields.
3. Deploy producers writing new fields.
4. Monitor error rates and decode failures.
5. Defer hard deprecations to a major package version migration.

## Deprecation Procedure

1. Mark field as deprecated in comments.
2. Stop writing field values in producers.
3. Verify all consumers no longer read field values.
4. Reserve field number and name in next major package version.
