package service

import "sync/atomic"

var internalErrorCount atomic.Uint64

func RecordInternalError() {
	internalErrorCount.Add(1)
}

type TelemetrySnapshot struct {
	InternalErrors uint64
}

func SnapshotTelemetry() TelemetrySnapshot {
	return TelemetrySnapshot{InternalErrors: internalErrorCount.Load()}
}

