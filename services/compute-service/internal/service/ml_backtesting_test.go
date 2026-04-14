package service

import (
	"math"
	"testing"
)

type backtestSplit struct {
	trainStart int
	trainEnd   int
	testStart  int
	testEnd    int
}

type backtestMetrics struct {
	mae    float64
	rmse   float64
	splits int
}

func TestOfflineBacktesting_WalkForwardWindows(t *testing.T) {
	series := make([]float64, 0, 240)
	for i := 0; i < 240; i++ {
		trend := 100.0 + float64(i)*0.05
		seasonal := math.Sin(float64(i) / 12.0)
		series = append(series, trend+seasonal)
	}

	metrics, splits := runWalkForwardBacktest(series, 72, 24)
	if metrics.splits == 0 {
		t.Fatal("expected at least one backtesting split")
	}
	if len(splits) != metrics.splits {
		t.Fatalf("split count mismatch: metrics=%d actual=%d", metrics.splits, len(splits))
	}

	for _, s := range splits {
		if s.trainEnd > s.testStart {
			t.Fatalf("data leakage detected: trainEnd=%d testStart=%d", s.trainEnd, s.testStart)
		}
	}

	if metrics.mae <= 0 || metrics.rmse <= 0 {
		t.Fatalf("invalid metrics: mae=%f rmse=%f", metrics.mae, metrics.rmse)
	}
	if metrics.rmse < metrics.mae {
		t.Fatalf("rmse should be >= mae: mae=%f rmse=%f", metrics.mae, metrics.rmse)
	}
}

func runWalkForwardBacktest(series []float64, trainWindow, testWindow int) (backtestMetrics, []backtestSplit) {
	if len(series) < trainWindow+testWindow {
		return backtestMetrics{}, nil
	}

	splits := make([]backtestSplit, 0)
	var absErrSum float64
	var sqErrSum float64
	var n int

	for start := 0; start+trainWindow+testWindow <= len(series); start += testWindow {
		trainStart := start
		trainEnd := start + trainWindow
		testStart := trainEnd
		testEnd := testStart + testWindow
		splits = append(splits, backtestSplit{
			trainStart: trainStart,
			trainEnd:   trainEnd,
			testStart:  testStart,
			testEnd:    testEnd,
		})

		mean := average(series[trainStart:trainEnd])
		for i := testStart; i < testEnd; i++ {
			err := mean - series[i]
			absErrSum += math.Abs(err)
			sqErrSum += err * err
			n++
		}
	}

	if n == 0 {
		return backtestMetrics{}, splits
	}
	mae := absErrSum / float64(n)
	rmse := math.Sqrt(sqErrSum / float64(n))
	return backtestMetrics{mae: mae, rmse: rmse, splits: len(splits)}, splits
}

func average(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}
	sum := 0.0
	for _, v := range values {
		sum += v
	}
	return sum / float64(len(values))
}

