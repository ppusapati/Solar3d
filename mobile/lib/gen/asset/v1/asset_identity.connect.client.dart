//
//  Generated code. Do not modify.
//  source: asset/v1/asset_identity.proto
//

import "package:connectrpc/connect.dart" as connect;
import "asset_identity.pb.dart" as assetv1asset_identity;
import "asset_identity.connect.spec.dart" as specs;

/// AssetIdentityService manages the linkage of design-time asset IDs (from
/// layout, electrical, and transmission services) to physical/operational asset
/// identities (manufacturer serial numbers, SCADA tags, IEC 62446-1 commissioning
/// references).  Identity records are created during the commissioning handover
/// step and consumed by TelemetryService and FaultService for event correlation.
extension type AssetIdentityServiceClient (connect.Transport _transport) {
  /// LinkAssetIdentity creates an identity link between a design asset and its
  /// physical installation instance.  Requires an ACTIVE twin_id.
  /// Returns ALREADY_EXISTS if a link for the same design_asset_id already exists
  /// within the same twin.
  Future<assetv1asset_identity.LinkAssetIdentityResponse> linkAssetIdentity(
    assetv1asset_identity.LinkAssetIdentityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetIdentityService.linkAssetIdentity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetAssetIdentity returns a single identity link by its unique ID.
  Future<assetv1asset_identity.GetAssetIdentityResponse> getAssetIdentity(
    assetv1asset_identity.GetAssetIdentityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetIdentityService.getAssetIdentity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListAssetIdentitiesByProject returns all identity links for a project across
  /// all provisioned twins, ordered by linked_at descending.
  Future<assetv1asset_identity.ListAssetIdentitiesByProjectResponse> listAssetIdentitiesByProject(
    assetv1asset_identity.ListAssetIdentitiesByProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetIdentityService.listAssetIdentitiesByProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListAssetIdentitiesByTwin returns all identity links for a specific twin,
  /// optionally filtered by design asset type.
  Future<assetv1asset_identity.ListAssetIdentitiesByTwinResponse> listAssetIdentitiesByTwin(
    assetv1asset_identity.ListAssetIdentitiesByTwinRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetIdentityService.listAssetIdentitiesByTwin,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateAssetIdentity patches the mutable physical identity fields
  /// (physical_serial_number, installation_notes, commissioning_reference).
  /// Design asset linkage fields (design_asset_id, design_asset_type) are immutable.
  Future<assetv1asset_identity.UpdateAssetIdentityResponse> updateAssetIdentity(
    assetv1asset_identity.UpdateAssetIdentityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetIdentityService.updateAssetIdentity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UnlinkAssetIdentity permanently removes an identity link.
  /// Records referenced by active TelemetryService readings cannot be unlinked.
  Future<assetv1asset_identity.UnlinkAssetIdentityResponse> unlinkAssetIdentity(
    assetv1asset_identity.UnlinkAssetIdentityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetIdentityService.unlinkAssetIdentity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
