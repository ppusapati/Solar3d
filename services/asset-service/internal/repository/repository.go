package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/solar3d/solar3d/services/asset-service/internal/domain"
)

type Repository struct {
	pool *pgxpool.Pool
}

func New(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

func (r *Repository) CreateAsset(ctx context.Context, asset *domain.Asset) error {
	asset.ID = uuid.New()
	asset.CreatedAt = time.Now()
	asset.UpdatedAt = asset.CreatedAt

	_, err := r.pool.Exec(ctx,
		`INSERT INTO assets (id, name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg,
			electrical_params, model_3d_path, datasheet_path, metadata, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)`,
		asset.ID, asset.Name, asset.Manufacturer, asset.Model, asset.Category,
		asset.Dimensions.WidthMM, asset.Dimensions.HeightMM, asset.Dimensions.DepthMM, asset.Dimensions.WeightKG,
		asset.ElectricalParams, asset.Model3DPath, asset.DatasheetPath, asset.Metadata,
		asset.CreatedAt, asset.UpdatedAt,
	)
	return err
}

func (r *Repository) GetAsset(ctx context.Context, id uuid.UUID) (*domain.Asset, error) {
	var asset domain.Asset
	var electricalParams, metadata []byte

	err := r.pool.QueryRow(ctx,
		`SELECT id, name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg,
			electrical_params, model_3d_path, datasheet_path, metadata, created_at, updated_at
		FROM assets WHERE id = $1`, id,
	).Scan(
		&asset.ID, &asset.Name, &asset.Manufacturer, &asset.Model, &asset.Category,
		&asset.Dimensions.WidthMM, &asset.Dimensions.HeightMM, &asset.Dimensions.DepthMM, &asset.Dimensions.WeightKG,
		&electricalParams, &asset.Model3DPath, &asset.DatasheetPath, &metadata,
		&asset.CreatedAt, &asset.UpdatedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("asset not found: %s", id)
		}
		return nil, fmt.Errorf("querying asset: %w", err)
	}

	asset.ElectricalParams = json.RawMessage(electricalParams)
	asset.Metadata = json.RawMessage(metadata)
	return &asset, nil
}

func (r *Repository) ListAssets(ctx context.Context, category string, limit, offset int) ([]domain.Asset, int, error) {
	var countQuery string
	var dataQuery string
	var args []interface{}

	if category != "" {
		countQuery = `SELECT COUNT(*) FROM assets WHERE category = $1`
		dataQuery = `SELECT id, name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg,
			electrical_params, model_3d_path, datasheet_path, metadata, created_at, updated_at
			FROM assets WHERE category = $1 ORDER BY name LIMIT $2 OFFSET $3`
		args = []interface{}{category, limit, offset}
	} else {
		countQuery = `SELECT COUNT(*) FROM assets`
		dataQuery = `SELECT id, name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg,
			electrical_params, model_3d_path, datasheet_path, metadata, created_at, updated_at
			FROM assets ORDER BY name LIMIT $1 OFFSET $2`
		args = []interface{}{limit, offset}
	}

	var totalCount int
	if category != "" {
		r.pool.QueryRow(ctx, countQuery, category).Scan(&totalCount)
	} else {
		r.pool.QueryRow(ctx, countQuery).Scan(&totalCount)
	}

	rows, err := r.pool.Query(ctx, dataQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("querying assets: %w", err)
	}
	defer rows.Close()

	var assets []domain.Asset
	for rows.Next() {
		var asset domain.Asset
		var electricalParams, metadata []byte
		if err := rows.Scan(
			&asset.ID, &asset.Name, &asset.Manufacturer, &asset.Model, &asset.Category,
			&asset.Dimensions.WidthMM, &asset.Dimensions.HeightMM, &asset.Dimensions.DepthMM, &asset.Dimensions.WeightKG,
			&electricalParams, &asset.Model3DPath, &asset.DatasheetPath, &metadata,
			&asset.CreatedAt, &asset.UpdatedAt,
		); err != nil {
			return nil, 0, fmt.Errorf("scanning asset: %w", err)
		}
		asset.ElectricalParams = json.RawMessage(electricalParams)
		asset.Metadata = json.RawMessage(metadata)
		assets = append(assets, asset)
	}

	return assets, totalCount, nil
}

func (r *Repository) UpdateAsset(ctx context.Context, asset *domain.Asset) error {
	asset.UpdatedAt = time.Now()
	tag, err := r.pool.Exec(ctx,
		`UPDATE assets SET name=$2, manufacturer=$3, model=$4, width_mm=$5, height_mm=$6,
			depth_mm=$7, weight_kg=$8, electrical_params=$9, model_3d_path=$10, metadata=$11, updated_at=$12
		WHERE id = $1`,
		asset.ID, asset.Name, asset.Manufacturer, asset.Model,
		asset.Dimensions.WidthMM, asset.Dimensions.HeightMM, asset.Dimensions.DepthMM, asset.Dimensions.WeightKG,
		asset.ElectricalParams, asset.Model3DPath, asset.Metadata, asset.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("updating asset: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("asset not found: %s", asset.ID)
	}
	return nil
}

func (r *Repository) DeleteAsset(ctx context.Context, id uuid.UUID) error {
	tag, err := r.pool.Exec(ctx, `DELETE FROM assets WHERE id = $1`, id)
	if err != nil {
		return fmt.Errorf("deleting asset: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("asset not found: %s", id)
	}
	return nil
}
