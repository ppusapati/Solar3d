package pagination

// PaginationResponse is the paginated list response wrapper.
// This corresponds to the PaginationResponse message in pagination.proto.
type PaginationResponse struct {
	TotalCount int32 `json:"total_count,omitempty"`
	PageOffset int32 `json:"page_offset,omitempty"`
	PageSize   int32 `json:"page_size,omitempty"`
	HasNext    bool  `json:"has_next,omitempty"`
}

func (p *PaginationResponse) GetTotalCount() int32 {
	if p != nil {
		return p.TotalCount
	}
	return 0
}

func (p *PaginationResponse) GetPageOffset() int32 {
	if p != nil {
		return p.PageOffset
	}
	return 0
}

func (p *PaginationResponse) GetPageSize() int32 {
	if p != nil {
		return p.PageSize
	}
	return 0
}

func (p *PaginationResponse) GetHasNext() bool {
	if p != nil {
		return p.HasNext
	}
	return false
}
