//
//  Generated code. Do not modify.
//  source: protection/v1/protection.proto
//

import "package:connectrpc/connect.dart" as connect;
import "protection.pb.dart" as protectionv1protection;

/// ProtectionService implements IEC 60909 short-circuit and IEC 60255 protective
/// relay studies for solar plant HV/MV networks.
abstract final class ProtectionService {
  /// Fully-qualified name of the ProtectionService service.
  static const name = 'protection.v1.ProtectionService';

  /// Study management
  static const createStudy = connect.Spec(
    '/$name/CreateStudy',
    connect.StreamType.unary,
    protectionv1protection.CreateStudyRequest.new,
    protectionv1protection.CreateStudyResponse.new,
  );

  static const getStudy = connect.Spec(
    '/$name/GetStudy',
    connect.StreamType.unary,
    protectionv1protection.GetStudyRequest.new,
    protectionv1protection.GetStudyResponse.new,
  );

  static const listStudies = connect.Spec(
    '/$name/ListStudies',
    connect.StreamType.unary,
    protectionv1protection.ListStudiesRequest.new,
    protectionv1protection.ListStudiesResponse.new,
  );

  static const deleteStudy = connect.Spec(
    '/$name/DeleteStudy',
    connect.StreamType.unary,
    protectionv1protection.DeleteStudyRequest.new,
    protectionv1protection.DeleteStudyResponse.new,
  );

  /// Fault calculations
  static const computeShortCircuit = connect.Spec(
    '/$name/ComputeShortCircuit',
    connect.StreamType.unary,
    protectionv1protection.ComputeShortCircuitRequest.new,
    protectionv1protection.ComputeShortCircuitResponse.new,
  );

  static const computeEarthFault = connect.Spec(
    '/$name/ComputeEarthFault',
    connect.StreamType.unary,
    protectionv1protection.ComputeEarthFaultRequest.new,
    protectionv1protection.ComputeEarthFaultResponse.new,
  );

  /// Relay selection and settings
  static const selectRelay = connect.Spec(
    '/$name/SelectRelay',
    connect.StreamType.unary,
    protectionv1protection.SelectRelayRequest.new,
    protectionv1protection.SelectRelayResponse.new,
  );

  static const computeRelaySettings = connect.Spec(
    '/$name/ComputeRelaySettings',
    connect.StreamType.unary,
    protectionv1protection.ComputeRelaySettingsRequest.new,
    protectionv1protection.ComputeRelaySettingsResponse.new,
  );

  /// Coordination check across upstream/downstream hierarchy
  static const validateCoordination = connect.Spec(
    '/$name/ValidateCoordination',
    connect.StreamType.unary,
    protectionv1protection.ValidateCoordinationRequest.new,
    protectionv1protection.ValidateCoordinationResponse.new,
  );

  /// Plain-text protection study report
  static const generateProtectionReport = connect.Spec(
    '/$name/GenerateProtectionReport',
    connect.StreamType.unary,
    protectionv1protection.GenerateProtectionReportRequest.new,
    protectionv1protection.GenerateProtectionReportResponse.new,
  );
}
