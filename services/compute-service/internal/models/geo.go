package models

type Point2DModel struct {
	X float64 `json:"x"`
	Y float64 `json:"y"`
}

type PolygonModel struct {
	Ring []Point2DModel `json:"ring"`
}

type BufferPointRequest struct {
	Center   Point2DModel `json:"center"`
	Radius   float64      `json:"radius"`
	Segments int32        `json:"segments"`
}

type BufferPointResponse struct {
	Polygon PolygonModel `json:"polygon"`
}

type NearestPointRequest struct {
	Query      Point2DModel   `json:"query"`
	Candidates []Point2DModel `json:"candidates"`
}

type NearestPointResponse struct {
	Index    int32        `json:"index"`
	Distance float64      `json:"distance"`
	Point    Point2DModel `json:"point"`
}

type GenerateContoursRequest struct {
	Width      int32     `json:"width"`
	Height     int32     `json:"height"`
	Resolution float64   `json:"resolution"`
	OriginX    float64   `json:"origin_x"`
	OriginY    float64   `json:"origin_y"`
	NoData     float64   `json:"nodata"`
	Data       []float64 `json:"data"`
	Interval   float64   `json:"interval"`
}

type ContourLineModel struct {
	Elevation float64        `json:"elevation"`
	Points    []Point2DModel `json:"points"`
}

type GenerateContoursResponse struct {
	Contours []ContourLineModel `json:"contours"`
}

