//
//  Generated code. Do not modify.
//  source: fault/v1/fault_schema.proto
//

import "package:connectrpc/connect.dart" as connect;
import "fault_schema.pb.dart" as faultv1fault_schema;

/// FaultService manages operational fault events received from digital twins,
/// SCADA systems, protection relays, and manual reports.  Fault codes align
/// with IEC 60909 (short-circuit fault calculations) and IEC 61724-1 (PV system
/// performance monitoring) where applicable.
abstract final class FaultService {
  /// Fully-qualified name of the FaultService service.
  static const name = 'fault.v1.FaultService';

  /// ReportFault creates a new fault event for a digital twin asset.
  /// The twin_id must correspond to an ACTIVE DigitalTwin.
  static const reportFault = connect.Spec(
    '/$name/ReportFault',
    connect.StreamType.unary,
    faultv1fault_schema.ReportFaultRequest.new,
    faultv1fault_schema.ReportFaultResponse.new,
  );

  /// GetFault retrieves a single fault event by its unique ID.
  static const getFault = connect.Spec(
    '/$name/GetFault',
    connect.StreamType.unary,
    faultv1fault_schema.GetFaultRequest.new,
    faultv1fault_schema.GetFaultResponse.new,
  );

  /// ListFaults returns fault events filtered by twin, project, severity or status.
  /// Results are ordered by detected_at descending.
  static const listFaults = connect.Spec(
    '/$name/ListFaults',
    connect.StreamType.unary,
    faultv1fault_schema.ListFaultsRequest.new,
    faultv1fault_schema.ListFaultsResponse.new,
  );

  /// AcknowledgeFault marks a fault as seen by an operator.  Only faults in
  /// FAULT_STATUS_ACTIVE state may be acknowledged; others return FAILED_PRECONDITION.
  static const acknowledgeFault = connect.Spec(
    '/$name/AcknowledgeFault',
    connect.StreamType.unary,
    faultv1fault_schema.AcknowledgeFaultRequest.new,
    faultv1fault_schema.AcknowledgeFaultResponse.new,
  );

  /// ResolveFault closes a fault with operator resolution notes.  Faults must be
  /// in FAULT_STATUS_ACTIVE or FAULT_STATUS_ACKNOWLEDGED state to be resolved.
  static const resolveFault = connect.Spec(
    '/$name/ResolveFault',
    connect.StreamType.unary,
    faultv1fault_schema.ResolveFaultRequest.new,
    faultv1fault_schema.ResolveFaultResponse.new,
  );
}
