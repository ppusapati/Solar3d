import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/connectrpc/services/layout_service.dart';
import '../../../core/models/layout.dart';

// Events
abstract class LayoutEvent extends Equatable {
  const LayoutEvent();
  @override
  List<Object?> get props => [];
}

class LoadLayouts extends LayoutEvent {
  final String projectId;
  const LoadLayouts(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class CreateLayout extends LayoutEvent {
  final String projectId;
  final String name;
  const CreateLayout({required this.projectId, required this.name});
  @override
  List<Object?> get props => [projectId, name];
}

class GeneratePanelArray extends LayoutEvent {
  final String layoutId;
  final PanelArrayParams params;
  const GeneratePanelArray({required this.layoutId, required this.params});
  @override
  List<Object?> get props => [layoutId];
}

class LoadComponents extends LayoutEvent {
  final String layoutId;
  const LoadComponents(this.layoutId);
  @override
  List<Object?> get props => [layoutId];
}

class PlaceComponent extends LayoutEvent {
  final String layoutId;
  final String componentType;
  final ComponentPosition position;
  final String? assetId;

  const PlaceComponent({
    required this.layoutId,
    required this.componentType,
    required this.position,
    this.assetId,
  });

  @override
  List<Object?> get props => [layoutId, componentType];
}

class DeleteLayout extends LayoutEvent {
  final String id;
  const DeleteLayout(this.id);
  @override
  List<Object?> get props => [id];
}

// State
class LayoutState extends Equatable {
  final List<Layout> layouts;
  final Layout? activeLayout;
  final List<Component> components;
  final bool isLoading;
  final bool isGenerating;
  final String? error;

  const LayoutState({
    this.layouts = const [],
    this.activeLayout,
    this.components = const [],
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
  });

  LayoutState copyWith({
    List<Layout>? layouts,
    Layout? activeLayout,
    List<Component>? components,
    bool? isLoading,
    bool? isGenerating,
    String? error,
  }) {
    return LayoutState(
      layouts: layouts ?? this.layouts,
      activeLayout: activeLayout ?? this.activeLayout,
      components: components ?? this.components,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [layouts, activeLayout, components, isLoading, isGenerating, error];
}

// Bloc
class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  final LayoutServiceClient _layoutService;

  LayoutBloc(this._layoutService) : super(const LayoutState()) {
    on<LoadLayouts>(_onLoad);
    on<CreateLayout>(_onCreate);
    on<GeneratePanelArray>(_onGenerate);
    on<LoadComponents>(_onLoadComponents);
    on<PlaceComponent>(_onPlaceComponent);
    on<DeleteLayout>(_onDelete);
  }

  Future<void> _onLoad(
      LoadLayouts event, Emitter<LayoutState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final layouts = await _layoutService.listLayouts(event.projectId);
      emit(state.copyWith(
        layouts: layouts,
        isLoading: false,
        activeLayout: layouts.isNotEmpty ? layouts.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateLayout event, Emitter<LayoutState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final layout = await _layoutService.createLayout(
        projectId: event.projectId,
        name: event.name,
      );
      emit(state.copyWith(
        layouts: [layout, ...state.layouts],
        activeLayout: layout,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGenerate(
      GeneratePanelArray event, Emitter<LayoutState> emit) async {
    emit(state.copyWith(isGenerating: true, error: null));
    try {
      final layout = await _layoutService.generatePanelArray(
        layoutId: event.layoutId,
        params: event.params,
      );
      final layouts =
          state.layouts.map((l) => l.id == event.layoutId ? layout : l).toList();
      emit(state.copyWith(
        layouts: layouts,
        activeLayout: layout,
        isGenerating: false,
      ));
    } catch (e) {
      emit(state.copyWith(isGenerating: false, error: e.toString()));
    }
  }

  Future<void> _onLoadComponents(
      LoadComponents event, Emitter<LayoutState> emit) async {
    try {
      final components =
          await _layoutService.listComponents(event.layoutId);
      emit(state.copyWith(components: components));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onPlaceComponent(
      PlaceComponent event, Emitter<LayoutState> emit) async {
    try {
      final component = await _layoutService.placeComponent(
        layoutId: event.layoutId,
        componentType: event.componentType,
        position: event.position,
        assetId: event.assetId,
      );
      emit(state.copyWith(
        components: [...state.components, component],
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteLayout event, Emitter<LayoutState> emit) async {
    try {
      await _layoutService.deleteLayout(event.id);
      final layouts = state.layouts.where((l) => l.id != event.id).toList();
      emit(state.copyWith(
        layouts: layouts,
        activeLayout:
            state.activeLayout?.id == event.id ? null : state.activeLayout,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
