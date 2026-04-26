//
//  Generated code. Do not modify.
//  source: twin/v1/digital_twin.proto
//

import "package:connectrpc/connect.dart" as connect;
import "digital_twin.pb.dart" as twinv1digital_twin;
import "digital_twin.connect.spec.dart" as specs;

/// DigitalTwinService manages the lifecycle of digital twins provisioned from
/// approved solar project lineage.  A twin is provisioned exactly once per
/// approved project revision; it holds operational state and links design asset
/// IDs to physical/operational identities via the AssetIdentityService.
extension type DigitalTwinServiceClient (connect.Transport _transport) {
  /// ProvisionTwin creates a new digital twin from an approved project lineage.
  /// Requires an approved project_id and the IDs of the three design artifacts
  /// (layout, electrical network, transmission route) that form the approved revision.
  Future<twinv1digital_twin.ProvisionTwinResponse> provisionTwin(
    twinv1digital_twin.ProvisionTwinRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DigitalTwinService.provisionTwin,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetTwinState retrieves the current twin including its operational state.
  /// Returns NOT_FOUND if the twin_id does not exist.
  Future<twinv1digital_twin.GetTwinStateResponse> getTwinState(
    twinv1digital_twin.GetTwinStateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DigitalTwinService.getTwinState,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateTwinState patches the mutable operational state fields (power, availability,
  /// active fault count, health score).  All other fields are immutable after provisioning.
  Future<twinv1digital_twin.UpdateTwinStateResponse> updateTwinState(
    twinv1digital_twin.UpdateTwinStateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DigitalTwinService.updateTwinState,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeprovisionTwin marks a twin as decommissioned.  Decommissioned twins are
  /// immutable; telemetry ingestion is rejected for decommissioned twins.
  Future<twinv1digital_twin.DeprovisionTwinResponse> deprovisionTwin(
    twinv1digital_twin.DeprovisionTwinRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DigitalTwinService.deprovisionTwin,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListTwinsByProject returns all twins for a project ordered by provisioned_at desc.
  Future<twinv1digital_twin.ListTwinsByProjectResponse> listTwinsByProject(
    twinv1digital_twin.ListTwinsByProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DigitalTwinService.listTwinsByProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
