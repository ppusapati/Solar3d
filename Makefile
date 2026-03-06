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
	@for f in migrations/*.sql; do \
		echo "Applying $$f"; \
		psql "$$DATABASE_URL" -f "$$f"; \
	done

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
	cd services/project-service && go run cmd/server/main.go

dev-terrain:
	cd services/terrain-service && go run cmd/server/main.go

dev-layout:
	cd services/layout-service && go run cmd/server/main.go

dev-simulation:
	cd services/simulation-service && go run cmd/server/main.go

dev-electrical:
	cd services/electrical-service && go run cmd/server/main.go

dev-routing:
	cd services/routing-service && go run cmd/server/main.go

dev-report:
	cd services/report-service && go run cmd/server/main.go

dev-asset:
	cd services/asset-service && go run cmd/server/main.go

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
