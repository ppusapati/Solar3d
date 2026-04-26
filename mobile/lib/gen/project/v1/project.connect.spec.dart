//
//  Generated code. Do not modify.
//  source: project/v1/project.proto
//

import "package:connectrpc/connect.dart" as connect;
import "project.pb.dart" as projectv1project;

abstract final class ProjectService {
  /// Fully-qualified name of the ProjectService service.
  static const name = 'project.v1.ProjectService';

  static const createProject = connect.Spec(
    '/$name/CreateProject',
    connect.StreamType.unary,
    projectv1project.CreateProjectRequest.new,
    projectv1project.CreateProjectResponse.new,
  );

  static const getProject = connect.Spec(
    '/$name/GetProject',
    connect.StreamType.unary,
    projectv1project.GetProjectRequest.new,
    projectv1project.GetProjectResponse.new,
  );

  static const listProjects = connect.Spec(
    '/$name/ListProjects',
    connect.StreamType.unary,
    projectv1project.ListProjectsRequest.new,
    projectv1project.ListProjectsResponse.new,
  );

  static const updateProject = connect.Spec(
    '/$name/UpdateProject',
    connect.StreamType.unary,
    projectv1project.UpdateProjectRequest.new,
    projectv1project.UpdateProjectResponse.new,
  );

  static const deleteProject = connect.Spec(
    '/$name/DeleteProject',
    connect.StreamType.unary,
    projectv1project.DeleteProjectRequest.new,
    projectv1project.DeleteProjectResponse.new,
  );

  static const transitionPhase = connect.Spec(
    '/$name/TransitionPhase',
    connect.StreamType.unary,
    projectv1project.TransitionPhaseRequest.new,
    projectv1project.TransitionPhaseResponse.new,
  );

  static const getPhaseState = connect.Spec(
    '/$name/GetPhaseState',
    connect.StreamType.unary,
    projectv1project.GetPhaseStateRequest.new,
    projectv1project.GetPhaseStateResponse.new,
  );

  static const listPhaseTransitions = connect.Spec(
    '/$name/ListPhaseTransitions',
    connect.StreamType.unary,
    projectv1project.ListPhaseTransitionsRequest.new,
    projectv1project.ListPhaseTransitionsResponse.new,
  );

  static const validatePhaseReadiness = connect.Spec(
    '/$name/ValidatePhaseReadiness',
    connect.StreamType.unary,
    projectv1project.ValidatePhaseReadinessRequest.new,
    projectv1project.ValidatePhaseReadinessResponse.new,
  );
}
