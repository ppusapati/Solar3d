//
//  Generated code. Do not modify.
//  source: graph/v1/graph.proto
//

import "package:connectrpc/connect.dart" as connect;
import "graph.pb.dart" as graphv1graph;
import "graph.connect.spec.dart" as specs;

/// GraphService exposes graph algorithms used for layout and routing optimization.
extension type GraphServiceClient (connect.Transport _transport) {
  /// MinimumSpanningTree computes the MST over the provided weighted graph.
  Future<graphv1graph.MinimumSpanningTreeResponse> minimumSpanningTree(
    graphv1graph.MinimumSpanningTreeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.GraphService.minimumSpanningTree,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApproximateSteinerTree computes an approximate Steiner tree for terminal nodes.
  Future<graphv1graph.ApproximateSteinerTreeResponse> approximateSteinerTree(
    graphv1graph.ApproximateSteinerTreeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.GraphService.approximateSteinerTree,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
