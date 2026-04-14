package repository

import "sync/atomic"

var duplicateCommandReplayCount atomic.Uint64
var lockWaitConflictCount atomic.Uint64
var integrityDriftFindingCount atomic.Uint64
var integrityRepairCount atomic.Uint64
var integrityAuditFailureCount atomic.Uint64

func recordDuplicateCommandReplay() {
	duplicateCommandReplayCount.Add(1)
}

func recordLockWaitConflict() {
	lockWaitConflictCount.Add(1)
}

func recordIntegrityDrift(findings int) {
	if findings > 0 {
		integrityDriftFindingCount.Add(uint64(findings))
	}
}

func recordIntegrityRepair(resolved int) {
	if resolved > 0 {
		integrityRepairCount.Add(uint64(resolved))
	}
}

func recordIntegrityAuditFailure() {
	integrityAuditFailureCount.Add(1)
}

type TelemetrySnapshot struct {
	DuplicateCommandReplays uint64
	LockWaitConflicts       uint64
	IntegrityDriftFindings  uint64
	IntegrityRepairs        uint64
	IntegrityAuditFailures  uint64
}

func SnapshotTelemetry() TelemetrySnapshot {
	return TelemetrySnapshot{
		DuplicateCommandReplays: duplicateCommandReplayCount.Load(),
		LockWaitConflicts:       lockWaitConflictCount.Load(),
		IntegrityDriftFindings:  integrityDriftFindingCount.Load(),
		IntegrityRepairs:        integrityRepairCount.Load(),
		IntegrityAuditFailures:  integrityAuditFailureCount.Load(),
	}
}

