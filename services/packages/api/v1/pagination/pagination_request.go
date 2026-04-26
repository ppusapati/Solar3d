package pagination

// PaginationRequest is the paginated list request wrapper.
// This corresponds to the PaginationRequest message in pagination.proto.
//
// TODO: When the real proto is regenerated, this handwritten shim can be
// replaced with the generated type.
type PaginationRequest struct {
	PageOffset int32  `json:"page_offset,omitempty"`
	PageSize   int32  `json:"page_size,omitempty"`
	SortBy     string `json:"sort_by,omitempty"`
	SortOrder  string `json:"sort_order,omitempty"`
}

func (p *PaginationRequest) GetPageOffset() int32 {
	if p != nil {
		return p.PageOffset
	}
	return 0
}

func (p *PaginationRequest) GetPageSize() int32 {
	if p != nil {
		return p.PageSize
	}
	return 0
}

func (p *PaginationRequest) GetSortBy() string {
	if p != nil {
		return p.SortBy
	}
	return ""
}

func (p *PaginationRequest) GetSortOrder() string {
	if p != nil {
		return p.SortOrder
	}
	return ""
}
