package pgxpostgres

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

// PoolOptions controls the pgx connection pool sizing + lifetime.
// Defaults match the Solar3D standard from ROADMAP_TO_COMPLETE.md §0.6:
//
//	MaxConns=20, MinConns=4, MaxConnLifetime=30m, MaxConnIdleTime=5m.
type PoolOptions struct {
	MaxConns        int32
	MinConns        int32
	MaxConnLifetime time.Duration
	MaxConnIdleTime time.Duration
}

// DefaultPoolOptions returns the standard pool sizing used across all Solar3D services.
func DefaultPoolOptions() PoolOptions {
	return PoolOptions{
		MaxConns:        20,
		MinConns:        4,
		MaxConnLifetime: 30 * time.Minute,
		MaxConnIdleTime: 5 * time.Minute,
	}
}

// NewPgxFromDSN opens a pgxpool from a libpq-style DSN (or postgres:// URL).
// Unlike NewPgx which expects a structured config.Data, this variant accepts the
// raw DATABASE_URL that Solar3D services already load from env. Zero-valued
// PoolOptions fields are left at pgxpool's defaults; use DefaultPoolOptions()
// to apply the Solar3D standard pool sizing.
//
// The returned cleanup func closes the pool and is safe to call from defer.
func NewPgxFromDSN(ctx context.Context, dsn string, opts PoolOptions) (*pgxpool.Pool, func(), error) {
	if dsn == "" {
		return nil, nil, fmt.Errorf("pgxpostgres: dsn is required")
	}

	poolConfig, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		return nil, nil, fmt.Errorf("pgxpostgres: parse dsn: %w", err)
	}

	if opts.MaxConns > 0 {
		poolConfig.MaxConns = opts.MaxConns
	}
	if opts.MinConns > 0 {
		poolConfig.MinConns = opts.MinConns
	}
	if opts.MaxConnLifetime > 0 {
		poolConfig.MaxConnLifetime = opts.MaxConnLifetime
	}
	if opts.MaxConnIdleTime > 0 {
		poolConfig.MaxConnIdleTime = opts.MaxConnIdleTime
	}

	pool, err := pgxpool.NewWithConfig(ctx, poolConfig)
	if err != nil {
		return nil, nil, fmt.Errorf("pgxpostgres: create pool: %w", err)
	}

	pingCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
	if err := pool.Ping(pingCtx); err != nil {
		pool.Close()
		return nil, nil, fmt.Errorf("pgxpostgres: ping: %w", err)
	}

	cleanup := func() { pool.Close() }
	return pool, cleanup, nil
}
