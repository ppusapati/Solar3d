package main

import (
	"context"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	grpchealth "google.golang.org/grpc/health/grpc_health_v1"

	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/client"
	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/handler"
	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/service"
	"p9e.in/samavaya/packages/httpmiddleware"
)

const (
	shutdownTimeout = 30 * time.Second
	healthTimeout   = 10 * time.Second
)

var (
	geoHTTPRequestsTotal = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "geo_analytics_service_http_requests_total",
			Help: "Total number of HTTP requests handled by geo-analytics-service.",
		},
		[]string{"method", "route", "status"},
	)
	geoHTTPRequestDurationSeconds = prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "geo_analytics_service_http_request_duration_seconds",
			Help:    "HTTP request duration in seconds for geo-analytics-service.",
			Buckets: prometheus.DefBuckets,
		},
		[]string{"method", "route", "status"},
	)
)

func init() {
	prometheus.MustRegister(geoHTTPRequestsTotal, geoHTTPRequestDurationSeconds)
}

func main() {
	// Load configuration from environment variables
	rustBridgeURL := os.Getenv("GEO_COMPUTE_URL")
	if rustBridgeURL == "" {
		rustBridgeURL = "http://localhost:8001"
	}

	grpcPort := os.Getenv("GEO_SERVICE_PORT")
	if grpcPort == "" {
		grpcPort = ":50060"
	}

	httpPort := os.Getenv("GEO_SERVICE_HTTP_PORT")
	if httpPort == "" {
		httpPort = ":8060"
	}

	logLevel := os.Getenv("LOG_LEVEL")
	if logLevel == "" {
		logLevel = "info"
	}

	log.Printf("════════════════════════════════════════════")
	log.Printf("Geo-Analytics Service v1.0")
	log.Printf("════════════════════════════════════════════")
	log.Printf("Configuration:")
	log.Printf("  Rust bridge URL: %s", rustBridgeURL)
	log.Printf("  gRPC port: %s", grpcPort)
	log.Printf("  HTTP port: %s", httpPort)
	log.Printf("  Log level: %s", logLevel)

	// Create context for initialization
	ctx, cancel := context.WithTimeout(context.Background(), healthTimeout)
	defer cancel()

	// Create Rust compute client
	rustClient := client.NewGeoComputeClient(rustBridgeURL)

	// Health check Rust bridge with retry logic
	log.Println("Checking Rust bridge health...")
	var lastErr error
	for attempts := 0; attempts < 3; attempts++ {
		if err := rustClient.Health(ctx); err == nil {
			log.Println("✓ Rust bridge is healthy")
			break
		} else {
			lastErr = err
			log.Printf("  Attempt %d/3: bridge check failed - %v", attempts+1, err)
			if attempts < 2 {
				time.Sleep(time.Second)
			}
		}
	}
	if lastErr != nil {
		log.Printf("WARNING: Could not reach Rust bridge. Service will be degraded. Error: %v", lastErr)
	}

	// Create service layer
	svc := service.New(rustClient)

	// Create handler layer
	h := handler.New(svc)

	// Setup graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	// Create HTTP server
	httpServer := &http.Server{
		Addr:              httpPort,
		Handler:           instrumentHTTP(createHTTPMux(h), geoHTTPRequestsTotal, geoHTTPRequestDurationSeconds),
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       10 * time.Second,
		WriteTimeout:      10 * time.Second,
	}

	// Create gRPC server
	grpcServer := grpc.NewServer(
		grpc.ChainUnaryInterceptor(unaryServerLoggingInterceptor()),
	)
	healthServer := health.NewServer()
	grpchealth.RegisterHealthServer(grpcServer, healthServer)
	healthServer.SetServingStatus("geoanalytics.v1.GeoAnalyticsService", grpchealth.HealthCheckResponse_SERVING)

	// Start servers in goroutines
	go func() {
		log.Printf("HTTP server listening on %s", httpPort)
		if err := httpServer.ListenAndServe(); err != http.ErrServerClosed {
			log.Fatalf("HTTP server error: %v", err)
		}
	}()

	go func() {
		lis, err := net.Listen("tcp", grpcPort)
		if err != nil {
			log.Fatalf("Failed to listen on %s: %v", grpcPort, err)
		}
		log.Printf("gRPC server listening on %s", grpcPort)
		if err := grpcServer.Serve(lis); err != nil {
			log.Fatalf("gRPC server error: %v", err)
		}
	}()

	log.Printf("✓ Geo-Analytics Service is RUNNING")
	log.Printf("════════════════════════════════════════════")

	// Wait for shutdown signal
	sig := <-sigChan
	log.Printf("\nReceived signal: %v", sig)
	log.Println("Initiating graceful shutdown...")

	// Stop accepting new connections
	grpcServer.GracefulStop()

	// Shutdown HTTP server with timeout
	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer shutdownCancel()

	if err := httpServer.Shutdown(shutdownCtx); err != nil {
		log.Printf("HTTP server shutdown error: %v", err)
	}

	log.Println("✓ Geo-Analytics Service stopped gracefully")
}

// createHTTPMux creates the HTTP multiplexer with all routes
func createHTTPMux(h *handler.Handler) *http.ServeMux {
	mux := http.NewServeMux()

	// Health check endpoint
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
		defer cancel()
		err := h.Health(ctx)
		if err != nil {
			middleware.WriteError(w, http.StatusServiceUnavailable, "Service unhealthy", err.Error())
			return
		}
		middleware.WriteSuccess(w, http.StatusOK, map[string]string{"status": "ok"})
	})

	// Ready check endpoint
	mux.HandleFunc("GET /ready", func(w http.ResponseWriter, r *http.Request) {
		middleware.WriteSuccess(w, http.StatusOK, map[string]bool{"ready": true})
	})

	mux.Handle("GET /metrics", promhttp.Handler())

	// Register all REST API routes
	h.RegisterHTTPRoutes(mux)

	return mux
}

type statusRecorder struct {
	http.ResponseWriter
	status int
}

func (sr *statusRecorder) WriteHeader(code int) {
	sr.status = code
	sr.ResponseWriter.WriteHeader(code)
}

func instrumentHTTP(next http.Handler, counter *prometheus.CounterVec, duration *prometheus.HistogramVec) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		rec := &statusRecorder{ResponseWriter: w, status: http.StatusOK}
		next.ServeHTTP(rec, r)

		route := r.Pattern
		if route == "" {
			route = r.URL.Path
		}
		status := http.StatusText(rec.status)
		counter.WithLabelValues(r.Method, route, status).Inc()
		duration.WithLabelValues(r.Method, route, status).Observe(time.Since(start).Seconds())
	})
}

// unaryServerLoggingInterceptor is a simple unary server interceptor for logging
func unaryServerLoggingInterceptor() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
		start := time.Now()
		resp, err := handler(ctx, req)
		duration := time.Since(start)

		if err != nil {
			log.Printf("[GRPC] %s failed in %v: %v", info.FullMethod, duration, err)
		} else {
			log.Printf("[GRPC] %s succeeded in %v", info.FullMethod, duration)
		}

		return resp, err
	}
}
