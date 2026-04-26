/// Deep link routing configuration for Solar3D mobile app.
///
/// Supports the `solar3d://` URI scheme for direct navigation to specific
/// project artifacts from notifications, emails, or shared links.
///
/// URI patterns:
///   solar3d://project/<id>                    → project detail
///   solar3d://project/<id>/layout             → layout viewer
///   solar3d://project/<id>/simulation         → simulation results
///   solar3d://project/<id>/electrical         → electrical design
///   solar3d://project/<id>/report             → reports list
///   solar3d://project/<id>/twin               → digital twin
///   solar3d://project/<id>/qc/<checklist_id>  → QC checklist runner
///   solar3d://project/<id>/punch/<item_id>    → punch list item
///   solar3d://asset/<id>                      → asset catalog detail
///   solar3d://scan?type=qr&value=<encoded>    → barcode scan handler
library deep_links;

/// A parsed deep link with extracted route information.
class DeepLink {
  final String path;
  final Map<String, String> params;
  final Map<String, String> queryParams;

  const DeepLink({
    required this.path,
    this.params = const {},
    this.queryParams = const {},
  });
}

/// Parses a `solar3d://...` URI into a structured DeepLink.
/// Returns null if the URI is not a valid Solar3D deep link.
DeepLink? parseDeepLink(String uri) {
  Uri parsed;
  try {
    parsed = Uri.parse(uri);
  } catch (_) {
    return null;
  }
  if (parsed.scheme != 'solar3d') return null;

  final segments = parsed.pathSegments;
  if (parsed.host.isEmpty && segments.isEmpty) return null;

  // Authority becomes first path segment
  final fullPath = [if (parsed.host.isNotEmpty) parsed.host, ...segments];

  return _matchRoute(fullPath, parsed.queryParameters);
}

DeepLink? _matchRoute(List<String> path, Map<String, String> query) {
  if (path.isEmpty) return null;

  // project/<id>[/<section>[/<subId>]]
  if (path[0] == 'project' && path.length >= 2) {
    final projectId = path[1];
    if (path.length == 2) {
      return DeepLink(path: '/project/$projectId', params: {'projectId': projectId}, queryParams: query);
    }
    if (path.length == 3) {
      final section = path[2];
      const validSections = {'layout', 'simulation', 'electrical', 'report', 'twin', 'terrain', 'financial'};
      if (!validSections.contains(section)) return null;
      return DeepLink(
        path: '/project/$projectId/$section',
        params: {'projectId': projectId, 'section': section},
        queryParams: query,
      );
    }
    if (path.length == 4) {
      final section = path[2];
      final subId = path[3];
      const validSubSections = {'qc', 'punch', 'ncr', 'milestone'};
      if (!validSubSections.contains(section)) return null;
      return DeepLink(
        path: '/project/$projectId/$section/$subId',
        params: {'projectId': projectId, 'section': section, 'subId': subId},
        queryParams: query,
      );
    }
  }

  // asset/<id>
  if (path[0] == 'asset' && path.length == 2) {
    return DeepLink(path: '/asset/${path[1]}', params: {'assetId': path[1]}, queryParams: query);
  }

  // scan?type=qr&value=<...>
  if (path[0] == 'scan') {
    return DeepLink(path: '/scan', params: {}, queryParams: query);
  }

  return null;
}

/// Builds a deep link URI for sharing or notification payloads.
String buildDeepLink(String path, {Map<String, String>? queryParams}) {
  final cleanPath = path.startsWith('/') ? path.substring(1) : path;
  final uri = Uri(scheme: 'solar3d', host: '', path: cleanPath, queryParameters: queryParams);
  // Uri serialization includes // for scheme:// — strip and reformat
  return 'solar3d://$cleanPath${queryParams != null && queryParams.isNotEmpty ? '?${Uri(queryParameters: queryParams).query}' : ''}';
}
