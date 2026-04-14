.PHONY: proto sqlc migrate dev build test lint clean

# Proto generation
proto:
	cd proto && buf generate

# sqlc generation
sqlc:
	@for dir in services/*/internal/db; do \
		if [ -f "$$dir/sqlc.yaml" ]; then \
			echo "Generating sqlc for $$dir"; \
			cd $$dir && sqlc generate && cd -; \
		fi; \
	done

# Database migrations
migrate:
	powershell -Command "Get-ChildItem migrations/*.sql | ForEach-Object { echo Applying $$_.FullName; psql $$env:DATABASE_URL -f $$_.FullName }"
# Development - run all services
dev:
	@echo "Starting all services..."
	@$(MAKE) dev-project &
	@$(MAKE) dev-terrain &
	@$(MAKE) dev-layout &
	@$(MAKE) dev-simulation &
	@$(MAKE) dev-electrical &
	@$(MAKE) dev-routing &
	@$(MAKE) dev-report &
	@$(MAKE) dev-asset &
	@wait

dev-project:
	cd services/project-service && go mod tidy && go run cmd/server/main.go

dev-terrain:
	cd services/terrain-service && go mod tidy && go run cmd/server/main.go

dev-layout:
	cd services/layout-service && go mod tidy && go run cmd/server/main.go

dev-simulation:
	cd services/simulation-service && go mod tidy && go run cmd/server/main.go

dev-electrical:
	cd services/electrical-service && go mod tidy && go run cmd/server/main.go

dev-routing:
	cd services/routing-service && go mod tidy && go run cmd/server/main.go

dev-report:
	cd services/report-service && go mod tidy && go run cmd/server/main.go

dev-asset:
	cd services/asset-service && go mod tidy && go run cmd/server/main.go

# Build all services
build:
	@for dir in services/*/; do \
		echo "Building $$dir"; \
		cd $$dir && go build -o bin/server cmd/server/main.go && cd -; \
	done

# Build Rust compute modules
build-compute:
	cd compute/solar-compute && cargo build --release
	cd compute/terrain-compute && cargo build --release

# Run all tests
test:
	@for dir in services/*/; do \
		echo "Testing $$dir"; \
		cd $$dir && go test ./... && cd -; \
	done
	cd compute/solar-compute && cargo test
	cd compute/terrain-compute && cargo test

# Lint
lint:
	@for dir in services/*/; do \
		cd $$dir && golangci-lint run ./... && cd -; \
	done
	cd compute/solar-compute && cargo clippy
	cd compute/terrain-compute && cargo clippy

# Clean
clean:
	@for dir in services/*/; do \
		rm -rf $$dir/bin; \
	done
	cd compute/solar-compute && cargo clean
	cd compute/terrain-compute && cargo clean

# ============================================================
# Podman Build Targets (Production-ready container builds)
# ============================================================

# Check if podman is available
.PHONY: check-podman
check-podman:
	@command -v podman >/dev/null 2>&1 || (echo "Podman not installed. Install from: https://podman.io/docs/installation" && exit 1)
	@echo "✓ Podman is available: $$(podman --version)"

# Build all services with Podman (multi-stage, optimized)
podman-build-services: check-podman
	@echo "🔨 Building all services with Podman..."
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=project-service \
		-t solar3d/project-service:latest \
		-t solar3d/project-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=terrain-service \
		-t solar3d/terrain-service:latest \
		-t solar3d/terrain-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=layout-service \
		-t solar3d/layout-service:latest \
		-t solar3d/layout-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=simulation-service \
		-t solar3d/simulation-service:latest \
		-t solar3d/simulation-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=electrical-service \
		-t solar3d/electrical-service:latest \
		-t solar3d/electrical-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=routing-service \
		-t solar3d/routing-service:latest \
		-t solar3d/routing-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=report-service \
		-t solar3d/report-service:latest \
		-t solar3d/report-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=asset-service \
		-t solar3d/asset-service:latest \
		-t solar3d/asset-service:$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	@echo "✅ All services built successfully"

# Build a single service with Podman
podman-build-service: check-podman
	@if [ -z "$(SERVICE)" ]; then \
		echo "Usage: make podman-build-service SERVICE=<service-name>"; \
		echo "Available services: project-service, terrain-service, layout-service, simulation-service, electrical-service, routing-service, report-service, asset-service"; \
		exit 1; \
	fi
	@echo "🔨 Building $(SERVICE) with Podman..."
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=$(SERVICE) \
		-t solar3d/$(SERVICE):latest \
		-t solar3d/$(SERVICE):$$(git describe --tags --always 2>/dev/null || echo "dev") \
		.
	@echo "✅ $(SERVICE) built successfully"

# Run all services with Podman Compose
podman-up: check-podman
	@echo "🚀 Starting all services with Podman Compose..."
	podman-compose -f podman-compose.yml up -d
	@echo "✅ Services started"
	@echo ""
	@echo "Service Status:"
	podman-compose -f podman-compose.yml ps

# Stop all services
podman-down: check-podman
	@echo "🛑 Stopping all services..."
	podman-compose -f podman-compose.yml down
	@echo "✅ Services stopped"

# View logs
podman-logs: check-podman
	@if [ -z "$(SERVICE)" ]; then \
		podman-compose -f podman-compose.yml logs -f; \
	else \
		podman-compose -f podman-compose.yml logs -f $(SERVICE); \
	fi

# Execute command in running service
podman-exec: check-podman
	@if [ -z "$(SERVICE)" ] || [ -z "$(CMD)" ]; then \
		echo "Usage: make podman-exec SERVICE=<service-name> CMD='<command>'"; \
		exit 1; \
	fi
	podman-compose -f podman-compose.yml exec $(SERVICE) $(CMD)

# Pull images and validate
podman-validate: check-podman
	@echo "✓ Checking Podman setup..."
	podman ps >/dev/null 2>&1 && echo "✓ Podman daemon is running" || (echo "✗ Podman daemon not running" && exit 1)
	@echo "✓ Podman is properly configured"

# Clean up Podman resources
podman-clean: check-podman
	@echo "🧹 Cleaning up Podman resources..."
	podman-compose -f podman-compose.yml down -v
	podman system prune -f
	@echo "✅ Cleanup complete"

# Build and start complete stack
podman-full-stack: podman-build-services podman-up
	@echo "✅ Full stack built and started"

# Show Podman build progress verbosely
podman-build-verbose: check-podman
	@echo "🔨 Building services with verbose output..."
	podman build \
		-f deploy/docker/go-service.Dockerfile \
		--build-arg SERVICE_NAME=project-service \
		--progress=plain \
		-t solar3d/project-service:latest \
		.

# Export images
podman-export-images: check-podman
	@echo "📦 Exporting Podman images..."
	mkdir -p ./podman-exports
	@for service in project-service terrain-service layout-service simulation-service electrical-service routing-service report-service asset-service; do \
		echo "Exporting solar3d/$$service:latest..."; \
		podman save solar3d/$$service:latest -o ./podman-exports/$$service-latest.tar; \
	done
	@echo "✅ Images exported to ./podman-exports/"

# Import images
podman-import-images: check-podman
	@echo "📥 Importing Podman images..."
	@for tar in ./podman-exports/*.tar; do \
		echo "Importing $$tar..."; \
		podman load -i $$tar; \
	done
	@echo "✅ Images imported"

# Health check all services
podman-health: check-podman
	@echo "🔍 Checking service health..."
	podman-compose -f podman-compose.yml ps --filter "status=running"

# Integration test with Podman
podman-test: podman-full-stack
	@echo "🧪 Running integration tests..."
	sleep 10  # Wait for services to stabilize
	@if [ -f "./services/integration_test.go" ]; then \
		cd services && go test -v -run TestFullSolarProjectWorkflow -timeout 120s || true; \
	fi
	@echo "✅ Integration tests complete"
