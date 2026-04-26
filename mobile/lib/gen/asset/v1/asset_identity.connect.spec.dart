//
//  Generated code. Do not modify.
//  source: asset/v1/asset_identity.proto
//

import "package:connectrpc/connect.dart" as connect;
import "asset_identity.pb.dart" as assetv1asset_identity;

/// AssetIdentityService manages the linkage of design-time asset IDs (from
/// layout, electrical, and transmission services) to physical/operational asset
/// identities (manufacturer serial numbers, SCADA tags, IEC 62446-1 commissioning
/// references).  Identity records are created during the commissioning handover
/// step and consumed by TelemetryService and FaultService for event correlation.
abstract final class AssetIdentityService {
  /// Fully-qualified name of the AssetIdentityService service.
  static const name = 'asset.v1.AssetIdentityService';

  /// LinkAssetIdentity creates an identity link between a design asset and its
  /// physical installation instance.  Requires an ACTIVE twin_id.
  /// Returns ALREADY_EXISTS if a link for the same design_asset_id already exists
  /// within the same twin.
  static const linkAssetIdentity = connect.Spec(
    '/$name/LinkAssetIdentity',
    connect.StreamType.unary,
    assetv1asset_identity.LinkAssetIdentityRequest.new,
    assetv1asset_identity.LinkAssetIdentityResponse.new,
  );

  /// GetAssetIdentity returns a single identity link by its unique ID.
  static const getAssetIdentity = connect.Spec(
    '/$name/GetAssetIdentity',
    connect.StreamType.unary,
    assetv1asset_identity.GetAssetIdentityRequest.new,
    assetv1asset_identity.GetAssetIdentityResponse.new,
  );

  /// ListAssetIdentitiesByProject returns all identity links for a project across
  /// all provisioned twins, ordered by linked_at descending.
  static const listAssetIdentitiesByProject = connect.Spec(
    '/$name/ListAssetIdentitiesByProject',
    connect.StreamType.unary,
    assetv1asset_identity.ListAssetIdentitiesByProjectRequest.new,
    assetv1asset_identity.ListAssetIdentitiesByProjectResponse.new,
  );

  /// ListAssetIdentitiesByTwin returns all identity links for a specific twin,
  /// optionally filtered by design asset type.
  static const listAssetIdentitiesByTwin = connect.Spec(
    '/$name/ListAssetIdentitiesByTwin',
    connect.StreamType.unary,
    assetv1asset_identity.ListAssetIdentitiesByTwinRequest.new,
    assetv1asset_identity.ListAssetIdentitiesByTwinResponse.new,
  );

  /// UpdateAssetIdentity patches the mutable physical identity fields
  /// (physical_serial_number, installation_notes, commissioning_reference).
  /// Design asset linkage fields (design_asset_id, design_asset_type) are immutable.
  static const updateAssetIdentity = connect.Spec(
    '/$name/UpdateAssetIdentity',
    connect.StreamType.unary,
    assetv1asset_identity.UpdateAssetIdentityRequest.new,
    assetv1asset_identity.UpdateAssetIdentityResponse.new,
  );

  /// UnlinkAssetIdentity permanently removes an identity link.
  /// Records referenced by active TelemetryService readings cannot be unlinked.
  static const unlinkAssetIdentity = connect.Spec(
    '/$name/UnlinkAssetIdentity',
    connect.StreamType.unary,
    assetv1asset_identity.UnlinkAssetIdentityRequest.new,
    assetv1asset_identity.UnlinkAssetIdentityResponse.new,
  );
}
