package redis

import (
	"context"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
)

// NewClientFromURL opens a Redis client from a redis:// URL.
// Solar3D services load REDIS_URL from env; unlike ProvideRedisClient which
// expects a structured config.Data, this variant accepts the raw URL string.
//
// The returned cleanup func closes the client and is safe to call from defer.
// A Ping is performed with a 2s timeout to verify the connection.
//
// A blank url returns a nil client + no-op cleanup + nil error so services can
// run without Redis. Callers must check for nil before using the client (or use
// a TTLCache wrapper which handles the nil case).
func NewClientFromURL(ctx context.Context, url string) (*redis.Client, func(), error) {
	if url == "" {
		return nil, func() {}, nil
	}

	opts, err := redis.ParseURL(url)
	if err != nil {
		return nil, nil, fmt.Errorf("redis: parse url: %w", err)
	}

	client := redis.NewClient(opts)

	pingCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()
	if err := client.Ping(pingCtx).Err(); err != nil {
		_ = client.Close()
		return nil, nil, fmt.Errorf("redis: ping: %w", err)
	}

	cleanup := func() { _ = client.Close() }
	return client, cleanup, nil
}
