//
//  Generated code. Do not modify.
//  source: electrical/v1/electrical.proto
//

import "package:connectrpc/connect.dart" as connect;
import "electrical.pb.dart" as electricalv1electrical;

/// ElectricalService manages electrical network topology for solar farm layouts,
/// including string configuration, inverter assignment, capacity calculations,
/// network topology validation, BOM derivation, and the acceptance workflow gate
/// required for ElectricalReady -> TransmissionReady phase progression.
abstract final class ElectricalService {
  /// Fully-qualified name of the ElectricalService service.
  static const name = 'electrical.v1.ElectricalService';

  /// CreateNetwork creates a new electrical network for a project layout.
  static const createNetwork = connect.Spec(
    '/$name/CreateNetwork',
    connect.StreamType.unary,
    electricalv1electrical.CreateNetworkRequest.new,
    electricalv1electrical.CreateNetworkResponse.new,
  );

  /// GetNetwork retrieves an electrical network by ID including review metadata.
  static const getNetwork = connect.Spec(
    '/$name/GetNetwork',
    connect.StreamType.unary,
    electricalv1electrical.GetNetworkRequest.new,
    electricalv1electrical.GetNetworkResponse.new,
  );

  /// ListNetworks returns all electrical networks for a project.
  static const listNetworks = connect.Spec(
    '/$name/ListNetworks',
    connect.StreamType.unary,
    electricalv1electrical.ListNetworksRequest.new,
    electricalv1electrical.ListNetworksResponse.new,
  );

  /// DeleteNetwork permanently removes an electrical network and all its strings.
  static const deleteNetwork = connect.Spec(
    '/$name/DeleteNetwork',
    connect.StreamType.unary,
    electricalv1electrical.DeleteNetworkRequest.new,
    electricalv1electrical.DeleteNetworkResponse.new,
  );

  /// String operations
  static const createString = connect.Spec(
    '/$name/CreateString',
    connect.StreamType.unary,
    electricalv1electrical.CreateStringRequest.new,
    electricalv1electrical.CreateStringResponse.new,
  );

  /// AutoGenerateStrings generates panel strings automatically based on inverter groups.
  static const autoGenerateStrings = connect.Spec(
    '/$name/AutoGenerateStrings',
    connect.StreamType.unary,
    electricalv1electrical.AutoGenerateStringsRequest.new,
    electricalv1electrical.AutoGenerateStringsResponse.new,
  );

  /// ListStrings returns all strings for a network.
  static const listStrings = connect.Spec(
    '/$name/ListStrings',
    connect.StreamType.unary,
    electricalv1electrical.ListStringsRequest.new,
    electricalv1electrical.ListStringsResponse.new,
  );

  /// Inverter operations
  static const assignInverter = connect.Spec(
    '/$name/AssignInverter',
    connect.StreamType.unary,
    electricalv1electrical.AssignInverterRequest.new,
    electricalv1electrical.AssignInverterResponse.new,
  );

  /// ListInverterGroups returns all inverter groups and their assigned strings.
  static const listInverterGroups = connect.Spec(
    '/$name/ListInverterGroups',
    connect.StreamType.unary,
    electricalv1electrical.ListInverterGroupsRequest.new,
    electricalv1electrical.ListInverterGroupsResponse.new,
  );

  /// Calculations
  static const calculateDCCapacity = connect.Spec(
    '/$name/CalculateDCCapacity',
    connect.StreamType.unary,
    electricalv1electrical.CalculateDCCapacityRequest.new,
    electricalv1electrical.CalculateDCCapacityResponse.new,
  );

  /// CalculateACCapacity computes total AC output capacity for the network.
  static const calculateACCapacity = connect.Spec(
    '/$name/CalculateACCapacity',
    connect.StreamType.unary,
    electricalv1electrical.CalculateACCapacityRequest.new,
    electricalv1electrical.CalculateACCapacityResponse.new,
  );

  /// CalculateLosses computes cable, mismatch, and system losses for the network.
  static const calculateLosses = connect.Spec(
    '/$name/CalculateLosses',
    connect.StreamType.unary,
    electricalv1electrical.CalculateLossesRequest.new,
    electricalv1electrical.CalculateLossesResponse.new,
  );

  /// ValidateSizing performs parametric sizing validation against design constraints.
  static const validateSizing = connect.Spec(
    '/$name/ValidateSizing',
    connect.StreamType.unary,
    electricalv1electrical.ValidateSizingRequest.new,
    electricalv1electrical.ValidateSizingResponse.new,
  );

  /// ValidateNetwork performs full topology validation: all strings assigned, no orphans, MPPT limits.
  static const validateNetwork = connect.Spec(
    '/$name/ValidateNetwork',
    connect.StreamType.unary,
    electricalv1electrical.ValidateNetworkRequest.new,
    electricalv1electrical.ValidateNetworkResponse.new,
  );

  /// GenerateNetworkBOM derives BOM item counts directly from the live network topology.
  static const generateNetworkBOM = connect.Spec(
    '/$name/GenerateNetworkBOM',
    connect.StreamType.unary,
    electricalv1electrical.GenerateNetworkBOMRequest.new,
    electricalv1electrical.GenerateNetworkBOMResponse.new,
  );

  /// Acceptance workflow — gates the ElectricalReady -> TransmissionReady phase transition.
  /// SubmitNetworkForReview transitions review_metadata.status to REVIEW_PENDING.
  static const submitNetworkForReview = connect.Spec(
    '/$name/SubmitNetworkForReview',
    connect.StreamType.unary,
    electricalv1electrical.SubmitNetworkForReviewRequest.new,
    electricalv1electrical.SubmitNetworkForReviewResponse.new,
  );

  /// ApproveNetwork sets review_metadata.status to APPROVED, enabling TransmissionReady transition.
  static const approveNetwork = connect.Spec(
    '/$name/ApproveNetwork',
    connect.StreamType.unary,
    electricalv1electrical.ApproveNetworkRequest.new,
    electricalv1electrical.ApproveNetworkResponse.new,
  );

  /// RejectNetwork sets review_metadata.status to REJECTED and records blocker reasons.
  static const rejectNetwork = connect.Spec(
    '/$name/RejectNetwork',
    connect.StreamType.unary,
    electricalv1electrical.RejectNetworkRequest.new,
    electricalv1electrical.RejectNetworkResponse.new,
  );
}
