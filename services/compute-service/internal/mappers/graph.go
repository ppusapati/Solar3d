package mappers

import (
	"p9e.in/samavaya/solar3d/compute-service/internal/models"

	graphv1 "p9e.in/samavaya/solar3d/gen/graph/v1"
)

func ProtoToMinimumSpanningTree(req *graphv1.MinimumSpanningTreeRequest) *models.MinimumSpanningTreeRequest {
	if req == nil {
		return nil
	}
	edges := make([]models.GraphEdgeModel, 0, len(req.Edges))
	for _, e := range req.Edges {
		edges = append(edges, models.GraphEdgeModel{U: e.U, V: e.V, Weight: e.Weight})
	}
	return &models.MinimumSpanningTreeRequest{NodeCount: req.NodeCount, Edges: edges}
}

func MinimumSpanningTreeToProto(resp *models.MinimumSpanningTreeResponse) *graphv1.MinimumSpanningTreeResponse {
	if resp == nil {
		return &graphv1.MinimumSpanningTreeResponse{}
	}
	edges := make([]*graphv1.GraphEdge, 0, len(resp.Edges))
	for _, e := range resp.Edges {
		edges = append(edges, &graphv1.GraphEdge{U: e.U, V: e.V, Weight: e.Weight})
	}
	return &graphv1.MinimumSpanningTreeResponse{Edges: edges}
}

func ProtoToApproximateSteinerTree(req *graphv1.ApproximateSteinerTreeRequest) *models.ApproximateSteinerTreeRequest {
	if req == nil {
		return nil
	}
	edges := make([]models.GraphEdgeModel, 0, len(req.Edges))
	for _, e := range req.Edges {
		edges = append(edges, models.GraphEdgeModel{U: e.U, V: e.V, Weight: e.Weight})
	}
	return &models.ApproximateSteinerTreeRequest{
		NodeCount: req.NodeCount,
		Edges:     edges,
		Terminals: append([]int32(nil), req.Terminals...),
	}
}

func ApproximateSteinerTreeToProto(resp *models.ApproximateSteinerTreeResponse) *graphv1.ApproximateSteinerTreeResponse {
	if resp == nil {
		return &graphv1.ApproximateSteinerTreeResponse{}
	}
	edges := make([]*graphv1.GraphEdge, 0, len(resp.Edges))
	for _, e := range resp.Edges {
		edges = append(edges, &graphv1.GraphEdge{U: e.U, V: e.V, Weight: e.Weight})
	}
	return &graphv1.ApproximateSteinerTreeResponse{Edges: edges}
}

