//
//  Generated code. Do not modify.
//  source: electrical/v1/electrical.proto
//

import "package:connectrpc/connect.dart" as connect;
import "electrical.pb.dart" as electricalv1electrical;
import "electrical.connect.spec.dart" as specs;

/// ElectricalService manages electrical network topology for solar farm layouts,
/// including string configuration, inverter assignment, capacity calculations,
/// network topology validation, BOM derivation, and the acceptance workflow gate
/// required for ElectricalReady -> TransmissionReady phase progression.
extension type ElectricalServiceClient (connect.Transport _transport) {
  /// CreateNetwork creates a new electrical network for a project layout.
  Future<electricalv1electrical.CreateNetworkResponse> createNetwork(
    electricalv1electrical.CreateNetworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.createNetwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetNetwork retrieves an electrical network by ID including review metadata.
  Future<electricalv1electrical.GetNetworkResponse> getNetwork(
    electricalv1electrical.GetNetworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.getNetwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListNetworks returns all electrical networks for a project.
  Future<electricalv1electrical.ListNetworksResponse> listNetworks(
    electricalv1electrical.ListNetworksRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.listNetworks,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteNetwork permanently removes an electrical network and all its strings.
  Future<electricalv1electrical.DeleteNetworkResponse> deleteNetwork(
    electricalv1electrical.DeleteNetworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.deleteNetwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// String operations
  Future<electricalv1electrical.CreateStringResponse> createString(
    electricalv1electrical.CreateStringRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.createString,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AutoGenerateStrings generates panel strings automatically based on inverter groups.
  Future<electricalv1electrical.AutoGenerateStringsResponse> autoGenerateStrings(
    electricalv1electrical.AutoGenerateStringsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.autoGenerateStrings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListStrings returns all strings for a network.
  Future<electricalv1electrical.ListStringsResponse> listStrings(
    electricalv1electrical.ListStringsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.listStrings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Inverter operations
  Future<electricalv1electrical.AssignInverterResponse> assignInverter(
    electricalv1electrical.AssignInverterRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.assignInverter,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListInverterGroups returns all inverter groups and their assigned strings.
  Future<electricalv1electrical.ListInverterGroupsResponse> listInverterGroups(
    electricalv1electrical.ListInverterGroupsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.listInverterGroups,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Calculations
  Future<electricalv1electrical.CalculateDCCapacityResponse> calculateDCCapacity(
    electricalv1electrical.CalculateDCCapacityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.calculateDCCapacity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateACCapacity computes total AC output capacity for the network.
  Future<electricalv1electrical.CalculateACCapacityResponse> calculateACCapacity(
    electricalv1electrical.CalculateACCapacityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.calculateACCapacity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateLosses computes cable, mismatch, and system losses for the network.
  Future<electricalv1electrical.CalculateLossesResponse> calculateLosses(
    electricalv1electrical.CalculateLossesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.calculateLosses,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ValidateSizing performs parametric sizing validation against design constraints.
  Future<electricalv1electrical.ValidateSizingResponse> validateSizing(
    electricalv1electrical.ValidateSizingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.validateSizing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ValidateNetwork performs full topology validation: all strings assigned, no orphans, MPPT limits.
  Future<electricalv1electrical.ValidateNetworkResponse> validateNetwork(
    electricalv1electrical.ValidateNetworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.validateNetwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GenerateNetworkBOM derives BOM item counts directly from the live network topology.
  Future<electricalv1electrical.GenerateNetworkBOMResponse> generateNetworkBOM(
    electricalv1electrical.GenerateNetworkBOMRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.generateNetworkBOM,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Acceptance workflow — gates the ElectricalReady -> TransmissionReady phase transition.
  /// SubmitNetworkForReview transitions review_metadata.status to REVIEW_PENDING.
  Future<electricalv1electrical.SubmitNetworkForReviewResponse> submitNetworkForReview(
    electricalv1electrical.SubmitNetworkForReviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.submitNetworkForReview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApproveNetwork sets review_metadata.status to APPROVED, enabling TransmissionReady transition.
  Future<electricalv1electrical.ApproveNetworkResponse> approveNetwork(
    electricalv1electrical.ApproveNetworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.approveNetwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RejectNetwork sets review_metadata.status to REJECTED and records blocker reasons.
  Future<electricalv1electrical.RejectNetworkResponse> rejectNetwork(
    electricalv1electrical.RejectNetworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ElectricalService.rejectNetwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
