package handler

import (
	"context"
	"errors"
	"strings"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	projectv1 "p9e.in/samavaya/solar3d/gen/project/v1"
	projectv1connect "p9e.in/samavaya/solar3d/gen/project/v1/projectv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"
	paginationv1 "p9e.in/samavaya/packages/api/v1/pagination"
	pkgErrors "p9e.in/samavaya/packages/errors"

	"p9e.in/samavaya/solar3d/project-service/internal/domain"
	"p9e.in/samavaya/solar3d/project-service/internal/service"
)

// ConnectProjectService adapts the internal service layer to the generated
// ConnectRPC ProjectService interface.
type ConnectProjectService struct {
	svc *service.ProjectService
}

var _ projectv1connect.ProjectServiceHandler = (*ConnectProjectService)(nil)

func NewConnectProjectService(svc *service.ProjectService) *ConnectProjectService {
	return &ConnectProjectService{svc: svc}
}

func (h *ConnectProjectService) CreateProject(
	ctx context.Context,
	req *connect.Request[projectv1.CreateProjectRequest],
) (*connect.Response[projectv1.CreateProjectResponse], error) {
	project := &domain.Project{
		Name:        strings.TrimSpace(req.Msg.GetName()),
		Description: req.Msg.GetDescription(),
	}
	if metadata := req.Msg.GetMetadata(); metadata != nil {
		project.TargetCapacityMW = metadata.GetTargetCapacityMw()
		project.LocationName = metadata.GetLocationName()
		project.ClientName = metadata.GetClientName()
		project.Notes = metadata.GetNotes()
	}

	if err := h.svc.CreateProject(ctx, project); err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&projectv1.CreateProjectResponse{
		Project: projectToProto(project, nil),
	}), nil
}

func (h *ConnectProjectService) GetProject(
	ctx context.Context,
	req *connect.Request[projectv1.GetProjectRequest],
) (*connect.Response[projectv1.GetProjectResponse], error) {
	id, err := parseUUID(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	project, err := h.svc.GetProject(ctx, id)
	if err != nil {
		return nil, toConnectError(err)
	}

	site, err := h.svc.GetSiteByProjectID(ctx, id)
	if err != nil && !errors.Is(err, service.ErrNotFound) {
		return nil, toConnectError(err)
	}
	if errors.Is(err, service.ErrNotFound) {
		site = nil
	}

	return connect.NewResponse(&projectv1.GetProjectResponse{
		Project: projectToProto(project, site),
	}), nil
}

func (h *ConnectProjectService) ListProjects(
	ctx context.Context,
	req *connect.Request[projectv1.ListProjectsRequest],
) (*connect.Response[projectv1.ListProjectsResponse], error) {
	pagination := req.Msg.GetPagination()
	pageSize := int(pagination.GetPageSize())
	if pageSize <= 0 {
		pageSize = 20
	}
	if pageSize > 100 {
		pageSize = 100
	}

	offset := int(pagination.GetPageOffset())

	projects, err := h.svc.ListProjects(ctx, pageSize, offset)
	if err != nil {
		return nil, toConnectError(err)
	}

	protoProjects := make([]*projectv1.Project, 0, len(projects))
	for _, project := range projects {
		protoProjects = append(protoProjects, projectToProto(project, nil))
	}

	hasNext := len(projects) == pageSize

	return connect.NewResponse(&projectv1.ListProjectsResponse{
		Projects: protoProjects,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: int32(offset + len(projects)),
			PageOffset: pagination.GetPageOffset(),
			PageSize:   int32(pageSize),
			HasNext:    hasNext,
		},
	}), nil
}

func (h *ConnectProjectService) UpdateProject(
	ctx context.Context,
	req *connect.Request[projectv1.UpdateProjectRequest],
) (*connect.Response[projectv1.UpdateProjectResponse], error) {
	id, err := parseUUID(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	project, err := h.svc.GetProject(ctx, id)
	if err != nil {
		return nil, toConnectError(err)
	}

	if name := strings.TrimSpace(req.Msg.GetName()); name != "" {
		project.Name = name
	}
	if description := req.Msg.GetDescription(); description != "" {
		project.Description = description
	}
	if status := req.Msg.GetStatus(); status != projectv1.ProjectStatus_PROJECT_STATUS_UNSPECIFIED {
		project.Status = protoStatusToDomain(status)
	}
	if metadata := req.Msg.GetMetadata(); metadata != nil {
		project.TargetCapacityMW = metadata.GetTargetCapacityMw()
		project.LocationName = metadata.GetLocationName()
		project.ClientName = metadata.GetClientName()
		project.Notes = metadata.GetNotes()
	}

	if err := h.svc.UpdateProject(ctx, project); err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&projectv1.UpdateProjectResponse{
		Project: projectToProto(project, nil),
	}), nil
}

func (h *ConnectProjectService) DeleteProject(
	ctx context.Context,
	req *connect.Request[projectv1.DeleteProjectRequest],
) (*connect.Response[projectv1.DeleteProjectResponse], error) {
	id, err := parseUUID(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	if err := h.svc.DeleteProject(ctx, id); err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&projectv1.DeleteProjectResponse{}), nil
}

func parseUUID(raw string) (uuid.UUID, error) {
	parsed, parseErr := uuid.Parse(raw)
	if parseErr != nil {
		return uuid.Nil, errors.New("invalid project id")
	}
	return parsed, nil
}

func projectToProto(project *domain.Project, site *domain.Site) *projectv1.Project {
	if project == nil {
		return nil
	}

	protoProject := &projectv1.Project{
		Id:          project.ID.String(),
		Name:        project.Name,
		Description: project.Description,
		Status:      domainStatusToProto(project.Status),
		Metadata: &projectv1.ProjectMetadata{
			TargetCapacityMw: project.TargetCapacityMW,
			LocationName:     project.LocationName,
			ClientName:       project.ClientName,
			Notes:            project.Notes,
		},
		CreatedAt: timestamppb.New(project.CreatedAt),
		UpdatedAt: timestamppb.New(project.UpdatedAt),
	}
	if site != nil {
		protoProject.Site = &projectv1.Site{
			Id:              site.ID.String(),
			ProjectId:       site.ProjectID.String(),
			Name:            site.Name,
			BoundaryGeojson: site.BoundaryGeoJSON,
			AreaSqm:         site.AreaSqm,
			Latitude:        site.Latitude,
			Longitude:       site.Longitude,
			Timezone:        site.Timezone,
			CreatedAt:       timestamppb.New(site.CreatedAt),
		}
	}
	return protoProject
}

func domainStatusToProto(status domain.ProjectStatus) projectv1.ProjectStatus {
	switch status {
	case domain.ProjectStatusDraft:
		return projectv1.ProjectStatus_PROJECT_STATUS_DRAFT
	case domain.ProjectStatusDesign:
		return projectv1.ProjectStatus_PROJECT_STATUS_DESIGN
	case domain.ProjectStatusSimulation:
		return projectv1.ProjectStatus_PROJECT_STATUS_SIMULATION
	case domain.ProjectStatusReview:
		return projectv1.ProjectStatus_PROJECT_STATUS_REVIEW
	case domain.ProjectStatusApproved:
		return projectv1.ProjectStatus_PROJECT_STATUS_APPROVED
	case domain.ProjectStatusArchived:
		return projectv1.ProjectStatus_PROJECT_STATUS_ARCHIVED
	default:
		return projectv1.ProjectStatus_PROJECT_STATUS_UNSPECIFIED
	}
}

func protoStatusToDomain(status projectv1.ProjectStatus) domain.ProjectStatus {
	switch status {
	case projectv1.ProjectStatus_PROJECT_STATUS_DRAFT:
		return domain.ProjectStatusDraft
	case projectv1.ProjectStatus_PROJECT_STATUS_DESIGN:
		return domain.ProjectStatusDesign
	case projectv1.ProjectStatus_PROJECT_STATUS_SIMULATION:
		return domain.ProjectStatusSimulation
	case projectv1.ProjectStatus_PROJECT_STATUS_REVIEW:
		return domain.ProjectStatusReview
	case projectv1.ProjectStatus_PROJECT_STATUS_APPROVED:
		return domain.ProjectStatusApproved
	case projectv1.ProjectStatus_PROJECT_STATUS_ARCHIVED:
		return domain.ProjectStatusArchived
	default:
		return ""
	}
}

func toConnectError(err error) error {
	switch {
	case errors.Is(err, service.ErrInvalidInput):
		if pkgErr, ok := err.(*pkgErrors.Error); ok {
			return pkgErr.ToConnectError()
		}
		return pkgErrors.InvalidArgumentf("%w", err).ToConnectError()
	case errors.Is(err, service.ErrNotFound):
		if pkgErr, ok := err.(*pkgErrors.Error); ok {
			return pkgErr.ToConnectError()
		}
		return pkgErrors.NotFound("project", "").ToConnectError()
	default:
		if pkgErr, ok := err.(*pkgErrors.Error); ok {
			return pkgErr.ToConnectError()
		}
		return pkgErrors.Internal("operation failed", err.Error()).ToConnectError()
	}
}
