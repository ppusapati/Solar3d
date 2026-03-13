import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/connectrpc/services/report_service.dart';
import '../../../core/models/report.dart';

// Events
abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadReports extends ReportEvent {
  final String projectId;
  const LoadReports(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class GenerateReport extends ReportEvent {
  final String projectId;
  final String reportType;
  final String format;
  final String? layoutId;

  const GenerateReport({
    required this.projectId,
    required this.reportType,
    required this.format,
    this.layoutId,
  });

  @override
  List<Object?> get props => [projectId, reportType, format];
}

class GenerateBOM extends ReportEvent {
  final String projectId;
  const GenerateBOM(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class DeleteReport extends ReportEvent {
  final String id;
  const DeleteReport(this.id);
  @override
  List<Object?> get props => [id];
}

// State
class ReportState extends Equatable {
  final List<Report> reports;
  final BillOfMaterials? bom;
  final bool isLoading;
  final bool isGenerating;
  final String? error;

  const ReportState({
    this.reports = const [],
    this.bom,
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
  });

  ReportState copyWith({
    List<Report>? reports,
    BillOfMaterials? bom,
    bool? isLoading,
    bool? isGenerating,
    String? error,
  }) {
    return ReportState(
      reports: reports ?? this.reports,
      bom: bom ?? this.bom,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
    );
  }

  @override
  List<Object?> get props => [reports, bom, isLoading, isGenerating, error];
}

// Bloc
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportServiceClient _reportService;

  ReportBloc(this._reportService) : super(const ReportState()) {
    on<LoadReports>(_onLoad);
    on<GenerateReport>(_onGenerate);
    on<GenerateBOM>(_onGenerateBOM);
    on<DeleteReport>(_onDelete);
  }

  Future<void> _onLoad(
      LoadReports event, Emitter<ReportState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final reports = await _reportService.listReports(event.projectId);
      emit(state.copyWith(reports: reports, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGenerate(
      GenerateReport event, Emitter<ReportState> emit) async {
    emit(state.copyWith(isGenerating: true, error: null));
    try {
      final report = await _reportService.generateReport(
        projectId: event.projectId,
        reportType: event.reportType,
        format: event.format,
        layoutId: event.layoutId,
      );
      emit(state.copyWith(
        reports: [report, ...state.reports],
        isGenerating: false,
      ));
    } catch (e) {
      emit(state.copyWith(isGenerating: false, error: e.toString()));
    }
  }

  Future<void> _onGenerateBOM(
      GenerateBOM event, Emitter<ReportState> emit) async {
    emit(state.copyWith(isGenerating: true, error: null));
    try {
      final bom = await _reportService.generateBOM(event.projectId);
      emit(state.copyWith(bom: bom, isGenerating: false));
    } catch (e) {
      emit(state.copyWith(isGenerating: false, error: e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteReport event, Emitter<ReportState> emit) async {
    try {
      await _reportService.deleteReport(event.id);
      final reports =
          state.reports.where((r) => r.id != event.id).toList();
      emit(state.copyWith(reports: reports));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
