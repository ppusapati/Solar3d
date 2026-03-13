import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/connectrpc/services/project_service.dart';
import '../../../core/models/project.dart';

// Events
abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectEvent {}

class CreateProject extends ProjectEvent {
  final String name;
  final String? description;
  final double? targetCapacityMw;
  final String? locationName;
  final String? clientName;

  const CreateProject({
    required this.name,
    this.description,
    this.targetCapacityMw,
    this.locationName,
    this.clientName,
  });

  @override
  List<Object?> get props => [name];
}

class UpdateProject extends ProjectEvent {
  final String id;
  final Map<String, dynamic> updates;

  const UpdateProject(this.id, this.updates);

  @override
  List<Object?> get props => [id, updates];
}

class DeleteProject extends ProjectEvent {
  final String id;
  const DeleteProject(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshProjects extends ProjectEvent {}

// State
class ProjectState extends Equatable {
  final List<Project> projects;
  final bool isLoading;
  final String? error;
  final bool isCreating;

  const ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.error,
    this.isCreating = false,
  });

  ProjectState copyWith({
    List<Project>? projects,
    bool? isLoading,
    String? error,
    bool? isCreating,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCreating: isCreating ?? this.isCreating,
    );
  }

  @override
  List<Object?> get props => [projects, isLoading, error, isCreating];
}

// Bloc
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectServiceClient _projectService;

  ProjectBloc(this._projectService) : super(const ProjectState()) {
    on<LoadProjects>(_onLoad);
    on<CreateProject>(_onCreate);
    on<UpdateProject>(_onUpdate);
    on<DeleteProject>(_onDelete);
    on<RefreshProjects>(_onRefresh);
  }

  Future<void> _onLoad(
      LoadProjects event, Emitter<ProjectState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final projects = await _projectService.listProjects();
      emit(state.copyWith(projects: projects, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateProject event, Emitter<ProjectState> emit) async {
    emit(state.copyWith(isCreating: true, error: null));
    try {
      final project = await _projectService.createProject(
        name: event.name,
        description: event.description,
        targetCapacityMw: event.targetCapacityMw,
        locationName: event.locationName,
        clientName: event.clientName,
      );
      emit(state.copyWith(
        projects: [project, ...state.projects],
        isCreating: false,
      ));
    } catch (e) {
      emit(state.copyWith(isCreating: false, error: e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateProject event, Emitter<ProjectState> emit) async {
    try {
      final updated =
          await _projectService.updateProject(event.id, event.updates);
      final projects = state.projects
          .map((p) => p.id == event.id ? updated : p)
          .toList();
      emit(state.copyWith(projects: projects));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteProject event, Emitter<ProjectState> emit) async {
    try {
      await _projectService.deleteProject(event.id);
      final projects = state.projects.where((p) => p.id != event.id).toList();
      emit(state.copyWith(projects: projects));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshProjects event, Emitter<ProjectState> emit) async {
    try {
      final projects = await _projectService.listProjects();
      emit(state.copyWith(projects: projects));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
