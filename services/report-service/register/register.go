// Package reportservice exposes a Register function for monolith use.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	reportv1connect "github.com/solar3d/solar3d/gen/report/v1/reportv1connect"

	"solar3d/report-service/internal/handler"
	"solar3d/report-service/internal/repository"
	"solar3d/report-service/internal/service"
)

// Register wires the report-service handlers onto mux.
func Register(mux *http.ServeMux, pool *pgxpool.Pool) {
	repo := repository.NewReportRepository(pool)
	svc := service.NewReportService(repo)
	h := handler.NewConnectReportService(svc)
	path, connectHandler := reportv1connect.NewReportServiceHandler(h)
	mux.Handle(path, connectHandler)
}

