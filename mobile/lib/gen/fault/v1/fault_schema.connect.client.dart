//
//  Generated code. Do not modify.
//  source: fault/v1/fault_schema.proto
//

import "package:connectrpc/connect.dart" as connect;
import "fault_schema.pb.dart" as faultv1fault_schema;
import "fault_schema.connect.spec.dart" as specs;

/// FaultService manages operational fault events received from digital twins,
/// SCADA systems, protection relays, and manual reports.  Fault codes align
/// with IEC 60909 (short-circuit fault calculations) and IEC 61724-1 (PV system
/// performance monitoring) where applicable.
extension type FaultServiceClient (connect.Transport _transport) {
  /// ReportFault creates a new fault event for a digital twin asset.
  /// The twin_id must correspond to an ACTIVE DigitalTwin.
  Future<faultv1fault_schema.ReportFaultResponse> reportFault(
    faultv1fault_schema.ReportFaultRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FaultService.reportFault,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetFault retrieves a single fault event by its unique ID.
  Future<faultv1fault_schema.GetFaultResponse> getFault(
    faultv1fault_schema.GetFaultRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FaultService.getFault,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListFaults returns fault events filtered by twin, project, severity or status.
  /// Results are ordered by detected_at descending.
  Future<faultv1fault_schema.ListFaultsResponse> listFaults(
    faultv1fault_schema.ListFaultsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FaultService.listFaults,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AcknowledgeFault marks a fault as seen by an operator.  Only faults in
  /// FAULT_STATUS_ACTIVE state may be acknowledged; others return FAILED_PRECONDITION.
  Future<faultv1fault_schema.AcknowledgeFaultResponse> acknowledgeFault(
    faultv1fault_schema.AcknowledgeFaultRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FaultService.acknowledgeFault,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ResolveFault closes a fault with operator resolution notes.  Faults must be
  /// in FAULT_STATUS_ACTIVE or FAULT_STATUS_ACKNOWLEDGED state to be resolved.
  Future<faultv1fault_schema.ResolveFaultResponse> resolveFault(
    faultv1fault_schema.ResolveFaultRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FaultService.resolveFault,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
