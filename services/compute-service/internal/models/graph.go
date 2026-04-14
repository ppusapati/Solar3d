package models

type GraphEdgeModel struct {
	U      int32   `json:"u"`
	V      int32   `json:"v"`
	Weight float64 `json:"weight"`
}

type MinimumSpanningTreeRequest struct {
	NodeCount int32            `json:"node_count"`
	Edges     []GraphEdgeModel `json:"edges"`
}

type MinimumSpanningTreeResponse struct {
	Edges []GraphEdgeModel `json:"edges"`
}

type ApproximateSteinerTreeRequest struct {
	NodeCount int32            `json:"node_count"`
	Edges     []GraphEdgeModel `json:"edges"`
	Terminals []int32          `json:"terminals"`
}

type ApproximateSteinerTreeResponse struct {
	Edges []GraphEdgeModel `json:"edges"`
}

