import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/connectrpc/services/simulation_service.dart';
import '../../../core/models/simulation.dart';

// Events
abstract class SimulationEvent extends Equatable {
  const SimulationEvent();
  @override
  List<Object?> get props => [];
}

class LoadSimulations extends SimulationEvent {
  final String projectId;
  const LoadSimulations(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class CreateSimulation extends SimulationEvent {
  final String projectId;
  final String layoutId;
  final String name;
  final String simulationType;
  final SimulationParams params;

  const CreateSimulation({
    required this.projectId,
    required this.layoutId,
    required this.name,
    required this.simulationType,
    required this.params,
  });

  @override
  List<Object?> get props => [projectId, name, simulationType];
}

class RunSimulation extends SimulationEvent {
  final String id;
  const RunSimulation(this.id);
  @override
  List<Object?> get props => [id];
}

class PollSimulationStatus extends SimulationEvent {
  final String id;
  const PollSimulationStatus(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteSimulation extends SimulationEvent {
  final String id;
  const DeleteSimulation(this.id);
  @override
  List<Object?> get props => [id];
}

// State
class SimulationState extends Equatable {
  final List<Simulation> simulations;
  final bool isLoading;
  final bool isRunning;
  final String? error;
  final String? activeSimulationId;

  const SimulationState({
    this.simulations = const [],
    this.isLoading = false,
    this.isRunning = false,
    this.error,
    this.activeSimulationId,
  });

  SimulationState copyWith({
    List<Simulation>? simulations,
    bool? isLoading,
    bool? isRunning,
    String? error,
    String? activeSimulationId,
  }) {
    return SimulationState(
      simulations: simulations ?? this.simulations,
      isLoading: isLoading ?? this.isLoading,
      isRunning: isRunning ?? this.isRunning,
      error: error,
      activeSimulationId: activeSimulationId ?? this.activeSimulationId,
    );
  }

  @override
  List<Object?> get props =>
      [simulations, isLoading, isRunning, error, activeSimulationId];
}

// Bloc
class SimulationBloc extends Bloc<SimulationEvent, SimulationState> {
  final SimulationServiceClient _simulationService;

  SimulationBloc(this._simulationService) : super(const SimulationState()) {
    on<LoadSimulations>(_onLoad);
    on<CreateSimulation>(_onCreate);
    on<RunSimulation>(_onRun);
    on<PollSimulationStatus>(_onPoll);
    on<DeleteSimulation>(_onDelete);
  }

  Future<void> _onLoad(
      LoadSimulations event, Emitter<SimulationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final sims =
          await _simulationService.listSimulations(event.projectId);
      emit(state.copyWith(simulations: sims, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateSimulation event, Emitter<SimulationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final sim = await _simulationService.createSimulation(
        projectId: event.projectId,
        layoutId: event.layoutId,
        name: event.name,
        simulationType: event.simulationType,
        params: event.params,
      );
      emit(state.copyWith(
        simulations: [sim, ...state.simulations],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRun(
      RunSimulation event, Emitter<SimulationState> emit) async {
    emit(state.copyWith(isRunning: true, activeSimulationId: event.id));
    try {
      final sim = await _simulationService.runSimulation(event.id);
      final sims =
          state.simulations.map((s) => s.id == event.id ? sim : s).toList();
      emit(state.copyWith(
        simulations: sims,
        isRunning: sim.isRunning,
        activeSimulationId: sim.isRunning ? event.id : null,
      ));

      // Auto-poll if still running
      if (sim.isRunning) {
        add(PollSimulationStatus(event.id));
      }
    } catch (e) {
      emit(state.copyWith(isRunning: false, error: e.toString()));
    }
  }

  Future<void> _onPoll(
      PollSimulationStatus event, Emitter<SimulationState> emit) async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      final sim = await _simulationService.getSimulation(event.id);
      final sims =
          state.simulations.map((s) => s.id == event.id ? sim : s).toList();
      emit(state.copyWith(
        simulations: sims,
        isRunning: sim.isRunning,
        activeSimulationId: sim.isRunning ? event.id : null,
      ));

      if (sim.isRunning) {
        add(PollSimulationStatus(event.id));
      }
    } catch (e) {
      emit(state.copyWith(isRunning: false, error: e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteSimulation event, Emitter<SimulationState> emit) async {
    try {
      await _simulationService.deleteSimulation(event.id);
      final sims =
          state.simulations.where((s) => s.id != event.id).toList();
      emit(state.copyWith(simulations: sims));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
