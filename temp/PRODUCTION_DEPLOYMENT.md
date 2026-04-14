# ML Learning System - Production Deployment Guide

## Overview

This guide covers production deployment of the complete ML Learning System using Podman, including:
- Multi-container orchestration with podman-compose
- Infrastructure setup (PostgreSQL, MinIO)
- ML services deployment
- Monitoring and observability
- Testing and validation
- Security best practices

## Prerequisites

- Podman 4.0+
- podman-compose 1.0+
- Available ports: 5432, 9000, 9001, 8081, 8082, 3030, 9090, 3000
- Minimum resources: 4 CPU cores, 8GB RAM
- PostgreSQL 16+ (via container)
- MinIO S3-compatible storage (via container)

## Quick Start

### 1. Prepare Environment

```bash
# Clone repository
git clone https://github.com/solar3d/solar3d
cd solar3d

# Create environment file
cat > .env.production << EOF
POSTGRES_USER=solar3d
POSTGRES_PASSWORD=$(openssl rand -base64 32)
POSTGRES_DB=solar3d
POSTGRES_PORT=5432

MINIO_ROOT_USER=solar3d
MINIO_ROOT_PASSWORD=$(openssl rand -base64 32)

LOG_LEVEL=info
GRAFANA_ADMIN_PASSWORD=$(openssl rand -base64 16)

# Optional explicit routing for advanced analytics workflow stages.
# Defaults are shown below and match podman-compose.yml.
GEO_SERVICE_URL=http://compute-service:8081
GRAPH_SERVICE_URL=http://compute-service:8081
OPTIMIZATION_SERVICE_URL=http://compute-service:8081
SIMULATION_SERVICE_URL=http://compute-service:8081
ML_INFERENCE_SERVICE_URL=http://compute-service:8081
PLOT_SHEET_SERVICE_URL=http://plot-sheet-service:8080
EOF

# Load environment
export $(cat .env.production | xargs)
```

### 2. Start Services

```bash
# Make deployment script executable
chmod +x deploy-ml-production.sh

# Run deployment
./deploy-ml-production.sh
```

The script will:
1. Build container images
2. Start PostgreSQL and MinIO
3. Run database migrations
4. Start ML services
5. Launch monitoring stack
6. Run health checks

### 3. Verify Deployment

```bash
# Check all services are running
podman-compose -f podman-compose.yml ps

# View service logs
podman-compose -f podman-compose.yml logs -f compute-service
podman-compose -f podman-compose.yml logs -f compute-orchestration-service
podman-compose -f podman-compose.yml logs -f ml-inference-bridge

# Test API endpoints
curl -X GET http://localhost:8081/health
curl -X GET http://localhost:8082/health
curl -X GET http://localhost:3030/health
```

## Service Description

### Compute Service (Port 8081)

Handles ML training feedback and model management RPCs:

**Key Endpoints:**
- `POST /solar3d.ml_inference.v1.MLInferenceService/SubmitFeedback` - Collect post-prediction labels
- `POST /solar3d.ml_inference.v1.MLInferenceService/StartTraining` - Trigger training job
- `POST /solar3d.ml_inference.v1.MLInferenceService/GetTrainingStatus` - Monitor training progress
- `POST /solar3d.ml_inference.v1.MLInferenceService/EvaluateModel` - Compare models
- `POST /solar3d.ml_inference.v1.MLInferenceService/DeployModelVersion` - Deploy with safety gates
- `POST /solar3d.ml_inference.v1.MLInferenceService/RollbackModelVersion` - Emergency rollback

**Example: Start Training**
```bash
curl -X POST http://localhost:8081/solar3d.ml_inference.v1.MLInferenceService/StartTraining \
  -H "Content-Type: application/json" \
  -d '{
    "task_type": "yield_prediction",
    "training_type": "all",
    "hyperparams": {
      "learning_rate": "0.001",
      "epochs": "10",
      "batch_size": "32"
    }
  }'
```

### Orchestration Service (Port 8082)

Manages 7-step training pipeline, monitoring, and safety gates:

**Advanced Analytics Workflow Routing Variables:**
- `COMPUTE_SERVICE_URL` - Base fallback URL for compute RPCs.
- `GEO_SERVICE_URL` - Geo RPC endpoint override.
- `GRAPH_SERVICE_URL` - Graph RPC endpoint override.
- `OPTIMIZATION_SERVICE_URL` - Optimization RPC endpoint override.
- `SIMULATION_SERVICE_URL` - Simulation RPC endpoint override.
- `ML_INFERENCE_SERVICE_URL` - ML inference RPC endpoint override.
- `PLOT_SHEET_SERVICE_URL` - Plot/Sheet publish RPC endpoint.

When these are not explicitly set, orchestration falls back to `COMPUTE_SERVICE_URL` for compute stages and only requires `PLOT_SHEET_SERVICE_URL` for publish stage routing.

**7-Step Workflow:**
1. DatasetPrepStep - Query feedback, prepare splits
2. FeatureValidationStep - Verify schema consistency
3. TrainingStep - Execute model training
4. EvaluationStep - Compare candidate vs champion
5. SafetyCheckStep - Verify metrics and regressions
6. CanaryDeploymentStep - Deploy to 10% traffic
7. PromotionStep - Promote to 100% if metrics pass

**Safety Gates:**
- Canary deployment (10% traffic first)
- Drift detection (KS-test, Wasserstein, PSI)
- Automatic rollback on metric degradation
- Audit trail for all operations

### ML Inference Bridge (Port 3030)

Rust-based ML inference with model versioning:

**Features:**
- Thread-safe model registry
- Hot-reload support
- Feature schema validation
- Graceful fallback to previous model
- Comprehensive audit logging

## Database Schema

PostgreSQL contains 15 tables for complete ML lifecycle:

### Core Tables
- `ml_prediction_logs` - All predictions with model version
- `ml_feedback_labels` - Post-prediction labels from production
- `ml_feature_schemas` - Feature contracts with versioning
- `ml_datasets` - Training data snapshots

### Training
- `ml_training_runs` - Training job tracking
- `ml_training_samples` - Prepared training data (train/val/test)
- `ml_model_versions` - Model artifacts and metadata

### Deployment
- `ml_deployments` - Deployment records with canary info
- `ml_active_models` - Current production models per task
- `ml_eval_runs` - Candidate vs champion comparisons

### Monitoring
- `ml_monitoring_metrics` - Time-series metrics (MAE, RMSE, etc)
- `ml_feature_drift_stats` - Drift detection results
- `ml_audit_events` - Full audit trail

## Monitoring and Observability

### Prometheus (Port 9090)

Scrapes metrics from all services:
- Training pipeline metrics
- Model deployment events
- Prediction latency and accuracy
- Drift detection scores
- Service health

### Grafana (Port 3000)

Dashboards for monitoring:
- Training Pipeline Status
- Model Performance Trends
- Drift Detection Alerts
- Deployment Safety Gates
- Resource Utilization

Access at `http://localhost:3000` with credentials:
- Username: `admin`
- Password: from `GRAFANA_ADMIN_PASSWORD`

## Storage

### PostgreSQL (Port 5432)

Persistent data:
- Database: `solar3d`
- User: from `POSTGRES_USER`
- Password: from `POSTGRES_PASSWORD`

Connect:
```bash
psql -h localhost -U solar3d -d solar3d
```

### MinIO (Port 9000, Console 9001)

S3-compatible artifact storage:
- ML model artifacts
- Training data snapshots
- Evaluation results
- Deployment artifacts

Buckets created:
- `ml-models` - Model versions
- `training-artifacts` - Training outputs
- `predictions` - Prediction logs

## Testing

### Unit Tests
```bash
cd services/compute-service
go test ./internal/service -v
```

### Integration Tests
```bash
cd services/compute-service
go test ./internal/service -run TestEndToEndMLLifecycle -v
```

### Load Tests
```bash
cd services/compute-service
go test -timeout 120s ./internal/service -run TestLoad -v
```

Tests include:
- 50 concurrent workers
- 100 requests per worker
- Model refresh during load
- Latency percentiles (P50, P95, P99)

### Chaos Tests
```bash
cd services/compute-service
go test -timeout 120s ./internal/service -run TestChaos -v
```

Tests simulate:
- Artifact storage outages (50% failure rate)
- Model registry failures (70% failure rate)
- Network partitions (95% failure rate)
- Multiple simultaneous failures
- Graceful degradation

## Production Checklist

### Pre-Deployment
- [ ] All environment variables configured
- [ ] Database backups enabled
- [ ] MinIO backups enabled
- [ ] SSL certificates obtained
- [ ] Firewall rules configured
- [ ] Resource limits verified

### Deployment
- [ ] Services start successfully
- [ ] Health checks pass
- [ ] Database migrations complete
- [ ] MinIO buckets created
- [ ] Monitoring stack online

### Post-Deployment
- [ ] All services responding to health checks
- [ ] Prometheus scraping metrics
- [ ] Grafana dashboards populated
- [ ] Audit trail recording events
- [ ] Alerts configured and tested

### Operational
- [ ] Backup schedule running
- [ ] Log retention configured
- [ ] Security patches scheduled
- [ ] Capacity planning in place
- [ ] Documentation updated

## Common Operations

### View Training Status
```bash
# Get training run details
curl -X POST http://localhost:8081/solar3d.ml_inference.v1.MLInferenceService/GetTrainingStatus \
  -H "Content-Type: application/json" \
  -d '{"training_run_id": "training_run_001"}'

# Query database directly
psql -h localhost -U solar3d -d solar3d -c \
  "SELECT id, task_type, status, metrics FROM ml_training_runs ORDER BY created_at DESC LIMIT 10;"
```

### List Model Versions
```bash
curl -X POST http://localhost:8081/solar3d.ml_inference.v1.MLInferenceService/GetModelVersions \
  -H "Content-Type: application/json" \
  -d '{"task_type": "yield_prediction", "status": "candidate", "limit": 10}'
```

### Deploy Model
```bash
curl -X POST http://localhost:8081/solar3d.ml_inference.v1.MLInferenceService/DeployModelVersion \
  -H "Content-Type: application/json" \
  -d '{
    "model_version_id": "model_v2_candidate",
    "traffic_percent": 10,
    "policy": {
      "deployment_type": "canary",
      "canary_duration": "3600",
      "min_traffic": "10",
      "max_traffic": "100"
    }
  }'
```

### Emergency Rollback
```bash
curl -X POST http://localhost:8081/solar3d.ml_inference.v1.MLInferenceService/RollbackModelVersion \
  -H "Content-Type: application/json" \
  -d '{
    "deployment_id": "deployment_001",
    "rollback_reason": "Quality degradation detected",
    "rollback_triggered_by": "admin"
  }'
```

### Monitor Service Logs
```bash
# All services
podman-compose -f podman-compose.yml logs -f

# Specific service with filtering
podman-compose -f podman-compose.yml logs -f compute-service | grep ERROR
```

### Check Database Health
```bash
psql -h localhost -U solar3d -d solar3d << EOF
-- Check table sizes
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) 
FROM pg_tables 
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check recent training runs
SELECT id, task_type, status, created_at FROM ml_training_runs ORDER BY created_at DESC LIMIT 10;

-- Check active models
SELECT * FROM ml_active_models;
EOF
```

## Troubleshooting

### Service won't start
```bash
# Check logs
podman-compose -f podman-compose.yml logs <service-name>

# Verify dependencies
podman-compose -f podman-compose.yml exec <service-name> curl http://postgres:5432

# Check resource limits
podman stats
```

### Database connection errors
```bash
# Test PostgreSQL connection
podman-compose -f podman-compose.yml exec -T postgres pg_isready

# Check database exists
podman-compose -f podman-compose.yml exec -T postgres psql -U solar3d -d solar3d -c "SELECT 1"
```

### MinIO bucket access issues
```bash
# List buckets
podman-compose -f podman-compose.yml exec -T minio mc ls minio/

# Check bucket permissions
podman-compose -f podman-compose.yml exec -T minio mc stat minio/ml-models
```

### High latency or slow training
```bash
# Check system resources
podman stats

# Check database query performance
psql -h localhost -U solar3d -d solar3d -c "SELECT * FROM pg_stat_statements ORDER BY mean_exec_time DESC LIMIT 10;"

# Check model size
podman-compose -f podman-compose.yml exec -T minio mc du minio/ml-models/
```

## Security Best Practices

### Network Security
- [ ] Use TLS for all inter-service communication
- [ ] Restrict database access to application network only
- [ ] Use firewall rules to limit exposure
- [ ] Consider service mesh for fine-grained policies

### Authentication & Authorization
- [ ] Rotate database passwords regularly
- [ ] Use IAM for MinIO access
- [ ] Implement API authentication for external consumers
- [ ] Use audit logging for all privileged operations

### Data Protection
- [ ] Enable encryption at rest for database
- [ ] Enable encryption in transit (TLS)
- [ ] Implement backup encryption
- [ ] Use separate credentials for different environments

### Monitoring & Auditing
- [ ] Enable query logging in PostgreSQL
- [ ] Monitor resource utilization
- [ ] Alert on anomalies
- [ ] Review audit logs regularly

## Performance Tuning

### PostgreSQL
```bash
# Connection pooling
CREATE EXTENSION IF NOT EXISTS pg_partman;

# Index optimization
ANALYZE;
VACUUM FULL;

# Slow query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- 1 second
```

### Application
- Adjust concurrency based on load
- Configure batch sizes for training
- Optimize feature schema for inference
- Enable query result caching

### Infrastructure
- Use SSD storage for PostgreSQL
- Configure swap space for large datasets
- Monitor and tune TCP buffers
- Allocate sufficient disk space

## Maintenance

### Daily
- [ ] Monitor service health
- [ ] Check error logs
- [ ] Verify backups

### Weekly
- [ ] Review monitoring dashboards
- [ ] Update security patches
- [ ] Test rollback procedures
- [ ] Audit training metrics

### Monthly
- [ ] Full backup verification
- [ ] Capacity planning review
- [ ] Security audit
- [ ] Performance optimization review

## Disaster Recovery

### Data Backup
```bash
# PostgreSQL backup
podman-compose -f podman-compose.yml exec -T postgres \
  pg_dump -U solar3d solar3d > /backups/solar3d_$(date +%Y%m%d).sql

# MinIO backup
podman-compose -f podman-compose.yml exec -T minio \
  mc mirror minio/ml-models /backups/ml-models-$(date +%Y%m%d)
```

### Recovery Procedures
1. Stop all services
2. Restore database from backup
3. Restore MinIO artifacts
4. Verify data integrity
5. Start services in dependency order
6. Validate system functionality

## Support

For issues, questions, or contributions:
- GitHub: https://github.com/solar3d/solar3d
- Documentation: ./ML_LEARNING_SYSTEM.md
- Issues: https://github.com/solar3d/solar3d/issues
