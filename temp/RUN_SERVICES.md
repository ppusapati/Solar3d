# 🚀 Quick Start: Run Solar3D Services on Windows

## TL;DR - Get Services Running in 5 Minutes

## Single Command Dev Mode (Microservices Unchanged)

If you want one command that launches all backend services plus frontend for local testing, use the dev launcher:

```powershell
cd e:\Brahma\Solar3d\services\shared
go run ./cmd/dev-monolith
```

What this does:
- Starts each existing service as its own process using `go run`
- Starts frontend with `pnpm dev --host 0.0.0.0 --port 3000`
- Streams all logs into one terminal with service prefixes
- Stops everything on Ctrl+C

Optional:

```powershell
# Only run selected services
go run ./cmd/dev-monolith -only drawing-revision-service,cad-core-service,api-gateway-service

# Skip frontend
go run ./cmd/dev-monolith -frontend=false
```

### 1. Start Database
```powershell
# Using Docker (preferred)
docker run -d -p 5432:5432 -e POSTGRES_DB=solar3d -e POSTGRES_USER=solar3d -e POSTGRES_PASSWORD=ABcd!@34 --name solar3d-db postgres:15

# OR using Podman
podman run -d -p 5432:5432 -e POSTGRES_DB=solar3d -e POSTGRES_USER=solar3d -e POSTGRES_PASSWORD=ABcd!@34 --name solar3d-db postgres:15

# OR run migrations against existing PostgreSQL
```

Note: PostgreSQL is not an HTTP service. Use port 5432 via a connection string such as `postgres://solar3d:ABcd%21%4034@localhost:5432/solar3d?sslmode=disable`.

### 2. Set Environment
```powershell
$env:DATABASE_URL = "postgres://solar3d:ABcd%21%4034@localhost:5432/solar3d?sslmode=disable"
$env:LOG_LEVEL = "DEBUG"
```

If `DATABASE_URL` is not set, `go run ./cmd/dev-monolith` now loads values from the repo `.env` file and builds the URL automatically.

### 3. Open 8 Terminals (Or Use Terminal Multiplexer)

**Terminal 1:**
```powershell
e:\Brahma\Solar3d\services\project-service\bin\project.exe
```

**Terminal 2:**
```powershell
e:\Brahma\Solar3d\services\terrain-service\bin\terrain.exe
```

**Terminal 3:**
```powershell
e:\Brahma\Solar3d\services\layout-service\bin\layout.exe
```

**Terminal 4:**
```powershell
e:\Brahma\Solar3d\services\simulation-service\bin\simulation.exe
```

**Terminal 5:**
```powershell
e:\Brahma\Solar3d\services\electrical-service\bin\electrical.exe
```

**Terminal 6:**
```powershell
e:\Brahma\Solar3d\services\routing-service\bin\routing.exe
```

**Terminal 7:**
```powershell
e:\Brahma\Solar3d\services\report-service\bin\report.exe
```

**Terminal 8:**
```powershell
e:\Brahma\Solar3d\services\asset-service\bin\asset.exe
```

### 4. Test Services
```powershell
# In a new terminal
curl http://localhost:8001/health
curl http://localhost:8002/health
# ... etc
```

## Ports Reference

```
8001 → project-service    (Project management)
8002 → terrain-service    (Terrain generation)
8003 → layout-service     (Solar farm layout)
8004 → simulation-service (Energy simulation)
8005 → electrical-service (Electrical calculations)
8006 → routing-service    (Wire routing)
8007 → report-service     (Report generation)
8008 → asset-service      (Asset management)
```

## Rebuilding Services

**All services:**
```cmd
build-all.bat
```

**One service:**
```powershell
cd e:\Brahma\Solar3d\services\project-service
go build -o bin/project.exe ./cmd/server/main.go
```

## Database Setup

Run migrations after database is ready:

```powershell
# Navigate to migrations folder
cd e:\Brahma\Solar3d\migrations

# Apply all migrations (adjust connection string as needed)
$connStr = "postgres://postgres:postgres@localhost:5432/solar3d"

# Run each migration
psql -U postgres -d solar3d -f 001_initial_schema.sql
psql -U postgres -d solar3d -f 002_compute_orchestration.sql
psql -U postgres -d solar3d -f 002_project_location.sql
psql -U postgres -d solar3d -f 003_orchestration_idempotency_deadletter.sql
psql -U postgres -d solar3d -f 004_ml_learning_system.sql
```

## Troubleshooting

### Service Won't Start
```
Error: "DATABASE_URL environment variable is required"
```
**Fix:** Set the env var before running
```powershell
$env:DATABASE_URL = "postgres://postgres:postgres@localhost:5432/solar3d"
```

### Port Already in Use
```powershell
# Find what's using port 8001
netstat -ano | findstr :8001

# Kill it (replace 12345 with actual PID)
taskkill /PID 12345 /F
```

### Connection Refused
**Problem:** Database is not running  
**Fix:**
```powershell
# Check if Docker container is running
docker ps | findstr solar3d-db

# If not, start it
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres --name solar3d-db postgres:15
```

### Rebuild Everything
```powershell
cd e:\Brahma\Solar3d

# Clean old binaries
foreach ($svc in @("project", "terrain", "layout", "simulation", "electrical", "routing", "report", "asset")) {
    Remove-Item "services\$svc-service\bin" -Recurse -Force -ErrorAction SilentlyContinue
}

# Rebuild all
cmd /c build-all.bat
```

## Using Terminal Multiplexer (Easier!)

### Windows Terminal Multiplexer (tmux-like)
```powershell
# Install scoop first if needed
iwr -useb get.scoop.sh | iexEscapetry

# Install tmux
scoop install tmux

# Create session with 8 panes
tmux new-session -d -s solar3d -x 200 -y 50

# Set env in main session
tmux send-keys -t solar3d "$env:DATABASE_URL = \"postgres://postgres:postgres@localhost:5432/solar3d\"" Enter

# Create panes and run services
tmux send-keys -t solar3d "e:\Brahma\Solar3d\services\project-service\bin\project.exe" Enter
tmux split-window -h
tmux send-keys -t solar3d "e:\Brahma\Solar3d\services\terrain-service\bin\terrain.exe" Enter
# ... repeat for each service

# View all panes
tmux attach -t solar3d
```

## Performance Tips

1. **First build takes longer** - Go downloads dependencies
2. **Incremental rebuilds are fast** - Only changed code recompiled
3. **Run services in separate processes** - Easier to manage individually
4. **Use terminal multiplexer** - Manage all 8 terminals in one window
5. **Set up IDE debugging** - VS Code + go extension = full debugging support

## IDE Setup (VS Code)

1. Install Go extension
2. Open workspace in VS Code
3. Go → Run and Debug (Ctrl+Shift+D)
4. Create debug config in `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch project-service",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "program": "${workspaceFolder}/services/project-service",
      "cwd": "${workspaceFolder}/services/project-service",
      "env": {
        "DATABASE_URL": "postgres://postgres:postgres@localhost:5432/solar3d",
        "PORT": "8001"
      }
    }
  ]
}
```

Then press F5 to debug with breakpoints!

## Documentation

- [WINDOWS_BUILD_SUCCESS.md](WINDOWS_BUILD_SUCCESS.md) - Complete build info
- [WINDOWS_NATIVE_BUILD_GUIDE.md](WINDOWS_NATIVE_BUILD_GUIDE.md) - Comprehensive guide
- [WINDOWS_QUICK_START.md](WINDOWS_QUICK_START.md) - Getting started

## Summary

✅ All 8 services compile natively on Windows  
✅ No Docker/Podman required for local development  
✅ Fast builds and IDE-integrated debugging  
✅ Services run on ports 8001-8008  
✅ Communication via gRPC  

**Time to get services running:** ~5 minutes (after database setup)
