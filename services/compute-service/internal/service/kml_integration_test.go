package service

import (
	"context"
	"fmt"
	"strconv"
	"testing"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

// TestKMLIntegration_EndToEnd tests complete KML upload → parse → validate → store → query flow.
func TestKMLIntegration_EndToEnd(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// Sample KML with multiple geometries
	kmlData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Integration Test</name>
    
    <Placemark>
      <name>Test Point</name>
      <description>A test point feature</description>
      <Point>
        <coordinates>-122.0822035425683,37.42228990140251,0</coordinates>
      </Point>
    </Placemark>
    
    <Placemark>
      <name>Test Route</name>
      <description>A test linestring</description>
      <LineString>
        <coordinates>
          -122.084075,37.4220033612141,0
          -122.085125,37.4220133612141,0
          -122.086125,37.4220233612141,0
        </coordinates>
      </LineString>
    </Placemark>
    
    <Placemark>
      <name>Test Area</name>
      <description>A test polygon</description>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
              -122.08223,37.42254,0
              -122.08219,37.42281,0
              -122.08244,37.42292,0
              -122.08249,37.42266,0
              -122.08223,37.42254,0
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    </Placemark>
    
  </Document>
</kml>`)

	// Step 1: Upload
	uploadJobID, err := svc.UploadKML(ctx, kmlData, "integration_test.kml", 4326, "test-project", map[string]string{
		"type": "integration_test",
	})
	if err != nil {
		t.Fatalf("Step 1 - Upload failed: %v", err)
	}

	if uploadJobID == "" {
		t.Fatal("uploadJobID is empty")
	}

	// Wait for async processing to complete
	if err := waitForUploadTerminalState(ctx, svc, uploadJobID, 3*time.Second); err != nil {
		t.Fatalf("Step 2 - Upload did not reach terminal state: %v", err)
	}

	// Step 2: Check upload status
	job, err := svc.GetUploadStatus(ctx, uploadJobID)
	if err != nil {
		t.Fatalf("Step 2 - GetUploadStatus failed: %v", err)
	}

	if job == nil {
		t.Fatal("Step 2 - Job is nil")
	}

	if job.Status == "FAILED" {
		t.Fatalf("Step 2 - Upload failed with error: %s", job.ErrorMessage)
	}

	// Step 3: List imported geometries
	geometries, totalCount, err := svc.ListImportedGeometries(ctx, uploadJobID, "", 100, 0)
	if err != nil {
		t.Fatalf("Step 3 - ListImportedGeometries failed: %v", err)
	}

	if totalCount == 0 {
		t.Fatal("Step 3 - No geometries were imported")
	}

	if totalCount != 3 {
		t.Fatalf("Step 3 - Expected 3 geometries, got %d", totalCount)
	}

	if len(geometries) != 3 {
		t.Fatalf("Step 3 - Expected 3 geometries in result, got %d", len(geometries))
	}

	// Step 4: Verify each geometry type
	geometryTypes := make(map[string]int)
	for _, geom := range geometries {
		geometryTypes[geom.GeometryType]++
		t.Logf("Imported: %s (%s)", geom.FeatureName, geom.GeometryType)
	}

	if geometryTypes["Point"] != 1 {
		t.Fatalf("Expected 1 Point, got %d", geometryTypes["Point"])
	}

	if geometryTypes["LineString"] != 1 {
		t.Fatalf("Expected 1 LineString, got %d", geometryTypes["LineString"])
	}

	if geometryTypes["Polygon"] != 1 {
		t.Fatalf("Expected 1 Polygon, got %d", geometryTypes["Polygon"])
	}

	// Step 5: Retrieve full details of each geometry
	for _, geom := range geometries {
		fullGeom, err := svc.GetImportedGeometry(ctx, geom.GeometryID)
		if err != nil {
			t.Fatalf("Step 5 - GetImportedGeometry failed for %s: %v", geom.GeometryID, err)
		}

		if fullGeom == nil {
			t.Fatalf("Step 5 - Full geometry is nil for %s", geom.GeometryID)
		}

		if fullGeom.FeatureDescription == "" && geom.GeometryType != "Point" {
			t.Logf("Step 5 - Geometry %s has no description", geom.GeometryID)
		}

		if fullGeom.BBoxMinX == fullGeom.BBoxMaxX && fullGeom.BBoxMinY == fullGeom.BBoxMaxY {
			if geom.GeometryType != "Point" {
				t.Logf("Step 5 - Warning: Non-point geometry has degenerate bbox for %s", geom.GeometryID)
			}
		}
	}

	// Step 6: Query by geometry type
	polygons, polyCount, err := svc.ListImportedGeometries(ctx, uploadJobID, "Polygon", 100, 0)
	if err != nil {
		t.Fatalf("Step 6 - FilteredList failed: %v", err)
	}

	if polyCount != 1 {
		t.Fatalf("Step 6 - Expected 1 Polygon, got %d", polyCount)
	}

	if polygons[0].FeatureName != "Test Area" {
		t.Fatalf("Step 6 - Expected 'Test Area', got '%s'", polygons[0].FeatureName)
	}

	// Step 7: Delete upload (cleanup)
	deletedCount, err := svc.DeleteUpload(ctx, uploadJobID)
	if err != nil {
		t.Fatalf("Step 7 - DeleteUpload failed: %v", err)
	}

	if deletedCount != 3 {
		t.Fatalf("Step 7 - Expected 3 geometries deleted, got %d", deletedCount)
	}

	// Step 8: Verify deletion
	_, err = svc.GetUploadStatus(ctx, uploadJobID)
	if err == nil {
		t.Logf("Step 8 - Upload job still exists after deletion (soft delete expected)")
	}
}

// TestKMLIntegration_EmptyKML tests parsing of empty KML.
func TestKMLIntegration_EmptyKML(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	kmlData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Empty</name>
  </Document>
</kml>`)

	uploadJobID, err := svc.UploadKML(ctx, kmlData, "empty.kml", 4326, "", nil)
	if err != nil {
		t.Fatalf("Upload failed: %v", err)
	}

	time.Sleep(200 * time.Millisecond)

	job, err := svc.GetUploadStatus(ctx, uploadJobID)
	if err != nil {
		t.Fatalf("GetUploadStatus failed: %v", err)
	}

	// Empty file should still complete, just with 0 geometries
	if job.Status == "FAILED" {
		t.Logf("Empty KML resulted in FAILED status: %s", job.ErrorMessage)
	}

	if job.GeometriesImported > 0 {
		t.Fatalf("Expected 0 geometries from empty KML, got %d", job.GeometriesImported)
	}
}

// TestKMLIntegration_MalformedKML tests error handling for invalid KML.
func TestKMLIntegration_MalformedKML(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	kmlData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Broken`)

	uploadJobID, err := svc.UploadKML(ctx, kmlData, "broken.kml", 4326, "", nil)
	if err != nil {
		t.Fatalf("Upload initiation failed: %v", err)
	}

	time.Sleep(200 * time.Millisecond)

	job, err := svc.GetUploadStatus(ctx, uploadJobID)
	if err != nil {
		t.Fatalf("GetUploadStatus failed: %v", err)
	}

	if job.Status != "FAILED" {
		t.Fatalf("Expected FAILED status for malformed KML, got %s", job.Status)
	}

	if job.ErrorMessage == "" {
		t.Fatal("Expected error message for malformed KML")
	}
}

// TestKMLIntegration_DuplicateUpload tests duplicate file detection via hash.
func TestKMLIntegration_DuplicateUpload(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	kmlData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>
    <Placemark>
      <name>Point</name>
      <Point><coordinates>0,0,0</coordinates></Point>
    </Placemark>
  </Document>
</kml>`)

	// First upload
	uploadID1, err := svc.UploadKML(ctx, kmlData, "test.kml", 4326, "", nil)
	if err != nil {
		t.Fatalf("First upload failed: %v", err)
	}

	job1, _ := repo.GetUploadJob(ctx, uploadID1)
	hash1 := job1.FileHash

	// Second upload with same data
	uploadID2, err := svc.UploadKML(ctx, kmlData, "test_copy.kml", 4326, "", nil)
	if err != nil {
		t.Fatalf("Second upload failed: %v", err)
	}

	job2, _ := repo.GetUploadJob(ctx, uploadID2)
	hash2 := job2.FileHash

	// Hashes should match for identical data
	if hash1 != hash2 {
		t.Fatal("Identical files should produce same hash")
	}

	t.Logf("Successfully detected duplicate file via hash: %s", hash1)
}

// TestKMLIntegration_LargeFeatureCount tests handling of documents with many features.
func TestKMLIntegration_LargeFeatureCount(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// Generate KML with 100 points
	kmlData := buildKMLWithNPoints(100)

	uploadJobID, err := svc.UploadKML(ctx, kmlData, "large.kml", 4326, "", nil)
	if err != nil {
		t.Fatalf("Upload failed: %v", err)
	}

	if err := waitForUploadTerminalState(ctx, svc, uploadJobID, 5*time.Second); err != nil {
		t.Fatalf("Large feature upload did not reach terminal state: %v", err)
	}

	geometries, count, err := svc.ListImportedGeometries(ctx, uploadJobID, "", 200, 0)
	if err != nil {
		t.Fatalf("ListImportedGeometries failed: %v", err)
	}

	if count != 100 {
		t.Fatalf("Expected 100 geometries, got %d", count)
	}

	if len(geometries) != 100 {
		t.Fatalf("Expected 100 in result, got %d", len(geometries))
	}
}

// Helper function to build KML with N points
func buildKMLWithNPoints(n int) []byte {
	kml := `<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2"><Document><name>Large</name>`

	for i := 0; i < n; i++ {
		x := float64(i%10) * 10.0
		y := float64(i/10) * 10.0
		kml += `<Placemark><name>Point ` + strconv.Itoa(i) + `</name><Point><coordinates>` +
			fmt.Sprintf("%.6f", x) + `,` + fmt.Sprintf("%.6f", y) + `,0</coordinates></Point></Placemark>`
	}

	kml += `</Document></kml>`
	return []byte(kml)
}

func waitForUploadTerminalState(ctx context.Context, svc *KMLService, uploadJobID string, timeout time.Duration) error {
	deadline := time.Now().Add(timeout)
	for time.Now().Before(deadline) {
		job, err := svc.GetUploadStatus(ctx, uploadJobID)
		if err != nil {
			return err
		}

		if job.Status == "COMPLETED" {
			return nil
		}
		if job.Status == "FAILED" {
			if job.ErrorMessage != "" {
				return fmt.Errorf("%s", job.ErrorMessage)
			}
			return fmt.Errorf("upload failed")
		}

		time.Sleep(50 * time.Millisecond)
	}

	return fmt.Errorf("timeout waiting for upload to complete")
}
