import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/connectrpc/services/electrical_service.dart';
import '../../../core/models/electrical.dart';

// Events
abstract class ElectricalEvent extends Equatable {
  const ElectricalEvent();
  @override
  List<Object?> get props => [];
}

class LoadNetworks extends ElectricalEvent {
  final String projectId;
  const LoadNetworks(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class CreateNetwork extends ElectricalEvent {
  final String projectId;
  final String layoutId;
  final String name;
  const CreateNetwork({
    required this.projectId,
    required this.layoutId,
    required this.name,
  });
  @override
  List<Object?> get props => [projectId, name];
}

class AutoGenerateStrings extends ElectricalEvent {
  final String networkId;
  const AutoGenerateStrings(this.networkId);
  @override
  List<Object?> get props => [networkId];
}

class CalculateLosses extends ElectricalEvent {
  final String networkId;
  const CalculateLosses(this.networkId);
  @override
  List<Object?> get props => [networkId];
}

class DeleteNetwork extends ElectricalEvent {
  final String id;
  const DeleteNetwork(this.id);
  @override
  List<Object?> get props => [id];
}

// State
class ElectricalState extends Equatable {
  final List<ElectricalNetwork> networks;
  final ElectricalNetwork? activeNetwork;
  final List<PanelString> strings;
  final LossBreakdown? losses;
  final bool isLoading;
  final bool isGenerating;
  final String? error;

  const ElectricalState({
    this.networks = const [],
    this.activeNetwork,
    this.strings = const [],
    this.losses,
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
  });

  ElectricalState copyWith({
    List<ElectricalNetwork>? networks,
    ElectricalNetwork? activeNetwork,
    List<PanelString>? strings,
    LossBreakdown? losses,
    bool? isLoading,
    bool? isGenerating,
    String? error,
  }) {
    return ElectricalState(
      networks: networks ?? this.networks,
      activeNetwork: activeNetwork ?? this.activeNetwork,
      strings: strings ?? this.strings,
      losses: losses ?? this.losses,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [networks, activeNetwork, strings, losses, isLoading, isGenerating];
}

// Bloc
class ElectricalBloc extends Bloc<ElectricalEvent, ElectricalState> {
  final ElectricalServiceClient _electricalService;

  ElectricalBloc(this._electricalService)
      : super(const ElectricalState()) {
    on<LoadNetworks>(_onLoad);
    on<CreateNetwork>(_onCreate);
    on<AutoGenerateStrings>(_onAutoGenerate);
    on<CalculateLosses>(_onCalculateLosses);
    on<DeleteNetwork>(_onDelete);
  }

  Future<void> _onLoad(
      LoadNetworks event, Emitter<ElectricalState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final networks =
          await _electricalService.listNetworks(event.projectId);
      emit(state.copyWith(
        networks: networks,
        isLoading: false,
        activeNetwork: networks.isNotEmpty ? networks.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateNetwork event, Emitter<ElectricalState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final network = await _electricalService.createNetwork(
        projectId: event.projectId,
        layoutId: event.layoutId,
        name: event.name,
      );
      emit(state.copyWith(
        networks: [network, ...state.networks],
        activeNetwork: network,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAutoGenerate(
      AutoGenerateStrings event, Emitter<ElectricalState> emit) async {
    emit(state.copyWith(isGenerating: true, error: null));
    try {
      final network =
          await _electricalService.autoGenerateStrings(event.networkId);
      final strings =
          await _electricalService.listStrings(event.networkId);
      final networks = state.networks
          .map((n) => n.id == event.networkId ? network : n)
          .toList();
      emit(state.copyWith(
        networks: networks,
        activeNetwork: network,
        strings: strings,
        isGenerating: false,
      ));
    } catch (e) {
      emit(state.copyWith(isGenerating: false, error: e.toString()));
    }
  }

  Future<void> _onCalculateLosses(
      CalculateLosses event, Emitter<ElectricalState> emit) async {
    try {
      final losses =
          await _electricalService.calculateLosses(event.networkId);
      emit(state.copyWith(losses: losses));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteNetwork event, Emitter<ElectricalState> emit) async {
    try {
      await _electricalService.deleteNetwork(event.id);
      final networks =
          state.networks.where((n) => n.id != event.id).toList();
      emit(state.copyWith(
        networks: networks,
        activeNetwork:
            state.activeNetwork?.id == event.id ? null : state.activeNetwork,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
