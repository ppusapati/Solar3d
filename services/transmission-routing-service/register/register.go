package register

import (
	"context"
	"fmt"
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	transmissionv1connect "p9e.in/samavaya/solar3d/gen/transmission/v1/transmissionv1connect"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/db"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/handler"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/repository"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/service"
)

func Register(mux *http.ServeMux, pool *pgxpool.Pool, terrainBridgeURL, terrainServiceURL, projectServiceURL string) error {
	if err := db.EnsureSchema(context.Background(), pool); err != nil {
		return fmt.Errorf("bootstrap transmission schema: %w", err)
	}

	repo := repository.New(db.New(pool))
	svc := service.NewTransmissionService(repo, terrainBridgeURL, terrainServiceURL, projectServiceURL)
	connectPath, connectHandler := transmissionv1connect.NewTransmissionRoutingServiceHandler(handler.NewConnectTransmissionRoutingService(svc))
	mux.Handle(connectPath, connectHandler)
	return nil
}
