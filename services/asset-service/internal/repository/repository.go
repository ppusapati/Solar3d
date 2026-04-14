package repository

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/asset-service/internal/domain"
)

type AssetRepository struct {
	pool *pgxpool.Pool
}

func NewAssetRepository(pool *pgxpool.Pool) *AssetRepository {
	return &AssetRepository{pool: pool}
}

func (r *AssetRepository) Create(ctx context.Context, asset *domain.Asset) error {
	dimJSON, err := json.Marshal(asset.Dimensions)
	if err != nil {
		return fmt.Errorf("marshaling dimensions: %w", err)
	}
	elecJSON, err := json.Marshal(asset.ElectricalParams)
	if err != nil {
		return fmt.Errorf("marshaling electrical params: %w", err)
	}

	query := `
		INSERT INTO assets (id, name, manufacturer, model, category, dimensions, electrical_params, model_3d_path, datasheet_path, metadata)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`

	_, err = r.pool.Exec(ctx, query,
		asset.ID, asset.Name, asset.Manufacturer, asset.Model,
		asset.Category, dimJSON, elecJSON,
		asset.Model3DPath, asset.DatasheetPath, asset.Metadata,
	)
	if err != nil {
		return fmt.Errorf("inserting asset: %w", err)
	}
	return nil
}

func (r *AssetRepository) GetByID(ctx context.Context, id uuid.UUID) (*domain.Asset, error) {
	query := `
		SELECT id, name, manufacturer, model, category, dimensions, electrical_params, model_3d_path, datasheet_path, metadata
		FROM assets WHERE id = $1`

	return r.scanAsset(r.pool.QueryRow(ctx, query, id))
}

func (r *AssetRepository) List(ctx context.Context) ([]domain.Asset, error) {
	query := `
		SELECT id, name, manufacturer, model, category, dimensions, electrical_params, model_3d_path, datasheet_path, metadata
		FROM assets ORDER BY category, name`

	return r.queryAssets(ctx, query)
}

func (r *AssetRepository) ListByCategory(ctx context.Context, category domain.AssetCategory) ([]domain.Asset, error) {
	query := `
		SELECT id, name, manufacturer, model, category, dimensions, electrical_params, model_3d_path, datasheet_path, metadata
		FROM assets WHERE category = $1 ORDER BY name`

	return r.queryAssets(ctx, query, category)
}

func (r *AssetRepository) Search(ctx context.Context, filter domain.AssetFilter) ([]domain.Asset, error) {
	var conditions []string
	var args []interface{}
	argIdx := 1

	if filter.Category != nil {
		conditions = append(conditions, fmt.Sprintf("category = $%d", argIdx))
		args = append(args, *filter.Category)
		argIdx++
	}
	if filter.Manufacturer != nil {
		conditions = append(conditions, fmt.Sprintf("manufacturer ILIKE $%d", argIdx))
		args = append(args, "%"+*filter.Manufacturer+"%")
		argIdx++
	}
	if filter.SearchQuery != nil {
		conditions = append(conditions, fmt.Sprintf("(name ILIKE $%d OR model ILIKE $%d OR manufacturer ILIKE $%d)", argIdx, argIdx, argIdx))
		args = append(args, "%"+*filter.SearchQuery+"%")
		argIdx++
	}

	query := `
		SELECT id, name, manufacturer, model, category, dimensions, electrical_params, model_3d_path, datasheet_path, metadata
		FROM assets`
	if len(conditions) > 0 {
		query += " WHERE " + strings.Join(conditions, " AND ")
	}
	query += " ORDER BY category, name"

	return r.queryAssets(ctx, query, args...)
}

func (r *AssetRepository) Update(ctx context.Context, asset *domain.Asset) error {
	dimJSON, err := json.Marshal(asset.Dimensions)
	if err != nil {
		return fmt.Errorf("marshaling dimensions: %w", err)
	}
	elecJSON, err := json.Marshal(asset.ElectricalParams)
	if err != nil {
		return fmt.Errorf("marshaling electrical params: %w", err)
	}

	query := `
		UPDATE assets
		SET name = $2, manufacturer = $3, model = $4, category = $5,
		    dimensions = $6, electrical_params = $7, model_3d_path = $8,
		    datasheet_path = $9, metadata = $10
		WHERE id = $1`

	tag, err := r.pool.Exec(ctx, query,
		asset.ID, asset.Name, asset.Manufacturer, asset.Model,
		asset.Category, dimJSON, elecJSON,
		asset.Model3DPath, asset.DatasheetPath, asset.Metadata,
	)
	if err != nil {
		return fmt.Errorf("updating asset: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("asset not found: %s", asset.ID)
	}
	return nil
}

func (r *AssetRepository) Delete(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM assets WHERE id = $1`
	tag, err := r.pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("deleting asset: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("asset not found: %s", id)
	}
	return nil
}

func (r *AssetRepository) scanAsset(row pgx.Row) (*domain.Asset, error) {
	var asset domain.Asset
	var dimJSON, elecJSON []byte
	var model3dPath, datasheetPath sql.NullString

	err := row.Scan(
		&asset.ID, &asset.Name, &asset.Manufacturer, &asset.Model,
		&asset.Category, &dimJSON, &elecJSON,
		&model3dPath, &datasheetPath, &asset.Metadata,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("asset not found")
		}
		return nil, fmt.Errorf("scanning asset: %w", err)
	}

	// Convert sql.NullString to *string
	if model3dPath.Valid {
		asset.Model3DPath = &model3dPath.String
	}
	if datasheetPath.Valid {
		asset.DatasheetPath = &datasheetPath.String
	}

	if err := json.Unmarshal(dimJSON, &asset.Dimensions); err != nil {
		return nil, fmt.Errorf("unmarshaling dimensions: %w", err)
	}
	if err := json.Unmarshal(elecJSON, &asset.ElectricalParams); err != nil {
		return nil, fmt.Errorf("unmarshaling electrical params: %w", err)
	}

	return &asset, nil
}

func (r *AssetRepository) queryAssets(ctx context.Context, query string, args ...interface{}) ([]domain.Asset, error) {
	rows, err := r.pool.Query(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("querying assets: %w", err)
	}
	defer rows.Close()

	var assets []domain.Asset
	for rows.Next() {
		var asset domain.Asset
		var dimJSON, elecJSON []byte
		var model3dPath, datasheetPath sql.NullString

		if err := rows.Scan(
			&asset.ID, &asset.Name, &asset.Manufacturer, &asset.Model,
			&asset.Category, &dimJSON, &elecJSON,
			&model3dPath, &datasheetPath, &asset.Metadata,
		); err != nil {
			return nil, fmt.Errorf("scanning asset: %w", err)
		}

		// Convert sql.NullString to *string
		if model3dPath.Valid {
			asset.Model3DPath = &model3dPath.String
		}
		if datasheetPath.Valid {
			asset.DatasheetPath = &datasheetPath.String
		}

		if err := json.Unmarshal(dimJSON, &asset.Dimensions); err != nil {
			return nil, fmt.Errorf("unmarshaling dimensions: %w", err)
		}
		if err := json.Unmarshal(elecJSON, &asset.ElectricalParams); err != nil {
			return nil, fmt.Errorf("unmarshaling electrical params: %w", err)
		}

		assets = append(assets, asset)
	}
	return assets, nil
}

