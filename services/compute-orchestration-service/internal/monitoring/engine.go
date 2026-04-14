package monitoring

import (
	"context"
	"fmt"
	"sync"
	"time"
)

// ============================================================
// Monitoring Metrics
// ============================================================

type ModelMetricsWindow struct {
	ModelVersionID  string
	WindowStart     time.Time
	WindowEnd       time.Time
	PredictionCount int64
	MAE             float64
	RMSE            float64
	CoverageLower   float64
	CoverageUpper   float64
	P50Latency      float64
	P95Latency      float64
	ErrorRate       float64
	DriftScore      float64
	AlertsTriggered []string
}

type FeatureDriftMetrics struct {
	FeatureName   string
	DriftDetector string // "ks_test", "wasserstein", "psi"
	DriftScore    float64
	PValue        float64
	DriftDetected bool
	BaselineStats map[string]interface{}
	CurrentStats  map[string]interface{}
}

// ============================================================
// Alert System
// ============================================================

type AlertPolicy struct {
	MetricName             string
	ThresholdHigh          float64
	ThresholdLow           float64
	WindowMinutes          int
	SeverityLevel          string // "warning", "critical"
	AutoRollbackOnCritical bool
}

type Alert struct {
	ID             string
	PolicyName     string
	ModelVersionID string
	MetricName     string
	MetricValue    float64
	Threshold      float64
	Severity       string
	TriggeredAt    time.Time
	Message        string
	AcknowledgedAt *time.Time
	AcknowledgedBy string
}

// ============================================================
// Monitoring Engine
// ============================================================

type MonitoringEngine struct {
	policies       map[string]*AlertPolicy
	alerts         map[string]*Alert
	metrics        map[string][]*ModelMetricsWindow
	driftDetectors map[string]DriftDetector
	alertHandlers  []AlertHandler
	mu             sync.RWMutex
}

type DriftDetector interface {
	DetectDrift(baseline []float64, current []float64) (float64, bool)
}

type AlertHandler interface {
	Handle(alert *Alert) error
}

func NewMonitoringEngine() *MonitoringEngine {
	return &MonitoringEngine{
		policies:       make(map[string]*AlertPolicy),
		alerts:         make(map[string]*Alert),
		metrics:        make(map[string][]*ModelMetricsWindow),
		driftDetectors: make(map[string]DriftDetector),
		alertHandlers:  []AlertHandler{},
	}
}

// Register alert policy
func (me *MonitoringEngine) RegisterPolicy(policy *AlertPolicy) {
	me.mu.Lock()
	defer me.mu.Unlock()
	me.policies[policy.MetricName] = policy
}

// Record metrics window
func (me *MonitoringEngine) RecordMetrics(window *ModelMetricsWindow) {
	me.mu.Lock()
	defer me.mu.Unlock()

	key := window.ModelVersionID
	me.metrics[key] = append(me.metrics[key], window)

	// Trim old metrics if list too long
	if len(me.metrics[key]) > 1000 {
		me.metrics[key] = me.metrics[key][len(me.metrics[key])-500:]
	}

	// Check for alerts
	me.checkAlertsLocked(window)
}

// Check metrics against policies
func (me *MonitoringEngine) checkAlertsLocked(window *ModelMetricsWindow) {
	metricsList := []struct {
		name  string
		value float64
	}{
		{"MAE", window.MAE},
		{"RMSE", window.RMSE},
		{"ErrorRate", window.ErrorRate},
		{"DriftScore", window.DriftScore},
	}

	for _, m := range metricsList {
		if policy, exists := me.policies[m.name]; exists {
			triggered := false
			message := ""

			if m.value > policy.ThresholdHigh {
				triggered = true
				message = fmt.Sprintf("%s exceeded high threshold: %.2f > %.2f", m.name, m.value, policy.ThresholdHigh)
			} else if m.value < policy.ThresholdLow {
				triggered = true
				message = fmt.Sprintf("%s below low threshold: %.2f < %.2f", m.name, m.value, policy.ThresholdLow)
			}

			if triggered {
				alert := &Alert{
					ID:             fmt.Sprintf("alert_%d", time.Now().UnixNano()),
					PolicyName:     m.name,
					ModelVersionID: window.ModelVersionID,
					MetricName:     m.name,
					MetricValue:    m.value,
					Threshold:      policy.ThresholdHigh,
					Severity:       policy.SeverityLevel,
					TriggeredAt:    time.Now(),
					Message:        message,
				}
				me.alerts[alert.ID] = alert
				window.AlertsTriggered = append(window.AlertsTriggered, alert.ID)

				// Handle alert
				for _, handler := range me.alertHandlers {
					_ = handler.Handle(alert)
				}

				// Check for auto-rollback
				if policy.AutoRollbackOnCritical && policy.SeverityLevel == "critical" {
					// Log for manual review
					fmt.Printf("[CRITICAL] Auto-rollback triggered for model %s: %s\n", window.ModelVersionID, message)
				}
			}
		}
	}
}

// Detect data drift
func (me *MonitoringEngine) DetectFeatureDrift(
	ctx context.Context,
	modelID string,
	featureName string,
	detector string,
	baseline []float64,
	current []float64,
) (*FeatureDriftMetrics, error) {
	me.mu.Lock()
	driftDetector, exists := me.driftDetectors[detector]
	me.mu.Unlock()

	if !exists {
		return nil, fmt.Errorf("drift detector not found: %s", detector)
	}

	scoreValue, driftDetected := driftDetector.DetectDrift(baseline, current)

	metrics := &FeatureDriftMetrics{
		FeatureName:   featureName,
		DriftDetector: detector,
		DriftScore:    scoreValue,
		DriftDetected: driftDetected,
		BaselineStats: computeStats(baseline),
		CurrentStats:  computeStats(current),
	}

	return metrics, nil
}

// Get recent alerts
func (me *MonitoringEngine) GetRecentAlerts(modelID string, limitMinutes int) []*Alert {
	me.mu.RLock()
	defer me.mu.RUnlock()

	var result []*Alert
	cutoff := time.Now().Add(time.Duration(-limitMinutes) * time.Minute)

	for _, alert := range me.alerts {
		if alert.ModelVersionID == modelID && alert.TriggeredAt.After(cutoff) {
			result = append(result, alert)
		}
	}

	return result
}

// Acknowledge alert
func (me *MonitoringEngine) AcknowledgeAlert(alertID, actor string) error {
	me.mu.Lock()
	defer me.mu.Unlock()

	alert, exists := me.alerts[alertID]
	if !exists {
		return fmt.Errorf("alert not found: %s", alertID)
	}

	now := time.Now()
	alert.AcknowledgedAt = &now
	alert.AcknowledgedBy = actor

	return nil
}

// Health check
func (me *MonitoringEngine) HealthCheck() map[string]interface{} {
	me.mu.RLock()
	defer me.mu.RUnlock()

	unacknowledged := 0
	critical := 0

	for _, alert := range me.alerts {
		if alert.AcknowledgedAt == nil {
			unacknowledged++
		}
		if alert.Severity == "critical" {
			critical++
		}
	}

	return map[string]interface{}{
		"total_alerts":     len(me.alerts),
		"unacknowledged":   unacknowledged,
		"critical_alerts":  critical,
		"monitored_models": len(me.metrics),
		"active_policies":  len(me.policies),
	}
}

// ============================================================
// Drift Detectors
// ============================================================

// Kolmogorov-Smirnov test implementation
type KSTestDetector struct {
	threshold float64
}

func NewKSTestDetector(threshold float64) *KSTestDetector {
	return &KSTestDetector{threshold: threshold}
}

func (d *KSTestDetector) DetectDrift(baseline []float64, current []float64) (float64, bool) {
	// Simplified KS test - in production would use proper statistical package
	if len(baseline) == 0 || len(current) == 0 {
		return 0.0, false
	}

	baselineStats := computeStats(baseline)
	currentStats := computeStats(current)

	// Detect shift in mean or variance
	meanShift := ((currentStats["mean"].(float64) - baselineStats["mean"].(float64)) /
		(baselineStats["mean"].(float64) + 1e-6))
	varShift := ((currentStats["std"].(float64) - baselineStats["std"].(float64)) /
		(baselineStats["std"].(float64) + 1e-6))

	score := (meanShift*meanShift + varShift*varShift) / 2.0

	return score, score > d.threshold
}

// Wasserstein distance detector
type WassersteinDetector struct {
	threshold float64
}

func NewWassersteinDetector(threshold float64) *WassersteinDetector {
	return &WassersteinDetector{threshold: threshold}
}

func (d *WassersteinDetector) DetectDrift(baseline []float64, current []float64) (float64, bool) {
	// Simplified implementation
	stats1 := computeStats(baseline)
	stats2 := computeStats(current)

	distance := (stats2["mean"].(float64) - stats1["mean"].(float64)) *
		(stats2["mean"].(float64) - stats1["mean"].(float64))

	return distance, distance > d.threshold
}

func computeStats(data []float64) map[string]interface{} {
	if len(data) == 0 {
		return map[string]interface{}{"mean": 0.0, "std": 0.0}
	}

	sum := 0.0
	for _, v := range data {
		sum += v
	}
	mean := sum / float64(len(data))

	variance := 0.0
	for _, v := range data {
		variance += (v - mean) * (v - mean)
	}
	variance /= float64(len(data))
	std := variance * variance // sqrt
	if std < 0 {
		std = 0
	}

	return map[string]interface{}{
		"mean": mean,
		"std":  std,
		"min":  min(data),
		"max":  max(data),
	}
}

func min(data []float64) float64 {
	if len(data) == 0 {
		return 0
	}
	m := data[0]
	for _, v := range data {
		if v < m {
			m = v
		}
	}
	return m
}

func max(data []float64) float64 {
	if len(data) == 0 {
		return 0
	}
	m := data[0]
	for _, v := range data {
		if v > m {
			m = v
		}
	}
	return m
}

// ============================================================
// Log Alert Handler
// ============================================================

type LogAlertHandler struct{}

func (h *LogAlertHandler) Handle(alert *Alert) error {
	fmt.Printf("[ALERT] %s - Model: %s, Metric: %s=%.2f (threshold: %.2f)\n",
		alert.Severity, alert.ModelVersionID, alert.MetricName, alert.MetricValue, alert.Threshold)
	return nil
}

