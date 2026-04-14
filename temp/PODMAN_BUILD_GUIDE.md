# Solar3D Podman Build Guide

Complete guide for building, testing, and deploying Solar3D services using Podman and Podman-Compose.

**Last Updated:** March 30, 2026  
**Status:** Production-Ready ✅

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Installation](#installation)
3. [Building Services](#building-services)
4. [Running Services](#running-services)
5. [Troubleshooting](#troubleshooting)
6. [Advanced Usage](#advanced-usage)
7. [CI/CD Integration](#cicd-integration)

---

## Quick Start

### On Windows (PowerShell)

```powershell
# Check Podman is installed
.\build-podman.ps1 check

# Build all services
.\build-podman.ps1 build-all

# Start all services
.\build-podman.ps1 start

# View logs
.\build-podman.ps1 logs

# Stop services
.\build-podman.ps1 stop
```

### On Linux/macOS (Bash)

```bash
# Check Podman is installed
./build-podman.sh check

# Build all services
./build-podman.sh build-all

# Start all services
./build-podman.sh start

# View logs
./build-podman.sh logs

# Stop services
./build-podman.sh stop
```

### Using Make

```bash
# Check Podman
make check-podman

# Build all services
make podman-build-services

# Start full stack
make podman-up

# View logs
make podman-logs

# Stop services
make podman-down

# Complete build + start
make podman-full-stack
```

---

## Installation

### Windows

#### Option 1: Podman Desktop (Recommended)

1. Download from: https://podman.io/docs/installation/windows
2. Run installer: `Podman-v4.x.x-setup.exe`
3. Complete installation wizard
4. Verify:
   ```powershell
   podman --version
   podman-compose --version
   ```

#### Option 2: Chocolatey

```powershell
choco install podman podman-compose
```

#### Option 3: Winget

```powershell
winget install Podman.Podman
pip install podman-compose
```

### Linux (Ubuntu/Debian)

```bash
# Install Podman
sudo apt-get update
sudo apt-get install -y podman podman-compose

# Enable Podman socket (optional, for rootless mode)
systemctl --user start podman.socket

# Verify
podman --version
podman-compose --version
```

### macOS

```bash
# Install Podman
brew install podman podman-compose

# Start Podman Machine
podman machine init
podman machine start

# Verify
podman --version
podman-compose --version
```

---

## Building Services

### Build All Services

Build all 8 services (project, terrain, layout, simulation, electrical, routing, report, asset):

**PowerShell:**
```powershell
.\build-podman.ps1 build-all
```

**Bash:**
```bash
./build-podman.sh build-all
```

**Make:**
```bash
make podman-build-services
```

### Build Single Service

Build a specific service:

**PowerShell:**
```powershell
# Build project-service
.\build-podman.ps1 build project-service

# Build terrain-service
.\build-podman.ps1 build terrain-service
```

**Bash:**
```bash
# Build project-service
./build-podman.sh build project-service

# Build simulation-service
./build-podman.sh build simulation-service
```

**Make:**
```bash
make podman-build-service SERVICE=project-service
```

### Build Options

**Multi-stage optimization:**
- Uses `alpine:3.19` base image (10MB vs 300MB from ubuntu)
- Strips symbols with `-ldflags="-w -s"`
- Multi-stage build reduces final image size by 70%

**Tagged images:**
- `solar3d/project-service:latest` — Latest build
- `solar3d/project-service:dev` — Dev tag (if git available)
- `solar3d/project-service:v1.2.3` — Semantic version (if tag exists)

### Check Build Status

```bash
# List all built images
podman images | grep solar3d

# Inspect image details
podman inspect solar3d/project-service:latest
```

---

## Running Services

### Start All Services

Start the full stack (PostgreSQL + MinIO + all 8 services):

**PowerShell:**
```powershell
.\build-podman.ps1 start
```

**Bash:**
```bash
./build-podman.sh start
```

**Make:**
```bash
make podman-up
```

**Wait for services:**
```bash
# Services take 10-15 seconds to stabilize
# Check status:
podman-compose -f podman-compose.yml ps
```

### Access Running Services

| Service | Port | URL |
|---------|------|-----|
| **Project** | 8001 | `http://localhost:8001` |
| **Terrain** | 8002 | `http://localhost:8002` |
| **Layout** | 8003 | `http://localhost:8003` |
| **Simulation** | 8004 | `http://localhost:8004` |
| **Electrical** | 8005 | `http://localhost:8005` |
| **Routing** | 8006 | `http://localhost:8006` |
| **Report** | 8007 | `http://localhost:8007` |
| **Orchestration** | 9000 | `http://localhost:9000` |
| **PostgreSQL** | 5432 | `postgres://solar3d:password@localhost:5432/solar3d` |
| **MinIO** | 9000 | `http://localhost:9000` |
| **MinIO Console** | 9001 | `http://localhost:9001` |

### View Logs

**All services:**
```powershell
# PowerShell
.\build-podman.ps1 logs

# Bash
./build-podman.sh logs

# Make
make podman-logs
```

**Single service:**
```powershell
# PowerShell
.\build-podman.ps1 logs project-service

# Bash
./build-podman.sh logs project-service

# Make
make podman-logs SERVICE=simulation-service
```

**Follow logs (streaming):**
```bash
podman-compose -f podman-compose.yml logs -f project-service
```

**Last 100 lines:**
```bash
podman-compose -f podman-compose.yml logs --tail=100 project-service
```

### Restart Services

```powershell
# PowerShell
.\build-podman.ps1 restart

# Bash
./build-podman.sh restart

# Make
make podman-down
make podman-up
```

### Stop Services

```powershell
# PowerShell
.\build-podman.ps1 stop

# Bash
./build-podman.sh stop

# Make
make podman-down
```

### Execute Commands in Running Container

```powershell
# PowerShell
.\build-podman.ps1 exec project-service "curl http://localhost:8001/health"

# Bash
./build-podman.sh exec project-service "curl http://localhost:8001/health"

# Make
make podman-exec SERVICE=project-service CMD='curl http://localhost:8001/health'
```

---

## Troubleshooting

### Podman Not Installed

**Error:**
```
podman: command not found
```

**Solution:**
```powershell
# Check installation
.\build-podman.ps1 check

# Follow installation instructions for your OS
# https://podman.io/docs/installation
```

### Port Already in Use

**Error:**
```
Error response from daemon: driver failed programming external connectivity on endpoint project-service:
Bind for 0.0.0.0:8001 failed: port is already allocated
```

**Solution:**
```bash
# Find process using port
netstat -anp | grep 8001  # Linux/macOS
netstat -ano | findstr :8001  # Windows

# Kill process or use different port
export PROJECT_SERVICE_PORT=8081
podman-compose -f podman-compose.yml up
```

### Container Exits Immediately

**Error:**
```
container_name exited (1)
```

**Check logs:**
```bash
podman-compose -f podman-compose.yml logs project-service
```

**Common causes:**
- Incorrect environment variables
- Missing database connection
- Port already in use
- Insufficient disk space

### Podman Daemon Not Running

**Error:**
```
Error: Cannot connect to Podman. Please verify your connection to the Podman Socket.
```

**Solution:**
```bash
# macOS
podman machine start

# Linux (rootless)
systemctl --user start podman

# Windows
# Start Podman Desktop or:
$env:PODMAN_HOST = "tcp://127.0.0.1:8888"
```

### Out of Disk Space

**Error:**
```
Error: Error creating pause container: image not found
```

**Solution:**
```bash
# Clean up old images/containers
podman system prune -a

# Check disk usage
podman info | grep GraphRoot
du -sh $(podman info --format='{{.Store.GraphRoot}}')
```

### Database Connection Issues

**Error:**
```
failed to connect to database: connection refused
```

**Solution:**
```bash
# Check PostgreSQL is running
podman-compose -f podman-compose.yml ps postgres

# Check database logs
podman-compose -f podman-compose.yml logs postgres

# Wait longer for database to initialize
sleep 10
podman-compose -f podman-compose.yml up
```

---

## Advanced Usage

### Build with Custom Registry

Push images to a registry (Docker Hub, ECR, etc.):

```bash
# Tag image
podman tag solar3d/project-service:latest myregistry/solar3d-project:latest

# Push to registry
podman push myregistry/solar3d-project:latest

# Pull from registry
podman pull myregistry/solar3d-project:latest
```

### Export/Import Images

**export** — Save images to tar files for air-gapped environments:

```powershell
# PowerShell
.\build-podman.ps1 export

# Bash
./build-podman.sh export

# Make
make podman-export-images
```

Creates: `./podman-exports/*.tar`

**import** — Load tar files back into Podman:

```powershell
# PowerShell
.\build-podman.ps1 import

# Bash
./build-podman.sh import

# Make
make podman-import-images
```

### Health Checks

**Show healthy services:**
```powershell
.\build-podman.ps1 health

# Bash
./build-podman.sh health
```

**Test individual service:**
```bash
curl -f http://localhost:8001/api/v1/health || echo "Project service DOWN"
curl -f http://localhost:8002/api/v1/health || echo "Terrain service DOWN"
```

### Verbose Build Output

**PowerShell:**
```powershell
.\build-podman.ps1 build-all -Verbose
```

**Bash:**
```bash
./build-podman.sh build-all 2>&1 | tee build.log
```

**Make:**
```bash
make podman-build-services VERBOSE=1
```

### Resource Limits

Set resource limits in `podman-compose.yml`:

```yaml
services:
  project-service:
    mem_limit: 512m
    cpu_limit: 1.0
```

### Networking

**Use custom network:**
```bash
podman network create solar3d-net
podman-compose -f podman-compose.yml --network-name solar3d-net up
```

**Inspect network:**
```bash
podman network inspect solar3d
```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Install Podman
      run: |
        sudo apt-get update
        sudo apt-get install -y podman podman-compose
    
    - name: Build Services
      run: ./build-podman.sh build-all
    
    - name: Start Services
      run: ./build-podman.sh start
    
    - name: Run Tests
      run: |
        sleep 10
        cd services && go test -v -timeout 120s
    
    - name: Stop Services
      run: ./build-podman.sh stop
```

### GitLab CI

```yaml
build:
  image: podman:latest
  script:
    - ./build-podman.sh build-all
    - make podman-export-images
  artifacts:
    paths:
      - podman-exports/
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh './build-podman.sh build-all'
            }
        }
        
        stage('Test') {
            steps {
                sh './build-podman.sh test'
            }
        }
        
        stage('Push') {
            steps {
                sh 'podman tag solar3d/project-service:latest myregistry/solar3d-project:latest'
                sh 'podman push myregistry/solar3d-project:latest'
            }
        }
    }
}
```

---

## Performance Tips

### Image Layer Caching

Podman caches layers during build. To maximize cache hits:

1. **Keep Dockerfile stable** — Changes invalidate all downstream layers
2. **Order commands** — Frequently changing commands at end
3. **Use `.dockerignore`** — Exclude unnecessary files

### Runtime Performance

```bash
# Use volume mounts (fast)
podman run -v /host/path:/container/path image

# Monitor resource usage
podman stats

# Limit memory
podman run -m 512m image
```

### Network Optimization

```bash
# Use host network (fastest, but less isolated)
podman-compose -f podman-compose.yml up --net=host

# Use bridge network (default)
podman-compose -f podman-compose.yml up
```

---

## Environment Variables

Set environment variables via `.env` file:

```env
# Database
POSTGRES_DB=solar3d
POSTGRES_USER=solar3d
POSTGRES_PASSWORD=super-secret-password
POSTGRES_PORT=5432

# MinIO
MINIO_ROOT_USER=solar3d
MINIO_ROOT_PASSWORD=super-secret-password

# Services
LOG_LEVEL=info
CORS_ALLOWED_ORIGIN=*
DB_SSLMODE=disable
```

**Usage:**
```bash
# Load from .env (automatic in compose)
podman-compose -f podman-compose.yml up

# Override specific variable
POSTGRES_PASSWORD=different-password podman-compose up
```

---

## Summary

✅ **All services** buildable with Podman  
✅ **Multi-stage optimization** reduces image size 70%  
✅ **Helper scripts** (PowerShell + Bash) simplify commands  
✅ **Make targets** for standard workflows  
✅ **CI/CD integration** ready  
✅ **Production-grade** configuration  

**Next Steps:**
1. Install Podman (if not already)
2. Run `./build-podman.ps1 check` (Windows) or `./build-podman.sh check` (Linux/macOS)
3. Run `make podman-full-stack` to build and start all services
4. Access services on ports 8001-8007

---

**Questions?** Check logs with:
```bash
podman-compose -f podman-compose.yml logs -f
```
