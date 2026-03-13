import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/projects/bloc/project_bloc.dart';
import '../../features/layout/bloc/layout_bloc.dart';
import '../../features/simulation/bloc/simulation_bloc.dart';
import '../../features/electrical/bloc/electrical_bloc.dart';
import '../../features/reports/bloc/report_bloc.dart';
import 'service_providers.dart';

// Bloc instances provided via Riverpod for DI
final projectBlocProvider = Provider<ProjectBloc>((ref) {
  final bloc = ProjectBloc(ref.watch(projectServiceProvider));
  ref.onDispose(() => bloc.close());
  return bloc;
});

final layoutBlocProvider = Provider.family<LayoutBloc, String>((ref, projectId) {
  final bloc = LayoutBloc(ref.watch(layoutServiceProvider));
  bloc.add(LoadLayouts(projectId));
  ref.onDispose(() => bloc.close());
  return bloc;
});

final simulationBlocProvider =
    Provider.family<SimulationBloc, String>((ref, projectId) {
  final bloc = SimulationBloc(ref.watch(simulationServiceProvider));
  bloc.add(LoadSimulations(projectId));
  ref.onDispose(() => bloc.close());
  return bloc;
});

final electricalBlocProvider =
    Provider.family<ElectricalBloc, String>((ref, projectId) {
  final bloc = ElectricalBloc(ref.watch(electricalServiceProvider));
  bloc.add(LoadNetworks(projectId));
  ref.onDispose(() => bloc.close());
  return bloc;
});

final reportBlocProvider =
    Provider.family<ReportBloc, String>((ref, projectId) {
  final bloc = ReportBloc(ref.watch(reportServiceProvider));
  bloc.add(LoadReports(projectId));
  ref.onDispose(() => bloc.close());
  return bloc;
});
