package service

import (
	"context"
	"sort"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"solar3d/compute-service/internal/models"
)

func TestLoad_SubmitFeedback_Concurrent(t *testing.T) {
	repo := newInMemoryMLRepo()
	svc := NewMLTrainingService(repo)

	const workers = 50
	const perWorker = 100
	const total = workers * perWorker
	repo.seedPredictionLogs("yield", total)

	latencies := make([]time.Duration, 0, total)
	latMu := sync.Mutex{}
	var failures int64
	var wg sync.WaitGroup

	for w := 0; w < workers; w++ {
		wg.Add(1)
		go func(worker int) {
			defer wg.Done()
			for i := 0; i < perWorker; i++ {
				idx := worker*perWorker + i
				start := time.Now()
				_, err := svc.SubmitFeedback(context.Background(), &models.SubmitFeedbackRequest{
					PredictionID: "pred_" + itoa(idx),
					SiteID:       "site_a",
					TaskType:     "yield",
					ActualLabel:  100.0,
					SubmittedBy:  "load@test",
				})
				elapsed := time.Since(start)
				latMu.Lock()
				latencies = append(latencies, elapsed)
				latMu.Unlock()
				if err != nil {
					atomic.AddInt64(&failures, 1)
				}
			}
		}(w)
	}
	wg.Wait()

	if len(latencies) != total {
		t.Fatalf("expected %d latency samples, got %d", total, len(latencies))
	}
	failureRate := float64(failures) / float64(total)
	if failureRate > 0.01 {
		t.Fatalf("failure rate too high: %.2f%%", failureRate*100)
	}

	p95 := percentileDuration(latencies, 95)
	if p95 > 50*time.Millisecond {
		t.Fatalf("p95 too high for in-memory path: %v", p95)
	}
}

func TestLoad_GetActiveModel_WithModelRefresh(t *testing.T) {
	repo := newInMemoryMLRepo()
	repo.modelVersions["v1"] = &models.MLModelVersion{ID: "v1", TaskType: "yield", Status: ModelStatusChampion, CreatedAt: time.Now()}
	repo.modelVersions["v2"] = &models.MLModelVersion{ID: "v2", TaskType: "yield", Status: ModelStatusCandidate, CreatedAt: time.Now()}
	repo.activeModels["yield"] = &models.MLActiveModel{ID: "active_1", TaskType: "yield", CurrentModelID: "v1", PreviousModelID: nullableString("v2"), PromotedAt: time.Now()}

	svc := NewMLTrainingService(repo)
	ctx := context.Background()

	stop := make(chan struct{})
	var refreshWG sync.WaitGroup
	refreshWG.Add(1)
	go func() {
		defer refreshWG.Done()
		ticker := time.NewTicker(2 * time.Millisecond)
		defer ticker.Stop()
		toggle := false
		for {
			select {
			case <-stop:
				return
			case <-ticker.C:
				repo.mu.Lock()
				if toggle {
					repo.activeModels["yield"].CurrentModelID = "v1"
					repo.activeModels["yield"].PreviousModelID = nullableString("v2")
				} else {
					repo.activeModels["yield"].CurrentModelID = "v2"
					repo.activeModels["yield"].PreviousModelID = nullableString("v1")
				}
				toggle = !toggle
				repo.mu.Unlock()
			}
		}
	}()

	const readers = 20
	const readsPerReader = 200
	var readWG sync.WaitGroup
	var readFailures int64

	for i := 0; i < readers; i++ {
		readWG.Add(1)
		go func() {
			defer readWG.Done()
			for j := 0; j < readsPerReader; j++ {
				resp, err := svc.GetActiveModel(ctx, "yield")
				if err != nil || resp == nil || (resp.ActiveVersion.VersionID != "v1" && resp.ActiveVersion.VersionID != "v2") {
					atomic.AddInt64(&readFailures, 1)
				}
			}
		}()
	}
	readWG.Wait()
	close(stop)
	refreshWG.Wait()

	if readFailures != 0 {
		t.Fatalf("unexpected read failures during refresh: %d", readFailures)
	}
}

func percentileDuration(values []time.Duration, p int) time.Duration {
	copyVals := append([]time.Duration(nil), values...)
	sort.Slice(copyVals, func(i, j int) bool { return copyVals[i] < copyVals[j] })
	if len(copyVals) == 0 {
		return 0
	}
	idx := (len(copyVals) - 1) * p / 100
	return copyVals[idx]
}

func itoa(v int) string {
	if v == 0 {
		return "0"
	}
	neg := v < 0
	if neg {
		v = -v
	}
	buf := [20]byte{}
	i := len(buf)
	for v > 0 {
		i--
		buf[i] = byte('0' + v%10)
		v /= 10
	}
	if neg {
		i--
		buf[i] = '-'
	}
	return string(buf[i:])
}

