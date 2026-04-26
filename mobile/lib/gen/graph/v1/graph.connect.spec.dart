//
//  Generated code. Do not modify.
//  source: graph/v1/graph.proto
//

import "package:connectrpc/connect.dart" as connect;
import "graph.pb.dart" as graphv1graph;

/// GraphService exposes graph algorithms used for layout and routing optimization.
abstract final class GraphService {
  /// Fully-qualified name of the GraphService service.
  static const name = 'graph.v1.GraphService';

  /// MinimumSpanningTree computes the MST over the provided weighted graph.
  static const minimumSpanningTree = connect.Spec(
    '/$name/MinimumSpanningTree',
    connect.StreamType.unary,
    graphv1graph.MinimumSpanningTreeRequest.new,
    graphv1graph.MinimumSpanningTreeResponse.new,
  );

  /// ApproximateSteinerTree computes an approximate Steiner tree for terminal nodes.
  static const approximateSteinerTree = connect.Spec(
    '/$name/ApproximateSteinerTree',
    connect.StreamType.unary,
    graphv1graph.ApproximateSteinerTreeRequest.new,
    graphv1graph.ApproximateSteinerTreeResponse.new,
  );
}
