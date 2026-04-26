package export

import (
	"fmt"
	"io"
	"strings"
	"time"
)

// ========================================================================
// IFC (BIM) Export
// ========================================================================
// Generates IFC 4 (ISO 16739-1:2018) STEP file for construction handover.
// The export represents the PV array as IfcBuildingElementProxy entities
// with attached property sets for electrical parameters.

// IFCPanel represents a single PV module for IFC export.
type IFCPanel struct {
	ID           string
	Name         string
	Model        string
	Manufacturer string
	X            float64 // local coords (m)
	Y            float64
	Z            float64
	Tilt         float64 // degrees
	Azimuth      float64 // degrees
	Width        float64 // m
	Height       float64 // m
	PowerW       float64
}

// IFCProject holds the project envelope for IFC generation.
type IFCProject struct {
	ProjectName  string
	Author       string
	Organization string
	Latitude     float64
	Longitude    float64
	Panels       []IFCPanel
}

// WriteIFC generates a minimal IFC 4 STEP file.
// This is a simplified generator that covers the geometry and property sets
// needed for construction coordination. For full BIM round-trip, use
// IfcOpenShell or similar libraries.
func (p *IFCProject) WriteIFC(w io.Writer) error {
	var sb strings.Builder
	now := time.Now().UTC()

	// STEP header
	sb.WriteString("ISO-10303-21;\n")
	sb.WriteString("HEADER;\n")
	sb.WriteString(fmt.Sprintf("FILE_DESCRIPTION(('Solar3D IFC Export'),'2;1');\n"))
	sb.WriteString(fmt.Sprintf("FILE_NAME('%s.ifc','%s',('%s'),('%s'),'Solar3D','Solar3D Export','');\n",
		p.ProjectName, now.Format("2006-01-02T15:04:05"), p.Author, p.Organization))
	sb.WriteString("FILE_SCHEMA(('IFC4'));\n")
	sb.WriteString("ENDSEC;\n\n")

	sb.WriteString("DATA;\n")
	entityID := 1

	// IfcProject
	projectID := entityID
	sb.WriteString(fmt.Sprintf("#%d=IFCPROJECT('%s',$,'%s',$,$,$,$,$,#%d);\n",
		entityID, generateGUID(), p.ProjectName, entityID+1))
	entityID++

	// Units
	unitsID := entityID
	sb.WriteString(fmt.Sprintf("#%d=IFCUNITASSIGNMENT((#%d,#%d,#%d));\n",
		entityID, entityID+1, entityID+2, entityID+3))
	entityID++
	sb.WriteString(fmt.Sprintf("#%d=IFCSIUNIT(*,.LENGTHUNIT.,$,.METRE.);\n", entityID))
	entityID++
	sb.WriteString(fmt.Sprintf("#%d=IFCSIUNIT(*,.AREAUNIT.,$,.SQUARE_METRE.);\n", entityID))
	entityID++
	sb.WriteString(fmt.Sprintf("#%d=IFCSIUNIT(*,.VOLUMEUNIT.,$,.CUBIC_METRE.);\n", entityID))
	entityID++

	// IfcSite
	siteID := entityID
	sb.WriteString(fmt.Sprintf("#%d=IFCSITE('%s',$,'Site',$,$,$,$,$,.ELEMENT.,(%d,%d,0,0),(%d,%d,0,0),0.,$,$);\n",
		entityID, generateGUID(),
		int(p.Latitude), int((p.Latitude-float64(int(p.Latitude)))*60*10000),
		int(p.Longitude), int((p.Longitude-float64(int(p.Longitude)))*60*10000)))
	entityID++

	// IfcBuilding (required by IFC schema)
	buildingID := entityID
	sb.WriteString(fmt.Sprintf("#%d=IFCBUILDING('%s',$,'PV Array',$,$,$,$,$,.ELEMENT.,$,$,$);\n",
		entityID, generateGUID()))
	entityID++

	// IfcBuildingStorey
	storeyID := entityID
	sb.WriteString(fmt.Sprintf("#%d=IFCBUILDINGSTOREY('%s',$,'Ground Level',$,$,$,$,$,.ELEMENT.,0.);\n",
		entityID, generateGUID()))
	entityID++

	// Panels as IfcBuildingElementProxy
	for _, panel := range p.Panels {
		// Placement
		placementID := entityID
		sb.WriteString(fmt.Sprintf("#%d=IFCLOCALPLACEMENT($,#%d);\n", entityID, entityID+1))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCAXIS2PLACEMENT3D(#%d,$,$);\n", entityID, entityID+1))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCCARTESIANPOINT((%.3f,%.3f,%.3f));\n", entityID, panel.X, panel.Y, panel.Z))
		entityID++

		// Shape (simplified box)
		shapeID := entityID
		sb.WriteString(fmt.Sprintf("#%d=IFCSHAPEREPRESENTATION(#%d,'Body','SweptSolid',(#%d));\n",
			entityID, entityID+1, entityID+2))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCGEOMETRICREPRESENTATIONCONTEXT($,'Model',3,1.E-5,#%d,$);\n",
			entityID, entityID+1))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCAXIS2PLACEMENT3D(#%d,$,$);\n", entityID, entityID+1))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCCARTESIANPOINT((0.,0.,0.));\n", entityID))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCEXTRUDEDAREASOLID(#%d,#%d,#%d,0.035);\n",
			entityID, entityID+1, entityID+2, entityID+3))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCRECTANGLEPROFILEDEF(.AREA.,$,#%d,%.3f,%.3f);\n",
			entityID, entityID+1, panel.Width, panel.Height))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCAXIS2PLACEMENT2D(#%d,$);\n", entityID, entityID+1))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCCARTESIANPOINT((0.,0.));\n", entityID))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCAXIS2PLACEMENT3D(#%d,$,$);\n", entityID, entityID+1))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCCARTESIANPOINT((0.,0.,0.));\n", entityID))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCDIRECTION((0.,0.,1.));\n", entityID))
		entityID++

		// Product definition shape
		pdsID := entityID
		sb.WriteString(fmt.Sprintf("#%d=IFCPRODUCTDEFINITIONSHAPE($,$,(#%d));\n", entityID, shapeID))
		entityID++

		// The panel entity
		sb.WriteString(fmt.Sprintf("#%d=IFCBUILDINGELEMENTPROXY('%s',$,'%s','%s %s',$,#%d,#%d,$,$);\n",
			entityID, generateGUID(), panel.Name, panel.Manufacturer, panel.Model,
			placementID, pdsID))
		entityID++

		// Property set
		sb.WriteString(fmt.Sprintf("#%d=IFCPROPERTYSET('%s',$,'Pset_SolarPanel','PV module properties',(#%d,#%d,#%d));\n",
			entityID, generateGUID(), entityID+1, entityID+2, entityID+3))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCPROPERTYSINGLEVALUE('Power_W',$,IFCPOWERMEASURE(%.1f),$);\n", entityID, panel.PowerW))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCPROPERTYSINGLEVALUE('Tilt_deg',$,IFCPLANEANGLEMEASURE(%.1f),$);\n", entityID, panel.Tilt))
		entityID++
		sb.WriteString(fmt.Sprintf("#%d=IFCPROPERTYSINGLEVALUE('Azimuth_deg',$,IFCPLANEANGLEMEASURE(%.1f),$);\n", entityID, panel.Azimuth))
		entityID++
	}

	// Relationships
	sb.WriteString(fmt.Sprintf("#%d=IFCRELAGGREGATES('%s',$,$,$,#%d,(#%d));\n", entityID, generateGUID(), projectID, siteID))
	entityID++
	sb.WriteString(fmt.Sprintf("#%d=IFCRELAGGREGATES('%s',$,$,$,#%d,(#%d));\n", entityID, generateGUID(), siteID, buildingID))
	entityID++
	sb.WriteString(fmt.Sprintf("#%d=IFCRELAGGREGATES('%s',$,$,$,#%d,(#%d));\n", entityID, generateGUID(), buildingID, storeyID))
	entityID++
	_ = unitsID // referenced in project

	sb.WriteString("ENDSEC;\n")
	sb.WriteString("END-ISO-10303-21;\n")

	_, err := io.WriteString(w, sb.String())
	return err
}

// generateGUID produces a simplified IFC GlobalId (22-char base64).
// In production this should be a proper IFC GUID per ISO 10303-21.
var guidCounter uint64

func generateGUID() string {
	guidCounter++
	return fmt.Sprintf("0Solar3D%013d", guidCounter)
}
