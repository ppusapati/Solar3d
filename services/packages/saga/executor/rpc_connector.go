// Package executor provides RPC communication for saga steps
package executor

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"

	"p9e.in/samavaya/packages/saga"
)

// RpcConnectorImpl implements an HTTP/JSON saga RPC connector compatible
// with both ConnectRPC handlers and bare net/http JSON endpoints. The default
// transport is `http.DefaultClient` with a 30-second timeout; callers may
// override it via `SetHTTPClient` for mTLS or service-mesh integration.
//
// Endpoints are registered as base URLs (e.g. "https://layout-svc.internal").
// At invoke time the connector composes a path of the form
// `<baseURL>/<HandlerMethod>`, where `HandlerMethod` is the fully qualified
// procedure (e.g. "solar3d.layout.v1.LayoutService/CreateLayout") so a single
// connector can serve any number of methods on a service.
type RpcConnectorImpl struct {
	mu              sync.RWMutex
	serviceRegistry map[string]string // serviceName -> endpoint base URL
	httpClient      *http.Client
}

// NewRpcConnectorImpl creates a new RPC connector instance.
func NewRpcConnectorImpl() *RpcConnectorImpl {
	return &RpcConnectorImpl{
		serviceRegistry: make(map[string]string),
		httpClient:      &http.Client{Timeout: 30 * time.Second},
	}
}

// SetHTTPClient overrides the default HTTP client. Useful for tests and for
// production deployments that need mTLS, custom transport, or a sidecar.
func (r *RpcConnectorImpl) SetHTTPClient(client *http.Client) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if client != nil {
		r.httpClient = client
	}
}

// InvokeHandler POSTs the request as JSON to `<endpoint>/<handlerMethod>`,
// matching the wire format ConnectRPC uses for unary calls (`Content-Type:
// application/json`). The decoded response body is returned as
// `map[string]interface{}`; sagas treat the response as opaque and persist it
// for compensation handlers to consult.
func (r *RpcConnectorImpl) InvokeHandler(
	ctx context.Context,
	endpoint string,
	handlerMethod string,
	request interface{},
) (interface{}, error) {
	if endpoint == "" {
		return nil, fmt.Errorf("endpoint cannot be empty")
	}
	if handlerMethod == "" {
		return nil, fmt.Errorf("handler method cannot be empty")
	}

	r.mu.RLock()
	client := r.httpClient
	r.mu.RUnlock()

	url := strings.TrimRight(endpoint, "/") + "/" + strings.TrimLeft(handlerMethod, "/")

	body, err := json.Marshal(request)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("build request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("RPC call failed: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("RPC %s returned %d: %s", handlerMethod, resp.StatusCode, truncate(string(respBody), 512))
	}

	if len(respBody) == 0 {
		return map[string]interface{}{}, nil
	}

	var decoded interface{}
	if err := json.Unmarshal(respBody, &decoded); err != nil {
		return nil, fmt.Errorf("decode response: %w (body: %s)", err, truncate(string(respBody), 256))
	}
	return decoded, nil
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n] + "…"
}

// GetServiceEndpoint resolves a service endpoint from registry
func (r *RpcConnectorImpl) GetServiceEndpoint(serviceName string) (string, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	// 1. Look up service in registry
	endpoint, exists := r.serviceRegistry[serviceName]
	if !exists {
		return "", fmt.Errorf("service %s not registered in endpoint registry", serviceName)
	}

	// 2. Return endpoint
	return endpoint, nil
}

// RegisterService registers a service endpoint
func (r *RpcConnectorImpl) RegisterService(serviceName string, endpoint string) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	// 1. Validate inputs
	if serviceName == "" {
		return fmt.Errorf("service name cannot be empty")
	}
	if endpoint == "" {
		return fmt.Errorf("endpoint cannot be empty")
	}

	// 2. Check if already registered
	if existing, exists := r.serviceRegistry[serviceName]; exists {
		if existing != endpoint {
			return fmt.Errorf("service %s already registered with different endpoint: %s", serviceName, existing)
		}
		return nil // Already registered with same endpoint
	}

	// 3. Register service
	r.serviceRegistry[serviceName] = endpoint

	return nil
}

// GetRegisteredServices returns all registered services (for debugging/testing)
func (r *RpcConnectorImpl) GetRegisteredServices() map[string]string {
	r.mu.RLock()
	defer r.mu.RUnlock()

	result := make(map[string]string)
	for k, v := range r.serviceRegistry {
		result[k] = v
	}
	return result
}

// Compile-time guarantee that RpcConnectorImpl implements the saga.RpcConnector
// contract used by step_executor.go.
var _ saga.RpcConnector = (*RpcConnectorImpl)(nil)
