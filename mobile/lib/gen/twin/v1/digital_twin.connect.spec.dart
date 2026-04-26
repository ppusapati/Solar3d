//
//  Generated code. Do not modify.
//  source: twin/v1/digital_twin.proto
//

import "package:connectrpc/connect.dart" as connect;
import "digital_twin.pb.dart" as twinv1digital_twin;

/// DigitalTwinService manages the lifecycle of digital twins provisioned from
/// approved solar project lineage.  A twin is provisioned exactly once per
/// approved project revision; it holds operational state and links design asset
/// IDs to physical/operational identities via the AssetIdentityService.
abstract final class DigitalTwinService {
  /// Fully-qualified name of the DigitalTwinService service.
  static const name = 'twin.v1.DigitalTwinService';

  /// ProvisionTwin creates a new digital twin from an approved project lineage.
  /// Requires an approved project_id and the IDs of the three design artifacts
  /// (layout, electrical network, transmission route) that form the approved revision.
  static const provisionTwin = connect.Spec(
    '/$name/ProvisionTwin',
    connect.StreamType.unary,
    twinv1digital_twin.ProvisionTwinRequest.new,
    twinv1digital_twin.ProvisionTwinResponse.new,
  );

  /// GetTwinState retrieves the current twin including its operational state.
  /// Returns NOT_FOUND if the twin_id does not exist.
  static const getTwinState = connect.Spec(
    '/$name/GetTwinState',
    connect.StreamType.unary,
    twinv1digital_twin.GetTwinStateRequest.new,
    twinv1digital_twin.GetTwinStateResponse.new,
  );

  /// UpdateTwinState patches the mutable operational state fields (power, availability,
  /// active fault count, health score).  All other fields are immutable after provisioning.
  static const updateTwinState = connect.Spec(
    '/$name/UpdateTwinState',
    connect.StreamType.unary,
    twinv1digital_twin.UpdateTwinStateRequest.new,
    twinv1digital_twin.UpdateTwinStateResponse.new,
  );

  /// DeprovisionTwin marks a twin as decommissioned.  Decommissioned twins are
  /// immutable; telemetry ingestion is rejected for decommissioned twins.
  static const deprovisionTwin = connect.Spec(
    '/$name/DeprovisionTwin',
    connect.StreamType.unary,
    twinv1digital_twin.DeprovisionTwinRequest.new,
    twinv1digital_twin.DeprovisionTwinResponse.new,
  );

  /// ListTwinsByProject returns all twins for a project ordered by provisioned_at desc.
  static const listTwinsByProject = connect.Spec(
    '/$name/ListTwinsByProject',
    connect.StreamType.unary,
    twinv1digital_twin.ListTwinsByProjectRequest.new,
    twinv1digital_twin.ListTwinsByProjectResponse.new,
  );
}
