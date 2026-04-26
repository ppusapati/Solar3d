package redis

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
)

// ErrCacheMiss is returned by TTLCache.GetJSON when the key is absent.
// Callers should treat this as a normal cache miss, not a failure.
var ErrCacheMiss = errors.New("cache: miss")

// TTLCache is a thin JSON-over-Redis wrapper used by Solar3D services to cache
// read-mostly derived data with a TTL. It degrades gracefully to a no-op when
// constructed with a nil client (i.e. REDIS_URL was empty), so code paths
// calling SetJSON/GetJSON don't need to check whether caching is available.
type TTLCache struct {
	client *redis.Client
	prefix string
}

// NewTTLCache wraps a redis.Client. prefix is prepended to every key (include
// a trailing colon, e.g. "projects:"). A nil client yields a no-op cache.
func NewTTLCache(client *redis.Client, prefix string) *TTLCache {
	return &TTLCache{client: client, prefix: prefix}
}

// SetJSON marshals v as JSON and stores it at prefix+key for ttl.
// No-op (nil error) if the cache was constructed without a client.
func (c *TTLCache) SetJSON(ctx context.Context, key string, v any, ttl time.Duration) error {
	if c == nil || c.client == nil {
		return nil
	}
	buf, err := json.Marshal(v)
	if err != nil {
		return fmt.Errorf("cache: marshal: %w", err)
	}
	if err := c.client.Set(ctx, c.prefix+key, buf, ttl).Err(); err != nil {
		return fmt.Errorf("cache: set: %w", err)
	}
	return nil
}

// GetJSON decodes the JSON stored at prefix+key into dst. Returns ErrCacheMiss
// if the key is absent, or if the cache has no underlying client (no-op mode).
func (c *TTLCache) GetJSON(ctx context.Context, key string, dst any) error {
	if c == nil || c.client == nil {
		return ErrCacheMiss
	}
	raw, err := c.client.Get(ctx, c.prefix+key).Bytes()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return ErrCacheMiss
		}
		return fmt.Errorf("cache: get: %w", err)
	}
	if err := json.Unmarshal(raw, dst); err != nil {
		return fmt.Errorf("cache: unmarshal: %w", err)
	}
	return nil
}

// Delete removes prefix+key. No-op if the cache has no underlying client.
func (c *TTLCache) Delete(ctx context.Context, key string) error {
	if c == nil || c.client == nil {
		return nil
	}
	if err := c.client.Del(ctx, c.prefix+key).Err(); err != nil {
		return fmt.Errorf("cache: del: %w", err)
	}
	return nil
}
