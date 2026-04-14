# Quick Start: Building Solar3D Natively on Windows

## 1. Verify Go Installation (30 seconds)

```powershell
go version
gcc --version
```

You already have:
- ✅ Go 1.26.1
- ✅ gcc 10.3.0

## 2. First Build (2-3 minutes)

```powershell
# Navigate to project root
cd e:\Brahma\Solar3d

# Build all 8 services
./build-win.ps1 -Command build-all
```

This will:
1. Download dependencies (~200MB first time)
2. Compile all services
3. Output binaries to `services/*/bin/`

## 3. Run a Service (Immediate)

```powershell
# Start project-service on port 8001
./build-win.ps1 -Command run -Service project

# Output:
# Running project-service on port 8001...
# (logs appear here)
```

Keep this terminal open. Open another terminal for:

## 4. Test the Service

```powershell
# In a new terminal
curl http://localhost:8001/health

# Should return:
# {"status":"healthy"}
```

## 5. Development Mode (Optional)

For faster feedback during development:

```powershell
# Install live reload tool (one-time)
go install github.com/cosmtrek/air@latest

# Start with live reload
./build-win.ps1 -Command dev -Service terrain

# Now edit services/terrain-service/**/*.go and save
# It will automatically rebuild and restart!
```

## Common Commands

```powershell
# Build all services
./build-win.ps1 -Command build-all

# Build one service
./build-win.ps1 -Command build -Service project

# Run a service
./build-win.ps1 -Command run -Service terrain

# Development with auto-reload
./build-win.ps1 -Command dev -Service layout

# Run tests
./build-win.ps1 -Command test -Service electrical

# Clean build artifacts
./build-win.ps1 -Command clean
```

## Service Ports

| Service | Port |
|---------|------|
| project-service | 8001 |
| terrain-service | 8002 |
| layout-service | 8003 |
| simulation-service | 8004 |
| electrical-service | 8005 |
| routing-service | 8006 |
| report-service | 8007 |
| asset-service | 8008 |

## Running Multiple Services

Open multiple terminals:

```powershell
# Terminal 1
./build-win.ps1 -Command run -Service project

# Terminal 2
./build-win.ps1 -Command run -Service terrain

# Terminal 3
./build-win.ps1 -Command run -Service layout

# ... etc
```

All services will communicate via gRPC on ports 8001-8008.

## Next: Database Setup

To run full integration tests, you'll need PostgreSQL:

```powershell
# Option 1: Use Docker
docker run -d -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:15

# Option 2: Use Podman (if working)
podman run -d -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:15

# Option 3: Install PostgreSQL natively
# Download from https://www.postgresql.org/download/windows/
```

Then set the database URL in your environment:

```powershell
$env:DATABASE_URL = "postgres://postgres:postgres@localhost:5432/solar3d"
./build-win.ps1 -Command run -Service project
```

## Check Status

```powershell
# See all available services
./build-win.ps1 -Command list

# Test all services built successfully
./build-win.ps1 -Command build-all
```

---

**That's it!** You now have:
- ✅ Native Windows builds (no containers needed)
- ✅ Fast compilation and reload
- ✅ Easy debugging with IDE integration
- ✅ Full control over 8 microservices

For more details, see [WINDOWS_NATIVE_BUILD_GUIDE.md](WINDOWS_NATIVE_BUILD_GUIDE.md).
