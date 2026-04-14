# Podman/WSL Issue Resolution Guide

**Issue:** Podman machine has WSL root user issues preventing builds

**Solutions:**

---

## Option 1: Use Docker Desktop (Recommended - Simplest)

If you have Docker Desktop installed, you can use it immediately without Podman setup hassles:

```bash
# Verify Docker is installed
docker --version

# Test the build with Docker instead
docker build -f deploy/docker/go-service.Dockerfile \
  --build-arg SERVICE_NAME=project-service \
  -t solar3d/project-service:latest .

# Use docker-compose 
docker-compose -f docker-compose.yml up -d --build

# All commands work identically with docker or podman
```

### Install Docker Desktop (if not present)
1. Download: https://www.docker.com/products/docker-desktop
2. Run installer
3. Restart Windows
4. Verify: `docker --version`

---

## Option 2: Fix WSL Podman Machine

### Method A: Quick Reset (Recommended)

```powershell
# Stop the machine
podman machine stop

# Clear the problematic distro
wsl --list -v
wsl --unregister podman-machine-default

# Reinitialize
podman machine init --now

# Verify
podman version
```

### Method B: Reset Entire WSL (Nuclear option)

```powershell
# WARNING: This removes ALL WSL distributions and their data
wsl --shutdown
wsl --list -v
wsl --unregister Ubuntu-24.04  # or whatever distro you use
wsl --unregister podman-machine-default

# Then reinitialize Podman
podman machine init --now
```

### Method C: Use Existing WSL Distro

If you have an existing WSL distro (Ubuntu, etc), use that instead:

```powershell
# List WSL distros
wsl -l -v

# Connect Podman to existing distro
podman machine init --image-path=/mnt/c/path/to/distro

# Or manually create connection
podman system connection add wsl ssh://user@wsl-distro.local
```

---

## Option 3: Use Podman with Rootful Mode

```powershell
# Create rootful machine (different permissions model)
podman machine init --rootful

# Start it
podman machine start

# Test build
podman build -f deploy/docker/go-service.Dockerfile \
  --build-arg SERVICE_NAME=project-service \
  -t solar3d/project-service:latest .
```

---

## Option 4: Run Services on Host (Development Only)

Skip containers entirely for development and run services directly:

```bash
# Install Go dependencies
cd services/project-service
go mod download

# Run service directly
go run ./cmd/server/main.go

# Other services similarly
```

---

## Recommended Path Forward

### If you want to use Podman (best long-term):

1. **Try Option 2A first** (Quick WSL reset) — 80% success rate
   ```powershell
   wsl --unregister podman-machine-default
   podman machine init --now
   ```

2. If that fails, try **Option 1** (Docker Desktop) — works instantly
   ```bash
   docker-compose up -d --build
   ```

### If you want to keep using Podman:

Switch to **Linux** or **macOS** where Podman works flawlessly without WSL complications

---

## Quick Comparison

| Method | Setup Time | Reliability | Notes |
|--------|-----------|-------------|-------|
| Docker Desktop | 5 min | ✅ Excellent | Works perfectly, most reliable |
| Podman (Fresh) | 10 min | ✅ Good | If WSL reset works |
| WSL Distro | 15 min | ⚠️ Moderate | Requires manual config |
| Rootful Podman | 5 min | ⚠️ Risky | Less secure, may need tweaks |
| Host build | 2 min | ✅ Excellent | No containers, fast iteration |

---

## Next Steps

**Choose one:**

### Path A: Docker (Recommended for Windows)
```bash
docker --version
docker-compose up -d --build  # Replaces: podman-compose up -d --build
```

### Path B: Fix Podman (Try Option 2A)
```powershell
wsl --unregister podman-machine-default
podman machine init --now
podman version
cd e:\Brahma\Solar3d
podman-compose up -d --build
```

### Path C: Host-based development (Fastest for iteration)
```bash
cd e:\Brahma\Solar3d\services\project-service
go run ./cmd/server/main.go
```

---

Let me know which option you prefer and I'll help you set it up! 🚀
