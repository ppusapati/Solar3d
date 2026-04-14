package service

import "sync/atomic"

var staleConflictCount atomic.Uint64
var internalErrorCount atomic.Uint64

func recordStaleConflict() {
	staleConflictCount.Add(1)
}

func RecordInternalError() {
	internalErrorCount.Add(1)
}

type TelemetrySnapshot struct {
	StaleConflicts uint64
	InternalErrors uint64
}

func SnapshotTelemetry() TelemetrySnapshot {
	return TelemetrySnapshot{
		StaleConflicts: staleConflictCount.Load(),
		InternalErrors: internalErrorCount.Load(),
	}
}

