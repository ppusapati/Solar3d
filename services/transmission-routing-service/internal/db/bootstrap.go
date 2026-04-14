package db

import (
	"context"
	_ "embed"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

//go:embed schema.sql
var transmissionSchema string

func EnsureSchema(ctx context.Context, pool *pgxpool.Pool) error {
	if _, err := pool.Exec(ctx, transmissionSchema); err != nil {
		return fmt.Errorf("ensuring transmission schema: %w", err)
	}
	return nil
}

