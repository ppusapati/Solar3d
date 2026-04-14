package config

import (
	"testing"
	"time"
)

func TestLoadDefaults(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/solar3d")
	t.Setenv("PORT", "")
	t.Setenv("LOG_LEVEL", "")
	t.Setenv("INTEGRITY_AUDIT_ENABLED", "")
	t.Setenv("INTEGRITY_AUDIT_INTERVAL", "")
	t.Setenv("INTEGRITY_AUDIT_BATCH_SIZE", "")
	t.Setenv("INTEGRITY_AUDIT_STARTUP_DELAY", "")

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load returned error: %v", err)
	}
	if !cfg.IntegrityAuditEnabled {
		t.Fatal("expected integrity audit to be enabled by default")
	}
	if cfg.IntegrityAuditInterval != 5*time.Minute {
		t.Fatalf("expected default interval 5m, got %s", cfg.IntegrityAuditInterval)
	}
	if cfg.IntegrityAuditBatchSize != 250 {
		t.Fatalf("expected default batch size 250, got %d", cfg.IntegrityAuditBatchSize)
	}
	if cfg.IntegrityAuditStartupDelay != 30*time.Second {
		t.Fatalf("expected default startup delay 30s, got %s", cfg.IntegrityAuditStartupDelay)
	}
}

func TestLoadIntegrityAuditOverrides(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/solar3d")
	t.Setenv("INTEGRITY_AUDIT_ENABLED", "false")
	t.Setenv("INTEGRITY_AUDIT_INTERVAL", "2m")
	t.Setenv("INTEGRITY_AUDIT_BATCH_SIZE", "75")
	t.Setenv("INTEGRITY_AUDIT_STARTUP_DELAY", "5s")

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load returned error: %v", err)
	}
	if cfg.IntegrityAuditEnabled {
		t.Fatal("expected integrity audit to be disabled")
	}
	if cfg.IntegrityAuditInterval != 2*time.Minute {
		t.Fatalf("expected interval 2m, got %s", cfg.IntegrityAuditInterval)
	}
	if cfg.IntegrityAuditBatchSize != 75 {
		t.Fatalf("expected batch size 75, got %d", cfg.IntegrityAuditBatchSize)
	}
	if cfg.IntegrityAuditStartupDelay != 5*time.Second {
		t.Fatalf("expected startup delay 5s, got %s", cfg.IntegrityAuditStartupDelay)
	}
}

