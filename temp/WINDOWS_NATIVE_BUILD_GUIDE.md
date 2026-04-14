# Solar3D Windows Native Build Guide

## Overview

This guide explains how to build and run Solar3D services **natively on Windows** without Docker or Podman. This approach is:

- **Faster** - No container overhead, instant builds
- **Easier** - Direct debugging and IDE integration
- **Better for development** - Live reload, hot restart capability
- **Works everywhere** - No WSL/Podman/Docker required

## Prerequisites

### Required
- **Windows 10/11**
- **Go 1.21+** (check with `go version`)
- **gcc** (comes with Go on Windows)
- **Git** (for module dependencies)

### Verify Installation

```powershell
# Open terminal and check:
go version
gcc --version
git --version
```

You already have everything installed:
- Go 1.26.1
- gcc 10.3.0

### Optional
- **air** - For live reload during development
  ```powershell
  go install github.com/cosmtrek/air@latest
  ```

## Quick Start

### Build All Services

```powershell
# Using PowerShell script (recommended)
PS> ./build-win.ps1 -Command build-all

# Or using batch script
C:\> build-win.bat build-all
```

Output will show:
```
╔═══════════════════════════════════════════╗
║      Building All Services (Windows)      ║
╚═══════════════════════════════════════════╝

[*] Building project-service...
[*]   Tidying dependencies...
[*]   Compiling...
[✓] project-service built successfully (45.23MB)
  Location: services/project-service/bin/project.exe

... (builds 7 more services) ...

[✓] All services built successfully!
```

### Build Single Service

```powershell
# PowerShell
./build-win.ps1 -Command build -Service project   # short form
./build-win.ps1 -Command build -Service project-service  # full form

# Batch
build-win.bat build project-service
```

### Run a Service

```powershell
# PowerShell - builds, then runs on default port
./build-win.ps1 -Command run -Service terrain

# Service will output something like:
# ╔═══════════════════════════════════════════╗
# ║    Running terrain-service on port 8002   ║
# ╚═══════════════════════════════════════════╝
# 
# [*] Press Ctrl+C to stop
# Starting server on :8002...
```

### Development with Live Reload

Automatically rebuild when you change Go files:

```powershell
# Install air if not already installed
go install github.com/cosmtrek/air@latest

# Start watching
./build-win.ps1 -Command dev -Service layout

# Output:
# ╔═════════════════════════════════════════════╗
# ║   Dev watching layout-service on port 8003  ║
# ╚═════════════════════════════════════════════╝
# 
# [*] Changes to Go files will trigger rebuild
# [*] Press Ctrl+C to stop
#
# air (processes running)
```

Now edit any `.go` file in `services/layout-service/`, save, and it will:
1. Detect the change
2. Recompile
3. Restart the service
4. Show output

Perfect for rapid development!

## Service Ports

| Service | Port | Purpose |
|---------|------|---------|
| project-service | 8001 | Project management |
| terrain-service | 8002 | Terrain generation |
| layout-service | 8003 | Solar farm layout |
| simulation-service | 8004 | Energy simulation |
| electrical-service | 8005 | Electrical calculations |
| routing-service | 8006 | Wire routing |
| report-service | 8007 | Report generation |
| asset-service | 8008 | Asset management |

## PowerShell Script Reference

### Setup (First Time Only)

```powershell
# If you get execution policy error:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then run:
./build-win.ps1 -Command list
```

### Commands

```powershell
# Build all services
./build-win.ps1 -Command build-all

# Build specific service
./build-win.ps1 -Command build -Service project
./build-win.ps1 -Command build -Service terrain
./build-win.ps1 -Command build -Service layout

# Run service (builds + runs)
./build-win.ps1 -Command run -Service project

# Development mode (auto-rebuild on file changes, requires 'air')
./build-win.ps1 -Command dev -Service terrain

# Run tests
./build-win.ps1 -Command test -Service electrical

# List all services
./build-win.ps1 -Command list

# Clean all build artifacts
./build-win.ps1 -Command clean
```

## Batch Script Reference

If you prefer Command Prompt (`.bat` file):

```cmd
# Build all services
build-win.bat build-all

# Build specific service
build-win.bat build project-service
build-win.bat build terrain-service

# Run service
build-win.bat run project-service

# Development mode
build-win.bat dev layout-service

# Clean
build-win.bat clean
```

## Manual Build (Without Scripts)

If you prefer manual control:

```powershell
cd services/project-service
go mod tidy                                    # Download dependencies
go build -o bin/project.exe ./cmd/server/main.go  # Compile
.\bin\project.exe                              # Run
```

## Testing

### Run Tests for Service

```powershell
./build-win.ps1 -Command test -Service electrical

# Output:
# [*] Running tests for electrical-service...
# === RUN   TestCalculateLoad
# --- PASS: TestCalculateLoad (0.01s)
# === RUN   TestValidateCircuit
# --- PASS: TestValidateCircuit (0.05s)
# ...
# [✓] Tests passed for electrical-service
#   coverage: 87.3% of statements
```

### Manual Testing

```powershell
cd services/project-service
go test -v ./...                           # Verbose
go test -cover ./...                       # With coverage
go test -coverprofile=coverage.out ./...  # Generate coverage file
go tool cover -html=coverage.out           # View in browser
```

## Debugging

### IDE Integration

All major editors work with these native builds:

**VS Code:**
```json
// .vscode/launch.json
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
      "args": []
    }
  ]
}
```

Then press `F5` to debug with breakpoints, watches, etc.

**Visual Studio / Rider:** Similar Go debugging support.

### Command Line Debugging

```powershell
cd services/project-service

# Compile with debug info
go build -gcflags="all=-N -l" -o bin/project-debug.exe ./cmd/server/main.go

# Run with debugger (requires Delve)
go install github.com/go-delve/delve/cmd/dlv@latest
dlv exec .\bin\project-debug.exe
```

## Environment Variables

Customize behavior with environment variables:

```powershell
# Set logging level (service-specific)
$env:LOG_LEVEL = "DEBUG"

# Set port (override default)
$env:PORT = "9001"

# Set database URL
$env:DATABASE_URL = "postgres://user:pass@localhost:5432/solar3d"

# Then run:
./build-win.ps1 -Command run -Service project
```

Or in `.env` file (if services support):

```
LOG_LEVEL=DEBUG
PORT=8001
DATABASE_URL=postgres://user:pass@localhost:5432/solar3d
DATABASE_SSL=false
```

## Troubleshooting

### Build Fails with "Module not found"

```
go: solar3d/shared: no matching versions for query "@v0.0.0"
```

**Solution:**
```powershell
go mod tidy        # Update go.mod
go mod download    # Pre-fetch all modules
```

### Port Already in Use

```
Error: listen tcp :8001: bind: Only one usage of each socket address
```

**Solution:**
```powershell
# Find process on port 8001
netstat -ano | findstr :8001

# Kill the process (replace PID)
taskkill /PID 12345 /F

# Then try again
./build-win.ps1 -Command run -Service project
```

### gcc Not Found

```
The program 'gcc' could not be found
```

**Solution:**
1. Go typically includes gcc
2. Reinstall Go: https://go.dev/dl/
3. Ensure it's in PATH: `gcc --version`

### Script Execution Disabled

```
PowerShell: File cannot be loaded because running scripts is disabled
```

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Building Full Stack

To run all services simultaneously:

```powershell
# Terminal 1
./build-win.ps1 -Command run -Service project-service

# Terminal 2
./build-win.ps1 -Command run -Service terrain-service

# Terminal 3
./build-win.ps1 -Command run -Service layout-service

# ... continue for other services
# Or use multi-terminal IDE feature (VS Code, Terminal multiplexer, etc.)
```

Services will start on ports 8001-8008 and communicate via gRPC/HTTP.

## Performance Tips

1. **First build is slowest** - Go downloads and caches dependencies
2. **Subsequent builds are faster** - Dependencies cached
3. **Live reload (air) is fastest** - Only recompiles changed files
4. **Use dev mode during development** - See instant feedback
5. **Parallel builds on CI** - make build-all parallelizes naturally

Typical times:
- Full build (first): 30-45 seconds
- Incremental rebuild: 2-5 seconds
- Live reload rebuild: 1-3 seconds

## Next Steps

1. **Build one service:**
   ```powershell
   ./build-win.ps1 -Command build -Service project
   ```

2. **Run it:**
   ```powershell
   ./build-win.ps1 -Command run -Service project
   ```

3. **Test it:**
   ```powershell
   curl http://localhost:8001/health
   ```

4. **Develop with live reload:**
   ```powershell
   ./build-win.ps1 -Command dev -Service project
   ```

5. **Set up database and other services** as needed for full integration testing

## Additional Resources

- [Go Official Documentation](https://golang.org/doc/)
- [Go Build Command Reference](https://pkg.go.dev/cmd/go)
- [Air Live Reload](https://github.com/cosmtrek/air)
- [gRPC Go](https://grpc.io/docs/languages/go/)

## FAQ

**Q: Why not use containers?**
A: Containers are great for production deployment but add overhead for local development. Native builds are faster and simpler for developers.

**Q: Can I still use containers later?**
A: Yes! The Dockerfile and compose files we created earlier still work. This native build approach is just for development.

**Q: How do I deploy with containers?**
A: Use the corrected `docker-compose.yml` or `podman-compose.yml` files for deployment.

**Q: What about the database?**
A: For full integration testing, you'll need PostgreSQL running. Either:
- Use Docker: `docker run -d -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres`
- Install PostgreSQL natively
- Update DATABASE_URL environment variable to point to it

**Q: Can I mix native and container builds?**
A: Yes! This is actually recommended for development. Run services natively and use containers for dependencies (PostgreSQL, MinIO, etc.).

---

**Last Updated:** 2024
**Go Version:** 1.26.1+
**Tested On:** Windows 10/11, Go 1.21+
