#!/bin/bash
# ML Learning System - Production Readiness Validation
# Comprehensive checklist and validation script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0
WARNING=0

check() {
    local name=$1
    local command=$2
    
    echo -n "  [$name] ... "
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC}"
        ((FAILED++))
    fi
}

warn() {
    local name=$1
    echo -e "  ${YELLOW}⚠${NC} [$name]"
    ((WARNING++))
}

section() {
    echo ""
    echo -e "${BLUE}■ $1${NC}"
}

# ============================================================
# Prerequisites
# ============================================================

section "Prerequisites"
check "Podman installed" "command -v podman"
check "Podman compose installed" "command -v podman-compose"
check "curl available" "command -v curl"
check "Go executable available" "cd services/compute-service && go version"
check "Cargo available" "cd compute/ml-inference && cargo --version"
check "PostgreSQL driver available" "command -v psql"

# ============================================================
# Code Quality
# ============================================================

section "Code Quality"
check "Compute service builds" "cd services/compute-service && $env:GOWORK='off'; go build ./..."
check "Orchestration service builds" "cd services/compute-orchestration-service && $env:GOWORK='off'; go build ./..."
check "ML Inference builds" "cd compute/ml-inference && cargo build --release >/dev/null 2>&1"

# ============================================================
# Tests
# ============================================================

section "Unit Tests"
check "Compute service tests pass" "cd services/compute-service && $env:GOWORK='off'; go test ./internal/service -q"
check "Orchestration tests pass" "cd services/compute-orchestration-service && $env:GOWORK='off'; go test ./internal/workflows -q"

# ============================================================
# Database
# ============================================================

section "Database Schema"
check "Migrations exist" "[ -f migrations/004_ml_learning_system.sql ]"
check "Migration is valid SQL" "grep -q 'ml_model_versions' migrations/004_ml_learning_system.sql"
check "Audit tables defined" "grep -q 'ml_audit_events' migrations/004_ml_learning_system.sql"
check "Feature schemas table" "grep -q 'ml_feature_schemas' migrations/004_ml_learning_system.sql"
check "Monitoring tables" "grep -q 'ml_monitoring_metrics' migrations/004_ml_learning_system.sql"
check "Deployment tracking" "grep -q 'ml_deployments' migrations/004_ml_learning_system.sql"

# ============================================================
# API Contracts
# ============================================================

section "API Contracts (Proto)"
check "ML Inference proto exists" "[ -f proto/ml_inference/v1/ml_inference.proto ]"
check "StartTraining RPC defined" "grep -q 'rpc StartTraining' proto/ml_inference/v1/ml_inference.proto"
check "SubmitFeedback RPC defined" "grep -q 'rpc SubmitFeedback' proto/ml_inference/v1/ml_inference.proto"
check "EvaluateModel RPC defined" "grep -q 'rpc EvaluateModel' proto/ml_inference/v1/ml_inference.proto"
check "DeployModelVersion RPC defined" "grep -q 'rpc DeployModelVersion' proto/ml_inference/v1/ml_inference.proto"
check "RollbackModelVersion RPC defined" "grep -q 'rpc RollbackModelVersion' proto/ml_inference/v1/ml_inference.proto"
check "GetActiveModelVersion RPC defined" "grep -q 'rpc GetActiveModelVersion' proto/ml_inference/v1/ml_inference.proto"

# ============================================================
# Service Layer
# ============================================================

section "Service Layer (Go)"
check "ML training service exists" "[ -f services/compute-service/internal/service/ml_training.go ]"
check "Training models defined" "[ -f services/compute-service/internal/models/ml_training.go ]"
check "Repository interface" "[ -f services/compute-service/internal/repository/ml_training.go ]"
check "Training handlers" "[ -f services/compute-service/internal/handler/ml_training.go ]"
check "Training mappers" "[ -f services/compute-service/internal/mappers/ml_training.go ]"

# ============================================================
# Orchestration  
# ============================================================

section "Orchestration Workflows"
check "Workflow file exists" "[ -f services/compute-orchestration-service/internal/workflows/ml_training.go ]"
check "Monitoring engine exists" "[ -f services/compute-orchestration-service/internal/monitoring/engine.go ]"
check "7-step pipeline defined" "grep -q 'DatasetPrepStep\|FeatureValidationStep\|TrainingStep\|EvaluationStep\|SafetyCheckStep\|CanaryDeploymentStep\|PromotionStep' services/compute-orchestration-service/internal/workflows/ml_training.go"

# ============================================================
# ML Inference Bridge
# ============================================================

section "ML Inference Bridge (Rust)"
check "Model registry exists" "[ -f compute/ml-inference/src/model_registry.rs ]"
check "Hot-reload support" "grep -q 'hot.reload\|reload' compute/ml-inference/src/model_registry.rs"
check "Feature validation" "grep -q 'FeatureSchema' compute/ml-inference/src/model_registry.rs"
check "Fallback logic" "grep -q 'fallback\|previous' compute/ml-inference/src/model_registry.rs"

# ============================================================
# Monitoring & Observability
# ============================================================

section "Monitoring & Observability"
check "Prometheus config" "[ -f monitoring/prometheus.yml ]"
check "Grafana datasources" "[ -f monitoring/grafana-datasources.yml ]"
check "Grafana dashboards" "[ -f monitoring/grafana-dashboards.yml ]"

# ============================================================
# Deployment
# ============================================================

section "Deployment Configuration"
check "podman-compose.yml exists" "[ -f podman-compose.yml ]"
check "Compute service in compose" "grep -q 'compute-service:' podman-compose.yml"
check "Orchestration in compose" "grep -q 'compute-orchestration-service:' podman-compose.yml"
check "ML Inference in compose" "grep -q 'ml-inference-bridge:' podman-compose.yml"
check "PostgreSQL in compose" "grep -q 'postgres:' podman-compose.yml"
check "MinIO in compose" "grep -q 'minio:' podman-compose.yml"
check "Prometheus in compose" "grep -q 'prometheus:' podman-compose.yml"
check "Grafana in compose" "grep -q 'grafana:' podman-compose.yml"

check "Deployment script exists" "[ -f deploy-ml-production.sh ]"
check "Environment template" "[ -f .env.production.example ]"
check "Production documentation" "[ -f PRODUCTION_DEPLOYMENT.md ]"

# ============================================================
# Safety & Security
# ============================================================

section "Safety & Security Gates"
check "Canary deployment policy" "grep -q 'canary' services/compute-orchestration-service/internal/workflows/ml_training.go"
check "Rollback mechanism" "grep -q 'rollback\|Rollback' services/compute-service/internal/service/ml_training.go"
check "Drift detection" "grep -q 'KSTestDetector\|WassersteinDetector\|PSIDetector' services/compute-orchestration-service/internal/monitoring/engine.go"
check "Audit logging" "grep -q 'ml_audit_events' migrations/004_ml_learning_system.sql"
check "Model versioning" "grep -q 'ml_model_versions' migrations/004_ml_learning_system.sql"
check "Artifact integrity" "grep -q 'artifact_hash' migrations/004_ml_learning_system.sql"

# ============================================================
# Documentation
# ============================================================

section "Documentation"
check "ML Learning System doc" "[ -f ML_LEARNING_SYSTEM.md ]"
check "Production deployment guide" "[ -f PRODUCTION_DEPLOYMENT.md ]"
check "README exists" "[ -f README.md ]"

# ============================================================
# Summary
# ============================================================

echo ""
echo "======================================================"
echo -e "${BLUE}Production Readiness Validation Report${NC}"
echo "======================================================"
echo -e "${GREEN}Passed:${NC}  $PASSED"
[ $FAILED -eq 0 ] && echo -e "${GREEN}Failed:${NC}  $FAILED" || echo -e "${RED}Failed:${NC}  $FAILED"
[ $WARNING -eq 0 ] && echo -e "${GREEN}Warnings:${NC} $WARNING" || echo -e "${YELLOW}Warnings:${NC} $WARNING"
echo "======================================================"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ System is PRODUCTION READY${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Review PRODUCTION_DEPLOYMENT.md"
    echo "  2. Configure .env.production from .env.production.example"
    echo "  3. Run: ./deploy-ml-production.sh"
    exit 0
else
    echo -e "${RED}✗ System has $FAILED FAILURES${NC}"
    echo ""
    echo "Resolve failing checks before deploying to production."
    exit 1
fi
