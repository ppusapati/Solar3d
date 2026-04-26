package db

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/packages/database/pgxpostgres"
)

// NewPool opens a pgxpool using the Solar3D standard pool configuration
// (MaxConns=20, MinConns=4, MaxConnLifetime=30m, MaxConnIdleTime=5m).
// Callers must close the returned pool; for a cleanup-func variant use
// pgxpostgres.NewPgxFromDSN directly.
func NewPool(ctx context.Context, databaseURL string) (*pgxpool.Pool, error) {
	pool, _, err := pgxpostgres.NewPgxFromDSN(ctx, databaseURL, pgxpostgres.DefaultPoolOptions())
	return pool, err
}
