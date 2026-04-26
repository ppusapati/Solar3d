//
//  Generated code. Do not modify.
//  source: protection/v1/protection.proto
//

import "package:connectrpc/connect.dart" as connect;
import "protection.pb.dart" as protectionv1protection;
import "protection.connect.spec.dart" as specs;

/// ProtectionService implements IEC 60909 short-circuit and IEC 60255 protective
/// relay studies for solar plant HV/MV networks.
extension type ProtectionServiceClient (connect.Transport _transport) {
  /// Study management
  Future<protectionv1protection.CreateStudyResponse> createStudy(
    protectionv1protection.CreateStudyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.createStudy,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protectionv1protection.GetStudyResponse> getStudy(
    protectionv1protection.GetStudyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.getStudy,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protectionv1protection.ListStudiesResponse> listStudies(
    protectionv1protection.ListStudiesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.listStudies,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protectionv1protection.DeleteStudyResponse> deleteStudy(
    protectionv1protection.DeleteStudyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.deleteStudy,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Fault calculations
  Future<protectionv1protection.ComputeShortCircuitResponse> computeShortCircuit(
    protectionv1protection.ComputeShortCircuitRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.computeShortCircuit,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protectionv1protection.ComputeEarthFaultResponse> computeEarthFault(
    protectionv1protection.ComputeEarthFaultRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.computeEarthFault,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Relay selection and settings
  Future<protectionv1protection.SelectRelayResponse> selectRelay(
    protectionv1protection.SelectRelayRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.selectRelay,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protectionv1protection.ComputeRelaySettingsResponse> computeRelaySettings(
    protectionv1protection.ComputeRelaySettingsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.computeRelaySettings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Coordination check across upstream/downstream hierarchy
  Future<protectionv1protection.ValidateCoordinationResponse> validateCoordination(
    protectionv1protection.ValidateCoordinationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.validateCoordination,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Plain-text protection study report
  Future<protectionv1protection.GenerateProtectionReportResponse> generateProtectionReport(
    protectionv1protection.GenerateProtectionReportRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProtectionService.generateProtectionReport,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
