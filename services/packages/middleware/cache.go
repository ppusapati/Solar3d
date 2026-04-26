package middleware

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/redis/go-redis/v9"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/proto"
)

// CacheMiddleware implements caching for RPC calls
type CacheMiddleware struct {
	client *redis.Client
	ttl    time.Duration
}

// NewCacheMiddleware creates a new cache middleware
func NewCacheMiddleware(redisURL string, ttl time.Duration) (*CacheMiddleware, error) {
	opts, err := redis.ParseURL(redisURL)
	if err != nil {
		return nil, err
	}

	client := redis.NewClient(opts)
	if err := client.Ping(context.Background()).Err(); err != nil {
		return nil, err
	}

	return &CacheMiddleware{
		client: client,
		ttl:    ttl,
	}, nil
}

// UnaryInterceptor returns a unary RPC interceptor that caches successful
// responses for read-only methods. Cache hits skip the network call entirely;
// cache misses go to the wire and the response is stored for next time.
//
// The cache uses protobuf wire-format serialization, which means both `req`
// and `reply` must be `proto.Message`. Non-proto requests bypass the cache
// gracefully — caching is best-effort, not a correctness boundary.
func (c *CacheMiddleware) UnaryInterceptor() grpc.UnaryClientInterceptor {
	return func(ctx context.Context, method string, req, reply interface{}, cc *grpc.ClientConn,
		invoker grpc.UnaryInvoker, opts ...grpc.CallOption) error {

		if !isReadOperation(method) {
			return invoker(ctx, method, req, reply, cc, opts...)
		}

		reqMsg, reqOK := req.(proto.Message)
		replyMsg, replyOK := reply.(proto.Message)
		if !reqOK || !replyOK {
			// Non-proto types — fall through without caching to keep
			// behaviour identical to a no-op interceptor.
			return invoker(ctx, method, req, reply, cc, opts...)
		}

		cacheKey, err := generateCacheKey(method, reqMsg)
		if err != nil {
			return invoker(ctx, method, req, reply, cc, opts...)
		}

		if cached, err := c.client.Get(ctx, cacheKey).Bytes(); err == nil {
			if unmarshalErr := proto.Unmarshal(cached, replyMsg); unmarshalErr == nil {
				return nil
			}
			// Corrupted cache entry — drop it and fall through to live call.
			_ = c.client.Del(ctx, cacheKey).Err()
		} else if !errors.Is(err, redis.Nil) {
			// Redis is having a bad day; do not fail the RPC because of it.
			// Fall through to live call.
		}

		if err := invoker(ctx, method, req, reply, cc, opts...); err != nil {
			return err
		}

		// Best-effort cache write. We deliberately ignore Set errors so a
		// failing cache never breaks the request path.
		if encoded, err := proto.Marshal(replyMsg); err == nil {
			_ = c.client.Set(ctx, cacheKey, encoded, c.ttl).Err()
		}
		return nil
	}
}

// generateCacheKey creates a stable, collision-resistant cache key from the
// method name and the wire-format bytes of the request. Deterministic
// marshalling ensures equivalent requests hash to the same key across runs.
func generateCacheKey(method string, req proto.Message) (string, error) {
	encoded, err := proto.MarshalOptions{Deterministic: true}.Marshal(req)
	if err != nil {
		return "", fmt.Errorf("cache key marshal: %w", err)
	}
	sum := sha256.Sum256(encoded)
	return "rpc:" + method + ":" + hex.EncodeToString(sum[:]), nil
}

// isReadOperation determines if a fully-qualified gRPC method
// (e.g. "/solar3d.project.v1.ProjectService/GetProject") is read-only.
// We strip the package/service prefix and check whether the method name
// begins with a known read verb.
func isReadOperation(method string) bool {
	readPrefixes := []string{"Get", "List", "Describe", "Search", "Read", "Query", "Lookup"}
	name := method
	if idx := strings.LastIndex(name, "/"); idx >= 0 {
		name = name[idx+1:]
	}
	for _, p := range readPrefixes {
		if strings.HasPrefix(name, p) {
			return true
		}
	}
	return false
}

// InvalidateCache clears cache for a service
func (c *CacheMiddleware) InvalidateCache(ctx context.Context, servicePattern string) error {
	iter := c.client.Scan(ctx, 0, fmt.Sprintf("rpc:%s:*", servicePattern), 0).Iterator()
	for iter.Next(ctx) {
		if err := c.client.Del(ctx, iter.Val()).Err(); err != nil {
			return err
		}
	}
	return iter.Err()
}

// Close closes the cache connection
func (c *CacheMiddleware) Close() error {
	return c.client.Close()
}

// CacheStats returns parsed Redis stats (counter name → value as string).
// Useful for emitting hit/miss metrics from a sidecar exporter.
func (c *CacheMiddleware) CacheStats(ctx context.Context) (map[string]string, error) {
	info, err := c.client.Info(ctx, "stats").Result()
	if err != nil {
		return nil, err
	}
	out := make(map[string]string)
	for _, line := range strings.Split(info, "\r\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		if k, v, ok := strings.Cut(line, ":"); ok {
			out[k] = v
		}
	}
	return out, nil
}
